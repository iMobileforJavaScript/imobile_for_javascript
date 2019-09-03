package com.supermap.interfaces.ar;

import android.annotation.SuppressLint;
import android.content.Context;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.RNUtils.FileUtil;
import com.supermap.ar.highprecision.MeasureView;
import com.supermap.data.*;
import com.supermap.data.Enum;
import com.supermap.interfaces.ai.CustomRelativeLayout;
import com.supermap.interfaces.ar.rajawali.MotionRajawaliRenderer;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.MapControl;
import org.rajawali3d.scene.ASceneFrameCallback;
import org.rajawali3d.surface.IRajawaliSurface;
import org.rajawali3d.surface.RajawaliSurfaceView;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

public class SCollectSceneFormView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SCollectSceneFormView";
    private static RajawaliSurfaceView mSurfaceView;
    private static MeasureView mMeasureView;

    private static Context mContext = null;
    private static ReactApplicationContext mReactContext = null;
    private static CustomRelativeLayout mCustomRelativeLayout = null;

    private static MotionRajawaliRenderer mRenderer;
    private static boolean isShowTrace = true;//初始值
    private static float[] mCurrentPoseTranslation = new float[3];
    private static float[] mCurrentPoseRotation = new float[4];

    private static DecimalFormat mDecimalFormat = new DecimalFormat("0.00");
    private ArrayList<Point3D> mPostData = new ArrayList<>();
    private ArrayList<Point3D> mQueryData = new ArrayList<>();//查询到的数据

    private String mDatasourceAlias, mDatasetName = null;
    private static String mLanguage = "CN";//EN
    private static String UDBpath = "";

    public static void setMeasureView(MeasureView measureView) {
        mMeasureView = measureView;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SCollectSceneFormView(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
        mContext = reactContext.getApplicationContext();
    }

    public static void setViewManager(CustomRelativeLayout relativeLayout) {
        mCustomRelativeLayout = relativeLayout;
    }

    @SuppressLint("ClickableViewAccessibility")
    public static void setSurfaceView(RajawaliSurfaceView surfaceView) {
        //----------------------------显示层----------------------------------
        //1.获取显示层
        mSurfaceView = surfaceView;

        //2. 设置透明
        mSurfaceView.setFrameRate(60);
        mSurfaceView.setRenderMode(IRajawaliSurface.RENDERMODE_WHEN_DIRTY);
        mSurfaceView.setTransparent(true);

        //3.新建渲染器
        mRenderer = new MotionRajawaliRenderer(mContext);

        //4.添加手势控制
        mSurfaceView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                mRenderer.onTouchEvent(event);
                return true;
            }
        });

        //5.控制渲染
        setupRenderer();
    }

    private static void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private static void setupRenderer() {
        // motion renderer
        mSurfaceView.setEGLContextClientVersion(2);
        mRenderer.getCurrentScene().registerFrameCallback(new ASceneFrameCallback() {
            @Override
            public void onPreFrame(long sceneTime, double deltaTime) {
                if (isShowTrace) {
                    mMeasureView.saveCurrentPoseTranslation(mCurrentPoseTranslation);
                    mMeasureView.saveCurrentPoseRotation(mCurrentPoseRotation);

                    mRenderer.updateCameraPoseFromVecotr(mCurrentPoseTranslation, mCurrentPoseRotation);

                    //记录总长度
                    float totalLength = mRenderer.getTotalLength();
//                    Log.d(REACT_CLASS, "TotalLength: " + totalLength + "m");

                    WritableMap allResults = Arguments.createMap();
                    allResults.putString("totalLength", mDecimalFormat.format(totalLength));
                    sendEvent(mReactContext, "onTotalLengthChanged", allResults);
                }
            }

            @Override
            public boolean callPreFrame() {
                return true;
            }

            @Override
            public void onPreDraw(long sceneTime, double deltaTime) {
            }

            @Override
            public void onPostFrame(long sceneTime, double deltaTime) {

            }
        });

        mSurfaceView.setSurfaceRenderer(mRenderer);
    }

    /**
     * 开始记录
     * @param promise
     */
    @ReactMethod
    public void startRecording(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------startRecording--------RN--------");
            isShowTrace = true;

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 停止记录
     * @param promise
     */
    @ReactMethod
    public void stopRecording(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------stopRecording--------RN--------");
            isShowTrace = false;

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取三维场景里的数据并保存
     * @param promise
     */
    @ReactMethod
    public void saveData(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------saveData--------RN--------");
            if (mPostData == null) {
                mPostData = new ArrayList<>();
            } else {
                mPostData.clear();
            }
            if (mRenderer != null) {
                mRenderer.savePoseData(mPostData);
            }
            //保存到数据集
            saveDataset();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
    /**
     * 加载数据到三维场景里
     * @param promise
     */
    @ReactMethod
    public void loadData(int ID, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------stopRecording--------RN--------");
            if (mRenderer != null) {
                mRenderer.loadPoseData(mPostData);
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
    /**
     * 清空数据
     * @param promise
     */
    @ReactMethod
    public void clearData(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------stopRecording--------RN--------");
            if (mRenderer != null) {
                mRenderer.clearPoseData();
            }
            if (mPostData != null) {
                mPostData.clear();
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setArSceneViewVisible(final boolean isVisible, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------setArSceneViewVisible--------RN--------");
            getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (isVisible) {
                        mMeasureView.setVisibility(View.VISIBLE);
                    } else {
                        mMeasureView.setVisibility(View.INVISIBLE);
                    }
                }
            });

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void onDestroy(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------onDestroy--------RN--------");
            isShowTrace = false;
            mRenderer.getCurrentScene().clearFrameCallbacks();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void initSceneFormView(String datasourceAlias, String datasetName, String language, String UDBpath, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------initSceneFormView--------RN--------");
            mDatasourceAlias = datasourceAlias;
            mDatasetName = datasetName;
            mLanguage = language;
            this.UDBpath = UDBpath;

            createDatasource(mDatasourceAlias, this.UDBpath);
            createDataset(mDatasourceAlias, mDatasetName);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /*********************************************************************************************/
    private void createDatasource(String datasourceAlias, String datasourcePath) {
        Datasource datasource = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().get(datasourceAlias);
        if (datasource == null || datasource.isReadOnly()) {
            DatasourceConnectionInfo info = new DatasourceConnectionInfo();
            info.setAlias(datasourceAlias);
            info.setEngineType(EngineType.UDB);
            FileUtil.createDirectory(datasourcePath);
            String server = datasourcePath + datasourceAlias + ".udb";
            info.setServer(server);

            datasource = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().create(info);
            if (datasource == null) {
                SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().open(info);
            } else {
                Log.e(REACT_CLASS, "createDatasource: " + server);
            }
            info.dispose();
        }
    }

    private void createDataset(String UDBName, String datasetName) {
        MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
        Workspace workspace = mapControl.getMap().getWorkspace();
        Datasource datasource = workspace.getDatasources().get(UDBName);

        Datasets datasets = datasource.getDatasets();
        if (datasets.contains(datasetName)) {
            checkFieldInfos((DatasetVector)datasets.get(datasetName));
            return;
        }

        DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
        datasetVectorInfo.setType(DatasetType.LINE3D);
        datasetVectorInfo.setEncodeType(EncodeType.NONE);
        datasetVectorInfo.setName(datasetName);
        DatasetVector datasetVector = datasets.create(datasetVectorInfo);

        //创建数据集时创建好字段
        addFieldInfo(datasetVector, "Description", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "ModifiedDate", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "Name", FieldType.TEXT, false, "", 255);

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

    private void checkFieldInfos(DatasetVector datasetVector) {
        FieldInfos fieldInfos = datasetVector.getFieldInfos();

        if (fieldInfos.indexOf("Description") == -1) {
            addFieldInfo(datasetVector, "Description", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("ModifiedDate") == -1) {
            addFieldInfo(datasetVector, "ModifiedDate", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("Name") == -1) {
            addFieldInfo(datasetVector, "Name", FieldType.TEXT, false, "", 255);
        }
    }

    /**
     * 保存数据
     */
    private void saveDataset() {
        try {
            DatasetVector datasetVector = null;
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            Workspace workspace = mapControl.getMap().getWorkspace();
            Datasource datasource = workspace.getDatasources().get(mDatasourceAlias);
            datasetVector = (DatasetVector) datasource.getDatasets().get(mDatasetName);

            Recordset recordset = datasetVector.getRecordset(false, CursorType.DYNAMIC);//动态指针
            if (recordset != null) {
                //移动指针到最后
                recordset.moveLast();
                recordset.edit();//可编辑

                GeoLine3D geoLine3D = new GeoLine3D();
                Point3D[] point3DS = new Point3D[mPostData.size()];
                for (int i = 0; i < mPostData.size(); i++) {
                    point3DS[i] = mPostData.get(i);
                }
                Point3Ds point3Ds = new Point3Ds(point3DS);
                geoLine3D.addPart(point3Ds);
                //移动指针到下一位
                recordset.moveNext();
                //新增面对象
                recordset.addNew(geoLine3D);

                FieldInfos fieldInfos = recordset.getFieldInfos();
                if (fieldInfos.indexOf("ModifiedDate") != -1) {
                    String str = null;
                    Object ob = recordset.getFieldValue("ModifiedDate");
                    if (ob != null) {
                        str = ob.toString();
                    }
                    if (!getCurrentTime().equals(str)) {
                        recordset.setFieldValue("ModifiedDate", getCurrentTime());
                    }
                }

                //保存更新,并释放资源
                recordset.update();
                recordset.close();
                recordset.dispose();
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
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

    // 获取指定数据集中所有信息
    public ArrayList<POIInfo> getDatasetAllGeometry(String UDBName, String DatasetName) {
        DatasetVector datasetVector = null;
        if (UDBName != null && DatasetName != null) {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            Workspace workspace = mapControl.getMap().getWorkspace();
            Datasource datasource = workspace.getDatasources().get(UDBName);
            datasetVector = (DatasetVector) datasource.getDatasets().get(DatasetName);
        }

        if (datasetVector == null) {
            Log.e(REACT_CLASS, "getDatasetAllGeometry argument is valid!");
            return null;
        }

        // 如果数据集未打开
        if (!datasetVector.isOpen()) {
            return null;
        }

        Recordset recordset = datasetVector.getRecordset(false, CursorType.STATIC);
        recordset.moveFirst();
        Object ob;
        FieldInfos fieldInfos = recordset.getFieldInfos();

        ArrayList<POIInfo> list = new ArrayList<POIInfo>();

        while (!recordset.isEOF()) {
            int geometryId = recordset.getGeometry().getID();

            String NAME = "";
            if (fieldInfos.indexOf("NAME") != -1) {
                ob = recordset.getFieldValue("NAME");
                if (ob != null) {
                    NAME = ob.toString();
                }
            }

            String TYPE = "";
            if (fieldInfos.indexOf("TYPE") != -1) {
                ob = recordset.getFieldValue("TYPE");
                if (ob != null) {
                    TYPE = ob.toString();
                }
            }

            String PERSON = "";
            if (fieldInfos.indexOf("PERSON") != -1) {
                ob = recordset.getFieldValue("PERSON");
                if (ob != null) {
                    PERSON = ob.toString();
                }
            }

            String TIME = "";
            if (fieldInfos.indexOf("TIME") != -1) {
                ob = recordset.getFieldValue("TIME");
                if (ob != null) {
                    TIME = ob.toString();
                }
            }

            String ADDRESS = "";
            if (fieldInfos.indexOf("ADDRESS") != -1) {
                ob = recordset.getFieldValue("ADDRESS");
                if (ob != null) {
                    ADDRESS = ob.toString();
                }
            }

            String PICPATH = "";
            if (fieldInfos.indexOf("PICPATH") != -1) {
                ob = recordset.getFieldValue("PICPATH");
                if (ob != null) {
                    PICPATH = ob.toString();
                }
            }

            String NOTES = "";
            if (fieldInfos.indexOf("NOTES") != -1) {
                ob = recordset.getFieldValue("NOTES");
                if (ob != null) {
                    NOTES = ob.toString();
                }
            }

            double LOCATIONX = 0;
            if (fieldInfos.indexOf("LOCATIONX") != -1) {
                ob = recordset.getFieldValue("LOCATIONX");
                if (ob != null) {
                    LOCATIONX = Double.parseDouble(ob.toString());
                }
            }

            double LOCATIONY = 0;
            if (fieldInfos.indexOf("LOCATIONY") != -1) {
                ob = recordset.getFieldValue("LOCATIONY");
                if (ob != null) {
                    LOCATIONY = Double.parseDouble(ob.toString());
                }
            }

            POIInfo poiInfo = new POIInfo.Builder()
                    .ID(geometryId)
                    .name(NAME)
                    .type(TYPE)
                    .person(PERSON)
                    .time(TIME)
                    .address(ADDRESS)
                    .picpath(PICPATH)
                    .notes(NOTES)
                    .locationX(LOCATIONX)
                    .locationY(LOCATIONY)
                    .build();

            list.add(poiInfo);

            recordset.moveNext();
        }

        recordset.close();
        recordset.dispose();

        return list;
    }

}
