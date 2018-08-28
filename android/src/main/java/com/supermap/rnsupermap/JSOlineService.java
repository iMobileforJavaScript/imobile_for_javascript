package com.supermap.rnsupermap;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.onlineservices.DownLoadFile;
import com.supermap.onlineservices.OnlineService;

public class JSOlineService extends ReactContextBaseJavaModule {

    ReactContext mReactContext;
    OnlineService onlineService;

    public JSOlineService(ReactApplicationContext reactContext) {
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
        return "JSOlineService";
    }

    @ReactMethod
    public void download( final String path, String username, String passworld, final String filename) {
        try {
            final OnlineService onlineService = getInstance();
            onlineService.login(username, passworld, new OnlineService.LoginCallback() {
                @Override
                public void loginSuccess() {
                    onlineService.DownLoadFile(mReactContext.getApplicationContext(), filename, path, new DownLoadFile.DownLoadListener() {
                        @Override
                        public void getProgress(int progeress) {
                            Log.e("++++++++++++","+"+progeress);
                            mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("DownLoad",progeress);
                        }

                        @Override
                        public void onComplete() {
                            Log.e("++++++++++++","11111111111111111");
                        }

                        @Override
                        public void onFailure() {
                            Log.e("++++++++++++","33333333333333333");
                        }
                    });
                }

                @Override
                public void loginFailed(String s) {
                    Log.e("++++++++++++","5555555555555555555");
                }
            });
        } catch (Exception e) {
            Log.e("=============","+"+e);
        }

    }

    @ReactMethod
    public void login(String username, String passworld, final Promise promise) {
        try {
//            OnlineService onlineService = getInstance();
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
    public void logout(String username, String passworld, final Promise promise) {
        try {
//            OnlineService onlineService = getInstance();
            OnlineService.logout();
        } catch (Exception e) {
            promise.resolve(e);
        }
    }

}
