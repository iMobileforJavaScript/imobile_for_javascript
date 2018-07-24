package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Geometry;
import com.supermap.mapping.collector.ElementPoint;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/7/20.
 */
public class JSElementPoint extends JSCollectorElement {
    public static final String REACT_CLASS = "JSElementPoint";
    private static Map<String,ElementPoint> mElementPointList = new HashMap();
    ElementPoint mElementPoint;

    public JSElementPoint(ReactApplicationContext context){super(context);}

    public static ElementPoint getObjFromList(String id) { return mElementPointList.get(id); }

    public static String registerId(ElementPoint collector){
        if(!mElementPointList.isEmpty()) {
            for(Map.Entry entry:mElementPointList.entrySet()){
                if(collector.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mElementPointList.put(id,collector);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }


    @ReactMethod
    public void createObj(Promise promise){
        try{
            ElementPoint element = new ElementPoint();
            String elementId = registerId(element);

            promise.resolve(elementId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 通过 Geomotry 构造点类型的采集对象
     * @param collectorId
     * @param geometryId
     * @param promise
     */
    @ReactMethod
    public void fromGeometry(String collectorId, String geometryId, Promise promise){
        try{
            ElementPoint elemnt = mElementPointList.get(collectorId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            boolean result = elemnt.fromGeometry(geometry);
            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }

}
