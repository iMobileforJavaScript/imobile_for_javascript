package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.analyst.networkanalyst.LocationAnalystParameter;
import com.supermap.analyst.networkanalyst.SupplyCenters;
import com.supermap.data.Point2Ds;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSLocationAnalystParameter extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLocationAnalystParameter";
    protected static Map<String, LocationAnalystParameter> m_LocationAnalystParameterList = new HashMap<String, LocationAnalystParameter>();
    LocationAnalystParameter m_LocationAnalystParameter;

    public JSLocationAnalystParameter(ReactApplicationContext context) {
        super(context);
    }

    public static LocationAnalystParameter getObjFromList(String id) {
        return m_LocationAnalystParameterList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(LocationAnalystParameter obj) {
        for (Map.Entry entry : m_LocationAnalystParameterList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_LocationAnalystParameterList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = new LocationAnalystParameter();
            String locationAnalystParameterId = registerId(transportationAnalystParameter);

            promise.resolve(locationAnalystParameterId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回期望用于最终设施选址的资源供给中心数量
     * @param locationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getExpectedSupplyCenterCount(String locationAnalystParameterId, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            int count = transportationAnalystParameter.getExpectedSupplyCenterCount();

            promise.resolve(count);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回结点需求量字段
     * @param locationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getNodeDemandField(String locationAnalystParameterId, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            String value = transportationAnalystParameter.getNodeDemandField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍结点的坐标列表
     * @param locationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getSupplyCenters(String locationAnalystParameterId, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            SupplyCenters supplyCenters = transportationAnalystParameter.getSupplyCenters();
            String supplyCentersId = JSSupplyCenters.registerId(supplyCenters);

            promise.resolve(supplyCentersId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回转向权值字段，该字段是交通网络分析环境设置中指定的转向权值字段集合中的一员
     * @param locationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getTurnWeightField(String locationAnalystParameterId, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            String value = transportationAnalystParameter.getTurnWeightField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回权值字段信息的名称，即交通网络分析环境设置中指定的权值字段信息集合对象（WeightFieldInfos 类对象）中的某一个权值字段信息对象（WeightFieldInfo 类对象）的 setName() 方法值
     * @param locationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getWeightName(String locationAnalystParameterId, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            String value = transportationAnalystParameter.getWeightName();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回是否从资源供给中心开始分配资源
     * @param locationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void isFromCenter(String locationAnalystParameterId, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            boolean value = transportationAnalystParameter.isFromCenter();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置期望用于最终设施选址的资源供给中心数量
     * @param locationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setExpectedSupplyCenterCount(String locationAnalystParameterId, int value, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            transportationAnalystParameter.setExpectedSupplyCenterCount(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置是否从资源供给中心开始分配资源
     * @param locationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFromCenter(String locationAnalystParameterId, boolean value, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            transportationAnalystParameter.setFromCenter(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置结点需求量字段
     * @param locationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setNodeDemandField(String locationAnalystParameterId, String value, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            transportationAnalystParameter.setNodeDemandField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置资源供给中心集合
     * @param locationAnalystParameterId
     * @param supplyCentersId
     * @param promise
     */
    @ReactMethod
    public void setSupplyCenters(String locationAnalystParameterId, String supplyCentersId, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            SupplyCenters supplyCenters = JSSupplyCenters.getObjFromList(supplyCentersId);
            transportationAnalystParameter.setSupplyCenters(supplyCenters);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置转向权值字段，该字段是交通网络分析环境设置中指定的转向权值字段集合中的一员
     * @param locationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTurnWeightField(String locationAnalystParameterId, String value, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            transportationAnalystParameter.setTurnWeightField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置权值字段信息的名称，即交通网络分析环境设置中指定的权值字段信息集合对象（WeightFieldInfos 类对象）中的某一个权值字段信息对象（WeightFieldInfo 类对象）的 setName() 方法值
     * @param locationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setWeightName(String locationAnalystParameterId, String value, Promise promise){
        try{
            LocationAnalystParameter transportationAnalystParameter = getObjFromList(locationAnalystParameterId);
            transportationAnalystParameter.setWeightName(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

