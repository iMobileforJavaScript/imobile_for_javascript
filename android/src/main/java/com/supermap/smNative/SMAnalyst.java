package com.supermap.smNative;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.RNUtils.DataUtil;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferEndType;
import com.supermap.analyst.BufferRadiusUnit;
import com.supermap.analyst.networkanalyst.FacilityAnalystSetting;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.analyst.spatialanalyst.InterpolationAlgorithmType;
import com.supermap.analyst.spatialanalyst.InterpolationDensityParameter;
import com.supermap.analyst.spatialanalyst.InterpolationIDWParameter;
import com.supermap.analyst.spatialanalyst.InterpolationKrigingParameter;
import com.supermap.analyst.spatialanalyst.InterpolationParameter;
import com.supermap.analyst.spatialanalyst.InterpolationRBFParameter;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;
import com.supermap.analyst.spatialanalyst.SearchMode;
import com.supermap.data.Color;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.EncodeType;
import com.supermap.data.Enum;
import com.supermap.data.GeoStyle;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.QueryParameter;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Size2D;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.Map;

import org.json.JSONObject;

/**
  @Author: shanglongyang
  Date:        2019/4/24
  project:     iTablet
  package:     iTablet
  class:
  description:
*/
public class SMAnalyst {
    public static Layer displayResult(Dataset ds, GeoStyle style) {
        Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
        Layer layer = map.getLayers().add(ds, true);

        if (style != null) {
            ((LayerSettingVector)layer.getAdditionalSetting()).setStyle(style);
        }

        map.refresh();
        return layer;
    }

    public static Datasource getDatasourceByDictionary(ReadableMap dic) {
        return getDatasourceByDictionary(dic, false);
    }

    public static Datasource getDatasourceByDictionary(ReadableMap dic, boolean createNew) {
        Datasources datasources = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources();
        Datasource datasource = null;

        if (dic != null) {
            if (dic.hasKey("datasource")) {
                String alias = dic.getString("datasource");
                datasource = datasources.get(alias);
                if (datasource == null && createNew) {
                    Workspace workspace = SMap.getSMWorkspace().getWorkspace();
                    DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(dic.toHashMap());

                    datasource = workspace.getDatasources().open(info);
                }
            }
        }
        return datasource;
    }

    public static Dataset getDatasetByDictionary(ReadableMap dic) {
        Dataset dataset = null;
        Datasources datasources = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources();
        Datasource datasource = null;

        if (dic != null) {
            if (dic.hasKey("datasource")) {
                String alias = dic.getString("datasource");
                datasource = datasources.get(alias);
                if (datasource != null && dic.hasKey("dataset")) {
                    dataset = datasource.getDatasets().get(dic.getString("dataset"));
                }
            }
        }
        return dataset;
    }

