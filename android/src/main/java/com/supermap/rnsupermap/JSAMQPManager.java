package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.messagequeue.AMQPManager;
import com.supermap.messagequeue.AMQPReceiver;
import com.supermap.messagequeue.AMQPSender;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/15.
 */

public class JSAMQPManager extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSAMQPManager";
    public static Map<String,AMQPManager> mManagerList=new HashMap<String,AMQPManager>();
    AMQPManager mManager;

    public JSAMQPManager(ReactApplicationContext context){super(context);}

    public static String registerId(AMQPManager manager){
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
            AMQPManager manager = new AMQPManager();
            String _AMQPManagerId = registerId(manager);

            WritableMap map = Arguments.createMap();
            map.putString("_AMQPManagerId",_AMQPManagerId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void newReceiver(String managerId,String queueName,Promise promise){
        try{
            mManager = mManagerList.get(managerId);
            AMQPReceiver receiver = mManager.newReceiver(queueName);
            String receiverId = JSAMQPReceiver.registerId(receiver);

            WritableMap map = Arguments.createMap();
            map.putString("AMQPReceiverId",receiverId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void newSender(String managerId,Promise promise){
        try{
            mManager = mManagerList.get(managerId);
            AMQPSender sender = mManager.newSender();
            String senderId = JSAMQPSender.registerId(sender);

            WritableMap map = Arguments.createMap();
            map.putString("AMQPSenderId",senderId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void connection(String managerId, ReadableMap jsonObject, Promise promise){
        try{
            mManager = mManagerList.get(managerId);
            String ip = jsonObject.getString("IP");
            int port = jsonObject.getInt("Port");
            String hostName = jsonObject.getString("HostName");
            String userName = jsonObject.getString("UserName");
            String passWord = jsonObject.getString("PassWord");
            String clientId = jsonObject.getString("ClientId");
            boolean isConnection = mManager.connection(ip,port,hostName,userName,passWord,clientId);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isConnection",isConnection);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void disconnection(String managerId, Promise promise){
        try{
            mManager = mManagerList.get(managerId);
            mManager.disconnection();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
