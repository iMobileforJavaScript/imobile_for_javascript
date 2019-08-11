package com.supermap.interfaces.ar;

import android.os.Handler;
import android.util.Log;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.google.ar.core.ArCoreApk;
import com.supermap.ar.highprecision.MeasureView;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.Datasources;
import com.supermap.data.EncodeType;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.GeoPoint;
import com.supermap.data.Geometry;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Recordset;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.MapControl;
import com.supermap.track.HPTrack;

public class SMeasureView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SMeasureView";

    private static MeasureView mMeasureView = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SMeasureView(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    public static void setInstance(MeasureView measureView) {
        Log.d(REACT_CLASS, "----------------SMeasureView--setInstance--------RN--------");
        mMeasureView = measureView;

        mMeasureView.enableSupport(true);
    }

    private boolean checkARCore() {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--checkARCore--------JAVA--------");
            ArCoreApk.Availability availability = ArCoreApk.getInstance().checkAvailability(getCurrentActivity());
            if (availability.isTransient()) {
                // Re-query at 5Hz while compatibility is checked in the background.
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        checkARCore();
                    }
                }, 200);
            }
            // Unsupported or unknown.
            return availability.isSupported();
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 检查是否支持ARCore
     */
    @ReactMethod
    public void isSupportedARCore(Promise promise) {
        try {
            boolean checkARCore = checkARCore();
            Log.d(REACT_CLASS, "----------------SMeasureView--isSupportedARCore--------RN--------" + checkARCore);
            promise.resolve(checkARCore);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 新增记录
     */
    @ReactMethod
    public void addNewRecord(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--addNewRecord--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.addNewRecord();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 撤销上一记录
     */
    @ReactMethod
    public void undoDraw(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--undoDraw--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.undo();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除所有
     */
    @ReactMethod
    public void clearAll(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--clearAll--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.cleanAll();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置中心辅助
     */
    @ReactMethod
    public void setEnableSupport(boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--setEnableSupport--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.enableSupport(value);
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void initMeasureCollector(String path, Promise promise) {
        try {
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存数据
     */
    @ReactMethod
    public void saveDataset(String datasourceAlias, String datasetName, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--saveDataset--------RN--------");
            if (mMeasureView != null) {
                createDataset(datasourceAlias, datasetName);

                DatasetVector datasetVector = null;
                MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
                Workspace workspace = mapControl.getMap().getWorkspace();
                Datasource datasource = workspace.getDatasources().get(datasourceAlias);
                datasetVector = (DatasetVector) datasource.getDatasets().get(datasetName);

                Point2Ds totalPoints = mMeasureView.getTotalPoints();
                Recordset recordset = datasetVector.getRecordset(false, CursorType.STATIC);
                if (recordset != null) {
                    for (int i = 0; i < totalPoints.getCount(); i++) {
//                    POIInfo poiInfo = new POIInfo.Builder()
//                            .ID(currentGeometryID)
//                            .name(info)
//                            .type(type)
//                            .person("人员编号")
//                            .time(getCurrentTime())
//                            .address("酒仙桥北路甲IT电子产业园附近")
//                            .picpath(picFolderPath)
//                            .locationX(currentPoint2D.getX())
//                            .locationY(currentPoint2D.getY())
//                            .notes("")
//                            .build();
                        Point2D item = totalPoints.getItem(i);
                        recordset.addNew(new GeoPoint(item.getX(), item.getY()));
                    }

                    recordset.update();
                    recordset.close();
                    recordset.dispose();
                    mMeasureView.cleanAll();
                }
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /*********************************************************************************************************************/
    private void createDataset(String UDBName, String datasetName) {
        MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
        Workspace workspace = mapControl.getMap().getWorkspace();
        Datasource datasource = workspace.getDatasources().get(UDBName);

        Datasets datasets = datasource.getDatasets();
        if (datasets.contains(datasetName)) {
            return;
        }

        DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
        datasetVectorInfo.setType(DatasetType.CAD);
        datasetVectorInfo.setEncodeType(EncodeType.NONE);
        datasetVectorInfo.setName(datasetName);
        DatasetVector datasetVector = datasets.create(datasetVectorInfo);

        //创建数据集时创建好字段
        addFieldInfo(datasetVector, "NAME", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "TYPE", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "PERSON", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "TIME", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "ADDRESS", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "PICPATH", FieldType.TEXT, false, "", 255);
        addFieldInfo(datasetVector, "NOTES", FieldType.TEXT, false, "", 255);

        addFieldInfo(datasetVector, "LOCATIONX", FieldType.DOUBLE, false, "", 25);
        addFieldInfo(datasetVector, "LOCATIONY", FieldType.DOUBLE, false, "", 25);

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

    // 修改数据集中指定ID的属性
    private void updatePOIInfo(String UDBName, String DatasetName, POIInfo info) {
        DatasetVector datasetVector = null;
        MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
        if (UDBName != null && DatasetName != null) {
            Workspace workspace = mapControl.getMap().getWorkspace();
            Datasource datasource = workspace.getDatasources().get(UDBName);
            datasetVector = (DatasetVector) datasource.getDatasets().get(DatasetName);
        }

        if (datasetVector == null || info == null) {
            Log.e(REACT_CLASS, "updatePOIInfo argument is null!");
            return;
        }

        // 如果数据集未打开 返回0；
        if (!datasetVector.isOpen()) {
            return;
        }

        checkPOIFieldInfos(datasetVector);

        // id查询,假定数据集为矢量数据集
        int[] ids = {info.getID()};
        Recordset recordset = datasetVector.query(ids, CursorType.DYNAMIC);

        // 如果记录集为null，返回0；
        if (recordset == null || recordset.isEmpty()) {
            return;
        }

        recordset.moveFirst();
        recordset.edit();

        // 判断值是否有更改，如果有，设置新值，并将Modified属性设为true
        double dlocation = 0;
        String oldString = null;
        Object ob = null;

        FieldInfos fieldInfos = recordset.getFieldInfos();

        if (fieldInfos.indexOf("NAME") != -1) {
            ob = recordset.getFieldValue("NAME");
            if (ob != null) {
                oldString = ob.toString();
            }
            if ((info.getName() != null) && !info.getName().equalsIgnoreCase(oldString)) {
                recordset.setFieldValue("NAME", info.getName());
            }
        }

        if (fieldInfos.indexOf("TYPE") != -1) {
            ob = recordset.getFieldValue("TYPE");
            if (ob != null) {
                oldString = ob.toString();
            }
            if ((info.getType() != null) && !info.getType().equalsIgnoreCase(oldString)) {
                recordset.setFieldValue("TYPE", info.getType());
            }
        }

        if (fieldInfos.indexOf("PERSON") != -1) {
            ob = recordset.getFieldValue("PERSON");
            if (ob != null) {
                oldString = ob.toString();
            }
            if ((info.getPerson() != null) && !info.getPerson().equalsIgnoreCase(oldString)) {
                recordset.setFieldValue("PERSON", info.getPerson());
            }
        }

        if (fieldInfos.indexOf("TIME") != -1) {
            ob = recordset.getFieldValue("TIME");
            if (ob != null) {
                oldString = ob.toString();
            }
            if (info.getTime() != null || !info.getTime().equalsIgnoreCase(oldString)) {
                recordset.setFieldValue("TIME", info.getTime());
            }
        }

        if (fieldInfos.indexOf("ADDRESS") != -1) {
            ob = recordset.getFieldValue("ADDRESS");
            if (ob != null) {
                oldString = ob.toString();
            }
            if ((info.getAddress() != null) && !info.getAddress().equalsIgnoreCase(oldString)) {
                recordset.setFieldValue("ADDRESS", info.getAddress());
            }
        }

        if (fieldInfos.indexOf("NOTES") != -1) {
            ob = recordset.getFieldValue("NOTES");
            if (ob != null) {
                oldString = ob.toString();
            }
            if ((info.getNotes() != null) && !info.getNotes().equalsIgnoreCase(oldString)) {
                recordset.setFieldValue("NOTES", info.getNotes());
            }
        }

        if (fieldInfos.indexOf("PICPATH") != -1) {
            ob = recordset.getFieldValue("PICPATH");
            if (ob != null) {
                oldString = ob.toString();
            }
            if ((info.getPicpath() != null) && !info.getPicpath().equalsIgnoreCase(oldString)) {
                recordset.setFieldValue("PICPATH", info.getPicpath());
            }
        }

        if (fieldInfos.indexOf("LOCATIONX") != -1) {
            ob = recordset.getFieldValue("LOCATIONX");
            if (ob != null) {
                dlocation = Double.parseDouble(ob.toString());
            }
            if (info.getLocationX() != dlocation) {
                recordset.setFieldValue("LOCATIONX", info.getLocationX());
            }
        }

        if (fieldInfos.indexOf("LOCATIONY") != -1) {
            ob = recordset.getFieldValue("LOCATIONY");
            if (ob != null) {
                dlocation = Double.parseDouble(ob.toString());
            }
            if (info.getLocationY() != dlocation) {
                recordset.setFieldValue("LOCATIONY", info.getLocationY());
            }
        }

        recordset.update();
        recordset.close();
        recordset.dispose();
    }

    private void checkPOIFieldInfos(DatasetVector datasetVector) {
        FieldInfos fieldInfos = datasetVector.getFieldInfos();


        if (fieldInfos.indexOf("NAME") == -1) {
            addFieldInfo(datasetVector, "NAME", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("TYPE") == -1) {
            addFieldInfo(datasetVector, "TYPE", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("PERSON") == -1) {
            addFieldInfo(datasetVector, "PERSON", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("TIME") == -1) {
            addFieldInfo(datasetVector, "TIME", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("ADDRESS") == -1) {
            addFieldInfo(datasetVector, "ADDRESS", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("PICPATH") == -1) {
            addFieldInfo(datasetVector, "PICPATH", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("NOTES") == -1) {
            addFieldInfo(datasetVector, "NOTES", FieldType.TEXT, false, "", 255);
        }

        if (fieldInfos.indexOf("LOCATIONX") == -1) {
            addFieldInfo(datasetVector, "LOCATIONX", FieldType.DOUBLE, false, "", 25);
        }
        if (fieldInfos.indexOf("LOCATIONY") == -1) {
            addFieldInfo(datasetVector, "LOCATIONY", FieldType.DOUBLE, false, "", 25);
        }
    }


}
