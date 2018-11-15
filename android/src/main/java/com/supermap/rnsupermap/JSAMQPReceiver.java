package com.supermap.rnsupermap;

import android.os.Handler;
import android.os.Message;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.messagequeue.AMQPManager;
import com.supermap.messagequeue.AMQPReceiver;
import com.supermap.messagequeue.AMQPReturnMessage;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/16.
 */

public class JSAMQPReceiver extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSAMQPReceiver";
    public static Map<String,AMQPReceiver> mReceiverList=new HashMap<String,AMQPReceiver>();
    AMQPReceiver mReceiver;

    public JSAMQPReceiver(ReactApplicationContext context){super(context);}

    public static String registerId(AMQPReceiver receiver){
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
    public void receiveMessage(String receiverId, final Promise promise){
        try{
            mReceiver = mReceiverList.get(receiverId);

            final Handler myHandler = new Handler(){
                @Override
                public void handleMessage(Message msg){
                    AMQPReturnMessage message = (AMQPReturnMessage) msg.obj;
                    String content = message.getMessage();
                    String queue = message.getQueue();

                    WritableMap map1 = Arguments.createMap();
                    WritableMap map = Arguments.createMap();
                    map1.putString("message",content);
                    map1.putString("queue",queue);
                    map.putMap("message",map1);
                    promise.resolve(map);
                }
            };

            new Thread(new Runnable() {
                @Override
                public void run() {
                    AMQPReturnMessage returnMessage = mReceiver.receiveMessage();
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
}
