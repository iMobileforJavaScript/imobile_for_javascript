package com.supermap.rnsupermap;

import com.supermap.RNUtils.N_R_EventSender;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.supermap.data.Environment;
import com.supermap.mapping.MapView;

/**
 * Created by will on 2016/6/16.
 */
public class MapViewManager extends SimpleViewManager<MapView> {
    public static final String REACT_CLASS="RCTMapView";
    private final String sdcard = android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();

    ThemedReactContext m_ThemedReactContext;
    MapView m_MapView;
    N_R_EventSender n_r_eventSender=new N_R_EventSender();

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public MapView createViewInstance(ThemedReactContext reactContext){
        // 设置许可路径,初始化环境
        Environment.setLicensePath(sdcard + "/SuperMap/license/");
        Environment.initialization(reactContext.getBaseContext());

        m_ThemedReactContext=reactContext;
        m_MapView = new MapView(reactContext.getBaseContext());

        String mapViewId = JSMapView.registerId(m_MapView);
        n_r_eventSender.putString("mapViewId",mapViewId);

        return m_MapView;
    }

    @ReactProp(name="returnId")
    public void returnId(MapView view, boolean b){
        //向JS返回MapView的ID
        m_ThemedReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                view.getId(),
                "topChange",
                n_r_eventSender.createSender()
        );
    }
}
