package com.supermap.interfaces;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.analyst.BufferAnalystGeometry;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferEndType;
import com.supermap.containts.EventConst;
import com.supermap.containts.Map3DEventConst;
import com.supermap.data.Color;
import com.supermap.data.Dataset;
import com.supermap.data.Enum;
import com.supermap.data.GeoRegion;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.map3D.AnalysisHelper;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;
import com.supermap.realspace.SceneControl;
import com.supermap.rnsupermap.JSLayer;
import com.supermap.rnsupermap.JSMap;
import com.supermap.smNative.SMSceneWC;

import java.util.Map;

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
    
}
