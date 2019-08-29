package com.supermap.interfaces.ar;

import android.graphics.Color;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.google.ar.core.Session;
import com.google.ar.core.exceptions.CameraNotAvailableException;
import com.google.ar.core.exceptions.UnavailableException;
import com.google.ar.sceneform.ArSceneView;
import com.supermap.interfaces.ai.CustomRelativeLayout;
import com.supermap.interfaces.ar.rajawali.DemoUtils;
import org.rajawali3d.surface.RajawaliSurfaceView;

public class CollectSceneFormViewManager extends SimpleViewManager<CustomRelativeLayout> {

    public static final String REACT_CLASS = "RCTCollectSceneFormView";

    private ArSceneView mArSceneView;
    private RajawaliSurfaceView mSurfaceView;
    private CustomRelativeLayout mCustomRelativeLayout = null;
    private ThemedReactContext mReactContext = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected CustomRelativeLayout createViewInstance(ThemedReactContext reactContext) {
        Log.d(REACT_CLASS, "----------------createViewInstance--------RN--------");
        mReactContext = reactContext;

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        mCustomRelativeLayout = new CustomRelativeLayout(reactContext);
        mCustomRelativeLayout.setLayoutParams(params);
        mCustomRelativeLayout.setBackgroundColor(Color.parseColor("#FFFFFF"));
        SCollectSceneFormView.setViewManager(mCustomRelativeLayout);

        mArSceneView = new ArSceneView(reactContext);
        mArSceneView.setLayoutParams(params);
        SCollectSceneFormView.setArSceneView(mArSceneView);

        mSurfaceView = new RajawaliSurfaceView(reactContext);
        mSurfaceView.setLayoutParams(params);
        SCollectSceneFormView.setArView(mSurfaceView);

        mCustomRelativeLayout.addView(mArSceneView);
        mCustomRelativeLayout.addView(mSurfaceView);
        mSurfaceView.setZOrderMediaOverlay(true);   // 必须layout.addView之后使用，必须动态调用。

        onResume();

        return mCustomRelativeLayout;
    }

    private void onResume() {
        if (mArSceneView.getSession() == null) {
            try {
                Session session = DemoUtils.createArSession(mReactContext.getCurrentActivity(), false);
                if (session == null) {
//                  requestPermissions();
                    return;
                } else {
                    mArSceneView.setupSession(session);
                }
            } catch (UnavailableException e) {
                DemoUtils.handleSessionException(mReactContext.getCurrentActivity(), e);
            }
        }

        try {
            mArSceneView.resume();
        } catch (CameraNotAvailableException ex) {
            DemoUtils.displayError(mReactContext.getCurrentActivity(), "Unable to get camera", ex);
            return;
        }
    }
}
