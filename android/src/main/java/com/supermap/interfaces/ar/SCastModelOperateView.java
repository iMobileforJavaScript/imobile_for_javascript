package com.supermap.interfaces.ar;

import android.app.Activity;
import android.content.Context;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.rnsupermap.R;

public class SCastModelOperateView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SCastModelOperateView";
    private Context mContext = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SCastModelOperateView(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext.getApplicationContext();
    }

//    public static void setInstance(ArFragment arFragment) {
//    }

    @ReactMethod
    public void onPause(Promise promise) {
        try {
            Log.d("CastModelOperateView", "----------------SCastModelOperateView--onPause--------RN--------");

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void onDestroy(Promise promise) {
        try {
            Log.d("CastModelOperateView", "----------------SCastModelOperateView--onDestroy--------RN--------");

            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        FragmentActivity fragmentActivity = (FragmentActivity) currentActivity;
                        FragmentManager supportFragmentManager = fragmentActivity.getSupportFragmentManager();

                        AugmentedImageFragment arFragment = (AugmentedImageFragment) supportFragmentManager.findFragmentById(R.id.ar_fragment);
                        if (arFragment != null) {
                            FragmentTransaction fragmentTransaction = supportFragmentManager.beginTransaction();
                            fragmentTransaction.remove(arFragment);
                            fragmentTransaction.commitNow();
                        }
                    }
                });
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    protected void onResume(Promise promise) {
        try {
            Log.d("CastModelOperateView", "--------------SCastModelOperateView---onResume--------RN--------");

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /*****************************************************************************************/


}
