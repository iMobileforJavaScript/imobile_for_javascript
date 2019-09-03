package com.supermap.interfaces.ai;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.annotation.Nullable;
import android.util.Log;
import com.facebook.react.bridge.*;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.ai.classifier.Classifier2;
import com.supermap.ai.classifier.TensorFlowImageClassifier;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.MapControl;

import java.io.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class SAIClassifyView extends ReactContextBaseJavaModule {

    private static final String REACT_CLASS = "SAIClassifyView";

    private static final String DEFAULT_MODEL_NAME = "mobilenet_quant_224.tflite";
    private static final String DEFAULT_LABEL_NAME = "mobilenet_quant_224.txt";
    private static final String DEFAULT_LABEL_CN_TRANSLATE = "mobilenet_quant_224_cn.txt";

    private static ModelType mModelType = ModelType.ASSETS_FILE;
    private static String MODEL_PATH = "";
    private static String LABEL_PATH = "";

    private static int INPUT_SIZE = 224;
    private static boolean QUANT = true;//量化模型

    private static Classifier2 mClassifier = null;

    private static Context mContext = null;
    private static ReactApplicationContext mReactContext = null;

    private String mDatasourceAlias, mDatasetName = null;
    private static Bitmap mBitmap = null;

    private static List<String> mListCNClassifyNames = null;
    private static List<String> mListENClassifyNames = null;
    private static String mLanguage = "CN";//EN

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SAIClassifyView(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
        mContext = getReactApplicationContext();
    }

//    public static void setInstance() {
//        initTensorFlowAndLoadModel();
//    }

    private static void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private static void initTensorFlowAndLoadModel() {
        try {
            if (mModelType == ModelType.ASSETS_FILE) {
                mClassifier = TensorFlowImageClassifier.create(
                        mContext.getAssets(),
                        DEFAULT_MODEL_NAME,
                        DEFAULT_LABEL_NAME,
                        INPUT_SIZE,
                        QUANT);
            } else if (mModelType == ModelType.ABSOLUTE_FILE_PATH) {
                mClassifier = TensorFlowImageClassifier.create(
                        MODEL_PATH,
                        LABEL_PATH,
                        INPUT_SIZE,
                        QUANT);
            }
        } catch (final Exception e) {
            throw new RuntimeException("Error initializing TensorFlow!", e);
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
            } finally {
                if (mBitmap != null && !mBitmap.isRecycled()) {
                    mBitmap.recycle();
                    mBitmap = null;
                }
            }
        } catch (Exception e) {
            Log.d(REACT_CLASS, e.getMessage());
        }
    }

    private void initData() {
        mListCNClassifyNames = getAllChineseClassifyName();
        mListENClassifyNames = getAllEngClassifyName();
    }

    /********************************************************************************************/
    //初始化
    @ReactMethod
    public void initAIClassify(String datasourceAlias, String datasetName, String language, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--initMeasureCollector--------RN--------" +
                    "datasourceAlias: " +  datasourceAlias + ", datasetName: " + datasetName );
            mDatasourceAlias = datasourceAlias;
            mDatasetName = datasetName;

            initTensorFlowAndLoadModel();
            mLanguage = language;
            initData();
