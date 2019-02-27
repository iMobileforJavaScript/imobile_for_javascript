package com.supermap.interfaces;

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
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;
import com.supermap.data.Color;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasource;
import com.supermap.data.EncodeType;
import com.supermap.data.Enum;
import com.supermap.data.GeoRegion;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.QueryListener;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.data.Workspace;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;
import com.supermap.rnsupermap.JSLayer;
import com.supermap.rnsupermap.JSMap;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMParameter;
import com.supermap.smNative.SMSceneWC;

import java.util.ArrayList;
import java.util.Map;
import java.util.Vector;

public class SAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SAnalyst";
    private static SAnalyst analyst;
    private static ReactApplicationContext context;
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


    @ReactMethod
    public void analystBuffer(String mapId, String layerId, ReadableMap params, Promise promise) {
        try {
            com.supermap.mapping.Map map = JSMap.getObjFromList(mapId);
            Layer layer = JSLayer.getLayer(layerId);
            Selection selection = layer.getSelection();
            Recordset recordset = selection.toRecordset();

            TrackingLayer trackingLayer = map.getTrackingLayer();

            trackingLayer.clear();
            while (!recordset.isEOF()) {

                Geometry geoForBuffer = recordset.getGeometry();
                Dataset queryDataset = recordset.getDataset();

                PrjCoordSys prjCoordSys = queryDataset.getPrjCoordSys();

                GeoStyle geoStyle = new GeoStyle();

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

                if (params.hasKey("geoStyle")) {
                    ReadableMap geoStyleMap = params.getMap("geoStyle");

                    if (geoStyleMap.hasKey("lineWidth")) {
                        geoStyle.setLineWidth(geoStyleMap.getInt("lineWidth"));
                    }
                    if (geoStyleMap.hasKey("fillForeColor")) {
                        ReadableMap fillForeColor = geoStyleMap.getMap("fillForeColor");
                        geoStyle.setFillForeColor(new Color(fillForeColor.getInt("r"), fillForeColor.getInt("g"), fillForeColor.getInt("b")));
                    }
                    if (geoStyleMap.hasKey("lineColor")) {
                        ReadableMap lineColor = geoStyleMap.getMap("lineColor");
                        geoStyle.setLineColor(new Color(lineColor.getInt("r"), lineColor.getInt("g"), lineColor.getInt("b")));
                    }
                    if (geoStyleMap.hasKey("lineSymbolID")) {
                        geoStyle.setLineSymbolID(geoStyleMap.getInt("lineSymbolID"));
                    }
                    if (geoStyleMap.hasKey("markerSymbolID")) {
                        geoStyle.setMarkerSymbolID(geoStyleMap.getInt("markerSymbolID"));
                    }
                    if (geoStyleMap.hasKey("markerSize")) {
                        ReadableMap markerSize = geoStyleMap.getMap("markerSize");
                        geoStyle.setMarkerSize(new Size2D(markerSize.getInt("w"), markerSize.getInt("h")));
                    }
                    if (geoStyleMap.hasKey("fillOpaqueRate")) {
                        geoStyle.setMarkerSymbolID(geoStyleMap.getInt("fillOpaqueRate"));
                    }
                }

                GeoRegion geoRegion = BufferAnalystGeometry.createBuffer(geoForBuffer, bufferAnalystParameter, prjCoordSys);
                geoRegion.setStyle(geoStyle);

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
     *叠加分析
     *
     */
    @ReactMethod
    public void overlayAnalyst(String datasourceName,String datasetPath,String clipDatasetPath,String analystType,ReadableMap map,Promise promise) {
        try {
            DatasetVector datasetCliped=(DatasetVector)SMLayer.findLayerByPath(datasetPath).getDataset();
            DatasetVector datasetClip=(DatasetVector)SMLayer.findLayerByPath(clipDatasetPath).getDataset();
            String resultDatasetClipName=datasetClip.getDatasource().getDatasets().getAvailableDatasetName("resultDatasetClip");
            DatasetVectorInfo datasetVectorInfoClip=new DatasetVectorInfo();
            DatasetType datasetType=datasetCliped.getType();
            datasetVectorInfoClip.setType(datasetType);
            datasetVectorInfoClip.setName(resultDatasetClipName);
            datasetVectorInfoClip.setEncodeType(EncodeType.NONE);
            DatasetVector resultDatasetClip=datasetClip.getDatasource().getDatasets().create(datasetVectorInfoClip);
            Map params=map.toHashMap();
            OverlayAnalystParameter overlayAnalystParameter=SMParameter.setOverlayParameter(params);
            Boolean result=false;
            switch (analystType){
                case "clip":
                     result=OverlayAnalyst.clip(datasetCliped,datasetClip,resultDatasetClip,overlayAnalystParameter);
                    break;
                case "erase":
                    result=OverlayAnalyst.erase(datasetCliped,datasetClip,resultDatasetClip,overlayAnalystParameter);
                    break;
                case "identity":
                    result=OverlayAnalyst.identity(datasetCliped,datasetClip,resultDatasetClip,overlayAnalystParameter);
                    break;
                case "intersect":
                    result=OverlayAnalyst.intersect(datasetCliped,datasetClip,resultDatasetClip,overlayAnalystParameter);
                    break;
                case "union":
                    result=OverlayAnalyst.union(datasetCliped,datasetClip,resultDatasetClip,overlayAnalystParameter);
                    break;
                case "updata":
                    result=OverlayAnalyst.update(datasetCliped,datasetClip,resultDatasetClip,overlayAnalystParameter);
                    break;
                case "xOR":
                    result=OverlayAnalyst.xOR(datasetCliped,datasetClip,resultDatasetClip,overlayAnalystParameter);
                    break;
            }
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     *创建矢量数据集缓冲区
     *
     */
    @ReactMethod
    public void createbuffer(String datasetPath,boolean isUnion,boolean isAttributeRetained,ReadableMap map,Promise promise) {
        try {
            DatasetVector sourceDataset= (DatasetVector)SMLayer.findLayerByPath(datasetPath).getDataset();
            String resultDatasetName=sourceDataset.getDatasource().getDatasets().getAvailableDatasetName("resultDatasetBuffer");
            DatasetVectorInfo datasetVectorInfo=new DatasetVectorInfo();
            DatasetType datasetType=sourceDataset.getType();
            datasetVectorInfo.setType(datasetType);
            datasetVectorInfo.setName(resultDatasetName);
            datasetVectorInfo.setEncodeType(EncodeType.NONE);
            DatasetVector resultDatasetBuffer=sourceDataset.getDatasource().getDatasets().create(datasetVectorInfo);
            Map params=map.toHashMap();
            BufferAnalystParameter bufferAnalystParameter=SMParameter.setBufferParameter(params);
            Boolean result=BufferAnalyst.createBuffer(sourceDataset,resultDatasetBuffer,bufferAnalystParameter,isUnion,isAttributeRetained);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createMultiBuffer(String datasetPath,ReadableArray arrBufferRadius, int bufferRadiusUnit, int semicircleSegment, Boolean isUnion, Boolean isAttributeRetained,Boolean isRing, Promise promise){
        try{
            DatasetVector sourceDataset= (DatasetVector)SMLayer.findLayerByPath(datasetPath).getDataset();
            String resultDatasetName=sourceDataset.getDatasource().getDatasets().getAvailableDatasetName("resultDatasetBuffer");
            DatasetVectorInfo datasetVectorInfo=new DatasetVectorInfo();
            DatasetType datasetType=sourceDataset.getType();
            datasetVectorInfo.setType(datasetType);
            datasetVectorInfo.setName(resultDatasetName);
            datasetVectorInfo.setEncodeType(EncodeType.NONE);
            DatasetVector resultDatasetBuffer=sourceDataset.getDatasource().getDatasets().create(datasetVectorInfo);
            BufferRadiusUnit unit = (BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class,bufferRadiusUnit);
            ArrayList listArr = arrBufferRadius.toArrayList();
            Object[] objArr = listArr.toArray();
            double[] doubleArr = new double[objArr.length];
            for (int i = 0; i<=objArr.length-1;i++){
                doubleArr[i] = (double)objArr[i];
            }
            Boolean isCreate = BufferAnalyst.createMultiBuffer(sourceDataset,resultDatasetBuffer,doubleArr,unit,semicircleSegment,isUnion,isAttributeRetained,isRing);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createLineOneSideMultiBuffer(String datasetPath,ReadableArray arrBufferRadius, int bufferRadiusUnit, int semicircleSegment, Boolean isLeft, Boolean isUnion, Boolean isAttributeRetained, Boolean isRing, Promise promise){
        try{
            DatasetVector sourceDataset= (DatasetVector)SMLayer.findLayerByPath(datasetPath).getDataset();
            String resultDatasetName=sourceDataset.getDatasource().getDatasets().getAvailableDatasetName("resultDatasetBuffer");
            DatasetVectorInfo datasetVectorInfo=new DatasetVectorInfo();
            DatasetType datasetType=sourceDataset.getType();
            datasetVectorInfo.setType(datasetType);
            datasetVectorInfo.setName(resultDatasetName);
            datasetVectorInfo.setEncodeType(EncodeType.NONE);
            DatasetVector resultDatasetBuffer=sourceDataset.getDatasource().getDatasets().create(datasetVectorInfo);
            BufferRadiusUnit unit = (BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class,bufferRadiusUnit);

            ArrayList listArr = arrBufferRadius.toArrayList();
            Object[] objArr = listArr.toArray();
            double[] doubleArr = new double[objArr.length];
            for (int i = 0; i<=objArr.length-1;i++){
                doubleArr[i] = (double)objArr[i];
            }
            Boolean isCreate = BufferAnalyst.createLineOneSideMultiBuffer(sourceDataset,resultDatasetBuffer,doubleArr,unit,semicircleSegment,isLeft,isUnion,isAttributeRetained,isRing);
            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }


    /**
     *对矢量数据集进行查询
     *
     */
    public Recordset query(String datasetPath,Object includeObj,ReadableMap map) {
            DatasetVector datasetVector= (DatasetVector)SMLayer.findLayerByPath(datasetPath).getDataset();
            Map params=map.toHashMap();
            QueryParameter queryParameter=SMParameter.setQueryParameter(params);
            if(includeObj!=null){
                queryParameter.setSpatialQueryObject(includeObj);
            }
            Recordset recordset=datasetVector.query(queryParameter);
            return recordset;
    }


    /**
     *加载设施网络分析模型
     *
     */
    public boolean loadModel(DatasetVector datasetVector,ReadableMap facilitySetting,ReadableMap weightFieldInfo){
        Map params=facilitySetting.toHashMap();
        FacilityAnalystSetting analystSetting=SMParameter.setfacilitySetting(params);
        analystSetting.setNetworkDataset(datasetVector);
        Map data=weightFieldInfo.toHashMap();
        WeightFieldInfo weightFieldInfo1=SMParameter.setweightFieldInfo(data);
        WeightFieldInfos weightFieldInfos=new WeightFieldInfos();
        weightFieldInfos.add(weightFieldInfo1);
        FacilityAnalyst facilityAnalyst=new FacilityAnalyst();
        facilityAnalyst.setAnalystSetting(analystSetting);
        return  facilityAnalyst.load();
    }
}
