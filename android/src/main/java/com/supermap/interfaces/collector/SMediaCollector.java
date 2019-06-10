package com.supermap.interfaces.collector;

import android.view.MotionEvent;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.RNUtils.DateUtil;
import com.supermap.RNUtils.MediaUtil;
import com.supermap.component.MapWrapView;
import com.supermap.containts.EventConst;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CursorType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasource;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.interfaces.utils.SMFileUtil;
import com.supermap.mapping.CallOut;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMMapWC;
import com.supermap.smNative.collector.SMMedia;
import com.supermap.smNative.collector.SMMediaCollector;
import com.supermap.smNative.components.InfoCallout;

import org.apache.http.cookie.SM;

import java.text.DateFormat;
import java.text.FieldPosition;
import java.text.ParsePosition;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @Author: shanglongyang
 * Date:        2019/5/17
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class SMediaCollector extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SMediaCollector";
    private static SMediaCollector collector = null;
    private static ReactApplicationContext context;
    private static Layer mediaLayer;
    private static View.OnTouchListener calloutListner;

    public SMediaCollector(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static View.OnTouchListener getCalloutListner() {
        if (calloutListner == null) {
            calloutListner = new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                    switch (motionEvent.getAction()) {
                        case MotionEvent.ACTION_UP: {
                            InfoCallout infoCallout = (InfoCallout)view;

                            WritableMap data = getCalloutData(infoCallout);

                            context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                    .emit(EventConst.MEDIA_CAPTURE_TAP_ACTION, data);
                            break;
                        }
                    }

                    return true;
                }
            };
        }
        return calloutListner;
    }

    public static WritableMap getCalloutData(InfoCallout infoCallout) {
        Point2D pt = new Point2D(infoCallout.getLocationX(), infoCallout.getLocationY());
        return getCalloutData(infoCallout.getID(), infoCallout.getLayerName(), infoCallout.getGeoID(), pt);
    }

    public static WritableMap getCalloutData(String id, String layerName, int geoID, Point2D pt) {
        Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();

        WritableArray medium = Arguments.createArray();

        Layer tapLayer = SMLayer.findLayerWithName(layerName);
        DatasetVector dv = (DatasetVector) tapLayer.getDataset();

        QueryParameter qp = new QueryParameter();
        qp.setAttributeFilter("SmID=" + geoID);
        qp.setCursorType(CursorType.STATIC);
        Recordset recordset = dv.query(qp);

        if (pt == null) {
            pt = recordset.getGeometry().getInnerPoint();
        }
        if (map.getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
            Point2Ds points = new Point2Ds();
            points.add(pt);
            PrjCoordSys desPrjCoorSys = new PrjCoordSys();
            desPrjCoorSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            CoordSysTranslator.convert(points, desPrjCoorSys, map.getPrjCoordSys(),
                    new CoordSysTransParameter(),
                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

            pt.setX(points.getItem(0).getX());
            pt.setY(points.getItem(0).getY());
        }

        WritableMap point = Arguments.createMap();
        point.putDouble("x", pt.getX());
        point.putDouble("y", pt.getY());

        String modifiedDate = recordset.getString("ModifiedDate");
        String mediaFileName = recordset.getString("MediaFileName");
        String httpAddress = recordset.getString("HttpAddress");
        String description = recordset.getString("Description");

        String mediaFilePaths = recordset.getString("MediaFilePaths");
        WritableArray paths = Arguments.createArray();
        String[] pathArr = mediaFilePaths.split(",");
        for (String path : pathArr) {
//                                if (path.indexOf("file://") != 0) {
//                                    path = "file://" + path;
//                                }
            paths.pushString(path);
        }

        recordset.dispose();

        WritableMap data = Arguments.createMap();
        data.putString("id", id);
        data.putMap("coordinate", point);
        data.putString("layerName", layerName);
        data.putInt("geoID", geoID);
        data.putArray("medium", medium);
        data.putString("modifiedDate", modifiedDate);
        data.putString("mediaFileName", mediaFileName);
        data.putArray("mediaFilePaths", paths);
        data.putString("httpAddress", httpAddress);
        data.putString("description", description);

        return data;
    }

    @ReactMethod
    public void initMediaCollector(String path, Promise promise) {
        try {
            SMMediaCollector collector = SMMediaCollector.getInstance();
            collector.setMediaPath(path);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 把拍摄后的结果添加到数据集中
     * @param info
     * @param addToMap
     * @param promise
     */
    @ReactMethod
    public void addMedia(ReadableMap info, boolean addToMap, Promise promise) {
        try {
            boolean result = false;
            SMMediaCollector collector = SMMediaCollector.getInstance();

            if (collector == null || collector.getMediaPath().equals("")) {
                promise.resolve(new Error("MediaCollector should be initialized"));
            } else {
                MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
                String datasourceName = info.getString("datasourceName");
                String datasetName = info.getString("datasetName");
                ReadableArray sourcePaths = info.getArray("mediaPaths");

                String mediaName = new Date().getTime() + "";
                if (sourcePaths.size() > 0) {
                    mediaName = sourcePaths.getString(0).substring(
                            sourcePaths.getString(0).lastIndexOf("/") + 1,
                            sourcePaths.getString(0).lastIndexOf(".")
                            );
                }
                SMMedia media = new SMMedia(mediaName);

                Datasource ds = mapControl.getMap().getWorkspace().getDatasources().get(datasourceName);
                if (media.setMediaDataset(ds, datasetName)) {
                    if (addToMap) {
                        mediaLayer = SMLayer.findLayerByDatasetName(datasetName);

                        if (mediaLayer == null) {
                            mediaLayer = SMLayer.addLayerByName(datasourceName, datasetName);
                        }
                        ArrayList<String> paths = new ArrayList<>();
                        for (int i = 0; i < sourcePaths.size(); i++) {
                            paths.add(sourcePaths.getString(i));
                        }
                        result = media.saveMedia(paths, collector.getMediaPath(), true);

                        addCallout(media, mediaLayer);
                    }
                }
                promise.resolve(result);
            }

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void saveMediaByLayer(String layerName, int geoID, String toPath, ReadableArray fieldInfos, Promise promise) {
        try {
            Layer layer = SMLayer.findLayerWithName(layerName);

            boolean saveResult = saveMedia(layer, geoID, toPath, fieldInfos);

            promise.resolve(saveResult);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void saveMediaByDataset(String datasetName, int geoID, String toPath, ReadableArray fieldInfos, Promise promise) {
        try {
            Layer layer = SMLayer.findLayerByDatasetName(datasetName);

            boolean saveResult = saveMedia(layer, geoID, toPath, fieldInfos);

            promise.resolve(saveResult);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    public boolean saveMedia(Layer layer, int geoID, String toPath, ReadableArray fieldInfos) {
        try {
            WritableArray infos = Arguments.createArray();
            SMMedia media = SMMediaCollector.findMediaByLayer(layer, geoID);

            for (int i = 0; i < fieldInfos.size(); i++) {
                WritableMap dic = Arguments.createMap();
                dic.putString("name", fieldInfos.getMap(i).getString("name"));
                if (dic.getString("name").equals("MediaFilePaths")) {
                    String mediaPaths = "";
                    ReadableArray files = fieldInfos.getMap(i).getArray("value");

                    if (files.size() > 0) {
                        ArrayList<String> fileArr = new ArrayList<>();
                        for (int j = 0; j < files.size(); j++) {
                            fileArr.add(files.getString(j));
                        }

                        media.saveMedia(fileArr, toPath, false);
                        ArrayList<String> paths = media.getPaths();
                        for (int j = 0; j < paths.size(); j++) {
                            mediaPaths += paths.get(j) + (j == paths.size() - 1 ? "" : ",");
                        }
                    }

                    dic.putString("value", mediaPaths);
                } else {
                    // TODO 根据类型来存储数据，目前除了MediaFilePaths，都是字符串
                    dic.putString("value", fieldInfos.getMap(i).getString("value"));
                }
                infos.pushMap(dic);
            }


            boolean saveResult = false;
            if (media.getPaths() != null) {
                WritableMap params = Arguments.createMap();
                String filter = "SmID=" + geoID;
                params.putString("filter", filter);
                saveResult = SMLayer.setLayerFieldInfo(layer, infos, params);
            }

            return saveResult;
        } catch (Exception e) {
            throw e;
        }
    }

    private void addCallout(SMMedia media, Layer layer) {
        if (layer != null) {
            Recordset rs = ((DatasetVector)layer.getDataset()).getRecordset(false, CursorType.DYNAMIC);
            rs.moveLast();

            SMMediaCollector.addCalloutByMedia(getReactApplicationContext(), media, rs, layer.getName(), getCalloutListner());

            rs.dispose();
        }
    }

    private void addCalloutsByLayer(Layer layer) {
        if (layer != null) {
            SMMediaCollector.addMediasByLayer(getReactApplicationContext(), layer, getCalloutListner());
        }
    }

    @ReactMethod
    public void removeMedias(Promise promise) {
        try {
            SMap.getInstance().getActivity().runOnUiThread(new Runnable(){
                @Override
                public void run(){
                MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

                mapControl.getMap().getMapView().removeAllCallOut();
                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void showMedia(String layerName, Promise promise) {
        try {
            Layer layer = SMLayer.findLayerWithName(layerName);
            if (layer != null) {
                SMMediaCollector.addMediasByLayer(getReactApplicationContext(), layer, getCalloutListner());
                promise.resolve(true);
            } else {
                promise.reject(new Error("The layer is not exist"));
            }

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void hideMedia(final String layerName, Promise promise) {
        try {
            SMap.getInstance().getActivity().runOnUiThread(new Runnable(){
                @Override
                public void run(){
                    MapWrapView mapView = (MapWrapView)SMap.getInstance().getSmMapWC().getMapControl().getMap().getMapView();

                    List<CallOut> callouts = mapView.getCallouts();

                    for (int i = 0; i < callouts.size(); i++) {
                        InfoCallout callout = (InfoCallout)callouts.get(i);
                        if (callout.getLayerName().equals(layerName)) {
                            mapView.removeCallOut(callout.getID());
                        }
                    }
                }
            });

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getVideoInfo(String path, Promise promise) {
        try {
            WritableMap info = MediaUtil.getScreenShotImage(getReactApplicationContext(), path);
            int duration = MediaUtil.getVideoDuration(path);

            duration = new Double(duration / 1000).intValue();
            info.putInt("duration", duration);

            promise.resolve(info);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMediaInfo(String layerName, int geoID, Promise promise) {
        try {
            WritableMap data = getCalloutData(layerName + "-" + geoID, layerName, geoID, null);

            if (data != null) {
                promise.resolve(data);
            } else {
                promise.reject(new Error("Can not find this media"));
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}
