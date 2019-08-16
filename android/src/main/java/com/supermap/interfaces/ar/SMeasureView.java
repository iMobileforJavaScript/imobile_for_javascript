package com.supermap.interfaces.ar;

import android.os.Handler;
import android.support.annotation.Nullable;
import android.util.Log;
import com.facebook.react.bridge.*;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.ar.core.ArCoreApk;
import com.supermap.RNUtils.LocationTransfer;
import com.supermap.ar.highprecision.MeasureView;
import com.supermap.ar.highprecision.OnLengthChangedListener;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.MapControl;
import com.supermap.plugin.LocationManagePlugin;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.collector.SMCollector;
import com.supermap.track.HPTrack;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class SMeasureView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SMeasureView";

    private static MeasureView mMeasureView = null;

    private String mDatasourceAlias, mDatasetName = null;

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

        LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
        Point2D point2D = new Point2D(gpsDat.dLongitude, gpsDat.dLatitude);
        LocationTransfer.latitudeAndLongitudeToMapCoord(point2D);
        Log.d(REACT_CLASS, "----------------SMeasureView--setInstance--------RN--------point2D:" +
                "X: " +  point2D.getX() + ", Y: " + point2D.getY());
        mMeasureView.setFixedPoint(point2D);

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

    //初始化
    @ReactMethod
    public void initMeasureCollector(String datasourceAlias, String datasetName, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--initMeasureCollector--------RN--------" +
                    "datasourceAlias: " +  datasourceAlias + ", datasetName: " + datasetName );
            mDatasourceAlias = datasourceAlias;
            mDatasetName = datasetName;

            createDataset(datasourceAlias, datasetName);

            if (SMLayer.findLayerByDatasetName(datasetName) == null) {
                Layer layer = SMLayer.addLayerByName(datasourceAlias, datasetName);
                if (layer != null) {
                    layer.setSelectable(true);
                }
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存数据
     */
    @ReactMethod
    public void saveDataset(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--saveDataset--------RN--------");
            if (mMeasureView != null) {
                DatasetVector datasetVector = null;
                MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
                Workspace workspace = mapControl.getMap().getWorkspace();
                Datasource datasource = workspace.getDatasources().get(mDatasourceAlias);
                datasetVector = (DatasetVector) datasource.getDatasets().get(mDatasetName);

                //风格
                GeoStyle geoStyle = new GeoStyle();

                Point2Ds fixedTotalPoints = mMeasureView.getFixedTotalPoints();
                Point2Ds totalPoints = mMeasureView.getTotalPoints();
                Recordset recordset = datasetVector.getRecordset(false, CursorType.DYNAMIC);//动态指针
                if (recordset != null) {
                    //移动指针到最后
                    recordset.moveLast();
                    recordset.edit();//可编辑

                    GeoLine geoLine = new GeoLine();
                    geoLine.addPart(fixedTotalPoints);
                    geoStyle.setLineColor(new Color(70,128,223));
                    geoStyle.setLineWidth(2);
                    geoLine.setStyle(geoStyle);
                    //移动指针到下一位
                    recordset.moveNext();
                    //新增线对象
                    recordset.addNew(geoLine);

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

                    for (int i = 0; i < fixedTotalPoints.getCount(); i++) {
                        //移动指针到下一位
                        recordset.moveNext();

                        Point2D item = fixedTotalPoints.getItem(i);
                        GeoPoint geoPoint = new GeoPoint(item.getX(), item.getY());
                        geoStyle.setMarkerSize(new Size2D(12,12));
                        geoStyle.setLineColor(new Color(255, 0, 0));
                        geoPoint.setStyle(geoStyle);
                        //新增点对象
                        recordset.addNew(geoPoint);

                        //修改属性
                        double dlocation = 0;
                        String str = null;
                        Object ob = null;

                        if (fieldInfos.indexOf("OriginalX") != -1) {
                            ob = recordset.getFieldValue("OriginalX");
                            if (ob != null) {
                                dlocation = Double.parseDouble(ob.toString());
                            }
                            if (totalPoints.getItem(i).getX() != dlocation) {
                                recordset.setFieldValue("OriginalX", totalPoints.getItem(i).getX());
                            }
                        }

                        if (fieldInfos.indexOf("OriginalY") != -1) {
                            ob = recordset.getFieldValue("OriginalY");
                            if (ob != null) {
                                dlocation = Double.parseDouble(ob.toString());
                            }
                            if (totalPoints.getItem(i).getY() != dlocation) {
                                recordset.setFieldValue("OriginalY", totalPoints.getItem(i).getY());
                            }
                        }

                        if (fieldInfos.indexOf("ModifiedDate") != -1) {
                            ob = recordset.getFieldValue("ModifiedDate");
                            if (ob != null) {
                                str = ob.toString();
                            }
                            if (!getCurrentTime().equals(str)) {
                                recordset.setFieldValue("ModifiedDate", getCurrentTime());
                            }
                        }
                    }

                    //保存更新,并释放资源
                    recordset.update();
                    recordset.close();
                    recordset.dispose();
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

    // 修改数据集中指定ID的属性
    private void updatePOIInfo(String UDBName, String DatasetName, POIInfo info) {
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

        if (fieldInfos.indexOf("OriginalX") == -1) {
            addFieldInfo(datasetVector, "OriginalX", FieldType.DOUBLE, false, "", 25);
        }
        if (fieldInfos.indexOf("OriginalY") == -1) {
            addFieldInfo(datasetVector, "OriginalY", FieldType.DOUBLE, false, "", 25);
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

}
