package com.supermap.interfaces.collector;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.data.Dataset;
import com.supermap.data.GeoStyle;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Recordset;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Action;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.Map;
import com.supermap.mapping.collector.Collector;
import com.supermap.smNative.SMCollector;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMMapWC;

public class SCollector extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SCollector";
    private static Collector collector = null;
    private static ReactApplicationContext context;

    public SCollector(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public Collector getCollector() {
        try {
            if (collector == null) {
                SMMapWC smMapWC = SMap.getSMWorkspace();
                collector = smMapWC.getMapControl().getCollector();
            }
            return collector;
        } catch (Exception e) {
            throw e;
        }
    }

    /**
     * 设置采集对象的绘制风格
     *
     * @param styleJson
     * @param promise
     */
    @ReactMethod
    public void setStyle(String styleJson, Promise promise) {
        try {
            collector = getCollector();
            GeoStyle style = new GeoStyle();
            style.fromJson(styleJson);

            collector.setStyle(style);

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的绘制风格
     *
     * @param promise
     */
    @ReactMethod
    public void getStyle(Promise promise) {
        try {
            collector = getCollector();
            GeoStyle style = collector.getStyle();
            String styleJson = style.toJson();

            promise.resolve(styleJson);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置用于存储采集数据的数据集，若数据源不可用，则自动创建
     * @param data
     * @param promise
     */
    @ReactMethod
    public void setDataset(ReadableMap data, Promise promise) {
        try {
            SMMapWC smMapWC = SMap.getSMWorkspace();
            collector = getCollector();

            Dataset ds;
            Layer layer = null;
            Boolean resetPrj = false;
            String layerPath = data.getString("layerPath");
            String style = data.getString("style");

            if (layerPath != null || !layerPath.equals("")) {
                layer = SMLayer.findLayerByPath(layerPath);
                ds = layer.getDataset();
            } else {
                String name = data.getString("datasetName");
                int type = data.getInt("datasetType");
                String datasourceName = "Collection";
                if (data.getString("datasourceName") != null && !data.getString("datasourceName").equals("")) {
                    datasourceName = data.getString("datasourceName");
                } else if (!smMapWC.getMapControl().getMap().getName().equals("")) {
                    datasourceName = smMapWC.getMapControl().getMap().getName();
                }
                String datasourcePath = data.getString("datasourcePath");

                if (!name.equals("")) {
                    layer = smMapWC.getMapControl().getMap().getLayers().get(name + "@" + datasourceName);
                }
                if (layer == null) {
                    ds = smMapWC.addDatasetByName(name, type, datasourceName, datasourcePath);
                    layer = smMapWC.getMapControl().getMap().getLayers().add(ds, true);
                    resetPrj = true;
                } else {
                    ds = layer.getDataset();
                }
            }

            GeoStyle geoStyle = null;
            if (style != null) {
                geoStyle = new GeoStyle();
                geoStyle.fromJson(style);
                ((LayerSettingVector)layer.getAdditionalSetting()).setStyle(geoStyle);
            }

            if (layer != null) {

                if (resetPrj) ds.setPrjCoordSys(new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE));

                layer.setVisible(true);
                layer.setEditable(true);
                collector.setDataset(ds);
                promise.resolve(true);
            } else {
                promise.resolve(false);
            }

        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 指定采集方式，并采集对象
     *
     * @param type
     * @param promise
     */
    @ReactMethod
    public void startCollect(int type, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            collector = getCollector();

            boolean result = SMCollector.setCollector(collector, sMap.getSMWorkspace().getMapControl(), type);

            promise.resolve(result);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 停止采集
     * @param promise
     */
    @ReactMethod
    public void stopCollect(Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            collector = getCollector();
            collector.setSingleTapEnable(false);
            sMap.getSMWorkspace().getMapControl().setAction(Action.PAN);

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 添加点,GPS获取的点
     * @param promise
     */
    @ReactMethod
    public void addGPSPoint(Promise promise) {
        try {
            collector = getCollector();
            boolean result = SMCollector.addGPSPoint(collector);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 回退操作
     * @param type
     * @param promise
     */
    @ReactMethod
    public void undo(int type, Promise promise) {
        try {
            if (type == SCollectorType.LINE_HAND_PATH || type == SCollectorType.REGION_HAND_PATH || type == -1) {
                SMap.getSMWorkspace().getMapControl().undo();
            } else {
                collector = getCollector();
                collector.undo();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 重做操作
     * @param type
     * @param promise
     */
    @ReactMethod
    public void redo(int type, Promise promise) {
        try {
            if (type == SCollectorType.LINE_HAND_PATH || type == SCollectorType.REGION_HAND_PATH || type == -1) {
                SMap.getSMWorkspace().getMapControl().redo();
            } else {
                collector = getCollector();
                collector.redo();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 提交
     * @param type
     * @param promise
     */
    @ReactMethod
    public void submit(int type, Promise promise) {
        try {
            if (type == SCollectorType.LINE_HAND_PATH || type == SCollectorType.REGION_HAND_PATH || type == -1) {
                SMap.getSMWorkspace().getMapControl().submit();
            } else {
                collector = getCollector();
                collector.submit();
            }
            SMap.getSMWorkspace().getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 取消
     * @param type
     * @param promise
     */
    @ReactMethod
    public void cancel(int type, Promise promise) {
        try {
            SMap.getSMWorkspace().getMapControl().cancel();
            if (type == SCollectorType.REGION_HAND_PATH || type == SCollectorType.LINE_HAND_PATH || type == -1) {
                startCollect(type, promise);
            } else {
                promise.resolve(true);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 打开GPS定位
     * @param promise
     */
    @ReactMethod
    public void openGPS(Promise promise) {
        try {
            collector = getCollector();
            SMCollector.openGPS(collector, context);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭GPS
     * @param promise
     */
    @ReactMethod
    public void closeGPS(Promise promise) {
        try {
            collector = getCollector();
            SMCollector.closeGPS(collector);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 删除对象
     * @param id
     * @param promise
     */
    @ReactMethod
    public void remove(int id, String layerPath, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(layerPath);
            Recordset recordset = layer.getSelection().toRecordset();
            recordset.seekID(id);
            boolean result = recordset.delete();
            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
