package com.supermap.interfaces;

import android.view.GestureDetector;
import android.view.MotionEvent;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.analyst.BufferAnalyst;
import com.supermap.analyst.BufferAnalystGeometry;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferEndType;
import com.supermap.analyst.BufferRadiusUnit;
import com.supermap.analyst.networkanalyst.FacilityAnalyst;
import com.supermap.analyst.networkanalyst.FacilityAnalystResult;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.TransportationAnalyst;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.analyst.networkanalyst.TransportationAnalystResult;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;
import com.supermap.data.Color;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasource;
import com.supermap.data.Datasources;
import com.supermap.data.EncodeType;
import com.supermap.data.Enum;
import com.supermap.data.GeoLineM;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoRegion;
import com.supermap.data.GeoStyle;
import com.supermap.data.GeoText;
import com.supermap.data.Geometry;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.data.TextPart;
import com.supermap.data.TextStyle;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Action;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerSetting;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;
import com.supermap.rnsupermap.JSLayer;
import com.supermap.rnsupermap.JSMap;
import com.supermap.smNative.Network_tool;
import com.supermap.smNative.SMAnalyst;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMParameter;

import java.util.ArrayList;
import java.util.Map;

public class SAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SAnalyst";
    private static SAnalyst analyst;
    private static ReactApplicationContext context;
