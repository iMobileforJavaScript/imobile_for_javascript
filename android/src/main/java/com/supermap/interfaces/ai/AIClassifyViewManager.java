package com.supermap.interfaces.ai;

import android.graphics.Color;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.wonderkiln.camerakit.CameraView;

public class AIClassifyViewManager extends SimpleViewManager<CustomRelativeLayout> {

    public static final String REACT_CLASS = "RCTAIClassifyView";

    private ThemedReactContext mReactContext = null;
    private CustomRelativeLayout mCustomRelativeLayout = null;
    private CameraView mCameraView = null;
    private ImageView mImageView = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected CustomRelativeLayout createViewInstance(ThemedReactContext reactContext) {
        mReactContext = reactContext;

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        mCustomRelativeLayout = new CustomRelativeLayout(reactContext);
        mCustomRelativeLayout.setLayoutParams(params);
        mCustomRelativeLayout.setBackgroundColor(Color.parseColor("#FFFFFF"));

        mCameraView = new CameraView(reactContext);
        mCameraView.setLayoutParams(params);
        SAIClassifyView.setInstance(mCameraView);

        mImageView = new ImageView(reactContext);
        RelativeLayout.LayoutParams paramsImage = new RelativeLayout.LayoutParams(380, 500);
        paramsImage.setMargins(20, 20, 20, 20);
        mImageView.setBackgroundColor(Color.parseColor("#80C0C0C0"));
        mImageView.setLayoutParams(paramsImage);
        mImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        SAIClassifyView.setImageView(mImageView);

        mCustomRelativeLayout.addView(mCameraView);
        mCustomRelativeLayout.addView(mImageView);

        return mCustomRelativeLayout;
    }


}
