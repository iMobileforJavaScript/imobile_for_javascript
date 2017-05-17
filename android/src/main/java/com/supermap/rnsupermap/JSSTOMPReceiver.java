package com.supermap.rnsupermap;

import android.os.Handler;
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
    public void receive(String receiverId, final Promise promise){
        try{
            mReceiver = mReceiverList.get(receiverId);

            final Handler myHandler = new Handler(){
                @Override
                public void handleMessage(Message msg){
                    String message = (String) msg.obj;

                    WritableMap map = Arguments.createMap();
                    map.putString("message",message);
                    promise.resolve(map);
                }
            };

            new Thread(new Runnable() {
                @Override
                public void run() {
                    String returnMessage = mReceiver.receive();
                    if (returnMessage != null){
                        Message msg = Message.obtain();
                        msg.obj = returnMessage;
                        myHandler.sendMessage(msg);
                    }

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
