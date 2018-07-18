package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.data.DatasetVector;
import com.supermap.data.Point2Ds;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSTransportationAnalystSetting extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTransportationAnalystSetting";
    public static Map<String, TransportationAnalystSetting> m_JSTransportationAnalystSettingList = new HashMap<String, TransportationAnalystSetting>();
    TransportationAnalystSetting m_TransportationAnalystSetting;

    public JSTransportationAnalystSetting(ReactApplicationContext context) {
        super(context);
    }

    public static TransportationAnalystSetting getObjFromList(String id) {
        return m_JSTransportationAnalystSettingList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(TransportationAnalystSetting obj) {
        for (Map.Entry entry : m_JSTransportationAnalystSettingList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_JSTransportationAnalystSettingList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            m_TransportationAnalystSetting = new TransportationAnalystSetting();
            String transportationAnalystSettingId = registerId(m_TransportationAnalystSetting);

            promise.resolve(transportationAnalystSettingId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍弧段 ID 列表
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getBarrierEdges(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            int[] arr = m_TransportationAnalystSetting.getBarrierEdges();

            WritableArray array = Arguments.fromArray(arr);

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回障碍结点 ID 列表
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getBarrierNodes(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            int[] arr = m_TransportationAnalystSetting.getBarrierNodes();

            WritableArray array = Arguments.fromArray(arr);

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回交通网络分析中弧段过滤表达式
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getEdgeFilter(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String edgeFilter = m_TransportationAnalystSetting.getEdgeFilter();

            promise.resolve(edgeFilter);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中标志弧段 ID 的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getEdgeIDField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String edgeIDField = m_TransportationAnalystSetting.getEdgeIDField();

            promise.resolve(edgeIDField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回存储弧段名称的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getEdgeNameField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String edgeNameField = m_TransportationAnalystSetting.getEdgeNameField();

            promise.resolve(edgeNameField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中标志弧段起始结点 ID 的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getFNodeIDField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String fNodeIDField = m_TransportationAnalystSetting.getFNodeIDField();

            promise.resolve(fNodeIDField);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回用于表示正向单行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getFTSingleWayRuleValues(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] value = m_TransportationAnalystSetting.getFTSingleWayRuleValues();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回用于分析的网络数据集
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getNetworkDataset(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            DatasetVector datasetVector = m_TransportationAnalystSetting.getNetworkDataset();
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            promise.resolve(datasetVectorId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中标识结点 ID 的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getNodeIDField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String value = m_TransportationAnalystSetting.getNodeIDField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回存储结点名称的字段的字段名
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getNodeNameField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String value = m_TransportationAnalystSetting.getNodeNameField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回用于表示禁行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getProhibitedWayRuleValues(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] value = m_TransportationAnalystSetting.getProhibitedWayRuleValues();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络数据集中表示网络弧段的交通规则的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getRuleField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String value = m_TransportationAnalystSetting.getRuleField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回用于表示逆向单行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTFSingleWayRuleValues(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] value = m_TransportationAnalystSetting.getTFSingleWayRuleValues();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍结点 ID 列表
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTNodeIDField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String value = m_TransportationAnalystSetting.getTNodeIDField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回转向表数据集
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTurnDataset(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            DatasetVector datasetVector = m_TransportationAnalystSetting.getTurnDataset();
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            promise.resolve(datasetVectorId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回转向起始弧段 ID 的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTurnFEdgeIDField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String value = m_TransportationAnalystSetting.getTurnFEdgeIDField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回转向结点 ID 的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTurnNodeIDField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String value = m_TransportationAnalystSetting.getTurnNodeIDField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回转向终止弧段 ID 的字段
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTurnTEdgeIDField(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String value = m_TransportationAnalystSetting.getTurnTEdgeIDField();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回转向权值字段集合
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTurnWeightFields(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] value = m_TransportationAnalystSetting.getTurnWeightFields();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回用于表示双向通行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getTwoWayRuleValues(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] value = m_TransportationAnalystSetting.getTwoWayRuleValues();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍结点 ID 列表
     * @param transportationAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void getWeightFieldInfos(String transportationAnalystSettingId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            WeightFieldInfos weightFieldInfos = m_TransportationAnalystSetting.getWeightFieldInfos();
            String weightFieldInfosId = JSWeightFieldInfos.registerId(weightFieldInfos);

            promise.resolve(weightFieldInfosId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍弧段的 ID 列表
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setBarrierEdges(String transportationAnalystSettingId, int[] value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setBarrierEdges(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置障碍结点的 ID 列表
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setBarrierNodes(String transportationAnalystSettingId, int[] value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setBarrierNodes(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置交通网络分析中弧段过滤表达式
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setEdgeFilter(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setEdgeFilter(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标志弧段 ID 的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setEdgeIDField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setEdgeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置存储弧段名称的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setEdgeNameField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setEdgeNameField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标志弧段起始结点 ID 的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFNodeIDField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setFNodeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置用于表示正向单行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFTSingleWayRuleValues(String transportationAnalystSettingId, ReadableArray value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);

            String[] list = new String[value.size()];
            for (int i = 0; i < value.size(); i++) {
                list[i] = value.getString(i);
            }

            m_TransportationAnalystSetting.setFTSingleWayRuleValues(list);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置用于分析的网络数据集
     * @param transportationAnalystSettingId
     * @param datasetVectorId
     * @param promise
     */
    @ReactMethod
    public void setNetworkDataset(String transportationAnalystSettingId, String datasetVectorId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            m_TransportationAnalystSetting.setNetworkDataset(datasetVector);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标识结点 ID 的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setNodeIDField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setNodeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置存储结点名称的字段的字段名
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setNodeNameField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setNodeNameField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置用于表示禁行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setProhibitedWayRuleValues(String transportationAnalystSettingId, ReadableArray value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] list = new String[value.size()];
            for (int i = 0; i < value.size(); i++) {
                list[i] = value.getString(i);
            }
            m_TransportationAnalystSetting.setProhibitedWayRuleValues(list);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中表示网络弧段的交通规则的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setRuleField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setRuleField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置用于表示逆向单行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTFSingleWayRuleValues(String transportationAnalystSettingId, ReadableArray value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] list = new String[value.size()];
            for (int i = 0; i < value.size(); i++) {
                list[i] = value.getString(i);
            }
            m_TransportationAnalystSetting.setTFSingleWayRuleValues(list);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络数据集中标志弧段终止结点 ID 的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTNodeIDField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setTNodeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置点到弧段的距离容限
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTolerance(String transportationAnalystSettingId, double value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setTolerance(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置转向表数据集
     * @param transportationAnalystSettingId
     * @param datasetVectorId
     * @param promise
     */
    @ReactMethod
    public void setTurnDataset(String transportationAnalystSettingId, String datasetVectorId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            m_TransportationAnalystSetting.setTurnDataset(datasetVector);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置转向起始弧段 ID 的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTurnFEdgeIDField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setTurnFEdgeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置转向结点 ID 的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTurnNodeIDField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setTurnNodeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置转向终止弧段 ID 的字段
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTurnTEdgeIDField(String transportationAnalystSettingId, String value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            m_TransportationAnalystSetting.setTurnTEdgeIDField(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置转向权值字段集合
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTurnWeightFields(String transportationAnalystSettingId, ReadableArray value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] list = new String[value.size()];
            for (int i = 0; i < value.size(); i++) {
                list[i] = value.getString(i);
            }
            m_TransportationAnalystSetting.setTurnWeightFields(list);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置用于表示双向通行线的字符串的数组
     * @param transportationAnalystSettingId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTwoWayRuleValues(String transportationAnalystSettingId, ReadableArray value, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            String[] list = new String[value.size()];
            for (int i = 0; i < value.size(); i++) {
                list[i] = value.getString(i);
            }
            m_TransportationAnalystSetting.setTwoWayRuleValues(list);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置权值字段信息集合对象
     * @param transportationAnalystSettingId
     * @param weightFieldInfosId
     * @param promise
     */
    @ReactMethod
    public void setWeightFieldInfos(String transportationAnalystSettingId, String weightFieldInfosId, Promise promise){
        try{
            m_TransportationAnalystSetting = getObjFromList(transportationAnalystSettingId);
            WeightFieldInfos weightFieldInfos = JSWeightFieldInfos.getObjFromList(weightFieldInfosId);
            m_TransportationAnalystSetting.setWeightFieldInfos(weightFieldInfos);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}

