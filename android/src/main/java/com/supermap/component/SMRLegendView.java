package com.supermap.component;

import android.view.View;
import android.view.ViewGroup;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.supermap.RNUtils.RNLegendView;
import com.supermap.data.Color;
import com.supermap.data.GeoStyle;
import com.supermap.data.Symbol;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.ColorLegendItem;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Layers;
import com.supermap.mapping.Legend;
import com.supermap.mapping.LegendView;
import com.supermap.mapping.ThemeGridRange;
import com.supermap.mapping.ThemeRange;
import com.supermap.mapping.ThemeType;
import com.supermap.mapping.ThemeUnique;
import com.supermap.mapping.view.SymbolLibView;
import com.supermap.smNative.SMSymbol;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;

public class SMRLegendView extends SimpleViewManager<RNLegendView> {
    private static final String REACT_CLASS = "RCTLegendView";
    ThemedReactContext m_ThemedReactContext;
    SymbolLibView symbolLibView;
    RNLegendView m_View;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected RNLegendView createViewInstance(ThemedReactContext reactContext) {
        m_ThemedReactContext = reactContext;
        m_View = new RNLegendView(reactContext);
        m_View.setRowWidth(50);
        m_View.setRowHeight(50);
        m_View.setNumColumns(2);
        m_View.setTextSize(8);
        com.supermap.mapping.Map M_map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
        Legend legend = M_map.getLegend();
        Layers layers = M_map.getLayers();
        Map<String, String> map = new HashMap<String, String>();
        for(int i=0 ;i<layers.getCount();i++){
            Layer layer = layers.get(i);
            if(layer.getTheme()!=null){
                if(layer.getTheme().getType()== ThemeType.RANGE || layer.getTheme().getType()== ThemeType.UNIQUE || layer.getTheme().getType()== ThemeType.GRIDRANGE){
                    if(layer.getTheme().getType()== ThemeType.RANGE){
                        ThemeRange themeRange = (ThemeRange) layer.getTheme();
                        for(int a=0;a<themeRange.getCount();a++){
                            GeoStyle GeoStyle = themeRange.getItem(a).getStyle();
                            map.put(themeRange.getItem(a).getCaption(), GeoStyle.getFillForeColor().toColorString());
                        }
                    }
                    if(layer.getTheme().getType()== ThemeType.UNIQUE){
                        ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                        for(int a=0;a<themeUnique.getCount();a++){
                            GeoStyle GeoStyle = themeUnique.getItem(a).getStyle();
                            map.put(themeUnique.getItem(a).getCaption(), GeoStyle.getFillForeColor().toColorString());
                        }
                    }
                    if(layer.getTheme().getType()== ThemeType.GRIDRANGE){
                        ThemeGridRange themeGridRange = (ThemeGridRange) layer.getTheme();
                        for(int a=0;a<themeGridRange.getCount();a++){
                            map.put(themeGridRange.getItem(a).getCaption(), themeGridRange.getItem(a).getColor().toColorString());
                        }
                    }
                }
            }
        }

        for (Map.Entry<String, String> entry : map.entrySet()) {
            int color = android.graphics.Color.parseColor(entry.getValue());
            ColorLegendItem colorLegendItem = new ColorLegendItem();
            colorLegendItem.setColor(color);
            colorLegendItem.setCaption(entry.getKey());
            legend.addColorLegendItem(2,colorLegendItem);
        }
        legend.connectLegendView(m_View);
        return m_View;
    }
}
