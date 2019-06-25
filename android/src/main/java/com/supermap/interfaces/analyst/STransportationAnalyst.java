package com.supermap.interfaces.analyst;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.analyst.networkanalyst.TransportationAnalyst;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.analyst.networkanalyst.TransportationAnalystResult;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.data.Color;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasource;
import com.supermap.data.GeoLineM;
import com.supermap.data.GeoStyle;
import com.supermap.data.Point2D;
import com.supermap.data.Size2D;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.TrackingLayer;
import com.supermap.smNative.Network_tool;
import com.supermap.smNative.SMParameter;

import java.util.ArrayList;
import java.util.Map;

public class STransportationAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "STransportationAnalyst";
    private static STransportationAnalyst analyst;
    private static ReactApplicationContext context;
    //    private LongPressAction longPressAction = LongPressAction.NULL;
    private ArrayList<Integer> m_elementIDs = null;
    private TransportationAnalyst transportationAnalyst = null;

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

    /**
     * 加载交通网络分析环境设置对象
     */
    @ReactMethod
    public void load(ReadableMap facilitySetting, ReadableMap weightFieldInfo, Promise promise) {
        try {
            Map params = facilitySetting.toHashMap();
            TransportationAnalystSetting transportationAnalystSetting = SMParameter.setTransportationSetting(params);
            Map data = weightFieldInfo.toHashMap();
            WeightFieldInfo weightFieldInfo1 = SMParameter.setWeightFieldInfo(data);
            WeightFieldInfos weightFieldInfos = new WeightFieldInfos();
            weightFieldInfos.add(weightFieldInfo1);
            transportationAnalystSetting.setWeightFieldInfos(weightFieldInfos);
            if (transportationAnalyst == null) {
                transportationAnalyst = new TransportationAnalyst();
            }
            transportationAnalyst.setAnalystSetting(transportationAnalystSetting);
            transportationAnalyst.load();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void findPath(ReadableMap transportationAnalystParameter, Promise promise) {
        try {
            Map params = transportationAnalystParameter.toHashMap();
            TransportationAnalystParameter transportationAnalystParameter1 = SMParameter.setTransportationParameter(params);
            TransportationAnalystResult analystResult = transportationAnalyst.findPath(transportationAnalystParameter1, false);
            transportationAnalystParameter1.dispose();
            boolean result = showFindPathResult(analystResult);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    public boolean showFindPathResult(TransportationAnalystResult result) {
        SMap sMap = SMap.getInstance();
        MapControl mapControl = sMap.getSmMapWC().getMapControl();
        TrackingLayer trackingLayer = mapControl.getMap().getTrackingLayer();
        int count = trackingLayer.getCount();
        for (int i = 0; i < count; i++) {
            int index = trackingLayer.indexOf("result");
            if (index != -1) {
                trackingLayer.remove(index);
            }
        }
        GeoLineM[] routes = result.getRoutes();
        if (routes == null) {
            return false;
        }
        for (int i = 0; i < routes.length; i++) {
            GeoLineM geoLineM = routes[i];
            GeoStyle style = new GeoStyle();
            style.setLineColor(new Color(225, 80, 0));
            style.setLineWidth(1);
            geoLineM.setStyle(style);
            trackingLayer.add(geoLineM, "result");
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