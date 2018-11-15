package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.services.FeatureSet;
import com.supermap.services.ResponseCallback;
import com.supermap.services.ServiceBase;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSServiceBase extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSServiceBase";
    protected static Map<String, ServiceBase> m_ServiceBaseList = new HashMap<String, ServiceBase>();
    ServiceBase m_ServiceBase;
    private static final String REQUESTFAILED = "com.supermap.services.ServiceBase.requestFailed";
    private static final String REQUESTSUCCESS = "com.supermap.services.ServiceBase.requestSuccess";
    private static final String RECEIVERESPONSE = "com.supermap.services.ServiceBase.receiveResponse";
    private static final String DATASERVICEFINISHED = "com.supermap.services.ServiceBase.dataServiceFinished";

    ReactApplicationContext mReactContext;

    public JSServiceBase(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    public static ServiceBase getObjFromList(String id) {
        return m_ServiceBaseList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(ServiceBase obj) {
        for (Map.Entry entry : m_ServiceBaseList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ServiceBaseList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void getUrl(String serviceBaseId,Promise promise){
        try{
            ServiceBase serviceBase = getObjFromList(serviceBaseId);
            String url = serviceBase.getUrl();

            WritableMap map = Arguments.createMap();
            map.putString("url",url);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setUrl(String serviceBaseId,String url,Promise promise){
        try{
            ServiceBase serviceBase = getObjFromList(serviceBaseId);
            serviceBase.setUrl(url);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setServerName(String serviceBaseId,String serverName,Promise promise){
        try{
            ServiceBase serviceBase = getObjFromList(serviceBaseId);
            serviceBase.setServerName(serverName);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setResponseCallback(String serviceBaseId,Promise promise){
        try{
            ServiceBase serviceBase = getObjFromList(serviceBaseId);
            serviceBase.setResponseCallback(new ResponseCallback() {
                @Override
                public void addFeatureSuccess(int var1) {
                    //为解决编译问题暂时添加的空方法
                }

                @Override
                public void requestFailed(String s) {
                    WritableMap map = Arguments.createMap();
                    map.putString("error",s);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(REQUESTFAILED,map);
                }

                @Override
                public void requestSuccess() {
                    WritableMap map = Arguments.createMap();
                    map.putString("success","success");
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(REQUESTSUCCESS,map);
                }

                @Override
                public void receiveResponse(FeatureSet featureSet) {
                    String featureSetId = JSFeatureSet.registerId(featureSet);

                    WritableMap map = Arguments.createMap();
                    map.putString("_featureSetId",featureSetId);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(RECEIVERESPONSE,map);
                }

                @Override
                public void dataServiceFinished(String s) {
                    WritableMap map = Arguments.createMap();
                    map.putString("finish",s);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(DATASERVICEFINISHED,map);
                }
            });

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}

