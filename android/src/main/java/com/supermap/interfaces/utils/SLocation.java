package com.supermap.interfaces.utils;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.util.Log;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.plugin.LocationManagePlugin;

import org.json.JSONObject;

public class SLocation  extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SLocation";
    private static ReactApplicationContext context;

    private static AMapLocationClient locationClient = null;

    private static String deviceName = "local";
    private static Boolean isOpenExternalGPS = false;
    private static Boolean isSerachingDevice = false;
    private static BroadcastReceiver mExReceiver = null;

    private static LocationManagePlugin.GPSData m_gpsData = new LocationManagePlugin.GPSData();

    private static final String NOTIFICATION_CHANNEL_NAME = "BackgroundLocation";
    private static NotificationManager notificationManager = null;
    private static boolean  isCreateChannel = false;

    public SLocation(ReactApplicationContext context) {
        super(context);
        this.context = context;
        openGPS();
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }


    @ReactMethod
    public void setDeviceName(String deviceName, Promise promise) {
        SLocation.deviceName = deviceName;
        promise.resolve(true);
    }

    @ReactMethod
    public void searchDevice(Boolean isSearch, Promise promise) {
        isSerachingDevice = isSearch;
        promise.resolve(true);
    }

    @ReactMethod
    public void openGPS(Promise promise) {
        try {
            openGPS();
            promise.resolve(true);
        } catch(Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void closeGPS(Promise promise) {
        try {
            closeGPS();
            promise.resolve(true);
        } catch(Exception e) {
            promise.reject(e);
        }
    }

    public static void openGPS() {
        initGPS(context);
        if(deviceName.equals("local")) {
            openLocalGPS();
        } else {
            openExternalGPS();
        }
    }

    public static void closeGPS() {
        if(deviceName.equals("local")) {
            closeLocalGPS();
        } else {
            closeExternalGPS();
        }
    }

    public static LocationManagePlugin.GPSData getGPSPoint(){
        LocationManagePlugin.GPSData data = new LocationManagePlugin.GPSData();
        data.dLatitude = m_gpsData.dLatitude;
        data.dLongitude = m_gpsData.dLongitude ;
        data.dAccuracy = m_gpsData.dAccuracy ;
        data.dAltitude = m_gpsData.dAltitude ;
        data.dSpeed = m_gpsData.dSpeed ;
        data.dBearing = m_gpsData.dBearing;
        return  data;
    }

    private static void openLocalGPS() {
        locationClient.startLocation();
    }

    private static void openExternalGPS() {
        isOpenExternalGPS = true;
    }

    private static void closeLocalGPS() {
        locationClient.stopLocation();
    }

    private static void closeExternalGPS() {
        isOpenExternalGPS = false;
    }

    private static void initGPS(Context context) {
        //本地
        if (locationClient == null) {
            AMapLocationClient.setApiKey("078057f0e29931c173ad8ec02284a897");
            locationClient = new AMapLocationClient(context);
            locationClient.setLocationListener(new AMapLocationListener() {
                @Override
                public void onLocationChanged(AMapLocation aMapLocation) {
                    if (aMapLocation != null) {

                        if (aMapLocation.getErrorCode() == 0) {
                            m_gpsData.dLatitude = aMapLocation.getLatitude();
                            m_gpsData.dLongitude = aMapLocation.getLongitude();
                            m_gpsData.dAccuracy = aMapLocation.getAccuracy();
                            m_gpsData.dAltitude = aMapLocation.getAltitude();
                            m_gpsData.dSpeed = aMapLocation.getSpeed();
                            m_gpsData.dBearing = aMapLocation.getBearing();
                            // eventEmitter.emit("AMapGeolocation", toReadableMap(location));
                        }
                        Log.v("xzy",m_gpsData.dLatitude+" "+m_gpsData.dLongitude);
                        // TODO: 返回定位错误信息
                    }
                }
            });

            AMapLocationClientOption option = new AMapLocationClientOption();
            option.setInterval(2000);
            option.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
            locationClient.setLocationOption(option);
            locationClient.enableBackgroundLocation(2000, buildNotification(context));
            Log.v("xzy","GPS init");
        }

        //外部
        if(mExReceiver == null) {
            mExReceiver = new BroadcastReceiver() {
                @Override
                public void onReceive(Context context, Intent intent) {
                    try {
                        String info =  intent.getExtras().getString("info");
                        JSONObject jsonObject = new JSONObject(info);
                        String device;
                        if(jsonObject.has("deviceName")) {
                            device = jsonObject.getString("deviceName");
                            if(isSerachingDevice) {
                                SLocation.context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(EventConst.LOCATION_SEARCH_DEVICE, device);
                            }
                            String deviceFullName = "external_" + device;
                            if(deviceFullName.equals(deviceName) && isOpenExternalGPS) {
                                m_gpsData.dLatitude = jsonObject.getDouble("latitude");
                                m_gpsData.dLongitude = jsonObject.getDouble("longitude");
                                if(jsonObject.has("altitude")) {
                                    m_gpsData.dAltitude = jsonObject.getDouble("altitude");
                                }
                                if(jsonObject.has("speed")) {
                                    m_gpsData.dSpeed = jsonObject.getDouble("speed");
                                }

                                Log.d("external_gps", "onReceive: " + m_gpsData.dLatitude + ", " + m_gpsData.dLongitude);
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            };
            IntentFilter intentFilter = new IntentFilter();
            intentFilter.addAction(EventConst.LOCATION_LISTEN_EXTERNAL);
            context.registerReceiver(mExReceiver, intentFilter);
        }
    }

    private static Notification buildNotification(Context context) {

        Notification.Builder builder = null;
        Notification notification = null;
        if(android.os.Build.VERSION.SDK_INT >= 26) {
            //Android O上对Notification进行了修改，如果设置的targetSDKVersion>=26建议使用此种方式创建通知栏
            if (null == notificationManager) {
                notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            }
            String channelId = context.getPackageName();
            if(!isCreateChannel) {
                NotificationChannel notificationChannel = new NotificationChannel(channelId,
                        NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT);
                notificationChannel.enableLights(true);//是否在桌面icon右上角展示小圆点
                notificationChannel.setLightColor(Color.BLUE); //小圆点颜色
                notificationChannel.setShowBadge(true); //是否在久按桌面图标时显示此渠道的通知
                notificationManager.createNotificationChannel(notificationChannel);
                isCreateChannel = true;
            }
            builder = new Notification.Builder(context, channelId);
        } else {
            builder = new Notification.Builder(context);
        }
        builder.setSmallIcon(0)
                .setContentTitle("iTablet")
                .setContentText("正在后台运行")
                .setWhen(System.currentTimeMillis());

        if (android.os.Build.VERSION.SDK_INT >= 16) {
            notification = builder.build();
        } else {
            return builder.getNotification();
        }
        return notification;
    }
}
