package com.supermap.interfaces.ai;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.support.annotation.Nullable;
import android.util.Log;
import android.widget.ImageView;
import com.facebook.react.bridge.*;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.ai.classifier.Classifier2;
import com.supermap.ai.classifier.TensorFlowImageClassifier;
import com.supermap.data.*;
import com.supermap.interfaces.ar.POIInfo;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.MapControl;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMThemeCartography;
import com.wonderkiln.camerakit.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class SAIClassifyView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SAIClassifyView";

    private static String MODEL_NAME = "mobilenet_v1_1.0_224_quant.tflite";
    private static String LABEL_NAME = "labels_mobilenet_quant_v1_224.txt";
    private static int INPUT_SIZE = 224;
    private static boolean QUANT = true;

    private static Classifier2 classifier = null;

    private static Context mContext = null;
    private static ReactApplicationContext mReactContext = null;

    private String mDatasourceAlias, mDatasetName = null;
    private static CameraView mCameraView = null;
    private static ImageView mImageView = null;
    private static Bitmap mBitmap = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SAIClassifyView(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
        mContext = getReactApplicationContext();
    }

    public static void setInstance(CameraView cameraView) {
        Log.d(REACT_CLASS, "----------------setInstance--------RN--------");
        mCameraView = cameraView;
        mCameraView.setBackgroundColor(Color.parseColor("#FFFFFF"));
        mCameraView.setFocus(CameraKit.Constants.FOCUS_TAP);
        mCameraView.setJpegQuality(100);
        mCameraView.setPinchToZoom(true);


        mCameraView.setFacing(CameraKit.Constants.FACING_BACK);
        mCameraView.setFlash(CameraKit.Constants.FLASH_OFF);
        mCameraView.setMethod(CameraKit.Constants.METHOD_STANDARD);

        initTensorFlowAndLoadModel();
        mCameraView.addCameraKitListener(mCameraKitEventListener);
    }

    public static void setImageView(ImageView imageView) {
        mImageView = imageView;
    }

    private static CameraKitEventListener mCameraKitEventListener = new CameraKitEventListener() {
        @Override
        public void onEvent(CameraKitEvent cameraKitEvent) {
            Log.d(REACT_CLASS, "CameraKitEventListener: onEvent" + cameraKitEvent.getMessage());

        }

        @Override
        public void onError(CameraKitError cameraKitError) {
            Log.d(REACT_CLASS, "CameraKitEventListener: onError" + cameraKitError.getMessage());
        }

        @Override
        public void onImage(CameraKitImage cameraKitImage) {
            Log.e(REACT_CLASS, "CameraKitEventListener: onImage");
            if (cameraKitImage.getJpeg() != null && cameraKitImage.getJpeg().length > 0) {
                Bitmap bitmap = cameraKitImage.getBitmap();

                if (mBitmap != null && !mBitmap.isRecycled()) {
                    mBitmap.recycle();
                    mBitmap = null;
                }
                mBitmap = cameraKitImage.getBitmap();
                Log.d(REACT_CLASS, "mBitmap" + mBitmap.getByteCount());

                bitmap = Bitmap.createScaledBitmap(bitmap, INPUT_SIZE, INPUT_SIZE, false);
                Log.d(REACT_CLASS, "bitmap" + bitmap.getByteCount());

                mImageView.setImageBitmap(mBitmap);

                final List<Classifier2.Recognition> results = classifier.recognizeImage(bitmap);

                if (results != null && results.size() > 0) {
                    WritableArray arr = Arguments.createArray();
                    for (int  i= 0; i < results.size(); i++){
                        Classifier2.Recognition recognition = results.get(i);
                        WritableMap writeMap = Arguments.createMap();
                        writeMap.putString("ID", recognition.getId());
                        writeMap.putString("Title", recognition.getTitle());
                        Float confidence = recognition.getConfidence();
                        DecimalFormat mDecimalFormat = new DecimalFormat("0.00");
                        writeMap.putString("Confidence", mDecimalFormat.format(confidence));
                        arr.pushMap(writeMap);
                        Log.d(REACT_CLASS, "ID:" + recognition.getId() + ", Title:" + recognition.getTitle() + ", Confidence:" + recognition.getConfidence());
                    }

                    WritableMap allResults = Arguments.createMap();
                    allResults.putArray("results", arr);

                    sendEvent(mReactContext, "recognizeImage", allResults);
                }
            }
        }

        @Override
        public void onVideo(CameraKitVideo cameraKitVideo) {

        }
    };

    private static void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private static void initTensorFlowAndLoadModel() {
        try {
            classifier = TensorFlowImageClassifier.create(
                    mContext.getAssets(),
                    MODEL_NAME,
                    LABEL_NAME,
                    INPUT_SIZE,
                    QUANT);
            Log.d(REACT_CLASS, "MODEL_NAME=" + MODEL_NAME + ", LABEL_NAME=" + LABEL_NAME +
                    ", INPUT_SIZE=" + INPUT_SIZE + ", QUANT=" + QUANT);
        } catch (final Exception e) {
            throw new RuntimeException("Error initializing TensorFlow!", e);
        }
    }

    private String getCurrentTime() {
        //得到long类型当前时间
        long l = System.currentTimeMillis();
        //new日期对
        Date date = new Date(l);
        //转换提日期输出格式
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.CHINA);
//        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss_ms", Locale.CHINA);

        return dateFormat.format(date);
    }

    private void createDataset(String UDBName, String datasetName) {
        MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
        Workspace workspace = mapControl.getMap().getWorkspace();
        Datasource datasource = workspace.getDatasources().get(UDBName);

        Datasets datasets = datasource.getDatasets();
        if (datasets.contains(datasetName)) {
            checkPOIFieldInfos((DatasetVector)datasets.get(datasetName));
            return;
        }

        DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
        datasetVectorInfo.setType(DatasetType.CAD);
        datasetVectorInfo.setEncodeType(EncodeType.NONE);
        datasetVectorInfo.setName(datasetName);
        DatasetVector datasetVector = datasets.create(datasetVectorInfo);

        //创建数据集时创建好字段
        addFieldInfo(datasetVector, "MediaFilePaths", FieldType.TEXT, false, "", 800);
        addFieldInfo(datasetVector, "HttpAddress", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "Description", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "ModifiedDate", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "MediaName", FieldType.TEXT, false, "", 255);

        addFieldInfo(datasetVector, "ClassifyType", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "Confidence", FieldType.TEXT, false, "", 255);

        addFieldInfo(datasetVector, "OriginalX", FieldType.DOUBLE, false, "", 25);
        addFieldInfo(datasetVector, "OriginalY", FieldType.DOUBLE, false, "", 25);

        datasetVector.setPrjCoordSys(new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE));

        datasetVectorInfo.dispose();
        datasetVector.close();
    }

    // 添加指定字段到数据集
    private void addFieldInfo(DatasetVector dv, String name, FieldType type, boolean required, String value, int maxLength) {
        FieldInfos infos = dv.getFieldInfos();
        if (infos.indexOf(name) != -1) {//exists
            infos.remove(name);
        }
        FieldInfo newInfo = new FieldInfo();
        newInfo.setName(name);
        newInfo.setType(type);
        newInfo.setMaxLength(maxLength);
        newInfo.setDefaultValue(value);
        newInfo.setRequired(required);
        infos.add(newInfo);
    }

    private void checkPOIFieldInfos(DatasetVector datasetVector) {
        FieldInfos fieldInfos = datasetVector.getFieldInfos();

        if (fieldInfos.indexOf("MediaFilePaths") == -1) {
            addFieldInfo(datasetVector, "MediaFilePaths", FieldType.TEXT, false, "", 800);
        }

        if (fieldInfos.indexOf("HttpAddress") == -1) {
            addFieldInfo(datasetVector, "HttpAddress", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("Description") == -1) {
            addFieldInfo(datasetVector, "Description", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("ModifiedDate") == -1) {
            addFieldInfo(datasetVector, "ModifiedDate", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("MediaName") == -1) {
            addFieldInfo(datasetVector, "MediaName", FieldType.TEXT, false, "", 255);
        }

        //分类类型
        if (fieldInfos.indexOf("ClassifyType") == -1) {
            addFieldInfo(datasetVector, "ClassifyType", FieldType.TEXT, false, "", 255);
        }
        //置信度
        if (fieldInfos.indexOf("Confidence") == -1) {
            addFieldInfo(datasetVector, "Confidence", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("OriginalX") == -1) {
            addFieldInfo(datasetVector, "OriginalX", FieldType.DOUBLE, false, "", 25);
        }
        if (fieldInfos.indexOf("OriginalY") == -1) {
            addFieldInfo(datasetVector, "OriginalY", FieldType.DOUBLE, false, "", 25);
        }
    }

    //保存bitmap为图片
    public static void saveClassifyBitmapAsFile(final String folderPath, final String name) {
        try {
            if (!new File(folderPath).exists()) {
                new File(folderPath).mkdirs();
            }
            if (mBitmap == null || mBitmap.isRecycled()) {
                return;
            }
            File saveFile = new File(folderPath, name + ".jpg");

            FileOutputStream os = null;
            try {
                Log.d(REACT_CLASS, "Saving File To Cache " + saveFile.getPath());
                os = new FileOutputStream(saveFile);
                mBitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
                os.flush();
                os.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            Log.d(REACT_CLASS, e.getMessage());
        }
    }

    /********************************************************************************************/
    //初始化
    @ReactMethod
    public void initAIClassify(String datasourceAlias, String datasetName, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--initMeasureCollector--------RN--------" +
                    "datasourceAlias: " +  datasourceAlias + ", datasetName: " + datasetName );
            mDatasourceAlias = datasourceAlias;
            mDatasetName = datasetName;

            createDataset(datasourceAlias, datasetName);

            if (SMLayer.findLayerByDatasetName(datasetName) == null) {
                SMLayer.addLayerByName(datasourceAlias, datasetName);
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 开始预览
     */
    @ReactMethod
    public void startPreview(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------startPreview--------RN--------");
            mCameraView.start();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 拍照检测
     */
    @ReactMethod
    public void captureImage(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------captureImage--------RN--------");
            mCameraView.captureImage();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 结束并释放资源
     */
    @ReactMethod
    public void dispose(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------dispose--------RN--------");
            mCameraView.stop();
            mImageView.setImageBitmap(null);
            if (mBitmap != null && !mBitmap.isRecycled()) {
                mBitmap.recycle();
                mBitmap = null;
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setModelName(String modelName, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------setModelName--------RN--------");
            MODEL_NAME = modelName;
            initTensorFlowAndLoadModel();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLabelName(String labelName, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------setLabelName--------RN--------");
            LABEL_NAME = labelName;
            initTensorFlowAndLoadModel();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setInputSize(int value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------setInputSize--------RN--------");
            INPUT_SIZE = value;
            initTensorFlowAndLoadModel();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setQuant(boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------setQuant--------RN--------");
            QUANT = value;
            initTensorFlowAndLoadModel();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
