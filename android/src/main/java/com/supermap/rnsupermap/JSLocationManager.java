package com.supermap.rnsupermap;

import android.content.Context;
import android.location.LocationManager;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.RNUtils.GPSUtil;
import com.supermap.plugin.LocationChangedListener;
import com.supermap.plugin.LocationManagePlugin;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSLocationManager extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLocationManager";
    protected static Map<String, LocationManagePlugin> m_LocationManagePluginList = new HashMap<String, LocationManagePlugin>();
    LocationManagePlugin m_LocationManagePlugin;

    private static final String LOCATIONCHANGED_EVENT = "com.supermap.RN.JSLocationManager.location_changed_event";
    private static final String LONGPRESS_EVENT = "com.supermap.RN.JSLocationManager.location_changed_event";

    ReactApplicationContext mContext;

    public JSLocationManager(ReactApplicationContext context) {
        super(context);
        mContext = context;
    }

    public static LocationManagePlugin getObjFromList(String id) {
        return m_LocationManagePluginList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(LocationManagePlugin obj) {
        for (Map.Entry entry : m_LocationManagePluginList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_LocationManagePluginList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            LocationManagePlugin locationManagePlugin = new LocationManagePlugin();
            String locationManagePluginId = registerId(locationManagePlugin);

            WritableMap map = Arguments.createMap();
            map.putString("_locationManagePluginId_",locationManagePluginId);

            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 打开设备GPS
     * @param locationManagePluginId
     * @param promise
     */
    @ReactMethod
    public void openGpsDevice(String locationManagePluginId, Promise promise){
        try{
            LocationManager locationManager = (LocationManager) mContext.getSystemService(Context.LOCATION_SERVICE);
            LocationManagePlugin locationManagePlugin = getObjFromList(locationManagePluginId);
            locationManagePlugin.openGpsDevice(locationManager);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 关闭设备GPS
     * @param locationManagePluginId
     * @param promise
     */
    @ReactMethod
    public void closeGpsDevice(String locationManagePluginId, Promise promise){
        try{
            LocationManagePlugin locationManagePlugin = getObjFromList(locationManagePluginId);
            locationManagePlugin.closeGpsDevice();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 监听GPS坐标变化
     * @param locationManagerId
     * @param promise
     */
    @ReactMethod
    public void getLocationInfo(String locationManagerId,Promise promise){
        try{
            LocationManagePlugin locationManagePlugin = getObjFromList(locationManagerId);
            locationManagePlugin.addLocationChangedListener(new LocationChangedListener() {
                @Override
                public void locationChanged(LocationManagePlugin.GPSData gpsData, LocationManagePlugin.GPSData gpsData1) {
                }

                @Override
                public void locationChanged(LocationManagePlugin.GPSData gpsData,
                                            LocationManagePlugin.GPSData gpsData1, boolean b) {
                    WritableMap map = parseLocationParameters(gpsData,gpsData1,b);
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(LOCATIONCHANGED_EVENT,map);
                }
            });

        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 组合返回的卫星信息，并转换成JSON格式。
     * @param oldGps
     * @param newGps
     * @param b
     * @return
     */
    private WritableMap parseLocationParameters(LocationManagePlugin.GPSData oldGps,
                                                LocationManagePlugin.GPSData newGps, boolean b) {
        WritableMap oldGpsMap = GPSUtil.parseGps(oldGps);
        WritableMap newGpsMap = GPSUtil.parseGps(newGps);

        WritableMap map = Arguments.createMap();
        map.putMap("oldGps",oldGpsMap);
        map.putMap("newGps",newGpsMap);
        map.putBoolean("isGPSPointValid",b);

        return map;
    }

}

