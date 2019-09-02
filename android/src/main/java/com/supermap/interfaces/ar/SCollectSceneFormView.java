package com.supermap.interfaces.ar;

import android.annotation.SuppressLint;
import android.content.Context;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.ar.highprecision.MeasureView;
import com.supermap.interfaces.ai.CustomRelativeLayout;
import com.supermap.interfaces.ar.rajawali.MotionRajawaliRenderer;
import org.rajawali3d.scene.ASceneFrameCallback;
import org.rajawali3d.surface.IRajawaliSurface;
import org.rajawali3d.surface.RajawaliSurfaceView;

import java.text.DecimalFormat;

public class SCollectSceneFormView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SCollectSceneFormView";
    private static RajawaliSurfaceView mSurfaceView;
    private static MeasureView mMeasureView;

    private static Context mContext = null;
    private static ReactApplicationContext mReactContext = null;
    private static CustomRelativeLayout mCustomRelativeLayout = null;

    private static MotionRajawaliRenderer mRenderer;
    private static boolean isShowTrace = true;//初始值
    private static float[] mCurrentPoseTranslation = new float[3];
    private static float[] mCurrentPoseRotation = new float[4];

    private static DecimalFormat mDecimalFormat = new DecimalFormat("0.00");

    public static void setMeasureView(MeasureView measureView) {
        mMeasureView = measureView;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SCollectSceneFormView(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
        mContext = reactContext.getApplicationContext();
    }

    public static void setViewManager(CustomRelativeLayout relativeLayout) {
        mCustomRelativeLayout = relativeLayout;
    }

    @SuppressLint("ClickableViewAccessibility")
    public static void setArView(RajawaliSurfaceView surfaceView) {
        //----------------------------显示层----------------------------------
        //1.获取显示层
        mSurfaceView = surfaceView;

        //2. 设置透明
        mSurfaceView.setFrameRate(60);
        mSurfaceView.setRenderMode(IRajawaliSurface.RENDERMODE_WHEN_DIRTY);
        mSurfaceView.setTransparent(true);

        //3.新建渲染器
        mRenderer = new MotionRajawaliRenderer(mContext);

        //4.添加手势控制
        mSurfaceView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                mRenderer.onTouchEvent(event);
                return true;
            }
        });

        //5.控制渲染
        setupRenderer();
    }

    private static void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    private static void setupRenderer() {
        // motion renderer
        mSurfaceView.setEGLContextClientVersion(2);
        mRenderer.getCurrentScene().registerFrameCallback(new ASceneFrameCallback() {
            @Override
            public void onPreFrame(long sceneTime, double deltaTime) {
                if (isShowTrace) {
                    mMeasureView.saveCurrentPoseTranslation(mCurrentPoseTranslation);
                    mMeasureView.saveCurrentPoseRotation(mCurrentPoseRotation);

                    mRenderer.updateCameraPoseFromVecotr(mCurrentPoseTranslation, mCurrentPoseRotation);

                    //记录总长度
                    float totalLength = mRenderer.getTotalLength();
                    Log.d(REACT_CLASS, "TotalLength: " + totalLength + "m");

                    WritableMap allResults = Arguments.createMap();
                    allResults.putString("totalLength", mDecimalFormat.format(totalLength));
                    sendEvent(mReactContext, "onTotalLengthChanged", allResults);
                }
            }

            @Override
            public boolean callPreFrame() {
                return true;
            }

            @Override
            public void onPreDraw(long sceneTime, double deltaTime) {
            }

            @Override
            public void onPostFrame(long sceneTime, double deltaTime) {

            }
        });

        mSurfaceView.setSurfaceRenderer(mRenderer);
    }

    @ReactMethod
    public void startNewRecording(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------startNewRecording--------RN--------");
            isShowTrace = true;

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void stopRecording(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------stopRecording--------RN--------");
            isShowTrace = false;

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setArSceneViewVisible(boolean isVisible, Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------setArSceneViewVisible--------RN--------");
            if (isVisible) {
            } else {
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void onResume(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------onResume--------RN--------");

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void onPause(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------onPause--------RN--------");

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void onDestroy(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------onDestroy--------RN--------");
            isShowTrace = false;
            mRenderer.getCurrentScene().clearFrameCallbacks();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
