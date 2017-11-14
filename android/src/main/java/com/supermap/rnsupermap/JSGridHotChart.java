package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;
import com.supermap.mapping.imChart.ColorScheme;
import com.supermap.mapping.imChart.GridHotChart;

import java.util.Calendar;
import java.util.Map;
import android.os.Handler;
import android.os.Looper;

/**
 * Created by Myself on 2017/6/1.
 */

public class JSGridHotChart extends JSChartView {
    private static final String MODULE_NAME = "JSGridHotChart";
    ReactApplicationContext m_context;

    public JSGridHotChart(ReactApplicationContext context){
        super(context);
        m_context = context;
    }

    public static GridHotChart getObjFromList(String id){
        return (GridHotChart) m_ChartViewList.get(id);
    }

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId(GridHotChart obj) {
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
                    MapControl map1 = mapView.getMapControl();
                    GridHotChart hotChart = new GridHotChart(m_context,mapView);
                    String hotChartId = registerId(hotChart);

                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putString("gridHotChartId",hotChartId);
                    promise.resolve(writeMap);
                }
            });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setColorScheme(String hotChartId, String schemeId, Promise promise){
        try{
            GridHotChart hotChart = getObjFromList(hotChartId);
            ColorScheme colorScheme = JSColorScheme.getObjFromList(schemeId);
            hotChart.setColorScheme(colorScheme);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
