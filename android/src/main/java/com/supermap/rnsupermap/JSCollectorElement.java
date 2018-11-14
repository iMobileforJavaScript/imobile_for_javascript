package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.Geometry;
import com.supermap.data.GeometryType;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Rectangle2D;
import com.supermap.mapping.collector.CollectorElement;
import com.supermap.mapping.collector.CollectorElement;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/7/20.
 */
public class JSCollectorElement extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSCollectorElement";
    private static Map<String,CollectorElement> mCollectorElementList = new HashMap();
    CollectorElement mCollectorElement;

    public JSCollectorElement(ReactApplicationContext context){super(context);}

    public static CollectorElement getObjFromList(String id) { return mCollectorElementList.get(id); }

    public static String registerId(CollectorElement collector){
        if(!mCollectorElementList.isEmpty()) {
            for(Map.Entry entry:mCollectorElementList.entrySet()){
                if(collector.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mCollectorElementList.put(id,collector);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    /**
     * 添加点
     * @param collectorId
     * @param point2DId
     * @param promise
     */
    @ReactMethod
    public void addPoint(String collectorId, String point2DId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            Point2D point2D = JSPoint2D.getObjFromList(point2DId);
            collector.addPoint(point2D);
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 通过 Geomotry 构造采集对象
     * @param collectorId
     * @param geometryId
     * @param promise
     */
    @ReactMethod
    public void fromGeometry(String collectorId, String geometryId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            boolean result = collector.fromGeometry(geometry);
            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的边框范围
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getBounds(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            Rectangle2D rectangle2D = collector.getBounds();
            String rectangle2DId = JSRectangle2D.registerId(rectangle2D);
            promise.resolve(rectangle2DId);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的 Geometry
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getGeometry(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            Geometry geometry = collector.getGeometry();
            String geometryId = JSGeometry.registerId(geometry);
            promise.resolve(geometryId);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的几何对象类型
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getGeometryType(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            GeometryType type = collector.getGeometryType();
            int typeValue = type.value();
            promise.resolve(typeValue);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的点串
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getGeoPoints(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            Point2Ds point2Ds = collector.getGeoPoints();
            WritableArray array = JsonUtil.point2DsToJson(point2Ds);

            promise.resolve(array);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的ID
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getID(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            int value = collector.getID();

            promise.resolve(value);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的名称
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getName(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            String value = collector.getName();

            promise.resolve(value);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的备注信息
     * 获取采集对象的名称
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getNotes(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            String value = collector.getNotes();

            promise.resolve(value);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取单击事件监听器
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getOnClickListenner(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            CollectorElement.OnClickListener listener = collector.getOnClickListenner();

            // TODO 获取单击事件监听器
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取点串分组信息（仅适用于通过Geomotry构造的动态数据）
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getPart(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            ArrayList part = collector.getPart();
            WritableArray array = Arguments.fromArray(part);

            promise.resolve(array);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取采集对象的类型
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getType(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            CollectorElement.GPSElementType type = collector.getType();
            String typeName = type.name();

            promise.resolve(typeName);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取用户数据
     * @param collectorId
     * @param promise
     */
    @ReactMethod
    public void getUserData(String collectorId, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            Object object = collector.getUserData();

            promise.resolve(object);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置采集对象的名称
     * @param collectorId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setName(String collectorId, String value, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            collector.setName(value);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置采集对象的备注信息
     * @param collectorId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setNotes(String collectorId, String value, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            collector.setNotes(value);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置点击监听器
     * @param collectorId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setOnClickListenner(String collectorId, String value, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            // TODO 设置点击监听器

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置用户数据
     * @param collectorId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setUserData(String collectorId, WritableMap value, Promise promise){
        try{
            CollectorElement collector = mCollectorElementList.get(collectorId);
            collector.setUserData(value);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

}