    public static Dataset createDatasetByDictionary(ReadableMap dic) {
        Dataset dataset = null;
        Datasources datasources = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources();
        Datasource datasource = null;

        if (dic != null) {
            if (dic.hasKey("datasource")) {
                String alias = dic.getString("datasource");
                datasource = datasources.get(alias);
                if (datasource == null) {
                    Workspace workspace = SMap.getSMWorkspace().getWorkspace();
                    DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(dic.toHashMap());

                    datasource = workspace.getDatasources().open(info);
                }
                if (datasource != null && dic.hasKey("dataset")) {
                    String datasetName = dic.getString("dataset");
                    datasetName = datasource.getDatasets().getAvailableDatasetName(datasetName);
//                    if (datasource.getDatasets().contains(datasetName)) {
//                        throw new RuntimeException("dataset is exist");
//                    }

                    DatasetType datasetType = DatasetType.REGION;

                    if (dic.hasKey("datasetType")) {
                        int type = dic.getInt("datasetType");
                        if (type == DatasetType.POINT.value()) {
                            datasetType = DatasetType.POINT;
                        } else if (type == DatasetType.LINE.value()) {
                            datasetType = DatasetType.LINE;
                        } else if (type == DatasetType.GRID.value()) {
                            datasetType = DatasetType.GRID;
                        } else if (type == DatasetType.TEXT.value()) {
                            datasetType = DatasetType.TEXT;
                        } else if (type == DatasetType.IMAGE.value()) {
                            datasetType = DatasetType.IMAGE;
//                        } else if (type == DatasetType.REGION.value()) {
                        } else {
                            datasetType = DatasetType.REGION;
                        }
                    }

                    EncodeType encodeType = EncodeType.NONE;
                    if (dic.hasKey("encodeType")) {
                        int type = dic.getInt("encodeType");
                        if (type == EncodeType.LZW.value()) {
                            encodeType = EncodeType.LZW;
                        } else if (type == EncodeType.BYTE.value()) {
                            encodeType = EncodeType.BYTE;
                        } else if (type == EncodeType.INT16.value()) {
                            encodeType = EncodeType.INT16;
                        } else if (type == EncodeType.INT24.value()) {
                            encodeType = EncodeType.INT24;
                        } else if (type == EncodeType.INT32.value()) {
                            encodeType = EncodeType.INT32;
                        } else if (type == EncodeType.DCT.value()) {
                            encodeType = EncodeType.DCT;
                        } else if (type == EncodeType.SGL.value()) {
                            encodeType = EncodeType.SGL;
                        } else {
                            encodeType = EncodeType.NONE;
                        }
                    }

                    DatasetVectorInfo info = new DatasetVectorInfo();
                    info.setType(datasetType);
                    info.setEncodeType(encodeType);
                    info.setName(datasetName);

                    dataset = datasource.getDatasets().create(info);
                }
            }
        }
        return dataset;
    }

    public static GeoStyle getGeoStyleByDictionary(ReadableMap geoStyleDic) {
        GeoStyle geoStyle = new GeoStyle();
        if (geoStyleDic != null) {
            JSONObject jsonObject = new JSONObject(geoStyleDic.toHashMap());
            geoStyle.fromJson(jsonObject.toString());
//            if (geoStyleDic.hasKey("lineWidth")) {
//                geoStyle.setLineWidth(geoStyleDic.getInt("lineWidth"));
//            }
//            if (geoStyleDic.hasKey("fillForeColor")) {
//                ReadableMap fillForeColor = geoStyleDic.getMap("fillForeColor");
//                geoStyle.setFillForeColor(new Color(fillForeColor.getInt("r"), fillForeColor.getInt("g"), fillForeColor.getInt("b")));
//            }
//            if (geoStyleDic.hasKey("lineColor")) {
//                ReadableMap lineColor = geoStyleDic.getMap("lineColor");
//                geoStyle.setLineColor(new Color(lineColor.getInt("r"), lineColor.getInt("g"), lineColor.getInt("b")));
//            }
//            if (geoStyleDic.hasKey("lineSymbolID")) {
//                geoStyle.setLineSymbolID(geoStyleDic.getInt("lineSymbolID"));
//            }
//            if (geoStyleDic.hasKey("markerSymbolID")) {
//                geoStyle.setMarkerSymbolID(geoStyleDic.getInt("markerSymbolID"));
//            }
//            if (geoStyleDic.hasKey("markerSize")) {
//                ReadableMap markerSize = geoStyleDic.getMap("markerSize");
//                geoStyle.setMarkerSize(new Size2D(markerSize.getInt("w"), markerSize.getInt("h")));
//            }
//            if (geoStyleDic.hasKey("fillOpaqueRate")) {
//                geoStyle.setMarkerSymbolID(geoStyleDic.getInt("fillOpaqueRate"));
//            }
        } else {
            geoStyle.setLineColor(new Color(0, 100, 255));
            geoStyle.setFillForeColor(new Color(0, 100, 255));
            geoStyle.setMarkerSize(new Size2D(5, 5));
        }

        return geoStyle;
    }

