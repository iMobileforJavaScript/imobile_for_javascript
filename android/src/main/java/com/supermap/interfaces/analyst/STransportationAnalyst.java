package com.supermap.interfaces.analyst;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.DataUtil;
import com.supermap.analyst.networkanalyst.TransportationAnalyst;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.analyst.networkanalyst.TransportationAnalystResult;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.data.Color;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.GeoLineM;
import com.supermap.data.GeoStyle;
import com.supermap.data.Point2D;
import com.supermap.data.Size2D;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Action;
import com.supermap.mapping.Layers;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.TrackingLayer;
import com.supermap.smNative.Network_tool;
import com.supermap.smNative.SMAnalyst;
import com.supermap.smNative.SMDatasource;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMParameter;

import org.apache.http.cookie.SM;

import java.util.ArrayList;
import java.util.Map;

public class STransportationAnalyst extends SNetworkAnalyst {
    public static final String REACT_CLASS = "STransportationAnalyst";
    private static STransportationAnalyst analyst;
    private static ReactApplicationContext context;
    private TransportationAnalyst transportationAnalyst = null;
    private ArrayList<Integer> nodes = null;
    private ArrayList<Integer> barrierNodes = null;

    private GeoStyle getGeoStyle(Size2D size2D, Color color) {
        GeoStyle geoStyle = new GeoStyle();
        geoStyle.setMarkerSize(size2D);
        geoStyle.setLineColor(color);
        return geoStyle;
    }

    ReactContext mReactContext;

