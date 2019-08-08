package com.supermap.interfaces.ar;

import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.ar.highprecision.MeasureView;

/**
 * AR高精度采集
 */
public class MeasureViewManager extends SimpleViewManager<MeasureView> {

    public static final String REACT_CLASS = "RCTMeasureView";

    private ThemedReactContext mReactContext = null;
    private MeasureView mMeasureView = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected MeasureView createViewInstance(ThemedReactContext reactContext) {
        mReactContext = reactContext;

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        mMeasureView = new MeasureView(reactContext.getCurrentActivity());
        mMeasureView.setLayoutParams(params);
        SMeasureView.setInstance(mMeasureView);

        return mMeasureView;
    }
}
