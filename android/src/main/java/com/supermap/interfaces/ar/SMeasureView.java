package com.supermap.interfaces.ar;

import android.os.Handler;
import android.util.Log;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.google.ar.core.ArCoreApk;
import com.supermap.ar.highprecision.MeasureView;

public class SMeasureView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SMeasureView";

    private static MeasureView mMeasureView = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SMeasureView(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    public static void setInstance(MeasureView measureView) {
        Log.d(REACT_CLASS, "----------------SMeasureView--setInstance--------RN--------");
        mMeasureView = measureView;

        mMeasureView.enableSupport(true);
    }

    /**
     * 新增记录
     */
    private boolean checkARCore() {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--checkARCore--------JAVA--------");
            ArCoreApk.Availability availability = ArCoreApk.getInstance().checkAvailability(getCurrentActivity());
            if (availability.isTransient()) {
                // Re-query at 5Hz while compatibility is checked in the background.
                new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        checkARCore();
                    }
                }, 200);
            }
            if (availability.isSupported()) {
                return true;
            } else {
                // Unsupported or unknown.
                return false;
            }
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 检查是否支持ARCore
     */
    @ReactMethod
    public void isSupportedARCore(Promise promise) {
        try {
            boolean checkARCore = checkARCore();
            Log.d(REACT_CLASS, "----------------SMeasureView--isSupportedARCore--------RN--------" + checkARCore);
            promise.resolve(checkARCore);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 新增记录
     */
    @ReactMethod
    public void addNewRecord(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--addNewRecord--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.addNewRecord();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 撤销上一记录
     */
    @ReactMethod
    public void undoDraw(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--undoDraw--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.withDraw();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除所有
     */
    @ReactMethod
    public void clearAll(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SMeasureView--clearAll--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.cleanAll();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置中心辅助
     */
    @ReactMethod
    public void setEnableSupport(boolean value, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------SAIDetectView--setEnableSupport--------RN--------");
            if (mMeasureView != null) {
                mMeasureView.enableSupport(value);
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
