package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.messagequeue.MQTTClient;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/16.
 */

public class JSMQTTClientSide extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSMQTTClientSide";
    public static Map<String,MQTTClient> mClientList=new HashMap<String,MQTTClient>();
    MQTTClient mClient;

    public JSMQTTClientSide(ReactApplicationContext context){super(context);}

    public static String registerId(MQTTClient client){
        if(!mClientList.isEmpty()) {
            for(Map.Entry entry:mClientList.entrySet()){
                if(client.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mClientList.put(id,client);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            MQTTClient client = new MQTTClient();
            String _MQTTClientSideId = registerId(client);

            WritableMap map = Arguments.createMap();
            map.putString("_MQTTClientSideId",_MQTTClientSideId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void create(String clientSideId,String URI,String userName,String password,String clientId,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            boolean isConnection = mClient.create(URI,userName,password,clientId);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isConnection",isConnection);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void sendMessage(String clientSideId,String topic,String message,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            boolean isSent = mClient.sendMessage(topic,message);

            WritableMap map = Arguments.createMap();
            map.putBoolean("send",isSent);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void receiveMessage(String clientSideId,String topic,String message,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            boolean isSent = mClient.sendMessage(topic,message);

            WritableMap map = Arguments.createMap();
            map.putBoolean("send",isSent);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void subscribe(String clientSideId,String topic,int qos,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            boolean isSubscribe = mClient.subscribe(topic,qos);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isSubscribe",isSubscribe);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void unsubscribe(String clientSideId,String topic,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            boolean unSubscribe = mClient.unsubscribe(topic);

            WritableMap map = Arguments.createMap();
            map.putBoolean("unSubscribe",unSubscribe);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void suspend(String clientSideId,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            mClient.suspend();

            promise.resolve("suspend");
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void resume(String clientSideId,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            mClient.resume();

            promise.resolve("resume");
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String clientSideId,Promise promise){
        try{
            mClient = mClientList.get(clientSideId);
            mClientList.remove(clientSideId);
            mClient.dispose();

            promise.resolve("dispose");
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
