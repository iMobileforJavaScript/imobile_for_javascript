package com.supermap.smNative;

import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.*;

public class SMCartography {

    /**
     * 根据文本对齐中文返回文本对齐类型
     * @param alignmentText
     * @return
     */
    public static TextAlignment getTextAlignment(String alignmentText){
        switch (alignmentText) {
            case "TOPLEFT":
                return TextAlignment.TOPLEFT;
            case "TOPCENTER":
                return TextAlignment.TOPCENTER;
            case "TOPRIGHT":
                return TextAlignment.TOPRIGHT;
            case "BASELINELEFT":
                return TextAlignment.BASELINELEFT;
            case "BASELINECENTER":
                return TextAlignment.BASELINECENTER;
            case "BASELINERIGHT":
                return TextAlignment.BASELINERIGHT;
            case "BOTTOMLEFT":
                return TextAlignment.BOTTOMLEFT;
            case "BOTTOMCENTER":
                return TextAlignment.BOTTOMCENTER;
            case "BOTTOMRIGHT":
                return TextAlignment.BOTTOMRIGHT;
            case "MIDDLELEFT":
                return TextAlignment.MIDDLELEFT;
            case "MIDDLECENTER":
                return TextAlignment.MIDDLECENTER;
            case "MIDDLERIGHT":
                return TextAlignment.MIDDLERIGHT;
            default:
                return null;
        }
    }

    public static Geometry getGeoText(Recordset recordset) {
        try {
            if (recordset != null && recordset.getRecordCount() > 0) {
                recordset.moveFirst();
                Geometry geometry = recordset.getGeometry();
                if (geometry.getType() == GeometryType.GEOTEXT) {
                    return geometry;
                }
            }

            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Recordset getRecordset(int geometryID, String layerName) {
        try {
            Layers layers = SMap.getSMWorkspace().getMapControl().getMap().getLayers();
            Layer layer = layers.get(layerName);
            if (layer != null && layer.getDataset() instanceof DatasetVector) {
                DatasetVector datasetVector = (DatasetVector) layer.getDataset();
                int[] ids = {geometryID};
                return datasetVector.query(ids, CursorType.DYNAMIC);
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 获取栅格图层设置类
     *
     * @param layerName 图层名称
     * @return
     */
    public static LayerSettingGrid getLayerSettingGrid(String layerName) {
        try {
            Layer layer = getLayerByName(layerName);
            //判断是否是专题图
            if (layer != null && layer.getTheme() == null) {
                if (layer.getAdditionalSetting() != null && layer.getAdditionalSetting().getType() == LayerSettingType.GRID) {
                    return (LayerSettingGrid) layer.getAdditionalSetting();
                }
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 获取矢量图层设置类
     *
     * @param layerName 图层名称
     * @return
     */
    public static LayerSettingVector getLayerSettingVector(String layerName) {
        try {
            Layer layer = getLayerByName(layerName);
            //判断是否是专题图
            if (layer != null && layer.getTheme() == null) {
                if (layer.getAdditionalSetting() != null && layer.getAdditionalSetting().getType() == LayerSettingType.VECTOR) {
                    return (LayerSettingVector) layer.getAdditionalSetting();
                }
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    /**
     * 根据图层名称获取图层对象
     *
     * @return
     */
    public static Layer getLayerByName(String layerName) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Layers layers = mapControl.getMap().getLayers();
            return layers.get(layerName);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据图层索引获取图层对象
     *
     * @return
     */
    public static Layer getLayerByIndex(int layerIndex) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Layers layers = mapControl.getMap().getLayers();
            return layers.get(layerIndex);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
