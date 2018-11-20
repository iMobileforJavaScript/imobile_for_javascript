package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.GeoPoint;

import java.util.Calendar;
import java.util.Map;

public class JSGeoPoint extends JSGeometry {
    public static final String REACT_CLASS = "JSGeoPoint";
    GeoPoint m_GeoPoint;

    public JSGeoPoint(ReactApplicationContext context) {
        super(context);
    }

    public static GeoPoint getObjFromList(String id) {
        return (GeoPoint)m_GeometryList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(GeoPoint obj) {
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
    public void createObj(Promise promise){
        try{
            GeoPoint geoPoint = new GeoPoint();
            String geoPointId = registerId(geoPoint);

            WritableMap map = Arguments.createMap();
            map.putString("geoPointId",geoPointId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjByXY(Double longitude,Double latitude,Promise promise){
        try{
            GeoPoint geoPoint = new GeoPoint(longitude,latitude);
            String geoPointId = registerId(geoPoint);

            WritableMap map = Arguments.createMap();
            map.putString("geoPointId",geoPointId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getX(String geoPointId,Promise promise){
        try{
            GeoPoint geoPoint = getObjFromList(geoPointId);
            Double coordsX = geoPoint.getX();

            WritableMap map = Arguments.createMap();
            map.putDouble("coordsX",coordsX);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getY(String geoPointId,Promise promise){
        try{
            GeoPoint geoPoint = getObjFromList(geoPointId);
            Double coordsY = geoPoint.getY();

            WritableMap map = Arguments.createMap();
            map.putDouble("coordsY",coordsY);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

