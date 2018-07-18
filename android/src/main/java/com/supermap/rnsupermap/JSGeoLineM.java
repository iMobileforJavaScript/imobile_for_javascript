package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoLineM;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PointM;
import com.supermap.data.PointMs;

import java.util.Calendar;
import java.util.Map;

public class JSGeoLineM extends JSGeometry {
    public static final String REACT_CLASS = "JSGeoLineM";
    GeoLineM m_GeoLineM;

    public JSGeoLineM(ReactApplicationContext context) {
        super(context);
    }

    public static GeoLineM getObjFromList(String id) {
        return (GeoLineM)m_GeometryList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(GeoLineM obj) {
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
            GeoLineM geoLine = new GeoLineM();
            String geoLineMId = registerId(geoLine);

            promise.resolve(geoLineMId);
        }catch (Exception e){
            promise.reject(e);
        }
    }



    @ReactMethod
    public void createObjByPts(ReadableArray points, Promise promise){
        try{
            PointM[] pointM_arr = {};
            for(int i = 0 ; i < points.size() ; i++){
                double x = points.getMap(i).getDouble("x");
                double y = points.getMap(i).getDouble("y");
                double m = points.getMap(i).getDouble("m");
                PointM pM = new PointM(x, y, m);
                pointM_arr[i] = pM;
            }

            PointMs pMs = new PointMs(pointM_arr);
            GeoLineM geoLineM = new GeoLineM(pMs);
            String geoLineMId = registerId(geoLineM);

            promise.resolve(geoLineMId);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

