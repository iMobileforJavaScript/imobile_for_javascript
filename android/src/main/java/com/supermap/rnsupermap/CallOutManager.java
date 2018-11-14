package com.supermap.rnsupermap;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.supermap.RNUtils.N_R_EventSender;
import com.supermap.mapping.CallOut;

/**
 * Created by will on 2016/7/27.
 */
public class CallOutManager extends SimpleViewManager<CallOut> {

    public static final String REACT_CLASS = "RCTCallOut";

    ThemedReactContext m_ThemedReactContext;
    CallOut m_CallOut;
    N_R_EventSender n_r_eventSender=new N_R_EventSender();

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public CallOut createViewInstance(ThemedReactContext reactContext){
        m_ThemedReactContext = reactContext;
        m_CallOut = new CallOut(m_ThemedReactContext);
        String callOutId = JSCallOut.registerId(m_CallOut);
        n_r_eventSender.putString("callOutId",callOutId);
        return m_CallOut;
    }

    @ReactProp(name="returnId")
    public void returnId(CallOut callOut, boolean b){
        m_ThemedReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                callOut.getId(),
                "topChange",
                n_r_eventSender.createSender()
        );
    }
}
