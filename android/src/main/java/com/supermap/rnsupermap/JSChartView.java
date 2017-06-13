package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.mapping.imChart.ChartLegend;
import com.supermap.mapping.imChart.ChartPoint;
import com.supermap.mapping.imChart.ChartView;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
/**
 * Created by Myself on 2017/5/27.
 */

public class JSChartView extends ReactContextBaseJavaModule{
    private static final String MODULE_NAME = "JSChartView";
    protected static Map <String, ChartView> m_ChartViewList = new HashMap<String,ChartView>();

    ChartView m_ChartView;

    public JSChartView(ReactApplicationContext reactContext){
        super(reactContext);
    }

    public static ChartView getObjFromList(String id){
        return m_ChartViewList.get(id);
    }

    @Override
    public  String getName(){
        return MODULE_NAME;
    }

    public static String registerId (ChartView Obj){
        for (Map.Entry entry : m_ChartViewList.entrySet()) {
            if (Obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ChartViewList.put(id, Obj);
        return id;
    }

    @ReactMethod
    public void setTitle(String id, String title, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            chartView.setTitle(title);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getTitle(String id, Promise promise){
        try {
            System.out.println("android device don't support this function!");

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLegend(String id, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            ChartLegend chartLegend = chartView.getLegend();
            String chartLegendId = JSChartLegend.registerId(chartLegend);

            WritableMap map = Arguments.createMap();
            map.putString("chartLegendId",chartLegendId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addChartDataWithTime(String id, ArrayList<ChartPoint> data, String timeTag, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            chartView.addChartDataset(data,timeTag);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addChartData(String id, ArrayList<ChartPoint> data, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            chartView.addChartDatas(data);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeChartDataWithTimeTag(String id,String timeTag, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            chartView.removeChartData(timeTag);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeAllData(String id, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            chartView.removeAllData();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String id, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            m_ChartViewList.remove(id);
            chartView.dispose();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void update(String id, Promise promise){
        try {
            ChartView chartView = getObjFromList(id);
            chartView.update();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