//            createDataset(datasourceAlias, datasetName);
//
//            if (SMLayer.findLayerByDatasetName(datasetName) == null) {
//                SMLayer.addLayerByName(datasourceAlias, datasetName);
//            }

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
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 暂停
     */
    @ReactMethod
    public void stopPreview(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------stopPreview--------RN--------");
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
            if (mBitmap != null && !mBitmap.isRecycled()) {
                mBitmap.recycle();
                mBitmap = null;
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 加载react-native-camera拍的照片（应用私有存储）
     */
    @ReactMethod
    public void loadImageUri(final String imgUri, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------loadImageUri--------RN--------");
            if (imgUri != null && !imgUri.isEmpty()) {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        //压缩图片到指定kb大小
                        mBitmap = BitmapFactory.decodeFile(imgUri);
                        //删除原始图片
                        File file = new File(imgUri);
                        if (file.exists()){
                            boolean delete = file.delete();
                            if (delete) {
                                Log.d(REACT_CLASS, "Delete Cache imgUri Success!");
                            }
                        }
                        Bitmap bitmap = Bitmap.createScaledBitmap(mBitmap, INPUT_SIZE, INPUT_SIZE, false);

                        final List<Classifier2.Recognition> results = mClassifier.recognizeImage(bitmap);
                        WritableArray arr = Arguments.createArray();

                        if (results != null && results.size() > 0) {
                            for (int  i= 0; i < results.size(); i++){
                                Classifier2.Recognition recognition = results.get(i);
                                WritableMap writeMap = Arguments.createMap();
                                writeMap.putString("ID", recognition.getId());
                                String title = recognition.getTitle();
                                if (mLanguage.equals("CN")) {
                                    if (mListENClassifyNames.contains(title)){
                                        int index = mListENClassifyNames.indexOf(title);
                                        title = mListCNClassifyNames.get(index);
                                    }
                                }
                                writeMap.putString("Title",title);
                                writeMap.putString("Time", getCurrentTime());
                                Float confidence = recognition.getConfidence();
                                DecimalFormat mDecimalFormat = new DecimalFormat("0.00");
                                writeMap.putString("Confidence", mDecimalFormat.format(confidence * 100) + "%");
                                arr.pushMap(writeMap);
                                Log.d(REACT_CLASS, "ID:" + recognition.getId() + ", Title:" + recognition.getTitle() + ", Confidence:" + recognition.getConfidence());
                            }
                        }
                        WritableMap allResults = Arguments.createMap();
                        allResults.putArray("results", arr);

                        sendEvent(mReactContext, "recognizeImage", allResults);
                    }
                }).start();
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 通过图片的绝对路径来获取对应的压缩后的Bitmap对象
     */
    public static Bitmap getCompressedBitmap(String filePath, int requireWidth, int requireHeight) {
        // 第一次解析将inJustDecodeBounds设置为true,用以获取图片大小,并且不需要将Bitmap对象加载到内存中
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(filePath, options); // 第一次解析
        // 计算inSampleSize的值,并且赋值给Options.inSampleSize
        options.inSampleSize = calculateInSampleSize(options, requireWidth, requireHeight);
        // 使用获取到的inSampleSize再次解析图片
        options.inJustDecodeBounds = false;
        options.inPreferredConfig = Bitmap.Config.RGB_565; //假如对图片没有透明度要求的话，可以改成RGB_565，相比ARGB_8888将节省一半的内存开销。
        return BitmapFactory.decodeFile(filePath, options);
    }

    /**
     * 计算压缩的inSampleSize的值,该值会在宽高上都进行压缩(也就是压缩前后比例是inSampleSize的平方倍)
     */
    private static int calculateInSampleSize(BitmapFactory.Options options, int requireWidth, int requireHeight) {
        // 获取源图片的实际的宽度和高度
        int realWidth = options.outWidth;
        int realHeight = options.outHeight;

        int inSampleSize = 1;
        if (realWidth > requireWidth || realHeight > requireHeight) {
            // 计算出实际的宽高与目标宽高的比例
            int widthRatio = Math.round((float) realWidth / (float) requireWidth);
            int heightRatio = Math.round((float) realHeight / (float) requireHeight);
            // 选择宽高比例最小的值赋值给inSampleSize,这样可以保证最终图片的宽高一定会大于或等于目标的宽高
            inSampleSize = widthRatio < heightRatio ? widthRatio : heightRatio;
        }
        return inSampleSize;
    }

    /**
     * 结束并释放资源
     */
    @ReactMethod
    public void getImagePath(String imageUri, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------getImagePath--------RN--------");
            String mediaPath = "";
            if (imageUri.indexOf("content://") == 0) {
                String  myImageUrl = imageUri;
                Uri uri = Uri.parse(myImageUrl);
                String[] proj = { MediaStore.Images.Media.DATA, MediaStore.Video.Media.DATA };
                Cursor cursor = mReactContext.getContentResolver().query(uri, proj,null,null,null);
                int actualMediaColumnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                mediaPath = cursor.getString(actualMediaColumnIndex);
                final String finalMediaPath = mediaPath;
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        //压缩图片到指定kb大小
                        mBitmap = BitmapFactory.decodeFile(finalMediaPath);
                        Bitmap bitmap = Bitmap.createScaledBitmap(mBitmap, INPUT_SIZE, INPUT_SIZE, false);

                        final List<Classifier2.Recognition> results = mClassifier.recognizeImage(bitmap);
                        WritableMap allResults = Arguments.createMap();
                        WritableArray arr = Arguments.createArray();

                        if (results != null && results.size() > 0) {
                            for (int  i= 0; i < results.size(); i++){
                                Classifier2.Recognition recognition = results.get(i);
                                WritableMap writeMap = Arguments.createMap();
                                writeMap.putString("ID", recognition.getId());
                                String title = recognition.getTitle();
                                if (mLanguage.equals("CN")) {
                                    if (mListENClassifyNames.contains(title)){
                                        int index = mListENClassifyNames.indexOf(title);
                                        title = mListCNClassifyNames.get(index);
                                    }
                                }
                                writeMap.putString("Title",title);
                                writeMap.putString("Time", getCurrentTime());
                                Float confidence = recognition.getConfidence();
                                DecimalFormat mDecimalFormat = new DecimalFormat("0.00");
                                writeMap.putString("Confidence", mDecimalFormat.format(confidence * 100) + "%");
                                arr.pushMap(writeMap);
                                Log.d(REACT_CLASS, "ID:" + recognition.getId() + ", Title:" + recognition.getTitle() + ", Confidence:" + recognition.getConfidence());
                            }
                        }
                        allResults.putArray("results", arr);
                        sendEvent(mReactContext, "recognizeImage", allResults);
                    }
                }).start();
            }
            promise.resolve(mediaPath);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

