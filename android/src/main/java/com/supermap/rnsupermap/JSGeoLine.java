package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.GeoLine;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;

import java.util.Calendar;
import java.util.Map;

public class JSGeoLine extends JSGeometry {
    public static final String REACT_CLASS = "JSGeoLine";
    GeoLine m_GeoLine;

    public JSGeoLine(ReactApplicationContext context) {
        super(context);
    }

    public static GeoLine getObjFromList(String id) {
        return (GeoLine)m_GeometryList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(GeoLine obj) {
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
            GeoLine geoLine = new GeoLine();
            String geoLineId = registerId(geoLine);

            WritableMap map = Arguments.createMap();
            map.putString("geoLineId",geoLineId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjByPts(ReadableArray points, Promise promise){
        try{
            Point2D [] point2D_arr = {};
            for(int i = 0 ; i < points.size() ; i++){
                double x = points.getMap(i).getDouble("x");
                double y = points.getMap(i).getDouble("y");
                Point2D p2D = new Point2D(x,y);
                point2D_arr[i] = p2D;
            }

            Point2Ds p2Ds = new Point2Ds(point2D_arr);
            GeoLine geoLine = new GeoLine(p2Ds);
            String geoLineId = registerId(geoLine);

            WritableMap map = Arguments.createMap();
            map.putString("geoLineId",geoLineId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

