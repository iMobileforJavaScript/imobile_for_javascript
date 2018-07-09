package com.supermap.rnsupermap;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.supermap.RNUtils.N_R_EventSender;
import com.supermap.data.Environment;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;

/**
 * Created by will on 2017/3/22.
 */

public class SceneViewManager extends SimpleViewManager<SceneControl> {

    public static final String REACT_CLASS="RCTSceneView";
    private final String sdcard = android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();

    ThemedReactContext m_ThemedReactContext;
    SceneControl mSceneControl;
    final N_R_EventSender n_r_eventSender = new N_R_EventSender();

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @Override
    public SceneControl createViewInstance(ThemedReactContext reactContext){
        Environment.setLicensePath(sdcard + "/SuperMap/license/");
        Environment.initialization(reactContext.getBaseContext());
        m_ThemedReactContext = reactContext;
        mSceneControl = new SceneControl(m_ThemedReactContext);

        final String sceneControlId = JSSceneControl.registerId(mSceneControl);

        n_r_eventSender.putString("sceneControlId",sceneControlId);

        return mSceneControl;
    }

    @ReactProp(name="returnId")
    public void returnId(final SceneControl view, boolean b){
        //向JS返回MapView的ID（必须在scenecontrol初始化后返回，否则会提示getScene（）红屏）
        view.sceneControlInitedComplete(new SceneControl.SceneControlInitedCallBackListenner() {
            @Override
            public void onSuccess(String s) {
                m_ThemedReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                        view.getId(),
                        "topChange",
                        n_r_eventSender.createSender()
                );
            }
        });
    }
}
