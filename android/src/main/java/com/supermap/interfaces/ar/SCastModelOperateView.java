package com.supermap.interfaces.ar;

import android.content.Context;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

public class SCastModelOperateView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SCastModelOperateView";
    private Context mContext = null;

    private static ImobileCustomSceneViewManager mSceneViewManager = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SCastModelOperateView(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext.getApplicationContext();
    }

    public static void setInstance(ImobileCustomSceneViewManager sceneViewManager) {
        mSceneViewManager = sceneViewManager;;
    }

    @ReactMethod
    public void onPause(Promise promise) {
        try {
            Log.d("CastModelOperateView", "----------------SCastModelOperateView--onPause--------RN--------");

            if (mSceneViewManager != null) {
                getCurrentActivity().runOnUiThread(() -> {
                    mSceneViewManager.onPause();
                });
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
                getCurrentActivity().runOnUiThread(() -> {
                    mSceneViewManager.onDestroyView();
                    mSceneViewManager.onDestroy();
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

            if (mSceneViewManager != null) {
                getCurrentActivity().runOnUiThread(() -> {
                    mSceneViewManager.onResume();
                });
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /*****************************************************************************************/


}
