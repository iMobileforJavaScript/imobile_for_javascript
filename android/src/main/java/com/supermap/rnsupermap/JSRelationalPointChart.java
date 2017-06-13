package com.supermap.rnsupermap;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;
import com.supermap.mapping.imChart.ColorScheme;
import com.supermap.mapping.imChart.RelationPointChart;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.InputStream;
import java.util.Calendar;
import java.util.Map;

/**
 * Created by Myself on 2017/6/6.
 */

public class JSRelationalPointChart extends JSChartView {
    private static final String MODULE_NAME = "JSRelationalPointChart";
    ReactApplicationContext m_context;

    public JSRelationalPointChart(ReactApplicationContext context){
        super(context);
        m_context = context;
    }

    public static RelationPointChart getObjFromList(String id){
        return (RelationPointChart) m_ChartViewList.get(id);
    }

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId(RelationPointChart obj) {
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
            RelationPointChart relationChart = new RelationPointChart(m_context,mapView);
            String relationChartId = registerId(relationChart);

            WritableMap writeMap = Arguments.createMap();
            writeMap.putString("RelationalPointChart",relationChartId);
            promise.resolve(writeMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAnimation(String chartId,boolean animation, Promise promise){
        try{
            RelationPointChart relationPointChart = getObjFromList(chartId);
            relationPointChart.setIsAnimation(animation);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isAnimation(String chartId, Promise promise){
        try{
            //RelationPointChart relationPointChart = getObjFromList(chartId);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAnimationImage(String chartId,String url, Promise promise){
        try{

            Bitmap image = BitmapFactory.decodeFile(url);
            RelationPointChart relationPointChart = getObjFromList(chartId);
            relationPointChart.setAnimationImage(image);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setColorScheme(String chartId, String schemeId, Promise promise){
        try{
            RelationPointChart relationPointChart = getObjFromList(chartId);
            ColorScheme colorScheme = JSColorScheme.getObjFromList(schemeId);
            relationPointChart.setColorScheme(colorScheme);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}
