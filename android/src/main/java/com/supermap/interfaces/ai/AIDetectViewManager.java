package com.supermap.interfaces.ai;

import android.view.ViewGroup;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;

/**
 * AI智能识别
 */
public class AIDetectViewManager extends SimpleViewManager<CustomAIDetectView> {

    public static final String REACT_CLASS="RCTAIDetectView";

    private ThemedReactContext mReactContext = null;
    private CustomAIDetectView mAIdetectView = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected CustomAIDetectView createViewInstance(ThemedReactContext reactContext) {
        mReactContext = reactContext;

        mAIdetectView = new CustomAIDetectView(reactContext.getCurrentActivity());
        SAIDetectView.setInstall(mAIdetectView);

        return mAIdetectView;
    }



}
