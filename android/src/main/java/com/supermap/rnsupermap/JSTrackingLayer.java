package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Geometry;
import com.supermap.mapping.TrackingLayer;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSTrackingLayer extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTrackingLayer";
    private static Map<String, TrackingLayer> m_TrackingLayerList = new HashMap<String, TrackingLayer>();
    TrackingLayer m_TrackingLayer;

    public JSTrackingLayer(ReactApplicationContext context) {
        super(context);
    }

    public static TrackingLayer getObjFromList(String id) {
        return m_TrackingLayerList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(TrackingLayer obj) {
        for (Map.Entry entry : m_TrackingLayerList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_TrackingLayerList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void add(String trackingLayerId, String geoId, String tag, Promise promise){
        try{
            TrackingLayer trackingLayer = getObjFromList(trackingLayerId);
            Geometry geometry = JSGeometry.getObjFromList(geoId);
            trackingLayer.add(geometry,tag);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void clear(String trackingLayerId,Promise promise){
        try{
            TrackingLayer trackingLayer = getObjFromList(trackingLayerId);
            trackingLayer.clear();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    private Geometry findGeometryType(String geoId, Promise promise) throws Exception {
        if(JSGeoPoint.getObjFromList(geoId) != null){
            return  JSGeoPoint.getObjFromList(geoId);
        }
        throw new Exception("Can`t find Geometry instance!");
    }
}

