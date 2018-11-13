package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.RNUtils.GPSUtil;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.GeoLine;
import com.supermap.data.Point2D;
import com.supermap.navi.DistanceChangeListener;
import com.supermap.navi.NaviInfo;
import com.supermap.navi.NaviListener;
import com.supermap.navi.NaviPath;
import com.supermap.navi.Navigation;
import com.supermap.navi.Navigation2;
import com.supermap.plugin.LocationManagePlugin;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSNavigation extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSNavigation";
    protected static Map<String, Navigation> m_NavigationList = new HashMap<String, Navigation>();
    private final String sdcard= android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();

    private static final String STARTNAVI = "com.supermap.RN.JSNavigation2.start_navi";
    private static final String NAVIINFOUPDATE = "com.supermap.RN.JSNavigation2.navi_info_update";
    private static final String ARRIVEDDESTINATION = "com.supermap.RN.JSNavigation2.arrived_destination";
    private static final String STOPNAVI = "com.supermap.RN.JSNavigation2.stop_navi";
    private static final String ADJUSTFAILURE = "com.supermap.RN.JSNavigation2.adjust_failure";
    private static final String PLAYNAVIMESSAGE = "com.supermap.RN.JSNavigation2.play_navi_massage";
    ReactContext mReactContext;
    Navigation m_Navigation;

    public JSNavigation(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    public static Navigation getObjFromList(String id) {
        return m_NavigationList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Navigation obj) {
        for (Map.Entry entry : m_NavigationList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_NavigationList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void connectNaviData(String traditionalNaviId, String dataPath, Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            boolean success = navigation.connectNaviData(sdcard + dataPath);

            WritableMap map = Arguments.createMap();
            map.putBoolean("success",success);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void routeAnalyst(String traditionalNaviId, int mode, Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            int result = navigation.routeAnalyst(mode);

            WritableMap map = Arguments.createMap();
            map.putInt("result",result);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setStartPoint(String traditionalNaviId,double x,double y,String mapId,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            com.supermap.mapping.Map map = JSMap.getObjFromList(mapId);

            Point2D beTrans = new Point2D(x,y);
            Point2D totrans = JSNavigation2.toLatLotSys(beTrans,map);
            navigation.setStartPoint(totrans.getX(),totrans.getY());

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setDestinationPoint(String traditionalNaviId,double x,double y,String mapId,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            com.supermap.mapping.Map map = JSMap.getObjFromList(mapId);

            Point2D beTrans = new Point2D(x,y);
            Point2D totrans = JSNavigation2.toLatLotSys(beTrans,map);
            navigation.setDestinationPoint(totrans.getX(),totrans.getY());

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void startGuide(String traditionalNaviId,int status,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);

            boolean guiding = navigation.startGuide(status);

            WritableMap map = Arguments.createMap();
            map.putBoolean("guiding",guiding);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addWayPoint(String traditionalNaviId,double x,double y,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);

            boolean added = navigation.addWayPoint(x,y);

            WritableMap map = Arguments.createMap();
            map.putBoolean("added",added);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void stopGuide(String traditionalNaviId,double x,double y,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);

            boolean stopped = navigation.stopGuide();

            WritableMap map = Arguments.createMap();
            map.putBoolean("stopped",stopped);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSpeechParam(String traditionalNaviId,boolean speech,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            Navigation.SpeechParam speechParam = new Navigation.SpeechParam();
            speechParam.bRoadDirection = speech;
            navigation.setSpeechParam(speechParam);

            boolean speak = navigation.stopGuide();

            WritableMap map = Arguments.createMap();
            map.putBoolean("speak",speak);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setGPSData(String traditionalNaviId, ReadableMap gpsData, Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            LocationManagePlugin.GPSData gps = GPSUtil.convertToGPSData(gpsData);
            navigation.setGPSData(gps);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void locateMap(String traditionalNaviId, Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            navigation.locateMap();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isGuiding(String traditionalNaviId, Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            boolean guiding = navigation.isGuiding();

            WritableMap map = Arguments.createMap();
            map.putBoolean("guiding",guiding);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getTimeToDestination(String traditionalNaviId, double speed, Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            int time = navigation.getTimeToDestination(speed);

            WritableMap map = Arguments.createMap();
            map.putInt("time",time);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getRoute(String traditionalNaviId, Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            GeoLine geoLine = navigation.getRoute();
            String geoLineId = JSGeoLine.registerId(geoLine);

            WritableMap map = Arguments.createMap();
            map.putString("geoLineId",geoLineId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void enablePanOnGuide(String traditionalNaviId,boolean bPan,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            navigation.enablePanOnGuide(bPan);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void cleanPath(String traditionalNaviId,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            navigation.cleanPath();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getNaviPath(String traditionalNaviId,Promise promise){
        try{
            Navigation navigation = getObjFromList(traditionalNaviId);
            NaviPath naviPath = navigation.getNaviPath();
            WritableMap map = JsonUtil.naviPathToJson(naviPath);

            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addNaviInfoListener(String navigation2Id,Promise promise){
        try{
            final Navigation navigation = m_NavigationList.get(navigation2Id);
            navigation.addNaviInfoListener(new NaviListener() {
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