//    private LongPressAction longPressAction = LongPressAction.NULL;
    private ArrayList<Integer> m_elementIDs = null;
    private FacilityAnalyst facilityAnalyst=null;
    private TransportationAnalyst transportationAnalyst=null;

    private GeoStyle getGeoStyle(Size2D size2D, Color color) {
        GeoStyle geoStyle = new GeoStyle();
        geoStyle.setMarkerSize(size2D);
        geoStyle.setLineColor(color);
        return geoStyle;
    }

    ReactContext mReactContext;

    public SAnalyst(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    /******************************************************************************缓冲区分析*****************************************************************************************/

    @ReactMethod
    public void analystBuffer(String layerPath, ReadableMap params, Promise promise) {
        try {
            com.supermap.mapping.Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
            Layer layer = SMLayer.findLayerByPath(layerPath);
            Selection selection = layer.getSelection();
            Recordset recordset = selection.toRecordset();

            TrackingLayer trackingLayer = map.getTrackingLayer();

            trackingLayer.clear();
            while (!recordset.isEOF()) {

                Geometry geoForBuffer = recordset.getGeometry();
                Dataset queryDataset = recordset.getDataset();

                PrjCoordSys prjCoordSys = queryDataset.getPrjCoordSys();

                BufferAnalystParameter bufferAnalystParameter = new BufferAnalystParameter();
                ReadableMap parameter = params.getMap("parameter");

                if (params.hasKey("parameter")) {
                    if (parameter.hasKey("endType")) {
                        BufferEndType endType = (BufferEndType) Enum.parse(BufferEndType.class, parameter.getInt("endType"));
                        bufferAnalystParameter.setEndType(endType);
                    }
                    if (parameter.hasKey("leftDistance")) {
                        bufferAnalystParameter.setLeftDistance(parameter.getInt("leftDistance"));
                    }
                    if (parameter.hasKey("rightDistance")) {
                        bufferAnalystParameter.setRightDistance(parameter.getInt("rightDistance"));
                    }
                }

                GeoRegion geoRegion = BufferAnalystGeometry.createBuffer(geoForBuffer, bufferAnalystParameter, prjCoordSys);

                GeoStyle geoStyle = SMAnalyst.getGeoStyleByDictionary(params.getMap("geoStyle"));
                if (geoStyle != null) {
                    geoRegion.setStyle(geoStyle);
                }

                trackingLayer.add(geoRegion, "");

                recordset.moveNext();
            }
            recordset.dispose();

            map.refresh();
            promise.resolve(true);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /**
     * 创建矢量数据集缓冲区
     */
    @ReactMethod
    public void createBuffer(ReadableMap sourceData, ReadableMap resultData, ReadableMap bufferParameter, boolean isUnion, boolean isAttributeRetained, ReadableMap optionParameter, Promise promise) {
        try {
            com.supermap.mapping.Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
            if (map.getWorkspace() == null || map.getWorkspace() != SMap.getInstance().getSmMapWC().getWorkspace()) {
                map.setWorkspace(SMap.getInstance().getSmMapWC().getWorkspace());
            }

            Dataset sourceDataset = SMAnalyst.getDatasetByDictionary(sourceData);
            Dataset resultDataset = null;

            if (resultData.hasKey("dataset")) {
                resultDataset = SMAnalyst.createDatasetByDictionary(resultData);
            }

            boolean result = false;
            String errorMsg = "";

            if (sourceDataset != null && resultDataset != null) {
                BufferAnalystParameter parameter = SMAnalyst.getBufferAnalystParameterByDictionary(bufferParameter);

                if (parameter != null) {
                    result = BufferAnalyst.createBuffer((DatasetVector)sourceDataset, (DatasetVector)resultDataset, parameter, isUnion, isAttributeRetained);

                    if (!result) errorMsg = "分析失败";
                } else {
                    errorMsg = "缺少分析参数";
                }
            } else {
                if (sourceDataset == null) {
                    errorMsg = "数据源不存在";
                } else if (sourceData == null) {
                    errorMsg = "数据集已存在";
                }
            }

            GeoStyle geoStyle = null;
            ReadableMap geoStyleMap;
            if (optionParameter.hasKey("geoStyle")) {
                geoStyle = SMAnalyst.getGeoStyleByDictionary(optionParameter.getMap("geoStyle"));
            } else {
                geoStyle = SMAnalyst.getGeoStyleByDictionary(null);
            }
            if (geoStyle != null) {
                String description = "{\"geoStyle\":" + geoStyle.toJson() + "}";
                resultDataset.setDescription(description);
            }

            if (result && optionParameter.hasKey("showResult")) {
                boolean showResult = optionParameter.getBoolean("showResult");
                if (showResult) {
                    Layer layer = map.getLayers().add(resultDataset, true);
                    if (geoStyle != null) {
                        LayerSetting layerSetting = layer.getAdditionalSetting();
                        ((LayerSettingVector) layerSetting).setStyle(geoStyle);
                    }

                    map.refresh();
                }
            }

            WritableMap resultMap = Arguments.createMap();
            resultMap.putBoolean("result", result);
            if (result) {
                promise.resolve(resultMap);
            } else {
                SMAnalyst.deleteDataset(resultData);
                resultMap.putString("errorMsg", errorMsg);
                promise.resolve(resultMap);
            }
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

    /**
     * 多重缓冲区分析
     * @param sourceData
     * @param resultData
     * @param bufferRadiuses
     * @param bufferRadiusUnit
     * @param semicircleSegments
     * @param isUnion
     * @param isAttributeRetained
     * @param isRing
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void createMultiBuffer(ReadableMap sourceData, ReadableMap resultData, ReadableArray bufferRadiuses, String bufferRadiusUnit, int semicircleSegments, boolean isUnion, boolean isAttributeRetained, boolean isRing, ReadableMap optionParameter, Promise promise) {
        try {
            com.supermap.mapping.Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
            if (map.getWorkspace() == null || map.getWorkspace() != SMap.getInstance().getSmMapWC().getWorkspace()) {
                map.setWorkspace(SMap.getInstance().getSmMapWC().getWorkspace());
            }

            Dataset sourceDataset = SMAnalyst.getDatasetByDictionary(sourceData);
            Dataset resultDataset = null;

            if (resultData.hasKey("dataset")) {
                resultDataset = SMAnalyst.createDatasetByDictionary(resultData);
            }

            boolean result = false;
            String errorMsg = "";

            if (sourceDataset != null && resultDataset != null) {
                BufferRadiusUnit unit = SMAnalyst.getBufferRadiusUnit(bufferRadiusUnit);

                double[] radiusArr = new double[bufferRadiuses.size()];
                for (int i = 0; i < bufferRadiuses.size(); i++) {
                    radiusArr[i] = bufferRadiuses.getDouble(i);
                }
                result = BufferAnalyst.createMultiBuffer((DatasetVector)sourceDataset, (DatasetVector)resultDataset, radiusArr, unit, semicircleSegments, isUnion, isAttributeRetained, isRing);

                if (!result) errorMsg = "分析失败";
            } else {
                if (sourceDataset == null) {
                    errorMsg = "数据源不存在";
                } else if (sourceData == null) {
                    errorMsg = "数据集已存在";
                }
            }

            GeoStyle geoStyle = null;
            ReadableMap geoStyleMap;
            if (optionParameter.hasKey("geoStyle")) {
                geoStyle = SMAnalyst.getGeoStyleByDictionary(optionParameter.getMap("geoStyle"));
            } else {
                geoStyle = SMAnalyst.getGeoStyleByDictionary(null);
            }
            if (geoStyle != null) {
                String description = "{\"geoStyle\":" + geoStyle.toJson() + "}";
                resultDataset.setDescription(description);
            }

            if (result && optionParameter.hasKey("showResult")) {
                boolean showResult = optionParameter.getBoolean("showResult");
                if (showResult) {
                    Layer layer = map.getLayers().add(resultDataset, true);
                    if (geoStyle != null) {
                        LayerSetting layerSetting = layer.getAdditionalSetting();
                        ((LayerSettingVector) layerSetting).setStyle(geoStyle);
                    }

                    map.refresh();
                }
            }

            WritableMap resultMap = Arguments.createMap();
            if (result) {
                resultMap.putBoolean("result", result);
                promise.resolve(result);
            } else {
                SMAnalyst.deleteDataset(resultData);
                promise.reject(null, errorMsg);
            }
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }


    /********************************************************************************叠加分析**************************************************************************************/

    /**
     * 叠加分析-裁剪
     * @param sourceData
     * @param targetData
     * @param resultData
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void clip(ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter, Promise promise) {
        try {
            boolean result = SMAnalyst.overlayerAnalystWithType("clip", sourceData, targetData, resultData, optionParameter);
            promise.resolve(result);
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

    /**
     * 叠加分析-擦除
     * @param sourceData
     * @param targetData
     * @param resultData
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void erase(ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter, Promise promise) {
        try {
            boolean result = SMAnalyst.overlayerAnalystWithType("erase", sourceData, targetData, resultData, optionParameter);
            promise.resolve(result);
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

    /**
     * 叠加分析-同一
     * @param sourceData
     * @param targetData
     * @param resultData
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void identity(ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter, Promise promise) {
        try {
            boolean result = SMAnalyst.overlayerAnalystWithType("identity", sourceData, targetData, resultData, optionParameter);
            promise.resolve(result);
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

    /**
     * 叠加分析-相交
     * @param sourceData
     * @param targetData
     * @param resultData
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void intersect(ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter, Promise promise) {
        try {
            boolean result = SMAnalyst.overlayerAnalystWithType("intersect", sourceData, targetData, resultData, optionParameter);
            promise.resolve(result);
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

    /**
     * 叠加分析-合并
     * @param sourceData
     * @param targetData
     * @param resultData
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void union(ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter, Promise promise) {
        try {
            boolean result = SMAnalyst.overlayerAnalystWithType("union", sourceData, targetData, resultData, optionParameter);
            promise.resolve(result);
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

    /**
     * 叠加分析-更新
     * @param sourceData
     * @param targetData
     * @param resultData
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void update(ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter, Promise promise) {
        try {
            boolean result = SMAnalyst.overlayerAnalystWithType("update", sourceData, targetData, resultData, optionParameter);
            promise.resolve(result);
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

    /**
     * 叠加分析-对称差
     * @param sourceData
     * @param targetData
     * @param resultData
     * @param optionParameter
     * @param promise
     */
    @ReactMethod
    public void xOR(ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter, Promise promise) {
        try {
            boolean result = SMAnalyst.overlayerAnalystWithType("xOR", sourceData, targetData, resultData, optionParameter);
            promise.resolve(result);
        } catch (Exception e) {
            SMAnalyst.deleteDataset(resultData);
            promise.reject(e);
        }
    }

//    @ReactMethod
//    public void createLineOneSideMultiBuffer(String datasetPath, ReadableArray arrBufferRadius, int bufferRadiusUnit, int semicircleSegment, Boolean isLeft, Boolean isUnion, Boolean isAttributeRetained, Boolean isRing, Promise promise) {
//        try {
//            DatasetVector sourceDataset = (DatasetVector) SMLayer.findLayerByPath(datasetPath).getDataset();
//            String resultDatasetName = sourceDataset.getDatasource().getDatasets().getAvailableDatasetName("resultDatasetBuffer");
//            DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
//            DatasetType datasetType = sourceDataset.getType();
//            datasetVectorInfo.setType(datasetType);
//            datasetVectorInfo.setName(resultDatasetName);
//            datasetVectorInfo.setEncodeType(EncodeType.NONE);
//            DatasetVector resultDatasetBuffer = sourceDataset.getDatasource().getDatasets().create(datasetVectorInfo);
//            datasetVectorInfo.dispose();
//            BufferRadiusUnit unit = (BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class, bufferRadiusUnit);
//
//            ArrayList listArr = arrBufferRadius.toArrayList();
//            Object[] objArr = listArr.toArray();
//            double[] doubleArr = new double[objArr.length];
//            for (int i = 0; i <= objArr.length - 1; i++) {
//                doubleArr[i] = (double) objArr[i];
//            }
//            Boolean isCreate = BufferAnalyst.createLineOneSideMultiBuffer(sourceDataset, resultDatasetBuffer, doubleArr, unit, semicircleSegment, isLeft, isUnion, isAttributeRetained, isRing);
//            WritableMap map = Arguments.createMap();
//            map.putBoolean("isCreate", isCreate);
//            promise.resolve(map);
//        } catch (Exception e) {
//            promise.reject(e);
//        }
//    }
//
//
//    /**
//     * 对矢量数据集进行查询
//     */
//    public Recordset query(String datasetPath, ReadableMap queryParameterMap) {
//        DatasetVector datasetVector = (DatasetVector) SMLayer.findLayerByPath(datasetPath).getDataset();
//        Map params = queryParameterMap.toHashMap();
//        QueryParameter queryParameter = SMParameter.setQueryParameter(params);
//        Recordset recordset = datasetVector.query(queryParameter);
//        queryParameter.dispose();
//        return recordset;
//    }
//
//
//    /**
//     * 加载设施网络分析模型
//     */
//    @ReactMethod
//    public void loadModel(String datasetPath, ReadableMap facilitySetting, ReadableMap weightFieldInfo,Promise promise) {
//       try {
//           DatasetVector datasetVector = (DatasetVector) SMLayer.findLayerByPath(datasetPath).getDataset();
//           Map params = facilitySetting.toHashMap();
//           FacilityAnalystSetting analystSetting = SMParameter.setfacilitySetting(params);
//           analystSetting.setNetworkDataset(datasetVector);
//           Map data = weightFieldInfo.toHashMap();
//           WeightFieldInfo weightFieldInfo1 = SMParameter.setweightFieldInfo(data);
//           WeightFieldInfos weightFieldInfos = new WeightFieldInfos();
//           weightFieldInfos.add(weightFieldInfo1);
//           analystSetting.setWeightFieldInfos(weightFieldInfos);
//           facilityAnalyst=new FacilityAnalyst();
//           facilityAnalyst.setAnalystSetting(analystSetting);
//           facilityAnalyst.load();
//           promise.resolve(true);
//       }catch (Exception e){
//           promise.reject(e);
//       }
//    }
//
//    @ReactMethod
//    public void traceUp(Selection selection, MapControl mapControl,Promise promise) {
//       try {
//           for (int i = 0; i < m_elementIDs.size(); i++) {
//               FacilityAnalystResult facilityAnalystResult = facilityAnalyst.traceUpFromNode(m_elementIDs.get(i), "length", true);
//               int[] resultIDs = facilityAnalystResult.getEdges();
//               for (int j = 0; j < resultIDs.length; j++) {
//                   selection.add(resultIDs[j]);
//               }
//           }
//           displayResult(selection, mapControl);
//           mapControl.setAction(Action.PAN);
//           promise.resolve(true);
//       }catch (Exception e){
//           promise.reject(e);
//       }
//    }
//
//    @ReactMethod
//    public void traceDown( Selection selection, MapControl mapControl,Promise promise) {
//        try {
//            for (int i = 0; i < m_elementIDs.size(); i++) {
//                FacilityAnalystResult facilityAnalystResult = facilityAnalyst.traceDownFromNode(m_elementIDs.get(i), "length", true);
//                int[] resultIDs = facilityAnalystResult.getEdges();
//                for (int j = 0; j < resultIDs.length; j++) {
//                    selection.add(resultIDs[j]);
//                }
//            }
//            displayResult(selection, mapControl);
//            mapControl.setAction(Action.PAN);
//            promise.resolve(true);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//    }
//
//    @ReactMethod
//    public void connectedAnalyst( Selection selection, MapControl mapControl,Promise promise) {
//        try {
//            int[] IDs = new int[m_elementIDs.size()];
//            for (int i = 0; i < IDs.length; i++) {
//                IDs[i] = m_elementIDs.get(i);
//            }
//            for (int i = 0; i < IDs.length; i++) {
//                FacilityAnalystResult facilityAnalystResult = facilityAnalyst.findPathFromNodes(IDs[i], IDs[i + 1], "length", false);
//                if (facilityAnalystResult == null) {
//                    continue;
//                }
//                int[] edgess = facilityAnalystResult.getEdges();
//                for (int j = 0; j < edgess.length; j++) {
//                    selection.add(edgess[j]);
//                }
//            }
//            displayResult(selection, mapControl);
//            mapControl.setAction(Action.PAN);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//
//    }

//    /**
//     * 加载交通网络分析环境设置对象
//     */
//    @ReactMethod
//    public void loadTransport(ReadableMap facilitySetting, ReadableMap weightFieldInfo, Promise promise) {
//        try {
//            Map params = facilitySetting.toHashMap();
//            TransportationAnalystSetting transportationAnalystSetting = SMParameter.settransportationSetting(params);
//            Map data = weightFieldInfo.toHashMap();
//            WeightFieldInfo weightFieldInfo1 = SMParameter.setweightFieldInfo(data);
//            WeightFieldInfos weightFieldInfos = new WeightFieldInfos();
//            weightFieldInfos.add(weightFieldInfo1);
//            transportationAnalystSetting.setWeightFieldInfos(weightFieldInfos);
//            if(transportationAnalyst==null){
//                transportationAnalyst=new TransportationAnalyst();
//            }
//            transportationAnalyst.setAnalystSetting(transportationAnalystSetting);
//            transportationAnalyst.load();
//            promise.resolve(true);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//    }
//
//    @ReactMethod
//    public void findPath(ReadableMap transportationAnalystParameter,Promise promise) {
//        try {
//            Map params = transportationAnalystParameter.toHashMap();
//            TransportationAnalystParameter transportationAnalystParameter1=SMParameter.settransportationParameter(params);
//            TransportationAnalystResult analystResult = transportationAnalyst.findPath(transportationAnalystParameter1, false);
//            transportationAnalystParameter1.dispose();
//            boolean result=showFindPathResult(analystResult);
//            promise.resolve(result);
//        } catch (Exception e) {
//            promise.reject(e);
//        }
//    }
//
//
//    public boolean showFindPathResult(TransportationAnalystResult result) {
//        SMap sMap = SMap.getInstance();
//        MapControl mapControl = sMap.getSmMapWC().getMapControl();
//        TrackingLayer trackingLayer = mapControl.getMap().getTrackingLayer();
//        int count = trackingLayer.getCount();
//        for (int i = 0; i < count; i++) {
//            int index = trackingLayer.indexOf("result");
//            if (index != -1) {
//                trackingLayer.remove(index);
//            }
//        }
//        GeoLineM[] routes = result.getRoutes();
//        if (routes == null) {
//            return false;
//        }
//        for (int i = 0; i < routes.length; i++) {
//            GeoLineM geoLineM = routes[i];
//            GeoStyle style = new GeoStyle();
//            style.setLineColor(new Color(225, 80, 0));
//            style.setLineWidth(1);
//            geoLineM.setStyle(style);
//            trackingLayer.add(geoLineM, "result");
//        }
//        mapControl.getMap().refresh();
//        return true;
//    }
//
//    public void findClosestFacilityByID(ReadableMap parameter,String datasourceName,int eventID,int facilityCount, boolean isFromEvent,double maxWeight,String datasetname){
//        Map params=parameter.toHashMap();
//        TransportationAnalystParameter transportationAnalystParameter=SMParameter.settransportationParameter(params);
//        TransportationAnalystResult result=transportationAnalyst.findClosestFacility(transportationAnalystParameter,eventID,facilityCount,isFromEvent,maxWeight);
//        Workspace workspace=SMap.getInstance().getSmMapWC().getWorkspace();
//        Datasource datasource=workspace.getDatasources().get(datasourceName);
//        showfindClosest(result,datasource,facilityCount,datasetname);
//        transportationAnalystParameter.dispose();
//
//    }
//
//    public void findClosestFacilityByPoint(ReadableMap parameter,ReadableMap point,String datasourceName,int facilityCount, boolean isFromEvent,double maxWeight,String datasetname){
//        Map params=parameter.toHashMap();
//        Point2D point2D=new Point2D(point.getInt("pointX"),point.getInt("pointY"));
//        TransportationAnalystParameter transportationAnalystParameter=SMParameter.settransportationParameter(params);
//        TransportationAnalystResult result=transportationAnalyst.findClosestFacility(transportationAnalystParameter,point2D,facilityCount,isFromEvent,maxWeight);
//        Workspace workspace=SMap.getInstance().getSmMapWC().getWorkspace();
//        Datasource datasource=workspace.getDatasources().get(datasourceName);
//        showfindClosest(result,datasource,facilityCount,datasetname);
//        transportationAnalystParameter.dispose();
//
//    }
//
//    public boolean showfindClosest(TransportationAnalystResult result, Datasource datasource, int facilityCount, String name){
//        if(result==null){
//            return false;
//        }
//        double[] cost=result.getWeights();
//        if(cost.length==facilityCount){
//            return  false;
//        }
//        if(datasource.getDatasets().contains("src_"+name)){
//            datasource.getDatasets().delete("src"+name);
//        }
//        DatasetVector datasetVector=Network_tool.saveLineM("src_name",datasource,result.getRoutes());
//        MapControl mapControl=SMap.getInstance().getSmMapWC().getMapControl();
//        mapControl.getMap().getLayers().add(datasetVector,true);
//        mapControl.getMap().setAntialias(true);
//        result.dispose();
//        return true;
//    }

//    class gestureListener extends GestureDetector.SimpleOnGestureListener {
//
//        @Override
//        public void onLongPress(MotionEvent e) {
//            switch (longPressAction) {
//                case FACILITYANALYST:
//                    Point pt = new Point((int) e.getX(), (int) e.getY());
//                    SMap sMap = SMap.getInstance();
//                    MapControl mapControl = sMap.getSmMapWC().getMapControl();
//                    Selection selection = mapControl.getMap().getLayers().get(0).hitTestEx(pt, 20);
//                    if (selection != null && selection.getCount() > 0) {
//                        Recordset recordset = selection.toRecordset();
//                        GeoPoint point = (GeoPoint) recordset.getGeometry();
//                        m_elementIDs.add(recordset.getInt32("SMNODEID"));
//                        System.out.println(recordset.getInt32("SMNODEID"));
//                        GeoStyle geoStyle = getGeoStyle(new Size2D(10,
//                                10), new Color(255, 105, 0));
//                        geoStyle.setMarkerSymbolID(3614);
//                        point.setStyle(geoStyle);
//
//                        int count = m_elementIDs.size();
//                        TextPart textPart = new TextPart("要素" + count,
//                                new Point2D(point.getX(), point.getY()));
//                        GeoText geoText = new GeoText(textPart);
//                        TextStyle textStyle = new TextStyle();
//                        textStyle.setForeColor(new Color(0, 255, 0));
//                        geoText.setTextStyle(textStyle);
//
//                        mapControl.getMap().getTrackingLayer().add(point, "");
//                        mapControl.getMap().getTrackingLayer().add(geoText, "");
//                        mapControl.getMap().refresh();
//
//                        point.dispose();
//                        geoText.dispose();
//                        recordset.close();
//                        recordset.dispose();
//                    }
//                    break;
//                case TRANSPORTANALYST:
//                    break;
//            }
//        }
//    }
//
//    enum LongPressAction {
//        /**
//         * 空操作
//         */
//        NULL,
//        /**
//         *设施网络分析
//         */
//        FACILITYANALYST,
//        /**
//         *交通网络分析
//         */
//        TRANSPORTANALYST
//    }
}