package com.supermap.interfaces;

import android.util.Log;
import com.facebook.react.bridge.*;
import com.supermap.RNUtils.ColorParseUtil;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.*;
import com.supermap.smNative.SMMapWC;
import com.supermap.smNative.SMThemeCartography;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * 专题制图
 */

public class SThemeCartography extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SThemeCartography";
    private static ReactApplicationContext context;
    private static Color[] lastUniqueColors = null;
    private static Color[] lastRangeColors = null;

    public SThemeCartography(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

     /*单值专题图
    *********************************************************************************************/
    /**
     * 新建单值专题图层
     *
     * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、单值专题图字段表达式、默认样式)
     * @param promise
     */
    @ReactMethod
    public void createThemeUniqueMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;
            String datasetName = null;
            String uniqueExpression = null;
            ColorGradientType colorGradientType = null;

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("UniqueExpression")){
                uniqueExpression = data.get("UniqueExpression").toString();
            }
            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.GREENWHITE;
            }

            Dataset dataset = SMThemeCartography.getDataset(data, datasetName);
            if (dataset == null) {
                if (data.containsKey("DatasourceIndex")){
                    String index = data.get("DatasourceIndex").toString();
                    datasourceIndex = Integer.parseInt(index);
                }
                if (data.containsKey("DatasourceAlias")){
                    datasourceAlias = data.get("DatasourceAlias").toString();
                }

                if (datasourceAlias != null) {
                    dataset = SMThemeCartography.getDataset(datasourceAlias, datasetName);
                }  else {
                    dataset = SMThemeCartography.getDataset(datasourceIndex, datasetName);
                }
            }

            boolean result = false;
            if (dataset != null && uniqueExpression != null) {
                ThemeUnique themeUnique = ThemeUnique.makeDefault((DatasetVector) dataset, uniqueExpression, colorGradientType);
                if (themeUnique != null) {
                    if (data.containsKey("ColorScheme")) {
                        String colorScheme = data.get("ColorScheme").toString();
                        Color[] rangeColors = SMThemeCartography.getUniqueColors(colorScheme);

                        if (rangeColors != null) {
                            int rangeCount = themeUnique.getCount();
                            Colors selectedColors = Colors.makeGradient(rangeCount, rangeColors);

                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setGeoStyleColor(dataset.getType(), themeUnique.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        }
                    }

                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getMap().getLayers().add(dataset, themeUnique, true);
                    mapControl.getMap().refresh();

                    result = true;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 修改单值专题图层
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void modifyThemeUniqueMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String uniqueExpression = null;
            ColorGradientType colorGradientType = null;
            String layerName = null;

            if (data.containsKey("LayerName")) {
                layerName = data.get("LayerName").toString();
            }
            Layer themeUniqueLayer = SMThemeCartography.getLayerByName(layerName);
            Dataset dataset = null;
            if (themeUniqueLayer != null) {
                dataset = themeUniqueLayer.getDataset();
            }

            ThemeUnique themeUnique = null;
            if (themeUniqueLayer != null && themeUniqueLayer.getTheme() != null && themeUniqueLayer.getTheme().getType() == ThemeType.UNIQUE) {
                themeUnique = (ThemeUnique) themeUniqueLayer.getTheme();
            }

            if (data.containsKey("UniqueExpression")){
                uniqueExpression = data.get("UniqueExpression").toString();
            } else {
                if (themeUnique != null) {
                    uniqueExpression = themeUnique.getUniqueExpression();
                }
            }

            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.GREENWHITE;
            }

            boolean result = false;
            if (dataset != null && themeUniqueLayer.getTheme() != null && uniqueExpression != null && colorGradientType != null) {
                ThemeUnique tu = ThemeUnique.makeDefault((DatasetVector) dataset, uniqueExpression, colorGradientType);
                if (tu != null){
                    if (!data.containsKey("ColorGradientType")) {
                        Color[] colors = SMThemeCartography.getLastThemeColors(themeUniqueLayer);
                        if (colors != null ) {
                            lastUniqueColors = colors;
                            int rangeCount = tu.getCount();
                            Colors selectedColors = Colors.makeGradient(rangeCount, colors);
                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setGeoStyleColor(dataset.getType(), tu.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        } else {
                            //用上次的颜色值
                            if (lastUniqueColors != null) {
                                int rangeCount = tu.getCount();
                                Colors selectedColors = Colors.makeGradient(rangeCount, lastUniqueColors);
                                for (int i = 0; i < rangeCount; i++) {
                                    SMThemeCartography.setGeoStyleColor(dataset.getType(), tu.getItem(i).getStyle(), selectedColors.get(i));
                                }
                            }
                        }
                    }

                    themeUniqueLayer.getTheme().fromXML(tu.toXML());
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getMap().refresh();

                    result = true;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图的默认风格
     *
     * @param readableMap 显示风格
     * @param layerName 图层名称
     * @param promise
     */
    @ReactMethod
    public void setThemeUniqueDefaultStyle(ReadableMap readableMap, String layerName, Promise promise) {
        try {
            Layer layer = SMThemeCartography.getLayerByName(layerName);
            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    HashMap<String, Object> data = readableMap.toHashMap();
                    GeoStyle geoStyle = SMThemeCartography.getThemeUniqueGeoStyle(themeUnique.getDefaultStyle(), data);
                    themeUnique.setDefaultStyle(geoStyle);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图子项的显示风格
     *
     * @param readableMap 显示风格
     * @param layerName 图层名称
     * @param itemIndex 单值专题图子项索引
     * @param promise
     */
    @ReactMethod
    public void setThemeUniqueItemStyle(ReadableMap readableMap, String layerName, int itemIndex, Promise promise) {
        try {
            Layer layer = SMThemeCartography.getLayerByName(layerName);
            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    ThemeUniqueItem uniqueItem = themeUnique.getItem(itemIndex);

                    HashMap<String, Object> data = readableMap.toHashMap();
                    GeoStyle geoStyle = SMThemeCartography.getThemeUniqueGeoStyle(uniqueItem.getStyle(), data);
                    uniqueItem.setStyle(geoStyle);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图字段表达式
     *
     * @param readableMap 单值专题图字段表达式 图层名称 图层索引
     * @param promise
     */
    @ReactMethod
    public void setUniqueExpression(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            String uniqueExpression = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("UniqueExpression")){
                uniqueExpression = data.get("UniqueExpression").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && uniqueExpression != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    themeUnique.setUniqueExpression(uniqueExpression);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

//    /**
//     * 设置单值专题图颜色方案
//     *
//     * @param ColorGradientType 颜色方案
//     * @param layerName 图层名称
//     * @param promise
//     */
//    @ReactMethod
//    public void setUniqueColorGradientType(String ColorGradientType, String layerName, Promise promise) {
//        try {
//            Layer layer = SMThemeCartography.getLayerByName(layerName);
//            if (layer != null && layer.getTheme() != null) {
//                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
//                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
//
//
//                    SMap.getSMWorkspace().getMapControl().getMap().refresh();
//
//                    promise.resolve(true);
//                }
//            } else {
//                promise.resolve(false);
//            }
//        } catch (Exception e) {
//            Log.e(REACT_CLASS, e.getMessage());
//            e.printStackTrace();
//            promise.reject(e);
//        }
//    }

    /**
     * 获取单值专题图的默认风格
     *
     * @param layerName 图层名称
     * @param promise
     */
    @ReactMethod
    public void getThemeUniqueDefaultStyle(String layerName, Promise promise) {
        try {
            Layer layer = SMThemeCartography.getLayerByName(layerName);
            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    GeoStyle defaultStyle = themeUnique.getDefaultStyle();
                    WritableMap writableMap = SMThemeCartography.getThemeUniqueDefaultStyle(defaultStyle);

                    promise.resolve(writableMap);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取单值专题图的字段表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniqueExpression(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();

                    promise.resolve(themeUnique.getUniqueExpression());
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }


     /*标签专题图
    * ********************************************************************************************/
    /**
     * 新建单值标签图层
     *
     * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
     * @param promise
     */
    @ReactMethod
    public void createUniqueThemeLabelMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;
            String datasetName = null;
            String rangeExpression = null;//分段字段表达式
            RangeMode rangeMode = null;//分段模式
            double rangeParameter = -1;//分段参数
            ColorGradientType colorGradientType = null;

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("RangeExpression")){
                rangeExpression  = data.get("RangeExpression").toString();
            }
            if (data.containsKey("RangeMode")){
                String mode = data.get("RangeMode").toString();
                rangeMode  = SMThemeCartography.getRangeMode(mode);
            }
            if (data.containsKey("RangeParameter")){
                String rangParam = data.get("RangeParameter").toString();
                rangeParameter  = Double.parseDouble(rangParam);
            }
            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.YELLOWGREEN;
            }

            Dataset dataset = SMThemeCartography.getDataset(data, datasetName);
            if (dataset == null) {
                if (data.containsKey("DatasourceIndex")){
                    String index = data.get("DatasourceIndex").toString();
                    datasourceIndex = Integer.parseInt(index);
                }
                if (data.containsKey("DatasourceAlias")){
                    datasourceAlias = data.get("DatasourceAlias").toString();
                }

                if (datasourceAlias != null) {
                    dataset = SMThemeCartography.getDataset(datasourceAlias, datasetName);
                }  else {
                    dataset = SMThemeCartography.getDataset(datasourceIndex, datasetName);
                }
            }

            boolean result = false;
            JoinItems joinItems = null;
            if (dataset != null && rangeExpression != null && rangeMode != null && rangeParameter != -1) {
                ThemeLabel themeLabel = ThemeLabel.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType,joinItems);
                if (themeLabel != null) {
                    themeLabel.setLabelExpression(rangeExpression);
                    themeLabel.setFlowEnabled(true);
                    if (data.containsKey("ColorScheme")) {
                        String colorScheme = data.get("ColorScheme").toString();
                        Color[] rangeColors = SMThemeCartography.getRangeColors(colorScheme);

                        if (rangeColors != null) {
                            int rangeCount = themeLabel.getCount();
                            Colors selectedColors;
                            if(rangeCount>0){
                                 selectedColors = Colors.makeGradient(rangeCount, rangeColors);
                            }else {
                                 selectedColors = Colors.makeGradient(1, rangeColors);
                            }

                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setItemTextStyleColor(themeLabel.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        }
                    }

                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getMap().getLayers().add(dataset, themeLabel, true);
                    mapControl.getMap().refresh();

                    result = true;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 新建分段标签图层
     *
     * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
     * @param promise
     */
    @ReactMethod
    public void createRangeThemeLabelMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;
            String datasetName = null;
            String rangeExpression = null;//分段字段表达式
            RangeMode rangeMode = null;//分段模式
            double rangeParameter = -1;//分段参数
            ColorGradientType colorGradientType = null;

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("RangeExpression")){
                rangeExpression  = data.get("RangeExpression").toString();
            }
            if (data.containsKey("RangeMode")){
                String mode = data.get("RangeMode").toString();
                rangeMode  = SMThemeCartography.getRangeMode(mode);
            }
            if (data.containsKey("RangeParameter")){
                String rangParam = data.get("RangeParameter").toString();
                rangeParameter  = Double.parseDouble(rangParam);
            }
            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.GREENRED;
            }

            Dataset dataset = SMThemeCartography.getDataset(data, datasetName);
            if (dataset == null) {
                if (data.containsKey("DatasourceIndex")){
                    String index = data.get("DatasourceIndex").toString();
                    datasourceIndex = Integer.parseInt(index);
                }
                if (data.containsKey("DatasourceAlias")){
                    datasourceAlias = data.get("DatasourceAlias").toString();
                }

                if (datasourceAlias != null) {
                    dataset = SMThemeCartography.getDataset(datasourceAlias, datasetName);
                }  else {
                    dataset = SMThemeCartography.getDataset(datasourceIndex, datasetName);
                }
            }

            boolean result = false;
            if (dataset != null && rangeExpression != null && rangeMode != null && rangeParameter != -1) {
                ThemeLabel themeLabel = ThemeLabel.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, 5, colorGradientType);
                if (themeLabel != null) {
                    themeLabel.setMaxLabelLength(8);
                    themeLabel.setNumericPrecision(1);
                    themeLabel.setLabelExpression(rangeExpression);
                    themeLabel.setFlowEnabled(true);
                    if (data.containsKey("ColorScheme")) {
                        String colorScheme = data.get("ColorScheme").toString();
                        Color[] rangeColors = SMThemeCartography.getRangeColors(colorScheme);

                        if (rangeColors != null) {
                            int rangeCount = themeLabel.getCount();
                            Colors selectedColors;
                            if(rangeCount>0){
                                selectedColors = Colors.makeGradient(rangeCount, rangeColors);
                            }else {
                                selectedColors = Colors.makeGradient(1, rangeColors);
                            }

                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setItemTextStyleColor(themeLabel.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        }
                    }

                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getMap().getLayers().add(dataset, themeLabel, true);
                    mapControl.getMap().refresh();

                    result = true;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 新建统一标签专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createUniformThemeLabelMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;

            String datasetName = null;
            String labelExpression = null;//标注字段表达式
            LabelBackShape labelBackShape = null;//背景形状
            String fontName = null;//字体名称
            double fontSize = -1;//字号
            double rotation = -1;//旋转角度
            String foreColor = null;//颜色

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("LabelExpression")){
                labelExpression  = data.get("LabelExpression").toString();
            }
            if (data.containsKey("LabelBackShape")){
                String shape = data.get("LabelBackShape").toString();
                labelBackShape  = SMThemeCartography.getLabelBackShape(shape);
            }
            if (data.containsKey("FontName")){
                fontName = data.get("FontName").toString();
            }
            if (data.containsKey("FontSize")){
                String size = data.get("FontSize").toString();
                fontSize = Double.parseDouble(size);
            }
            if (data.containsKey("Rotation")){
                String rt = data.get("Rotation").toString();
                rotation = Double.parseDouble(rt);
            }
            if (data.containsKey("ForeColor")){
                foreColor = data.get("ForeColor").toString();
            }

            Dataset dataset = SMThemeCartography.getDataset(data, datasetName);
            if (dataset == null) {
                if (data.containsKey("DatasourceIndex")){
                    String index = data.get("DatasourceIndex").toString();
                    datasourceIndex = Integer.parseInt(index);
                }
                if (data.containsKey("DatasourceAlias")){
                    datasourceAlias = data.get("DatasourceAlias").toString();
                }

                if (datasourceAlias != null) {
                    dataset = SMThemeCartography.getDataset(datasourceAlias, datasetName);
                }  else {
                    dataset = SMThemeCartography.getDataset(datasourceIndex, datasetName);
                }
            }

            if (dataset != null && labelExpression != null) {
                ThemeLabel themeLabel = new ThemeLabel();
                themeLabel.setLabelExpression(labelExpression);
                if (labelBackShape != null) {
                    themeLabel.setBackShape(labelBackShape);
                }

                TextStyle textStyle = new TextStyle();
                if (fontName != null) {
                    textStyle.setFontName(fontName);
                }
                if (fontSize != -1) {
//                    textStyle.setFontScale();
                    textStyle.setFontHeight(fontSize);
//                    textStyle.setFontWidth(fontSize);
                }
                if (rotation != -1) {
                    textStyle.setRotation(rotation);
                }
                if (foreColor != null) {
                    textStyle.setForeColor(ColorParseUtil.getColor(foreColor));
                }
                themeLabel.setUniformStyle(textStyle);

                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getMap().getLayers().add(dataset, themeLabel, true);
                mapControl.getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统一标签专题图的表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniformLabelExpression(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            String labelExpression = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("LabelExpression")){
                labelExpression = data.get("LabelExpression").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && labelExpression != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    themeLabel.setLabelExpression(labelExpression);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取统一标签专题图的表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniformLabelExpression(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();

                    promise.resolve(themeLabel.getLabelExpression());
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统一标签专题图的背景形状
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniformLabelBackShape(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            LabelBackShape labelBackShape = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("LabelBackShape")){
                String shape = data.get("LabelBackShape").toString();
                labelBackShape = SMThemeCartography.getLabelBackShape(shape);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && labelBackShape != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    themeLabel.setBackShape(labelBackShape);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取统一标签专题图的背景形状
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniformLabelBackShape(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    LabelBackShape backShape = themeLabel.getBackShape();
                    String labelBackShape = SMThemeCartography.getLabelBackShapeString(backShape);

                    if (labelBackShape != null) {
                        promise.resolve(labelBackShape);
                    } else {
                        promise.resolve(false);
                    }
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统一标签专题图的字体
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniformLabelFontName(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            String fontName = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("FontName")){
                fontName = data.get("FontName").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && fontName != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    uniformStyle.setFontName(fontName);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取统一标签专题图的字体
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniformLabelFontName(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    String fontName = uniformStyle.getFontName();

                    promise.resolve(fontName);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统一标签专题图的字号
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniformLabelFontSize(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            double fontSize = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("FontSize")){
                String size = data.get("FontSize").toString();
                fontSize = Double.parseDouble(size);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && fontSize != -1 && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    uniformStyle.setFontHeight(fontSize);
//                    uniformStyle.setFontWidth(fontSize);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取统一标签专题图的字号
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniformLabelFontSize(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    double fontHeight = uniformStyle.getFontHeight();

                    promise.resolve(fontHeight);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统一标签专题图的旋转角度
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniformLabelRotaion(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            double rotation = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("Rotaion")){
                String rt = data.get("Rotaion").toString();
                rotation = Double.parseDouble(rt);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && rotation != -1 && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    double lastRotation = uniformStyle.getRotation();
                    if (lastRotation == 360.0) {
                        lastRotation = 0.0;
                    } else if (lastRotation == 0.0) {
                        lastRotation = 360.0;
                    }
                    uniformStyle.setRotation(lastRotation + rotation);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取统一标签专题图的旋转角度
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniformLabelRotaion(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    double rotation = uniformStyle.getRotation();

                    promise.resolve(rotation);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统一标签专题图的颜色
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniformLabelColor(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            String color = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("Color")){
                color = data.get("Color").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && color != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    uniformStyle.setForeColor(ColorParseUtil.getColor(color));

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统一标签专题图的背景颜色
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniformLabelBackColor(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            String color = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("Color")){
                color = data.get("Color").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && color != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    GeoStyle backStyle = themeLabel.getBackStyle();
                    backStyle.setFillForeColor(ColorParseUtil.getColor(color));

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取统一标签专题图的颜色
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniformLabelColor(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    Color foreColor = uniformStyle.getForeColor();

                    promise.resolve(foreColor.toColorString());
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

     /*分段专题图
    * ********************************************************************************************/
    /**
     * 新建分段专题图层
     *
     * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
     * @param promise
     */
    @ReactMethod
    public void createThemeRangeMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;
            String datasetName = null;
            String rangeExpression = null;//分段字段表达式
            RangeMode rangeMode = null;//分段模式
            double rangeParameter = -1;//分段参数
            ColorGradientType colorGradientType = null;

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("RangeExpression")){
                rangeExpression  = data.get("RangeExpression").toString();
            }
            if (data.containsKey("RangeMode")){
                String mode = data.get("RangeMode").toString();
                rangeMode  = SMThemeCartography.getRangeMode(mode);
            }
            if (data.containsKey("RangeParameter")){
                String rangParam = data.get("RangeParameter").toString();
                rangeParameter  = Double.parseDouble(rangParam);
            }
            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.GREENWHITE;
            }

            Dataset dataset = SMThemeCartography.getDataset(data, datasetName);
            if (dataset == null) {
                if (data.containsKey("DatasourceIndex")){
                    String index = data.get("DatasourceIndex").toString();
                    datasourceIndex = Integer.parseInt(index);
                }
                if (data.containsKey("DatasourceAlias")){
                    datasourceAlias = data.get("DatasourceAlias").toString();
                }

                if (datasourceAlias != null) {
                    dataset = SMThemeCartography.getDataset(datasourceAlias, datasetName);
                }  else {
                    dataset = SMThemeCartography.getDataset(datasourceIndex, datasetName);
                }
            }

            boolean result = false;
            if (dataset != null && rangeExpression != null && rangeMode != null && rangeParameter != -1) {
                ThemeRange themeRange = ThemeRange.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType);
                if (themeRange != null) {
                    if (data.containsKey("ColorScheme")) {
                        String colorScheme = data.get("ColorScheme").toString();
                        Color[] rangeColors = SMThemeCartography.getRangeColors(colorScheme);

                        if (rangeColors != null) {
                            int rangeCount = themeRange.getCount();
                            Colors selectedColors = Colors.makeGradient(rangeCount, rangeColors);

                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setGeoStyleColor(dataset.getType(), themeRange.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        }
                    }

                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getMap().getLayers().add(dataset, themeRange, true);
                    mapControl.getMap().refresh();

                    result = true;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 修改分段专题图层
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void modifyThemeRangeMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String rangeExpression = null;//分段字段表达式
            RangeMode rangeMode = null;//分段模式
            double rangeParameter = -1;//分段参数
            ColorGradientType colorGradientType = null;
            String layerName = null;

            if (data.containsKey("LayerName")) {
                layerName = data.get("LayerName").toString();
            }
            Layer themeRangeLayer = SMThemeCartography.getLayerByName(layerName);
            Dataset dataset = null;
            if (themeRangeLayer != null) {
                dataset = themeRangeLayer.getDataset();
            }

            ThemeRange themeRange = null;
            if (themeRangeLayer != null && themeRangeLayer.getTheme() != null && themeRangeLayer.getTheme().getType() == ThemeType.RANGE) {
                themeRange = (ThemeRange) themeRangeLayer.getTheme();
            }

            if (data.containsKey("RangeExpression")){
                rangeExpression  = data.get("RangeExpression").toString();
            } else {
                if (themeRange != null) {
                    rangeExpression = themeRange.getRangeExpression();
                }
            }

            if (data.containsKey("RangeMode")){
                String mode = data.get("RangeMode").toString();
                rangeMode  = SMThemeCartography.getRangeMode(mode);
            } else {
                if (themeRange != null) {
                    rangeMode = themeRange.getRangeMode();
                }
            }

            if (data.containsKey("RangeParameter")){
                String rangParam = data.get("RangeParameter").toString();
                rangeParameter  = Double.parseDouble(rangParam) <= 0 ? 1: Double.parseDouble(rangParam);
            } else {
                if (themeRange != null) {
                    rangeParameter = themeRange.getCount();
                }
            }

            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.GREENWHITE;
            }

            boolean result = false;
            if (dataset != null && themeRangeLayer.getTheme() != null && rangeExpression != null && rangeMode != null && rangeParameter != -1 && colorGradientType != null) {
                ThemeRange tr = ThemeRange.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType);
                if (tr != null){
                    if (!data.containsKey("ColorGradientType")) {
                        Color[] colors = SMThemeCartography.getLastThemeColors(themeRangeLayer);
                        if (colors != null) {
                            lastRangeColors = colors;
                            int rangeCount = tr.getCount();
                            Colors selectedColors = Colors.makeGradient(rangeCount, colors);
                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setGeoStyleColor(dataset.getType(), tr.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        } else {
                            if (lastRangeColors != null) {
                                int rangeCount = tr.getCount();
                                Colors selectedColors = Colors.makeGradient(rangeCount, lastRangeColors);
                                for (int i = 0; i < rangeCount; i++) {
                                    SMThemeCartography.setGeoStyleColor(dataset.getType(), tr.getItem(i).getStyle(), selectedColors.get(i));
                                }
                            }
                        }
                    }

                    themeRangeLayer.getTheme().fromXML(tr.toXML());
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getMap().refresh();

                    result = true;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图颜色方案
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniqueColorScheme(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Color[] rangeColors = null;
            if (data.containsKey("ColorScheme")) {
                String colorScheme = data.get("ColorScheme").toString();
                rangeColors = SMThemeCartography.getUniqueColors(colorScheme);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && rangeColors != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    int rangeCount = themeUnique.getCount();
                    Colors selectedColors = Colors.makeGradient(rangeCount, rangeColors);

                    for (int i = 0; i < rangeCount; i++) {
                        SMThemeCartography.setGeoStyleColor(layer.getDataset().getType(), themeUnique.getItem(i).getStyle(), selectedColors.get(i));
                    }
                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置分段专题图颜色方案
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setRangeColorScheme(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Color[] rangeColors = null;
            if (data.containsKey("ColorScheme")) {
                String colorScheme = data.get("ColorScheme").toString();
                rangeColors = SMThemeCartography.getRangeColors(colorScheme);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && rangeColors != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.RANGE) {
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();
                    int rangeCount = themeRange.getCount();
                    Colors selectedColors = Colors.makeGradient(rangeCount, rangeColors);

                    for (int i = 0; i < rangeCount; i++) {
                        SMThemeCartography.setGeoStyleColor(layer.getDataset().getType(), themeRange.getItem(i).getStyle(), selectedColors.get(i));
                    }
                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置分段专题图的分段字段表达式
     *
     * @param readableMap 分段字段表达式 图层名称 图层索引
     * @param promise
     */
    @ReactMethod
    public void setRangeExpression(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            String rangeExpression = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("RangeExpression")){
                rangeExpression = data.get("RangeExpression").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && rangeExpression != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.RANGE) {
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();
                    themeRange.setRangeExpression(rangeExpression);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取分段专题图的分段表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getRangeExpression(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.RANGE) {
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();

                    promise.resolve(themeRange.getRangeExpression());
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取分段专题图的分段方法
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getRangeMode(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.RANGE) {
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();

                    promise.resolve(themeRange.getRangeMode().toString());
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取分段专题图的分段数
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getRangeCount(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.RANGE) {
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();

                    promise.resolve(themeRange.getCount());
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

     /*栅格分段专题图
    * ********************************************************************************************/

    /*统计专题图
     * ********************************************************************************************/
    /**
     * 新建统计专题图层
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createThemeGraphMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;

            String datasetName = null;//数据集名称
            ArrayList<String> graphExpressions = null;//字段表达式
            ThemeGraphType themeGraphType = null;//统计图类型
            Color[] colors = null;//颜色方案

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("GraphExpressions")){
                graphExpressions  = (ArrayList<String>) data.get("GraphExpressions");
            }
            if (data.containsKey("ThemeGraphType")){
                String type = data.get("ThemeGraphType").toString();
                themeGraphType  = SMThemeCartography.getThemeGraphType(type);
            }
            if (data.containsKey("GraphColorType")){
                String type = data.get("GraphColorType").toString();
                colors = SMThemeCartography.getGraphColors(type);
            } else {
                colors = SMThemeCartography.getGraphColors("HA_Calm");//默认
            }

            Dataset dataset = SMThemeCartography.getDataset(data, datasetName);
            if (dataset == null) {
                if (data.containsKey("DatasourceIndex")){
                    String index = data.get("DatasourceIndex").toString();
                    datasourceIndex = Integer.parseInt(index);
                }
                if (data.containsKey("DatasourceAlias")){
                    datasourceAlias = data.get("DatasourceAlias").toString();
                }

                if (datasourceAlias != null) {
                    dataset = SMThemeCartography.getDataset(datasourceAlias, datasetName);
                }  else {
                    dataset = SMThemeCartography.getDataset(datasourceIndex, datasetName);
                }
            }

            boolean result = false;
            if (dataset != null && graphExpressions != null && graphExpressions.size() > 0 && themeGraphType != null && colors != null) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                Map map = mapControl.getMap();

                ThemeGraph themeGraph = new ThemeGraph();

                ThemeGraphItem themeGraphItem = new ThemeGraphItem();
                themeGraphItem.setGraphExpression(graphExpressions.get(0));
                themeGraphItem.setCaption(graphExpressions.get(0));
                themeGraph.insert(0, themeGraphItem);
                themeGraph.setGraphType(themeGraphType);
                themeGraph.getAxesTextStyle().setFontHeight(6);

                Point pointStart = new Point(0,0);
                Point pointEnd = new Point(0, (int)(mapControl.getMapWidth() / 3));
                Point2D point2DStart = map.pixelToMap(pointStart);
                Point2D point2DEnd = map.pixelToMap(pointEnd);
                Point pointMinEnd = new Point(0, (int)(mapControl.getMapWidth() / 18));
                Point2D point2DMinEnd = map.pixelToMap(pointMinEnd);
                themeGraph.setMaxGraphSize(Math.sqrt(Math.pow(point2DEnd.getX() - point2DStart.getX(), 2) + Math.pow(point2DEnd.getY() - point2DStart.getY(), 2)));
                themeGraph.setMinGraphSize(Math.sqrt((Math.pow(point2DMinEnd.getX() - point2DStart.getX(), 2) + Math.pow(point2DMinEnd.getY() - point2DStart.getY(), 2))));

                int count = themeGraph.getCount();
                Colors selectedColors = Colors.makeGradient(colors.length, colors);
                if (count > 0) {
                    for (int i = 0; i < count; i++) {
                        themeGraph.getItem(i).getUniformStyle().setFillForeColor(selectedColors.get(i));
                    }
                }

                //若有多个表达式，则从第二个开始添加
                for (int i = 1; i < graphExpressions.size(); i++) {
                    SMThemeCartography.addGraphItem(themeGraph, graphExpressions.get(i), colors);
                }

                mapControl.getMap().getLayers().add(dataset, themeGraph, true);
                mapControl.getMap().refresh();

                result = true;
            }
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统计专题图的表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setThemeGraphExpressions(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            ArrayList<String> graphExpressions = null;//字段表达式
            if (data.containsKey("GraphExpressions")){
                graphExpressions  = (ArrayList<String>) data.get("GraphExpressions");
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && graphExpressions != null && graphExpressions.size() > 0 && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.GRAPH) {
                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    int count = themeGraph.getCount();

                    ArrayList<String> listExpressions = new ArrayList<>();
                    for (int i = 0; i < graphExpressions.size(); i++) {
                        for (int j = 0; j < count; j++) {
                            String graphExpression = themeGraph.getItem(j).getGraphExpression();
                            if (!graphExpression.equals(graphExpressions.get(i))) {
                                listExpressions.add(graphExpressions.get(i));
                            }
                        }
                    }

                    if (listExpressions.size() > 0) {
                        Color[] colors = SMThemeCartography.getLastThemeColors(layer);

                        for (int i = 0; i < listExpressions.size(); i++) {
                            SMThemeCartography.addGraphItem(themeGraph, listExpressions.get(i), colors);
                        }
                        SMap.getSMWorkspace().getMapControl().getMap().refresh();

                        promise.resolve(true);
                    } else {
                        promise.resolve(false);
                    }

                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统计专题图的颜色方案
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setThemeGraphColorScheme(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Color[] colors = null;//颜色方案
            if (data.containsKey("GraphColorType")){
                String type = data.get("GraphColorType").toString();
                colors = SMThemeCartography.getGraphColors(type);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && colors != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.GRAPH) {
                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    int count = themeGraph.getCount();
                    Colors selectedColors = Colors.makeGradient(colors.length, colors);

                    for (int i = 0; i < count; i++) {
                        int index = i;
                        if (index >= selectedColors.getCount()) {
                            index = index % selectedColors.getCount();
                        }
                        themeGraph.getItem(i).getUniformStyle().setFillForeColor(selectedColors.get(index));
                    }
                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统计专题图的类型
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setThemeGraphType(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            ThemeGraphType themeGraphType = null;//统计图类型

            if (data.containsKey("ThemeGraphType")){
                String type = data.get("ThemeGraphType").toString();
                themeGraphType  = SMThemeCartography.getThemeGraphType(type);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && themeGraphType != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.GRAPH) {
                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    themeGraph.setGraphType(themeGraphType);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统计专题图的统计值的计算方法
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setThemeGraphGraduatedMode(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            GraduatedMode graduatedMode = null;//常量分级、对数分级和平方根分级

            if (data.containsKey("GraduatedMode")){
                String type = data.get("GraduatedMode").toString();
                graduatedMode  = SMThemeCartography.getGraduatedMode(type);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && graduatedMode != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.GRAPH) {
                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    themeGraph.setGraduatedMode(graduatedMode);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /***************************************************************************************/


    /**
     * 获取数据集中的字段
     * @param layerName 图层名称
     * @param promise
     */
    @ReactMethod
    public void getThemeExpressionByLayerName(String layerName, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Layers layers = mapControl.getMap().getLayers();
            Dataset dataset = layers.get(layerName).getDataset();
            DatasetVector datasetVector = (DatasetVector) dataset;
            FieldInfos fieldInfos = datasetVector.getFieldInfos();
            int count = fieldInfos.getCount();

            WritableArray arr = Arguments.createArray();
            for (int i=0;i<count;i++){
                FieldInfo fieldInfo = fieldInfos.get(i);
                String name = fieldInfo.getName();
                String fieldType = SMThemeCartography.getFieldType(fieldInfo);//字段类型
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("expression", name);
                writeMap.putBoolean("isSelected", false);
                writeMap.putString("datasourceName", dataset.getDatasource().getAlias());
                writeMap.putString("datasetName", dataset.getName());
                writeMap.putString("fieldType", fieldType);
                if (name.equals("SmGeoPosition")) {
                    writeMap.putBoolean("isSystemField", true);//SmGeoPosition会被误判为非系统字段，暂做处理
                } else  {
                    writeMap.putBoolean("isSystemField", fieldInfo.isSystemField());//是否系统字段
                }
                arr.pushMap(writeMap);
            }

            WritableMap map2 = Arguments.createMap();
            String datasetName = dataset.getName();
            map2.putString("datasetName", datasetName);
            String datasetType = dataset.getType().toString();
            map2.putString("datasetType", datasetType);

            WritableMap WritableMap = Arguments.createMap();
            WritableMap.putArray("list", arr);
            WritableMap.putMap("dataset", map2);

            promise.resolve(WritableMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取数据集中的字段
     * @param layerIndex 图层索引
     * @param promise
     */
    @ReactMethod
    public void getThemeExpressionByLayerIndex(int layerIndex, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Layers layers = mapControl.getMap().getLayers();
            Dataset dataset = layers.get(layerIndex).getDataset();
            DatasetVector datasetVector = (DatasetVector) dataset;
            FieldInfos fieldInfos = datasetVector.getFieldInfos();
            int count = fieldInfos.getCount();

            WritableArray arr = Arguments.createArray();
            for (int i=0;i<count;i++){
                FieldInfo fieldInfo = fieldInfos.get(i);
                String name = fieldInfo.getName();
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("expression", name);
                writeMap.putBoolean("isSelected", false);
                arr.pushMap(writeMap);
            }

            WritableMap map2 = Arguments.createMap();
            String datasetName = dataset.getName();
            map2.putString("datasetName", datasetName);
            String datasetType = dataset.getType().toString();
            map2.putString("datasetType", datasetType);

            WritableMap WritableMap = Arguments.createMap();
            WritableMap.putArray("list", arr);
            WritableMap.putMap("dataset", map2);

            promise.resolve(WritableMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取数据集中的表达式
     * @param
     * @param promise
     */
    @ReactMethod
    public void getThemeExpressionByDatasetName(String datasourceAlias, String datasetName,Promise promise) {
        try {
            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();
            Datasource datasource = datasources.get(datasourceAlias);
            Datasets datasets = datasource.getDatasets();

            Dataset dataset = datasets.get(datasetName);
            DatasetVector datasetVector = (DatasetVector) dataset;
            FieldInfos fieldInfos = datasetVector.getFieldInfos();
            int count = fieldInfos.getCount();

            WritableArray arr = Arguments.createArray();
            for (int i=0;i<count;i++){
                FieldInfo fieldInfo = fieldInfos.get(i);
                String name = fieldInfo.getName();
                String fieldType = SMThemeCartography.getFieldType(fieldInfo);//字段类型
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("expression", name);
                writeMap.putString("fieldType", fieldType);
                if (name.equals("SmGeoPosition")) {
                    writeMap.putBoolean("isSystemField", true);//SmGeoPosition会被误判为非系统字段，暂做处理
                } else  {
                    writeMap.putBoolean("isSystemField", fieldInfo.isSystemField());//是否系统字段
                }
                arr.pushMap(writeMap);
            }

            WritableMap map2 = Arguments.createMap();
            String name = dataset.getName();
            map2.putString("datasetName", name);
            String datasetType = dataset.getType().toString();
            map2.putString("datasetType", datasetType);

            WritableMap WritableMap = Arguments.createMap();
            WritableMap.putArray("list", arr);
            WritableMap.putMap("dataset", map2);

            promise.resolve(WritableMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取所有数据源中的数据集
     * @param
     * @param promise
     */
    @ReactMethod
    public void getAllDatasetNames(Promise promise) {
        try {
            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();
            int datasourcesCount = datasources.getCount();

            WritableArray WA = Arguments.createArray();
            for (int i = 0; i < datasourcesCount; i++) {
                Datasource datasource = datasources.get(i);
                if (datasource.getConnectionInfo().getEngineType() != EngineType.UDB) {
                    //除了UDB数据源都排除
                    continue;
                }

                Datasets datasets = datasource.getDatasets();
                int datasetsCount = datasets.getCount();

                WritableArray arr = Arguments.createArray();
                for (int j = 0; j < datasetsCount; j++) {
                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putString("datasetName", datasets.get(j).getName());
                    writeMap.putString("datasetType", datasets.get(j).getType().toString());
                    writeMap.putString("datasourceName", datasource.getAlias());
                    PrjCoordSys prjCoordSys = datasets.get(j).getPrjCoordSys();
                    if (prjCoordSys != null) {
                        GeoCoordSys geoCoordSys = prjCoordSys.getGeoCoordSys();//地理坐标系
                        if (geoCoordSys != null && geoCoordSys.getType() != null) {
                            GeoCoordSysType geoCoordSysType = geoCoordSys.getType();
                            writeMap.putString("geoCoordSysType", geoCoordSysType.toString());
                        }
                        if (prjCoordSys.getType() != null) {
                            PrjCoordSysType prjCoordSysType = prjCoordSys.getType();//投影坐标系
                            writeMap.putString("prjCoordSysType", prjCoordSysType.toString());
                        }
                    }
                    arr.pushMap(writeMap);
                }

                WritableMap map = Arguments.createMap();
                String datasourceAlias = datasource.getAlias();
                map.putString("alias", datasourceAlias);

                WritableMap writableMap = Arguments.createMap();
                writableMap.putArray("list", arr);
                writableMap.putMap("datasource", map);

                WA.pushMap(writableMap);
            }

            promise.resolve(WA);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定数据源中的数据集
     * @param
     * @param promise
     */
    @ReactMethod
    public void getDatasetsByDatasource(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String alias = null;

            if (data.containsKey("Alias")) {
                alias = data.get("Alias").toString();
            }

            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();

            WritableArray WA = Arguments.createArray();
            Datasource datasource = datasources.get(alias);
            if (datasource == null) {
                promise.resolve(false);
                return;
            }
            if (datasource.getConnectionInfo().getEngineType() != EngineType.UDB) {
                //除了UDB数据源都排除
                promise.resolve(false);
                return;
            }

            Datasets datasets = datasource.getDatasets();
            int datasetsCount = datasets.getCount();

            WritableArray arr = Arguments.createArray();
            for (int j = 0; j < datasetsCount; j++) {
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("datasetName", datasets.get(j).getName());
                writeMap.putString("datasetType", datasets.get(j).getType().toString());
                writeMap.putString("datasourceName", datasource.getAlias());
                arr.pushMap(writeMap);
            }

            WritableMap map = Arguments.createMap();
            String datasourceAlias = datasource.getAlias();
            map.putString("alias", datasourceAlias);

            WritableMap writableMap = Arguments.createMap();
            writableMap.putArray("list", arr);
            writableMap.putMap("datasource", map);

            WA.pushMap(writableMap);

            promise.resolve(WA);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取专题图的颜色方案
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getThemeColorSchemeName(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null) {
                String themeColorSchemeName = SMThemeCartography.getThemeColorSchemeName(layer);

                if (themeColorSchemeName != null) {
                    promise.resolve(themeColorSchemeName);
                } else {
                    promise.resolve(false);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 保存当前地图
     *
     * @param promise
     */
    @ReactMethod
    public void saveMap(Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            com.supermap.mapping.Map map = mapControl.getMap();

            boolean saveMap = map.save();
            boolean saveWorkspace = workspace.save();
            if (saveMap && saveWorkspace) {
                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取UDB中数据集名称
     *  @param path UDB在内存中路径
     * @param promise
     */
    @ReactMethod
    public void getUDBName(String path, Promise promise) {
        try {
            File tempFile = new File(path.trim());
            String[] strings = tempFile.getName().split("\\.");
            String udbName = strings[0];
            Datasource datasource;

            SMap sMap = SMap.getInstance();
            SMMapWC smMapWC = sMap.getSmMapWC();
            smMapWC.getMapControl().getMap().setWorkspace(smMapWC.getWorkspace());
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();
            if (smMapWC.getMapControl().getMap().getWorkspace().getDatasources().indexOf(udbName) != -1) {
                datasource = smMapWC.getMapControl().getMap().getWorkspace().getDatasources().get(udbName);
            } else {
                datasourceconnection.setEngineType(EngineType.UDB);
                datasourceconnection.setServer(path);
                datasourceconnection.setAlias(udbName);
                datasource = smMapWC.getMapControl().getMap().getWorkspace().getDatasources().open(datasourceconnection);
            }

            Datasets datasets = datasource.getDatasets();
            int count = datasets.getCount();

            WritableArray arr = Arguments.createArray();
            for (int i=0;i<count;i++){
                Dataset dataset = datasets.get(i);
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("datasetName", dataset.getName());
                writeMap.putString("datasetType", dataset.getType().toString());
                writeMap.putString("datasourceName", datasource.getAlias());
                PrjCoordSys prjCoordSys = dataset.getPrjCoordSys();
                if (prjCoordSys != null) {
                    GeoCoordSys geoCoordSys = prjCoordSys.getGeoCoordSys();//地理坐标系
                    if (geoCoordSys != null && geoCoordSys.getType() != null) {
                        GeoCoordSysType geoCoordSysType = geoCoordSys.getType();
                        writeMap.putString("geoCoordSysType", geoCoordSysType.toString());
                    }
                    if (prjCoordSys.getType() != null) {
                        PrjCoordSysType prjCoordSysType = prjCoordSys.getType();//投影坐标系
                        writeMap.putString("prjCoordSysType", prjCoordSysType.toString());
                    }
                }
                arr.pushMap(writeMap);
            }
            datasourceconnection.dispose();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 是否有打开的数据源
     *
     * @param promise
     */
    @ReactMethod
    public void isAnyOpenedDS(Promise promise) {
        try {
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            int count = workspace.getDatasources().getCount();

            Datasources datasources = workspace.getDatasources();
            int datasourcesCount = datasources.getCount();
            ArrayList<Datasource> list = new ArrayList<>();
            for (int i = 0; i < datasourcesCount; i++) {
                Datasource datasource = datasources.get(i);
                if (datasource.getConnectionInfo().getEngineType() == EngineType.UDB) {
                    //除了UDB数据源都排除
                    list.add(datasource);
                }
            }

            boolean isAnyOpenedDS = true;
            if (count <= 0) {
                isAnyOpenedDS = false;
            } else if (list.size() == 0) {
                isAnyOpenedDS = false;
            }
            promise.resolve(isAnyOpenedDS);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
