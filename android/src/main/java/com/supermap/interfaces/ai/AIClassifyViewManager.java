package com.supermap.interfaces.ai;

import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.wonderkiln.camerakit.CameraView;

public class AIClassifyViewManager extends SimpleViewManager<RelativeLayout> {

    public static final String REACT_CLASS = "RCTAIClassifyView";

    private ThemedReactContext mReactContext = null;
    private RelativeLayout mCustomRelativeLayout = null;
    private CameraView mCameraView = null;
//    private ImageView mImageView = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected RelativeLayout createViewInstance(ThemedReactContext reactContext) {
        mReactContext = reactContext;

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        mCustomRelativeLayout = new RelativeLayout(reactContext);
        mCustomRelativeLayout.setLayoutParams(params);
        mCustomRelativeLayout.setBackgroundColor(Color.parseColor("#FFFFFF"));

        mCameraView = new CameraView(reactContext);
        mCameraView.setLayoutParams(params);
        SAIClassifyView.setInstance(mCameraView);
        mCustomRelativeLayout.addView(mCameraView);

//        mImageView = new ImageView(reactContext);
//        RelativeLayout.LayoutParams paramsImage = new RelativeLayout.LayoutParams(380, 500);
//        paramsImage.setMargins(20, 20, 20, 20);
//        mImageView.setBackgroundColor(Color.parseColor("#80C0C0C0"));
//        mImageView.setLayoutParams(paramsImage);
//        mImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
//        SAIClassifyView.setImageView(mImageView);

//        mCustomRelativeLayout.addView(mImageView);

        return mCustomRelativeLayout;
    }


}
