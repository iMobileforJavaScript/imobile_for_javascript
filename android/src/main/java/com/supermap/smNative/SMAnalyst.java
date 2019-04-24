package com.supermap.smNative;

import com.facebook.react.bridge.ReadableMap;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferEndType;
import com.supermap.analyst.BufferRadiusUnit;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;
import com.supermap.data.Color;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasource;
import com.supermap.data.Datasources;
import com.supermap.data.EncodeType;
import com.supermap.data.GeoStyle;
import com.supermap.data.QueryParameter;
import com.supermap.data.Size2D;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.Map;

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
        Datasources datasources = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources();
        Datasource datasource = null;

        if (dic != null) {
            if (dic.hasKey("datasource")) {
                String alias = dic.getString("datasource");
                datasource = datasources.get(alias);
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
                if (datasource != null && dic.hasKey("dataset")) {
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
                    info.setName(dic.getString("dataset"));

                    dataset = datasource.getDatasets().create(info);
                }
            }
        }
        return dataset;
    }

    public static GeoStyle getGeoStyleByDictionary(ReadableMap geoStyleDic) {
        GeoStyle geoStyle = new GeoStyle();
        if (geoStyleDic != null) {
            if (geoStyleDic.hasKey("lineWidth")) {
                geoStyle.setLineWidth(geoStyleDic.getInt("lineWidth"));
            }
            if (geoStyleDic.hasKey("fillForeColor")) {
                ReadableMap fillForeColor = geoStyleDic.getMap("fillForeColor");
                geoStyle.setFillForeColor(new Color(fillForeColor.getInt("r"), fillForeColor.getInt("g"), fillForeColor.getInt("b")));
            }
            if (geoStyleDic.hasKey("lineColor")) {
                ReadableMap lineColor = geoStyleDic.getMap("lineColor");
                geoStyle.setLineColor(new Color(lineColor.getInt("r"), lineColor.getInt("g"), lineColor.getInt("b")));
            }
            if (geoStyleDic.hasKey("lineSymbolID")) {
                geoStyle.setLineSymbolID(geoStyleDic.getInt("lineSymbolID"));
            }
            if (geoStyleDic.hasKey("markerSymbolID")) {
                geoStyle.setMarkerSymbolID(geoStyleDic.getInt("markerSymbolID"));
            }
            if (geoStyleDic.hasKey("markerSize")) {
                ReadableMap markerSize = geoStyleDic.getMap("markerSize");
                geoStyle.setMarkerSize(new Size2D(markerSize.getInt("w"), markerSize.getInt("h")));
            }
            if (geoStyleDic.hasKey("fillOpaqueRate")) {
                geoStyle.setMarkerSymbolID(geoStyleDic.getInt("fillOpaqueRate"));
            }
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
                bufferAnalystParameter.setLeftDistance(parameter.getDouble("rightDistance"));
            }
            if (parameter.hasKey("semicircleSegments")) {
                bufferAnalystParameter.setLeftDistance(parameter.getInt("semicircleSegments"));
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
            resultDataset = SMAnalyst.createDatasetByDictionary(resultData);
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
        int dsIndex = ds.getDatasets().indexOf(resultData.getString("dataset"));
        if (dsIndex >= 0) {
            ds.getDatasets().delete(dsIndex);
        }
    }
}
