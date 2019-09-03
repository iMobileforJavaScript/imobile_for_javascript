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
import com.supermap.ar.highprecision.OnRuntimeStatusChangedListener;

import java.text.DecimalFormat;

/**
 * AR户型图采集
 */
public class MeasureViewManager extends SimpleViewManager<CustomMeasureView> {

    public static final String REACT_CLASS = "RCTMeasureView";

    private ThemedReactContext mReactContext = null;
    private CustomMeasureView mMeasureView = null;
    private DecimalFormat mDecimalFormat = new DecimalFormat("0.00");

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected CustomMeasureView createViewInstance(ThemedReactContext reactContext) {
        mReactContext = reactContext;

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        mMeasureView = new CustomMeasureView(reactContext.getCurrentActivity());
        mMeasureView.setLayoutParams(params);
        SMeasureView.setInstance(mMeasureView);

        mMeasureView.setOnLengthChangedListener(mOnLengthChangedListener);
        mMeasureView.setOnRuntimeStatusChangedLisener(mOnRuntimeStatusChangedListener);

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

    private OnRuntimeStatusChangedListener mOnRuntimeStatusChangedListener = new OnRuntimeStatusChangedListener() {
        @Override
        public void onRuntimeNotice(MeasureView.RuntimeStatus runtimeStatus, String s) {
            Log.d(REACT_CLASS, "onRuntimeNotice: " + s );
            if (runtimeStatus == MeasureView.RuntimeStatus.SEARCHING_SURFACES) {
                sendEvent(mReactContext, "onSearchingSurfaces", null);
            } else if (runtimeStatus == MeasureView.RuntimeStatus.SEARCHING_SURFACES_SUCCEED) {
                sendEvent(mReactContext, "onSearchingSurfacesSucceed", null);
            } else if (runtimeStatus == MeasureView.RuntimeStatus.INITIAL_FAILED) {

            } else if (runtimeStatus == MeasureView.RuntimeStatus.RUNTIME_TRACKING_PAUSED) {

            } else if (runtimeStatus == MeasureView.RuntimeStatus.RUNTIME_TRACKING_STOPPED) {

            }
        }
    };

    private void sendEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }
}
