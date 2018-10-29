package com.supermap.interfaces;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.data.Dataset;
import com.supermap.data.Datasource;
import com.supermap.data.Maps;
import com.supermap.data.Point2D;
import com.supermap.data.Workspace;
import com.supermap.mapping.Action;
import com.supermap.mapping.MapControl;
import com.supermap.smNative.SMWorkspace;

import java.util.Map;

public class SMap extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SMap";
    private static SMap sMap;
    private static ReactApplicationContext context;

    private SMWorkspace smWorkspace;
    private MapControl mapControl;

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
        if (sMap.smWorkspace == null) {
            sMap.smWorkspace = new SMWorkspace();
        }
        sMap.smWorkspace.setMapControl(mapControl);
        if (sMap.smWorkspace.getWorkspace() == null) {
            sMap.smWorkspace.setWorkspace(new Workspace());
        }
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
            boolean result = sMap.smWorkspace.openWorkspace(params);

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
            Datasource datasource = sMap.smWorkspace.openDatasource(params);
            sMap.smWorkspace.getMapControl().getMap().setWorkspace(sMap.smWorkspace.getWorkspace());

            if (datasource != null && defaultIndex >= 0) {
                Dataset ds = datasource.getDatasets().get(defaultIndex);
                sMap.smWorkspace.getMapControl().getMap().getLayers().add(ds, true);
            }

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
            Datasource datasource = sMap.smWorkspace.openDatasource(params);
            sMap.smWorkspace.getMapControl().getMap().setWorkspace(sMap.smWorkspace.getWorkspace());

            if (datasource != null && defaultName.equals("")) {
                Dataset ds = datasource.getDatasets().get(defaultName);
                sMap.smWorkspace.getMapControl().getMap().getLayers().add(ds, true);
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
            com.supermap.mapping.Map map = sMap.smWorkspace.getMapControl().getMap();
            Maps maps = sMap.smWorkspace.getWorkspace().getMaps();

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

                sMap.smWorkspace.getMapControl().setAction(Action.PAN);
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
            com.supermap.mapping.Map map = sMap.smWorkspace.getMapControl().getMap();
            Maps maps = sMap.smWorkspace.getWorkspace().getMaps();

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

                sMap.smWorkspace.getMapControl().setAction(Action.PAN);
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

    class DisposeThread implements Runnable {

        private Promise promise;

        public DisposeThread(Promise promise) {
            this.promise = promise;
        }

        @Override
        public void run() {
            try {
                sMap = getInstance();
                sMap.smWorkspace.getMapControl().dispose();
                sMap.smWorkspace.getWorkspace().close();
                sMap.smWorkspace.getWorkspace().dispose();

                sMap.smWorkspace.setMapControl(null);
                sMap.smWorkspace.setWorkspace(null);
                promise.resolve(true);
            } catch (Exception e) {
                promise.resolve(e);
            }
        }
    }
}
