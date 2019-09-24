package com.supermap.interfaces.ai;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.facebook.react.bridge.*;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.supermap.ai.*;
import com.supermap.ar.*;
import com.supermap.rnsupermap.R;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * AI识别控制类
 */
public class SAIDetectView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SAIDetectView";

    private static Context mContext = null;
    private static AIDetectView mAIDetectView = null;
    private static AIDetectViewInfo mAidetectViewInfo;
    private static World mWorld;

    private Vector<String> mStrToUseAll = new Vector<>(); //模型文件中所有可用的模型
    private static Date mStartDate = null;//开始识别
    private static Vector<String> mStrToUse = new Vector<>(); //初始化默认设置的模型
    private static int mDetectInterval = 2000;//识别时间间隔,默认3000毫秒

    private static ArView mArView = null;//绑定的AR显示类
    private static boolean mIsPOIMode = false; //AR-POI投射模式
    private static boolean mIsPolymerize = false; //聚合模式
    private static boolean mIsPOIOverlap = false; //POI避让
    private static boolean mIsDrawTitle = false;
    private static boolean mIsDrawConfidence = false;

    private static AIDetectStyle mAiDetectStyle = null;

    private static ArObject mCurrentArObject = null;

    private static ReactApplicationContext mReactContext = null;
    private static CustomRelativeLayout mCustomRelativeLayout = null;

    private static String mLanguage = "CN";//EN

    public SAIDetectView(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
        mContext = reactContext.getApplicationContext();
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static void setInstance(AIDetectView aiDetectView) {
        Log.d(REACT_CLASS, "----------------SAIDetectView--setInstance--------RN--------");

        mAIDetectView = aiDetectView;
        mAidetectViewInfo = new AIDetectViewInfo();
        mAidetectViewInfo.assetManager = mContext.getAssets();
        prepareAiDetectViewInfo("detect.tflite", "labelmap.txt");

        mAIDetectView.init();

        mAIDetectView.setBackgroundColor(Color.parseColor("#2D2D2F"));
        mAIDetectView.setDetectInfo(mAidetectViewInfo);//设置数据

        if (mStrToUse.isEmpty()) {
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.PERSON));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.BICYCLE));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CAR));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.MOTORCYCLE));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.BUS));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.TRUCK));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CUP));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CHAIR));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.POTTEDPLANT));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.LAPTOP));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.MOUSE));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.TV));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.KEYBOARD));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.CELLPHONE));
            mStrToUse.add(AIDetectModel2.getEnglishName(AIDetectModel2.BOTTLE));
        }

        mAIDetectView.setDetectArrayToUse(mStrToUse);//设置初始模型

        mAIDetectView.setDetectedListener(mDetectListener);//设置Ai监听回调

        mAIDetectView.setDetectInterval(mDetectInterval);//设置识别时间间隔

        mAIDetectView.setPolymerize(mIsPolymerize);//是否聚合模式
        mAIDetectView.setPolymerizeThreshold(100, 100);//设置聚合模式网格宽高

        //风格
        if (mAiDetectStyle == null) {
            mAiDetectStyle = new AIDetectStyle();
            mAiDetectStyle.isDrawTitle = mIsDrawTitle;
            mAiDetectStyle.isDrawConfidence = mIsDrawConfidence;
        }
        mAIDetectView.setAIDetectStyle(mAiDetectStyle);

        mAIDetectView.startCameraPreview();
        mAIDetectView.resumeDetect();
        mAIDetectView.startCountTrackedObjs();
    }

    public static void setArView(ArView arView) {
        Log.d(REACT_CLASS, "----------------SAIDetectView--setSurfaceView--------RN--------");
        mArView = arView;
//        mArView.setBackgroundColor(Color.parseColor("#2000fSMediaCollectorf00"));

        mArView.setDistanceFactor(0.6f);
        //创建AR场景
        mWorld = CustomWorldHelper.generateMyObjects(mContext);
        mArView.setWorld(mWorld);
        //mArView.setPOIOverlapEnable(true); //POI避让
        mArView.setOnClickArObjectListener(arObjectListener);
        if (mIsPOIMode) {
            mArView.startRenderingAR();
        } else {
            mArView.stopRenderingAR();
        }
        mArView.setPOIOverlapEnable(mIsPOIOverlap);
    }

    private static OnClickArObjectListener arObjectListener = new OnClickArObjectListener() {
        @Override
        public void onClickArObject(ArrayList<ArObject> arrayList) {
//          if (!mAIDetectView.isDetect()) {
//            return;
//          }
            //POI对象点击
            mCurrentArObject = arrayList.get(0);
            Log.d(REACT_CLASS, "onClickArObject: " + mCurrentArObject.getName());

            //移除其他的Arobject
            List<ArObjectList> arObjectLists = mWorld.getArObjectLists();
            for (int i = 0; i < arObjectLists .size(); i++) {
                ArObjectList arObjects = arObjectLists.get(i);
                for (int j = 0; j < arObjects.size(); j++) {
                    ArObject arObject = arObjects.get(j);
                    if (mCurrentArObject.getId() != arObject.getId()) {
                        mWorld.remove(arObject);
                    }
                }
            }

            //向JS传递ArObject的点击事件
            WritableMap info = Arguments.createMap();
            info.putInt("id", ((int) mCurrentArObject.getId()));
            info.putString("name", mCurrentArObject.getName());
            info.putString("info", mCurrentArObject.getInfo());
            mReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                    mCustomRelativeLayout.getId(),
                    "onArObjectClick",
                    info
            );
        }
    };

    public static void setViewManager(CustomRelativeLayout relativeLayout) {
        mCustomRelativeLayout = relativeLayout;
    }

    @ReactMethod
    public void initAIDetect(String language, Promise promise){
        try{
            Log.d(REACT_CLASS, "----------------SAIDetectView--initAIDetect--------RN--------");
            mLanguage = language;

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 开始识别
     */
    @ReactMethod
    public void startDetect(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--startDetect--------RN--------");
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mAIDetectView == null) {
                            return;
                        }
                        mAIDetectView.startCameraPreview();
                        mAIDetectView.resumeDetect();//开始识别
                        mAIDetectView.startCountTrackedObjs();

                        mWorld.clearWorld();
                        mArView.startRenderingAR();
                    }
                });
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 暂停识别
     */
    @ReactMethod
    public void pauseDetect(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--pauseDetect--------RN--------");
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (mAIDetectView == null) {
                            return;
                        }
                        mAIDetectView.pauseDetect();
                        mAIDetectView.stopCountTrackedObjs();

                        mWorld.clearWorld();
                        mArView.stopRenderingAR();
                    }
                });
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 资源是否已经释放
     * @param
     */
    private boolean isDisposed() {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--isDisposed--------JAVA--------");
            if (mAIDetectView == null) {
                return true;
            }
            boolean isDisposed = false;
            int childCount = mAIDetectView.getChildCount();
            if (childCount == 0) {
                isDisposed = true;
            }
            return isDisposed;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 停止识别,回收资源
     * @param promise
     */
    @ReactMethod
    public void dispose(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--dispose--------RN--------");
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (isDisposed()) {
                            return;
                        }
                        mAIDetectView.pauseDetect();
                        mAIDetectView.stopCountTrackedObjs();
                        mAIDetectView.dispose();

                        int childCount = mAIDetectView.getChildCount();
                        Log.d(REACT_CLASS, "----------------SAIDetectView--dispose----------RN--------childCount: " + childCount);

                        mWorld.clearWorld();
                        mArView.stopRenderingAR();
                    }
                });
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 资源是否已经释放
     * @param promise
     */
    @ReactMethod
    public void isDisposed(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--dispose--------RN--------");
            if (mAIDetectView == null) {
                promise.resolve(true);
                return;
            }
            boolean isDisposed = false;
            int childCount = mAIDetectView.getChildCount();
            if (childCount == 0) {
                isDisposed = true;
            }
            promise.resolve(isDisposed);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置模型文件等信息
     * @param modelName
     * @param lableName
     * @param promise
     */
    @ReactMethod
    public void setDetectInfo(String modelName, String lableName, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setDetectInfo--------RN--------");
            prepareAiDetectViewInfo(modelName, lableName);
            mAIDetectView.setDetectInfo(mAidetectViewInfo);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置识别类型
     * @param array
     * @param promise
     */
    @ReactMethod
    public void setDetectArrayToUse(ReadableArray array, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setDetectArrayToUse--------RN--------");
            Vector<String> arrayToUse = new Vector<>();
            for (int i = 0; i < array.size(); i++) {
                String lableName = array.getString(i);
                arrayToUse.add(lableName);
            }
            mAIDetectView.setDetectArrayToUse(arrayToUse);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 是否正在识别
     * @param promise
     */
    @ReactMethod
    public void isDetect(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--isDetect--------RN--------");
            if (mAIDetectView == null) {
                promise.resolve(false);
                return;
            }
            boolean detect = mAIDetectView.isDetect();

            promise.resolve(detect);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取当前设置的识别类型
     * @param promise
     */
    @ReactMethod
    public void getDetectArrayToUse(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--getDetectArrayToUse--------RN--------");
            Vector<String> detectArrayToUse = mAIDetectView.getDetectArrayToUse();

            ArrayList<String> list = new ArrayList<>();
            for (int i = 0; i < detectArrayToUse.size(); i++) {
                list.add(AIDetectModel2.getChineseName(detectArrayToUse.get(i)));
            }

            WritableArray array = Arguments.createArray();
            for (int i = 0; i < list.size(); i++) {
                array.pushString(list.get(i));
            }

            promise.resolve(array);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取所有可用的识别分类
     * @param promise
     */
    @ReactMethod
    public void getAllDetectArrayProvide(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--getAllDetectArrayProvide--------RN--------");
            Vector<String> detectArrayToUse = mAIDetectView.getAllDetectArrayProvide();

            WritableArray array = Arguments.createArray();
            for (int i = 0; i < detectArrayToUse.size(); i++) {
                array.pushString(detectArrayToUse.get(i));
            }

            promise.resolve(array);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除识别对象
     * @param promise
     */
    @ReactMethod
    public void clearDetectObjects(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--clearDetectObjects--------RN--------");
            mAIDetectView.clearDetectObjects();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置是否聚合模式(态势检测)
     * @param promise
     */
    @ReactMethod
    public void setIsPolymerize(boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setisPolymerize--------RN--------");
            mAIDetectView.setPolymerize(value);
            mIsPolymerize = value;

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回是否聚合模式
     * @param promise
     */
    @ReactMethod
    public void isPolymerize(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--isPolynerize--------RN--------");
            boolean polymerize = mAIDetectView.isPolymerize();

            promise.resolve(mIsPolymerize);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置聚合模式阀值
     * @param promise
     */
    @ReactMethod
    public void setPolymerizeThreshold(int x, int y, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setPolymerizeThreshold--------RN--------");
            mAIDetectView.setPolymerizeThreshold(x, y);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置聚合模式宽高
     * @param promise
     */
    @ReactMethod
    public void setPolySize(int width, int height, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setPolySize--------RN--------");
            AISize aiSize = new AISize(width, height);
            mAIDetectView.setPolySize(aiSize);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取当前跟踪计数结果
     * @param promise
     */
    @ReactMethod
    public void getTrackedCount(int width, int height, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--getTrackedCount--------RN--------");
            int trackedCount = mAIDetectView.getTrackedCount();

            promise.resolve(trackedCount);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 重置跟踪计数结果
     * @param promise
     */
    @ReactMethod
    public void resetTrackedCount(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--resetTrackedCount--------RN--------");
            mAIDetectView.resetTrackedCount();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 开始跟踪计数
     * @param promise
     */
    @ReactMethod
    public void startCountTrackedObjs(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--startCountTrackedObjs--------RN--------");
            mAIDetectView.startCountTrackedObjs();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 停止跟踪计数
     * @param promise
     */
    @ReactMethod
    public void stopCountTrackedObjs(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--stopCountTrackedObjs--------RN--------");
            mAIDetectView.stopCountTrackedObjs();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存预览图片
     * @param
     */
    public static void saveArPreviewBitmap(final String pictureDirectory, final String fileName) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--savePreviewBitmap--------RN--------");
            Bitmap previewBitmap = mAIDetectView.getPreviewBitmap();

            saveBitmapAsFile(pictureDirectory, fileName, previewBitmap);
        } catch (Exception e) {
            Log.d(REACT_CLASS, e.getMessage());
        }
    }

    /**
     * 保存预览图片
     * @param promise
     */
    @ReactMethod
    public void savePreviewBitmap(final String pictureDirectory, final String fileName, Promise promise) {
        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    Log.d(REACT_CLASS, "----------------SAIDetectView--savePreviewBitmap--------RN--------");
                    Bitmap previewBitmap = mAIDetectView.getPreviewBitmap();

                    saveBitmapAsFile(pictureDirectory, fileName, previewBitmap);
                }
            }).start();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存截屏(预览图片+识别绘制框)
     * @param promise
     */
    @ReactMethod
    public void saveScreenCapture(final String pictureDirectory, final String fileName, Promise promise) {
        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    Log.d(REACT_CLASS, "----------------SAIDetectView--saveScreenCapture--------RN--------");
                    Bitmap screenCapture = mAIDetectView.getScreenCapture();

                    saveBitmapAsFile(pictureDirectory, fileName, screenCapture);
                }
            }).start();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 投射模式
     * @param promise
     */
    @ReactMethod
    public void setProjectionModeEnable(final boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setProjectionModeEnable--------RN--------");
            if (value) {
                mArView.startRenderingAR();
            } else {
                mArView.stopRenderingAR();
            }
            mIsPOIMode = value;
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 投射模式
     * @param promise
     */
    @ReactMethod
    public void isProjectionModeEnable(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--isProjectionModeEnable--------RN--------");
            promise.resolve(mIsPOIMode);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 避让模式
     * @param promise
     */
    @ReactMethod
    public void setPOIOverlapEnable(boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setPOIOverlapEnable--------RN--------");

            mArView.setPOIOverlapEnable(value);
            mIsPOIOverlap = value;

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 是否避让模式
     * @param promise
     */
    @ReactMethod
    public void isPOIOverlapEnable(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--isPOIOverlapEnable--------RN--------");
            promise.resolve(mIsPOIOverlap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置单个识别类型是否可用
     * @param promise
     */
    @ReactMethod
    public void setDetectItemEnable(final String name, final boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setDetectItemEnable--------RN--------");
            String englishName = AIDetectModel2.getEnglishName(name);

            if (value) {
                if (!mStrToUse.contains(englishName)) {
                    mStrToUse.add(englishName);
                }
            } else {
                if (mStrToUse.contains(englishName)) {
                    mStrToUse.remove(englishName);
                }
            }
            mAIDetectView.setDetectArrayToUse(mStrToUse);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置识别框是否绘制检测名称
     * @param promise
     */
    @ReactMethod
    public void setDrawTileEnable(boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setDrawTileEnable--------RN--------");

            mIsDrawTitle = value;
            mAiDetectStyle.isDrawTitle = value;
            mAIDetectView.setAIDetectStyle(mAiDetectStyle);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置识别框是否绘制检测名称
     * @param promise
     */
    @ReactMethod
    public void isDrawTileEnable(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--isDrawTileEnable--------RN--------");

            promise.resolve(mAiDetectStyle.isDrawTitle);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置识别框是否绘制可信度
     * @param promise
     */
    @ReactMethod
    public void setDrawConfidenceEnable(boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setDrawConfidenceEnable--------RN--------");

            mIsDrawConfidence = value;
            mAiDetectStyle.isDrawConfidence = value;
            mAIDetectView.setAIDetectStyle(mAiDetectStyle);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
      * 设置识别框是否绘制可信度
     * @param promise
     */
    @ReactMethod
    public void isDrawConfidenceEnable(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--isDrawConfidenceEnable--------RN--------");

            promise.resolve(mAiDetectStyle.isDrawConfidence);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置识别框是否绘制统一颜色
     * @param promise
     */
    @ReactMethod
    public void setSameColorEnable(final boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setSameColorEnable--------RN--------");

            mAiDetectStyle.isSameColor = value;
            mAIDetectView.setAIDetectStyle(mAiDetectStyle);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置识别框的统一颜色
     * @param promise
     */
    @ReactMethod
    public void setSameColor(final String value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setSameColor--------RN--------");

            mAiDetectStyle.aiColor = Color.parseColor(value);
            mAIDetectView.setAIDetectStyle(mAiDetectStyle);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置识别框的线宽
     * @param promise
     */
    @ReactMethod
    public void setStrokeWidth(final float value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setStrokeWidth--------RN--------");

            mAiDetectStyle.aiStrokeWidth = value;
            mAIDetectView.setAIDetectStyle(mAiDetectStyle);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * ARView是否可用
     * @param promise
     */
    @ReactMethod
    public void checkIfSensorsAvailable(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--checkIfSensorsAvailable--------RN--------");
            PackageManager packageManager = mContext.getPackageManager();
            boolean compass = packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_COMPASS);
            boolean accelerometer = packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_ACCELEROMETER);
            Log.e(REACT_CLASS, "checkIfSensorsAvailable: " + (compass && accelerometer));

            promise.resolve(compass && accelerometer);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    //*******************************************************************************************************//
    private static void prepareAiDetectViewInfo(String modelName, String lableName) {
        mAidetectViewInfo.modeFile = modelName;
        mAidetectViewInfo.lableFile = lableName;
        mAidetectViewInfo.inputSize = 300;
        mAidetectViewInfo.isQuantized = true;
    }

    //毫秒
    private static int calLastedTime(Date startDate) {
        long a = new Date().getTime();
        long b = startDate.getTime();
        int c = (int) (a - b);
        return c;
    }

    //保存bitmap为图片
    private static boolean saveBitmapAsFile(String folderPath, String name, Bitmap bitmap) {
        if (!new File(folderPath).exists()) {
            new File(folderPath).mkdirs();
        }
        if (bitmap == null || bitmap.isRecycled()) {
            return false;
        }
        File saveFile = new File(folderPath, name + ".jpg");

        boolean saved = false;
        FileOutputStream os = null;
        try {
            Log.d("FileCache", "Saving File To Cache " + saveFile.getPath());
            os = new FileOutputStream(saveFile);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
            os.flush();
            os.close();
            saved = true;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return saved;
    }

    private static AIDetectView.DetectListener mDetectListener = new AIDetectView.DetectListener() {
        @Override
        public void onDectetComplete(Map<String, Integer> result) {
            //流量统计
            Log.d("DetectListener", "-----------onDectetComplete-----------: " + result.size());
//            for (Map.Entry<String, Integer> entry : result.entrySet()) {
//                Log.d("onDectetComplete:", entry.getKey() + "  value:" + entry.getValue());
//            }
        }

        @Override
        public void onProcessDetectResult(List<AIRecognition> recognitions) {
//            Log.d("DetectListener", "-----------onProcessDetectResult-----------");
            if (!mAIDetectView.isDetect()) {
                //停止识别状态
                return;
            }
            //识别结果(3秒间隔)
            boolean isCreated = false;//重新识别
            if (mStartDate == null) {
                isCreated = true;
            } else if (mIsPOIMode && calLastedTime(mStartDate) >= mDetectInterval) {
                isCreated = true;
            } else if (mIsPOIMode && calLastedTime(mStartDate) < mDetectInterval) {
                isCreated = false;
            } else {
                isCreated = false;
            }

            if (isCreated) {
                //重新识别
                Log.d("DetectListener", "onProcessDetectResult--重新识别--: "  + recognitions.size());
                mStartDate = new Date();
                mWorld.clearWorld();

                //创建POI对象
                if (mArView != null) {
                    generateArObject(recognitions);
                }
            }
        }

        @Override
        public void onTrackedCountChanged(int i) {
            Log.d("DetectListener", "-----------onTrackedCountChanged-----------:" + i);
        }

        @Override
        public void onAISizeChanged(AISize aiSize) {

        }
    };

    private static void generateArObject(List<AIRecognition> recognitions) {
        for (int i = 0; i < recognitions.size(); i++) {
            AIRecognition recognition = recognitions.get(i);
            AIDetectModel2 modelType = AIDetectModel2.getModelType(recognition.title);
            createScreenCoordPoi((int) (recognition.location.left + recognition.location.right) / 2,
                    (int) (recognition.location.top + recognition.location.bottom) / 2, modelType, recognition.trackedID);
        }
    }

    private static void createScreenCoordPoi(int x, int y, AIDetectModel2 type, int trackID) {
        Point3D point = mArView.getIntersectionPoint(x, y);
        if (point != null) {
            GeoObject tempArObject = new GeoObject(System.currentTimeMillis());
            tempArObject.setGeoPosition(mWorld.getLatitude() + point.y,
                    mWorld.getLongitude() + point.x,
                    mWorld.getAltitude() + point.z);

            if (type != null) {
                tempArObject.setName("" + System.currentTimeMillis() + "_" + type.toString());
            } else {
                tempArObject.setName("" + System.currentTimeMillis());
            }
            tempArObject.setInfo(AIDetectModel2.getChineseName(type));
            DecimalFormat df = new DecimalFormat("0.00");
            tempArObject.setDistanceFromUser(Double.parseDouble(df.format(20)));//添加距离信息
            updateImagesByStaticView(tempArObject, type);

            mWorld.addArObject(tempArObject);
        }
    }

    private static String getCurrentTime() {
        //得到long类型当前时间
        long l = System.currentTimeMillis();
        //new日期对
        Date date = new Date(l);
        //转换提日期输出格式
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA);
//        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss_ms", Locale.CHINA);

        return dateFormat.format(date);
    }

    private static void updateImagesByStaticView(ArObject arObject, AIDetectModel2 type) {
        LayoutInflater layoutInflater = LayoutInflater.from(mContext);
        if (layoutInflater != null) {
            View view = layoutInflater.inflate(R.layout.ar_object_view_wrapcontent, null);
            TextView tv_name = view.findViewById(R.id.tv_name);
            TextView tv_address = view.findViewById(R.id.tv_address);

            ImageView imageView = view.findViewById(R.id.ai_ar_content);
            TextView info = view.findViewById(R.id.info);
            TextView address = view.findViewById(R.id.address);

            if (mLanguage.equals("CN")) {
                tv_name.setText("类别:");
                tv_address.setText("时间:");
                info.setText(AIDetectModel2.getChineseName(type));
            } else {
                tv_name.setText("Type:");
                tv_address.setText("Time:");
                info.setText(AIDetectModel2.getEnglishName(type));
            }

//            address.setText("未知定位,请检查网络或者GPS.");
            address.setText(getCurrentTime());

            Bitmap bitmap = getBitmapByType(type);
            imageView.setImageBitmap(bitmap);

            mArView.storeArObjectViewAndUri(view, arObject);
        }
    }

    //create ARObject
    private static Bitmap getBitmapByType(AIDetectModel2 type) {
        Bitmap bitmap = null;
        switch (type) {
            case PERSON:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.person_type);
                break;
            case BICYCLE:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.bicycle_type);
                break;
            case CAR:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.car_type);
                break;
            case MOTORCYCLE:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.motorcycle_type);
                break;
            case BUS:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.bus_type);
                break;

            case TRUCK:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.truck_type);
                break;
            case TRAFFICLIGHT:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.traffic_light_type);
                break;
            case FIREHYDRANT:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.fire_hydrant_type);
                break;
            case BIRD:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.bird_type);
                break;
            case CAT:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.cat_type);
                break;

            case DOG:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.dog_type);
                break;
            case POTTEDPLANT:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.potted_plant_type);
                break;
            case TV:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.tv_type);
                break;
            case LAPTOP:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.laptop_type);
                break;
            case MOUSE:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.mouse_type);
                break;

            case KEYBOARD:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.keyboard_type);
                break;
            case CELLPHONE:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.cellphone_type);
                break;
            case BOOK:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.book_type);
                break;

            case CUP:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.cup_type);
                break;
            case CHAIR:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.chair_type);
                break;
            case BOTTLE:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.bottles);
                break;
            default:
                bitmap = BitmapFactory.decodeResource(mContext.getResources(), R.drawable.aitype);
                break;
        }
        return bitmap;
    }

}
