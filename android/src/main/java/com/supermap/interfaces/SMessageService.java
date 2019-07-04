package com.supermap.interfaces;

import android.os.Looper;
import android.util.Base64;

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
import com.supermap.messagequeue.AMQPReturnMessage;
import com.supermap.messagequeue.AMQPSender;
import com.supermap.messagequeue.AMQPExchangeType;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;


public class SMessageService extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SMessageService";
    private static SMessageService messageService;
    private static ReactApplicationContext context;

    static AMQPManager g_AMQPManager = null;
    static AMQPSender g_AMQPSender = null;
    static AMQPReceiver g_AMQPReceiver = null;

    static boolean bStopRecieve = true;
    static boolean isRecieving = true;
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
            //假如有接收线程未停止，在这等待
//            while (!bStopRecieve) {
//                Thread.sleep(500);
//            }

//            if(g_AMQPManager != null){
//                g_AMQPManager.suspend();
//            }
//            if(g_AMQPReceiver != null){
//                g_AMQPReceiver.dispose();
//            }
//            g_AMQPManager = null;
//            g_AMQPSender = null;
//            g_AMQPReceiver = null;



            boolean bRes = true;
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

                if(!bRes){
                    g_AMQPManager = null;
                    g_AMQPSender = null;
                }
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
    public void sendFile(final String connectInfo, final String message, final String filePath,
                         final String talkId, final int msgId ,final Promise promise) {
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

                            jMessage.getJSONObject("message").getJSONObject("message")
                                    .put("data", sFileBlock)
                                    .put("length", total)
                                    .put("index", count);

                            fileSender.sendMessage(sExchange, jMessage.toString(), sRoutingKey);

                            int percentage = (int)((float) count / total * 100);
                            WritableMap infoMap = Arguments.createMap();
                            infoMap.putString("talkId", talkId);
                            infoMap.putInt("msgId", msgId);
                            infoMap.putInt("percentage", percentage );
                            context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                    .emit(EventConst.MESSAGE_SERVICE_SEND_FILE, infoMap);
                        }
                        bos.close();
                        inStream.close();
                        mAMQPManager_File.disconnection();
                        WritableMap map = Arguments.createMap();

                        map.putString("queueName",sQueue);
                        map.putString("fileName",fileName);
                        map.putDouble("fileSize",fileSize);
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
     * 文件发送，用第三方服务器发送文件
     */
    @ReactMethod
    public void sendFileWithThirdServer(final String message, final String filePath,
                         final String talkId, final int msgId ,final Promise promise) {

            try {
                Thread Thread_Send_File = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            HttpPost httpPost = new HttpPost("http://111.202.121.144:8124/upload");
                            File file = new File(filePath);
                            String fileName = file.getName();

                            FileInputStream inStream = new FileInputStream(file);
                            ByteArrayOutputStream bos = new ByteArrayOutputStream();

                            long startPos = 0;
                            //BASE64编码的单个文件
                            String sFileBlock;
                            //文件大小
                            long fileSize = file.length();
                            //2M为单位切割文件后的总个数
                            long total = (long) (Math.ceil((double) fileSize / ((double) 1024 * 1024 * 2)));
                            int blockSize = 1024 * 1024 * 2;
                            byte[] buffer = new byte[blockSize];
                            int length, count = 0;
                            String md5 = getFileMD5(file);

                            JSONObject jMessage = new JSONObject(message);
                            String userId=jMessage.getJSONObject("user").optString("id");
                            JSONObject filePack = new JSONObject();
                            filePack.put("md5", md5);
                            filePack.put("userId", userId);
                            for (int index = 0; (length = inStream.read(buffer)) != -1; index++, startPos += length) {
                                bos.write(buffer, 0, length);
                                byte[] bytes = bos.toByteArray();
                                sFileBlock = Base64.encodeToString(bytes, Base64.DEFAULT);
                                bos.reset();
                                count++;

                                filePack.put("dataLength", length);
                                filePack.put("startPos", startPos);
                                filePack.put("index", index);
                                filePack.put("data", sFileBlock);
                                StringEntity stringEntity = new StringEntity(filePack.toString());
                                httpPost.setEntity(stringEntity);
                                HttpClient client = new DefaultHttpClient();
                                HttpResponse response = client.execute(httpPost);
                                if (response.getStatusLine().getStatusCode() == 200) {
                                    int percentage = (int) ((float) count / total * 100);
                                    WritableMap infoMap = Arguments.createMap();
                                    infoMap.putString("talkId", talkId);
                                    infoMap.putInt("msgId", msgId);
                                    infoMap.putInt("percentage", percentage);
                                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                            .emit(EventConst.MESSAGE_SERVICE_SEND_FILE, infoMap);
                                }
                            }
                            bos.close();
                            inStream.close();

                            WritableMap map = Arguments.createMap();
                            map.putString("queueName", md5);
                            map.putString("fileName", fileName);
                            map.putDouble("fileSize", fileSize);
                            promise.resolve(map);

                        } catch (Exception e) {
                            promise.reject(e);
                        }
                    }
                });
                Thread_Send_File.start();
            } catch (Exception e) {
                promise.reject(e);
            }
    }

    //获取文件的MD5值
    private String getFileMD5(File file) {
        if (!file.isFile()) {
            return null;
        }
        MessageDigest digest = null;
        FileInputStream in = null;
        byte buffer[] = new byte[1024];
        int len;
        try {
            digest = MessageDigest.getInstance("MD5");
            in = new FileInputStream(file);
            while ((len = in.read(buffer, 0, 1024)) != -1) {
                digest.update(buffer, 0, len);
            }
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        BigInteger bigInt = new BigInteger(1, digest.digest());
        return bigInt.toString(16);
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
     * 接收文件,每次接收时运行
     */
    @ReactMethod
    public void receiveFile(final String fileName, final String queueName, final String receivePath, final String talkId, final int msgId ,final Promise promise) {
        Thread mf_Thread_File  =  new Thread(new Runnable() {
            @Override
            public void run() {
                Looper.prepare();
                File path = new File(receivePath);
                File file = new File(receivePath + "/" + fileName);
                byte[] bytes;
                JSONObject jsonReceived;
                try  {
                    if(!path.exists()){
                        path.mkdirs();
                    }
                    if (!file.exists()) {
                        file.createNewFile();
                    }
                    FileOutputStream fop = new FileOutputStream(file);
                    g_AMQPManager.declareQueue(queueName);
                    AMQPReceiver fileReceiver = g_AMQPManager.newReceiver(queueName);

                    while (fileReceiver != null) {
                        //接收消息
                        AMQPReturnMessage returnMsg = fileReceiver.receiveMessage();
                        if (!returnMsg.getMessage().isEmpty()) {
                            // 获取消息
                            String msg = returnMsg.getMessage();
                            jsonReceived = new JSONObject(msg);
                            bytes = Base64.decode(jsonReceived.getJSONObject("message").getJSONObject("message").getString("data"), Base64.DEFAULT);
                            fop.write(bytes);
                            fop.flush();
                            long index = jsonReceived.getJSONObject("message").getJSONObject("message").getLong("index");
                            long length = jsonReceived.getJSONObject("message").getJSONObject("message").getLong("length");
                            int percentage = (int)((float) index / length * 100);
                            WritableMap infoMap = Arguments.createMap();
                            infoMap.putString("talkId", talkId);
                            infoMap.putInt("msgId", msgId);
                            infoMap.putInt("percentage", percentage );
                            context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                    .emit(EventConst.MESSAGE_SERVICE_RECEIVE_FILE, infoMap);
                            if(index == length)
                                break;
                        }
                    }
                    fop.close();
                    //接收完后删除队列
                    g_AMQPManager.deleteQueue(queueName);
                    promise.resolve(true);
                } catch (Exception e) {
                    promise.reject(e);
                }
            }
        });

        mf_Thread_File.start();

    }

    /**
     * 接收文件,每次接收时运行
     */
    @ReactMethod
    public void receiveFileWithThirdServer(final String fileName, final String queueName, final String receivePath, final String talkId, final int msgId, final String userId, final int fileSize, final Promise promise) {
        try {
            Thread Thread_Send_File = new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        HttpPost httpPost = new HttpPost("http://111.202.121.144:8124/download");
                        File path = new File(receivePath);
                        File file = new File(receivePath + "/" + fileName);
                        if (!path.exists()) {
                            path.mkdirs();
                        }
                        if (!file.exists()) {
                            file.createNewFile();
                        } else if (file.exists()) {
                            file.delete();
                        }
                        int blockSize = 1024 * 1024 * 2;
                        long total = (long) (Math.ceil((double) fileSize / ((double) 1024 * 1024 * 2)));
                        HttpClient client = new DefaultHttpClient();
                        RandomAccessFile randomAccessFile = new RandomAccessFile(file, "rw");
                        JSONObject downloadPack = new JSONObject();
                        downloadPack.put("userID", userId);
                        downloadPack.put("md5", queueName);
                        downloadPack.put("dataLength", blockSize);
                        long start = 0;
                        for (int index=1;index<=total;index++) {
                            downloadPack.put("startPos", start);
                            StringEntity stringEntity = new StringEntity(downloadPack.toString());
                            httpPost.setEntity(stringEntity);
                            HttpResponse response = client.execute(httpPost);
                            String entity = EntityUtils.toString(response.getEntity(), "UTF-8");
                            JSONObject jsonObject1 = new JSONObject(entity);
                            int dataLength = jsonObject1.getInt("dataLength");
                            if (dataLength <= 0) {
                                break;
                            }
                            byte[] values = Base64.decode(jsonObject1.getString("value"), Base64.DEFAULT);
                            randomAccessFile.seek(start);
                            randomAccessFile.write(values);
                            start += dataLength;

                            int percentage = (int)((float) index / total * 100);
                            WritableMap infoMap = Arguments.createMap();
                            infoMap.putString("talkId", talkId);
                            infoMap.putInt("msgId", msgId);
                            infoMap.putInt("percentage", percentage );
                            context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                    .emit(EventConst.MESSAGE_SERVICE_RECEIVE_FILE, infoMap);

                        }
                        randomAccessFile.close();

                        promise.resolve(true);
                    } catch (Exception e) {
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
     * 开启消息接收
     */
    @ReactMethod
    public void startReceiveMessage(String uuid, Promise promise) {
        try {
            boolean bRes = false;
            final String sQueue = "Message_" + uuid;
            if(g_AMQPManager!=null && uuid!=null){
                g_AMQPManager.declareQueue(sQueue);
                g_AMQPReceiver = g_AMQPManager.newReceiver(sQueue);
            }

            isRecieving = true;
            //异步消息发送
             class MessageReceiveThread extends Thread{
                @Override
                public void run(){
                    int n = 0;
                    while (true){
                        if(isRecieving && g_AMQPReceiver != null){
                            bStopRecieve = false;
                            AMQPReturnMessage resMessage = g_AMQPReceiver.receiveMessage();
                            String sQueue = resMessage.getQueue();
                            String sMessage = resMessage.getMessage();
                            if (!sQueue.isEmpty() && !sMessage.isEmpty()) {
                                WritableMap map = Arguments.createMap();
                                map.putString("clientId", sQueue);
                                map.putString("message", sMessage);
                                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(EventConst.MESSAGE_SERVICE_RECEIVE, map);
                            }
                        }else{
                            if(g_AMQPReceiver != null) {
                                g_AMQPReceiver.dispose();
                                g_AMQPReceiver = null;
                            }
                            bStopRecieve = true;
                            break;
                        }

                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }

                        //一分钟重新连接一次：
                        if(n++ == 60){
                            if (g_AMQPManager != null) {
                                g_AMQPManager.suspend();
                                g_AMQPManager.resume();
                            }
                            n = 0;
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
            isRecieving = false;
            while (!bStopRecieve) {
                Thread.sleep(500);
            }
            promise.resolve(bRes);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


}
