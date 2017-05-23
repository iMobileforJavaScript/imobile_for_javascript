package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.messagequeue.STOMPSender;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/16.
 */

public class JSSTOMPSender extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSTOMPSender";
    public static Map<String,STOMPSender> mSenderList=new HashMap<String,STOMPSender>();
    STOMPSender mSender;

    public JSSTOMPSender(ReactApplicationContext context){super(context);}

    public static String registerId(STOMPSender sender){
        if(!mSenderList.isEmpty()) {
            for(Map.Entry entry:mSenderList.entrySet()){
                if(sender.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mSenderList.put(id,sender);
        return id;
    }

    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void sendMessage(String senderId,String message, Promise promise){
        try{

            mSender = mSenderList.get(senderId);
            boolean sent = mSender.sendMessage(message);
            promise.resolve(sent);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String senderId,Promise promise){
        try{

            mSender = mSenderList.get(senderId);
            mSenderList.remove(senderId);
            mSender.dispose();
            promise.resolve("dispose");
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
