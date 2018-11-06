package com.supermap.rnsupermap;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.onlineservices.DownLoadFile;
import com.supermap.onlineservices.OnlineService;
import com.supermap.onlineservices.UpLoadFile;

public class JSOnlineService extends ReactContextBaseJavaModule {

    ReactContext mReactContext;
    OnlineService onlineService;

    public JSOnlineService(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

    public OnlineService getInstance() {
        if (onlineService == null) {
            onlineService = new OnlineService(mReactContext.getApplicationContext());
        }
        return onlineService;
    }

    @Override
    public String getName() {
        return "JSOnlineService";
    }

    @ReactMethod
    public void download(final String path, final String filename, final Promise promise) {
        try {
            final OnlineService onlineService = getInstance();
            onlineService.DownLoadFile(mReactContext.getApplicationContext(), filename, path, new DownLoadFile.DownLoadListener() {
                @Override
                public void getProgress(int progeress) {
                    Log.e("++++++++++++", "+" + progeress);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADING, progeress);
                }

                @Override
                public void onComplete() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADED, true);

                }

                @Override
                public void onFailure() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_DOWNLOADFAILURE, false);
                }
            });
        } catch (Exception e) {
            promise.resolve(e);
        }

    }

    @ReactMethod
    public void login(String username, String passworld, final Promise promise) {
        try {
            OnlineService.login(username, passworld, new OnlineService.LoginCallback() {
                @Override
                public void loginSuccess() {
                    promise.resolve(true);
                }

                @Override
                public void loginFailed(String error) {
                    promise.resolve(error);
                }
            });
        } catch (Exception e) {
            promise.resolve(e);
        }
    }

    @ReactMethod
    public void logout(final Promise promise) {
        try {
            OnlineService.logout();
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(e);
        }
    }
    @ReactMethod
    public void upload(String filepath, String filename, final Promise promise) {
        try {
            final OnlineService onlineService = getInstance();
//            onlineService.UpLoadFile(filepath,filename,new UpLoadFile.UpLoadListener(){
//                @Override
//                public void getProgress(int progeress) {
//                    Log.e("++++++++++++", "+" + progeress);
//                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ONLINE_SERVICE_UPLOADING, progeress);
//                }
//            });
        } catch (Exception e) {
            promise.resolve(e);
        }
    }
}