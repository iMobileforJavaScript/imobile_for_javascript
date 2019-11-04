package com.supermap.component;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.supermap.RNUtils.N_R_EventSender;
import com.supermap.data.Environment;
import com.supermap.interfaces.mapping.SMapSuspension;
import com.supermap.mapping.MapView;
import com.supermap.rnsupermap.JSMapView;

import java.util.HashMap;
import java.util.Map;

public class MapSuspension extends SimpleViewManager<MapWrapView> {
    public static final String REACT_CLASS="RCTMapViewSus";
    private final String sdcard = android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();
    ThemedReactContext m_ThemedReactContext;
    MapWrapView m_MapView;
    N_R_EventSender n_r_eventSender=new N_R_EventSender();

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public MapWrapView createViewInstance(ThemedReactContext reactContext){
        // 设置许可路径,初始化环境
        Environment.setLicensePath(sdcard + "/iTablet/license/");
        Environment.initialization(reactContext.getBaseContext());

        m_ThemedReactContext=reactContext;
        m_MapView = new MapWrapView(reactContext.getBaseContext());

        return m_MapView;
    }

    @ReactProp(name="returnId")
    public void returnId(MapView view, boolean b){
        WritableMap event = Arguments.createMap();
        event.putString("mapViewId", ""+view.getId());

        //向JS返回MapView的ID
        m_ThemedReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                view.getId(),
                "topChange",
                event
        );
        SMapSuspension.m_MapWrapViewList.put(""+view.getId(),view);
    }


    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put(
                        "topChange",
                        MapBuilder.of(
                                "phasedRegistrationNames",
                                MapBuilder.of("bubbled", "onChange")))
                .build();
    }
}
