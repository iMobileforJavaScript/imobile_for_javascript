package com.supermap.interfaces.iServer;


import android.graphics.Bitmap;
import android.os.Build;
import android.util.Log;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.ValueCallback;


import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.data.Point2D;
import com.supermap.onlineservices.DataType;
import com.supermap.onlineservices.DownLoadFile;
import com.supermap.onlineservices.Geocoding;
import com.supermap.onlineservices.GeocodingData;
import com.supermap.onlineservices.OnlineCallBack;
import com.supermap.onlineservices.OnlineService;
import com.supermap.onlineservices.UpLoadFile;
import com.supermap.onlineservices.utils.AccountInfoType;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import static com.supermap.onlineservices.utils.EnumServiceType.RESTMAP;


/**
 * Created by lucd on 2018/11/19.
 */

public class SOnlineService extends ReactContextBaseJavaModule{
    private OnlineService mOnlineService = null;
    private Geocoding m_geocoding = null;
    private static  final String TAG = "SOnlineService"; //
    private static  final String downloadId = "fileName"; //
    private static  final String uploadId = "uploadId"; //
    private String mCookie = null;
    private static Integer downprogress=0 ;
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
        if(mOnlineService == null) {
            mOnlineService = new OnlineService(mContext.getApplicationContext());
        }
    }

    @ReactMethod
    public void reverseGeocoding(double longitude ,double latitude, final Promise promise){
        try{
            if(m_geocoding == null){
                m_geocoding = new Geocoding();
                m_geocoding.setKey("tY5A7zRBvPY0fTHDmKkDjjlr");
                m_geocoding.setGeocodingCallback(new Geocoding.GeocodingCallback() {
                    @Override
                    public void geocodeSuccess(List<GeocodingData> list) {

                    }

                    @Override
                    public void reverseGeocodeSuccess(GeocodingData geocodingData) {
                        mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_REVERSEGEOCODING,geocodingData.getFormatedAddress());
                    }

                    @Override
                    public void geocodeFailed(String s) {

                    }
                });
            }
            m_geocoding.reverseGeocoding(new Point2D(longitude,latitude));
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void login(String userName, String password, final Promise promise){
        try{
            OnlineService.login(userName, password, new OnlineService.LoginCallback() {
                @Override
                public void loginSuccess() {
                    try {
                        promise.resolve(true);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void loginFailed(String error) {
                    try {
                        promise.resolve(error);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
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
                    try {
                        promise.resolve(true);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void loginFailed(String error) {
                    try {
                        promise.resolve(error);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getUserInfo(final Promise promise){
        try{
            OnlineService.getAccountInfo(new OnlineService.AccountInfoCallback() {
                @Override
                public void accountInfoSuccess(String nickName, String phoneNumber, String email){
                    WritableMap map = Arguments.createMap();
                    map.putString("nickname",nickName);
                    map.putString("phoneNumber",phoneNumber);
                    map.putString("email",email);
                    promise.resolve(map);

                }

                @Override
                public void accountInfoFailed(String errInfo){
                    promise.resolve(errInfo);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }

    }

    @ReactMethod
    public void getUserInfoBy(String name,int type,final Promise promise){
        try{
            OnlineService.getAccountInfoByType(name,AccountInfoType.values()[type],new OnlineService.AccountInfoByTypeCallback() {
                @Override
                public void accountInfoByTypeSuccess(String nickName, String userId){
                    WritableArray array = Arguments.createArray();
                    array.pushString(userId);
                    array.pushString(nickName);
                    promise.resolve(array);

                }

                @Override
                public void accountInfoByTypeFailed(String errInfo){
                    promise.resolve(errInfo);
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
    public void downloadWithDataId(String filePath, final String onlineDataNameId, final Promise promise){
        try {
           OnlineService.downloadFileById(mContext, onlineDataNameId, filePath, new DownLoadFile.DownLoadListener() {
               @Override
               public void getProgress(int progress) {
                   if (progress%2==0&&progress>downprogress) {
                       WritableMap map =Arguments.createMap();
                       map.putString("id",onlineDataNameId);
                       map.putInt("progress",progress);
                       mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADINGOFID, map);
                       downprogress=progress;
                   }
               }

               @Override
               public void onComplete() {
                   WritableMap map =Arguments.createMap();
                   map.putString("id",onlineDataNameId);
                   map.putBoolean("downed",true);
                   mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADEDOFID,map);
               }

               @Override
               public void onFailure() {
                   mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADFAILUREOFID, false);
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
                    if (progress % 10 == 0) {
                        mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADING,progress);
                    }
                }

                @Override
                public void onComplete() {
                    promise.resolve(true);
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADED,true);
                }

                @Override
                public void onFailure() {
                    promise.resolve(false);
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADFAILURE,false);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void uploadByType(String filePath,String onlineDataName,String dataType,final Promise promise){
        try {

            String tags="用户数据";
            DataType type=DataType.WORKSPACE;
            if(dataType.equals("UDB")){
                type=DataType.UDB;
            }

            OnlineService.uploadFile(onlineDataName,filePath,tags,type, new UpLoadFile.UpLoadListener() {
                @Override
                public void getProgress(int progress) {
                    if (progress % 10 == 0) {
                        mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADING,progress);
                    }
                }

                @Override
                public void onComplete() {
                    promise.resolve(true);
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADED,true);
                }

                @Override
                public void onFailure() {
                    promise.resolve(false);
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
            OnlineService.registerWithPhone(phoneNumber, nickname, smsVerifyCode, password, new OnlineCallBack.CallBackString() {
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
    public void publishService(final String dataName,final Promise promise){
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
    public void publishServiceWithDataId(final String dataNameId,final Promise promise){
        try {
            OnlineService.publishServiceById(dataNameId, RESTMAP, new OnlineCallBack.CallBackString() {
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
//               int length = "JSESSIONID=".length();
//               String newSessionID = sessionId.substring(length);
//               Log.e("JESESSION",newSessionID + " ..."+sessionId);
               promise.resolve(sessionId);
           }

        }catch (Exception e){
            promise.reject(e);
        }
    }
    @ReactMethod
    public void removeCookie(){
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        cookieManager.removeAllCookie();
    }

    @ReactMethod
    public void syncCookie(String url){
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
            cookieManager.removeAllCookies(new ValueCallback<Boolean>() {
                @Override
                public void onReceiveValue(Boolean aBoolean) {

                }
            });
        }else{
            cookieManager.removeAllCookie();
        }
        cookieManager.setCookie(url,OnlineService.getDefaultJsessionidCookie());
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP){
            CookieSyncManager cookieSyncManager = CookieSyncManager.createInstance(mContext);
            cookieSyncManager.sync();
        }else {
            cookieManager.flush();
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

    @ReactMethod
    public void modifyPassword(String oldPassword, String newPassword, final Promise promise){
        OnlineService.modifyPassword(oldPassword, newPassword, new OnlineCallBack.CallBackString() {
            @Override
            public void onSucceed(String s) {
                promise.resolve(true);
            }

            @Override
            public void onError(String s) {
                promise.resolve(s);
            }
        });
    }
//    @ReactMethod
//    public void modifyNickname(final String nickname, final Promise promise){
//

//        OnlineService.validateUserNickname(nickname, new OnlineCallBack.CallBackString() {
//            @Override
//            public void onSucceed(String s) {
//                OnlineService.modifyNickname(nickname, new OnlineCallBack.CallBackString() {
//                    @Override
//                    public void onSucceed(String s) {
//                        promise.resolve(true);
//                    }
//
//                    @Override
//                    public void onError(String s) {
//                        promise.resolve(s);
//                    }
//                });
//            }
//
//            @Override
//            public void onError(String s) {
//                promise.resolve(s);
//            }
//        });

//
//    }


    @ReactMethod
    public void sendVerficationCode(String phoneNumber,final Promise promise){
        OnlineService.sendVerficationCode(phoneNumber, new OnlineCallBack.CallBackString() {
            @Override
            public void onSucceed(String s) {
                promise.resolve(true);
            }

            @Override
            public void onError(String s) {
                promise.resolve(s);
            }
        });
    }
    @ReactMethod
    public void bindPhoneNumber(String phoneNumber, String verifyCode, final Promise promise){
        OnlineService.bindPhoneNumber(phoneNumber, verifyCode, new OnlineCallBack.CallBackString() {
            @Override
            public void onSucceed(String s) {
                promise.resolve(true);
            }

            @Override
            public void onError(String s) {
                promise.resolve(s);
            }
        });
    }
    @ReactMethod
    public void bindEmail(String email, final Promise promise){

        OnlineService.bindEmail(email, new OnlineCallBack.CallBackString() {
            @Override
            public void onSucceed(String s) {
                WritableMap map = Arguments.createMap();
                map.putBoolean("result",true);
                map.putString("info",s);
                promise.resolve(map);

            }

            @Override
            public void onError(String s) {
                WritableMap map = Arguments.createMap();
                map.putBoolean("result",false);
                map.putString("info",s);
                promise.resolve(map);
            }
        });
    }

    @ReactMethod
    public void getSuperMapKnown(final Promise promise){
        try {
            String url="http://111.202.121.144:8088/officialAccount/zhidao/data.json";
            OkHttpClient client=new OkHttpClient();
            final Request request=new Request.Builder()
                    .url(url)
                    .build();
            client.newCall(request).enqueue(new Callback() {
                @Override
                public void onFailure(Call call, IOException e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    if(response.isSuccessful()){
                        String json=response.body().string();
                        try {
                            JSONArray jsonArray=new JSONArray(json);
                            WritableArray array=Arguments.createArray();
                            for (int i = 0; i <jsonArray.length() ; i++) {
                                JSONObject jsonObject=jsonArray.getJSONObject(i);
                                WritableMap map =Arguments.createMap();
                                map.putString("id",jsonObject.optString("id"));
                                map.putString("title",jsonObject.optString("title"));
                                map.putString("img",jsonObject.optString("cover"));
                                map.putString("time",jsonObject.optString("time"));
                                array.pushMap(map);
                            }
                            promise.resolve(array);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }
            });

        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void loginWithParam(final String url, final String cookie, final String params, final Promise promise) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    JSONObject jParams = new JSONObject(params);

                    final OkHttpClient okHttpClient = new OkHttpClient().newBuilder()
                            .followRedirects(false)
                            .build();

                    RequestBody body = new FormBody.Builder()
                            .add("loginType", jParams.getString("loginType"))
                            .add("username", jParams.getString("username"))
                            .add("password", jParams.getString("password"))
                            .add("lt", jParams.getString("lt"))
                            .add("execution", jParams.getString("execution"))
                            .add("_eventId", jParams.getString("_eventId"))
                            .build();
                    okhttp3.Request postRequest = new okhttp3.Request.Builder()
                            .url(url)
                            .addHeader("Cookie", cookie)
                            .post(body)
                            .build();
                    Response postResponse = okHttpClient.newCall(postRequest).execute();
                    if(postResponse.code() == 302){
                        okhttp3.Request getRequest = new okhttp3.Request.Builder()
                                .url(postResponse.header("Location"))
                                .addHeader("Cookie", cookie)
                                .get()
                                .build();

                        Response getResponse = okHttpClient.newCall(getRequest).execute();
                        if(getResponse.code() == 302){
                            Log.d("online", getResponse.headers("set-cookie").get(0));
                            mCookie = getResponse.headers("set-cookie").get(0);
                            promise.resolve(true);
                        } else {
                            promise.resolve(false);
                        }
                    } else {
//                        String responseBody = postResponse.body().string();
                        promise.resolve("用户名或用户密码错误");
                    }
                } catch (Exception e) {
                    promise.reject(e);
                }
            }
        }).start();
    }

    @ReactMethod
    public void getCookie(Promise promise) {
        if(mCookie != null) {
            promise.resolve(mCookie);
        } else {
            promise.resolve(false);
        }
    }
}
