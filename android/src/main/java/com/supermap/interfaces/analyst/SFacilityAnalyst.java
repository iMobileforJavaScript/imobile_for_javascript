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
import com.supermap.analyst.networkanalyst.FacilityAnalyst;
import com.supermap.analyst.networkanalyst.FacilityAnalystResult;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.data.Color;
import com.supermap.data.DatasetVector;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Action;
import com.supermap.mapping.Layer;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.Selection;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMParameter;

import java.util.Map;

public class SFacilityAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SFacilityAnalyst";
    private static SFacilityAnalyst analyst;
    private static ReactApplicationContext context;
    //    private LongPressAction longPressAction = LongPressAction.NULL;
    private Selection selection = null;
    private FacilityAnalyst facilityAnalyst = null;

    private GeoStyle getGeoStyle(Size2D size2D, Color color) {
        GeoStyle geoStyle = new GeoStyle();
        geoStyle.setMarkerSize(size2D);
        geoStyle.setLineColor(color);
        return geoStyle;
    }

    ReactContext mReactContext;

    public SFacilityAnalyst(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }


    @ReactMethod
    public void clear(Promise promise) {
        try {
            if (selection != null) {
                selection.clear();
            }
            SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer().clear();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 加载设施网络分析模型
     */
    @ReactMethod
    public void load(ReadableMap facilitySetting, Promise promise) {
        try {
            Layer layer = null;
            Map params = facilitySetting.toHashMap();
            if (params.containsKey("networkDataset")) {
                layer = SMLayer.findLayerByDatasetName((String) params.get("networkDataset"));
            } else if (params.containsKey("networkLayer")) {
                layer = SMLayer.findLayerWithName((String) params.get("networkLayer"));
            }

            if (layer != null) {
                FacilityAnalystSetting analystSetting = SMParameter.setFacilitySetting(params);
                analystSetting.setNetworkDataset((DatasetVector)layer.getDataset());

                facilityAnalyst = new FacilityAnalyst();
                facilityAnalyst.setAnalystSetting(analystSetting);
                facilityAnalyst.load();
                promise.resolve(true);
            } else {
                promise.reject(new Error("No networkDataset"));
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找这些弧段的共同上游弧段，返回弧段 ID 数组
     * @param ids
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonAncestorsFromEdges(WritableArray ids, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findCommonAncestorsFromEdges(IDs, isUncertainDirectionValid);

            displayResult(resultIDs);
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组，查找这些结点的共同上游弧段，返回弧段 ID 数组
     * @param ids
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonAncestorsFromNodes(WritableArray ids, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findCommonAncestorsFromNodes(IDs, isUncertainDirectionValid);

            displayResult(resultIDs);
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找这些弧段的共同下游弧段，返回弧段 ID 数组
     * @param ids
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonCatchmentsFromEdges(WritableArray ids, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findCommonCatchmentsFromEdges(IDs, isUncertainDirectionValid);

            displayResult(resultIDs);
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据指定的结点 ID 数组，查找这些结点的共同下游弧段，返回弧段 ID 数组
     * @param ids
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findCommonCatchmentsFromNodes(WritableArray ids, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findCommonCatchmentsFromNodes(IDs, isUncertainDirectionValid);

            displayResult(resultIDs);
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找与这些弧段相连通的弧段，返回弧段 ID 数组
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void findConnectedEdgesFromEdges(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findConnectedEdgesFromEdges(IDs);

            displayResult(resultIDs);
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组，查找与这些结点相连通弧段，返回弧段 ID 数组
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void findConnectedEdgesFromNodes(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findConnectedEdgesFromNodes(IDs);

            displayResult(resultIDs);
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组查找与这些弧段相连接的环路，返回构成环路的弧段 ID 数组
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void findLoopsFromEdges(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findLoopsFromEdges(IDs);

            displayResult(resultIDs);

            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组查找与这些结点相连接的环路，返回构成环路的弧段 ID 数组
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void findLoopsFromNodes(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] IDs = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                IDs[i] = ids.getInt(i);
            }
            int[] resultIDs = facilityAnalyst.findLoopsFromNodes(IDs);

            displayResult(resultIDs);

            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultIDs.length; i++) {
                resultArr.pushInt(resultIDs[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设施网络下游路径分析，根据给定的参与分析的弧段 ID，查询该弧段下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param ID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathDownFromEdge(int ID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            FacilityAnalystResult result = facilityAnalyst.findPathDownFromEdge(ID, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设施网络下游路径分析，根据给定的参与分析的结点 ID，查询该结点下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param ID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathDownFromNode(int ID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            FacilityAnalystResult result = facilityAnalyst.findPathDownFromNode(ID, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设施网络路径分析，即根据给定的起始和终止弧段 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param startId
     * @param endId
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathFromEdges(int startId, int endId, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            FacilityAnalystResult result = facilityAnalyst.findPathFromEdges(startId, endId, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设施网络路径分析，即根据给定的起始和终止结点 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费。
     * @param startId
     * @param endId
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathFromNodes(int startId, int endId, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

            FacilityAnalystResult result = facilityAnalyst.findPathFromNodes(startId, endId, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设施网络上游路径分析，根据给定的弧段 ID，查询该弧段上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathUpFromEdge(int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

            FacilityAnalystResult result = facilityAnalyst.findPathUpFromEdge(edgeID, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设施网络上游路径分析，根据给定的结点 ID，查询该结点上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findPathUpFromNode(int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

            FacilityAnalystResult result = facilityAnalyst.findPathUpFromNode(nodeID, weightName, isUncertainDirectionValid);


            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 查找汇，即从给定弧段出发，根据流向查找流出该弧段的下游汇点，并返回给定弧段到达该汇的最小耗费路径所包含的弧段、结点及耗费
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSinkFromEdge(int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

            FacilityAnalystResult result = facilityAnalyst.findSinkFromEdge(edgeID, weightName, isUncertainDirectionValid);


            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 查找汇，即从给定结点出发，根据流向查找流出该结点的下游汇点，并返回给定结点到达该汇的最小耗费路径所包含的弧段、结点及耗费
     * @param nodeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSinkFromNode(int nodeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

            FacilityAnalystResult result = facilityAnalyst.findSinkFromNode(nodeID, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 查找源，即从给定弧段出发，根据流向查找流向该弧段的网络源头，并返回该源到达给定弧段的最小耗费路径所包含的弧段、结点及耗费
     * @param edgeID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSourceFromEdge(int edgeID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

            FacilityAnalystResult result = facilityAnalyst.findSourceFromEdge(edgeID, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 查找源，即从给定结点出发，根据流向查找流向该结点的网络源头，并返回该源到达给定结点的最小耗费路径所包含的弧段、结点及耗费
     * @param ID
     * @param weightName
     * @param isUncertainDirectionValid
     * @param promise
     */
    @ReactMethod
    public void findSourceFromNode(int ID, String weightName, boolean isUncertainDirectionValid, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();

            FacilityAnalystResult result = facilityAnalyst.findSourceFromNode(ID, weightName, isUncertainDirectionValid);

            WritableMap map = dealResult(result);
            mapControl.setAction(Action.PAN);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 数组，查找与这些弧段不相连通的弧段，返回弧段 ID 数组
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void findUnconnectedEdgesFromEdges(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] idss = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                idss[i] = ids.getInt(i);
            }

            int[] resultID = facilityAnalyst.findUnconnectedEdgesFromNodes(idss);
            displayResult(resultID);

            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultID.length; i++) {
                resultArr.pushInt(resultID[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 数组，查找与这些结点不相连通的弧段，返回弧段 ID 数组
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void findUnconnectedEdgesFromNodes(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            int[] idss = new int[ids.size()];
            for (int i = 0; i < ids.size(); i++) {
                idss[i] = ids.getInt(i);
            }

            int[] resultID = facilityAnalyst.findUnconnectedEdgesFromNodes(idss);
            displayResult(resultID);

            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < resultID.length; i++) {
                resultArr.pushInt(resultID[i]);
            }

            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 进行下游追踪，即查找给定弧段的下游，返回下游包含的弧段、结点及总耗费
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void traceDownFromEdge(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < ids.size(); i++) {
                FacilityAnalystResult facilityAnalystResult = facilityAnalyst.traceDownFromEdge(ids.getInt(i), "length", true);
                resultArr.pushMap(dealResult(facilityAnalystResult));
            }
            displayResult();
            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 进行下游追踪，即查找给定结点的下游，返回下游包含的弧段、结点及总耗费
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void traceDownFromNode(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < ids.size(); i++) {
                FacilityAnalystResult facilityAnalystResult = facilityAnalyst.traceDownFromNode(ids.getInt(i), "length", true);
                resultArr.pushMap(dealResult(facilityAnalystResult));
            }
            displayResult();
            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的弧段 ID 进行上游追踪，即查找给定弧段的上游，返回上游包含的弧段、结点及总耗费
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void traceUpFromEdge(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < ids.size(); i++) {
                FacilityAnalystResult facilityAnalystResult = facilityAnalyst.traceUpFromEdge(ids.getInt(i), "length", true);

                resultArr.pushMap(dealResult(facilityAnalystResult));
            }
            displayResult();
            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据给定的结点 ID 进行上游追踪，即查找给定结点的上游，返回上游包含的弧段、结点及总耗费
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void traceUpFromNode(WritableArray ids, Promise promise) {
        try {
            MapControl mapControl = SMap.getInstance().getSmMapWC().getMapControl();
            WritableArray resultArr = Arguments.createArray();
            for (int i = 0; i < ids.size(); i++) {
                FacilityAnalystResult facilityAnalystResult = facilityAnalyst.traceUpFromNode(ids.getInt(i), "length", true);
                int[] resultIDs = facilityAnalystResult.getEdges();
                resultArr.pushMap(dealResult(facilityAnalystResult));
            }
            displayResult();
            mapControl.setAction(Action.PAN);
            promise.resolve(resultArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    public void displayResult() {
        if (selection != null && selection.getCount() > 0) {
            Recordset recordset = selection.toRecordset();
            recordset.moveFirst();

            while (!recordset.isEOF()) {
                Geometry geometry = recordset.getGeometry();
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
                geometry.setStyle(style);
                SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer().add(geometry, "");
                recordset.moveNext();
            }
            SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
        }
    }

    public void displayResult(int[] ids) {
        if (ids.length > 0) {
            for (int j = 0; j < ids.length; j++) {
                selection.add(ids[j]);
                Recordset recordset = selection.toRecordset();
                recordset.moveFirst();

                while (!recordset.isEOF()) {
                    Geometry geometry = recordset.getGeometry();
                    GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
                    geometry.setStyle(style);
                    SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer().add(geometry, "");
                    recordset.moveNext();
                }
                SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
            }
        }
    }

    public WritableMap dealResult(FacilityAnalystResult result) {
        int[] edges = result.getEdges();
        int[] nodes = result.getNodes();
        double cost = result.getCost();

        WritableMap map = Arguments.createMap();
        WritableArray edgess = Arguments.createArray();
        WritableArray nodess = Arguments.createArray();

        for (int j = 0; j < edges.length; j++) {
            selection.add(edges[j]);
            edgess.pushInt(edges[j]);
        }

        for (int j = 0; j < nodes.length; j++) {
            selection.add(nodes[j]);
            nodess.pushInt(nodes[j]);
        }

        map.putDouble("cost", cost);
        map.putArray("edges", edgess);
        map.putArray("nodes", nodess);

        return map;
    }

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