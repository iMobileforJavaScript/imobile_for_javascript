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

    private static ImobileSceneViewManager mSceneViewManager = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SCastModelOperateView(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext.getApplicationContext();
    }

    public static void setInstance(ImobileSceneViewManager sceneViewManager) {
        mSceneViewManager = sceneViewManager;;
    }

    @ReactMethod
    public void onPause(Promise promise) {
        try {
            Log.d("CastModelOperateView", "----------------SCastModelOperateView--onPause--------RN--------");

            if (mSceneViewManager != null) {
                mSceneViewManager.onPause();
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void onDestroy(Promise promise) {
        try {
            Log.d("CastModelOperateView", "----------------SCastModelOperateView--onDestroy--------RN--------");

            if (mSceneViewManager != null) {
                mSceneViewManager.onDestroyView();
                mSceneViewManager.onDestroy();
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

            if (mSceneViewManager != null) {
                mSceneViewManager.onResume();
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /*****************************************************************************************/


}
