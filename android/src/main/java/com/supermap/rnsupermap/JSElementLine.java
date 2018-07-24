package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Geometry;
import com.supermap.mapping.collector.ElementLine;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/7/20.
 */
public class JSElementLine extends JSCollectorElement {
    public static final String REACT_CLASS = "JSElementLine";
    public static Map<String,ElementLine> mElementLineList=new HashMap();
    ElementLine mElementLine;

    public JSElementLine(ReactApplicationContext context){super(context);}

    public static ElementLine getObjFromList(String id) { return mElementLineList.get(id); }

    public static String registerId(ElementLine collector){
        if(!mElementLineList.isEmpty()) {
            for(Map.Entry entry:mElementLineList.entrySet()){
                if(collector.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mElementLineList.put(id,collector);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }


    @ReactMethod
    public void createObj(Promise promise){
        try{
            ElementLine element = new ElementLine();
            String elementId = registerId(element);

            promise.resolve(elementId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 通过 Geomotry 构造线类型的采集对象
     * @param collectorId
     * @param geometryId
     * @param promise
     */
    @ReactMethod
    public void fromGeometry(String collectorId, String geometryId, Promise promise){
        try{
            ElementLine elemnt = mElementLineList.get(collectorId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            boolean result = elemnt.fromGeometry(geometry);
            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }

}
