package com.supermap.smNative;

import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferEndType;
import com.supermap.analyst.BufferRadiusUnit;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;
import com.supermap.data.CursorType;
import com.supermap.data.QueryParameter;
import com.supermap.data.SpatialQueryMode;

import java.util.ArrayList;
import java.util.Map;

public class SMParameter {

    public static QueryParameter setQueryParameter(Map data){
        QueryParameter queryParameter=new QueryParameter();
        if (data.containsKey("attributeFilter")) {
            queryParameter.setAttributeFilter(data.get("attributeFilter").toString());
        }
        if (data.containsKey("cursorType")) {
            switch (data.get("cursorType").toString()){
                case "DYNAMIC":
                    queryParameter.setCursorType(CursorType.DYNAMIC);
                    break;
                case "STATIC":
                    queryParameter.setCursorType(CursorType.STATIC);
            }
        }
        if (data.containsKey("groupBy")) {
            ArrayList<String> resultFields=(ArrayList<String>) data.get("groupBy");
            String[] arr= new String[resultFields.size()];
            for (int i = 0; i <resultFields.size() ; i++) {
                arr[i]=resultFields.get(i);
            }
            queryParameter.setGroupBy(arr);
        }

        if (data.containsKey("hasGeometry")) {
            boolean hasGeometry= Boolean.parseBoolean(data.get("attributeFilter").toString());
            queryParameter.setHasGeometry(hasGeometry);
        }
        if (data.containsKey("orderBy")) {
            ArrayList<String> resultFields=(ArrayList<String>) data.get("orderBy");
            String[] arr= new String[resultFields.size()];
            for (int i = 0; i <resultFields.size() ; i++) {
                arr[i]=resultFields.get(i);
            }
            queryParameter.setOrderBy(arr);
        }
        if (data.containsKey("resultFields")) {
            ArrayList<String> resultFields=(ArrayList<String>) data.get("resultFields");
            String[] arr= new String[resultFields.size()];
            for (int i = 0; i <resultFields.size() ; i++) {
                arr[i]=resultFields.get(i);
            }
            queryParameter.setResultFields(arr);
        }
        if (data.containsKey("spatialQueryMode")) {
            switch (data.get("spatialQueryMode").toString()){
                case "CONTAIN":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.CONTAIN);
                    break;
                case "CROSS":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.CROSS);
                    break;
                case "DISJOINT":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.DISJOINT);
                    break;
                case "INTERSECT":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.INTERSECT);
                    break;
                case "NONE":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.NONE);
                    break;
                case "OVERLAP":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.OVERLAP);
                    break;
                case "TOUCH":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.TOUCH);
                case "WITHIN":
                    queryParameter.setSpatialQueryMode(SpatialQueryMode.WITHIN);
            }
        }
        return  queryParameter;
    }

    public static OverlayAnalystParameter setOverlayParameter(Map data){
        OverlayAnalystParameter overlayAnalystParameter =new OverlayAnalystParameter();
        if (data.containsKey("operationRetainedFields")) {
            ArrayList<String> resultFields=(ArrayList<String>) data.get("operationRetainedFields");
            String[] arr= new String[resultFields.size()];
            for (int i = 0; i <resultFields.size() ; i++) {
                arr[i]=resultFields.get(i);
            }
            overlayAnalystParameter.setOperationRetainedFields(arr);
        }
        if (data.containsKey("sourceRetainedFields")) {
            ArrayList<String> resultFields=(ArrayList<String>) data.get("sourceRetainedFields");
            String[] arr= new String[resultFields.size()];
            for (int i = 0; i <resultFields.size() ; i++) {
                arr[i]=resultFields.get(i);
            }
            overlayAnalystParameter.setSourceRetainedFields(arr);
        }
        if (data.containsKey("tolerance")) {
            double tolerance= Double.parseDouble(data.get("tolerance").toString());
            overlayAnalystParameter.setTolerance(tolerance);
        }
        return overlayAnalystParameter;
    }

    public static BufferAnalystParameter setBufferParameter(Map data){
        BufferAnalystParameter bufferAnalystParameter=new BufferAnalystParameter();
        if (data.containsKey("endType")) {
            switch (data.get("endType").toString()){
                case "FLAT":
                    bufferAnalystParameter.setEndType(BufferEndType.FLAT);
                    break;
                case"ROUND":
                    bufferAnalystParameter.setEndType(BufferEndType.ROUND);
                    break;
            }
        }
        if (data.containsKey("leftDistance")) {
            double leftDistance= Double.parseDouble(data.get("leftDistance").toString());
            bufferAnalystParameter.setLeftDistance(leftDistance);
        }
        if (data.containsKey("radiusUnit")) {
            switch (data.get("radiusUnit").toString()){
                case "CentiMeter":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.CentiMeter);
                    break;
                case "DeciMeter":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.DeciMeter);
                    break;
                case"Foot":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.Foot);
                    break;
                case"Inch":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.Inch);
                    break;
                case"KiloMeter":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.KiloMeter);
                    break;
                case"Meter":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.Meter);
                    break;
                case"Mile":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.Mile);
                    break;
                case"MiliMeter":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.MiliMeter);
                    break;
                case "Yard":
                    bufferAnalystParameter.setRadiusUnit(BufferRadiusUnit.Yard);
                    break;
            }
        }
        if (data.containsKey("rightDistance")) {
            double rightDistance= Double.parseDouble(data.get("rightDistance").toString());
            bufferAnalystParameter.setRightDistance(rightDistance);
        }
        if (data.containsKey("rightDistance")) {
            Integer semicircleLineSegment= Integer.parseInt(data.get("rightDistance").toString());
            if(semicircleLineSegment>=4){
                bufferAnalystParameter.setSemicircleLineSegment(semicircleLineSegment);
            }
        }
        return bufferAnalystParameter;
    }

    public static FacilityAnalystSetting setfacilitySetting(Map data){
        FacilityAnalystSetting facilityAnalystSetting=new FacilityAnalystSetting();
        if (data.containsKey("barrierEdges")) {
            ArrayList<Integer> barrierEdges=(ArrayList<Integer>) data.get("barrierEdges");
            int[] arr= new int[barrierEdges.size()];
            for (int i = 0; i <barrierEdges.size() ; i++) {
                arr[i]=barrierEdges.get(i);
            }
            facilityAnalystSetting.setBarrierEdges(arr);
        }
        if (data.containsKey("barrierNodes")) {
            ArrayList<Integer> barrierEdges=(ArrayList<Integer>) data.get("barrierEdges");
            int[] arr= new int[barrierEdges.size()];
            for (int i = 0; i <barrierEdges.size() ; i++) {
                arr[i]=barrierEdges.get(i);
            }
            facilityAnalystSetting.setBarrierNodes(arr);
        }
        if (data.containsKey("directionField")) {
            facilityAnalystSetting.setDirectionField(data.get("directionField").toString());
        }
        if (data.containsKey("edgeIDField")) {
            facilityAnalystSetting.setEdgeIDField(data.get("edgeIDField").toString());
        }
        if (data.containsKey("fNodeIDField")) {
            facilityAnalystSetting.setEdgeIDField(data.get("fNodeIdField").toString());
        }
        if (data.containsKey("nodeIDField")) {
            facilityAnalystSetting.setEdgeIDField(data.get("nodeIDFiled").toString());
        }
        if (data.containsKey("tNodeIDField")) {
            facilityAnalystSetting.setEdgeIDField(data.get("tNodeIDField").toString());
        }
        if (data.containsKey("tolerance")) {
            facilityAnalystSetting.setTolerance(Double.parseDouble(data.get("tolerance").toString()));
        }
        return facilityAnalystSetting;
    }

    public static TransportationAnalystParameter settransportationParameter(Map data){
        TransportationAnalystParameter transportationAnalystParameter=new TransportationAnalystParameter();
        if (data.containsKey("barrierEdges")) {
            ArrayList<Integer> barrierEdges=(ArrayList<Integer>) data.get("barrierEdges");
            int[] arr= new int[barrierEdges.size()];
            for (int i = 0; i <barrierEdges.size() ; i++) {
                arr[i]=barrierEdges.get(i);
            }
            transportationAnalystParameter.setBarrierEdges(arr);
        }
        if (data.containsKey("barrierNodes")) {
            ArrayList<Integer> barrierEdges=(ArrayList<Integer>) data.get("barrierEdges");
            int[] arr= new int[barrierEdges.size()];
            for (int i = 0; i <barrierEdges.size() ; i++) {
                arr[i]=barrierEdges.get(i);
            }
            transportationAnalystParameter.setBarrierNodes(arr);
        }
        if (data.containsKey("edgesReturn")) {
            transportationAnalystParameter.setEdgesReturn(Boolean.parseBoolean(data.get("attributeFilter").toString()));
        }
        if (data.containsKey("nodes")) {
            ArrayList<Integer> barrierEdges=(ArrayList<Integer>) data.get("nodes");
            int[] arr= new int[barrierEdges.size()];
            for (int i = 0; i <barrierEdges.size() ; i++) {
                arr[i]=barrierEdges.get(i);
            }
            transportationAnalystParameter.setNodes(arr);
        }
        if (data.containsKey("nodesReturn")) {
            transportationAnalystParameter.setNodesReturn(Boolean.parseBoolean(data.get("nodesReturn").toString()));
        }
        if (data.containsKey("pathGuidesReturn")) {
            transportationAnalystParameter.setPathGuidesReturn(Boolean.parseBoolean(data.get("pathGuidesReturn").toString()));
        }
        if (data.containsKey("routesReturn")) {
            transportationAnalystParameter.setRoutesReturn(Boolean.parseBoolean(data.get("pathGuidesReturn").toString()));
        }
        if (data.containsKey("stopIndexesReturn")) {
            transportationAnalystParameter.setStopIndexesReturn(Boolean.parseBoolean(data.get("pathGuidesReturn").toString()));
        }
        if (data.containsKey("turnWeightField")) {
            transportationAnalystParameter.setTurnWeightField(data.get("turnWeightField").toString());
        }
        if (data.containsKey("weightName")) {
            transportationAnalystParameter.setWeightName(data.get("weightName").toString());
        }
        return transportationAnalystParameter;
    }

    public static TransportationAnalystSetting settransportationSetting(Map data){
        TransportationAnalystSetting transportationAnalystSetting=new TransportationAnalystSetting();
        if (data.containsKey("barrierEdges")) {
            ArrayList<Integer> barrierEdges=(ArrayList<Integer>) data.get("barrierEdges");
            int[] arr= new int[barrierEdges.size()];
            for (int i = 0; i <barrierEdges.size() ; i++) {
                arr[i]=barrierEdges.get(i);
            }
            transportationAnalystSetting.setBarrierEdges(arr);
        }
        if (data.containsKey("barrierNodes")) {
            ArrayList<Integer> barrierEdges=(ArrayList<Integer>) data.get("barrierEdges");
            int[] arr= new int[barrierEdges.size()];
            for (int i = 0; i <barrierEdges.size() ; i++) {
                arr[i]=barrierEdges.get(i);
            }
            transportationAnalystSetting.setBarrierNodes(arr);
        }
        if (data.containsKey("edgeField")) {
            transportationAnalystSetting.setEdgeFilter(data.get("edgeField").toString());
        }
        if (data.containsKey("edgeIDField")) {
            transportationAnalystSetting.setEdgeIDField(data.get("edgeIDField").toString());
        }
        if (data.containsKey("edgeNameField")) {
            transportationAnalystSetting.setEdgeIDField(data.get("edgeNameField").toString());
        }
        if (data.containsKey("fNodeIDField")) {
            transportationAnalystSetting.setFNodeIDField(data.get("fNodeIDField").toString());
        }
        if (data.containsKey("fTSingleWayRuleValues")) {
            ArrayList<String> RuleValues=(ArrayList<String>) data.get("fTSingleWayRuleValues");
            String[] arr= new String[RuleValues.size()];
            for (int i = 0; i <RuleValues.size() ; i++) {
                arr[i]=RuleValues.get(i);
            }
            transportationAnalystSetting.setFTSingleWayRuleValues(arr);
        }
        if (data.containsKey("nodeIDField")) {
            transportationAnalystSetting.setNodeIDField(data.get("nodeIDField").toString());
        }
        if (data.containsKey("nodeNameField")) {
            transportationAnalystSetting.setNodeIDField(data.get("nodeNameField").toString());
        }
        if (data.containsKey("prohibitedWayRuleValues")) {
            ArrayList<String> RuleValues=(ArrayList<String>) data.get("prohibitedWayRuleValues");
            String[] arr= new String[RuleValues.size()];
            for (int i = 0; i <RuleValues.size() ; i++) {
                arr[i]=RuleValues.get(i);
            }
            transportationAnalystSetting.setProhibitedWayRuleValues(arr);
        }
        if (data.containsKey("ruleField")) {
            transportationAnalystSetting.setRuleField(data.get("ruleField").toString());
        }
        if (data.containsKey("tFSingleWayRuleValues")) {
            ArrayList<String> RuleValues=(ArrayList<String>) data.get("tFSingleWayRuleValues");
            String[] arr= new String[RuleValues.size()];
            for (int i = 0; i <RuleValues.size() ; i++) {
                arr[i]=RuleValues.get(i);
            }
            transportationAnalystSetting.setTFSingleWayRuleValues(arr);
        }
        if (data.containsKey("tNodeIDField")) {
            transportationAnalystSetting.setTNodeIDField(data.get("tNodeIDField").toString());
        }
        if (data.containsKey("tolerance")) {
            transportationAnalystSetting.setTolerance(Double.parseDouble(data.get("tolerance").toString()));
        }
        if (data.containsKey("turnFEdgeIDField")) {
            transportationAnalystSetting.setTurnFEdgeIDField(data.get("turnFEdgeIDField").toString());
        }
        if (data.containsKey("turnNodeIDField")) {
            transportationAnalystSetting.setTurnNodeIDField(data.get("turnNodeIDField").toString());
        }
        if (data.containsKey("turnTEdgeIDField")) {
            transportationAnalystSetting.setTurnTEdgeIDField(data.get("turnTEdgeIDField").toString());
        }
        if (data.containsKey("twoWayRuleValues")) {
            ArrayList<String> RuleValues=(ArrayList<String>) data.get("twoWayRuleValues");
            String[] arr= new String[RuleValues.size()];
            for (int i = 0; i <RuleValues.size() ; i++) {
                arr[i]=RuleValues.get(i);
            }
            transportationAnalystSetting.setTwoWayRuleValues(arr);
        }
        return transportationAnalystSetting;
    }

    public static WeightFieldInfo setweightFieldInfo(Map data){
        WeightFieldInfo weightFieldInfo=new WeightFieldInfo();
        if (data.containsKey("fTWeightField")) {
            weightFieldInfo.setFTWeightField(data.get("fTWeightField").toString());
        }
        if (data.containsKey("name")) {
            weightFieldInfo.setName(data.get("name").toString());
        }
        if (data.containsKey("tFweightField")) {
            weightFieldInfo.setTFWeightField(data.get("tFweightField").toString());
        }
        return weightFieldInfo;
    }
}
