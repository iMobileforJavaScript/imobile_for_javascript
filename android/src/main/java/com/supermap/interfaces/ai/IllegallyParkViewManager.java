package com.supermap.interfaces.ai;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Rect;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.AsyncTask;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.ai.*;
import com.supermap.containts.EventConst;
import com.supermap.interfaces.ai.illegallypark.CarColorUtil;
import com.supermap.interfaces.ai.illegallypark.ImageColor;
import com.supermap.interfaces.ai.illegallypark.QRfinderView;
import com.supermap.rnsupermap.R;
import org.opencv.android.BaseLoaderCallback;
import org.opencv.android.LoaderCallbackInterface;
import org.opencv.android.OpenCVLoader;
import org.opencv.android.Utils;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;
import pr.hyperlpr.util.DeepAssetUtil;
import pr.hyperlpr.util.DeepCarUtil;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 违章采集界面
 */
public class IllegallyParkViewManager extends SimpleViewManager<CustomFrameLayout> {

    public static final String REACT_CLASS = "RCTIllegallyParkView";
    private ThemedReactContext mReactContext = null;

    private AIDetectView mAIdetectView;
    private QRfinderView qrView;
    private List<AIRecognition> currentidentityList;
    private Vector<String> carList;
    private AIRecognition currentAiRecognition;
    private boolean isLoadOpenCVSuccess = false;
    private Bitmap bmp;
    public static long handle;
    private TextView tvCarColor;
    private TextView tvCarNum;
    private TextView tvCarType;
    private Button btnConfirm;
    private boolean isIdentiting = false;
    private boolean isStartIdentity = false;
    private SensorManager mSensorManager;
    private Sensor mSensor;
    private long statTime;

    private Thread carColorThread;
    private Thread identityCarNumberThread;

    @Override
    public String getName() {
        return REACT_CLASS;
    }


