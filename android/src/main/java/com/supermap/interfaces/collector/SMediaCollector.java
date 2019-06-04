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

    public SMediaCollector(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
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
            ArrayList<String> copyPaths = null;

            WritableArray infos = Arguments.createArray();

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
                            mediaPaths += files.getString(j) + (j == files.size() - 1 ? "" : ",");
                        }
                        copyPaths = SMFileUtil.copyFiles(fileArr, toPath);
                    }

                    dic.putString("value", mediaPaths);
                } else {
                    // TODO 根据类型来存储数据，目前除了MediaFilePaths，都是字符串
                    dic.putString("value", fieldInfos.getMap(i).getString("value"));
                }
                infos.pushMap(dic);
            }


            boolean saveResult = false;
            if (copyPaths != null) {
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

//            double longitude = Double.parseDouble(rs.getFieldValue("SmX").toString());
//            double latitude = Double.parseDouble(rs.getFieldValue("SmY").toString());
            double longitude = rs.getGeometry().getInnerPoint().getX();
            double latitude = rs.getGeometry().getInnerPoint().getY();

            final InfoCallout callout = SMLayer.addCallOutWithLongitude(getReactApplicationContext(), longitude, latitude, media.getPaths().get(0));
            callout.setMediaFileName(media.getFileName());
            callout.setMediaFilePaths(media.getPaths());
//            callout.setType(media.getMediaType());
            callout.setLayerName(layer.getName());
            callout.setHttpAddress("");
            callout.setDescription("");

            String date = DateUtil.formatDateToString(new Date(), "yyyy-MM-dd HH:mm:ss");
            callout.setModifiedDate(date);
            callout.setGeoID(Integer.parseInt(rs.getFieldValue("SmID").toString()));

            rs.edit();

            rs.setFieldValue("ModifiedDate", callout.getModifiedDate());
            rs.setFieldValue("HttpAddress", callout.getHttpAddress());
            rs.setFieldValue("Description", callout.getDescription());

            String paths = "";
            for (int i = 0; i < callout.getMediaFilePaths().size(); i++) {
                paths += callout.getMediaFilePaths().get(i);
                if (i < callout.getMediaFilePaths().size() - 1) {
                    paths += ",";
                }
            }
            rs.setFieldValue("MediaFilePaths", paths);

            rs.update();
            rs.dispose();

            callout.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                switch (motionEvent.getAction()) {
                    case MotionEvent.ACTION_UP: {
                        InfoCallout infoCallout = (InfoCallout)view;
                        Point2D pt = new Point2D(infoCallout.getLocationX(), infoCallout.getLocationY());
                        Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
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

                        WritableArray medium = Arguments.createArray();

                        Layer tapLayer = SMLayer.findLayerWithName(callout.getLayerName());
                        DatasetVector dv = (DatasetVector) tapLayer.getDataset();

                        QueryParameter qp = new QueryParameter();
                        qp.setAttributeFilter("SmID=" + callout.getGeoID());
                        qp.setCursorType(CursorType.STATIC);
                        Recordset recordset = dv.query(qp);

                        String modifiedDate = recordset.getString("ModifiedDate");
                        String mediaFileName = recordset.getString("MediaFileName");
                        String httpAddress = recordset.getString("HttpAddress");
                        String description = recordset.getString("Description");

                        String mediaFilePaths = recordset.getString("MediaFilePaths");
                        WritableArray paths = Arguments.createArray();
                        String[] pathArr = mediaFilePaths.split(",");
                        for (String path : pathArr) {
                            if (path.indexOf("file://") != 0) {
                                path = "file://" + path;
                            }
                            paths.pushString(path);
                        }

                        recordset.dispose();

                        WritableMap data = Arguments.createMap();
                        data.putMap("coordinate", point);
                        data.putString("layerName", callout.getLayerName());
                        data.putInt("geoID", callout.getGeoID());
                        data.putArray("medium", medium);
                        data.putString("modifiedDate", modifiedDate);
                        data.putString("mediaFileName", mediaFileName);
                        data.putArray("mediaFilePaths", paths);
                        data.putString("httpAddress", httpAddress);
                        data.putString("description", description);
//                        data.putString("type", callout.getType());

                        context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit(EventConst.MEDIA_CAPTURE_TAP_ACTION, data);
                        break;
                    }
                }

                return true;
                }
            });
        }
    }

    @ReactMethod
    public void hideMedia(Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            mapControl.getMap().getMapView().removeAllCallOut();
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
}