    public static BufferAnalystParameter getBufferAnalystParameterByDictionary(ReadableMap parameter) {
        BufferAnalystParameter bufferAnalystParameter = null;
        if (parameter != null) {
            bufferAnalystParameter = new BufferAnalystParameter();
            if (parameter.hasKey("endType")) {
                int endType = parameter.getInt("endType");
                if (endType == BufferEndType.FLAT.value()) {
                    bufferAnalystParameter.setEndType(BufferEndType.FLAT);
                } else {
                    bufferAnalystParameter.setEndType(BufferEndType.ROUND);
                }
            }
            if (parameter.hasKey("leftDistance")) {
                bufferAnalystParameter.setLeftDistance(parameter.getDouble("leftDistance"));
            }
            if (parameter.hasKey("rightDistance")) {
                bufferAnalystParameter.setRightDistance(parameter.getDouble("rightDistance"));
            }
            if (parameter.hasKey("semicircleSegments")) {
                bufferAnalystParameter.setSemicircleLineSegment(parameter.getInt("semicircleSegments"));
            }
        }

        return bufferAnalystParameter;
    }

    public static BufferRadiusUnit getBufferRadiusUnit(String unitStr) {
        if (unitStr.equals("MiliMeter")) {
            return BufferRadiusUnit.MiliMeter;
        } else if (unitStr.equals("CentiMeter")) {
            return BufferRadiusUnit.CentiMeter;
        } else if (unitStr.equals("DeciMeter")) {
            return BufferRadiusUnit.DeciMeter;
        } else if (unitStr.equals("KiloMeter")) {
            return BufferRadiusUnit.KiloMeter;
        } else if (unitStr.equals("Yard")) {
            return BufferRadiusUnit.Yard;
        } else if (unitStr.equals("Inch")) {
            return BufferRadiusUnit.Inch;
        } else if (unitStr.equals("Foot")) {
            return BufferRadiusUnit.Foot;
        } else if (unitStr.equals("Mile")) {
            return BufferRadiusUnit.Mile;
        } else {
            return BufferRadiusUnit.Meter;
        }
    }

    public static boolean overlayerAnalystWithType(String type, ReadableMap sourceData, ReadableMap targetData, ReadableMap resultData, ReadableMap optionParameter) {
        Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
        if (map.getWorkspace() == null || map.getWorkspace() != SMap.getInstance().getSmMapWC().getWorkspace()) {
            map.setWorkspace(SMap.getInstance().getSmMapWC().getWorkspace());
        }

        Dataset sourceDataset = SMAnalyst.getDatasetByDictionary(sourceData);
        Dataset targetDataset = SMAnalyst.getDatasetByDictionary(targetData);
        Dataset resultDataset = null;

        if (resultData.hasKey("dataset")) {
           try {
               resultDataset = SMAnalyst.createDatasetByDictionary(resultData);
           } catch (Exception e) {
               throw e;
           }
        }

        boolean result = false;
        OverlayAnalystParameter parameter = new OverlayAnalystParameter();
        parameter.setTolerance(0.001);

        if (sourceDataset != null && targetDataset != null && resultDataset != null) {
            if (type.equals("clip")) {
                result = OverlayAnalyst.clip((DatasetVector) sourceDataset, (DatasetVector) targetDataset, (DatasetVector) resultDataset, parameter);
            } else if (type.equals("erase")) {
                result = OverlayAnalyst.erase((DatasetVector) sourceDataset, (DatasetVector) targetDataset, (DatasetVector) resultDataset, parameter);
            } else if (type.equals("identity")) {
                result = OverlayAnalyst.identity((DatasetVector) sourceDataset, (DatasetVector) targetDataset, (DatasetVector) resultDataset, parameter);
            } else if (type.equals("intersect")) {
                result = OverlayAnalyst.intersect((DatasetVector) sourceDataset, (DatasetVector) targetDataset, (DatasetVector) resultDataset, parameter);
            } else if (type.equals("union")) {
                result = OverlayAnalyst.union((DatasetVector) sourceDataset, (DatasetVector) targetDataset, (DatasetVector) resultDataset, parameter);
            } else if (type.equals("update")) {
                result = OverlayAnalyst.update((DatasetVector) sourceDataset, (DatasetVector) targetDataset, (DatasetVector) resultDataset, parameter);
            } else if (type.equals("xOR")) {
                result = OverlayAnalyst.xOR((DatasetVector) sourceDataset, (DatasetVector) targetDataset, (DatasetVector) resultDataset, parameter);
            } else {
                return false;
            }
        }

        if (result) {
            boolean showResult = false;
            if (optionParameter.hasKey("showResult")) {
                showResult = optionParameter.getBoolean("showResult");
            }

            GeoStyle geoStyle = null;
            if (optionParameter.hasKey("geoStyle")) {
                ReadableMap geoStyleDic = optionParameter.getMap("geoStyle");
                geoStyle = SMAnalyst.getGeoStyleByDictionary(geoStyleDic);
                if (geoStyle != null) {
                    resultDataset.setDescription("{\"geoStyle\":" + geoStyle.toJson() + "}");
                }
            }

            if (showResult) {
                SMAnalyst.displayResult(resultDataset, geoStyle);
            }
        } else {
            // 分析失败，删除结果数据集
            SMAnalyst.deleteDataset(resultData);
        }

        return result;
    }

