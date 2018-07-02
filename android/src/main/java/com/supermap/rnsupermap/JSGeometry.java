package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.Point2D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSGeometry extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSGeometry";
    protected static Map<String, Geometry> m_GeometryList = new HashMap<String, Geometry>();
    Geometry m_Geometry;

    public JSGeometry(ReactApplicationContext context) {
        super(context);
    }

    public static Geometry getObjFromList(String id) {
        return m_GeometryList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Geometry obj) {
        for (Map.Entry entry : m_GeometryList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_GeometryList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void getInnerPoint(String geometryId, Promise promise){
        try{
            Geometry geometry = m_GeometryList.get(geometryId);
            Point2D point2D = geometry.getInnerPoint();
            String point2DId = JSPoint2D.registerId(point2D);

            WritableMap map = Arguments.createMap();
            map.putString("point2DId",point2DId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setStyle(String geometryId,String geoStyleId,Promise promise){
        try{
            Geometry geometry = getObjFromList(geometryId);
            GeoStyle geoStyle = JSGeoStyle.getObjFromList(geoStyleId);
            geometry.setStyle(geoStyle);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}

