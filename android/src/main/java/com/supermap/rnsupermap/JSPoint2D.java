package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Point2D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSPoint2D extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSPoint2D";
    public static Map<String, Point2D> m_Point2DList = new HashMap<String, Point2D>();
    Point2D m_Point2D;

    public JSPoint2D(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Point2D obj) {
        for (Map.Entry entry : m_Point2DList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_Point2DList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            Point2D point2D = new Point2D();
            String point2DId = registerId(point2D);

            WritableMap map = Arguments.createMap();
            map.putString("point2DId",point2DId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjByXY(Double x,Double y,Promise promise){
        try{
            Point2D point2D = new Point2D(x,y);
            String point2DId = registerId(point2D);

            WritableMap map = Arguments.createMap();
            map.putString("point2DId",point2DId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

