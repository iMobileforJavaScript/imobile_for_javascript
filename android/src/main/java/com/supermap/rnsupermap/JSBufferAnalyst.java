package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.supermap.analyst.BufferAnalyst;
import com.supermap.analyst.BufferAnalystGeometry;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferEndType;
import com.supermap.analyst.BufferRadiusUnit;
import com.supermap.data.Color;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.data.GeoRegion;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/22.
 */

public class JSBufferAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSBufferAnalyst";
    protected static Map<String, BufferAnalyst> m_BufferAnalystList = new HashMap<String, BufferAnalyst>();
    BufferAnalyst m_BufferAnalyst;

    public JSBufferAnalyst(ReactApplicationContext context) {
        super(context);
    }

    public static BufferAnalyst getObjFromList(String id) {
        return m_BufferAnalystList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void createBuffer(String sourceDatasetId, String resultDatasetId,
                             String bufferAnalystParamId, Boolean isUnion, Boolean isAttributeRetained, Promise promise){
        try{
            DatasetVector source = JSDatasetVector.getObjFromList(sourceDatasetId);
            DatasetVector result = JSDatasetVector.getObjFromList(resultDatasetId);
            BufferAnalystParameter bufferAnalystPara = JSBufferAnalystParameter.getObjFromList(bufferAnalystParamId);

            Boolean isCreate = BufferAnalyst.createBuffer(source,result,bufferAnalystPara,isUnion,isAttributeRetained);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createLineOneSideMultiBuffer(String sourceDatasetId, String resultDatasetId,
                                             ReadableArray arrBufferRadius, int bufferRadiusUnit, int semicircleSegment, Boolean isLeft, Boolean isUnion, Boolean isAttributeRetained, Boolean isRing, Promise promise){
        try{
            DatasetVector source = JSDatasetVector.getObjFromList(sourceDatasetId);
            DatasetVector result = JSDatasetVector.getObjFromList(resultDatasetId);
            BufferRadiusUnit unit = (BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class,bufferRadiusUnit);

            ArrayList listArr = arrBufferRadius.toArrayList();
            Object[] objArr = listArr.toArray();
            double[] doubleArr = new double[objArr.length];
            for (int i = 0; i<=objArr.length-1;i++){
                doubleArr[i] = (double)objArr[i];
            }
            Boolean isCreate = BufferAnalyst.createLineOneSideMultiBuffer(source,result,doubleArr,unit,semicircleSegment,isLeft,isUnion,isAttributeRetained,isRing);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createMultiBuffer(String sourceDatasetId, String resultDatasetId,
                                  ReadableArray arrBufferRadius, int bufferRadiusUnit, int semicircleSegment, Boolean isUnion, Boolean isAttributeRetained,Boolean isRing, Promise promise){
        try{
            DatasetVector source = JSDatasetVector.getObjFromList(sourceDatasetId);
            DatasetVector result = JSDatasetVector.getObjFromList(resultDatasetId);
            BufferRadiusUnit unit = (BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class,bufferRadiusUnit);

            ArrayList listArr = arrBufferRadius.toArrayList();
            Object[] objArr = listArr.toArray();
            double[] doubleArr = new double[objArr.length];
            for (int i = 0; i<=objArr.length-1;i++){
                doubleArr[i] = (double)objArr[i];
            }
            Boolean isCreate = BufferAnalyst.createMultiBuffer(source,result,doubleArr,unit,semicircleSegment,isUnion,isAttributeRetained,isRing);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isCreate",isCreate);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void analyst(String mapId, String layerId, ReadableMap params, Promise promise){
        try{
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
        }catch (Exception e){
            e.printStackTrace();
            promise.reject(e);
        }
    }
}
