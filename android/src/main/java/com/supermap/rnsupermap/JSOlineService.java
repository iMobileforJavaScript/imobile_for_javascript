package com.supermap.rnsupermap;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.onlineservices.DownLoadFile;
import com.supermap.onlineservices.OnlineService;

public class JSOlineService extends ReactContextBaseJavaModule {
    private Context context;

    public JSOlineService(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
    }

    @Override
    public String getName() {
        return "JSOlineService";
    }

    @ReactMethod
    public void Download(final String path, String username, String passworld, final String filename) {
        try {
            final OnlineService onlineService = new OnlineService(context.getApplicationContext());
            onlineService.login(username, passworld, new OnlineService.LoginCallback() {
                @Override
                public void loginSuccess() {
                    onlineService.DownLoadFile(context.getApplicationContext(), filename, path, new DownLoadFile.DownLoadListener() {
                        @Override
                        public void getProgress(int progeress) {
                            Log.e("++++++++++++","+"+progeress);
                            if(progeress==99){
                                Toast toast=Toast.makeText(context.getApplicationContext(),"下载成功",Toast.LENGTH_SHORT);
                                toast.show();
                            }
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
}
