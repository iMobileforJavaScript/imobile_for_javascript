package com.supermap.rnsupermap;

import com.supermap.RNUtils.N_R_EventSender;
import com.supermap.RNUtils.RNLegendView;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.supermap.mapping.Legend;
import com.supermap.mapping.Map;

/**
 * Created by will on 2016/9/6.
 */
public class LegendViewManager extends SimpleViewManager<RNLegendView> {
    private static final String REACT_CLASS = "RCTLegendView";

    ThemedReactContext m_ThemeReactContext;
    RNLegendView m_LegendView;
    N_R_EventSender n_r_eventSender = new N_R_EventSender();

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @Override
    public RNLegendView createViewInstance(ThemedReactContext reactContext){
        m_ThemeReactContext = reactContext;
        m_LegendView = new RNLegendView(m_ThemeReactContext);
        return m_LegendView;
    }

    @ReactProp(name="mapId")
    public void setMapId(RNLegendView view,String mapId){
        Map map = JSMap.getObjFromList(mapId);

        Legend legend = map.getLegend();
        legend.connectLegendView(view);

    }
}
