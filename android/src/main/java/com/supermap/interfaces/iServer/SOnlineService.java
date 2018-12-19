package com.supermap.interfaces.iServer;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.onlineservices.DownLoadFile;
import com.supermap.onlineservices.OnlineCallBack;
import com.supermap.onlineservices.OnlineService;
import com.supermap.onlineservices.UpLoadFile;
import com.supermap.onlineservices.utils.EnumServiceType;

import java.io.File;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import static com.supermap.onlineservices.utils.EnumServiceType.RESTMAP;


/**
 * Created by lucd on 2018/11/19.
 */

public class SOnlineService extends ReactContextBaseJavaModule{
    private OnlineService mOnlineService = null;
    private static  final String TAG = "SOnlineService"; //
    private ReactApplicationContext mContext = null;
    String rootPath = android.os.Environment.getExternalStorageDirectory().getPath().toString();
    public SOnlineService(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
        Log.i(TAG,"构造函数");
    }

    /**
     ReactContextBaseJavaModule要求派生类实现getName方法,
     这个函数用于返回一个字符串名字，这个名字在 JavaScript 端标记这个模块。
     */
    @Override
    public String getName() {
        return TAG;
    }
    /**
     * 一个可选的方法getContants返回了需要导出给 JavaScript 使用的常量。
     * 它并不一定需要实现，但在定义一些可以被 JavaScript 同步访问到的预定义的值时非常有用。
     */
    @Override
    public Map<String,Object>getConstants(){
        final Map<String,Object> constants = new HashMap<>();
        constants.put("name",TAG);
        return constants;
    }
    @ReactMethod
    public void init(){
        if(mOnlineService == null){
            mOnlineService = new OnlineService(mContext.getApplicationContext());
        }
    }
    @ReactMethod
    public void login(String userName, String password, final Promise promise){
        try{
            OnlineService.login(userName, password, new OnlineService.LoginCallback() {
                @Override
                public void loginSuccess() {
                    promise.resolve(true);
                }

                @Override
                public void loginFailed(String error) {
                    promise.resolve(error);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }
    @ReactMethod
    public void loginWithPhone(String phoneNumber, String password, final Promise promise){
        try{
            OnlineService.loginByPhoneNumber(phoneNumber, password, new OnlineService.LoginCallback() {
                @Override
                public void loginSuccess() {
                    promise.resolve(true);
                }

                @Override
                public void loginFailed(String error) {
                    promise.resolve(error);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }
    @ReactMethod
    public void logout(final Promise promise){
        try{
            OnlineService.logout(new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String error) {
                    promise.reject(error);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }
    @ReactMethod
    public void download(String filePath,String onlineDataName,final Promise promise){
        try {
            OnlineService.downloadFile(mContext, onlineDataName,filePath, new DownLoadFile.DownLoadListener() {
                @Override
                public void getProgress(int progress) {
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADING,progress);
                }

                @Override
                public void onComplete() {
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADED,true);
                }

                @Override
                public void onFailure() {
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }
    @ReactMethod
    public void upload(String filePath,String onlineDataName,final Promise promise){
        try {
            OnlineService.uploadFile(onlineDataName,filePath, new UpLoadFile.UpLoadListener() {
                @Override
                public void getProgress(int progress) {
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADING,progress);
                }

                @Override
                public void onComplete() {
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADED,true);
                }

                @Override
                public void onFailure() {
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADFAILURE,false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }
    @ReactMethod
    public void getDataList(int currentPage,int pageSize,final Promise promise){
        try {
            OnlineService.getDataList(currentPage, pageSize, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(s);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getServiceList(int currentPage,int pageSize,final Promise promise){
        try {
            OnlineService.getServiceList(currentPage, pageSize, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(s);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void registerWithEmail(String email,String nickname,String password,final Promise promise){
        try {
            OnlineService.registerWithEmail(email, nickname, password, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void registerWithPhone(String phoneNumber,String smsVerifyCode,String nickname,String password,final Promise promise){
        try {
            OnlineService.registerWithPhone(phoneNumber, smsVerifyCode, nickname, password, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void sendSMSVerifyCode(String phoneNumber,final Promise promise){
        try {
            OnlineService.sendSMSVerifyCodeWithPhoneNumber(phoneNumber, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }


    @ReactMethod
    public void verifyCodeImage(final Promise promise){
        try {
            OnlineService.verifyCodeImage(new OnlineCallBack.CallBackBitmap() {
                @Override
                public void onSucceed(Bitmap bitmap) {
                    String fileDirs = rootPath+"/tmp/";
                    File file = new File(fileDirs);
                    if(!file.exists()){
                        file.mkdirs();
                    }
                    String filePath = fileDirs+ "verifyCodeImage.png";
                    File file2= new File(filePath);
                    if(!file2.exists()){
                        file2.delete();
                    }
                    FileOutputStream fos = null;
                    try {
                        fos = new FileOutputStream(file2);
                        bitmap.compress(Bitmap.CompressFormat.PNG,100,fos);
                        promise.resolve(filePath);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }finally {
                        try {
                            if(fos != null) {
                                fos.close();
                                fos.flush();
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }

                @Override
                public void onError(String s) {
                    promise.resolve(false);
                }
            });
        }catch (Exception e){

        }
    }

    @ReactMethod
    public void retrievePassword(String account,String verifyCode,boolean isPhone,final Promise promise){
        try {
            OnlineService.retrievePassword(account, verifyCode, isPhone, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){

        }
    }

    @ReactMethod
    public void retrievePasswordSecond(boolean firstResult,final Promise promise){
        try {
            if(!firstResult){
                return;
            }
            OnlineService.retrievePasswordSecond(new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){

        }
    }

    @ReactMethod
    public void retrievePasswordThrid(boolean secondResult,String safeCode,final Promise promise){
        try {
            if(!secondResult){
                promise.resolve("找回密码错误，请从头开始");
                return;
            }
            OnlineService.retrievePasswordThird(safeCode, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){

        }
    }

    @ReactMethod
    public void retrievePasswordFourth(boolean thirdResult,String newPassword,final Promise promise){
        try {
            if(!thirdResult){
                promise.resolve("找回密码错误，请从头开始");
                return;
            }
            OnlineService.retrievePasswordFourth(newPassword, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteData(final String dataName,final Promise promise){
        try {
            OnlineService.deleteData(dataName, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteDataWithDataId(final String dataId,final Promise promise){
        try {
            OnlineService.deleteDataById(dataId, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteService(final String dataName, final Promise promise){
        try {
            OnlineService.deleteService(dataName, RESTMAP, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }


    @ReactMethod
    public void deleteServiceWithServiceName(final String serviceName, final Promise promise){
        try {
            OnlineService.deleteServiceByName(serviceName, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }


    @ReactMethod
    public void deleteServiceWithServiceId(final String serviceId, final Promise promise){
        try {
            OnlineService.deleteServiceById(serviceId, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void changeDataVisibilityWithDataId(String id, final boolean isPublic,final Promise promise){
        try {
            OnlineService.changeDataVisiblity(id, isPublic, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void changeDataVisibility(String dataName, final boolean isPublic,final Promise promise){
        try {
            OnlineService.changeDataVisiblityByName(dataName, isPublic, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void changeServiceVisibility(final String serviceName, final boolean isPublic,final Promise promise){
        try {
            OnlineService.changeServiceVisiblityByName(serviceName, isPublic, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void changeServiceVisibilityWithServiceId(final String id, final boolean isPublic,final Promise promise){
        try {
            OnlineService.changeServiceVisiblity(id, isPublic, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAllUserSymbolLibList(final int currentPage, final Promise promise){
        try {
            OnlineService.getAllUserSymbolyLibList(currentPage, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(s);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAllUserDataList(final int currentPage,final Promise promise){
        try {
            OnlineService.getAllUserDataList(currentPage, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(s);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void pulishService(final String dataName,final Promise promise){
        try {
            OnlineService.publishService(dataName, RESTMAP, new OnlineCallBack.CallBackString() {
                @Override
                public void onSucceed(String s) {
                    promise.resolve(true);
                }

                @Override
                public void onError(String s) {
                    promise.resolve(s);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getSessionID(final Promise promise){
        try {
           String sessionId = OnlineService.getDefaultJsessionidCookie();
           if(sessionId.isEmpty()){
               promise.resolve("undefined");
           }else{
               int length = "JSESSIONID=".length();
               String newSessionID = sessionId.substring(length);
               Log.e("JESESSION",newSessionID + " ..."+sessionId);
               promise.resolve(newSessionID);
           }

        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void cacheImage(String imageUrl, final String saveFileName, final Promise promise){
        try {
            OnlineService.getBitmapByUrl(imageUrl, new OnlineCallBack.CallBackBitmap() {
                @Override
                public void onSucceed(Bitmap bitmap) {
                    String fileDirs = rootPath+"/iTablet/Cache/tmp";
                    File file = new File(fileDirs);
                    if(!file.exists()){
                        file.mkdirs();
                    }
                    String filePath = fileDirs+ "/"+saveFileName+".png";
                    File file2= new File(filePath);
                    if(!file2.exists()){
                        file2.delete();
                    }
                    FileOutputStream fos = null;
                    try {
                        fos = new FileOutputStream(file2);
                        bitmap.compress(Bitmap.CompressFormat.PNG,100,fos);
                        promise.resolve(filePath);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }finally {
                        try {
                            if(fos != null) {
                                fos.close();
                                fos.flush();
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }

                @Override
                public void onError(String s) {

                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
