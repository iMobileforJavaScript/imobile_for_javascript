package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Point;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSPoint extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSPoint";
    public static Map<String, Point> m_PointList = new HashMap<String, Point>();
    Point m_Point;

    public JSPoint(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public Point getObjFromList(String id){
        return m_PointList.get(id);
    }

    public static String registerId(Point obj) {
        for (Map.Entry entry : m_PointList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_PointList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(int x , int y , Promise promise){
        try{
            Point point = new Point(x,y);
            String pointId = registerId(point);

            WritableMap map = Arguments.createMap();
            map.putString("pointId",pointId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}

