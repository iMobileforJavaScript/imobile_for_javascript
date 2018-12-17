package com.supermap.interfaces;

import android.util.Log;
import com.facebook.react.bridge.*;
import com.supermap.RNUtils.ColorParseUtil;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.*;
import com.supermap.smNative.SMMapWC;
import com.supermap.smNative.SMThemeCartography;

import java.util.HashMap;

/**
 * 专题制图
 */

public class SThemeCartography extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SThemeCartography";
    private static ReactApplicationContext context;

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
            ColorGradientType colorGradientType = ColorGradientType.TERRAIN;//默认

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("UniqueExpression")){
                uniqueExpression = data.get("UniqueExpression").toString();
            }
            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
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

            if (dataset != null && uniqueExpression != null) {
                ThemeUnique themeUnique = ThemeUnique.makeDefault((DatasetVector) dataset, uniqueExpression, colorGradientType);

                GeoStyle geoStyle = SMThemeCartography.getThemeUniqueGeoStyle(themeUnique.getDefaultStyle(), data);
                themeUnique.setDefaultStyle(geoStyle);

                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getMap().getLayers().add(dataset, themeUnique, true);
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
     * 新建单值专题图层
     *
     * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、单值专题图字段表达式、默认样式)
     *                    LayerName: 要移除的专题图层
     * @param promise
     */
    @ReactMethod
    public void createAndRemoveThemeUniqueMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();