//    /**
//     * 拷贝图片到media文件夹
//     */
//    @ReactMethod
//    public void copyPicture(String from, String to, Promise promise) {
//        try {
//            Log.d(REACT_CLASS, "----------------copyPicture--------RN--------");
//
//            boolean b = copyFile(from, to);
//
//            promise.resolve(b);
//        } catch (Exception e) {
//            promise.reject(e);
//        }
//    }

    /**
     * 清除bitmap
     */
    @ReactMethod
    public void clearBitmap(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------clearBitmap--------RN--------");
            if (mBitmap != null && !mBitmap.isRecycled()) {
                mBitmap.recycle();
                mBitmap = null;
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    private boolean copyFile(String from, String to) {
        File fromFile = new File(from);
        File toFile = new File(to);
        if (!fromFile.exists()) return false;
        Boolean result = true;
        try {
            if (fromFile.isFile()) {
                return copyFile(fromFile, toFile, true);
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean copyFile(File from, File des, boolean rewrite) {
        //目标路径不存在的话就创建一个
        if (!des.getParentFile().exists()) {
            des.getParentFile().mkdirs();
        }
        if (des.exists()) {
            if (rewrite) {
                des.delete();
            } else {
                return false;
            }
        }

        try {
            InputStream fis = new FileInputStream(from);
            FileOutputStream fos = new FileOutputStream(des);
            //1kb
            byte[] bytes = new byte[1024];
            int readlength = -1;
            while ((readlength = fis.read(bytes)) > 0) {
                fos.write(bytes, 0, readlength);
            }
            fos.flush();
            fos.close();
            fis.close();
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    /**
     * 获取所有的分类类型的中文翻译(顺序与label文件对应)
     * @return
     */
    private List<String> getAllChineseClassifyName() {
        List<String> list = new ArrayList<>();
        try {
            InputStream inputStream = null;
            if (mModelType == ModelType.ASSETS_FILE) {
                inputStream = mContext.getAssets().open(DEFAULT_LABEL_CN_TRANSLATE);
            } else if (mModelType == ModelType.ABSOLUTE_FILE_PATH) {
                inputStream = new FileInputStream(new File(LABEL_PATH));
            }
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                if (!line.contains("?") && !line.equals("")){
                    list.add(line);
                }
            }
            bufferedReader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取所有的分类类型
     * @return
     */
    private List<String> getAllEngClassifyName() {
        List<String> list = new ArrayList<>();
        try {
            InputStream inputStream = null;
            if (mModelType == ModelType.ASSETS_FILE) {
                inputStream = mContext.getAssets().open(DEFAULT_LABEL_NAME);
            } else if (mModelType == ModelType.ABSOLUTE_FILE_PATH) {
                inputStream = new FileInputStream(new File(LABEL_PATH));
            }
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                if (!line.contains("?") && !line.equals("")){
                    list.add(line);
                }
            }
            bufferedReader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 修改最新的对象
     */
    @ReactMethod
    public void modifyLastItem(ReadableMap readableMap, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------modifyLastItem--------RN--------");
            HashMap<String, Object> data = readableMap.toHashMap();

            String datasourceAlias = null;
            String datasetName = null;
            String mediaName = null;
            String remarks = null;

            if (data.containsKey("datasourceAlias")){
                datasourceAlias = data.get("datasourceAlias").toString();
            }
            if (data.containsKey("datasetName")){
                datasetName = data.get("datasetName").toString();
            }
            if (data.containsKey("mediaName")){
                mediaName = data.get("mediaName").toString();
            }
            if (data.containsKey("remarks")){
                remarks = data.get("remarks").toString();
            }

            DatasetVector datasetVector = null;
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            Workspace workspace = mapControl.getMap().getWorkspace();
            Datasource datasource = workspace.getDatasources().get(datasourceAlias);
            datasetVector = (DatasetVector) datasource.getDatasets().get(datasetName);

            Recordset recordset = datasetVector.getRecordset(false, CursorType.DYNAMIC);//动态指针
            if (recordset != null) {
                //移动指针到最后
                recordset.moveLast();
                recordset.edit();//可编辑

                FieldInfos fieldInfos = recordset.getFieldInfos();
                if (fieldInfos.indexOf("MediaName") != -1) {
                    String str = null;
                    Object ob = recordset.getFieldValue("MediaName");
                    if (ob != null) {
                        str = ob.toString();
                    }
                    if (!mediaName.equals(str)) {
                        recordset.setFieldValue("MediaName", mediaName);
                    }
                }
                if (fieldInfos.indexOf("Description") != -1) {
                    String str = null;
                    Object ob = recordset.getFieldValue("Description");
                    if (ob != null) {
                        str = ob.toString();
                    }
                    if (!remarks.equals(str)) {
                        recordset.setFieldValue("Description", remarks);
                    }
                }

                //保存更新,并释放资源
                recordset.update();
                recordset.close();
                recordset.dispose();
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setModel(ReadableMap readableMap, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------setModel--------RN--------");
            HashMap<String, Object> data = readableMap.toHashMap();

            ModelType modelType = null;
            String modelPath = null;
            String labelPath = null;

            if (data.containsKey("ModelType")){
                String type = data.get("ModelType").toString();
                if (type.equals("ASSETS_FILE")) {
                    modelType = ModelType.ASSETS_FILE;
                } else if (type.equals("ABSOLUTE_FILE_PATH")) {
                    modelType = ModelType.ABSOLUTE_FILE_PATH;
                }
            }
            if (data.containsKey("ModelPath")){
                modelPath = data.get("ModelPath").toString();
            }
            if (data.containsKey("LabelPath")){
                labelPath = data.get("LabelPath").toString();
            }

            if (modelType == null) {
                promise.resolve(false);
                return;
            } else {
                if (modelType == ModelType.ABSOLUTE_FILE_PATH) {
                    if (modelPath == null || labelPath == null || modelPath.isEmpty() || labelPath.isEmpty()) {
                        promise.resolve(false);
                        return;
                    }
                }
            }
            mModelType = modelType;
            if (mModelType == ModelType.ABSOLUTE_FILE_PATH) {
                MODEL_PATH = modelPath;
                LABEL_PATH = labelPath;
                INPUT_SIZE = 64;
                QUANT = false;
            } else if (mModelType == ModelType.ASSETS_FILE){
                MODEL_PATH = "";
                LABEL_PATH = "";
                INPUT_SIZE = 224;
                QUANT = true;
            }

            initTensorFlowAndLoadModel();
            initData();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCurrentModel(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------getCurrentModel--------RN--------");
            WritableMap writableMap = Arguments.createMap();
            String modelType = mModelType.toString();
            writableMap.putString("ModelType", modelType);
            if (mModelType == ModelType.ABSOLUTE_FILE_PATH) {
                writableMap.putString("ModelPath", MODEL_PATH);
                writableMap.putString("LabelPath", LABEL_PATH);
            }

            promise.resolve(writableMap);
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

    public enum ModelType{
        ASSETS_FILE,
        ABSOLUTE_FILE_PATH,
    }

}
