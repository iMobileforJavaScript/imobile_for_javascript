package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.data.Point2Ds;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSTransportationAnalystParameter extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTransportationAnalystParameter";
    protected static Map<String, TransportationAnalystParameter> m_TransportationAnalystParameterList = new HashMap<String, TransportationAnalystParameter>();
    TransportationAnalystParameter m_TransportationAnalystParameter;

    public JSTransportationAnalystParameter(ReactApplicationContext context) {
        super(context);
    }

    public static TransportationAnalystParameter getObjFromList(String id) {
        return m_TransportationAnalystParameterList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(TransportationAnalystParameter obj) {
        for (Map.Entry entry : m_TransportationAnalystParameterList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_TransportationAnalystParameterList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            m_TransportationAnalystParameter = new TransportationAnalystParameter();
            String transportationAnalystParameterId = registerId(m_TransportationAnalystParameter);

            promise.resolve(transportationAnalystParameterId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍弧段 ID 列表
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getBarrierEdges(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            int[] arr = m_TransportationAnalystParameter.getBarrierEdges();

            WritableArray array = Arguments.fromArray(arr);

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍结点 ID 列表
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getBarrierNodes(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            int[] arr = m_TransportationAnalystParameter.getBarrierNodes();

            WritableArray array = Arguments.fromArray(arr);

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍结点的坐标列表
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getBarrierPoints(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            Point2Ds point2Ds = m_TransportationAnalystParameter.getBarrierPoints();

            WritableArray point2DsJson = JsonUtil.point2DsToJson(point2Ds);

            WritableArray array = Arguments.fromArray(point2DsJson);

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分析时途经结点 ID 的集合
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getNodes(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            int[] arr = m_TransportationAnalystParameter.getNodes();

            WritableArray array = Arguments.fromArray(arr);

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分析时途经点的集合
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getPoints(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            Point2Ds point2Ds = m_TransportationAnalystParameter.getPoints();

            WritableArray point2DsJson = JsonUtil.point2DsToJson(point2Ds);

            WritableArray array = Arguments.fromArray(point2DsJson);

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回转向权值字段
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getTurnWeightField(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            String value = m_TransportationAnalystParameter.getTurnWeightField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回权值字段信息的名称
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void getWeightName(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            String value = m_TransportationAnalystParameter.getWeightName();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分析结果中是否包含途经弧段集合
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void isEdgesReturn(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            boolean value = m_TransportationAnalystParameter.isEdgesReturn();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分析结果中是否包含途经结点的集合
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void isNodesReturn(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            boolean value = m_TransportationAnalystParameter.isNodesReturn();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分析结果中是否包含行驶导引集合
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void isPathGuidesReturn(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            boolean value = m_TransportationAnalystParameter.isPathGuidesReturn();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分析结果中是否包含路由（GeoLineM）对象的集合
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void isRoutesReturn(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            boolean value = m_TransportationAnalystParameter.isRoutesReturn();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分析结果中是否要包含站点索引的集合
     * @param transportationAnalystParameterId
     * @param promise
     */
    @ReactMethod
    public void isStopIndexesReturn(String transportationAnalystParameterId, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            boolean value = m_TransportationAnalystParameter.isStopIndexesReturn();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍弧段 ID 列表
     * @param transportationAnalystParameterId
     * @param arr
     * @param promise
     */
    @ReactMethod
    public void setBarrierEdges(String transportationAnalystParameterId, int[] arr, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setBarrierEdges(arr);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍结点 ID 列表
     * @param transportationAnalystParameterId
     * @param arr
     * @param promise
     */
    @ReactMethod
    public void setBarrierNodes(String transportationAnalystParameterId, int[] arr, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setBarrierNodes(arr);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍结点的坐标列表
     * @param transportationAnalystParameterId
     * @param points2DsJson
     * @param promise
     */
    @ReactMethod
    public void setBarrierPoints(String transportationAnalystParameterId, WritableArray points2DsJson, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            Point2Ds point2Ds = JsonUtil.jsonToPoint2Ds(points2DsJson);
            m_TransportationAnalystParameter.setBarrierPoints(point2Ds);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分析结果中是否包含途经弧段的集合
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setEdgesReturn(String transportationAnalystParameterId, boolean value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setEdgesReturn(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分析时途经结点 ID 的集合
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setNodes(String transportationAnalystParameterId, int[] value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setNodes(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分析结果中是否包含结点的集合
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setNodesReturn(String transportationAnalystParameterId, boolean value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setNodesReturn(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分析结果中是否包含行驶导引集合
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setPathGuidesReturn(String transportationAnalystParameterId, boolean value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setPathGuidesReturn(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分析结果中是否包含路由（GeoLineM）对象的集合。
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setRoutesReturn(String transportationAnalystParameterId, boolean value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setRoutesReturn(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分析结果中是否要包含站点索引的集合
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setStopIndexesReturn(String transportationAnalystParameterId, boolean value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setStopIndexesReturn(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分析时途经点的集合
     * @param transportationAnalystParameterId
     * @param points2DsJson
     * @param promise
     */
    @ReactMethod
    public void setPoints(String transportationAnalystParameterId, ReadableArray points2DsJson, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            Point2Ds point2Ds = JsonUtil.jsonToPoint2Ds(points2DsJson);
            int count = point2Ds.getCount();
            m_TransportationAnalystParameter.setPoints(point2Ds);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置转向权值字段
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTurnWeightField(String transportationAnalystParameterId, String value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setTurnWeightField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置权值字段信息的名称，即交通网络分析环境设置（TransportationAnalystSetting）中的权值字段信息集合（WeightFieldInfos）
     * 中的某一个权值字段信息对象（WeightFieldInfo）的 getName() 方法的返回值
     * @param transportationAnalystParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setWeightName(String transportationAnalystParameterId, String value, Promise promise){
        try{
            m_TransportationAnalystParameter = getObjFromList(transportationAnalystParameterId);
            m_TransportationAnalystParameter.setWeightName(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}

