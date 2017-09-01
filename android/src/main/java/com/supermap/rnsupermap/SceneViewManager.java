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

    ThemedReactContext m_ThemedReactContext;
    SceneControl mSceneControl;
    N_R_EventSender n_r_eventSender = new N_R_EventSender();

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @Override
    public SceneControl createViewInstance(ThemedReactContext reactContext){
        Environment.initialization(reactContext.getBaseContext());
        m_ThemedReactContext = reactContext;
        mSceneControl = new SceneControl(m_ThemedReactContext);
        String sceneControlId = JSSceneControl.registerId(mSceneControl);
//        mSceneControl.sceneControlInitedComplete(new SceneControl.SceneControlInitedCallBackListenner() {
//            @Override
//            public void onSuccess(String s) {
//
//            }
//        });
        n_r_eventSender.putString("sceneControlId",sceneControlId);
        return mSceneControl;
    }

    @ReactProp(name="returnId")
    public void returnId(SceneControl view, boolean b){
        //向JS返回MapView的ID
        m_ThemedReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                view.getId(),
                "topChange",
                n_r_eventSender.createSender()
        );
    }
}
