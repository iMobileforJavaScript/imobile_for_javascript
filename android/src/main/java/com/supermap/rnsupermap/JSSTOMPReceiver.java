package com.supermap.rnsupermap;

import android.os.Message;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.messagequeue.STOMPReceiver;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/16.
 */

public class JSSTOMPReceiver extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSTOMPReceiver";
    public static Map<String,STOMPReceiver> mReceiverList=new HashMap<String,STOMPReceiver>();
    STOMPReceiver mReceiver;

    public JSSTOMPReceiver(ReactApplicationContext context){super(context);}

    public static String registerId(STOMPReceiver receiver){
        if(!mReceiverList.isEmpty()) {
            for(Map.Entry entry:mReceiverList.entrySet()){
                if(receiver.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mReceiverList.put(id,receiver);
        return id;
    }

    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void receiveMessage(String receiverId, Promise promise){
        try{
            android.os.Handler myHandler = new android.os.Handler();

            mReceiver = mReceiverList.get(receiverId);
            new Thread(new Runnable() {
                @Override
                public void run() {
                    String message = mReceiver.receive();
                }
            }).start();
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String receiverId, Promise promise){
        try{
            mReceiver = mReceiverList.get(receiverId);
            mReceiverList.remove(receiverId);
            mReceiver.dispose();
            promise.resolve("dispose");
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