    @Override
    protected CustomFrameLayout createViewInstance(ThemedReactContext reactContext) {
        mReactContext = reactContext;

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        CustomFrameLayout frameLayout = new CustomFrameLayout(reactContext);
        frameLayout.setLayoutParams(params);

        View view = View.inflate(reactContext, R.layout.illegally_park_identity, frameLayout);


        mAIdetectView = ((AIDetectView) view.findViewById(R.id.ai_identity));
        qrView = ((QRfinderView) view.findViewById(R.id.viewfinder_view));
        tvCarColor = ((TextView) view.findViewById(R.id.tv_car_color));
        tvCarNum = ((TextView) view.findViewById(R.id.tv_car_num));
        tvCarType = ((TextView) view.findViewById(R.id.tv_car_type));
        btnConfirm = ((Button) view.findViewById(R.id.btn_confirm));
        btnConfirm.setClickable(false);
        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                btnConfirm();
            }
        });

        mSensorManager = (SensorManager) reactContext.getSystemService(Activity.SENSOR_SERVICE);
        mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);// TYPE_GRAVITY
        mSensorManager.registerListener(sensorEventListener, mSensor, SensorManager.SENSOR_DELAY_NORMAL);

        initModel();
        initOpenCV();

        SIllegallyParkView.setInstanse(mAIdetectView, mSensorManager, mSensor,
                carColorThread, sensorEventListener, identityCarNumberThread);

        return frameLayout;
    }

    private void initModel() {
        AIDetectViewInfo aidetectViewInfo = new AIDetectViewInfo();
        aidetectViewInfo.assetManager = mReactContext.getAssets();
        //模型
        aidetectViewInfo.modeFile = "detect.tflite";
        aidetectViewInfo.lableFile = "labelmap.txt";
        aidetectViewInfo.inputSize = 300;
        aidetectViewInfo.isQUANTIZED = true;
        mAIdetectView.setDetectInfo(aidetectViewInfo);
        mAIdetectView.init();
        AIDetectStyle detectStyle = new AIDetectStyle();
        detectStyle.isDrawTitle = false;
        detectStyle.isDrawConfidence = false;
        detectStyle.isSameColor = true;
        detectStyle.aiStrokeWidth = 0.01f;
        detectStyle.aiColor = Color.BLUE;
//        mAIdetectView.setAiDetectStyle(detectStyle);
        mAIdetectView.setDetectedListener(new AIDetectView.DetectListener() {
            @Override
            public void onDectetComplete(Map<String, Integer> map) {

            }

            @Override
            public void onProcessDetectResult(List<AIRecognition> list) {
                if (!isIdentiting) {
                    currentidentityList = list;
                }
            }

            @Override
            public void onTrackedCountChanged(int i) {

            }

            @Override
            public void onAISizeChanged(AISize aiSize) {
                int aiDetectWidth = aiSize.getWidth();
                int aiDerectHeight = aiSize.getHeight();
                initQRView(aiDetectWidth, aiDerectHeight);
            }
        });
        carList = new Vector<String>();
        carList.add("car");
        carList.add("motorcycle");
        carList.add("bus");
        carList.add("truck");
        mAIdetectView.setDetectArrayToUse(carList);
    }

    private void saveBitmap(Bitmap bitmap) {
        Thread saveBitmapThread = new Thread(new SaveBitmapRunnable(bitmap));
        saveBitmapThread.start();
    }


    private void initOpenCV() {
        BaseLoaderCallback mLoaderCallback = new BaseLoaderCallback(mReactContext) {
            @SuppressLint("StaticFieldLeak")
            @Override
            public void onManagerConnected(int status) {
                switch (status) {
                    case LoaderCallbackInterface.SUCCESS: {
                        Log.i(REACT_CLASS, "OpenCV loaded successfully");
                        //在加载openCV 成功后, 开始加载 hyperlpr so 文件
                        if (!isLoadOpenCVSuccess) {
                            System.loadLibrary("hyperlpr");
                            System.loadLibrary("opencv_java3");
                        }
                        new AsyncTask<Void, Void, Void>() {
                            @Override
                            protected Void doInBackground(Void... voids) {
                                handle = DeepAssetUtil.initRecognizer(mReactContext);
                                return null;
                            }

                            @Override
                            protected void onPostExecute(Void aVoid) {
                                super.onPostExecute(aVoid);
                                isStartIdentity = true;
                            }
                        }.execute();
                        isLoadOpenCVSuccess = true;
                    }
                    break;
                    default: {
                        super.onManagerConnected(status);
                    }
                    break;
                }
            }
        };
        if (!isLoadOpenCVSuccess && !OpenCVLoader.initDebug()) {
            Log.e(REACT_CLASS, "Internal OpenCV library not found. Using OpenCV Manager for initialization");
            OpenCVLoader.initDebug(true);
        } else {
            Log.d(REACT_CLASS, "OpenCV library found inside package. Using it!");
            mLoaderCallback.onManagerConnected(LoaderCallbackInterface.SUCCESS);
        }
    }

    /**
     * 初始化QR的窗体大小
     *
     * @param aiDetectWidth
     * @param aiDerectHeight
     */
    private void initQRView(int aiDetectWidth, int aiDerectHeight) {
        if (aiDerectHeight == 0 || aiDetectWidth == 0) {
            return;
        }
        int qrWidth = aiDetectWidth * 3 / 4;
        int qrHeight = aiDerectHeight * 3 / 4;

        int top = (aiDerectHeight - qrHeight) / 2;
        int left = (aiDetectWidth - qrWidth) / 2;
        int bottom = top + qrHeight;
        int right = left + qrWidth;
        Rect frame = new Rect(left, top, right, bottom);
        qrView.setFrame(frame);
        qrView.invalidate();
    }


    //确认
    public void btnConfirm() {
        mAIdetectView.pauseDetect();
        saveBitmap(bmp);
    }

    private synchronized void identityCarInfo() {
        isIdentiting = true;
        statTime = System.currentTimeMillis();
        long time1 = System.currentTimeMillis();
        final String title = parseList(currentidentityList);
        long time2 = System.currentTimeMillis();
        Log.d(REACT_CLASS, "车牌识别车辆排序时间：" + (time2 - time1));
        if (TextUtils.isEmpty(title)) {
            isIdentiting = false;
            return;
        }
        long screenTime1 = System.currentTimeMillis();
        final Bitmap bitmap = mAIdetectView.ScreenCapture();
        bmp = bitmap;
        long screenTime2 = System.currentTimeMillis();
        Log.d(REACT_CLASS, "车牌识别截屏时间：" + (screenTime2 - screenTime1));
        initIdentityCarNumber();
        initCarColor();
        initCarType(title);
    }

    private synchronized void initIdentityCarNumber() {
        if (bmp != null) {
            identityCarNumberThread  = new Thread(new Runnable() {
                @Override
                public void run() {
                    long l = System.currentTimeMillis();
                    if (bmp == null) {
                        mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                tvCarNum.setText("正在识别...");
                            }
                        });
                        return;
                    }
                    int width = bmp.getWidth();
                    int height = bmp.getHeight();
                    Mat m = new Mat(width, height, CvType.CV_8UC4);
                    Utils.bitmapToMat(bmp, m);
                    if (width > 1000 || height > 1000) {
                        Size sz = new Size(600, 800);
                        Imgproc.resize(m, m, sz);
                    }
                    String license = "";
                    try {
                        license = DeepCarUtil.SimpleRecognization(m.getNativeObjAddr(), handle);
                    } catch (Exception e) {
                        Log.e(REACT_CLASS, "exception occured!");
                        Log.e(REACT_CLASS, "车牌号码识别异常：" + e.toString());

                        mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                tvCarNum.setText("正在识别...");
                            }
                        });
                        return;
                    }
                    long l1 = System.currentTimeMillis();
                    Log.d(REACT_CLASS, "车牌号码识别时间：" + license + "," + (l1 - l));

                    final String result = license;
                    mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            isIdentiting = false;
                            //车牌识别成功，按钮能点击
                            btnConfirm.setClickable(true);
                            btnConfirm.setBackgroundResource(R.drawable.selector_confirm);
                            if (!TextUtils.isEmpty(result)) {
                                if (result.contains(",")) {
                                    String[] split = result.split(",");
                                    String s = split[0];
                                    tvCarNum.setText(s);
                                } else {
                                    tvCarNum.setText(result);
                                }
                            }
                        }
                    });

                }
            });
            identityCarNumberThread.start();
        } else {
            isIdentiting = false;
//            Toast.makeText(this, "未识别出车牌号码", Toast.LENGTH_SHORT);
        }
    }

    /**
     * 解析识别的结果
     *
     * @param list 识别集合
     */
    private synchronized String parseList(List<AIRecognition> list) {
        if (list == null || list.size() <= 0) {
            return null;
        }
        if (list.size() == 1) {
            currentAiRecognition = list.get(0);
            return currentAiRecognition.title;
        }
        ArrayList<AIRecognition> tempList = new ArrayList<AIRecognition>();
        for (AIRecognition aiRecognition : list) {
            tempList.add(aiRecognition);
        }
        Collections.sort(tempList, new Comparator<AIRecognition>() {
            @Override
            public int compare(AIRecognition aiRecognition, AIRecognition t1) {
                //降序
                return (int) (t1.detectionConfidence - aiRecognition.detectionConfidence);
            }
        });
        currentAiRecognition = tempList.get(0);
        return currentAiRecognition.title;
    }

    /**
     * 初始化车身颜色
     */
    private synchronized void initCarColor() {
        carColorThread = new Thread(new Runnable() {
            @Override
            public void run() {
                String result = "其他";
                Bitmap bitmap = screenImage();
                if (bitmap != null) {
                    try {
                        String mostCommonColour = ImageColor.getMostCommonColour(bitmap);
                        if (!TextUtils.isEmpty(mostCommonColour)) {
                            float[] hsv = ImageColor.getHsv();
                            String colorByHSV = CarColorUtil.getColorByHSV((int) hsv[0], (int) hsv[1], (int) hsv[2]);
                            result = colorByHSV;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        Log.e(REACT_CLASS, "车身颜色识别异常" + e.toString());
                        result = "其他";
                    }
                } else {
                    Log.e(REACT_CLASS, "车身颜色识别失败");
                    result = "其他";
                }

                final String text = result;
                mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        tvCarColor.setText(text);
                    }
                });
            }
        });
        carColorThread.start();
    }

    /**
     * 初始化车辆类型
     */
    private synchronized void initCarType(String carType) {
        if (TextUtils.isEmpty(carType)) {
            return;
        }
        if (carType.equals("car")) {
            tvCarType.setText("小汽车");
        } else if (carType.equals("bus")) {
            tvCarType.setText("客车");
        } else if (carType.equals("motorcycle")) {
            tvCarType.setText("摩托车");
        } else if (carType.equals("truck")) {
            tvCarType.setText("货车");
        } else {
            tvCarType.setText("其他");
        }
    }

    private class SaveBitmapRunnable implements Runnable {
        private Bitmap bitmap1;

        public SaveBitmapRunnable(Bitmap bitmap) {
            this.bitmap1 = bitmap;
        }

        @Override
        public void run() {
            String fileName = "IMG_" + new SimpleDateFormat("yyyyMMdd", Locale.CHINA).format(new Date()) + "_" + generateRandomNum(6) + ".jpg";// 照片命名
            File dir = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator + "SuperMap/photo");
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String filePath = dir.getPath() + File.separator + fileName;
            try {
                Log.d(REACT_CLASS, "Filepaht: " + filePath);
                File file = new File(filePath);
                FileOutputStream os = new FileOutputStream(file);
                bitmap1.compress(Bitmap.CompressFormat.PNG, 100, os);
                os.flush();
                os.close();
                Log.d(REACT_CLASS, "保存照片成功");
                mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit(EventConst.ILLEGALLYPARK, filePath);
                mAIdetectView.resumeDetect();
            } catch (Exception e) {
                Log.e(REACT_CLASS, "保存照片失败");
                return;
            }
        }
    }

    private Bitmap screenImage() {
        //截取识别框中图像
        float bottom = currentAiRecognition.location.bottom;
        float left = currentAiRecognition.location.left;
        float right = currentAiRecognition.location.right;
        float top = currentAiRecognition.location.top;
        int x = 0;
        int y = (int) top;
        int width = 0;
        int height = (int) (bottom - top);
        if (left <= 0) {
            x = 0;
        } else {
            x = (int) left;
        }
        if (right - left > bmp.getWidth()) {
            width = bmp.getWidth();
        } else {
            width = (int) (right - left);
        }
        if (x + width > bmp.getWidth()) {
            width = bmp.getWidth() - x;
        }
        Log.d("裁剪大小", "x:" + x + ",y:" + y + ",width:" + width + ",height:" + height + ",bitmapwidth:" + bmp.getWidth());
        Bitmap bitmap2 = Bitmap.createBitmap(bmp, x, y, width, height, null, false);
        return bitmap2;
    }

    /************************************************************************/
    //传感器 保留参数
    private float lastX = 0l;
    private float lastY = 0l;
    private float lastZ = 0l;
    public static final int DELEY_DURATION = 1000;

    public static final int STATUS_NONE = 0;
    public static final int STATUS_STATIC = 1;
    public static final int STATUS_MOVE = 2;
    private int STATUE = STATUS_NONE;

    private long lastStamp;//上一次保留的时间点

    private SensorEventListener sensorEventListener = new SensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
            if (event.sensor == null) {
                return;
            }
            if (!isStartIdentity) {
                return;
            }
            if (isIdentiting) {
                resetParam();
                return;
            }
            //判断手机是否在移动
            if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
                float x = event.values[0];
                float y = event.values[1];
                float z = event.values[2];
                Calendar mCalendar = Calendar.getInstance();
                //记录当前时间点
                long stamp = mCalendar.getTimeInMillis();
                if (STATUE != STATUS_NONE) {
                    float px = Math.abs(lastX - x);
                    float py = Math.abs(lastY - y);
                    float pz = Math.abs(lastZ - z);
                    //计算加速度差值
                    //手机处于匀速运动或者静止状态，代表一种状态
                    //xyz方向上的阈值大于0.5代表手机是在移动
                    if (px > 0.5 || py > 0.5 || pz > 0.5) {
                        STATUE = STATUS_MOVE;
                    } else {//手机停止移动
                        if (STATUE == STATUS_MOVE) {
                            //记录静止时间点
                            lastStamp = stamp;
                        }
                        //识别时间大于延迟识别时间，并且上一次状态不是静止状态
                        if (stamp - lastStamp > DELEY_DURATION) {
                            //移动后静止一段时间，开始处理
                            if (!isIdentiting) {
                                identityCarInfo();
                            }
                        }
                        STATUE = STATUS_STATIC;
                    }
                } else {
                    lastStamp = stamp;
                    STATUE = STATUS_STATIC;
                }
                lastX = x;
                lastY = y;
                lastZ = z;
            }
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {

        }
    };

    private void resetParam() {
        lastX = 0;
        lastY = 0;
        lastZ = 0;
    }

    /**
     * 生成随机字符串
     *
     * @return
     * @int 生成随机字符串的长度
     */
    public static String generateRandomNum(int length) {
        StringBuffer buf = new StringBuffer("0,1,2,3,4,5,6,7,8,9");
        String[] arr = buf.toString().split(",");
        StringBuffer b = new StringBuffer();
        java.util.Random r;
        int k;
        for (int i = 0; i < length; i++) {
            r = new java.util.Random();
            k = r.nextInt();
            b.append(String.valueOf(arr[Math.abs(k % 9)]));
        }
        return b.toString();
    }
}
