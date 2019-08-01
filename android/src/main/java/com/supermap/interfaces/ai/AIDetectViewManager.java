package com.supermap.interfaces.ai;

import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.ai.AIdetectView;
import com.supermap.ar.ARRendererInfoUtil;
import com.supermap.ar.ArView;

import javax.annotation.Nullable;
import java.util.Map;

/**
 * AI智能识别
 */
public class AIDetectViewManager extends SimpleViewManager<CustomRelativeLayout> {

    public static final String REACT_CLASS = "RCTAIDetectView";

    private ThemedReactContext mReactContext = null;
    private AIdetectView mAIdetectView = null;
    private ArView mArView = null;
    private CustomRelativeLayout mCustomRelativeLayout = null;

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
        SAIDetectView.setViewManager(mCustomRelativeLayout);

        mAIdetectView = new AIdetectView(reactContext);
        mAIdetectView.setLayoutParams(params);
        SAIDetectView.setInstance(mAIdetectView);

        ARRendererInfoUtil.saveARRendererMode(reactContext, ARRendererInfoUtil.MODE_PROJECTION);
        mArView = new ArView(reactContext);
        mArView.setLayoutParams(params);
        SAIDetectView.setArView(mArView);

        mCustomRelativeLayout.addView(mAIdetectView);
        mCustomRelativeLayout.addView(mArView);

        return mCustomRelativeLayout;
    }

    @Nullable
    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put(
                        "onArObjectClick",
                        MapBuilder.of(
                                "phasedRegistrationNames",
                                MapBuilder.of("bubbled", "onArObjectClick")))
                .build();
    }


}