    public static void deleteDataset(ReadableMap resultData) {
        Datasource ds = SMAnalyst.getDatasourceByDictionary(resultData);
        if (ds != null) {
            int dsIndex = ds.getDatasets().indexOf(resultData.getString("dataset"));
            if (dsIndex >= 0) {
                ds.getDatasets().delete(dsIndex);
            }
        }
    }

    public static WeightFieldInfo setWeightFieldInfo(ReadableMap data) {
        WeightFieldInfo info = new WeightFieldInfo();
        if (data.hasKey("name")) {
            String name = data.getString("name");
            info.setName(name);
        }
        if (data.hasKey("ftWeightField")) {
            String ftWeightField = data.getString("ftWeightField");
            info.setFTWeightField(ftWeightField);
        }
        if (data.hasKey("tfWeightField")) {
            String tfWeightField = data.getString("tfWeightField");
            info.setTFWeightField(tfWeightField);
        }
        return info;
    }

    public static FacilityAnalystSetting setFacilitySetting(ReadableMap data) {
        FacilityAnalystSetting setting = new FacilityAnalystSetting();
        if (data.hasKey("weightFieldInfos")) {
            ReadableArray infos = data.getArray("weightFieldInfos");
            WeightFieldInfos weightFieldInfos = new WeightFieldInfos();
            for (int i = 0; i < infos.size(); i++) {
                WeightFieldInfo info = setWeightFieldInfo(infos.getMap(i));
                weightFieldInfos.add(info);
            }
            setting.setWeightFieldInfos(weightFieldInfos);
        }

        if (data.hasKey("barrierEdges")) {
            ReadableArray barrierEdges = data.getArray("barrierEdges");
            setting.setBarrierEdges(DataUtil.rnArrayToIntArray(barrierEdges));
        }

        if (data.hasKey("barrierNodes")) {
            ReadableArray barrierNodes = data.getArray("barrierNodes");
            setting.setBarrierNodes(DataUtil.rnArrayToIntArray(barrierNodes));
        }

        if (data.hasKey("directionField")) setting.setDirectionField(data.getString("directionField"));
        if (data.hasKey("edgeIDField")) setting.setEdgeIDField(data.getString("edgeIDField"));

        if (data.hasKey("fNodeIDField")) setting.setFNodeIDField(data.getString("fNodeIDField"));
        if (data.hasKey("nodeIDField")) setting.setNodeIDField(data.getString("nodeIDField"));
        if (data.hasKey("tNodeIDField")) setting.setTNodeIDField(data.getString("tNodeIDField"));
        if (data.hasKey("tolerance")) setting.setTolerance(data.getDouble("tolerance"));

        return setting;
    }