    public STransportationAnalyst(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    private TransportationAnalyst getTransportationAnalyst() {
        if (transportationAnalyst == null) {
            transportationAnalyst = new TransportationAnalyst();
        }
        return transportationAnalyst;
    }

    /**
     * 设置起点
     * @param point
     * @param promise
     */
    @ReactMethod
    public void setStartPoint(ReadableMap point, Promise promise) {
        try {
            String nodeTag = "startNode";
            if (startNodeID > 0) {
                this.removeTagFromTrackingLayer(nodeTag);
                startNodeID = -1;
            }
            if (nodeLayer != null) {
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
                style.setMarkerSymbolID(3614);

                startNodeID = this.selectPoint(point, nodeLayer, style, nodeTag);
            }
            promise.resolve(startNodeID);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置终点
     * @param point
     * @param promise
     */
    @ReactMethod
    public void setEndPoint(ReadableMap point, Promise promise) {
        try {
            String nodeTag = "endNode";
            if (endNodeID > 0) {
                this.removeTagFromTrackingLayer(nodeTag);
                endNodeID = -1;
            }
            if (nodeLayer != null) {
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(105, 255, 0));
                style.setMarkerSymbolID(3614);

                endNodeID = this.selectPoint(point, nodeLayer, style, nodeTag);
            }
            promise.resolve(endNodeID);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加障碍点
     * @param point
     * @param promise
     */
    @ReactMethod
    public void addBarrierNode(ReadableMap point, Promise promise) {
        try {
            String nodeTag = "";
            int node = -1;
            if (nodeLayer != null) {
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 0, 0));
                style.setMarkerSymbolID(3614);

                node = this.selectPoint(point, nodeLayer, style, nodeTag);
                if (barrierNodes == null) {
                    barrierNodes = new ArrayList<>();
                }
                if (node > 0) {
                    barrierNodes.add(node);
                }
            }
            promise.resolve(node);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加结点
     * @param point
     * @param promise
     */
    @ReactMethod
    public void addNode(ReadableMap point, Promise promise) {
        try {
            String nodeTag = "";
            int node = -1;
            if (nodeLayer != null) {
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 255, 0));
                style.setMarkerSymbolID(3614);

                node = this.selectPoint(point, nodeLayer, style, nodeTag);
                if (nodes == null) {
                    nodes = new ArrayList<>();
                }
                if (node > 0) {
                    nodes.add(node);
                }
            }
            promise.resolve(node);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除记录
     * @param promise
     */
    @ReactMethod
    public void clear(Promise promise) {
        try {
            clear();
            startNodeID = -1;
            endNodeID = -1;
            startPoint = null;
            endPoint = null;
            if (nodes != null) nodes.clear();
            if (barrierNodes != null) barrierNodes.clear();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 加载交通网络分析环境设置对象
     */
    @ReactMethod
    public void load(ReadableMap datasourceInfo, ReadableMap settingMap, Promise promise) {
        try {
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            Layers layers = SMap.getInstance().getSmMapWC().getMapControl().getMap().getLayers();
            TransportationAnalystSetting setting = null;
            Dataset dataset = null;
            if (datasourceInfo.hasKey("server")) {
                DatasourceConnectionInfo connectionInfo = SMDatasource.convertDicToInfo(datasourceInfo.toHashMap());
                Datasources dss = workspace.getDatasources();
                Datasource datasource = dss.get(datasourceInfo.getString("alias"));
                if (datasource == null) {
                    datasource = dss.open(connectionInfo);
                }

                String datasetName = settingMap.getString("networkDataset");
                if (datasetName != null && !datasetName.equals("")) {
                    dataset = datasource.getDatasets().get(datasetName);
                    layer = SMLayer.findLayerByDatasetName(dataset.getName());
                    if (layer == null) {
                        layer = layers.add(dataset, true);
                        layer.setSelectable(false);
                    }

                    Dataset nodeDataset = ((DatasetVector)dataset).getChildDataset();
                    if (nodeDataset != null) {
                        nodeLayer = SMLayer.findLayerByDatasetName(nodeDataset.getName());
                        if (nodeLayer == null) {
                            nodeLayer = layers.add(nodeDataset, true);
                            nodeLayer.setSelectable(true);
                            nodeLayer.setVisible(true);
                        }
                    }
                }
            } else {
                if (settingMap.hasKey("networkDataset")) {
                    layer = SMLayer.findLayerByDatasetName(settingMap.getString("networkDataset"));
                }
            }

            if (layer != null) {
                dataset = layer.getDataset();
                if (selection != null) {
                    selection.clear();
                } else {
                    selection = layer.getSelection();
                }

                transportationAnalyst = getTransportationAnalyst();

                setting = SMAnalyst.setTransportSetting(settingMap);
                setting.setNetworkDataset((DatasetVector) dataset);
                transportationAnalyst.setAnalystSetting(setting);

                boolean result = transportationAnalyst.load();

                SMap.getInstance().getSmMapWC().getMapControl().setAction(Action.PAN);

                WritableMap layerInfo = SMLayer.getLayerInfo(layer, "");

                WritableMap resultMap = Arguments.createMap();
                resultMap.putBoolean("result", result);
                resultMap.putMap("layerInfo", layerInfo);

                promise.resolve(resultMap);
            } else {
                promise.reject(new Exception("No networkDataset"));
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void findPath(ReadableMap params, boolean hasLeastEdgeCount, Promise promise) {
        try {
            transportationAnalyst = getTransportationAnalyst();
            TransportationAnalystParameter paramter = SMAnalyst.getTransportationAnalystParameterByDictionary(params);

            if (paramter.getNodes() != null && paramter.getNodes().length <= 0) {
                ArrayList<Integer> mNodes = new ArrayList<>();
                if (nodes != null && nodes.size() > 0) {
                    mNodes.addAll(nodes);
                }
                if (startNodeID > 0) mNodes.add(0, startNodeID);
                if (endNodeID > 0) mNodes.add(mNodes.size(), endNodeID);
                paramter.setNodes(DataUtil.arrayToIntArray(mNodes));
            }

            if (barrierNodes != null && (paramter.getBarrierNodes() == null || paramter.getBarrierNodes().length <= 0)) {
                paramter.setBarrierNodes(DataUtil.arrayToIntArray(barrierNodes));
            }

            TransportationAnalystResult result = transportationAnalyst.findPath(paramter, hasLeastEdgeCount);
            WritableArray edgeArr = Arguments.createArray();
            WritableArray nodeArr = Arguments.createArray();
            int routesCount = 0;

            if (result != null && result.getEdges() != null) {
                int[][] edges = result.getEdges();
                edgeArr = DataUtil.array2DToRnArray(edges);
            }
            if (result != null && result.getEdges() != null) {
                int[][] nodes = result.getNodes();
                DataUtil.array2DToRnArray(nodes);
            }
            if (result != null && result.getRoutes() != null) {
                GeoLineM[] routes = result.getRoutes();
                routesCount = routes.length;
                if (routesCount > 0) displayRoutes(routes);
            }

            if (result != null) result.dispose();

            WritableMap resultMap = Arguments.createMap();
            resultMap.putArray("edges", edgeArr);
            resultMap.putArray("nodes", nodeArr);
            resultMap.putInt("routesCount", routesCount);
            promise.resolve(resultMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void findTSPPath(ReadableMap params, boolean isEndNodeAssigned, Promise promise) {
        try {
            transportationAnalyst = getTransportationAnalyst();
            TransportationAnalystParameter paramter = SMAnalyst.getTransportationAnalystParameterByDictionary(params);

            if (paramter.getNodes() != null && paramter.getNodes().length <= 0) {
                ArrayList<Integer> mNodes = new ArrayList<>();
                if (nodes != null && nodes.size() > 0) {
                    mNodes.addAll(nodes);
                }
                if (startNodeID > 0) mNodes.add(0, startNodeID);
                if (endNodeID > 0) mNodes.add(mNodes.size(), endNodeID);
                paramter.setNodes(DataUtil.arrayToIntArray(mNodes));
            }

            if (barrierNodes != null && (paramter.getBarrierNodes() == null || paramter.getBarrierNodes().length <= 0)) {
                paramter.setBarrierNodes(DataUtil.arrayToIntArray(barrierNodes));
            }

            TransportationAnalystResult result = transportationAnalyst.findTSPPath(paramter, isEndNodeAssigned);

            WritableArray edgeArr = Arguments.createArray();
            WritableArray nodeArr = Arguments.createArray();
            int routesCount = 0;

            if (result != null && result.getEdges() != null) {
                int[][] edges = result.getEdges();
                edgeArr = DataUtil.array2DToRnArray(edges);
            }
            if (result != null && result.getEdges() != null) {
                int[][] nodes = result.getNodes();
                DataUtil.array2DToRnArray(nodes);
            }
            if (result != null && result.getRoutes() != null) {
                GeoLineM[] routes = result.getRoutes();
                routesCount = routes.length;
                if (routesCount > 0) displayRoutes(routes);
            }

            if (result != null) result.dispose();

            WritableMap resultMap = Arguments.createMap();
            resultMap.putArray("edges", edgeArr);
            resultMap.putArray("nodes", nodeArr);
            resultMap.putInt("routesCount", routesCount);
            promise.resolve(resultMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    public boolean displayRoutes(GeoLineM[] routes) {
        SMap sMap = SMap.getInstance();
        MapControl mapControl = sMap.getSmMapWC().getMapControl();
        TrackingLayer trackingLayer = mapControl.getMap().getTrackingLayer();
//        int count = trackingLayer.getCount();
//        for (int i = 0; i < count; i++) {
//            int index = trackingLayer.indexOf("result");
//            if (index != -1) {
//                trackingLayer.remove(index);
//            }
//        }
        if (routes == null) {
            return false;
        }
        for (int i = 0; i < routes.length; i++) {
            GeoLineM geoLineM = routes[i];
            GeoStyle style = new GeoStyle();
            style.setLineColor(new Color(225, 80, 0));
            style.setLineWidth(1);
            geoLineM.setStyle(style);
            trackingLayer.add(geoLineM, "");
        }
        mapControl.getMap().refresh();
        return true;
    }

    public void findClosestFacilityByID(ReadableMap parameter, String datasourceName, int eventID, int facilityCount, boolean isFromEvent, double maxWeight, String datasetName) {
        Map params = parameter.toHashMap();
        TransportationAnalystParameter transportationAnalystParameter = SMParameter.setTransportationParameter(params);
        TransportationAnalystResult result = transportationAnalyst.findClosestFacility(transportationAnalystParameter, eventID, facilityCount, isFromEvent, maxWeight);
        Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
        Datasource datasource = workspace.getDatasources().get(datasourceName);
        showFindClosest(result, datasource, facilityCount, datasetName);
        transportationAnalystParameter.dispose();

    }

    public void findClosestFacilityByPoint(ReadableMap parameter, ReadableMap point, String datasourceName, int facilityCount, boolean isFromEvent, double maxWeight, String datasetName) {
        Map params = parameter.toHashMap();
        Point2D point2D = new Point2D(point.getInt("pointX"), point.getInt("pointY"));
        TransportationAnalystParameter transportationAnalystParameter = SMParameter.setTransportationParameter(params);
        TransportationAnalystResult result = transportationAnalyst.findClosestFacility(transportationAnalystParameter, point2D, facilityCount, isFromEvent, maxWeight);
        Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
        Datasource datasource = workspace.getDatasources().get(datasourceName);
        showFindClosest(result, datasource, facilityCount, datasetName);
        transportationAnalystParameter.dispose();

    }

    public boolean showFindClosest(TransportationAnalystResult result, Datasource datasource, int facilityCount, String name) {
        if (result == null) {
            return false;
        }
        double[] cost = result.getWeights();
        if (cost.length == facilityCount) {
            return false;
        }
        if (datasource.getDatasets().contains("src_" + name)) {
            datasource.getDatasets().delete("src" + name);
        }
        DatasetVector datasetVector = Network_tool.saveLineM("src_name", datasource, result.getRoutes());
        MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
        mapControl.getMap().getLayers().add(datasetVector, true);
        mapControl.getMap().setAntialias(true);
        result.dispose();
        return true;
    }
}