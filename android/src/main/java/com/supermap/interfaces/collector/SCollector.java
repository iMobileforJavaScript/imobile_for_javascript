package com.supermap.interfaces.collector;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.GeoStyle;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Action;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.Layers;
import com.supermap.mapping.collector.Collector;
import com.supermap.plugin.LocationManagePlugin;
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
            SMMapWC smMapWC = SMap.getSMWorkspace();
            collector = smMapWC.getMapControl().getCollector();
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
            String style = data.getString("style");

            if (data.hasKey("layerPath") && !data.getString("layerPath").equals("")) {
                String layerPath = data.getString("layerPath");
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
                    Layers layers = smMapWC.getMapControl().getMap().getLayers();
                    for (int i = 0; i < layers.getCount(); i++) {
                        Layer _layer = layers.get(i);
                        String[] nameArr = _layer.getName().split("@");
                        if (nameArr[0].equals(name)) {
                            layer = _layer;
                            break;
                        }
                    }
//                    layer = smMapWC.getMapControl().getMap().getLayers().get(name + "@" + datasourceName);
                }
                if (layer == null) {
                    // 若该采集图层没有被添加到地图上，则把以前的采集对象清除
                    ds = smMapWC.addDatasetByName(name, type, datasourceName, datasourcePath);
                    Recordset recordset = ((DatasetVector)ds).getRecordset(false, CursorType.DYNAMIC);
                    recordset.deleteAll();
                    recordset.dispose();
                    layer = smMapWC.getMapControl().getMap().getLayers().add(ds, true);
                    resetPrj = true;
                } else {
                    ds = layer.getDataset();
                }
            }

            GeoStyle geoStyle = null;
            if (style != null && !style.equals("")) {
                geoStyle = new GeoStyle();
                geoStyle.fromJson(style);
                geoStyle.setMarkerSize(new Size2D(6,6));
              //  geoStyle.setLineWidth(15);
                ((LayerSettingVector)layer.getAdditionalSetting()).setStyle(geoStyle);
            }

            if (layer != null) {

                if (resetPrj) ds.setPrjCoordSys( SMap.getSMWorkspace().getMapControl().getMap().getPrjCoordSys());
//                if (resetPrj) ds.setPrjCoordSys(new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE));

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
            SMap sMap = SMap.getInstance();
            sMap.getSMWorkspace().getMapControl().getMap().refresh();

            LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
            Point2D pt =  new Point2D(gpsDat.dLongitude,gpsDat.dLatitude);
            if (sMap.getSMWorkspace().getMapControl().getMap().getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
                Point2Ds point2Ds = new Point2Ds();
                point2Ds.add(pt);
                PrjCoordSys prjCoordSys = new PrjCoordSys();
                prjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                CoordSysTransParameter parameter = new CoordSysTransParameter();

                CoordSysTranslator.convert(point2Ds, prjCoordSys, sMap.getSMWorkspace().getMapControl().getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                pt = point2Ds.getItem(0);
            }
            boolean result = collector.addGPSPoint(pt);//SMCollector.addGPSPoint(collector);

            if (result) {
                WritableMap point = Arguments.createMap();
                point.putDouble("x", pt.getX());
                point.putDouble("y", pt.getY());
                promise.resolve(point);
            } else {
                promise.resolve(null);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取GPS点
     * @param promise
     */
    @ReactMethod
    public void getGPSPoint(Promise promise) {
        try {
            collector = getCollector();
            SMap sMap = SMap.getInstance();
            sMap.getSMWorkspace().getMapControl().getMap().refresh();

            LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
            Point2D pt =  new Point2D(gpsDat.dLongitude,gpsDat.dLatitude);
            if (sMap.getSMWorkspace().getMapControl().getMap().getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
                Point2Ds point2Ds = new Point2Ds();
                point2Ds.add(pt);
                PrjCoordSys prjCoordSys = new PrjCoordSys();
                prjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                CoordSysTransParameter parameter = new CoordSysTransParameter();

                CoordSysTranslator.convert(point2Ds, prjCoordSys, sMap.getSMWorkspace().getMapControl().getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                pt = point2Ds.getItem(0);
            }

            WritableMap point = Arguments.createMap();
            point.putDouble("x", pt.getX());
            point.putDouble("y", pt.getY());
            promise.resolve(point);
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
            if (type == SCollectorType.LINE_HAND_PATH || type == SCollectorType.REGION_HAND_PATH || type == -1 || type==SCollectorType.REGION_HAND_POINT || type==SCollectorType.LINE_HAND_POINT|| type==SCollectorType.POINT_HAND) {
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
            if (type == SCollectorType.LINE_HAND_PATH || type == SCollectorType.REGION_HAND_PATH || type == -1 || type==SCollectorType.REGION_HAND_POINT || type==SCollectorType.LINE_HAND_POINT|| type==SCollectorType.POINT_HAND) {
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
            if (type == SCollectorType.LINE_HAND_PATH || type == SCollectorType.REGION_HAND_PATH || type == -1 || type==SCollectorType.REGION_HAND_POINT || type==SCollectorType.LINE_HAND_POINT|| type==SCollectorType.POINT_HAND) {
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
                promise.resolve(true);
            } else {
                startCollect(type, promise);
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
         //   collector = getCollector();
            SMCollector.openGPS( context);
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
//            collector = getCollector();
            SMCollector.closeGPS();
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
            recordset.dispose();
            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 删除对象
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void removeByIds(ReadableArray ids, String layerPath, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(layerPath);
            Recordset recordset = layer.getSelection().toRecordset();

            boolean result = true;
            for (int i = 0; i < ids.size(); i++) {
                recordset.seekID(ids.getInt(i));
                result = result && recordset.delete();
            }

            recordset.dispose();
            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
