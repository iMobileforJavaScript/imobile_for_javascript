package com.supermap.interfaces.ai;

import android.app.Activity;
import android.hardware.Sensor;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.ai.AIDetectView;

/**
 * 违章采集
 */
public class SIllegallyParkView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SIllegallyParkView";
    private static ReactApplicationContext mReactContext = null;

    public SIllegallyParkView(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

    private static AIDetectView mAIdetectView;
    private static SensorManager mSensorManager;
    private static Sensor mSensor;
    private static SensorEventListener mSensorEventListener;
    private static Thread mCarColorThread;
    private static Thread mIdentityCarNumberThread;

    public static void setInstanse(AIDetectView aIdetectView, SensorManager sensorManager,
                                   Sensor sensor, Thread carColorThread, SensorEventListener sensorEventListener, Thread identityCarNumberThread) {
        mAIdetectView = aIdetectView;
        mSensorManager = sensorManager;
        mSensor = sensor;
        mSensorEventListener = sensorEventListener;
        mCarColorThread = carColorThread;
        mIdentityCarNumberThread = identityCarNumberThread;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void onStop(Promise promise) {
        Log.d(REACT_CLASS, "----------------onStop--------RN--------");
        if (mAIdetectView != null) {
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mAIdetectView.pauseDetect();
                    }
                });
            }
        }
        if (mCarColorThread != null) {
            mCarColorThread.interrupt();
        }
        mSensorManager.unregisterListener(mSensorEventListener, mSensor);
    }

    @ReactMethod
    public void onStart(Promise promise) {
        Log.d(REACT_CLASS, "----------------onStart--------RN--------");
        if (mAIdetectView != null) {
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mAIdetectView.startCameraPreview();
                        mAIdetectView.resumeDetect();
                    }
                });
            }
        }
        if (mSensorManager != null) {
            mSensorManager.registerListener(mSensorEventListener, mSensor,SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    @ReactMethod
    public void onDestroy(Promise promise) {
        Log.d(REACT_CLASS, "----------------onDestroy--------RN--------");
        if (mSensorManager != null) {
            mSensorManager.unregisterListener(mSensorEventListener, mSensor);
        }
        if (mCarColorThread != null) {
            mCarColorThread.interrupt();
        }
        if (mIdentityCarNumberThread != null) {
            mIdentityCarNumberThread.interrupt();
        }
        if (mAIdetectView != null) {
            Activity currentActivity = getCurrentActivity();
            if (currentActivity != null) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mAIdetectView.dispose();
                    }
                });
            }
        }
    }

}
