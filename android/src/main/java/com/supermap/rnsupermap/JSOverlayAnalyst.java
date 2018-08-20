package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;
import com.supermap.data.DatasetVector;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSOverlayAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSOverlayAnalyst";
    protected static Map<String, OverlayAnalyst> m_OverlayAnalystList = new HashMap<String, OverlayAnalyst>();
    OverlayAnalyst m_OverlayAnalyst;

    public JSOverlayAnalyst(ReactApplicationContext context) {
        super(context);
    }

    public static OverlayAnalyst getObjFromList(String id) {
        return m_OverlayAnalystList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(OverlayAnalyst obj) {
        for (Map.Entry entry : m_OverlayAnalystList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_OverlayAnalystList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void clip(String datasetId, String clipDatasetId,
                     String resultDatasetId, String overlayAnalystParameterId, Promise promise) {
        try {
            DatasetVector dataset = JSDatasetVector.getObjFromList(datasetId);
            DatasetVector clipDataset = JSDatasetVector.getObjFromList(clipDatasetId);
            DatasetVector resultDataset = JSDatasetVector.getObjFromList(resultDatasetId);
            OverlayAnalystParameter overlayAnalystParameter = JSOverlayAnalystParameter.getObjFromList(overlayAnalystParameterId);
            boolean clipped = OverlayAnalyst.clip(dataset, clipDataset, resultDataset, overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putBoolean("clipped", clipped);
            promise.resolve(map);
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    @ReactMethod
    public void erase(String datasetId, String eraseDatasetId,
                      String resultDatasetId, String overlayAnalystParameterId, Promise promise) {
        try {
            DatasetVector dataset = JSDatasetVector.getObjFromList(datasetId);
            DatasetVector clipDataset = JSDatasetVector.getObjFromList(eraseDatasetId);
            DatasetVector resultDataset = JSDatasetVector.getObjFromList(resultDatasetId);
            OverlayAnalystParameter overlayAnalystParameter = JSOverlayAnalystParameter.getObjFromList(overlayAnalystParameterId);
            boolean erased = OverlayAnalyst.erase(dataset, clipDataset, resultDataset, overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putBoolean("erased", erased);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void identity(String datasetId, String identityDatasetId,
                         String resultDatasetId, String overlayAnalystParameterId, Promise promise) {
        try {
            DatasetVector dataset = JSDatasetVector.getObjFromList(datasetId);
            DatasetVector identityDataset = JSDatasetVector.getObjFromList(identityDatasetId);
            DatasetVector resultDataset = JSDatasetVector.getObjFromList(resultDatasetId);
            OverlayAnalystParameter overlayAnalystParameter = JSOverlayAnalystParameter.getObjFromList(overlayAnalystParameterId);
            boolean identified = OverlayAnalyst.erase(dataset, identityDataset, resultDataset, overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putBoolean("identified", identified);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void intersect(String datasetVectorId, String intersectDatasetVectorId,
                          String resultDatasetVectorId, String overlayAnalystParameterId, Promise promise) {
        try {
            DatasetVector dataset = JSDatasetVector.getObjFromList(datasetVectorId);
            DatasetVector intersectDataset = JSDatasetVector.getObjFromList(intersectDatasetVectorId);
            DatasetVector resultDataset = JSDatasetVector.getObjFromList(resultDatasetVectorId);
            OverlayAnalystParameter overlayAnalystParameter = JSOverlayAnalystParameter.getObjFromList(overlayAnalystParameterId);
            boolean identified = OverlayAnalyst.intersect(dataset, intersectDataset, resultDataset, overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putBoolean("intersected", identified);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void union(String datasetId, String unionDatasetId,
                      String resultDatasetId, String overlayAnalystParameterId, Promise promise) {
        try {
            DatasetVector dataset = JSDatasetVector.getObjFromList(datasetId);
            DatasetVector unionDataset = JSDatasetVector.getObjFromList(unionDatasetId);
            DatasetVector resultDataset = JSDatasetVector.getObjFromList(resultDatasetId);
            OverlayAnalystParameter overlayAnalystParameter = JSOverlayAnalystParameter.getObjFromList(overlayAnalystParameterId);
            boolean unioned = OverlayAnalyst.union(dataset, unionDataset, resultDataset, overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putBoolean("unioned", unioned);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void update(String datasetId, String updateDatasetId,
                       String resultDatasetId, String overlayAnalystParameterId, Promise promise) {
        try {
            DatasetVector dataset = JSDatasetVector.getObjFromList(datasetId);
            DatasetVector updateDataset = JSDatasetVector.getObjFromList(updateDatasetId);
            DatasetVector resultDataset = JSDatasetVector.getObjFromList(resultDatasetId);
            OverlayAnalystParameter overlayAnalystParameter = JSOverlayAnalystParameter.getObjFromList(overlayAnalystParameterId);
            boolean updated = OverlayAnalyst.update(dataset, updateDataset, resultDataset, overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putBoolean("updated", updated);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void xOR(String datasetId, String xORDatasetId,
                    String resultDatasetId, String overlayAnalystParameterId, Promise promise) {
        try {
            DatasetVector dataset = JSDatasetVector.getObjFromList(datasetId);
            DatasetVector xORDataset = JSDatasetVector.getObjFromList(xORDatasetId);
            DatasetVector resultDataset = JSDatasetVector.getObjFromList(resultDatasetId);
            OverlayAnalystParameter overlayAnalystParameter = JSOverlayAnalystParameter.getObjFromList(overlayAnalystParameterId);
            boolean finished = OverlayAnalyst.xOR(dataset, xORDataset, resultDataset, overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putBoolean("finished", finished);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}