    public static TransportationAnalystSetting setTransportSetting(ReadableMap data) {
        TransportationAnalystSetting setting = new TransportationAnalystSetting();
        if (data.hasKey("weightFieldInfos")) {
            ReadableArray infos = data.getArray("weightFieldInfos");
            WeightFieldInfos weightFieldInfos = new WeightFieldInfos();
            for (int i = 0; i < infos.size(); i++) {
                WeightFieldInfo info = setWeightFieldInfo(infos.getMap(i));
                weightFieldInfos.add(info);
            }
            setting.setWeightFieldInfos(weightFieldInfos);
        }

        if (data.hasKey("barrierEdges")) {
            ReadableArray barrierEdges = data.getArray("barrierEdges");
            setting.setBarrierEdges(DataUtil.rnArrayToIntArray(barrierEdges));
        }

        if (data.hasKey("barrierNodes")) {
            ReadableArray barrierNodes = data.getArray("barrierNodes");
            setting.setBarrierNodes(DataUtil.rnArrayToIntArray(barrierNodes));
        }

        if (data.hasKey("edgeFilter")) setting.setEdgeFilter(data.getString("edgeFilter"));
        if (data.hasKey("edgeIDField")) setting.setEdgeIDField(data.getString("edgeIDField"));
        if (data.hasKey("edgeNameField")) setting.setEdgeNameField(data.getString("edgeNameField"));
        if (data.hasKey("fTSingleWayRuleValues")) {
            ReadableArray fTSingleWayRuleValues = data.getArray("fTSingleWayRuleValues");
            setting.setFTSingleWayRuleValues(DataUtil.rnArrayToStringArray(fTSingleWayRuleValues));
        }

        if (data.hasKey("fNodeIDField")) setting.setFNodeIDField(data.getString("fNodeIDField"));
        if (data.hasKey("nodeIDField")) setting.setNodeIDField(data.getString("nodeIDField"));
        if (data.hasKey("nodeNameField")) setting.setNodeNameField(data.getString("nodeNameField"));
        if (data.hasKey("prohibitedWayRuleValues")) {
            ReadableArray prohibitedWayRuleValues = data.getArray("prohibitedWayRuleValues");
            setting.setFTSingleWayRuleValues(DataUtil.rnArrayToStringArray(prohibitedWayRuleValues));
        }

        if (data.hasKey("ruleField")) setting.setRuleField(data.getString("ruleField"));
        if (data.hasKey("tFSingleWayRuleValues")) {
            ReadableArray tFSingleWayRuleValues = data.getArray("tFSingleWayRuleValues");
            setting.setFTSingleWayRuleValues(DataUtil.rnArrayToStringArray(tFSingleWayRuleValues));
        }
        if (data.hasKey("tNodeIDField")) setting.setTNodeIDField(data.getString("tNodeIDField"));
        if (data.hasKey("tolerance")) setting.setTolerance(data.getDouble("tolerance"));
        if (data.hasKey("turnFEdgeIDField")) setting.setTurnFEdgeIDField(data.getString("turnFEdgeIDField"));
        if (data.hasKey("turnNodeIDField")) setting.setTurnNodeIDField(data.getString("turnNodeIDField"));
        if (data.hasKey("turnTEdgeIDField")) setting.setTurnTEdgeIDField(data.getString("turnTEdgeIDField"));

        if (data.hasKey("turnWeightFields")) {
            ReadableArray turnWeightFields = data.getArray("turnWeightFields");
            setting.setFTSingleWayRuleValues(DataUtil.rnArrayToStringArray(turnWeightFields));
        }
        if (data.hasKey("twoWayRuleValues")) {
            ReadableArray twoWayRuleValues = data.getArray("twoWayRuleValues");
            setting.setFTSingleWayRuleValues(DataUtil.rnArrayToStringArray(twoWayRuleValues));
        }

//        if (data.hasKey("turnDataset")) setting.setTurnDataset(data.getString("turnDataset"));

        return setting;
    }

