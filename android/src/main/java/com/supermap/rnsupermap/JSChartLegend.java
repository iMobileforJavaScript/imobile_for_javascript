package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.mapping.imChart.ChartLegend;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/27.
 */

public class JSChartLegend extends ReactContextBaseJavaModule {
    private static final String MODULE_NAME = "JSChartLegend";
    protected static Map <String,ChartLegend> m_ChartLegendList = new HashMap<String, ChartLegend>();

    ChartLegend m_ChartLegend;

    public JSChartLegend(ReactApplicationContext reactContext){
        super(reactContext);
    }

    public static ChartLegend getObjFromList(String id){
        return m_ChartLegendList.get(id);
    }

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId (ChartLegend Obj){
        for (Map.Entry entry : m_ChartLegendList.entrySet()) {
            if (Obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ChartLegendList.put(id, Obj);
        return id;
    }

    @ReactMethod
    public void setOrient(String id, boolean b, Promise promise){
        try {
            ChartLegend chartLegend = getObjFromList(id);
            chartLegend.setOrient(b);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isOrient(String id, Promise promise){
        try {
            //ChartLegend chartLegend = getObjFromList(id);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAlignment(String id, int alignment, Promise promise){
        try {
            ChartLegend chartLegend = getObjFromList(id);
            chartLegend.setAlignment(alignment);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAlignment(String id, Promise promise){
        try {
            //ChartLegend chartLegend = getObjFromList(id);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
