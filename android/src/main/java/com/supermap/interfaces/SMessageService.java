package com.supermap.interfaces;

import android.util.Base64;
import android.util.Log;
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
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.messagequeue.AMQPManager;
import com.supermap.messagequeue.AMQPReceiver;
import com.supermap.messagequeue.AMQPReturnMessage;
import com.supermap.messagequeue.AMQPSender;
import com.supermap.messagequeue.AMQPExchangeType;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;


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

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SMessageService(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext = context;
        com.supermap.messagequeue.Environment.initialization(context);
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
    public void declareSession(ReadableArray members, String groupId, Promise promise) {
        try {

            boolean bRes = true;
            if (g_AMQPManager!=null){
                for(int i = 0; i < members.size(); i++){
                    ReadableMap member = members.getMap(i);
                    String sQueue = "Message_" + member.getString("id");
                    g_AMQPManager.declareQueue(sQueue);
                    g_AMQPManager.bindQueue(sGroupExchange, sQueue, groupId);
                }

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
    public void exitSession(String memberId, String groupId, Promise promise) {
        try {

            boolean bRes = true;
            if (g_AMQPManager!=null){
                String sQueue = "Message_" + memberId;
                String sRoutingKey = groupId;
                g_AMQPManager.unbindQueue(sGroupExchange, sQueue, sRoutingKey);

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

            boolean bGroup = targetID.contains("Group_");
            boolean bRes = true;
            //需要声明对方的消息队列并绑定routingkey
            String sQueue = "Message_" + targetID;
            String sRoutingKey = "Message_" + targetID;
            if (g_AMQPManager!=null && !bGroup){

                g_AMQPManager.declareQueue(sQueue);
                g_AMQPManager.bindQueue(sExchange, sQueue, sRoutingKey);

            }
            if(!bGroup){
                g_AMQPSender.sendMessage(sExchange, message, sRoutingKey);
            }else{
                g_AMQPSender.sendMessage(sGroupExchange, message, targetID);
            }


            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 文件发送
     */
    @ReactMethod
    public void sendFile(final String connectInfo, final String message, final String filePath , final Promise promise) {
        try {
            Thread Thread_Send_File = new Thread(new Runnable() {
                @Override
                public void run() {
                    try
                    {
                        File file = new File(filePath);
                        String fileName = file.getName();

                        FileInputStream inStream=new FileInputStream(file);
                        ByteArrayOutputStream bos = new ByteArrayOutputStream();

                        //文件大小
                        long fileSize = file.length();
                        //2M为单位切割文件后的总个数
                        long total = (long) (Math.ceil((double)fileSize / ((double) 1024 * 1024 * 2)));
                        byte[] buffer=new byte[1024 * 1024 * 2];

                        //发送的文件的计数
                        long count = 0;
                        //BASE64编码的单个文件
                        String sFileBlock;
                        //可以直接发送的json字符串
                        String jsonMessage;

                        JSONObject jMessage = new JSONObject(message);

                        //对方的文件队列名和key,最好随机生成
                        String sQueue = "File_" + jMessage.getJSONObject("user").getString("id") +"_"+  jMessage.getString("time");
                        String sRoutingKey = "File_" + jMessage.getJSONObject("user").getString("id") +"_"+ jMessage.getString("time");

                        JSONObject jConnectinfo = new JSONObject(connectInfo);

                        //传送文件时新建一个连接
                        AMQPManager mAMQPManager_File = new AMQPManager();

                        mAMQPManager_File.connection(jConnectinfo.getString("serverIP"),
                                jConnectinfo.getInt("port"),
                                jConnectinfo.getString("hostName"),
                                jConnectinfo.getString("userName"),
                                jConnectinfo.getString("passwd"),
                                jConnectinfo.getString("userID"));

                        mAMQPManager_File.declareQueue(sQueue);
                        //由于错误可能会有未删除的队列
                        mAMQPManager_File.deleteQueue(sQueue);
                        mAMQPManager_File.declareQueue(sQueue);
                        mAMQPManager_File.bindQueue(sExchange, sQueue, sRoutingKey);
                        AMQPSender fileSender = mAMQPManager_File.newSender();



                        int length;
                        while( (length = inStream.read(buffer)) != -1)
                        {
                            bos.write(buffer,0,length);
                            sFileBlock = Base64.encodeToString(bos.toByteArray(),Base64.DEFAULT);
                            bos.reset();

                            count++;

                            jMessage.put("message", sFileBlock)
                                    .put("total", total)
                                    .put("count", count);

                            fileSender.sendMessage(sExchange, jMessage.toString(), sRoutingKey);

                            final String percentage = Float.toString( (float) count / total * 100);

                        }
                        bos.close();
                        inStream.close();
                        mAMQPManager_File.disconnection();
                        WritableMap map = Arguments.createMap();

                        map.putString("queueName",sQueue);
                        map.putString("fileName",fileName);
                        promise.resolve(map);
                    }catch(Exception e){
                        promise.reject(e);
                    }
                }
            });
            Thread_Send_File.start();
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
                    g_AMQPManager.declareQueue(sQueue);
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
                    g_AMQPManager.declareQueue(sQueue);
                    g_AMQPReceiver = g_AMQPManager.newReceiver(sQueue);
                }
            }

            //异步消息发送
             class MessageReceiveThread extends Thread{
                @Override
                public void run(){
                    while (true){
                        if(g_AMQPReceiver!=null){
                            AMQPReturnMessage resMessage = g_AMQPReceiver.receiveMessage();
                            String sQueue = resMessage.getQueue();
                            String sMessage = resMessage.getMessage();
                            if(!sQueue.isEmpty() && !sMessage.isEmpty()){
                                WritableMap map = Arguments.createMap();
                                map.putString("clientId",sQueue);
                                map.putString("message",sMessage);
                                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(EventConst.MESSAGE_SERVICE_RECEIVE, map);
                            }
                            bStopRecieve = false;
                        }else{
                            bStopRecieve = true;
                            g_AMQPReceiver = null;
                            break;
                        }

                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }


                }
            }
            new MessageReceiveThread().start();

            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    //挂起操作，用于APP状态切换后台
    @ReactMethod
    public void suspend(Promise promise){
        if (g_AMQPManager != null){
            g_AMQPManager.suspend();
        }
        promise.resolve(true);
    }

    //恢复操作，用户APP唤醒
    @ReactMethod
    public void resume(Promise promise){
        boolean b = false;
        if (g_AMQPManager != null){
            b = g_AMQPManager.resume();
        }
        promise.resolve(b);
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
