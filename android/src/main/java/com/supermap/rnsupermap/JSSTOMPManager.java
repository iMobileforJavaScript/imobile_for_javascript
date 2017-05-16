package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.messagequeue.STOMPManager;
import com.supermap.messagequeue.STOMPReceiver;
import com.supermap.messagequeue.STOMPSender;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/16.
 */

public class JSSTOMPManager extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSTOMPManager";
    public static Map<String,STOMPManager> mManagerList=new HashMap<String,STOMPManager>();
    STOMPManager mManager;

    public JSSTOMPManager(ReactApplicationContext context){super(context);}

    public static String registerId(STOMPManager manager){
        if(!mManagerList.isEmpty()) {
            for(Map.Entry entry:mManagerList.entrySet()){
                if(manager.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mManagerList.put(id,manager);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            STOMPManager manager = new STOMPManager();
            String _STOMPManagerId = registerId(manager);

            WritableMap map = Arguments.createMap();
            map.putString("_STOMPManagerId",_STOMPManagerId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void initializeLibrary(Promise promise){
        try{
            STOMPManager.initializeLibrary();
            promise.resolve("init");
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void shutdownLibrary(Promise promise){
        try{
            STOMPManager.shutdownLibrary();
            promise.resolve("shutdown");
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void newSender(String managerId,boolean  useTopic,String name,Promise promise){
        try{
            STOMPManager manager = mManagerList.get(managerId);
            STOMPSender sender = manager.newSender(useTopic,name);
            String senderId = JSSTOMPSender.registerId(sender);

            WritableMap map = Arguments.createMap();
            map.putString("STOMPSenderId",senderId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void newReceiver(String managerId,boolean  useTopic,String name,String clientID,Promise promise){
        try{
            STOMPManager manager = mManagerList.get(managerId);
            STOMPReceiver receiver = manager.newReceiver(useTopic,name,clientID);
            String receiverId = JSSTOMPReceiver.registerId(receiver);

            WritableMap map = Arguments.createMap();
            map.putString("STOMPReceiverId",receiverId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void connection(String managerId,String  URI,String name,String password,Promise promise){
        try{
            STOMPManager manager = mManagerList.get(managerId);
            boolean isConnection = manager.connection(URI,name,password);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isConnection",isConnection);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void disconnection(String managerId,Promise promise){
        try{
            STOMPManager manager = mManagerList.get(managerId);
            manager.disconnection();

            promise.resolve("disconnection");
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
