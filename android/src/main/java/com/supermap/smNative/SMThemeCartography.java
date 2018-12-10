package com.supermap.smNative;

import android.util.Log;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.ColorParseUtil;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.*;

import java.util.HashMap;
import java.util.Map;

public class SMThemeCartography {
    private static final String TAG = "SMThemeCartography";

    /**
     * 根据数据源索引和数据集名称获取数据集对象
     * @return
     */
    public static Dataset getDataset(int datasourceIndex, String datasetName) {
        try {
            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();
            Datasource datasource = datasources.get(datasourceIndex);
            Dataset dataset = datasource.getDatasets().get(datasetName);

            return dataset;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据数据源别名和数据集名称获取数据集对象
     * @return
     */
    public static Dataset getDataset(String datasourceAlias, String datasetName) {
        try {
            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();
            Datasource datasource = datasources.get(datasourceAlias);
            Dataset dataset = datasource.getDatasets().get(datasetName);

            return dataset;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 打开数据源路径，数据集名称获取数据集对象
     * @return
     */
    public static Dataset getDataset(Map data, String datasetName) {
        try {
            if (!data.containsKey("server") || !data.containsKey("alias") || !data.containsKey("engineType")) {
                return null;
            }

            Dataset dataset = null;
            Datasource datasource = SMap.getSMWorkspace().openDatasource(data);
            if (datasource != null) {
                dataset= datasource.getDatasets().get(datasetName);
            }
            return dataset;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
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
            Log.e(TAG, e.getMessage());
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
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 解析获取单值专题图(子项)的显示风格
     * @param style
     * @param data
     * @return
     */
    public static GeoStyle getThemeUniqueGeoStyle(GeoStyle style, HashMap<String, Object> data) {
        final GeoStyle oldStyle = style.clone();
        try {
            if (data.containsKey("MarkerSymbolID")){
                //点符号的ID
                String MarkerSymbolID = data.get("MarkerSymbolID").toString();
                style.setMarkerSymbolID(Integer.parseInt(MarkerSymbolID));
            }
            if (data.containsKey("MarkerSize")){
                //点符号的大小
                String MarkerSize = data.get("MarkerSize").toString();
                int mm = Integer.parseInt(MarkerSize);
                style.setMarkerSize(new Size2D(mm, mm));
            }
            if (data.containsKey("MakerColor")){
                //点符号的颜色
                String MakerColor = data.get("MakerColor").toString();
                style.setLineColor(ColorParseUtil.getColor(MakerColor));
            }
            if (data.containsKey("MarkerAngle")){
                //点符号的旋转角度
                String MarkerAngle = data.get("MarkerAngle").toString();
                style.setMarkerAngle(Integer.parseInt(MarkerAngle));
            }
            if (data.containsKey("MarkerAlpha")){
                //点符号的透明度
                String MarkerAlpha = data.get("MarkerAlpha").toString();
                style.setFillOpaqueRate(100 - Integer.parseInt(MarkerAlpha));
            }

            if (data.containsKey("LineSymbolID")){
                //线符号的ID(//设置边框符号的ID)
                String LineSymbolID = data.get("LineSymbolID").toString();
                style.setLineSymbolID(Integer.parseInt(LineSymbolID));
            }
            if (data.containsKey("LineWidth")){
                //线宽(边框符号宽度)
                String LineWidth = data.get("LineWidth").toString();
                int mm = Integer.parseInt(LineWidth);
                double width = (double) mm / 10;
                style.setLineWidth(width);
            }
            if (data.containsKey("LineColor")){
                //线颜色(边框符号颜色)
                String LineColor = data.get("LineColor").toString();
                style.setLineColor(ColorParseUtil.getColor(LineColor));
            }

            if (data.containsKey("FillSymbolID")){
                //面符号的ID
                String FillSymbolID = data.get("FillSymbolID").toString();
                style.setFillSymbolID(Integer.parseInt(FillSymbolID));
            }
            if (data.containsKey("FillForeColor")){
                //前景色
                String FillForeColor = data.get("FillForeColor").toString();
                style.setFillForeColor(ColorParseUtil.getColor(FillForeColor));
            }
            if (data.containsKey("FillBackColor")){
                //背景色
                String FillBackColor = data.get("FillBackColor").toString();
                style.setFillBackColor(ColorParseUtil.getColor(FillBackColor));
            }
            if (data.containsKey("FillOpaqueRate")){
                //设置透明度（0-100）
                String FillOpaqueRate = data.get("FillOpaqueRate").toString();
                style.setFillOpaqueRate(100 - Integer.parseInt(FillOpaqueRate));
            }
            if (data.containsKey("FillGradientMode")){
                //设置渐变
                String FillGradientMode = data.get("FillGradientMode").toString();
                switch (FillGradientMode) {
                    case "LINEAR":  //线性渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.LINEAR);
                        break;
                    case "RADIAL":  //辐射渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.RADIAL);
                        break;
                    case "SQUARE":  //方形渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.SQUARE);
                        break;
                    case "NONE":  //无渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.NONE);
                        break;
                }
            }

            return style;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return oldStyle;
        }

    }

    /**
     * 获取单值专题图默认的显示风格
     * @param style
     * @return
     */
    public static WritableMap getThemeUniqueDefaultStyle(GeoStyle style) {
        WritableMap writeMap = Arguments.createMap();
        try {
            //点符号的ID
            int markerSymbolID = style.getMarkerSymbolID();
            writeMap.putInt("MarkerSymbolID", markerSymbolID);

            //点符号的大小
            Size2D markerSize = style.getMarkerSize();
            writeMap.putDouble("MarkerSize", markerSize.getHeight());

            //点符号的颜色
            Color markerColor = style.getLineColor();
            writeMap.putString("MarkerColor", markerColor.toColorString());

            //点符号的旋转角度
            double markerAngle = style.getMarkerAngle();
            writeMap.putDouble("MarkerAngle", markerAngle);

            //点符号的不透明度
            int markerFillOpaqueRate = style.getFillOpaqueRate();
            writeMap.putInt("MarkerFillOpaqueRate", markerFillOpaqueRate);

            //线符号的ID(//设置边框符号的ID)
            int lineSymbolID = style.getLineSymbolID();
            writeMap.putInt("LineSymbolID", lineSymbolID);

            //线宽(边框符号宽度)
            double lineWidth = style.getLineWidth();
            writeMap.putDouble("LineWidth", lineWidth);

            //线颜色(边框符号颜色)
            Color lineColor = style.getLineColor();
            writeMap.putString("LineColor", lineColor.toColorString());

            //面符号的ID
            int fillSymbolID = style.getFillSymbolID();
            writeMap.putInt("FillSymbolID", fillSymbolID);

            //前景色
            Color fillForeColor = style.getFillForeColor();
            writeMap.putString("FillForeColor", fillForeColor.toColorString());

            //背景色
            Color fillBackColor = style.getFillBackColor();
            writeMap.putString("FillBackColor", fillBackColor.toColorString());

            //不透明度
            int fillOpaqueRate = style.getFillOpaqueRate();
            writeMap.putInt("FillOpaqueRate", fillOpaqueRate);

            //设置渐变
            FillGradientMode fillGradientMode = style.getFillGradientMode();
            String mode = "NONE";
            if (fillGradientMode == FillGradientMode.LINEAR) {
                //线性渐变
                mode = "LINEAR";
            } else if (fillGradientMode == FillGradientMode.RADIAL) {
                //辐射渐变
                mode = "RADIAL";
            } else if (fillGradientMode == FillGradientMode.SQUARE) {
                //方形渐变
                mode = "SQUARE";
            } else if (fillGradientMode == FillGradientMode.NONE) {
                //无渐变
                mode = "NONE";
            }
            writeMap.putString("FillGradientMode", mode);

            return writeMap;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }

    }

    /**
     * 获取颜色渐变类型
     * @param type
     * @return ColorGradientType
     */
    public static ColorGradientType getColorGradientType(String type) {
        switch (type) {
            case "BLACKWHITE":
                //黑白渐变色
                return ColorGradientType.BLACKWHITE;
            case "BLUEBLACK":
                //蓝黑渐变色
                return ColorGradientType.BLUEBLACK;
            case "BLUERED":
                //蓝红渐变色
                return ColorGradientType.BLUERED;
            case "BLUEWHITE":
                //蓝白渐变色
                return ColorGradientType.BLUEWHITE;
            case "CYANBLACK":
                //青黑渐变色
                return ColorGradientType.CYANBLACK;
            case "CYANBLUE":
                //青蓝渐变色
                return ColorGradientType.CYANBLUE;
            case "CYANGREEN":
                //青绿渐变色
                return ColorGradientType.CYANGREEN;
            case "CYANWHITE":
                //青白渐变色
                return ColorGradientType.CYANWHITE;
            case "GREENBLACK":
                //绿黑渐变色
                return ColorGradientType.GREENBLACK;
            case "GREENBLUE":
                //绿蓝渐变色
                return ColorGradientType.GREENBLUE;
            case "GREENORANGEVIOLET":
                //绿橙紫渐变色
                return ColorGradientType.GREENORANGEVIOLET;
            case "GREENRED":
                //绿红渐变色
                return ColorGradientType.GREENRED;
            case "GREENWHITE":
                //绿白渐变色
                return ColorGradientType.GREENWHITE;
            case "PINKBLACK":
                //粉红黑渐变色
                return ColorGradientType.PINKBLACK;
            case "PINKBLUE":
                //粉红蓝渐变色
                return ColorGradientType.PINKBLUE;
            case "PINKRED":
                //粉红红渐变色
                return ColorGradientType.PINKRED;
            case "PINKWHITE":
                //粉红白渐变色
                return ColorGradientType.PINKWHITE;
            case "RAINBOW":
                //彩虹色
                return ColorGradientType.RAINBOW;
            case "REDBLACK":
                //红黑渐变色
                return ColorGradientType.REDBLACK;
            case "REDWHITE":
                //红白渐变色
                return ColorGradientType.REDWHITE;
            case "SPECTRUM":
                //光谱渐变
                return ColorGradientType.SPECTRUM;
            case "TERRAIN":
                //地形渐变
                return ColorGradientType.TERRAIN;
            case "YELLOWBLACK":
                //黄黑渐变色
                return ColorGradientType.YELLOWBLACK;
            case "YELLOWBLUE":
                //黄蓝渐变色
                return ColorGradientType.YELLOWBLUE;
            case "YELLOWGREEN":
                //黄绿渐变色
                return ColorGradientType.YELLOWGREEN;
            case "YELLOWRED":
                //黄红渐变色
                return ColorGradientType.YELLOWRED;
            case "YELLOWWHITE":
                //黄白渐变色
                return ColorGradientType.YELLOWWHITE;
            default:
                //默认
                return ColorGradientType.TERRAIN;
        }

    }

    /**
     * 获取分段模式
     * @param mode
     * @return RangeMode
     */
    public static RangeMode getRangeMode(String mode) {
        switch (mode) {
            case "CUSTOMINTERVAL":
                //自定义分段
                return RangeMode.CUSTOMINTERVAL;
            case "EQUALINTERVAL":
                //等距离分段
                return RangeMode.EQUALINTERVAL;
            case "LOGARITHM":
                //对数分段
                return RangeMode.LOGARITHM;
            case "NONE":
                //空分段模式
                return RangeMode.NONE;
            case "QUANTILE":
                //等计数分段
                return RangeMode.QUANTILE;
            case "SQUAREROOT":
                //平方根分段
                return RangeMode.SQUAREROOT;
            case "STDDEVIATION":
                //标准差分段。
                return RangeMode.STDDEVIATION;
            default:
                //默认：等距分段
                return RangeMode.EQUALINTERVAL;
        }
    }

    /**
     * 返回标签专题图中的标签背景的形状类型。
     * @param shape
     * @return RangeMode
     */
    public static LabelBackShape getLabelBackShape(String shape) {
        switch (shape) {
            case "DIAMOND":
                // 菱形背景
                return LabelBackShape.DIAMOND;
            case "ELLIPSE":
                // 椭圆形背景
                return LabelBackShape.ELLIPSE;
            case "MARKER":
                // 符号背景
                return LabelBackShape.MARKER;
            case "NONE":
                // 空背景
                return LabelBackShape.NONE;
            case "RECT":
                // 矩形背景
                return LabelBackShape.RECT;
            case "ROUNDRECT":
                // 圆角矩形背景
                return LabelBackShape.ROUNDRECT;
            case "TRIANGLE":
                // 三角形背景
                return LabelBackShape.TRIANGLE;
            default:
                //默认
                return LabelBackShape.NONE;
        }
    }

    /**
     * 返回标签专题图中的标签背景的形状类型字符串
     * @param shape
     * @return RangeMode
     */
    public static String getLabelBackShapeString(LabelBackShape shape) {
        if (shape == LabelBackShape.DIAMOND) {
            return "DIAMOND";
        }
        else if (shape == LabelBackShape.ELLIPSE) {
            return "ELLIPSE";
        }
        else if (shape == LabelBackShape.MARKER) {
            return "MARKER";
        }
        else if (shape == LabelBackShape.NONE) {
            return "NONE";
        }
        else if (shape == LabelBackShape.RECT) {
            return "RECT";
        }
        else if (shape == LabelBackShape.ROUNDRECT) {
            return "ROUNDRECT";
        }
        else if (shape == LabelBackShape.TRIANGLE) {
            return "TRIANGLE";
        }
        else {
            return null;
        }
    }
}