    public static TransportationAnalystParameter getTransportationAnalystParameterByDictionary(ReadableMap data) {
        TransportationAnalystParameter parameter = new TransportationAnalystParameter();

        if (data.hasKey("barrierEdges")) {
            ReadableArray barrierEdges = data.getArray("barrierEdges");
            parameter.setBarrierEdges(DataUtil.rnArrayToIntArray(barrierEdges));
        }

        if (data.hasKey("barrierNodes")) {
            ReadableArray barrierNodes = data.getArray("barrierNodes");
            parameter.setBarrierNodes(DataUtil.rnArrayToIntArray(barrierNodes));
        }

        if (data.hasKey("barrierPoints")) {
            ReadableArray barrierPoints = data.getArray("barrierPoints");
            Point2Ds point2Ds = new Point2Ds();
            for (int i = 0; i < barrierPoints.size(); i++) {
                ReadableMap p = barrierPoints.getMap(i);
                double x = p.getDouble("x");
                double y = p.getDouble("y");
                point2Ds.add(new Point2D(x, y));
            }
            parameter.setBarrierPoints(point2Ds);
        }

        if (data.hasKey("isEdgesReturn")) {
            parameter.setEdgesReturn(data.getBoolean("isEdgesReturn"));
        } else {
            parameter.setEdgesReturn(true);
        }
        if (data.hasKey("nodes")) {
            ReadableArray nodes = data.getArray("nodes");
            parameter.setNodes(DataUtil.rnArrayToIntArray(nodes));
        }

        if (data.hasKey("isNodesReturn")) {
            parameter.setNodesReturn(data.getBoolean("isNodesReturn"));
        } else {
            parameter.setNodesReturn(true);
        }
        if (data.hasKey("isPathGuidesReturn")) {
            parameter.setPathGuidesReturn(data.getBoolean("isPathGuidesReturn"));
        } else {
            parameter.setPathGuidesReturn(true);
        }

        if (data.hasKey("points")) {
            ReadableArray points = data.getArray("points");
            Point2Ds point2Ds = new Point2Ds();
            for (int i = 0; i < points.size(); i++) {
                ReadableMap p = points.getMap(i);
                double x = p.getDouble("x");
                double y = p.getDouble("y");
                point2Ds.add(new Point2D(x, y));
            }
            parameter.setPoints(point2Ds);
        }
        if (data.hasKey("isRoutesReturn")) {
            parameter.setRoutesReturn(data.getBoolean("isRoutesReturn"));
        } else {
            parameter.setRoutesReturn(true);
        }
        if (data.hasKey("isStopsReturn")) parameter.setStopIndexesReturn(data.getBoolean("isStopsReturn"));
        if (data.hasKey("turnWeightField")) parameter.setTurnWeightField(data.getString("turnWeightField"));
        if (data.hasKey("weightName")) parameter.setWeightName(data.getString("weightName"));

        return parameter;
    }

    public static InterpolationParameter getInterpolationParameter(ReadableMap data) {
        InterpolationParameter parameter = null;

        if (data.hasKey("type")) {
            int type = data.getInt("type");
            if (type == InterpolationAlgorithmType.IDW.value()) {
                parameter = new InterpolationIDWParameter();
            } else if (type == InterpolationAlgorithmType.RBF.value()) {
                parameter = new InterpolationRBFParameter();
            } else if (type == InterpolationAlgorithmType.DENSITY.value()) {
                parameter = new InterpolationDensityParameter();
            } else if (
                    type == InterpolationAlgorithmType.KRIGING.value() ||
                    type == InterpolationAlgorithmType.SimpleKRIGING.value() ||
                    type == InterpolationAlgorithmType.UniversalKRIGING.value()
                    ) {
                parameter = new InterpolationKrigingParameter();
            }
        }

        if (parameter != null) {
            if (data.hasKey("resolution")) {
                double resolution = data.getDouble("resolution");
                parameter.setResolution(resolution);
            }
            if (data.hasKey("searchMode")) {
                int searchMode = data.getInt("searchMode");
                SearchMode mode = (SearchMode)Enum.parse(SearchMode.class, searchMode);
                parameter.setSearchMode(mode);
            }
            if (data.hasKey("searchRadius")) {
                double searchRadius = data.getDouble("searchRadius");
                parameter.setSearchRadius(searchRadius);
            }
            if (data.hasKey("expectedCount")) {
                int expectedCount = data.getInt("expectedCount");
                parameter.setExpectedCount(expectedCount);
            }

            if (data.hasKey("bounds")) {
                ReadableMap bounds = data.getMap("bounds");
                Rectangle2D rectangle2D = new Rectangle2D(
                        bounds.getDouble("left"), bounds.getDouble("bottom"),
                        bounds.getDouble("right"), bounds.getDouble("top"));
                parameter.setBounds(rectangle2D);
            }

            if (data.hasKey("maxPointCountForInterpolation")) {
                int maxPointCountForInterpolation = data.getInt("maxPointCountForInterpolation");
                parameter.setMaxPointCountForInterpolation(maxPointCountForInterpolation);
            }
            if (data.hasKey("maxPointCountInNode")) {
                int maxPointCountInNode = data.getInt("maxPointCountInNode");
                parameter.setMaxPointCountInNode(maxPointCountInNode);
            }
        }

        return parameter;
    }
}
