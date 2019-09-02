package com.supermap.interfaces.ai;

import android.graphics.Color;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

public class AIClassifyViewManager extends SimpleViewManager<RelativeLayout> {

    public static final String REACT_CLASS = "RCTAIClassifyView";

    private ThemedReactContext mReactContext = null;
    private RelativeLayout mCustomRelativeLayout = null;

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

        return mCustomRelativeLayout;
    }


}
