package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.modules.core.RCTNativeAppEventEmitter;
import com.supermap.RNUtils.GPSUtil;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.GeoLine;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.navi.DistanceChangeListener;
import com.supermap.navi.NaviInfo;
import com.supermap.navi.NaviListener;
import com.supermap.navi.Navigation2;
import com.supermap.plugin.LocationManagePlugin;

import java.text.NumberFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

/**
 * Created by will on 2016/7/12.
 */
public class JSNavigation2 extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSNavigation2";
    private static final String DISTANCECHANGE = "com.supermap.RN.JSNavigation2.distance_change";
    private static final String STARTNAVI = "com.supermap.RN.JSNavigation2.start_navi";
    private static final String NAVIINFOUPDATE = "com.supermap.RN.JSNavigation2.navi_info_update";
    private static final String ARRIVEDDESTINATION = "com.supermap.RN.JSNavigation2.arrived_destination";
    private static final String STOPNAVI = "com.supermap.RN.JSNavigation2.stop_navi";
    private static final String ADJUSTFAILURE = "com.supermap.RN.JSNavigation2.adjust_failure";
    private static final String PLAYNAVIMESSAGE = "com.supermap.RN.JSNavigation2.play_navi_massage";
    private final String sdcard= android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();
    ReactContext mReactContext;

    public static Map<String , Navigation2> m_Navigation2List = new HashMap<String , Navigation2>();
    Navigation2 m_Navigation2;

    public JSNavigation2(ReactApplicationContext context){
        super(context);
        mReactContext = context;
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(Navigation2 navigation2){
        for(Map.Entry entry:m_Navigation2List.entrySet())
        {
            if(navigation2.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_Navigation2List.put(id,navigation2);
        return id;
    }

    @ReactMethod
    public void setPathVisible(String navigation2Id, Boolean visible, Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.setPathVisible(visible);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setNetworkDataset(String navigation2Id,String datasetId,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetId);
//            Dataset dataset = JSDataset.m_DatasetList.get(datasetId);
            navigation2.setNetworkDataset(datasetVector);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void loadModel(String navigation2Id,String path,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            boolean loaded = navigation2.loadModel(sdcard + path);
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setStartPoint(String navigation2Id,double x,double y,String mapId,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            com.supermap.mapping.Map map = JSMap.getObjFromList(mapId);
            Point2D beTrans = new Point2D(x,y);
            Point2D totrans = toLatLotSys(beTrans,map);

            navigation2.setStartPoint(totrans.getX(),totrans.getY());
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setDestinationPoint(String navigation2Id,double x,double y,String mapId,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            com.supermap.mapping.Map map = JSMap.getObjFromList(mapId);
            Point2D beTrans = new Point2D(x,y);
            Point2D totrans = toLatLotSys(beTrans,map);

            navigation2.setDestinationPoint(totrans.getX(),totrans.getY());
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void routeAnalyst(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            boolean finished = navigation2.routeAnalyst();

            WritableMap map = Arguments.createMap();
            map.putBoolean("finished",finished);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void startGuide(String navigation2Id,int guideMode,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            boolean isGuiding = navigation2.startGuide(guideMode);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isGuiding",isGuiding);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    public static Point2D toLatLotSys(Point2D beTrans, com.supermap.mapping.Map m_Map){
        PrjCoordSys Prj = m_Map.getPrjCoordSys();
        Point2D toTrans = beTrans;

        // 当投影不是经纬坐标系时，则对点进行投影转换
        if (Prj.getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
            Point2Ds points = new Point2Ds();
            points.add(beTrans);
            PrjCoordSys desPrjCoorSys = new PrjCoordSys();
            desPrjCoorSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            boolean b1 = CoordSysTranslator.convert(points,  Prj,desPrjCoorSys,
                    new CoordSysTransParameter(),
                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

            toTrans = points.getItem(0);
        }
        return toTrans;
    }

    @ReactMethod
    public void setTurnDataset(String navigation2Id,String datasetVectorId,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            navigation2.setTurnDataset(datasetVector);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAltimetricPointDataset(String navigation2Id,String datasetVectorId,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            navigation2.setDatasetPoint(datasetVector);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getRoute(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            GeoLine geoLine = navigation2.getRoute();
            String geoLineId = JSGeoLine.registerId(geoLine);

            WritableMap map = Arguments.createMap();
            map.putString("geoLineId",geoLineId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void cleanPath(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.cleanPath();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void pauseGuide(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.pauseGuide();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void resumeGuide(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.resumeGuide();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void stopGuide(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            boolean stoped = navigation2.stopGuide();

            WritableMap map = Arguments.createMap();
            map.putBoolean("stoped",stoped);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isGuiding(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            boolean yes = navigation2.isGuiding();

            WritableMap map = Arguments.createMap();
            map.putBoolean("yes",yes);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void enablePanOnGuide(String navigation2Id,boolean pan,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.enablePanOnGuide(pan);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void locateMap(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.locateMap();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setIsAutoNavi(String navigation2Id,boolean isAutoNavi,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.setIsAutoNavi(isAutoNavi);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setGPSData(String navigation2Id, ReadableMap newGps, Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            LocationManagePlugin.GPSData gpsData = GPSUtil.convertToGPSData(newGps);
            navigation2.setGPSData(gpsData);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSpeedField(String navigation2Id, String value, Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.setSpeedField(value);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getBarrierPoints(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            Point2Ds point2Ds = navigation2.getBarrierPoints();
            WritableArray array = JsonUtil.point2DsToJson(point2Ds);

            WritableMap map = Arguments.createMap();
            map.putArray("barrierPoints",array);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setBarrierNodes(String navigation2Id,ReadableArray value,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            int [] barrierNodes = null;
            for(int i = 0;i < value.size();i++){
                barrierNodes[i] = value.getInt(i);
            }
            navigation2.setBarrierNodes(barrierNodes);
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setBarrierEdges(String navigation2Id,ReadableArray value,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            int [] barrierEdges = null;
            for(int i = 0;i < value.size();i++){
                barrierEdges[i] = value.getInt(i);
            }
            navigation2.setBarrierEdges(barrierEdges);
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getBarrierEdges(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            int[] barrierEdges = navigation2.getBarrierEdges();
            WritableArray array = Arguments.createArray();
            for(int i = 0; i < barrierEdges.length; i++){
                array.pushInt(barrierEdges[i]);
            }

            WritableMap map = Arguments.createMap();
            map.putArray("barrierEdges",array);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setDistanceChangeListener(String navigation2Id,Promise promise){
        try{
            Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.setDistanceChangeListener(new DistanceChangeListener() {
                @Override
                public void distanceChange(double v) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("distance",v);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(DISTANCECHANGE,map);
                }
            });
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addNaviInfoListener(String navigation2Id,Promise promise){
        try{
            final Navigation2 navigation2 = m_Navigation2List.get(navigation2Id);
            navigation2.addNaviInfoListener(new NaviListener() {
                @Override
                public void onNaviInfoUpdate(NaviInfo naviInfo) {
                    try{
                        WritableMap map = JsonUtil.naviInfoToJson(naviInfo);
                        mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(NAVIINFOUPDATE,map);
                    }catch (Exception e){
                        System.out.print("NaviInfo Error.");
                    }
                }

                @Override
                public void onStartNavi() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(STARTNAVI,null);
                }

                @Override
                public void onAarrivedDestination() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(ARRIVEDDESTINATION,null);
                }

                @Override
                public void onStopNavi() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(STOPNAVI,null);
                }

                @Override
                public void onAdjustFailure() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(ADJUSTFAILURE,null);
                }

                @Override
                public void onPlayNaviMessage(String s) {
                    WritableMap map = Arguments.createMap();
                    map.putString("message",s);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(PLAYNAVIMESSAGE,map);
                }
            });
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
