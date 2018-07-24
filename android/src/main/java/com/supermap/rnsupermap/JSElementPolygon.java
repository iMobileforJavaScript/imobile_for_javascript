package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Geometry;
import com.supermap.mapping.collector.ElementPolygon;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/7/20.
 */
public class JSElementPolygon extends JSCollectorElement {
    public static final String REACT_CLASS = "JSElementPolygon";
    private static Map<String,ElementPolygon> mElementPolygonList = new HashMap();
    ElementPolygon mElementPolygon;

    public JSElementPolygon(ReactApplicationContext context){super(context);}

    public static ElementPolygon getObjFromList(String id) { return mElementPolygonList.get(id); }

    public static String registerId(ElementPolygon collector){
        if(!mElementPolygonList.isEmpty()) {
            for(Map.Entry entry:mElementPolygonList.entrySet()){
                if(collector.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mElementPolygonList.put(id,collector);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }


    @ReactMethod
    public void createObj(Promise promise){
        try{
            ElementPolygon element = new ElementPolygon();
            String elementId = registerId(element);

            promise.resolve(elementId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 通过 Geomotry 构造面类型的采集对象
     * @param collectorId
     * @param geometryId
     * @param promise
     */
    @ReactMethod
    public void fromGeometry(String collectorId, String geometryId, Promise promise){
        try{
            ElementPolygon elemnt = mElementPolygonList.get(collectorId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            boolean result = elemnt.fromGeometry(geometry);
            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }

}
