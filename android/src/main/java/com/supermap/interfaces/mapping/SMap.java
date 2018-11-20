package com.supermap.interfaces.mapping;

import android.view.GestureDetector;
import android.view.MotionEvent;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.data.*;
import com.supermap.data.Enum;
import com.supermap.data.Maps;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Resources;
import com.supermap.data.Workspace;
import com.supermap.mapping.Action;
import com.supermap.mapping.GeometrySelectedEvent;
import com.supermap.mapping.GeometrySelectedListener;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Layers;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MeasureListener;
import com.supermap.mapping.collector.Collector;
import com.supermap.rnsupermap.JSLayer;
import com.supermap.smNative.SMMapWC;
import com.supermap.smNative.SMSymbol;

import java.util.ArrayList;
import java.util.Map;

public class SMap extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SMap";
    private static SMap sMap;
    private static ReactApplicationContext context;
    private static MeasureListener mMeasureListener;
    private GestureDetector mGestureDetector;
    private GeometrySelectedListener mGeometrySelectedListener;

    private SMMapWC smMapWC;

    public SMap(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static SMap getInstance() {
        if (sMap == null) {
            sMap = new SMap(context);
        }
        return sMap;
    }

    public static SMap getInstance(ReactApplicationContext context) {
        if (sMap == null) {
            sMap = new SMap(context);
        }
        return sMap;
    }

    public static void setInstance(MapControl mapControl) {
        sMap = getInstance();
        if (sMap.smMapWC == null) {
            sMap.smMapWC = new SMMapWC();
        }
        sMap.smMapWC.setMapControl(mapControl);
        if (sMap.smMapWC.getWorkspace() == null) {
            sMap.smMapWC.setWorkspace(new Workspace());
        }
    }

    public static SMMapWC getSMWorkspace() {
        return getInstance().smMapWC;
    }

    /**
     * 打开工作空间
     *
     * @param data
     * @param promise
     */
    @ReactMethod
    public void openWorkspace(ReadableMap data, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            boolean result = sMap.smMapWC.openWorkspace(params);
            if (result) {
                sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());
            }
            sMap.smMapWC.getMapControl().getMap().setVisibleScalesEnabled(false);
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 以数据源形式打开工作空间
     *
     * @param data
     * @param defaultIndex 默认显示Map 图层索引
     * @param promise
     */
    @ReactMethod
    public void openDatasourceWithIndex(ReadableMap data, int defaultIndex, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            Datasource datasource = sMap.smMapWC.openDatasource(params);
            sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());

            if (datasource != null && defaultIndex >= 0) {
                Dataset ds = datasource.getDatasets().get(defaultIndex);
                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                map.getLayers().add(ds, true);
            }
            sMap.smMapWC.getMapControl().getMap().setVisibleScalesEnabled(false);
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 打开离线UDB数据
     *
     * @param data
     * @param defaultIndex 默认显示Map 图层索引
     * @param promise
     */
    @ReactMethod
    public void openUDBDatasourceWithIndex(ReadableMap data, int defaultIndex, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();
            datasourceconnection.setEngineType(EngineType.UDB);
            if (params.containsKey("server")) {
                datasourceconnection.setServer(params.get("server").toString());
            }
            String alias = params.get("alias").toString();
            if (sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().indexOf(alias) != -1) {
                sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().close(alias);
            }
            datasourceconnection.setAlias(alias);
            datasourceconnection.setPassword("");
            Datasource datasource = sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().open(datasourceconnection);


            if (datasource != null && defaultIndex >= 0) {
                Dataset ds = datasource.getDatasets().get(defaultIndex);
                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                map.getLayers().add(ds, true);
            }
            sMap.smMapWC.getMapControl().getMap().setVisibleScalesEnabled(false);
            sMap.smMapWC.getMapControl().getMap().refresh();

            datasourceconnection.dispose();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存工作空间
     * @param promise
     */
    @ReactMethod
    public void saveWorkspace(Promise promise) {
        try {
            sMap = getInstance();
            boolean result = sMap.smMapWC.saveWorkspace();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据工作空间连接信息保存工作空间
     * @param data
     * @param promise
     */
    @ReactMethod
    public void saveWorkspaceWithInfo(Map data, Promise promise) {
        try {
            sMap = getInstance();
            boolean result = sMap.smMapWC.saveWorkspaceWithInfo(data);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取UDB中数据集名称
     *  @param path UDB在内存中路径
     * @param promise
     */
    @ReactMethod
    public void getUDBName(String path, Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();
            if (sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().indexOf("switchudb") != -1) {
                sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().close("switchudb");
            }
            datasourceconnection.setEngineType(EngineType.UDB);
            datasourceconnection.setServer(path);
            datasourceconnection.setAlias("switchudb");
            Datasource datasource = sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().open(datasourceconnection);
            Datasets datasets = datasource.getDatasets();
            int count = datasets.getCount();

            WritableArray arr = Arguments.createArray();
            for (int i=0;i<count;i++){
                Dataset dataset = datasets.get(i);
                String name = dataset.getName();
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("title",name);
                arr.pushMap(writeMap);
            }
            datasourceconnection.dispose();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }



    /**
     * 移除指定图层
     *
     * @param defaultIndex 默认显示Map 图层索引
     * @param promise
     */
    @ReactMethod
    public void removeLayerWithIndex(int defaultIndex, Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().getMap().getLayers().remove(defaultIndex);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 以数据源形式打开工作空间
     *
     * @param data
     * @param defaultName 默认显示Map 图层名称
     * @param promise
     */
    @ReactMethod
    public void openDatasourceWithName(ReadableMap data, String defaultName, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            Datasource datasource = sMap.smMapWC.openDatasource(params);
            sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());

            if (datasource != null && defaultName.equals("")) {
                Dataset ds = datasource.getDatasets().get(defaultName);
                sMap.smMapWC.getMapControl().getMap().getLayers().add(ds, true);
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据名字显示图层
     *
     * @param name
     * @param viewEntire
     * @param center
     * @param promise
     */
    @ReactMethod
    public void openMapByName(String name, boolean viewEntire, ReadableMap center, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();

            if (maps.getCount() > 0) {
                String mapName = name;

                if (name.equals("")) {
                    mapName = maps.get(0);
                }

                map.open(mapName);

                if (viewEntire) {
                    map.viewEntire();
                }

                if (center.hasKey("x") && center.hasKey("y")) {
                    Double x = center.getDouble("x");
                    Double y = center.getDouble("y");
                    Point2D point2D = new Point2D(x, y);
                    map.setCenter(point2D);
                }

                sMap.smMapWC.getMapControl().setAction(Action.PAN);
                map.setVisibleScalesEnabled(false);
                map.refresh();
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据序号显示图层
     *
     * @param index
     * @param viewEntire
     * @param center
     * @param promise
     */
    @ReactMethod
    public void openMapByIndex(int index, boolean viewEntire, ReadableMap center, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();

            if (maps.getCount() > 0) {
                String name = maps.get(index);
                map.open(name);

                if (viewEntire) {
                    map.viewEntire();
                }

                if (center.hasKey("x") && center.hasKey("y")) {
                    Double x = center.getDouble("x");
                    Double y = center.getDouble("y");
                    Point2D point2D = new Point2D(x, y);
                    map.setCenter(point2D);
                }

                sMap.smMapWC.getMapControl().setAction(Action.PAN);
                map.setVisibleScalesEnabled(false);
                map.refresh();

                promise.resolve(true);
            } else {
                promise.reject("没有地图");
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭工作空间及地图控件
     *
     * @param promise
     */
    @ReactMethod
    public void closeWorkspace(Promise promise) {
        try {
            getCurrentActivity().runOnUiThread(new DisposeThread(promise));
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭地图
     *
     * @param promise
     */
    @ReactMethod
    public void closeMap(Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            com.supermap.mapping.Map map = mapControl.getMap();

            map.close();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    class DisposeThread implements Runnable {

        private Promise promise;

        public DisposeThread(Promise promise) {
            this.promise = promise;
        }

        @Override
        public void run() {
            try {
                sMap = getInstance();
                MapControl mapControl = sMap.smMapWC.getMapControl();
                Workspace workspace = sMap.smMapWC.getWorkspace();
                com.supermap.mapping.Map map = mapControl.getMap();

                map.close();
                map.dispose();
                mapControl.dispose();
                workspace.close();
                workspace.dispose();

                sMap.smMapWC.setMapControl(null);
                sMap.smMapWC.setWorkspace(null);
                promise.resolve(true);
            } catch (Exception e) {
                promise.resolve(e);
            }
        }
    }

    @ReactMethod
    public void setAction(int actionType, Promise promise) {
        try {
            sMap = getInstance();
            Action action = (Action) Enum.parse(Action.class, actionType);
            sMap.smMapWC.getMapControl().setAction(action);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void undo(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().undo();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void redo(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().redo();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addMeasureListener(Promise promise) {
        try {
            sMap = getInstance();
            mMeasureListener = new MeasureListener() {
                @Override
                public void lengthMeasured(double curResult, Point curPoint) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curResult", curResult);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MEASURE_LENGTH, map);
                }

                @Override
                public void areaMeasured(double curResult, Point curPoint) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curResult", curResult);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MEASURE_AREA, map);
                }

                @Override
                public void angleMeasured(double curAngle, Point curPoint) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curAngle", curAngle);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MEASURE_ANGLE, map);
                }
            };

            sMap.smMapWC.getMapControl().addMeasureListener(mMeasureListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeMeasureListener(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().removeMeasureListener(mMeasureListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 放大缩小
     * @param scale
     * @param promise
     */
    @ReactMethod
    public void zoom(double scale, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            map.zoom(scale);
            map.refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void submit(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().submit();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移动到当前位置
     * @param promise
     */
    @ReactMethod
    public void moveToCurrent(Promise promise) {
        try {
            MoveToCurrentThread moveToCurrentThread = new MoveToCurrentThread(promise);
            moveToCurrentThread.run();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    class MoveToCurrentThread implements Runnable {

        private Promise promise;

        public MoveToCurrentThread(Promise promise) {
            this.promise = promise;
        }

        @Override
        public void run() {
            try {
                sMap = getInstance();
                MapControl mapControl = sMap.smMapWC.getMapControl();
                Collector collector = mapControl.getCollector();

                collector.openGPS();
                Point2D point2D = new Point2D(collector.getGPSPoint());
                if (mapControl.getMap().getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
                    Point2Ds point2Ds = new Point2Ds();
                    point2Ds.add(point2D);
                    PrjCoordSys prjCoordSys = new PrjCoordSys();
                    prjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                    CoordSysTransParameter parameter = new CoordSysTransParameter();

                    CoordSysTranslator.convert(point2Ds, prjCoordSys, mapControl.getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                    point2D = point2Ds.getItem(0);
                }

                mapControl.getMap().setCenter(point2D);
                mapControl.getMap().refresh();
                promise.resolve(true);
            } catch (Exception e) {
                promise.resolve(e);
            }
        }
    }

    /**
     * 监听长按动作和滚动动作
     *
     * @param promise
     */
    @ReactMethod
    public void setGestureDetector(final Promise promise) {
        try {
            mGestureDetector = new GestureDetector(context, new GestureDetector.SimpleOnGestureListener() {

                public boolean onScroll(MotionEvent e1, MotionEvent e2,
                                        float distanceX, float distanceY) {
                    WritableMap mapE1 = Arguments.createMap();
                    mapE1.putInt("x", (int) e1.getX());
                    mapE1.putInt("y", (int) e1.getY());

                    WritableMap mapE2 = Arguments.createMap();
                    mapE2.putInt("x", (int) e2.getX());
                    mapE2.putInt("y", (int) e2.getY());

                    WritableMap map = Arguments.createMap();
                    map.putMap("start", mapE1);
                    map.putMap("end", mapE2);
                    map.putDouble("dx", distanceX);
                    map.putDouble("dy", distanceY);


                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_SCROLL, map);
                    return false;
                }

                public boolean onDown(MotionEvent event) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) event.getX());
                    map.putInt("y", (int) event.getY());

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_TOUCH_BEGAN, map);
                    return false;
                }

                public boolean onSingleTapUp(MotionEvent e) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) e.getX());
                    map.putInt("y", (int) e.getY());

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_SINGLE_TAP, map);
                    return false;
                }

                public void onLongPress(MotionEvent event) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) event.getX());
                    map.putInt("y", (int) event.getY());

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_LONG_PRESS, map);
                }

                public boolean onSingleTapConfirmed(MotionEvent e) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) e.getX());
                    map.putInt("y", (int) e.getY());

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_SINGLE_TAP, map);
                    return false;
                }

                public boolean onDoubleTap(MotionEvent e) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) e.getX());
                    map.putInt("y", (int) e.getY());

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_DOUBLE_TAP, map);
                    return false;
                }
            });
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.setGestureDetector(mGestureDetector);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteGestureDetector(Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.deleteGestureDetector();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addGeometrySelectedListener(Promise promise) {
        try {
            mGeometrySelectedListener = new GeometrySelectedListener() {
                @Override
                public void geometrySelected(GeometrySelectedEvent event) {
                    int id = event.getGeometryID();
                    Layer layer = event.getLayer();
                    String layerId = JSLayer.registerId(layer);

                    WritableMap map = Arguments.createMap();
                    map.putString("layerId", layerId);
                    map.putInt("id", id);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_GEOMETRY_SELECTED, map);
                }

                @Override
                public void geometryMultiSelected(ArrayList<GeometrySelectedEvent> events) {
                    WritableArray array = Arguments.createArray();
                    for (int i = 0; i < events.size(); i++) {
                        GeometrySelectedEvent event = events.get(i);
                        int id = event.getGeometryID();
                        Layer layer = event.getLayer();
                        String layerId = JSLayer.registerId(layer);

                        WritableMap map = Arguments.createMap();
                        map.putString("layerId", layerId);
                        map.putInt("id", id);
                        array.pushMap(map);
                    }

                    WritableMap geometries = Arguments.createMap();
                    geometries.putArray("geometries", array);
                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_GEOMETRY_MULTI_SELECTED, geometries);
                }
            };
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometrySelectedListener(Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.removeGeometrySelectedListener(mGeometrySelectedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 指定编辑几何对象
     *
     * @param geoID
     * @param layerName
     * @param promise
     */
    @ReactMethod
    public void appointEditGeometry(int geoID, String layerName, Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            Layer layer = mapControl.getMap().getLayers().get(layerName);
            boolean result = mapControl.appointEditGeometry(geoID, layer);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定SymbolGroup中所有的group
     * @param type
     * @param path
     * @param promise
     */
    @ReactMethod
    public void getSymbolGroups(String type, String path, Promise promise) {
        try {
            sMap = getInstance();
            Resources resources = sMap.smMapWC.getWorkspace().getResources();
            WritableArray groups = SMSymbol.getSymbolGroups(resources, type, path);

            promise.resolve(groups);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定SymbolGroup中所有的symbol
     * @param type
     * @param path
     * @param promise
     */
    @ReactMethod
    public void findSymbolsByGroups(String type, String path, Promise promise) {
        try {
            sMap = getInstance();
            Resources resources = sMap.smMapWC.getWorkspace().getResources();
            WritableArray symbols = SMSymbol.findSymbolsByGroups(resources, type, path);

            promise.resolve(symbols);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取图层标题列表及对应的数据集类型
     * @param promise
     */
    @ReactMethod
    public void getLayersNames(Promise promise){
        try{
            sMap = getInstance();
            Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
            int count = layers.getCount();
            WritableArray arr = Arguments.createArray();
            for (int i=0;i<count;i++){
                //获取图层标题（区别于图层的名称）
                String caption = layers.get(i).getCaption();
                WritableMap writeMap = Arguments.createMap();

                //获取数据集类型
                DatasetType type = layers.get(i).getDataset().getType();
                String datasetType = "";
                if (type == DatasetType.POINT) {
                    datasetType = "POINT";
                }
                else if (type == DatasetType.LINE) {
                    datasetType = "LINE";
                }
                else if (type == DatasetType.REGION) {
                    datasetType = "REGION";
                }
                else if (type == DatasetType.GRID) {
                    datasetType = "GRID";
                }
                else if (type == DatasetType.TEXT) {
                    datasetType = "TEXT";
                }
                else if (type == DatasetType.IMAGE) {
                    datasetType = "IMAGE";
                }
                else {
                    datasetType = type.toString();
                }

                writeMap.putString("title",caption);
                writeMap.putString("datasetType",datasetType);
                arr.pushMap(writeMap);
            }
            promise.resolve(arr);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
