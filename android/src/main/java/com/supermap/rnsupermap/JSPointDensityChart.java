package com.supermap.rnsupermap;

import android.os.Handler;
import android.os.Looper;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;
import com.supermap.mapping.imChart.ColorScheme;
import com.supermap.mapping.imChart.PointDensityChart;

import java.util.Calendar;
import java.util.Map;

/**
 * Created by Myself on 2017/6/1.
 */

public class JSPointDensityChart extends JSChartView {
    private static final String MODULE_NAME = "JSPointDensityChart";
    ReactApplicationContext m_context;

    public JSPointDensityChart(ReactApplicationContext context){
        super(context);
        m_context = context;
    }

    public static PointDensityChart getObjFromList(String id){
        return (PointDensityChart) m_ChartViewList.get(id);
    }

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId(PointDensityChart obj) {
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
    public void createObj(final String mapCtrId,final Promise promise){
        try{
            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(new Runnable() {
                @Override
                public void run() {
                    //已在主线程中，可以更新UI
                    MapControl mapCtr = JSMapControl.getObjFromList(mapCtrId);
                    com.supermap.mapping.Map map = mapCtr.getMap();
                    MapView mapView = map.getMapView();
                    PointDensityChart pointDensityChart = new PointDensityChart(m_context,mapView);
                    String pointDensityChartId = registerId(pointDensityChart);

                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putString("pointDensityChartId",pointDensityChartId);
                    promise.resolve(writeMap);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setColorScheme(String chartId, String schemeId, Promise promise){
        try{
            PointDensityChart pointDensityChart = getObjFromList(chartId);
            ColorScheme colorScheme = JSColorScheme.getObjFromList(schemeId);
            pointDensityChart.setColorScheme(colorScheme);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
