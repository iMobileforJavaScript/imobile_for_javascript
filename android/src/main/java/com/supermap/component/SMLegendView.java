package com.supermap.component;


import android.graphics.Color;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.supermap.RNUtils.RNLegendView;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Legend;
import com.supermap.mapping.LegendView;
import com.supermap.mapping.Map;

public class SMLegendView extends SimpleViewManager<LegendView> {
    private static final String REACT_CLASS = "RCTLegend";
    ThemedReactContext m_ThemeReactContext;
    View m_View;
    LegendView m_LegendView;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected LegendView createViewInstance(ThemedReactContext reactContext) {
        m_ThemeReactContext = reactContext;
//        m_View = new View(m_ThemeReactContext);
        m_LegendView = new LegendView(m_ThemeReactContext);
        Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();

        int width = reactContext.getCurrentActivity().getWindowManager().getDefaultDisplay().getWidth();
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(width, 300);
//        LinearLayout.LayoutParams linearParams =new LinearLayout.LayoutParams(300, 300);

        m_LegendView.setLayoutParams(params);
        m_LegendView.setBackgroundColor(Color.RED);

//        m_View.setLayoutParams(params);
//        m_View.setBackgroundColor(Color.RED);
        Legend legend = map.getLegend();
        legend.connectLegendView(m_LegendView);

        return m_LegendView;
    }

    @ReactProp(name="LegendStyle")
    public void setStyle(LegendView view,ReadableMap style){
//        if (style.hasKey("RowHeight")) {
//            view.setRowHeight(style.getInt("RowHeight"));
//        }
//        if (style.hasKey("TextSize")) {
//            view.setTextSize(style.getInt("TextSize"));
//        }
//        if (style.hasKey("TextColor")) {
//            view.setTextColor(style.getInt("TextColor"));
//        }
        if (style.hasKey("height") || style.hasKey("width")) {
//            LinearLayout.LayoutParams linearParams =new LinearLayout.LayoutParams(style.getInt("width"), style.getInt("height"));
            ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(style.getInt("width"), style.getInt("height"));
            view.setLayoutParams(params);
        }
        view.setBackgroundColor(Color.RED);
    }

}
