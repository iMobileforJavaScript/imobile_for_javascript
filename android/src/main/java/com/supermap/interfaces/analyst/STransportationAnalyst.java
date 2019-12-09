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
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.GeoLineM;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoStyle;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.data.TextStyle;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Action;
import com.supermap.mapping.Layers;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;
import com.supermap.smNative.Network_tool;
import com.supermap.smNative.SMAnalyst;
import com.supermap.smNative.SMDatasource;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMParameter;

import org.apache.http.cookie.SM;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class STransportationAnalyst extends SNetworkAnalyst {
    public static final String REACT_CLASS = "STransportationAnalyst";
    private static STransportationAnalyst analyst;
    private static ReactApplicationContext context;
    private TransportationAnalyst transportationAnalyst = null;
    private ArrayList<Integer> nodes = null;
    private ArrayList<Integer> barrierNodes = null;

    private Point2Ds points = null;
    private Point2Ds barrierPoints = null;

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

//    private TransportationAnalyst getTransportationAnalyst() {
//        if (transportationAnalyst == null) {
//            transportationAnalyst = new TransportationAnalyst();
//        }
//        return transportationAnalyst;
//    }

    /**
     * 设置起点
     * @param point
     * @param promise
     */
    @ReactMethod
    public void setStartPoint(ReadableMap point, String text, Promise promise) {
        try {
            String nodeTag = "startNode";
            String textTag = "startNodeText";
            int pointID = 3614;

            GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
            style.setMarkerSymbolID(pointID);
            Point2D tempPoint = this.selectPoint(point, nodeLayer, style, nodeTag);
            if (tempPoint != null) {
                if (startPoint != null) {
                    this.removeTagFromTrackingLayer(nodeTag);
                    this.removeTagFromTrackingLayer(textTag);
                    startPoint = null;

                    int i = 0;
                    while (i < history.getCount()) {
                        HashMap item = history.get(i);
                        if (item.get("tag").equals("startNode") || item.get("tag").equals("startNodeText")) {
                            history.remove(i);
                        } else {
                            i++;
                        }
                    }
                }
                if (nodeLayer != null) {
//                startNodeID = this.selectNode(point, nodeLayer, style, nodeTag);
//
//                double x = point.getDouble("x");
//                double y = point.getDouble("y");
//                Point p = new Point((int)x, (int)y);
//                startPoint = SMap.getInstance().getSmMapWC().getMapControl().getMap().pixelToMap(p);
                    startPoint = tempPoint;

                    TextStyle textStyle = new TextStyle();
                    textStyle.setOutline(true);
                    textStyle.setForeColor(new Color(255, 105, 0));
                    this.setText(text, startPoint, textStyle, textTag);

                    HashMap nodeMap = new HashMap();
                    nodeMap.put("tag", nodeTag);
                    nodeMap.put("labelTag", textTag);
                    nodeMap.put("label", text);
                    nodeMap.put("point", startPoint);
                    nodeMap.put("pointID", pointID);
                    nodeMap.put("pointStyle", style);
                    nodeMap.put("labelStyle", textStyle);
                    if (history == null) {
                        history = new History();
                    }
                    history.addHistory(nodeMap);
                }
                SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
                promise.resolve(startNodeID);
            } else {
                promise.resolve(-1);
            }
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
    public void setEndPoint(ReadableMap point, String text, Promise promise) {
        try {
            String nodeTag = "endNode";
            String textTag = "endNodeText";
            int pointID = 3614;

            GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(105, 255, 0));
            style.setMarkerSymbolID(pointID);
            Point2D tempPoint = this.selectPoint(point, nodeLayer, style, nodeTag);
            if (tempPoint != null) {
                if (endPoint != null) {
                    this.removeTagFromTrackingLayer(nodeTag);
                    this.removeTagFromTrackingLayer(textTag);
                    endPoint = null;

                    int i = 0;
                    while (i < history.getCount()) {
                        HashMap item = history.get(i);
                        if (item.get("tag").equals("endNode") || item.get("tag").equals("endNodeText")) {
                            history.remove(i);
                        } else {
                            i++;
                        }
                    }
                }
                if (nodeLayer != null) {
                    endPoint = tempPoint;

                    TextStyle textStyle = new TextStyle();
                    textStyle.setOutline(true);
                    textStyle.setForeColor(new Color(105, 255, 0));
                    this.setText(text, endPoint, textStyle, textTag);

                    HashMap nodeMap = new HashMap();
                    nodeMap.put("tag", nodeTag);
                    nodeMap.put("labelTag", textTag);
                    nodeMap.put("label", text);
                    nodeMap.put("point", endPoint);
                    nodeMap.put("pointID", pointID);
                    nodeMap.put("pointStyle", style);
                    nodeMap.put("labelStyle", textStyle);
                    if (history == null) {
                        history = new History();
                    }
                    history.addHistory(nodeMap);
                }
                SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
                promise.resolve(endNodeID);
            } else {
                promise.resolve(-1);
            }
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
    public void addBarrierNode(ReadableMap point, String text, Promise promise) {
        try {
            String nodeTag = "barrier_node_" + new Date().getTime();
            int node = -1;
            int pointID = 3614;
            if (nodeLayer != null) {
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 0, 0));
                style.setMarkerSymbolID(pointID);

//                node = this.selectNode(point, nodeLayer, style, nodeTag);
//                if (barrierNodes == null) {
//                    barrierNodes = new ArrayList<>();
//                }

                if (barrierPoints == null) {
                    barrierPoints = new Point2Ds();
                }
                Point2D point2D = this.selectPoint(point, nodeLayer, style, nodeTag);
                if (point2D != null) {
//                    int index = barrierNodes != null;
                    this.addBarrierPoints(point2D);

                    String label = text+barrierPoints.getCount();
                    TextStyle textStyle = new TextStyle();
                    textStyle.setOutline(true);
//                    textStyle.setFontWidth(6);
//                    textStyle.setFontHeight(8);
                    textStyle.setForeColor(new Color(255, 0, 0));
                    this.setText(label, point2D, textStyle, nodeTag);

                    HashMap nodeMap = new HashMap();
                    nodeMap.put("tag", nodeTag);
                    nodeMap.put("labelTag", nodeTag);
                    nodeMap.put("label", label);
                    nodeMap.put("point", point2D);
                    nodeMap.put("pointID", pointID);
                    nodeMap.put("pointStyle", style);
                    nodeMap.put("labelStyle", textStyle);
                    if (history == null) {
                        history = new History();
                    }
                    history.addHistory(nodeMap);
                }

//                if (node > 0) {
//                    barrierNodes.add(node);
//                }
            }
            SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
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
    public void addNode(ReadableMap point, String text, Promise promise) {
        try {
            String nodeTag = "node_" + new Date().getTime();
//            int node = -1;
            int pointID = 3614;
            if (nodeLayer != null) {
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(212, 161, 70));
                style.setMarkerSymbolID(pointID);

//                node = this.selectNode(point, nodeLayer, style, nodeTag);
//                if (nodes == null) {
//                    nodes = new ArrayList<>();
//                }

                if (points == null) {
                    points = new Point2Ds();
                }
                Point2D point2D = this.selectPoint(point, nodeLayer, style, nodeTag);
                if (point2D != null) {
                    this.addPoint(point2D);

                    String label = text + points.getCount();
                    TextStyle textStyle = new TextStyle();
                    textStyle.setOutline(true);
//                    textStyle.setFontWidth(6);
//                    textStyle.setFontHeight(8);
                    textStyle.setForeColor(new Color(212, 161, 70));
                    this.setText(label, point2D, textStyle, nodeTag);

                    HashMap nodeMap = new HashMap();
                    nodeMap.put("tag", nodeTag);
                    nodeMap.put("labelTag", nodeTag);
                    nodeMap.put("label", label);
                    nodeMap.put("point", point2D);
                    nodeMap.put("pointID", pointID);
                    nodeMap.put("pointStyle", style);
                    nodeMap.put("labelStyle", textStyle);
                    if (history == null) {
                        history = new History();
                    }
                    history.addHistory(nodeMap);
                }

//                if (node > 0) {
//                    nodes.add(node);
//                }
            }
            SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(true);
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
            if (points != null) points.clear();
            if (barrierPoints != null) barrierPoints.clear();
            if (history != null) history.clear();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除路线，保留点
     * @param promise
     */
    @ReactMethod
    public void clearRoutes(Promise promise) {
        try {
            clearRoutes();
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
                    String layerName = dataset.getName() + "@" + datasource.getAlias();
                    layer = SMLayer.findLayerWithName(layerName);
                    if (layer == null) {
                        layer = layers.add(dataset, true);
                        layer.setSelectable(false);

                        Dataset nodeDataset = ((DatasetVector)dataset).getChildDataset();
                        if (nodeDataset != null) {
                            nodeLayer = layers.add(nodeDataset, true);
                            nodeLayer.setSelectable(true);
                            nodeLayer.setVisible(true);
                        }
                    } else {
                        int index = layer.getName().indexOf("@");
                        String name = layer.getName().substring(0, index);
                        String dsName = layer.getName().substring(index + 1);
                        if (!name.equals("") && !dsName.equals("")) {
                            String nodeLayerName = name + "_Node@" + dsName;
                            nodeLayer = SMLayer.findLayerWithName(nodeLayerName);
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
//                if (selection != null && selection.) {
//                    selection.clear();
//                } else {
                selection = layer.getSelection();
//                }

                if (transportationAnalyst != null) {
                    transportationAnalyst.dispose();
                    transportationAnalyst = null;
                }
                transportationAnalyst = new TransportationAnalyst();

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
//            transportationAnalyst = getTransportationAnalyst();
            TransportationAnalystParameter paramter = SMAnalyst.getTransportationAnalystParameterByDictionary(params);

//            if (paramter.getNodes() != null && paramter.getNodes().length <= 0) {
//                ArrayList<Integer> mNodes = new ArrayList<>();
//                if (nodes != null && nodes.size() > 0) {
//                    mNodes.addAll(nodes);
//                }
//                if (startNodeID > 0) mNodes.add(0, startNodeID);
//                if (endNodeID > 0) mNodes.add(mNodes.size(), endNodeID);
//                paramter.setNodes(DataUtil.arrayToIntArray(mNodes));
//            }
//
//            if (barrierNodes != null && (paramter.getBarrierNodes() == null || paramter.getBarrierNodes().length <= 0)) {
//                paramter.setBarrierNodes(DataUtil.arrayToIntArray(barrierNodes));
//            }
//
//            if (barrierNodes != null && (paramter.getBarrierNodes() == null || paramter.getBarrierNodes().length <= 0)) {
//                paramter.setBarrierNodes(DataUtil.arrayToIntArray(barrierNodes));
//            }

            if (paramter.getPoints() == null || paramter.getPoints().getCount() <= 0) {
                if (points == null) {
                    points = new Point2Ds();
                }
                Point2Ds ps = new Point2Ds(points);
                if (startPoint != null) ps.insert(0, startPoint);
                if (endPoint != null) ps.add(endPoint);
                paramter.setPoints(ps);
            }

            if (barrierPoints != null && (paramter.getBarrierPoints() == null || paramter.getBarrierPoints().getCount() <= 0)) {
                paramter.setBarrierPoints(barrierPoints);
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
//            transportationAnalyst = getTransportationAnalyst();
            TransportationAnalystParameter paramter = SMAnalyst.getTransportationAnalystParameterByDictionary(params);

//            if (paramter.getNodes() != null && paramter.getNodes().length <= 0) {
//                ArrayList<Integer> mNodes = new ArrayList<>();
//                if (nodes != null && nodes.size() > 0) {
//                    mNodes.addAll(nodes);
//                }
//                if (startNodeID > 0) mNodes.add(0, startNodeID);
//                if (endNodeID > 0) mNodes.add(mNodes.size(), endNodeID);
//                paramter.setNodes(DataUtil.arrayToIntArray(mNodes));
//            }
//
//            if (barrierNodes != null && (paramter.getBarrierNodes() == null || paramter.getBarrierNodes().length <= 0)) {
//                paramter.setBarrierNodes(DataUtil.arrayToIntArray(barrierNodes));
//            }

            if (paramter.getPoints() == null || paramter.getPoints().getCount() <= 0) {
                if (points == null) {
                    points = new Point2Ds();
                }
                Point2Ds ps = new Point2Ds(points);
                if (startPoint != null) ps.insert(0, startPoint);
                if (endPoint != null) ps.add(endPoint);
                paramter.setPoints(ps);
            }

            if (barrierPoints != null && (paramter.getBarrierPoints() == null || paramter.getBarrierPoints().getCount() <= 0)) {
                paramter.setBarrierPoints(barrierPoints);
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

    @ReactMethod
    public void undo(Promise promise) {
        try {
            int preIndex = history.undo();
            if (preIndex == - 1) {
                promise.resolve(false);
            } else {
                HashMap node = history.get(preIndex);

                String tag = node.get("tag").toString();
                String labelTag = node.get("labelTag").toString();
                if (tag.indexOf("node_") == 0 && points != null) {
                    points.remove(points.getCount() - 1);
                } else if (tag.indexOf("barrier_node_") == 0 && barrierPoints != null) {
                    barrierPoints.remove(barrierPoints.getCount() - 1);
                } else if (tag.equals("startNode") && startPoint != null) {
                    startPoint = null;
                } else if (tag.equals("endNode") && endPoint != null) {
                    endPoint = null;
                }

                TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();

                if (trackingLayer.indexOf(tag) >= 0) trackingLayer.remove(trackingLayer.indexOf(tag));
                if (trackingLayer.indexOf(labelTag) >= 0) trackingLayer.remove(trackingLayer.indexOf(labelTag));

                SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
                promise.resolve(true);
            }
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    @ReactMethod
    public void redo(Promise promise) {
        try {
            int preIndex = history.redo();
            if (preIndex == history.getCount() - 1) {
                promise.resolve(false);
            } else {
                HashMap node = history.get(history.getCurrentIndex());

                String tag = node.get("tag").toString();
                String labelTag = node.get("labelTag").toString();
                String label = node.get("label").toString();
                TextStyle labelStyle = (TextStyle)node.get("labelStyle");
                GeoStyle pointStyle = (GeoStyle)node.get("pointStyle");
                int pointID = (int)node.get("pointID");
                Point2D point2D = (Point2D)node.get("point");
                if (tag.indexOf("node_") == 0 && points != null) {
                    points.add(point2D);
                } else if (tag.indexOf("barrier_node_") == 0 && barrierPoints != null) {
                    barrierPoints.add(point2D);
                } else if (tag.equals("startNode")) {
                    startPoint = point2D;
                } else if (tag.equals("endNode")) {
                    endPoint = point2D;
                }

                TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();

                GeoPoint geoPoint = new GeoPoint();

                if (pointStyle == null) {
                    pointID = pointID > 0 ? pointID : 3614;
                    pointStyle.setMarkerSymbolID(pointID);
                }
                geoPoint.setStyle(pointStyle);
                geoPoint.setX((int)point2D.getX());
                geoPoint.setY((int)point2D.getY());

                trackingLayer.add(geoPoint, tag);

                this.setText(label, point2D, labelStyle, labelTag);

                geoPoint.dispose();

                SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
                promise.resolve(true);
            }
        } catch (Exception e) {
            promise.resolve(false);
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
            trackingLayer.add(geoLineM, routeTag);
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

    public void addBarrierPoints(Point2D point) {
        if (barrierPoints == null) barrierPoints = new Point2Ds();
        boolean isExist = false;

        for (int i = 0; i < barrierPoints.getCount(); i++) {
            Point2D pt = barrierPoints.getItem(i);
            if (pt.getX() == point.getX() && pt.getY() == point.getY()) {
                isExist = true;
                break;
            }
        }

        if (!isExist) {
            com.supermap.mapping.Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
            if (SMap.safeGetType(map.getPrjCoordSys(), transportationAnalyst.getAnalystSetting().getNetworkDataset().getPrjCoordSys().getType())) {
                Point2Ds point2Ds = new Point2Ds();
                point2Ds.add(point);
                PrjCoordSys prjCoordSys = new PrjCoordSys();
                prjCoordSys.setType(transportationAnalyst.getAnalystSetting().getNetworkDataset().getPrjCoordSys().getType());
                CoordSysTransParameter parameter = new CoordSysTransParameter();

                CoordSysTranslator.convert(point2Ds, prjCoordSys, map.getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                point = point2Ds.getItem(0);
            }
            barrierPoints.add(point);
        }
    }

    public void addPoint(Point2D point) {
        if (barrierPoints == null) barrierPoints = new Point2Ds();
        boolean isExist = false;

        for (int i = 0; i < points.getCount(); i++) {
            Point2D pt = points.getItem(i);
            if (pt.getX() == point.getX() && pt.getY() == point.getY()) {
                isExist = true;
                break;
            }
        }

        if (!isExist) {
            com.supermap.mapping.Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
            if (SMap.safeGetType(map.getPrjCoordSys(), transportationAnalyst.getAnalystSetting().getNetworkDataset().getPrjCoordSys().getType())) {
                Point2Ds point2Ds = new Point2Ds();
                point2Ds.add(point);
                PrjCoordSys prjCoordSys = new PrjCoordSys();
                prjCoordSys.setType(transportationAnalyst.getAnalystSetting().getNetworkDataset().getPrjCoordSys().getType());
                CoordSysTransParameter parameter = new CoordSysTransParameter();

                CoordSysTranslator.convert(point2Ds, prjCoordSys, map.getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                point = point2Ds.getItem(0);
            }
            points.add(point);
        }
    }
}