package com.supermap.component;

import android.util.Log;
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
import com.supermap.mapping.LegendItem;
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
        com.supermap.mapping.Map M_map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
        Legend legend = M_map.createLegend();
        Layers layers = M_map.getLayers();
        ArrayList<HashMap<String, String>> arrayList = new ArrayList<>();

        for (int i = 0; i < layers.getCount(); i++) {
            Layer layer = layers.get(i);
            if (layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.RANGE) {
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();
                    for (int j = 0; j < themeRange.getCount(); j++) {
                        GeoStyle GeoStyle = themeRange.getItem(j).getStyle();
                        HashMap<String, String> map = new HashMap<String, String>();
                        map.put("Caption", themeRange.getItem(j).getCaption());
                        map.put("Color", GeoStyle.getFillForeColor().toColorString());
                        arrayList.add(map);
                    }
                }
            }
        }

        for (int i = 0; i < arrayList.size(); i++) {
            HashMap<String, String> hashMap = arrayList.get(i);
            String caption = hashMap.get("Caption");
            String colorString = hashMap.get("Color");

            int color = android.graphics.Color.parseColor(colorString);
//            ColorLegendItem colorLegendItem = new ColorLegendItem();
//            colorLegendItem.setColor(color);
//            colorLegendItem.setCaption(caption);
//            legend.addColorLegendItem(2, colorLegendItem);


            LegendItem legendItem = new LegendItem();
            legendItem.setColor(color);
            legendItem.setCaption(caption);
            legend.addUserDefinedLegendItem(legendItem);
        }
        legend.connectLegendView(m_View);
        return m_View;
    }

    @ReactProp(name = "tableStyle")
    public void setStyle(RNLegendView view, ReadableMap style) {
        if (style.hasKey("height") || style.hasKey("width")) {
            view.setRowWidth(style.getInt("width"));
            view.setRowHeight(style.getInt("height"));
        }
        if (style.hasKey("column")) {
            view.setNumColumns(style.getInt("column"));
        }
        if (style.hasKey("textsize")) {
            view.setTextSize(style.getInt("textsize"));
        }

        view.create();
    }

}
