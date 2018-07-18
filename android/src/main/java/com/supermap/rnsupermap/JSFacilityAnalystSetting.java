/**
 * Created by Yangshanglong on 2018/7/11.
 */
package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.data.DatasetVector;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSFacilityAnalystSetting extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSFacilityAnalystSetting";
    public static Map<String , FacilityAnalystSetting> m_FacilityAnalystSettingList = new HashMap<String , FacilityAnalystSetting>();
    FacilityAnalystSetting m_FacilityAnalystSetting;

    public JSFacilityAnalystSetting(ReactApplicationContext context){
        super(context);
    }

    public static FacilityAnalystSetting getObjFromList(String id) {
        return m_FacilityAnalystSettingList.get(id);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(FacilityAnalystSetting FacilityAnalystSetting){
        for(Map.Entry entry:m_FacilityAnalystSettingList.entrySet())
        {
            if(FacilityAnalystSetting.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_FacilityAnalystSettingList.put(id,FacilityAnalystSetting);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            FacilityAnalystSetting facilityAnalystSetting = new FacilityAnalystSetting();
            String facilityAnalystSettingId = registerId(facilityAnalystSetting);

            promise.resolve(facilityAnalystSettingId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍弧段的 ID 列表
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getBarrierEdges(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            int[] arr = facilityAnalystSetting.getBarrierEdges();

            WritableArray wArr = Arguments.fromArray(arr);

            promise.resolve(wArr);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍结点的 ID 列表
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getBarrierNodes(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            int[] arr = facilityAnalystSetting.getBarrierNodes();

            WritableArray wArr = Arguments.fromArray(arr);

            promise.resolve(wArr);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回流向字段
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getDirectionField(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            String directionField = facilityAnalystSetting.getDirectionField();

            promise.resolve(directionField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中标识弧段 ID 的字段
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getEdgeIDField(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            String edgeIDField = facilityAnalystSetting.getEdgeIDField();

            promise.resolve(edgeIDField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中标识弧段起始结点 ID 的字段
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getFNodeIDField(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            String fNodeIDField = facilityAnalystSetting.getFNodeIDField();

            promise.resolve(fNodeIDField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getNetworkDataset(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            DatasetVector datasetVector = facilityAnalystSetting.getNetworkDataset();
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            promise.resolve(datasetVectorId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中标识网络结点 ID 的字段
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getNodeIDField(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            String nodeIDField = facilityAnalystSetting.getNodeIDField();

            promise.resolve(nodeIDField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中标识弧段终止结点 ID 的字段
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTNodeIDField(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            String tNodeIDField = facilityAnalystSetting.getTNodeIDField();

            promise.resolve(tNodeIDField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回点到弧段的距离容限
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTolerance(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            Double tolerance = facilityAnalystSetting.getTolerance();

            promise.resolve(tolerance);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回权值字段信息集合对象
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getWeightFieldInfos(String facilityAnalystSettingId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            WeightFieldInfos weightFieldInfos = facilityAnalystSetting.getWeightFieldInfos();

            String weightFieldInfosId = JSWeightFieldInfos.registerId(weightFieldInfos);

            promise.resolve(weightFieldInfosId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍弧段的 ID 列表
     * @param facilityAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setBarrierEdges(String facilityAnalystSettingId, int[] value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setBarrierEdges(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍结点的 ID 列表
     * @param facilityAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setBarrierNodes(String facilityAnalystSettingId, int[] value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setBarrierNodes(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置流向字段
     * @param facilityAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setDirectionField(String facilityAnalystSettingId, String value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setDirectionField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标识弧段 ID 的字段
     * @param facilityAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setEdgeIDField(String facilityAnalystSettingId, String value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setEdgeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标识弧段起始结点 ID 的字段
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void setFNodeIDField(String facilityAnalystSettingId, String value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setFNodeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集
     * @param facilityAnalystSettingId
     * @param datasetVectorId
     * @param promise
     */
    @ReactMethod
    public void setNetworkDataset(String facilityAnalystSettingId, String datasetVectorId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            facilityAnalystSetting.setNetworkDataset(datasetVector);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标识网络结点 ID 的字段
     * @param facilityAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setNodeIDField(String facilityAnalystSettingId, String value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setNodeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标识弧段终止结点 ID 的字段
     * @param facilityAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTNodeIDField(String facilityAnalystSettingId, String value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setTNodeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置点到弧段的距离容限
     * @param facilityAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTolerance(String facilityAnalystSettingId, double value, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);
            facilityAnalystSetting.setTolerance(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置权值字段信息集合对象。
     * @param facilityAnalystSettingId
     * @param weightFieldInfosId
     * @param promise
     */
    @ReactMethod
    public void setWeightFieldInfos(String facilityAnalystSettingId, String weightFieldInfosId, Promise promise) {
        try{
            FacilityAnalystSetting facilityAnalystSetting = getObjFromList(facilityAnalystSettingId);

            WeightFieldInfos weightFieldInfos = JSWeightFieldInfos.getObjFromList(weightFieldInfosId);

            facilityAnalystSetting.setWeightFieldInfos(weightFieldInfos);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}

