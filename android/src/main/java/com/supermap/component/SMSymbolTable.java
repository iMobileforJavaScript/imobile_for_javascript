package com.supermap.component;

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
import com.supermap.data.Color;
import com.supermap.data.Symbol;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.view.SymbolLibView;
import com.supermap.smNative.SMSymbol;

import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;

public class SMSymbolTable extends SimpleViewManager<SymbolLibView> {
    private static final String REACT_CLASS = "RCTSymbolTable";
    ThemedReactContext m_ThemedReactContext;
    SymbolLibView symbolLibView;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected SymbolLibView createViewInstance(ThemedReactContext reactContext) {
        m_ThemedReactContext = reactContext;
        symbolLibView = new SymbolLibView(reactContext);
        symbolLibView.setRowOrCol(5);
        symbolLibView.setScrollDirection(SymbolLibView.Orientation.VERTICAL);
        int width = reactContext.getCurrentActivity().getWindowManager().getDefaultDisplay().getWidth();
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(width, 600);
        symbolLibView.setLayoutParams(params);
//        symbolLibView.setBackgroundColor(new Color(255, 0 ,0));
        symbolLibView.setImageSize(50);
        symbolLibView.setTextSize(15);
        symbolLibView.setTextColor(new Color(255, 255, 255));
        symbolLibView.setOnItemClickListener(new SymbolLibView.OnItemClickListener() {
            @Override
            public void onClick(Symbol symbol) {
                WritableMap info = Arguments.createMap();
                info.putInt("id", symbol.getID());
                info.putString("name", symbol.getName());
                int type = symbol.getType().value();
                switch (type) {
                    case 0:
                        info.putString("type", "marker");
                        break;
                    case 1:
                        info.putString("type", "line");
                        break;
                    case 2:
                        info.putString("type", "fill");
                        break;
                    default:
                        info.putString("type", "");
                        break;
                }
                m_ThemedReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
                        symbolLibView.getId(),
                        "onSymbolClick",
                        info
                );
            }
        });
        return symbolLibView;
    }

    @ReactProp(name = "tableStyle")
    public void setStyle(SymbolLibView view, ReadableMap style) {
        if (style.hasKey("orientation")) {
            SymbolLibView.Orientation orientation = style.getInt("orientation") == 0
                    ? SymbolLibView.Orientation.HORIZONTAL
                    : SymbolLibView.Orientation.VERTICAL;
            view.setScrollDirection(orientation);
        }
        if (style.hasKey("height") || style.hasKey("width")) {
            ViewGroup.LayoutParams params = view.getLayoutParams();
            params.width = style.getInt("width");
            params.height = style.getInt("height");
            view.setLayoutParams(params);
        }
        if (style.hasKey("lineSpacing")) {
            view.setItemPadding(style.getInt("lineSpacing"));
        }
        if (style.hasKey("count") && style.getInt("count") > 0) {
            view.setRowOrCol(style.getInt("count"));
        }
        if (style.hasKey("imageSize")) {
            view.setImageSize(style.getInt("imageSize"));
        }
        if (style.hasKey("textSize")) {
            view.setTextSize(style.getInt("textSize"));
        }
        if (style.hasKey("textColor")) {
            ReadableMap textColor = style.getMap("textColor");
            int r = textColor.getInt("r");
            int g = textColor.getInt("g");
            int b = textColor.getInt("b");
            int a = textColor.getInt("a") >= 0 ? textColor.getInt("r") : 255;
            view.setTextColor(new Color(r, g, b, a));
        }
        if (style.hasKey("legendBackgroundColor")) {
            ReadableMap textColor = style.getMap("legendBackgroundColor");
            int r = textColor.getInt("r");
            int g = textColor.getInt("g");
            int b = textColor.getInt("b");
            int a = textColor.getInt("a") >= 0 ? textColor.getInt("r") : 255;
            view.setBackgroundColor(new Color(r, g, b, a));
        }
    }

    @ReactProp(name = "data")
    public void setData(SymbolLibView view, ReadableArray data) {
        List arr = data.toArrayList();
        List<Symbol> symbols = SMSymbol.findSymbolsByIDs(SMap.getSMWorkspace().getWorkspace().getResources(), "", arr);

        view.showSymbols(symbols);
        view.scrollBy(0,1);
    }

    @Nullable
    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put(
                        "onSymbolClick",
                        MapBuilder.of(
                                "phasedRegistrationNames",
                                MapBuilder.of("bubbled", "onSymbolClick")))
                .build();
    }
}
