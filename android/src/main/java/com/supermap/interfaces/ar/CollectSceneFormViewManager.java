package com.supermap.interfaces.ar;

import android.graphics.Color;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.ar.highprecision.MeasureView;
import com.supermap.interfaces.ai.CustomRelativeLayout;
import org.rajawali3d.surface.RajawaliSurfaceView;

public class CollectSceneFormViewManager extends SimpleViewManager<CustomRelativeLayout> {

    public static final String REACT_CLASS = "RCTCollectSceneFormView";

    private MeasureView mMeasureView;
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
        mCustomRelativeLayout.setBackgroundColor(Color.parseColor("#505050"));
        SCollectSceneFormView.setViewManager(mCustomRelativeLayout);

        mMeasureView = new MeasureView(reactContext.getCurrentActivity());
        mMeasureView.setLayoutParams(params);
        SCollectSceneFormView.setMeasureView(mMeasureView);

        mSurfaceView = new RajawaliSurfaceView(reactContext.getCurrentActivity());
        mSurfaceView.setLayoutParams(params);
        SCollectSceneFormView.setSurfaceView(mSurfaceView);

        mCustomRelativeLayout.addView(mMeasureView);
        mCustomRelativeLayout.addView(mSurfaceView);
        mSurfaceView.setZOrderMediaOverlay(true);   // 必须layout.addView之后使用，必须动态调用。

        return mCustomRelativeLayout;
    }

}
