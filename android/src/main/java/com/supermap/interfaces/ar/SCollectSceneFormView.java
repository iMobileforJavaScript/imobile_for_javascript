package com.supermap.interfaces.ar;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.google.ar.core.*;
import com.google.ar.core.exceptions.CameraNotAvailableException;
import com.google.ar.core.exceptions.UnavailableException;
import com.google.ar.sceneform.ArSceneView;
import com.google.ar.sceneform.FrameTime;
import com.google.ar.sceneform.Scene;
import com.google.ar.sceneform.SceneView;
import com.supermap.interfaces.ai.CustomRelativeLayout;
import com.supermap.interfaces.ar.rajawali.DemoUtils;
import com.supermap.interfaces.ar.rajawali.MotionRajawaliRenderer;
import org.rajawali3d.scene.ASceneFrameCallback;
import org.rajawali3d.surface.IRajawaliSurface;
import org.rajawali3d.surface.RajawaliSurfaceView;

public class SCollectSceneFormView extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SCollectSceneFormView";
    private static ArSceneView mArSceneView;
    private static RajawaliSurfaceView mSurfaceView;

    private static Context mContext = null;
    private static ReactApplicationContext mReactContext = null;
    private static CustomRelativeLayout mCustomRelativeLayout = null;

    private static Camera mARCamera;
    private static MotionRajawaliRenderer mRenderer;
    private static boolean isShowTrace = true;//初始值
    private static boolean installRequested;

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

    private static Scene.OnUpdateListener mOnUpdateListener = new Scene.OnUpdateListener() {
        @Override
        public void onUpdate(FrameTime frameTime) {

            Frame frame = mArSceneView.getArFrame();
            if (frame == null) {
                return;
            }

            if (frame.getCamera().getTrackingState() != TrackingState.TRACKING) {
                return;
            }

            mARCamera = frame.getCamera();
        }
    };

    public static void setArSceneView(ArSceneView arSceneView) {
        mArSceneView = arSceneView;

        mArSceneView
                .getScene()
                .addOnUpdateListener(mOnUpdateListener);
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

        //轨迹记录开关
//        CheckBox checkBox = findViewById(R.id.cb_start_stop);
//        checkBox.setOnCheckedChangeListener((buttonView, isChecked) -> {
//            if (isChecked) {
//                startNewRecording();
//                arSceneView.setVisibility(View.VISIBLE);
//            } else {
//                stopRecording();
//                arSceneView.setVisibility(View.INVISIBLE);
//            }
//        });
    }

    private static void setupRenderer() {
        // motion renderer
        mSurfaceView.setEGLContextClientVersion(2);
        mRenderer.getCurrentScene().registerFrameCallback(new ASceneFrameCallback() {
            @Override
            public void onPreFrame(long sceneTime, double deltaTime) {
                if (mARCamera != null && isShowTrace) {
                    Pose pose = mARCamera.getDisplayOrientedPose();
                    mRenderer.updateCameraPoseFromMatrix(pose);
                    //记录总长度
                    String totalLength = mRenderer.getTotalLength() + "m";
                    Log.e(REACT_CLASS, "TotalLength: " + totalLength);
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
                mArSceneView.setVisibility(View.VISIBLE);
            } else {
                mArSceneView.setVisibility(View.INVISIBLE);
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
            if (mArSceneView.getSession() == null) {
                try {
                    Session session = DemoUtils.createArSession(getCurrentActivity(), installRequested);
                    if (session == null) {
//                  requestPermissions();
                        return;
                    } else {
                        mArSceneView.setupSession(session);
                    }
                } catch (UnavailableException e) {
                    DemoUtils.handleSessionException(getCurrentActivity(), e);
                }
            }

            try {
                mArSceneView.resume();
            } catch (CameraNotAvailableException ex) {
                DemoUtils.displayError(mContext, "Unable to get camera", ex);
                return;
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void onPause(Promise promise) {
        try {
            Log.d(REACT_CLASS, "----------------onPause--------RN--------");
            mArSceneView.pause();

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
            mArSceneView.getScene().removeOnUpdateListener(mOnUpdateListener);
            mRenderer.getCurrentScene().clearFrameCallbacks();
            mArSceneView.pause();
            mArSceneView.destroy();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
