package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;
import com.supermap.mapping.imChart.ColorScheme;
import com.supermap.mapping.imChart.PolymerChart;

import java.util.Calendar;
import java.util.Map;

/**
 * Created by Myself on 2017/6/1.
 */

public class JSPolymerChart extends JSChartView {
    private static final String MODULE_NAME = "JSPolymerChart";
    ReactApplicationContext m_context;

    public JSPolymerChart(ReactApplicationContext context){
        super(context);
        m_context = context;
    }

    public static PolymerChart getObjFromList(String id){
        return (PolymerChart) m_ChartViewList.get(id);
    }

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId(PolymerChart obj) {
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
            PolymerChart polymerChart = new PolymerChart(m_context,mapView);
            String polymerChartId = registerId(polymerChart);

            WritableMap writeMap = Arguments.createMap();
            writeMap.putString("polymerChartId",polymerChartId);
            promise.resolve(writeMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setPolymerizationType(String chartId,int type, Promise promise){
        try{
            PolymerChart polymerChart = getObjFromList(chartId);
            polymerChart.setPolymeriztionType(type);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getPolymerizationType(String chartId, Promise promise){
        try{
            PolymerChart polymerChart = getObjFromList(chartId);
            int type = polymerChart.getPolymeriztionType();

            WritableMap map = Arguments.createMap();
            map.putInt("type",type);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setUnfoldColor(String chartId, ReadableMap colorObj, Promise promise){
        try{
            PolymerChart polymerChart = getObjFromList(chartId);
            int red = colorObj.getInt("red");
            int green = colorObj.getInt("green");
            int blue = colorObj.getInt("blue");
            int alpha = colorObj.getInt("alpha");
            Color color = new Color(red,green,blue,alpha);

            polymerChart.setUnfoldColor(color);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getUnfoldColor(String chartId, Promise promise){
        try{
            //PolymerChart polymerChart = getObjFromList(chartId);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setFoldColor(String chartId, ReadableMap colorObj, Promise promise){
        try{
            PolymerChart polymerChart = getObjFromList(chartId);
            int red = colorObj.getInt("red");
            int green = colorObj.getInt("green");
            int blue = colorObj.getInt("blue");
            int alpha = colorObj.getInt("alpha");
            Color color = new Color(red,green,blue,alpha);

            polymerChart.setFoldColor(color);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFoldColor(String chartId, Promise promise){
        try{
            //PolymerChart polymerChart = getObjFromList(chartId);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setColorScheme(String chartId, String schemeId, Promise promise){
        try{
            PolymerChart polymerChart = getObjFromList(chartId);
            ColorScheme colorScheme = JSColorScheme.getObjFromList(schemeId);
            polymerChart.setColorScheme(colorScheme);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
