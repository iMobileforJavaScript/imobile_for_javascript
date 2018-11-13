package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Point2D;
import com.supermap.mapping.imChart.RelationalChartPoint;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Map;

/**
 * Created by Myself on 2017/11/16.
 */

public class JSRelationalChartPoint extends JSChartPoint {
    private static final String MODULE_NAME = "JSRelationalChartPoint";
    ReactApplicationContext m_context;

    public JSRelationalChartPoint(ReactApplicationContext context){
        super(context);
        m_context = context;
    }

    public static RelationalChartPoint getObjFromList(String id){
        return (RelationalChartPoint) m_ChartPointList.get(id);
    }

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId(RelationalChartPoint obj) {
        for (Map.Entry entry : m_ChartPointList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ChartPointList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(float weight, double x, double y, Promise promise){
        try {
            Point2D point = new Point2D(x,y);
            RelationalChartPoint chartPoint = new RelationalChartPoint(point,weight);
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
            RelationalChartPoint chartPoint = new RelationalChartPoint(point,weight);
            String chartPointId = registerId(chartPoint);

            WritableMap map = Arguments.createMap();
            map.putString("_chartpointId",chartPointId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getRelationalName(String pointId, Promise promise){
        try {
            RelationalChartPoint point = getObjFromList(pointId);
            String name = point.getRelationName();
            WritableMap map = Arguments.createMap();
            map.putString("name",name);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setRelationalName(String pointId, String name, Promise promise){
        try {
            RelationalChartPoint point = getObjFromList(pointId);
            point.setRelationName(name);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setRelationalPoints(String pointId, ReadableArray idArr, Promise promise){
        try {
            int count = idArr.size();
            RelationalChartPoint point = getObjFromList(pointId);
            ArrayList list =new ArrayList();
            for(int i=0;i<count;i++){
                String itemId = idArr.getString(i);
                RelationalChartPoint itemPoint = getObjFromList(itemId);
                list.add(itemPoint);
            }
            point.setRelationalPoints(list);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addRelationalPoint(String pointId, String itemPointId, Promise promise){
        try {
            RelationalChartPoint point = getObjFromList(pointId);
            RelationalChartPoint itemPoint = getObjFromList(itemPointId);
            point.getRelationalPoints().add(itemPoint);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
