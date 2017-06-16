package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;
import com.supermap.mapping.imChart.ChartView;
import com.supermap.mapping.imChart.ColorScheme;
import com.supermap.mapping.imChart.HotChart;

import java.util.Calendar;
import java.util.Map;

/**
 * Created by Myself on 2017/6/1.
 */

public class JSHotChart extends JSChartView {
    private static final String MODULE_NAME = "JSHotChart";
    JSHotChart m_HotChart;
    ReactApplicationContext m_context;

    public JSHotChart(ReactApplicationContext context){
        super(context);
        m_context = context;
    }
    public static HotChart getObjFromList(String id){
        return (HotChart) m_ChartViewList.get(id);
    }
    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId(HotChart obj) {
        for (Map.Entry entry : m_ChartViewList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ChartViewList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(String mapCtrId, Promise promise){
        try{
            MapControl mapCtr = JSMapControl.getObjFromList(mapCtrId);
            com.supermap.mapping.Map map = mapCtr.getMap();
            MapView mapView = map.getMapView();
            HotChart hotChart = new HotChart(m_context,mapView);
            String hotChartId = registerId(hotChart);

            WritableMap writeMap = Arguments.createMap();
            writeMap.putString("hotChartId",hotChartId);
            promise.resolve(writeMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setColorScheme(String hotChartId, String schemeId, Promise promise){
        try{
            HotChart hotChart = getObjFromList(hotChartId);
            ColorScheme colorScheme = JSColorScheme.getObjFromList(schemeId);
            hotChart.setColorScheme(colorScheme);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
