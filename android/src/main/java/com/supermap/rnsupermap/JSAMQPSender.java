package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.messagequeue.AMQPSender;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/16.
 */

public class JSAMQPSender extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSAMQPSender";
    public static Map<String,AMQPSender> mSenderList=new HashMap<String,AMQPSender>();
    AMQPSender mSender;

    public JSAMQPSender(ReactApplicationContext context){super(context);}

    public static String registerId(AMQPSender sender){
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
    public void sendMessage(String senderId, String exchange,String routingKey,String message, Promise promise){
        try{
            mSender = mSenderList.get(senderId);
            boolean sent = mSender.sendMessage(exchange,routingKey,message);
            promise.resolve(sent);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
