package com.supermap.interfaces.ar;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.component.MapFloorListView;
import com.supermap.interfaces.mapping.SMap;

import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;

public class RCTFloorListView extends SimpleViewManager<MapFloorListView> {
    public static final String REACT_CLASS = "RCTFloorListView";
    MapFloorListView m_View;
    ThemedReactContext m_ThemedReactContext;
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected MapFloorListView createViewInstance(ThemedReactContext reactContext) {
        m_ThemedReactContext = reactContext;
        m_View = new MapFloorListView(reactContext.getCurrentActivity());

        SMap.getInstance().getSmMapWC().setFloorListView(m_View);
//        runOnUiThread(new Runnable() {
//            @Override
//            public void run() {
//                m_View.linkMapControl(SMap.getInstance().getSmMapWC().getMapControl());
//            }
//        });


        return m_View;
    }

}
