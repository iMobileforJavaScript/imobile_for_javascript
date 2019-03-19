package com.supermap.interfaces;

import android.view.GestureDetector;
import android.view.MotionEvent;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.messagequeue.AMQPManager;
import com.supermap.messagequeue.AMQPReceiver;
import com.supermap.messagequeue.AMQPSender;
//import com.supermap.messagequeue.AMQPExchangeType;


public class SMessageService extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SMessageService";
    private static SMessageService messageService;
    private static ReactApplicationContext context;

    static AMQPManager g_AMQPManager = null;
    static AMQPSender g_AMQPSender = null;
    static AMQPReceiver g_AMQPReceiver = null;

    static boolean bStopRecieve = true;
    //分发消息的交换机
    static String sExchange = "message";
    //分发群消息的交换机
    static String sGroupExchange = "message.group";

    ReactContext mReactContext;

    public SMessageService(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext = context;
    }

    /**
     * 连接服务
     */
    @ReactMethod
    public void connectService(String serverIP, int port,String hostName, String userName,String passwd ,String userID, Promise promise) {
        try {
            g_AMQPManager = null;
            g_AMQPSender = null;
            g_AMQPReceiver = null;

            //假如有接收线程未停止，在这等待
            while (!bStopRecieve) {
                Thread.sleep(500);
            }

            boolean bRes = false;
            if (g_AMQPManager==null){

                g_AMQPManager = new AMQPManager();
                //建立与服务器的链接
                bRes = g_AMQPManager.connection(serverIP,port,hostName,userName,passwd,userID);
                //声明普通消息交换机
                bRes = g_AMQPManager.declareExchange(sExchange,AMQPExchangeType.DIRECT);
                //声明群消息交换机
                bRes = g_AMQPManager.declareExchange(sGroupExchange,AMQPExchangeType.DIRECT);
                //构造AMQP发送端
                g_AMQPSender = g_AMQPManager.newSender();
            }

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 断开服务链接
     */
    @ReactMethod
    public void disconnectionService(Promise promise) {
        try {

            boolean bRes = true;
            if (g_AMQPManager!=null){

                g_AMQPManager.disconnection();
                g_AMQPManager = null;
                g_AMQPSender = null;

            }

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 声明多人会话
     */
    @ReactMethod
    public void declareSession(String uuid, Promise promise) {
        try {

            boolean bRes = true;
            if (g_AMQPManager!=null){

                g_AMQPManager.declareQueue(uuid);

            }

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 加入多人会话
     */
    @ReactMethod
    public void joinSession(String uuid, Promise promise) {
        try {

            boolean bRes = true;
            if (g_AMQPManager!=null){

                String sQueue = "Group_Message_" + uuid;
                String sRoutingKey = "Group_Message_" + uuid;
                g_AMQPManager.bindQueue(sGroupExchange, sQueue, sRoutingKey);

            }

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 退出多人会话
     */
    @ReactMethod
    public void exitSession(String uuid, Promise promise) {
        try {

            boolean bRes = true;
            if (g_AMQPManager!=null){

                String sQueue = "Group_Message_" + uuid;
                String sRoutingKey = "Group_Message_" + uuid;
                g_AMQPManager.unbindQueue(sQueue ,sGroupExchange , sRoutingKey);

            }

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 消息发送
     */
    @ReactMethod
    public void sendMessage(String message ,String targetID, Promise promise) {
        try {

            boolean bRes = true;
            //需要声明对方的消息队列并绑定routingkey
            String sQueue = "Message_" + targetID;
            String sRoutingKey = "Message_" + targetID;
            if (g_AMQPManager!=null){

                g_AMQPManager.declareQueue(sQueue);
                g_AMQPManager.bindQueue(sExchange, sQueue, sRoutingKey);

            }
            g_AMQPSender.sendMessage(sExchange, message,sRoutingKey);

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 文件发送
     */
    @ReactMethod
    public void sendFile(String filePath ,String targetID, Promise promise) {
        try {

            boolean bRes = true;
            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 消息接收
     */
    @ReactMethod
    public void receiveMessage(String uuid, Promise promise) {
        try {

            boolean bRes = false;
            if(g_AMQPManager!=null && uuid!=null){
                if(g_AMQPReceiver==null){
                    String sQueue = "Message_" + uuid;
                    g_AMQPReceiver = g_AMQPManager.newReceiver(sQueue);
                }
            }


            // NSLog(@"+++ receive +++ %@",[NSThread currentThread]);
            if(g_AMQPReceiver!=null){
                AMQPReturnMessage resMessage = g_AMQPReceiver.receiveMessage();
                String sQueue = resMessage.getQueue();
                String sMessage = resMessage.getMessage();

                if (sQueue!=null && sMessage!=null){
                    WritableMap map = Arguments.createMap();
                    map.putString("clientId",sQueue);
                    map.putString("message",sMessage);
                    promise.resolve(map);
                }
            }

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 开启消息接收
     */
    @ReactMethod
    public void startReceiveMessage(String uuid, Promise promise) {
        try {

            boolean bRes = false;
            if(g_AMQPManager!=null && uuid!=null){
                if(g_AMQPReceiver==null){
                    String sQueue = "Message_" + uuid;
                    g_AMQPReceiver = g_AMQPManager.newReceiver(sQueue);
                }
            }

            //异步消息发送
            public class MessageReceiveThread extends Thread{
                @Override
                public void run(){
                    while (1){
                        if(g_AMQPReceiver!=null){
                            AMQPReturnMessage resMessage = g_AMQPReceiver.receiveMessage();
                            String sQueue = resMessage.getQueue();
                            String sMessage = resMessage.getMessage();
                            if(sQueue!=null && sMessage!=null){
                                WritableMap map = Arguments.createMap();
                                map.putString("clientId",sQueue);
                                map.putString("message",sMessage);
                                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(EventConst.MAP_DOUBLE_TAP, map);
                            }
                            bStopRecieve = false;
                        }else{
                            // NSLog(@"+++ receive  stop +++ %@",[NSThread currentThread]);
                            bStopRecieve = true;
                            break;
                        }

                        Thread.sleep(1000);
                    }


                }
            }
            new MessageReceiveThread().start();



            // NSLog(@"+++ receive +++ %@",[NSThread currentThread]);
            if(g_AMQPReceiver!=null){
                AMQPReturnMessage resMessage = g_AMQPReceiver.receiveMessage();
                String sQueue = resMessage.getQueue();
                String sMessage = resMessage.getMessage();

                if (sQueue!=null && sMessage!=null){
                    WritableMap map = Arguments.createMap();
                    map.putString("clientId",sQueue);
                    map.putString("message",sMessage);
                    promise.resolve(map);
                }
            }

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 停止消息接收
     */
    @ReactMethod
    public void stopReceiveMessage( Promise promise) {
        try {
            boolean bRes = false;
            g_AMQPReceiver = null;
            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
