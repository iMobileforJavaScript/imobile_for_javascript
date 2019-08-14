package com.supermap.interfaces.ar;

import android.support.annotation.Nullable;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.ar.highprecision.MeasureView;
import com.supermap.ar.highprecision.OnLengthChangedListener;

import java.text.DecimalFormat;

/**
 * AR高精度采集
 */
public class MeasureViewManager extends SimpleViewManager<MeasureView> {

    public static final String REACT_CLASS = "RCTMeasureView";

    private ThemedReactContext mReactContext = null;
    private MeasureView mMeasureView = null;
    private DecimalFormat mDecimalFormat = new DecimalFormat("0.0000");

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

        mMeasureView.setOnLengthChangedListener(mOnLengthChangedListener);

        return mMeasureView;
    }

    private OnLengthChangedListener mOnLengthChangedListener = new OnLengthChangedListener() {
        @Override
        public void onCurrentLengthChanged(float value) {
            Log.d(REACT_CLASS, "onCurrentLengthChanged: " + value);
            WritableMap params = Arguments.createMap();
            params.putString("current", mDecimalFormat.format(value));
            sendEvent(mReactContext, "onCurrentLengthChanged", params);
        }

        @Override
        public void onTotalLengthChanged(float value) {
            Log.d(REACT_CLASS, "onTotalLengthChanged: " + value);
            WritableMap params = Arguments.createMap();
            params.putString("total", mDecimalFormat.format(value));
            sendEvent(mReactContext, "onTotalLengthChanged", params);
        }
    };

    private static void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }
}
