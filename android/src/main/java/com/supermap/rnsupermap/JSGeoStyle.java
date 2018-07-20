package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.data.GeoStyle;
import com.supermap.data.Size2D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSGeoStyle extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSGeoStyle";
    private static Map<String, GeoStyle> m_GeoStyleList = new HashMap<String, GeoStyle>();
    GeoStyle m_GeoStyle;

    public JSGeoStyle(ReactApplicationContext context) {
        super(context);
    }

    public static GeoStyle getObjFromList(String id) {
        return m_GeoStyleList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(GeoStyle obj) {
        for (Map.Entry entry : m_GeoStyleList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_GeoStyleList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            GeoStyle geoStyle = new GeoStyle();
            String geoStyleId = registerId(geoStyle);

            WritableMap map = Arguments.createMap();
            map.putString("geoStyleId",geoStyleId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLineColor(String geoStyleId,int r,int g,int b,Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            Color color = new Color(r,g,b);
            geoStyle.setLineColor(color);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLineSymbolID(String geoStyleId,int symboleId,Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            geoStyle.setLineSymbolID(symboleId);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLineWidth(String geoStyleId,Double lineWidth,Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            geoStyle.setLineWidth(lineWidth);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setMarkerSymbolID(String geoStyleId,int markerSymbolId,Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            geoStyle.setMarkerSymbolID(markerSymbolId);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setMarkerSize(String geoStyleId,String size2DId,Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            Size2D size2D = JSSize2D.getObjFromList(size2DId);
            geoStyle.setMarkerSize(size2D);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setFillForeColor(String geoStyleId,int r,int g,int b,Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            geoStyle.setFillForeColor(new Color(r,g,b));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setFillOpaqueRate(String geoStyleId,int rate,Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            geoStyle.setFillOpaqueRate(rate);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLineColor(String geoStyleId, Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            Color color = geoStyle.getLineColor();
            WritableMap map = Arguments.createMap();
            map.putInt("r", color.getR());
            map.putInt("g", color.getG());
            map.putInt("b", color.getB());
            map.putInt("a", color.getA());

            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLineSymbolID(String geoStyleId, Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            int value = geoStyle.getLineSymbolID();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLineWidth(String geoStyleId, Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            double value = geoStyle.getLineWidth();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMarkerSymbolID(String geoStyleId, Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            int value = geoStyle.getMarkerSymbolID();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMarkerSize(String geoStyleId, Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            Size2D size2D = geoStyle.getMarkerSize();
            String size2DId = JSSize2D.registerId(size2D);

            promise.resolve(size2DId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFillForeColor(String geoStyleId, Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            Color color = geoStyle.getFillForeColor();
            WritableMap map = Arguments.createMap();
            map.putInt("r", color.getR());
            map.putInt("g", color.getG());
            map.putInt("b", color.getB());
            map.putInt("a", color.getA());

            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFillOpaqueRate(String geoStyleId, Promise promise){
        try{
            GeoStyle geoStyle = m_GeoStyleList.get(geoStyleId);
            int value = geoStyle.getFillOpaqueRate();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

