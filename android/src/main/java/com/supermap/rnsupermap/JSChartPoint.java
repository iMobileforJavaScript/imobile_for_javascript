package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Point2D;
import com.supermap.mapping.imChart.ChartPoint;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/31.
 */

public class JSChartPoint extends ReactContextBaseJavaModule {
    private static final String MODULE_NAME = "JSChartPoint";
    protected static Map<String,ChartPoint> m_ChartPointList = new HashMap<String, ChartPoint>();

    ChartPoint m_ChartPoint;
    public JSChartPoint(ReactApplicationContext context){super(context);}
    public static ChartPoint getObjFromList(String id){return m_ChartPointList.get(id);}

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId (ChartPoint Obj){
        for (Map.Entry entry : m_ChartPointList.entrySet()) {
            if (Obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ChartPointList.put(id, Obj);
        return id;
    }

    @ReactMethod
    public void createObj(float weight, double x, double y, Promise promise){
        try {
            Point2D point = new Point2D(x,y);
            ChartPoint chartPoint = new ChartPoint(point,weight);
            String chartPointId = registerId(chartPoint);

            WritableMap map = Arguments.createMap();
            map.putString("_chartpointId",chartPointId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjByPoint(float weight, String point2dId, Promise promise){
        try {
            Point2D point = JSPoint2D.m_Point2DList.get(point2dId);
            ChartPoint chartPoint = new ChartPoint(point,weight);
            String chartPointId = registerId(chartPoint);

            WritableMap map = Arguments.createMap();
            map.putString("_chartpointId",chartPointId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
