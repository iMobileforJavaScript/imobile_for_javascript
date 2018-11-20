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
import com.supermap.analyst.networkanalyst.FacilityAnalyst;
import com.supermap.analyst.networkanalyst.FacilityAnalystResult;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.data.DatasetVector;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSFacilityAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSFacilityAnalyst";
    public static Map<String , FacilityAnalyst> m_FacilityAnalystList = new HashMap<String , FacilityAnalyst>();
    FacilityAnalyst m_FacilityAnalyst;

    public JSFacilityAnalyst(ReactApplicationContext context){
        super(context);
    }

    public static FacilityAnalyst getObjFromList(String id) {
        return m_FacilityAnalystList.get(id);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(FacilityAnalyst m_FacilityAnalyst){
        for(Map.Entry entry:m_FacilityAnalystList.entrySet())
        {
            if(m_FacilityAnalyst.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_FacilityAnalystList.put(id,m_FacilityAnalyst);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            FacilityAnalyst m_FacilityAnalyst = new FacilityAnalyst();
            String facilityAnalystId = registerId(m_FacilityAnalyst);

            promise.resolve(facilityAnalystId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 检查网络环路，返回构成环路的弧段 ID 数组
     * @param ficilityAnalystId
     * @param promise
     */
    @ReactMethod
    public void checkLoops(String ficilityAnalystId, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.checkLoops();

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String ficilityAnalystId, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            m_FacilityAnalyst.dispose();
            m_FacilityAnalystList.remove(ficilityAnalystId);

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找这些弧段的共同上游弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param edgeIDs
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonAncestorsFromEdges(String ficilityAnalystId, int[] edgeIDs, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findCommonAncestorsFromEdges(edgeIDs, isUncertainDirectionValid);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组，查找这些结点的共同上游弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param nodeIDs
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonAncestorsFromNodes(String ficilityAnalystId, int[] nodeIDs, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findCommonAncestorsFromNodes(nodeIDs, isUncertainDirectionValid);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找这些弧段的共同下游弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param edgeIDs
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonCatchmentsFromEdges(String ficilityAnalystId, int[] edgeIDs, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findCommonCatchmentsFromEdges(edgeIDs, isUncertainDirectionValid);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据指定的结点 ID 数组，查找这些结点的共同下游弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param nodeIDs
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonCatchmentsFromNodes(String ficilityAnalystId, int[] nodeIDs, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findCommonCatchmentsFromNodes(nodeIDs, isUncertainDirectionValid);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找与这些弧段相连通的弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param edgeIDs
     * @param promise
     */
    @ReactMethod
    public void findConnectedEdgesFromEdges(String ficilityAnalystId, int[] edgeIDs, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findConnectedEdgesFromEdges(edgeIDs);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组，查找与这些结点相连通弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param nodeIDs
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findConnectedEdgesFromNodes(String ficilityAnalystId, int[] nodeIDs, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findConnectedEdgesFromNodes(nodeIDs);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组查找与这些弧段相连接的环路，返回构成环路的弧段 ID 数组
     * @param ficilityAnalystId
     * @param edgeIDs
     * @param promise
     */
    @ReactMethod
    public void findLoopsFromEdges(String ficilityAnalystId, int[] edgeIDs, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findLoopsFromEdges(edgeIDs);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组查找与这些结点相连接的环路，返回构成环路的弧段 ID 数组
     * @param ficilityAnalystId
     * @param nodeIDs
     * @param promise
     */
    @ReactMethod
    public void findLoopsFromNodes(String ficilityAnalystId, int[] nodeIDs, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] ids = m_FacilityAnalyst.findLoopsFromNodes(nodeIDs);

            WritableArray arr = Arguments.fromArray(ids);

            promise.resolve(arr);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设施网络下游路径分析，根据给定的参与分析的弧段 ID，查询该弧段下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathDownFromEdge(String ficilityAnalystId, int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findPathDownFromEdge(edgeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设施网络下游路径分析，根据给定的参与分析的结点 ID，查询该结点下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathDownFromNode(String ficilityAnalystId, int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findPathDownFromNode(nodeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设施网络路径分析，即根据给定的起始和终止弧段 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param startEdgeID
     * @param endEdgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathFromEdges(String ficilityAnalystId, int startEdgeID, int endEdgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findPathFromEdges(startEdgeID, endEdgeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设施网络路径分析，即根据给定的起始和终止结点 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费。
     * @param ficilityAnalystId
     * @param startNodeID
     * @param endNodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathFromNodes(String ficilityAnalystId, int startNodeID, int endNodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findPathFromNodes(startNodeID, endNodeID, weightName, isUncertainDirectionValid);

            if (result != null) {
                Double coast = result.getCost();
                int[] edges = result.getEdges();
                int[] nodes = result.getNodes();

                WritableMap map = Arguments.createMap();
                WritableArray edgesArr = Arguments.fromArray(edges);
                WritableArray nodesArr = Arguments.fromArray(nodes);

                map.putDouble("coast", coast);
                map.putArray("edges", edgesArr);
                map.putArray("nodes", nodesArr);

                promise.resolve(map);
            } else {
                WritableMap map = Arguments.createMap();

                map.putString("message", "FacilityAnalystResult is null");

                promise.resolve(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设施网络上游路径分析，根据给定的弧段 ID，查询该弧段上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathUpFromEdge(String ficilityAnalystId, int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findPathUpFromEdge(edgeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设施网络上游路径分析，根据给定的结点 ID，查询该结点上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathUpFromNode(String ficilityAnalystId, int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findPathUpFromNode(nodeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 查找汇，即从给定弧段出发，根据流向查找流出该弧段的下游汇点，并返回给定弧段到达该汇的最小耗费路径所包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSinkFromEdge(String ficilityAnalystId, int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findSinkFromEdge(edgeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 查找汇，即从给定结点出发，根据流向查找流出该结点的下游汇点，并返回给定结点到达该汇的最小耗费路径所包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSinkFromNode(String ficilityAnalystId, int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findSinkFromNode(nodeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 查找源，即从给定弧段出发，根据流向查找流向该弧段的网络源头，并返回该源到达给定弧段的最小耗费路径所包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSourceFromEdge(String ficilityAnalystId, int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findSourceFromEdge(edgeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 查找源，即从给定结点出发，根据流向查找流向该结点的网络源头，并返回该源到达给定结点的最小耗费路径所包含的弧段、结点及耗费
     * @param ficilityAnalystId
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSourceFromNode(String ficilityAnalystId, int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.findSourceFromNode(nodeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找与这些弧段不相连通的弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param edgeIDs
     * @param promise
     */
    @ReactMethod
    public void findUnconnectedEdgesFromEdges(String ficilityAnalystId, int[] edgeIDs, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] result = m_FacilityAnalyst.findUnconnectedEdgesFromEdges(edgeIDs);

            WritableArray unconnectedEdges = Arguments.fromArray(result);

            promise.resolve(unconnectedEdges);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组，查找与这些结点不相连通的弧段，返回弧段 ID 数组
     * @param ficilityAnalystId
     * @param nodeIDs
     * @param promise
     */
    @ReactMethod
    public void findUnconnectedEdgesFromNodes(String ficilityAnalystId, int[] nodeIDs, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            int[] result = m_FacilityAnalyst.findUnconnectedEdgesFromEdges(nodeIDs);

            WritableArray unconnectedEdges = Arguments.fromArray(result);

            promise.resolve(unconnectedEdges);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 进行下游追踪，即查找给定弧段的下游，返回下游包含的弧段、结点及总耗费
     * @param ficilityAnalystId
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void traceDownFromEdge(String ficilityAnalystId, int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.traceDownFromEdge(edgeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 进行下游追踪，即查找给定结点的下游，返回下游包含的弧段、结点及总耗费
     * @param ficilityAnalystId
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void traceDownFromNode(String ficilityAnalystId, int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.traceDownFromNode(nodeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 进行上游追踪，即查找给定弧段的上游，返回上游包含的弧段、结点及总耗费
     * @param ficilityAnalystId
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void traceUpFromEdge(String ficilityAnalystId, int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystResult result = m_FacilityAnalyst.traceUpFromEdge(edgeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 进行上游追踪，即查找给定结点的上游，返回上游包含的弧段、结点及总耗费
     * @param ficilityAnalystId
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void traceUpFromNode(String ficilityAnalystId, int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);

            FacilityAnalystResult result = m_FacilityAnalyst.traceUpFromNode(nodeID, weightName, isUncertainDirectionValid);

            Double coast = result.getCost();
            int[] edges = result.getEdges();
            int[] nodes = result.getNodes();

            WritableMap map = Arguments.createMap();
            WritableArray edgesArr = Arguments.fromArray(edges);
            WritableArray nodesArr = Arguments.fromArray(nodes);

            map.putDouble("coast", coast);
            map.putArray("edges", edgesArr);
            map.putArray("nodes", nodesArr);

            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置设施网络分析的环境
     * @param ficilityAnalystId
     * @param facilityAnalystSettingId
     * @param promise
     */
    @ReactMethod
    public void setAnalystSetting(String ficilityAnalystId, String facilityAnalystSettingId, Promise promise) {
        try {
            FacilityAnalystSetting setting = JSFacilityAnalystSetting.getObjFromList(facilityAnalystSettingId);

            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            m_FacilityAnalyst.setAnalystSetting(setting);

            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 返回设施网络分析的环境
     * @param ficilityAnalystId
     * @param promise
     */
    @ReactMethod
    public void getAnalystSetting(String ficilityAnalystId, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            FacilityAnalystSetting setting = m_FacilityAnalyst.getAnalystSetting();
            String settingId = JSFacilityAnalystSetting.registerId(setting);

            promise.resolve(settingId);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 根据设施网络分析环境设置加载设施网络模型
     * @param ficilityAnalystId
     * @param promise
     */
    @ReactMethod
    public void load(String ficilityAnalystId, Promise promise) {
        try {
            m_FacilityAnalyst = getObjFromList(ficilityAnalystId);
            boolean result = m_FacilityAnalyst.load();

            promise.resolve(result);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }
}