//            Log.e("SThemeCartography", "createAndRemoveThemeUniqueMap: " + data.toString());

            int datasourceIndex = 0;
            String datasourceAlias = null;
            String datasetName = null;
            String uniqueExpression = null;
            ColorGradientType colorGradientType = ColorGradientType.TERRAIN;//默认
            String layerName = null;
            int layerIndex = 0;

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("UniqueExpression")){
                uniqueExpression = data.get("UniqueExpression").toString();
            }
            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            }
            if (data.containsKey("LayerName")) {
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")) {
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
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

            if (dataset != null && uniqueExpression != null) {
                ThemeUnique themeUnique = ThemeUnique.makeDefault((DatasetVector) dataset, uniqueExpression, colorGradientType);

                GeoStyle geoStyle = SMThemeCartography.getThemeUniqueGeoStyle(themeUnique.getDefaultStyle(), data);
                themeUnique.setDefaultStyle(geoStyle);

                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                if (layerName != null) {
//                    mapControl.getMap().getLayers().remove(layerName);
                    mapControl.getMap().getLayers().get(layerName).setVisible(false);
                } else {
//                    mapControl.getMap().getLayers().remove(layerIndex);
                    mapControl.getMap().getLayers().get(layerIndex).setVisible(false);
                }
                mapControl.getMap().getLayers().add(dataset, themeUnique, true);
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
     * @param layerName 图层名称
     * @param promise
     */
    @ReactMethod
    public void getUniqueExpression(String layerName, Promise promise) {
        try {
            Layer layer = SMThemeCartography.getLayerByName(layerName);
            if (layer != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putString("UniqueExpression",themeUnique.getUniqueExpression());

                    promise.resolve(writeMap);
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
                    textStyle.setFontWidth(fontSize);
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
     * 新建统一标签专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createAndRemoveUniformThemeLabelMap(ReadableMap readableMap, Promise promise) {
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

            String layerName = null;
            int layerIndex = 0;
            if (data.containsKey("LayerName")) {
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")) {
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

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
                    textStyle.setFontHeight(fontSize);
                    textStyle.setFontWidth(fontSize);
                }
                if (rotation != -1) {
                    textStyle.setRotation(rotation);
                }
                if (foreColor != null) {
                    textStyle.setForeColor(ColorParseUtil.getColor(foreColor));
                }
                themeLabel.setUniformStyle(textStyle);

                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                if (layerName != null) {
//                    mapControl.getMap().getLayers().remove(layerName);
                    mapControl.getMap().getLayers().get(layerName).setVisible(false);
                } else {
//                    mapControl.getMap().getLayers().remove(layerIndex);
                    mapControl.getMap().getLayers().get(layerIndex).setVisible(false);
                }

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
                    String labelExpression = themeLabel.getLabelExpression();

                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putString("LabelExpression",labelExpression);
                    promise.resolve(writeMap);
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
                        WritableMap writeMap = Arguments.createMap();
                        writeMap.putString("LabelBackShape",labelBackShape);
                        promise.resolve(writeMap);
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

                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putString("FontName",fontName);
                    promise.resolve(writeMap);
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
                    uniformStyle.setFontWidth(fontSize);

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

                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putDouble("FontSize",fontHeight);
                    promise.resolve(writeMap);
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

                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putDouble("Rotaion",rotation);
                    promise.resolve(writeMap);
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

                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putString("Color",foreColor.toColorString());
                    promise.resolve(writeMap);
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
            ColorGradientType colorGradientType = ColorGradientType.TERRAIN;//默认的颜色渐变模式

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

            if (dataset != null && rangeExpression != null && rangeMode != null && rangeParameter != -1) {
                ThemeRange themeRange = ThemeRange.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType);

                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getMap().getLayers().add(dataset, themeRange, true);
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
     * 新建分段专题图层
     *
     * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
     * @param promise
     */
    @ReactMethod
    public void createAndRemoveThemeRangeMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;
            String datasetName = null;
            String rangeExpression = null;//分段字段表达式
            RangeMode rangeMode = null;//分段模式
            double rangeParameter = -1;//分段参数
            ColorGradientType colorGradientType = ColorGradientType.TERRAIN;//默认的颜色渐变模式

            String layerName = null;
            int layerIndex = 0;

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
            }

            if (data.containsKey("LayerName")) {
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")) {
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
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

            if (dataset != null && rangeExpression != null && rangeMode != null && rangeParameter != -1) {
                ThemeRange themeRange = ThemeRange.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType);

                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                if (layerName != null) {
//                    mapControl.getMap().getLayers().remove(layerName);
                    mapControl.getMap().getLayers().get(layerName).setVisible(false);
                } else {
//                    mapControl.getMap().getLayers().remove(layerIndex);
                    mapControl.getMap().getLayers().get(layerIndex).setVisible(false);
                }
                mapControl.getMap().getLayers().add(dataset, themeRange, true);
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

     /*栅格分段专题图
    * ********************************************************************************************/

    /**
     * 获取数据集中的字段
     * @param udbPath UDB在内存中路径
     * @param datasetName 数据集名称
     * @param promise
     */
    @ReactMethod
    public void getThemeExpressByUdb(String udbPath, String datasetName, Promise promise) {
        try {
            SMMapWC smMapWC = SMap.getInstance().getSmMapWC();
            smMapWC.getMapControl().getMap().setWorkspace(smMapWC.getWorkspace());
            DatasourceConnectionInfo datasourceConnection = new DatasourceConnectionInfo();
            if (smMapWC.getMapControl().getMap().getWorkspace().getDatasources().indexOf("switchudb") != -1) {
                smMapWC.getMapControl().getMap().getWorkspace().getDatasources().close("switchudb");
            }
            datasourceConnection.setEngineType(EngineType.UDB);
            datasourceConnection.setServer(udbPath);
            datasourceConnection.setAlias("switchudb");
            Datasource datasource = smMapWC.getMapControl().getMap().getWorkspace().getDatasources().open(datasourceConnection);
            Datasets datasets = datasource.getDatasets();
            DatasetVector datasetVector = (DatasetVector) datasets.get(datasetName);
            FieldInfos fieldInfos = datasetVector.getFieldInfos();
            int count = fieldInfos.getCount();

            WritableArray arr = Arguments.createArray();
            for (int i=0;i<count;i++){
                FieldInfo fieldInfo = fieldInfos.get(i);
                String name = fieldInfo.getName();
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("title",name);
                arr.pushMap(writeMap);
            }
            datasourceConnection.dispose();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取数据集中的字段
     * @param layerName 图层名称
     * @param promise
     */
    @ReactMethod
    public void getThemeExpressByLayerName(String layerName, Promise promise) {
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
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("title",name);
                arr.pushMap(writeMap);
            }
            promise.resolve(arr);
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
    public void getThemeExpressByLayerIndex(int layerIndex, Promise promise) {
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
                writeMap.putString("title",name);
                arr.pushMap(writeMap);
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}
