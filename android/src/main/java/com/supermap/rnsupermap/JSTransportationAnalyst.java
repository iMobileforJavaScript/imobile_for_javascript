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
import com.supermap.RNUtils.JsonUtil;
import com.supermap.analyst.networkanalyst.DemandResult;
import com.supermap.analyst.networkanalyst.LocationAnalystParameter;
import com.supermap.analyst.networkanalyst.LocationAnalystResult;
import com.supermap.analyst.networkanalyst.PathGuide;
import com.supermap.analyst.networkanalyst.SupplyCenterType;
import com.supermap.analyst.networkanalyst.SupplyResult;
import com.supermap.analyst.networkanalyst.TransportationAnalyst;
import com.supermap.analyst.networkanalyst.FacilityAnalystResult;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.analyst.networkanalyst.TransportationAnalystResult;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.data.DatasetVector;
import com.supermap.data.GeoLineM;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSTransportationAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTransportationAnalyst";
    public static Map<String , TransportationAnalyst> m_TransportationAnalystList = new HashMap<String , TransportationAnalyst>();
    TransportationAnalyst m_TransportationAnalyst;

    public JSTransportationAnalyst(ReactApplicationContext context){
        super(context);
    }

    public static TransportationAnalyst getObjFromList(String id) {
        return m_TransportationAnalystList.get(id);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(TransportationAnalyst m_TransportationAnalyst){
        for(Map.Entry entry:m_TransportationAnalystList.entrySet())
        {
            if(m_TransportationAnalyst.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_TransportationAnalystList.put(id,m_TransportationAnalyst);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            TransportationAnalyst m_TransportationAnalyst = new TransportationAnalyst();
            String facilityAnalystId = registerId(m_TransportationAnalyst);

            promise.resolve(facilityAnalystId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String transportationAnalystId, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            m_TransportationAnalyst.dispose();

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 创建内存文件
     * @param transportationAnalystId
     * @param path
     * @param promise
     */
    @ReactMethod
    public void createModel(String transportationAnalystId, String path, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            boolean result = m_TransportationAnalyst.createModel(path);

            promise.resolve(result);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据指定的参数进行最近设施查找分析，事件点为结点 ID
     * @param transportationAnalystId
     * @param parameterId
     * @param eventID
     * @param facilityCount
     * @param isFromEvent
     * @param maxWeight
     * @param promise
     */
    @ReactMethod
    public void findClosestFacilityByNode(String transportationAnalystId, String parameterId, int eventID,
                                    int facilityCount, boolean isFromEvent, double maxWeight, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            TransportationAnalystParameter parameter = JSTransportationAnalystParameter.getObjFromList(parameterId);

            TransportationAnalystResult result = m_TransportationAnalyst.findClosestFacility(parameter, eventID, facilityCount, isFromEvent, maxWeight);

            WritableMap map = transportationResultToMap(result);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据指定的参数进行最近设施查找分析，事件点为坐标点
     * @param transportationAnalystId
     * @param parameterId
     * @param point2DId
     * @param facilityCount
     * @param isFromEvent
     * @param maxWeight
     * @param promise
     */
    @ReactMethod
    public void findClosestFacilityByPoint2D(String transportationAnalystId, String parameterId, String point2DId,
                                    int facilityCount, boolean isFromEvent, double maxWeight, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            TransportationAnalystParameter parameter = JSTransportationAnalystParameter.getObjFromList(parameterId);

            Point2D point2D = JSPoint2D.getObjFromList(point2DId);

            TransportationAnalystResult result = m_TransportationAnalyst.findClosestFacility(parameter, point2D, facilityCount, isFromEvent, maxWeight);

            WritableMap map = transportationResultToMap(result);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的参数进行选址分区分析
     * @param transportationAnalystId
     * @param parameterId  LocationAnalystParameter
     * @param promise
     */
    @ReactMethod
    public void findLocation(String transportationAnalystId, String parameterId, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            LocationAnalystParameter parameter = JSLocationAnalystParameter.getObjFromList(parameterId);

            LocationAnalystResult result = m_TransportationAnalyst.findLocation(parameter);

            WritableMap map = locationResultToMap(result);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 多旅行商（物流配送）分析，配送中心为结点 ID 数组
     * @param transportationAnalystId
     * @param parameterId
     * @param centerNodes
     * @param hasLeastTotalCost
     * @param promise
     */
    @ReactMethod
    public void findMTSPPathByNodes(String transportationAnalystId, String parameterId, int[] centerNodes,
                             boolean hasLeastTotalCost, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            TransportationAnalystParameter parameter = JSTransportationAnalystParameter.getObjFromList(parameterId);
            TransportationAnalystResult result = m_TransportationAnalyst.findMTSPPath(parameter, centerNodes, hasLeastTotalCost);

            WritableMap map = transportationResultToMap(result);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 多旅行商（物流配送）分析，配送中心为点坐标串
     * @param transportationAnalystId
     * @param parameterId
     * @param centerPoints
     * @param hasLeastTotalCost
     * @param promise
     */
    @ReactMethod
    public void findMTSPPathByPoint2Ds(String transportationAnalystId, String parameterId, WritableArray centerPoints,
                             boolean hasLeastTotalCost, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            TransportationAnalystParameter parameter = JSTransportationAnalystParameter.getObjFromList(parameterId);

            Point2Ds point2DS = JsonUtil.jsonToPoint2Ds(centerPoints);

            TransportationAnalystResult result = m_TransportationAnalyst.findMTSPPath(parameter, point2DS, hasLeastTotalCost);

            WritableMap map = transportationResultToMap(result);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 最佳路径分析
     * @param transportationAnalystId
     * @param parameterId
     * @param hasLeastTotalCost
     * @param promise
     */
    @ReactMethod
    public void findPath(String transportationAnalystId, String parameterId, boolean hasLeastTotalCost, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            TransportationAnalystParameter parameter = JSTransportationAnalystParameter.getObjFromList(parameterId);

            TransportationAnalystResult result = m_TransportationAnalyst.findPath(parameter, hasLeastTotalCost);

            WritableMap map = transportationResultToMap(result);

            promise.resolve(map);

        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 服务区分析
     * @param transportationAnalystId
     * @param parameterId
     * @param weights
     * @param isFromCenter
     * @param isCenterMutuallyExclusive
     * @param promise
     */
    @ReactMethod
    public void findServiceArea(String transportationAnalystId, String parameterId, double[] weights, boolean isFromCenter,
                                boolean isCenterMutuallyExclusive, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            TransportationAnalystParameter parameter = JSTransportationAnalystParameter.getObjFromList(parameterId);

            TransportationAnalystResult result = m_TransportationAnalyst.findServiceArea(parameter, weights, isFromCenter, isCenterMutuallyExclusive);

            WritableMap map = transportationResultToMap(result);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 返回交通网络分析环境设置对象
     * @param transportationAnalystId
     * @param promise
     */
    @ReactMethod
    public void getAnalystSetting(String transportationAnalystId, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);

            TransportationAnalystSetting setting = m_TransportationAnalyst.getAnalystSetting();
            String settingId = JSTransportationAnalystSetting.registerId(setting);

            promise.resolve(settingId);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 加载网络模型
     * @param transportationAnalystId
     * @param promise
     */
    @ReactMethod
    public void load(String transportationAnalystId, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);

            boolean result = m_TransportationAnalyst.load();

            promise.resolve(result);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 加载内存文件
     * @param transportationAnalystId
     * @param filePath
     * @param networkDatasetId
     * @param promise
     */
    @ReactMethod
    public void loadModel(String transportationAnalystId, String filePath, String networkDatasetId, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            DatasetVector networkDataset = JSDatasetVector.getObjFromList(networkDatasetId);

            boolean result = m_TransportationAnalyst.loadModel(filePath, networkDataset);

            promise.resolve(result);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置交通网络分析环境设置对象
     * @param transportationAnalystId
     * @param settingId
     * @param promise
     */
    @ReactMethod
    public void setAnalystSetting(String transportationAnalystId, String settingId, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            TransportationAnalystSetting setting = JSTransportationAnalystSetting.getObjFromList(settingId);

            m_TransportationAnalyst.setAnalystSetting(setting);

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 该方法用来更新弧段的权值
     * @param transportationAnalystId
     * @param edgeID
     * @param fromNodeID
     * @param toNodeID
     * @param weightName
     * @param weight
     * @param promise
     */
    @ReactMethod
    public void updateEdgeWeight(String transportationAnalystId, int edgeID, int fromNodeID, int toNodeID, java.lang.String weightName, double weight, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            m_TransportationAnalyst.updateEdgeWeight(edgeID, fromNodeID, toNodeID, weightName, weight);

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 该方法用来更新转向结点的权值
     * @param transportationAnalystId
     * @param nodeID
     * @param fromEdgeID
     * @param toEdgeID
     * @param weightName
     * @param weight
     * @param promise
     */
    @ReactMethod
    public void updateTurnNodeWeight(String transportationAnalystId, int nodeID, int fromEdgeID, int toEdgeID, java.lang.String weightName, double weight, Promise promise) {
        try {
            m_TransportationAnalyst = getObjFromList(transportationAnalystId);
            m_TransportationAnalyst.updateTurnNodeWeight(nodeID, fromEdgeID, toEdgeID, weightName, weight);

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    private WritableMap transportationResultToMap(TransportationAnalystResult result) {
        int[][] edges = result.getEdges();
        int[][] nodes = result.getNodes();
        int[][] stopIndexes = result.getStopIndexes();
        double[][] stopWeights = result.getStopWeights();
        double[] weights = result.getWeights();
        // TODO pathGuides
        PathGuide[] pathGuides = result.getPathGuides();
        GeoLineM[] routes = result.getRoutes();

        // TODO JSPathGuide待做
//        String[] pathGuideIds = new String[pathGuides.length];
//        for (int i = 0; i < pathGuides.length; i++) {
//            PathGuide pathGuide = pathGuides[i];
//            String pathGuideId = JSPathGuide.registerId(pathGuide);
//            pathGuideIds[i] = pathGuideId;
//        }

        String[] routeIds = new String[routes.length];
        for (int i = 0; i < routes.length; i++) {
            GeoLineM geoLineM = routes[i];
            String geoLineMId = JSGeoLineM.registerId(geoLineM);
            routeIds[i] = geoLineMId;
        }

//        WritableArray pathGuideIdArr = Arguments.fromArray(pathGuideIds);
        WritableArray routeIdArr = Arguments.fromArray(routeIds);
        WritableArray edgesArr = arrayToWritableArray(edges);
        WritableArray nodesArr = arrayToWritableArray(nodes);
        WritableArray stopIndexesArr = arrayToWritableArray(stopIndexes);
        WritableArray stopWeightsArr = arrayToWritableArray(stopWeights);
        WritableArray weightsArr = Arguments.fromArray(weights);

        WritableMap map = Arguments.createMap();
//        map.putArray("pathGuideIds", pathGuideIdArr);
        map.putArray("routeIds", routeIdArr);
        map.putArray("edges", edgesArr);
        map.putArray("nodesArr", nodesArr);
        map.putArray("stopIndexesArr", stopIndexesArr);
        map.putArray("stopWeightsArr", stopWeightsArr);
        map.putArray("weightsArr", weightsArr);

        return map;
    }

    private WritableArray arrayToWritableArray (Object[] arr) {
        WritableArray writableArray = Arguments.createArray();
        for (int i = 0; i < arr.length; i++) {
            WritableArray subArr = Arguments.fromArray(arr[i]);
            writableArray.pushArray(subArr);
        }

        return writableArray;
    }

    private WritableMap locationResultToMap(LocationAnalystResult result) {
        DemandResult[] demandResults = result.getDemandResults();
        SupplyResult[] supplyResults = result.getSupplyResults();

        WritableArray demandArr = Arguments.createArray();
        for (int i = 0; i < demandResults.length; i++) {
            WritableMap map = Arguments.createMap();
            map.putDouble("actualResourceValue", demandResults[i].getActualResourceValue()); // 实际被分配的资源量
            map.putInt("id", demandResults[i].getID()); // 返回需求结点或需求弧段的 ID
            map.putInt("supplyCenterID", demandResults[i].getSupplyCenterID()); // 返回资源供给中心 ID
            map.putBoolean("isEdge", demandResults[i].isEdge()); // 实际被分配的资源量

            demandArr.pushMap(map);
        }

        WritableArray supplyArr = Arguments.createArray();
        for (int i = 0; i < supplyResults.length; i++) {
            WritableMap map = Arguments.createMap();
            map.putDouble("actualResourceValue", supplyResults[i].getActualResourceValue()); // 实际被分配的资源量
            map.putDouble("averageWeight", supplyResults[i].getAverageWeight()); // 返回平均耗费，即总耗费除以需求点数
            map.putInt("demandCount", supplyResults[i].getDemandCount()); // 返回该资源供给中心所服务的需求结点的数量
            map.putInt("id", supplyResults[i].getID()); // 返回该资源供给中心的 ID
            map.putDouble("maxWeight", supplyResults[i].getMaxWeight()); // 返回资源供给中心的最大耗费（阻值）
            map.putDouble("resourceValue", supplyResults[i].getResourceValue()); // 返回资源供给中心的最大耗费（阻值）
            map.putDouble("totalWeights", supplyResults[i].getTotalWeights()); // 返回资源供给中心的最大耗费（阻值）
            map.putInt("isEdge", supplyResults[i].getType().value()); // 实际被分配的资源量

            supplyArr.pushMap(map);
        }

        WritableMap map = Arguments.createMap();
        map.putArray("demandResults", demandArr);
        map.putArray("supplyResults", supplyArr);

        return map;
    }
}

