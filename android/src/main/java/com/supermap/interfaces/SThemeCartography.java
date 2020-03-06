package com.supermap.interfaces;

import android.util.Log;
import com.facebook.react.bridge.*;
import com.supermap.RNUtils.ColorParseUtil;
import com.supermap.data.*;
import com.supermap.data.Enum;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.*;
import com.supermap.smNative.SMMapWC;
import com.supermap.smNative.SMThemeCartography;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * 专题制图
 */

public class SThemeCartography extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SThemeCartography";
    private static ReactApplicationContext context;
//    private static Color[] lastUniqueColors = null;
//    private static Color[] lastRangeColors = null;
    private static Color[] lastGraphColors = null;
    private static String _colorScheme = null; // 用于记录单值标签颜色方案

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
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

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
                        _colorScheme = data.get("ColorScheme").toString();
                        Color[] rangeColors = SMThemeCartography.getUniqueColors(_colorScheme);

                        if (rangeColors != null) {
                            int rangeCount = themeUnique.getCount();
                            Colors selectedColors = Colors.makeGradient(rangeCount, rangeColors);

                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setGeoStyleColor(dataset.getType(), themeUnique.getItem(i).getStyle(), selectedColors.get(i));
                            }
//                            lastUniqueColors =  rangeColors;
                        }
                    }

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
            if (dataset != null && themeUniqueLayer.getTheme() != null && uniqueExpression != null && colorGradientType != null && !uniqueExpression.equals(themeUnique.getUniqueExpression())) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                ThemeUnique tu = ThemeUnique.makeDefault((DatasetVector) dataset, uniqueExpression, colorGradientType);
                if (tu != null){
                    Color[] lastUniqueColors = null;
                    if (!data.containsKey("ColorGradientType")) {
                        if(lastUniqueColors==null){
                            int rangeCount = themeUnique.getCount();
                            lastUniqueColors = new Color[rangeCount];
                            for (int i = 0; i < rangeCount; i++) {
                                Color color = SMThemeCartography.getGeoStyleColor(dataset.getType(),themeUnique.getItem(i).getStyle());
                                lastUniqueColors[i] = color;
                            }
                        }
                    }

                    themeUniqueLayer.getTheme().fromXML(tu.toXML());

                    int rangeCount = themeUnique.getCount();
                    for (int i = 0; i < rangeCount; i++) {
                        int k = (int)(Math.random()*lastUniqueColors.length);
                        Color color = lastUniqueColors[k];
                        SMThemeCartography.setGeoStyleColor(dataset.getType(), themeUnique.getItem(i).getStyle(),color);
                    }

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    HashMap<String, Object> data = readableMap.toHashMap();
                    GeoStyle geoStyle = SMThemeCartography.getThemeUniqueGeoStyle(themeUnique.getDefaultStyle(), data);
                    themeUnique.setDefaultStyle(geoStyle);

                    mapControl.getMap().refresh();

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
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    ThemeUniqueItem uniqueItem = themeUnique.getItem(itemIndex);

                    HashMap<String, Object> data = readableMap.toHashMap();
                    GeoStyle geoStyle = SMThemeCartography.getThemeUniqueGeoStyle(uniqueItem.getStyle(), data);
                    uniqueItem.setStyle(geoStyle);

                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    themeUnique.setUniqueExpression(uniqueExpression);

                    mapControl.getMap().refresh();

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


    /**
     * 获取单值专题图列表项
     * @param params
     * @param promise
     */
    @ReactMethod
    public void getUniqueList(ReadableMap params, Promise promise){
        try{
            String layerName = params.getString("LayerName");
            WritableArray array = Arguments.createArray();
            if(layerName != null){
                Layer layer = SMThemeCartography.getLayerByName(layerName);
                if(layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.UNIQUE){
                    ThemeUnique themeUnique = (ThemeUnique)layer.getTheme();
                    int count = themeUnique.getCount();
                    for(int i = 0; i < count; i++){
                        ThemeUniqueItem item = themeUnique.getItem(i);

                        String unique = item.getUnique();
                        boolean visible = item.isVisible();
                        GeoStyle style = item.getStyle();
                        String styleXML = style.toXML();

                        Color color = style.getFillForeColor();
                        int r = color.getR();
                        int g = color.getG();
                        int b = color.getB();

                        WritableMap returnColor = Arguments.createMap();
                        returnColor.putInt("r",r);
                        returnColor.putInt("g",g);
                        returnColor.putInt("b",b);

                        WritableMap dic = Arguments.createMap();
                        dic.putString("title",unique);
                        dic.putMap("color",returnColor);
                        dic.putBoolean("visible",visible);
                        dic.putString("style",styleXML);

                        array.pushMap(dic);
                    }
                }
            }
            promise.resolve(array);
        }catch (Exception e){
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置用户自定义单值专题图
     * @param params
     * @param promise
     */
    @ReactMethod
    public void setCustomThemeUnique(ReadableMap params, Promise promise){
        try{
            String layerName = params.getString("LayerName");
            ReadableArray rangeList = params.getArray("RangeList");
            if(layerName != null){
                Layer layer = SMThemeCartography.getLayerByName(layerName);
                if(layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.UNIQUE){
                    ThemeUnique themeUnique = (ThemeUnique)layer.getTheme();
                    themeUnique.clear();

                    for(int i = 0; i < rangeList.size(); i++){
                        ReadableMap curItem = rangeList.getMap(i);

                        String unique = curItem.getString("title");
                        boolean visible = curItem.getBoolean("visible");

                        String styleXML = curItem.getString("style");
                        ReadableMap color = curItem.getMap("color");

                        int r = color.getInt("r");
                        int g = color.getInt("g");
                        int b = color.getInt("b");

                        GeoStyle style = new GeoStyle();
                        style.fromXML(styleXML);
                        style.setFillForeColor(new Color(r,g,b));

                        ThemeUniqueItem item = new ThemeUniqueItem();
                        item.setUnique(unique);
                        item.setStyle(style);
                        item.setVisible(visible);

                        themeUnique.add(item);
                    }
                    SMap.getInstance().smMapWC.getMapControl().getMap().refresh();
                    promise.resolve(true);
                }
            }else{
                promise.resolve(false);
            }
        }catch (Exception e){
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
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;
            String datasetName = null;
            String uniqueExpression = null;//单值字段表达式
            ColorGradientType colorGradientType = null;

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("UniqueExpression")){
                uniqueExpression  = data.get("UniqueExpression").toString();
            }
            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.YELLOWBLUE;
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
            if (dataset != null && uniqueExpression != null) {
                ThemeLabel themeLabel = ThemeLabel.makeDefault((DatasetVector) dataset, uniqueExpression,  colorGradientType,joinItems);
                if (themeLabel != null) {
                    themeLabel.setLabelExpression(uniqueExpression);
                    themeLabel.setFlowEnabled(true);
                    if (data.containsKey("ColorScheme")) {
                        String colorScheme = data.get("ColorScheme").toString();
                        Color[] colors = SMThemeCartography.getUniqueColors(colorScheme);

                        if (colors != null) {
                            int count = themeLabel.getUniqueItems().getCount();
                            Colors selectedColors;
                            if(count>0){
                                 selectedColors = Colors.makeGradient(count, colors);
                            }else {
                                 selectedColors = Colors.makeGradient(1, colors);
                            }

                            for (int i = 0; i < count; i++) {
                                SMThemeCartography.setItemTextStyleColor(themeLabel.getUniqueItems().getItem(i).getStyle(), selectedColors.get(i));
                            }
                        }
                    }

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
     *
     * 获取单值标签专题图的字段表达式
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getUniqueLabelExpression(ReadableMap readableMap, Promise promise) {
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
                    ThemeLabel theme= (ThemeLabel) layer.getTheme();
                    String result = theme.getUniqueExpression();
                    if (result!=null && !result.isEmpty()){
                        promise.resolve(result);
                    }else{
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
     * 设置单值标签专题图字段单值字段
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniqueLabelExpression(ReadableMap readableMap, Promise promise) {
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
            if (data.containsKey("UniqueExpression")){
                labelExpression = data.get("UniqueExpression").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && labelExpression != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    ThemeLabel newThemeLabel = ThemeLabel.makeDefault((DatasetVector)layer.getDataset(), labelExpression, ColorGradientType.YELLOWBLUE, null);

                    Color[] uniqueColors;
                    if (_colorScheme != null && !_colorScheme.equals("")) {
                        uniqueColors = SMThemeCartography.getUniqueColors(_colorScheme);
                    } else if (themeLabel.getUniqueItems().getCount() > 1) {
                        uniqueColors = new Color[2];
                        uniqueColors[0] = themeLabel.getUniqueItems().getItem(0).getStyle().getForeColor();
                        uniqueColors[1] = themeLabel.getUniqueItems().getItem(themeLabel.getUniqueItems().getCount() - 1).getStyle().getForeColor();
                    } else {
                        _colorScheme = "DA_Ragular";
                        uniqueColors = SMThemeCartography.getUniqueColors(_colorScheme);
                    }
                    Colors colors;
                    themeLabel.getUniqueItems().clear();
                    if (newThemeLabel.getUniqueItems().getCount() > 0) {
                        colors = Colors.makeGradient(newThemeLabel.getUniqueItems().getCount(), uniqueColors);
                    } else {
                        colors = Colors.makeGradient(1, uniqueColors);
                    }

                    for (int i = 0; i < newThemeLabel.getUniqueItems().getCount(); i++) {
                        ThemeLabelUniqueItem item = newThemeLabel.getUniqueItems().getItem(i);
                        item.getStyle().setForeColor(colors.get(i));
                        themeLabel.getUniqueItems().add(item);
                    }
                    newThemeLabel.getUniqueItems().clear();
                    newThemeLabel.dispose();
                    newThemeLabel = null;

                    themeLabel.setUniqueExpression(labelExpression);

                    mapControl.getMap().refresh();

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
     * 设置单值标签专题图颜色方案
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setUniqueLabelColorScheme(ReadableMap readableMap, Promise promise) {
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

            Color[] colors = null;
            if (data.containsKey("ColorScheme")) {
                String colorScheme = data.get("ColorScheme").toString();
                colors = SMThemeCartography.getUniqueColors(colorScheme);
                _colorScheme = colorScheme;
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && colors != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel theme = (ThemeLabel) layer.getTheme();
                    ThemeLabelUniqueItems items = theme.getUniqueItems();
                    int count = items.getCount();
                    Colors selectedColors = Colors.makeGradient(count, colors);

                    for (int i = 0; i < count; i++) {
                        items.getItem(i).getStyle().setForeColor( selectedColors.get(i) );
                    }
                    mapControl.getMap().refresh();

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
     * 获取单值标签专题图的子项列表
     * @param params
     * @param promise
     */
    @ReactMethod
    public void getUniqueLabelList(ReadableMap params, Promise promise){
        try{
            String layerName = params.getString("LayerName");
            WritableArray array = Arguments.createArray();
            if(layerName != null){
                Layer layer = SMThemeCartography.getLayerByName(layerName);
                if(layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.LABEL){
                    ThemeLabel themeLabel = (ThemeLabel)layer.getTheme();
                    ThemeLabelUniqueItems items = themeLabel.getUniqueItems();
                    int count = items.getCount();

                    for(int i = 0; i < count; i++){
                        ThemeLabelUniqueItem item = items.getItem(i);

                        String unique = item.getUnique();
                        boolean visible = item.isVisible();

                        TextStyle style = item.getStyle();
                        String styleXML = style.toXML();

                        Color color = style.getForeColor();
                        int r = color.getR();
                        int g = color.getG();
                        int b = color.getB();

                        WritableMap returnColor = Arguments.createMap();
                        returnColor.putInt("r",r);
                        returnColor.putInt("g",g);
                        returnColor.putInt("b",b);

                        WritableMap dic = Arguments.createMap();
                        dic.putString("style",styleXML);
                        dic.putString("title",unique);
                        dic.putMap("color",returnColor);
                        dic.putBoolean("visible",visible);

                        array.pushMap(dic);
                    }
                }
            }
            promise.resolve(array);
        }catch (Exception e){
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 用户自定义单值标签专题图
     * @param params
     * @param promise
     */
    @ReactMethod
    public void setCustomUniqueLabel(ReadableMap params, Promise promise){
        try{
            String layerName = params.getString("LayerName");
            ReadableArray rangeList = params.getArray("RangeList");
            if(layerName != null){
                Layer layer = SMThemeCartography.getLayerByName(layerName);
                if(layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.LABEL){
                    ThemeLabel themeLabel = (ThemeLabel)layer.getTheme();
                    ThemeLabelUniqueItems items = themeLabel.getUniqueItems();
                    items.clear();

                    TextStyle style = new TextStyle();

                    for(int i = 0; i < rangeList.size(); i++){
                        ReadableMap curItem = rangeList.getMap(i);
                        String unique = curItem.getString("title");
                        boolean visible = curItem.getBoolean("visible");
                        String styleXML = curItem.getString("style");
                        ReadableMap color = curItem.getMap("color");

                        int r = color.getInt("r");
                        int g = color.getInt("g");
                        int b = color.getInt("b");

                        style.fromXML(styleXML);
                        style.setForeColor(new Color(r,g,b));

                        ThemeLabelUniqueItem item = new ThemeLabelUniqueItem();
                        item.setUnique(unique);
                        item.setStyle(style);
                        item.setVisible(visible);

                        items.add(item);
                    }
                    SMap.getInstance().smMapWC.getMapControl().getMap().refresh();
                    promise.resolve(true);
                }
            }
        }catch (Exception e){
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
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

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
            if (readableMap.hasKey("RangeMode")){
                int mode = readableMap.getInt("RangeMode");
                rangeMode  = (RangeMode)Enum.parse(RangeMode.class, mode);
            }
            if (data.containsKey("RangeParameter")){
                String rangParam = data.get("RangeParameter").toString();
                rangeParameter  = Double.parseDouble(rangParam);
            } else {
                rangeParameter = 5;
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
                ThemeLabel themeLabel = ThemeLabel.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType);
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
     * 获取分段标签专题图的字段表达式
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getRangeLabelExpression(ReadableMap readableMap, Promise promise) {
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
                    ThemeLabel theme= (ThemeLabel) layer.getTheme();
                    String result = theme.getRangeExpression();
                    if (result!=null && !result.isEmpty()){
                        promise.resolve(result);
                    }else{
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
     * 设置分段标签专题图字段单值字段
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setRangeLabelExpression(ReadableMap readableMap, Promise promise) {
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
            if (data.containsKey("RangeExpression")){
                labelExpression = data.get("RangeExpression").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && labelExpression != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    themeLabel.setRangeExpression(labelExpression);

                    mapControl.getMap().refresh();

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
     * 设置分段标签专题图颜色方案
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setRangeLabelColorScheme(ReadableMap readableMap, Promise promise) {
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

            Color[] colors = null;
            if (data.containsKey("ColorScheme")) {
                String colorScheme = data.get("ColorScheme").toString();
                colors = SMThemeCartography.getRangeColors(colorScheme);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && colors != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel theme = (ThemeLabel) layer.getTheme();
                    //ThemeLabelRangeItems items = theme.getRangeItems();
                    int count = theme.getCount();
                    Colors selectedColors = Colors.makeGradient(count, colors);

                    for (int i = 0; i < count; i++) {
                        theme.getItem(i).getStyle().setForeColor( selectedColors.get(i) );
                    }
                    mapControl.getMap().refresh();

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
     * 获取分段标签专题图的子项列表
     * @param params
     * @param promise
     */
    @ReactMethod
    public void getRangeLabelList(ReadableMap params, Promise promise){
        try {
            String layerName = params.getString("LayerName");
            WritableArray array = Arguments.createArray();
            if(layerName != null){
                Layer layer = SMThemeCartography.getLayerByName(layerName);
                if(layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.LABEL){
                    ThemeLabel themeLabel = (ThemeLabel)layer.getTheme();

                    ThemeLabelRangeItems items = themeLabel.getRangeItems();
                    String startStr;
                    String endStr;
                    int count = items.getCount();
                    for(int i = 0; i < count; i++){
                        ThemeLabelRangeItem item = items.getItem(i);

                        boolean visible = item.isVisible();
                        double start = item.getStart();
                        double end = item.getEnd();

                        startStr = start  < -3.4e+038 ? "min" : start + "";
                        endStr = end  > 3.4e+038 ? "max" : end + "";

                        TextStyle style = item.getStyle();
                        String styleXML = style.toXML();

                        Color color = style.getForeColor();
                        int r = color.getR();
                        int g = color.getG();
                        int b = color.getB();

                        WritableMap returnColor = Arguments.createMap();
                        returnColor.putInt("r",r);
                        returnColor.putInt("g",g);
                        returnColor.putInt("b",b);

                        WritableMap map = Arguments.createMap();
                        map.putString("start",startStr);
                        map.putString("end",endStr);
                        map.putString("style",styleXML);
                        map.putBoolean("visible",visible);
                        map.putMap("color",returnColor);

                        array.pushMap(map);
                    }
                }
            }
            promise.resolve(array);
        }catch (Exception e){
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 用户自定义分段标签专题图
     * @param params
     * @param promise
     */
    @ReactMethod
    public void setCustomRangeLabel(ReadableMap params, Promise promise){
        try{
            boolean result = false;
            String layerName = params.getString("LayerName");
            ReadableArray rangeList = params.getArray("RangeList");
            if(layerName != null){
                Layer layer = SMThemeCartography.getLayerByName(layerName);
                if(layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.LABEL){
                    ThemeLabel themeLabel = (ThemeLabel)layer.getTheme();
                    ThemeLabelRangeItems items = themeLabel.getRangeItems();
                    int count = items.getCount();

                    items.clear();

                    TextStyle style = new TextStyle();
                    for(int i = 0; i < count; i++){
                        ReadableMap curItem = rangeList.getMap(i);

                        String startStr = curItem.getString("start");
                        String endStr = curItem.getString("end");
                        boolean visible = curItem.getBoolean("visible");
                        String styleXML = curItem.getString("style");

                        ReadableMap color = curItem.getMap("color");
                        int r = color.getInt("r");
                        int g = color.getInt("g");
                        int b = color.getInt("b");

                        style.fromXML(styleXML);
                        style.setForeColor(new Color(r,g,b));

                        ThemeLabelRangeItem item = new ThemeLabelRangeItem();

                        if(i != 0){
                            double start = Double.parseDouble(startStr);
                            item.setStart(start);
                        }
                        if(i != rangeList.size() - 1){
                            double end = Double.parseDouble(endStr);
                            item.setEnd(end);
                        }
                        item.setVisible(visible);
                        item.setStyle(style);

                        items.addToTail(item,true);
                    }
                    SMap.getInstance().smMapWC.getMapControl().getMap().refresh();
                    result = true;
                }
            }
            promise.resolve(result);
        }catch (Exception e){
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
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    themeLabel.setLabelExpression(labelExpression);

                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    themeLabel.setBackShape(labelBackShape);

                    mapControl.getMap().refresh();

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
     * 设置统一/分段标签专题图的字体
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setLabelFontName(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String type = "uniform"; // uniform | range
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
            if (data.containsKey("type")){
                type = data.get("type").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && fontName != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    int count;
                    if (type.equals("range")) {
                        count = themeLabel.getCount();
                    } else {
                        count = themeLabel.getUniqueItems().getCount();
                    }
                    if(count == 0){
                        TextStyle uniformStyle = themeLabel.getUniformStyle();
                        if(fontName.equals("BOLD")){
                            if(uniformStyle.isBold()){
                                uniformStyle.setBold(false);
                            }
                            else{
                                uniformStyle.setBold(true);
                            }
                        }else if(fontName.equals("ITALIC")){
                            if(uniformStyle.getItalic()){
                                uniformStyle.setItalic(false);
                            }else{
                                uniformStyle.setItalic(true);
                            }

                        }else if(fontName.equals("UNDERLINE")){
                            if(uniformStyle.getUnderline()){
                                uniformStyle.setUnderline(false);
                            }else{
                                uniformStyle.setUnderline(true);
                            }
                        }else if(fontName.equals("STRIKEOUT")){
                            if(uniformStyle.getStrikeout()){
                                uniformStyle.setStrikeout(false);
                            }else{
                                uniformStyle.setStrikeout(true);
                            }
                        }else if(fontName.equals("SHADOW")){
                            if(uniformStyle.getShadow()){
                                uniformStyle.setShadow(false);
                            }else{
                                uniformStyle.setShadow(true);
                            }
                        }else if(fontName.equals("OUTLINE")){
                            if(uniformStyle.getOutline()){
                                uniformStyle.setOutline(false);
                            }else{
                                uniformStyle.setOutline(true);
                                uniformStyle.setBackColor(new Color(255,255,255));
                            }
                        }
                    }else{
                        for (int i = 0; i < count; i++) {
                            TextStyle style;
                            if (type.equals("range")) {
                                style = themeLabel.getItem(i).getStyle();
                            } else {
                                style = themeLabel.getUniqueItems().getItem(i).getStyle();
                            }
                            if(fontName.equals("BOLD")){
                                if(style.isBold()){
                                    style.setBold(false);
                                }
                                else{
                                    style.setBold(true);
                                }
                            }else if(fontName.equals("ITALIC")){
                                if(style.getItalic()){
                                    style.setItalic(false);
                                }else{
                                    style.setItalic(true);
                                }

                            }else if(fontName.equals("UNDERLINE")){
                                if(style.getUnderline()){
                                    style.setUnderline(false);
                                }else{
                                    style.setUnderline(true);
                                }
                            }else if(fontName.equals("STRIKEOUT")){
                                if(style.getStrikeout()){
                                    style.setStrikeout(false);
                                }else{
                                    style.setStrikeout(true);
                                }
                            }else if(fontName.equals("SHADOW")){
                                if(style.getShadow()){
                                    style.setShadow(false);
                                }else{
                                    style.setShadow(true);
                                }
                            }else if(fontName.equals("OUTLINE")){
                                if(style.getOutline()){
                                    style.setOutline(false);
                                }else{
                                    style.setOutline(true);
                                    style.setBackColor(new Color(255,255,255));
                                }
                            }
                        }
                    }

                    mapControl.getMap().refresh();

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
     * 获取统一/分段标签专题图的字体
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getLabelFontName(ReadableMap readableMap, Promise promise) {
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
     * 设置统一/分段标签专题图的字号
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setLabelFontSize(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String type = "uniform"; // uniform | range
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
            if (data.containsKey("type")){
                type = data.get("type").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && fontSize != -1 && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    int count;
                    if (type.equals("range")) {
                        count = themeLabel.getCount();
                    } else {
                        count = themeLabel.getUniqueItems().getCount();
                    }
                    if(count == 0) {
                        TextStyle uniformStyle = themeLabel.getUniformStyle();
                        uniformStyle.setFontHeight(fontSize);
                    }else{
                        for (int i = 0; i < count; i++) {
                            TextStyle style;
                            if (type.equals("range")) {
                                style = themeLabel.getItem(i).getStyle();
                            } else {
                                style = themeLabel.getUniqueItems().getItem(i).getStyle();
                            }
                            style.setFontHeight(fontSize);
                        }
                    }


                    mapControl.getMap().refresh();

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
     * 获取统一/分段标签专题图的字号
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getLabelFontSize(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String type = "uniform"; // uniform | range
            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("type")){
                type = data.get("type").toString();
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
                    int count;
                    if (type.equals("range")) {
                        count = themeLabel.getCount();
                    } else {
                        count = themeLabel.getUniqueItems().getCount();
                    }
                    if(count == 0) {
                        TextStyle uniformStyle = themeLabel.getUniformStyle();
                        double fontHeight = uniformStyle.getFontHeight();

                        promise.resolve(fontHeight);
                    }else{
                        for (int i = 0; i < count; i++) {
                            TextStyle style;
                            if (type.equals("range")) {
                                style = themeLabel.getItem(i).getStyle();
                            } else {
                                style = themeLabel.getUniqueItems().getItem(i).getStyle();
                            }
                            double fontHeight = style.getFontHeight();

                            promise.resolve(fontHeight);
                            return;
                        }
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
     * 设置统一/分段标签专题图的旋转角度
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setLabelRotation(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String type = "uniform"; // uniform | range
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
            if (data.containsKey("type")){
                type = data.get("type").toString();
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && rotation != -1 && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.LABEL) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    int count;
                    if (type.equals("range")) {
                        count = themeLabel.getCount();
                    } else {
                        count = themeLabel.getUniqueItems().getCount();
                    }
                    if(count == 0) {
                        TextStyle uniformStyle = themeLabel.getUniformStyle();
                        double lastRotation = uniformStyle.getRotation();
                        if (lastRotation == 360.0) {
                            lastRotation = 0.0;
                        } else if (lastRotation == 0.0) {
                            lastRotation = 360.0;
                        }
                        uniformStyle.setRotation(lastRotation + rotation);
                    }else{
                        for (int i = 0; i < count; i++) {
                            TextStyle style;
                            if (type.equals("range")) {
                                style = themeLabel.getItem(i).getStyle();
                            } else {
                                style = themeLabel.getUniqueItems().getItem(i).getStyle();
                            }
                            double lastRotation = style.getRotation();
                            if (lastRotation == 360.0) {
                                lastRotation = 0.0;
                            } else if (lastRotation == 0.0) {
                                lastRotation = 360.0;
                            }
                            style.setRotation(lastRotation + rotation);
                        }
                    }

                    mapControl.getMap().refresh();

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
     * 获取统一/分段标签专题图的旋转角度
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void ThemeType(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String type = "uniform";
            String layerName = null;
            int layerIndex = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("type")){
                type = data.get("type").toString();
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
                    int count;
                    if (type.equals("range")) {
                        count = themeLabel.getCount();
                    } else {
                        count = themeLabel.getUniqueItems().getCount();
                    }
                    if(count == 0) {
                        TextStyle uniformStyle = themeLabel.getUniformStyle();
                        double rotation = uniformStyle.getRotation();

                        promise.resolve(rotation);
                    }else{
                        for (int i = 0; i < count; i++) {
                            TextStyle style;
                            if (type.equals("range")) {
                                style = themeLabel.getItem(i).getStyle();
                            } else {
                                style = themeLabel.getUniqueItems().getItem(i).getStyle();
                            }
                            double rotation = style.getRotation();

                            promise.resolve(rotation);
                            return;
                        }
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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    TextStyle uniformStyle = themeLabel.getUniformStyle();
                    uniformStyle.setForeColor(ColorParseUtil.getColor(color));

                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();
                    GeoStyle backStyle = themeLabel.getBackStyle();
                    backStyle.setFillForeColor(ColorParseUtil.getColor(color));

                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

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
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

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
            if (readableMap.hasKey("RangeMode")){
                int mode = readableMap.getInt("RangeMode");
                rangeMode  = (RangeMode)Enum.parse(RangeMode.class, mode);
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
            double rangeParameter = -1;//分段参数--当分段方法为标准差时，此参数无效，因为标准差分段方法所得的“段数”由计算结果决定，用户不可控制。
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

            if (readableMap.hasKey("RangeMode")){
                int mode = readableMap.getInt("RangeMode");
                rangeMode  = (RangeMode)Enum.parse(RangeMode.class, mode);
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
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                ThemeRange tr = ThemeRange.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType);
                if (tr != null){
                    if (!data.containsKey("ColorGradientType")) {
                        Color[] colors = SMThemeCartography.getLastThemeColors(themeRangeLayer);
                        if(colors == null){
                            colors = new Color[themeRange.getCount()];
                            for (int i = 0; i < themeRange.getCount(); i++) {
                               Color c = SMThemeCartography.getGeoStyleColor(dataset.getType(), themeRange.getItem(i).getStyle());
                               colors[i] = c;
                            }

                        }
                        if (colors != null) {
                            int rangeCount = tr.getCount();
                            Colors selectedColors = Colors.makeGradient(rangeCount, colors);
                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setGeoStyleColor(dataset.getType(), tr.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        }
                    }
                    themeRangeLayer.getTheme().fromXML(tr.toXML());
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

    @ReactMethod
    public void modifyThemeLabelRangeMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String rangeExpression = null;//分段字段表达式
            RangeMode rangeMode = null;//分段模式
            double rangeParameter = -1;//分段参数--当分段方法为标准差时，此参数无效，因为标准差分段方法所得的“段数”由计算结果决定，用户不可控制。
            ColorGradientType colorGradientType = null;
            String layerName = null;
            double fontSize = -1;
            String fontName = null;//字体名称
            boolean isBold = false;
            boolean isItalic = false;
            boolean isUnderline = false;
            boolean isStrikeout = false;
            boolean isShadow = false;
            boolean isOutline = false;

            if (data.containsKey("LayerName")) {
                layerName = data.get("LayerName").toString();
            }
            Layer themeLayer = SMThemeCartography.getLayerByName(layerName);
            Dataset dataset = null;
            if (themeLayer != null) {
                dataset = themeLayer.getDataset();
            }

            ThemeLabel themelabel = null;
            if (themeLayer != null && themeLayer.getTheme() != null && themeLayer.getTheme().getType() == ThemeType.LABEL) {
                themelabel = (ThemeLabel) themeLayer.getTheme();
                if (themelabel.getRangeExpression().isEmpty() || themelabel.getCount() == 0) {
                    themelabel = null;
                }
            }

            if (data.containsKey("RangeExpression")){
                rangeExpression  = data.get("RangeExpression").toString();
                if(themelabel != null){
                    themelabel.setRangeExpression(rangeExpression);
                }
            } else {
                if (themelabel != null) {
                    rangeExpression = themelabel.getRangeExpression();
                }
            }

            if (readableMap.hasKey("RangeMode")){
                int mode = readableMap.getInt("RangeMode");
                rangeMode = (RangeMode)Enum.parse(RangeMode.class, mode);
            } else {
                if (themelabel != null) {
                    rangeMode = themelabel.getRangeMode();
                }
            }

            if (data.containsKey("RangeParameter")){
                String rangParam = data.get("RangeParameter").toString();
                rangeParameter  = Double.parseDouble(rangParam) <= 0 ? 1: Double.parseDouble(rangParam);
            } else {
                if (themelabel != null) {
                    rangeParameter = themelabel.getCount();
                }
            }

            if (data.containsKey("ColorGradientType")){
                String type = data.get("ColorGradientType").toString();
                colorGradientType = SMThemeCartography.getColorGradientType(type);
            } else {
                colorGradientType = ColorGradientType.GREENWHITE;
            }

            if (themelabel != null && themelabel.getCount() > 0) {
                TextStyle style = themelabel.getItem(0).getStyle();
                fontSize = style.getFontHeight();
                fontName = style.getFontName();
                isBold = style.isBold();
                isItalic = style.getItalic();
                isUnderline = style.getUnderline();
                isStrikeout = style.getStrikeout();
                isShadow = style.getShadow();
                isOutline = style.getOutline();
            }

            boolean result = false;
            if (dataset != null && themeLayer.getTheme() != null && rangeExpression != null && rangeMode != null && rangeParameter != -1 && colorGradientType != null) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                ThemeLabel tr = ThemeLabel.makeDefault((DatasetVector) dataset, rangeExpression, rangeMode, rangeParameter, colorGradientType);
                if (tr != null){
                    if (!data.containsKey("ColorGradientType")) {
                        Color[] colors = SMThemeCartography.getLastThemeColors(themeLayer);
                        if(colors == null){
                            colors = new Color[themelabel.getCount()];
                            for (int i = 0; i < themelabel.getCount(); i++) {
                                TextStyle itemStyle = themelabel.getItem(i).getStyle();
                                Color c = itemStyle.getForeColor();
                                colors[i] = c;
                            }

                        }
                        if (colors != null) {
                            int rangeCount = tr.getCount();
                            Colors selectedColors = Colors.makeGradient(rangeCount, colors);
                            for (int i = 0; i < rangeCount; i++) {
                                SMThemeCartography.setItemTextStyleColor(tr.getItem(i).getStyle(), selectedColors.get(i));
                            }
                        }
                    }
                    //themeLayer.getTheme().fromXML(tr.toXML());
                    themelabel.clear();
                    for(int i=0;i<tr.getCount();i++){
                        ThemeLabelItem itemTemp = tr.getItem(i);
                        TextStyle itemStyle = itemTemp.getStyle();
                        itemStyle.setFontHeight(fontSize);
                        itemStyle.setFontName(fontName);
                        itemStyle.setBold(isBold);
                        itemStyle.setItalic(isItalic);
                        itemStyle.setUnderline(isUnderline);
                        itemStyle.setStrikeout(isStrikeout);
                        itemStyle.setShadow(isShadow);
                        itemStyle.setOutline(isOutline);
                        if (isOutline) itemStyle.setBackColor(new Color(255,255,255));
                        themelabel.addToTail(itemTemp,true);
                    }

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
                _colorScheme = colorScheme; // 记录单值专题图颜色方案
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && rangeColors != null && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.UNIQUE) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeUnique themeUnique = (ThemeUnique) layer.getTheme();
                    int rangeCount = themeUnique.getCount();
                    Colors selectedColors = Colors.makeGradient(rangeCount, rangeColors);

//                    lastUniqueColors = new Color[rangeCount];
                    for (int i = 0; i < rangeCount; i++) {
                        SMThemeCartography.setGeoStyleColor(layer.getDataset().getType(), themeUnique.getItem(i).getStyle(), selectedColors.get(i));
//                        lastUniqueColors[i] = selectedColors.get(i);
                    }
                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeRange themeRange = (ThemeRange) layer.getTheme();
                    int rangeCount = themeRange.getCount();
                    Colors selectedColors = Colors.makeGradient(rangeCount, rangeColors);

                    for (int i = 0; i < rangeCount; i++) {
                        SMThemeCartography.setGeoStyleColor(layer.getDataset().getType(), themeRange.getItem(i).getStyle(), selectedColors.get(i));
                    }
                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeRange themeRange = (ThemeRange) layer.getTheme();
                    themeRange.setRangeExpression(rangeExpression);

                    mapControl.getMap().refresh();

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
                } else if (layer.getTheme().getType() == ThemeType.LABEL) {
                    ThemeLabel themeLabel = (ThemeLabel) layer.getTheme();

                    promise.resolve(themeLabel.getCount());
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
     * 获取分段专题图分段信息
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getRangeList(ReadableMap readableMap, Promise promise){
        try{
            String layerName = null;
            int layerIndex = -1;

            if (readableMap.hasKey("LayerName")){
                layerName = readableMap.getString("LayerName");
            }
            if (readableMap.hasKey("LayerIndex")){
                layerIndex = readableMap.getInt("LayerIndex");
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.RANGE) {
                WritableArray array = Arguments.createArray();
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();
                    int count = themeRange.getCount();
                    String startStr;
                    String endStr;
                    for(int i = 0; i < count; i++){
                        ThemeRangeItem item = themeRange.getItem(i);

                        double start = item.getStart();
                        double end = item.getEnd();

                        startStr = start  < -3.4e+038 ? "min" : start + "";
                        endStr = end  > 3.4e+038 ? "max" : end + "";

                        GeoStyle style = item.getStyle();

                        Color color = style.getFillForeColor();

                        int r = color.getR();
                        int g = color.getG();
                        int b = color.getB();

                        WritableMap colors = Arguments.createMap();
                        colors.putInt("r",r);
                        colors.putInt("g",g);
                        colors.putInt("b",b);

                        Boolean isVisible = item.isVisible();

                        WritableMap map = Arguments.createMap();
                        map.putString("start",startStr);
                        map.putString("end",endStr);
                        map.putMap("color",colors);
                        map.putBoolean("visible",isVisible);

                        array.pushMap(map);
                    }
                promise.resolve(array);
            } else {
                promise.resolve(false);
            }
        }catch (Exception e){
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /**
     * 设置用户自定义分段信息
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setCustomThemeRange(ReadableMap readableMap, Promise promise){
        try{
            String layerName = readableMap.getString("LayerName");
            ReadableArray rangeList = readableMap.getArray("RangeList");

            Layer layer;
            if(layerName != null){
                layer = SMThemeCartography.getLayerByName(layerName);
                if(layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.RANGE){
                    ThemeRange themeRange = (ThemeRange)layer.getTheme();
                    themeRange.clear();

                    GeoStyle style = new GeoStyle();
                    style.setFillGradientAngle(0);
                    style.setFillGradientMode(FillGradientMode.NONE);
                    style.setFillGradientOffsetRatioX(0);
                    style.setFillGradientOffsetRatioY(0);
                    style.setFillOpaqueRate(100);
                    style.setFillSymbolID(0);
                    style.setLineSymbolID(0);
                    style.setLineWidth(0.1);
                    style.setMarkerAngle(0);
                    style.setMarkerSymbolID(0);
                    style.setMarkerSize(new Size2D(28,28));

                    for(int i = 0; i < rangeList.size(); i++){
                        ReadableMap curItem = rangeList.getMap(i);

                        String startStr = curItem.getString("start");
                        String endStr = curItem.getString("end");
                        Boolean visible = curItem.getBoolean("visible");

                        ReadableMap color = curItem.getMap("color");

                        int r = color.getInt("r");
                        int g = color.getInt("g");
                        int b = color.getInt("b");

                        style.setFillForeColor(new Color(r,g,b));
                        style. setLineColor(new Color(r,g,b));

                        ThemeRangeItem item = new ThemeRangeItem();

                        if(i != 0){
                            double start = Double.parseDouble(startStr);
                            item.setStart(start);
                        }
                        if(i != rangeList.size() - 1){
                            double end = Double.parseDouble(endStr);
                            item.setEnd(end);
                        }

                        item.setVisible(visible);
                        item.setStyle(style);

                        themeRange.addToTail(item);
                    }
                    SMap.getInstance().smMapWC.getMapControl().getMap().refresh();
                    promise.resolve(true);
                }
            }else{
                promise.resolve(false);
            }
        }catch (Exception e){
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }
     /*栅格分段专题图
    * ********************************************************************************************/
    /**
     * 数据集->创建栅格分段专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createThemeGridRangeMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;

            String datasetName = null;//数据集名称
            Color[] colors = null;//颜色方案

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("GridRangeColorScheme")){
                String type = data.get("GridRangeColorScheme").toString();
                colors = SMThemeCartography.getRangeColors(type);
            } else {
                colors = SMThemeCartography.getRangeColors("FF_Blues");//默认
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

            WritableMap writableMap = SMThemeCartography.createThemeGridRangeMap(dataset, colors);
            promise.resolve(writableMap);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 图层->创建栅格分段专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createThemeGridRangeMapByLayer(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;//图层名称
            int layerIndex = -1;
            Color[] colors = null;//颜色方案

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            } else if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("GridRangeColorScheme")){
                String type = data.get("GridRangeColorScheme").toString();
                colors = SMThemeCartography.getRangeColors(type);
            } else {
                colors = SMThemeCartography.getRangeColors("FF_Blues");//默认
            }

            Layer layer = null;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }
            Dataset dataset = null;
            if (layer != null) {
                dataset = layer.getDataset();
            }

            WritableMap writableMap = SMThemeCartography.createThemeGridRangeMap(dataset, colors);
            promise.resolve(writableMap);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 修改栅格分段专题图(分段方法，分段参数，颜色方案)
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void modifyThemeGridRangeMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            RangeMode rangeMode = null;//分段方法：等距，平方根，对数
            double rangeParameter = -1;
            Color[] colors = null;//颜色方案


            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            } else if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (readableMap.hasKey("RangeMode")){
                int mode = readableMap.getInt("RangeMode");
                rangeMode  = (RangeMode)Enum.parse(RangeMode.class, mode);
            }
            if (data.containsKey("RangeParameter")){
                String param = data.get("RangeParameter").toString();
                rangeParameter = Double.parseDouble(param);
            }
            if (data.containsKey("GridRangeColorScheme")){
                String type = data.get("GridRangeColorScheme").toString();
                colors = SMThemeCartography.getRangeColors(type);
            }

            Layer layer = null;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            boolean result = SMThemeCartography.modifyThemeGridRangeMap(layer, rangeMode, rangeParameter, colors);
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取栅格分段专题图的分段数
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getGridRangeCount(ReadableMap readableMap, Promise promise) {
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
                if (layer.getTheme().getType() == ThemeType.GRIDRANGE) {
                    ThemeGridRange themeGridRange = (ThemeGridRange) layer.getTheme();

                    promise.resolve(themeGridRange.getCount());
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


    /*栅格单值专题图
     * ********************************************************************************************/
    /**
     * 数据集->创建栅格单值专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createThemeGridUniqueMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;

            String datasetName = null;//数据集名称
            Color[] colors = null;//颜色方案

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("GridUniqueColorScheme")){
                String type = data.get("GridUniqueColorScheme").toString();
                colors = SMThemeCartography.getUniqueColors(type);
            } else {
                colors = SMThemeCartography.getUniqueColors("EE_Lake");//默认
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

            WritableMap writableMap = SMThemeCartography.createThemeGridUniqueMap(dataset, colors);
            promise.resolve(writableMap);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 图层->创建栅格单值专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createThemeGridUniqueMapByLayer(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;//图层名称
            int layerIndex = -1;
            Color[] colors = null;//颜色方案

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            } else if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("GridUniqueColorScheme")){
                String type = data.get("GridUniqueColorScheme").toString();
                colors = SMThemeCartography.getUniqueColors(type);
            } else {
                colors = SMThemeCartography.getUniqueColors("EE_Lake");//默认
            }

            Layer layer = null;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }
            Dataset dataset = null;
            if (layer != null) {
                dataset = layer.getDataset();
            }

            WritableMap writableMap = SMThemeCartography.createThemeGridUniqueMap(dataset, colors);
            promise.resolve(writableMap);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置栅格单值专题图层的特殊值。
     * 设置栅格单值专题图的默认颜色，对于那些未在栅格单值专题图子项之列的对象使用该颜色显示。
     * 设置栅格单值专题图层特殊值的颜色。
     * 设置栅格单值专题图层的特殊值所处区域是否透明。
     * 设置颜色方案。
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void modifyThemeGridUniqueMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            int specialValue = -1;
            Color defaultColor = null;
            Color specialValueColor = null;

            boolean isParams = false;
            boolean isTransparent = false;//特殊值透明显示：默认false

            Color[] colors = null;//颜色方案

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            } else if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("SpecialValue")){
                String value = data.get("SpecialValue").toString();
                specialValue = Integer.parseInt(value);
            }
            if (data.containsKey("DefaultColor")){
                String color = data.get("DefaultColor").toString();
                defaultColor = ColorParseUtil.getColor(color);
            }
            if (data.containsKey("SpecialValueColor")){
                String color = data.get("SpecialValueColor").toString();
                specialValueColor = ColorParseUtil.getColor(color);
            }
            if (data.containsKey("SpecialValueTransparent")){
                isParams = true;
                String specialValueTransparent = data.get("SpecialValueTransparent").toString();
                isTransparent = Boolean.parseBoolean(specialValueTransparent);
            }
            if (data.containsKey("GridUniqueColorScheme")){
                String type = data.get("GridUniqueColorScheme").toString();
                colors = SMThemeCartography.getUniqueColors(type);
            }

            Layer layer = null;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            boolean result = SMThemeCartography.modifyThemeGridUniqueMap(layer, colors, specialValue, defaultColor, specialValueColor ,isParams, isTransparent);
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /*统计专题图
     * ********************************************************************************************/
    /**
     * 数据集->新建统计专题图层
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createThemeGraphMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

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

            boolean result = SMThemeCartography.createThemeGraphMap(dataset, graphExpressions, themeGraphType, colors);
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 图层->新建统计专题图层
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createThemeGraphMapByLayer(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;//图层名称
            int layerIndex = -1;
            ArrayList<String> graphExpressions = null;//字段表达式
            ThemeGraphType themeGraphType = null;//统计图类型
            Color[] colors = null;//颜色方案

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
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

            Layer layer = null;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }
            Dataset dataset = null;
            if (layer != null) {
                dataset = layer.getDataset();
            }

            boolean result = SMThemeCartography.createThemeGraphMap(dataset, graphExpressions, themeGraphType, colors);
            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置统计专题图的最大显示值
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setGraphMaxValue(ReadableMap readableMap, Promise promise) {
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

            double maxValue = -1;//倍数

            if (data.containsKey("MaxValue")){
                String value = data.get("MaxValue").toString();
                maxValue  = Double.parseDouble(value);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && maxValue >= 1 && layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.GRAPH) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    Double[] sizes = SMThemeCartography.getMaxMinGraphSize();
                    themeGraph.setMaxGraphSize(sizes[0] * maxValue);
                    themeGraph.setMinGraphSize(sizes[1]);

                    mapControl.getMap().refresh();

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
     * 获取统计专题图的最大显示值
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getGraphMaxValue(ReadableMap readableMap, Promise promise) {
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
                if (layer.getTheme().getType() == ThemeType.GRAPH) {
                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    Double[] sizes = SMThemeCartography.getMaxMinGraphSize();
                    double maxGraphSize = themeGraph.getMaxGraphSize();

                    double maxSize = 1;
                    if (maxGraphSize / sizes[0] < 1) {
                        maxSize = 1;
                    } else if ((maxGraphSize / sizes[0]) > 20 ) {
                        maxSize = 20;
                    } else {
                        maxSize = (maxGraphSize / sizes[0]);
                    }

                    promise.resolve(maxSize);
                }
            } else {
                promise.resolve(1);
            }
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

            Layer themeGraphLayer;
            if (layerName != null) {
                themeGraphLayer = SMThemeCartography.getLayerByName(layerName);
            } else {
                themeGraphLayer = SMThemeCartography.getLayerByIndex(layerIndex);
            }


            if (themeGraphLayer != null && graphExpressions != null && graphExpressions.size() > 0 && themeGraphLayer.getTheme() != null) {
                if (themeGraphLayer.getTheme().getType() == ThemeType.GRAPH) {
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeGraph themeGraph = (ThemeGraph) themeGraphLayer.getTheme();
                    int count = themeGraph.getCount();
                    ArrayList<String> listExpression = new ArrayList<>();
                    for (int i = 0; i < count; i++) {
                        listExpression.add(themeGraph.getItem(i).getGraphExpression());
                    }

                    ArrayList<String> listremovedExpressions = new ArrayList<>();//移除的表达式
                    for (int i = 0; i < count; i++) {
                        String expression = themeGraph.getItem(i).getGraphExpression();
                        if (!graphExpressions.contains(expression)) {
                            listremovedExpressions.add(expression);
                        }
                    }

                    ArrayList<String> listAddedExpressions = new ArrayList<>();//新增的表达式
                    for (int i = 0; i < graphExpressions.size(); i++) {
                        String expression = graphExpressions.get(i);
                        if (!listExpression.contains(expression)) {
                            listAddedExpressions.add(expression);
                        }
                    }

                    if (listremovedExpressions.size() > 0 || listAddedExpressions.size() > 0) {
                        Color[] colors = SMThemeCartography.getLastThemeColors(themeGraphLayer);
                        if (colors != null) {
                            lastGraphColors = colors;
                        } else {
                            if (lastGraphColors != null) {
                                colors = lastGraphColors;
                            } else {
                                colors = SMThemeCartography.getGraphColors("HA_Calm");//默认
                            }
                        }
                        Colors selectedColors = Colors.makeGradient(colors.length, colors);

                        //移除
                        for (int i = 0; i < listremovedExpressions.size(); i++) {
                            themeGraph.remove(themeGraph.indexOf(listremovedExpressions.get(i)));
                        }
                        //防止因为修改字段表达式造成的颜色值重复，遍历设置每个子项的颜色值
                        for (int i = 0; i < themeGraph.getCount(); i++) {
                            int index = i;
                            if (index >= selectedColors.getCount()) {
                                index = index % selectedColors.getCount();
                            }
                            themeGraph.getItem(i).getUniformStyle().setFillForeColor(selectedColors.get(index));
                        }
                        //添加
                        for (int i = 0; i < listAddedExpressions.size(); i++) {
                            SMThemeCartography.addGraphItem(themeGraph, listAddedExpressions.get(i), selectedColors);
                        }
                        mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

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
                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    themeGraph.setGraphType(themeGraphType);

                    mapControl.getMap().refresh();

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
                    MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                    mapControl.getEditHistory().addMapHistory();

                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    themeGraph.setGraduatedMode(graduatedMode);

                    mapControl.getMap().refresh();

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
     * 获取统计专题图的表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getGraphExpressions(ReadableMap readableMap, Promise promise) {
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
                if (layer.getTheme().getType() == ThemeType.GRAPH) {
                    ThemeGraph themeGraph = (ThemeGraph) layer.getTheme();
                    WritableArray array = Arguments.createArray();
                    for (int i = 0; i < themeGraph.getCount(); i++) {
                        array.pushString(themeGraph.getItem(i).getGraphExpression());
                    }

                    WritableMap writableMap = Arguments.createMap();
                    writableMap.putArray("list", array);
                    promise.resolve(writableMap);
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


    /**点密度专题图*************************************************************************************/
    /**
     * 新建点密度专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createDotDensityThemeMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;

            String datasetName = null;
            String dotExpression = null;//字段表达式
            Color lineColor = null;
            double value = -1;

            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("DotExpression")){
                dotExpression  = data.get("DotExpression").toString();
            }
            if (data.containsKey("LineColor")){
                String color = data.get("LineColor").toString();
                lineColor = ColorParseUtil.getColor(color);
            } else {
                lineColor = new Color(255,165,0,0);
            }
            if (data.containsKey("Value")){
                String valueParam = data.get("Value").toString();
                value  = Double.parseDouble(valueParam);
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
            if (dataset != null && dotExpression != null) {
                ThemeDotDensity themeDotDensity = new ThemeDotDensity();
                if (themeDotDensity != null) {
                    themeDotDensity.setDotExpression(dotExpression);
                    GeoStyle geoStyle = new GeoStyle();
                    geoStyle.setMarkerSize(new Size2D(2,2));
                    geoStyle.setLineColor(lineColor);
                    themeDotDensity.setStyle(geoStyle);
                    if (value != -1) {
                        themeDotDensity.setValue(value);
                    } else {
                        double maxValue = SMThemeCartography.getMaxValue((DatasetVector)dataset, dotExpression);
                        themeDotDensity.setValue(maxValue / 1000);
                    }

                    mapControl.getMap().getLayers().add(dataset, themeDotDensity, true);
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
     * 修改点密度专题图：设置点密度图的表达式，单点代表的值，点风格（符号，大小和颜色）。
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void modifyDotDensityThemeMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            String dotExpression = null;
            double value = -1;
            double dotSize = -1;
            Color lineColor = null;
            int symbolID = -1;


            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            if (data.containsKey("DotExpression")){
                dotExpression  = data.get("DotExpression").toString();
            }
            if (data.containsKey("Value")){
                String valueParam = data.get("Value").toString();
                value  = Double.parseDouble(valueParam);
            }
            if (data.containsKey("SymbolSize")){
                String size = data.get("SymbolSize").toString();
                dotSize  = Double.parseDouble(size);
            }
            if (data.containsKey("LineColor")){
                String color = data.get("LineColor").toString();
                lineColor = ColorParseUtil.getColor(color);
            }
            if (data.containsKey("SymbolID")) {
                String id = data.get("SymbolID").toString();
                symbolID = (int)Double.parseDouble(id);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.DOTDENSITY) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                ThemeDotDensity themeDotDensity = (ThemeDotDensity) layer.getTheme();
                if (dotExpression != null) {
                    themeDotDensity.setDotExpression(dotExpression);
                }
                if (value != -1) {
                    themeDotDensity.setValue(value);
                }
                if (dotSize != -1) {
                    themeDotDensity.getStyle().setMarkerSize(new Size2D(dotSize, dotSize));
                }
                if (lineColor != null) {
                    themeDotDensity.getStyle().setMarkerSymbolID(0);
                    themeDotDensity.getStyle().setLineColor(lineColor);
                }
                if (symbolID != -1) {
                    themeDotDensity.getStyle().setMarkerSymbolID(symbolID);
                }

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
     * 获取点密度专题图的表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getDotDensityExpression(ReadableMap readableMap, Promise promise) {
        try {
            ThemeDotDensity themeDotDensity = SMThemeCartography.getThemeDotDensity(readableMap);
            if (themeDotDensity != null) {
                promise.resolve(themeDotDensity.getDotExpression());
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
     * 获取点密度专题图的单点代表值
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getDotDensityValue(ReadableMap readableMap, Promise promise) {
        try {
            ThemeDotDensity themeDotDensity = SMThemeCartography.getThemeDotDensity(readableMap);
            if (themeDotDensity != null) {
                promise.resolve(themeDotDensity.getValue());
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
     * 获取点密度专题图的点符号大小
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getDotDensityDotSize(ReadableMap readableMap, Promise promise) {
        try {
            ThemeDotDensity themeDotDensity = SMThemeCartography.getThemeDotDensity(readableMap);
            if (themeDotDensity != null) {
                Size2D markerSize = themeDotDensity.getStyle().getMarkerSize();
                promise.resolve(markerSize.getHeight());
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**等级符号专题图*************************************************************************************/
    /**
     * 新建等级符号专题图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createGraduatedSymbolThemeMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;

            GraduatedMode graduatedMode = null;
            String datasetName = null;
            String graSymbolExpression = null;//字段表达式

            Color lineColor = null;
            double symbolSize = -1;

            if (data.containsKey("GraduatedMode")){
                String mode  = data.get("GraduatedMode").toString();
                graduatedMode = SMThemeCartography.getGraduatedMode(mode);
            }
            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("GraSymbolExpression")){
                graSymbolExpression  = data.get("GraSymbolExpression").toString();
            }

            if (data.containsKey("LineColor")){
                String color = data.get("LineColor").toString();
                lineColor = ColorParseUtil.getColor(color);
            } else {
                lineColor = new Color(255,165,0,0);
            }
            if (data.containsKey("SymbolSize")){
                String size = data.get("SymbolSize").toString();
                symbolSize  = Double.parseDouble(size);
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
            if (dataset != null && graSymbolExpression != null) {
                ThemeGraduatedSymbol themeGraduatedSymbol = null;
                if (graduatedMode != null) {
                    themeGraduatedSymbol  = ThemeGraduatedSymbol.makeDefault((DatasetVector)dataset, graSymbolExpression, graduatedMode);
                } else {
                    themeGraduatedSymbol = ThemeGraduatedSymbol.makeDefault((DatasetVector)dataset, graSymbolExpression, GraduatedMode.CONSTANT);
                }
                if (themeGraduatedSymbol == null) {
                    themeGraduatedSymbol = new ThemeGraduatedSymbol();
                }
                themeGraduatedSymbol.setFlowEnabled(true);//流动显示
                themeGraduatedSymbol.setExpression(graSymbolExpression);
                themeGraduatedSymbol.getPositiveStyle().setLineColor(lineColor);
                if (symbolSize != -1) {
                    themeGraduatedSymbol.getPositiveStyle().setMarkerSize(new Size2D(symbolSize,symbolSize));
                }

                mapControl.getMap().getLayers().add(dataset, themeGraduatedSymbol, true);
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
     * 修改等级符号专题图：设置表达式，分级方式，基准值，正值基准值风格（大小和颜色）。
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void modifyGraduatedSymbolThemeMap(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;

            String graSymbolExpression = null;
            GraduatedMode graduatedMode = null;
            double baseValue = -1;//基准值
            double symbolSize = -1;
            Color lineColor = null;
            int symbolID = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }

            if (data.containsKey("GraSymbolExpression")){
                graSymbolExpression  = data.get("GraSymbolExpression").toString();
            }
            if (data.containsKey("GraduatedMode")){
                String mode  = data.get("GraduatedMode").toString();
                graduatedMode = SMThemeCartography.getGraduatedMode(mode);
            }
            if (data.containsKey("BaseValue")){
                String valueParam = data.get("BaseValue").toString();
                baseValue  = Double.parseDouble(valueParam);
            }
            if (data.containsKey("SymbolSize")){
                String size = data.get("SymbolSize").toString();
                symbolSize  = Double.parseDouble(size);
            }
            if (data.containsKey("LineColor")){
                String color = data.get("LineColor").toString();
                lineColor = ColorParseUtil.getColor(color);
            }
            if (data.containsKey("SymbolID")) {
                String id = data.get("SymbolID").toString();
                symbolID = (int)Double.parseDouble(id);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && layer.getTheme() != null && layer.getTheme().getType() == ThemeType.GRADUATEDSYMBOL) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                ThemeGraduatedSymbol themeGraduatedSymbol = (ThemeGraduatedSymbol) layer.getTheme();
                if (graSymbolExpression != null) {
                    themeGraduatedSymbol.setExpression(graSymbolExpression);
                }
                if (graduatedMode != null) {
                    themeGraduatedSymbol.setGraduatedMode(graduatedMode);
                }
                if (baseValue != -1) {
                    themeGraduatedSymbol.setBaseValue(baseValue);
                }
                if (symbolSize != -1) {
                    themeGraduatedSymbol.getPositiveStyle().setMarkerSize(new Size2D(symbolSize, symbolSize));
                }
                if (lineColor != null) {
                    themeGraduatedSymbol.getPositiveStyle().setMarkerSymbolID(0);
                    themeGraduatedSymbol.getPositiveStyle().setLineColor(lineColor);
                }
                if (symbolID != -1) {
                    themeGraduatedSymbol.getPositiveStyle().setMarkerSymbolID(symbolID);
                }

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
     * 获取等级符号专题图的表达式
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getGraduatedSymbolExpress(ReadableMap readableMap, Promise promise) {
        try {
            ThemeGraduatedSymbol themeGraduatedSymbol = SMThemeCartography.getThemeGraduatedSymbol(readableMap);
            if (themeGraduatedSymbol != null) {
                promise.resolve(themeGraduatedSymbol.getExpression());
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
     * 获取等级符号专题图的基准值
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getGraduatedSymbolValue(ReadableMap readableMap, Promise promise) {
        try {
            ThemeGraduatedSymbol themeGraduatedSymbol = SMThemeCartography.getThemeGraduatedSymbol(readableMap);
            if (themeGraduatedSymbol != null) {
                promise.resolve(themeGraduatedSymbol.getBaseValue());
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
     * 获取等级符号专题图的符号大小
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getGraduatedSymbolSize(ReadableMap readableMap, Promise promise) {
        try {
            ThemeGraduatedSymbol themeGraduatedSymbol = SMThemeCartography.getThemeGraduatedSymbol(readableMap);
            if (themeGraduatedSymbol != null) {
                Size2D markerSize = themeGraduatedSymbol.getPositiveStyle().getMarkerSize();
                promise.resolve(markerSize.getHeight());
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /*热力图
     * ********************************************************************************************/
    /**
     * 数据集->新建热力图层
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void createHeatMap(ReadableMap readableMap, Promise promise) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            mapControl.getEditHistory().addMapHistory();

            HashMap<String, Object> data = readableMap.toHashMap();

            int datasourceIndex = -1;
            String datasourceAlias = null;

            String datasetName = null;//数据集名称
            int KernelRadius = 20;//核半径
            double FuzzyDegree = 0.1;//颜色渐变模糊度
            double Intensity = 0.1;//最大颜色权重
            Color[] colors = null;//颜色方案


            if (data.containsKey("DatasetName")){
                datasetName = data.get("DatasetName").toString();
            }
            if (data.containsKey("KernelRadius")){
                KernelRadius  = Integer.parseInt(data.get("KernelRadius").toString());
            }
            if (data.containsKey("FuzzyDegree")){
                FuzzyDegree  = Double.parseDouble(data.get("FuzzyDegree").toString());
            }
            if (data.containsKey("Intensity")){
                Intensity  = Double.parseDouble(data.get("Intensity").toString());
            }
            if (data.containsKey("ColorType")){
                String type = data.get("ColorType").toString();
                colors = SMThemeCartography.getAggregationColors(type);
            } else {
                colors = SMThemeCartography.getAggregationColors("BA_Rainbow");//默认
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

            if(dataset.getType()!=DatasetType.POINT){
                promise.reject("TypeError");
                return;
            }
            WritableMap writableMap = SMThemeCartography.createLayerHeatMap(dataset, KernelRadius, FuzzyDegree,Intensity, colors);
            promise.resolve(writableMap);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

//    /**
//     * 图层->新建热力图层
//     *
//     * @param readableMap
//     * @param promise
//     */
//    @ReactMethod
//    public void createHeatMapByLayer(ReadableMap readableMap, Promise promise) {
//        try {
//            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
//            mapControl.getEditHistory().addMapHistory();
//
//            HashMap<String, Object> data = readableMap.toHashMap();
//
//            String layerName = null;//图层名称
//            int layerIndex = -1;
//            ArrayList<String> graphExpressions = null;//字段表达式
//            ThemeGraphType themeGraphType = null;//统计图类型
//            Color[] colors = null;//颜色方案
//
//            if (data.containsKey("LayerName")){
//                layerName = data.get("LayerName").toString();
//            }
//            if (data.containsKey("LayerIndex")){
//                String index = data.get("LayerIndex").toString();
//                layerIndex = Integer.parseInt(index);
//            }
//            if (data.containsKey("GraphExpressions")){
//                graphExpressions  = (ArrayList<String>) data.get("GraphExpressions");
//            }
//            if (data.containsKey("ThemeGraphType")){
//                String type = data.get("ThemeGraphType").toString();
//                themeGraphType  = SMThemeCartography.getThemeGraphType(type);
//            }
//            if (data.containsKey("GraphColorType")){
//                String type = data.get("GraphColorType").toString();
//                colors = SMThemeCartography.getGraphColors(type);
//            } else {
//                colors = SMThemeCartography.getGraphColors("HA_Calm");//默认
//            }
//
//            Layer layer = null;
//            if (layerName != null) {
//                layer = SMThemeCartography.getLayerByName(layerName);
//            } else {
//                layer = SMThemeCartography.getLayerByIndex(layerIndex);
//            }
//            Dataset dataset = null;
//            if (layer != null) {
//                dataset = layer.getDataset();
//            }
//
//            boolean result = SMThemeCartography.createThemeGraphMap(dataset, graphExpressions, themeGraphType, colors);
//            promise.resolve(result);
//        } catch (Exception e) {
//            Log.e(REACT_CLASS, e.getMessage());
//            e.printStackTrace();
//            promise.reject(e);
//        }
//    }




    @ReactMethod
    public void setHeatMapColorScheme(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            String ColorScheme = null;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("HeatmapColorScheme")){
                ColorScheme= data.get("HeatmapColorScheme").toString();

            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && ColorScheme != null && layer.getTheme() == null) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                LayerHeatmap heatmap = (LayerHeatmap) layer;
                Color[] colors =  SMThemeCartography.getAggregationColors(ColorScheme);
                heatmap.setColorset(Colors.makeGradient(colors.length, colors));
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
     * 获取热力图的核半径
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getHeatMapRadius(ReadableMap readableMap, Promise promise) {
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

            if (layer != null && layer.getTheme() == null) {
                LayerHeatmap heatMap = (LayerHeatmap) layer;
                int kernelRadius = heatMap.getKernelRadius();

                promise.resolve(kernelRadius);
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
     * 设置热力图的核半径
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setHeatMapRadius(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            int radius = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("Radius")){
                String size = data.get("Radius").toString();
                radius = (int)Double.parseDouble(size);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && radius != -1 && layer.getTheme() == null) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                LayerHeatmap heatmap = (LayerHeatmap) layer;
                heatmap.setKernelRadius(radius);
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
     * 获取热力图的颜色渐变模糊度
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getHeatMapFuzzyDegree(ReadableMap readableMap, Promise promise) {
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

            if (layer != null && layer.getTheme() == null) {
                LayerHeatmap heatMap = (LayerHeatmap) layer;
                double fuzzyDegree = heatMap.getFuzzyDegree();

                promise.resolve(fuzzyDegree * 10);
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
     * 设置热力图的颜色渐变模糊度(0-1)
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setHeatMapFuzzyDegree(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            double fuzzyDegree = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("FuzzyDegree")){
                String size = data.get("FuzzyDegree").toString();
                fuzzyDegree = Double.parseDouble(size);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && fuzzyDegree != -1 && layer.getTheme() == null) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                LayerHeatmap heatmap = (LayerHeatmap) layer;
                heatmap.setFuzzyDegree(fuzzyDegree / 10);
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
     * 获取热力图的最大颜色权重
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void getHeatMapMaxColorWeight(ReadableMap readableMap, Promise promise) {
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

            if (layer != null && layer.getTheme() == null) {
                LayerHeatmap heatMap = (LayerHeatmap) layer;
                double intensity = heatMap.getIntensity();

                promise.resolve(intensity * 100.0);
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
     * 设置热力图的最大颜色权重(0-100)
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void setHeatMapMaxColorWeight(ReadableMap readableMap, Promise promise) {
        try {
            HashMap<String, Object> data = readableMap.toHashMap();

            String layerName = null;
            int layerIndex = -1;
            double intensity = -1;

            if (data.containsKey("LayerName")){
                layerName = data.get("LayerName").toString();
            }
            if (data.containsKey("LayerIndex")){
                String index = data.get("LayerIndex").toString();
                layerIndex = Integer.parseInt(index);
            }
            if (data.containsKey("MaxColorWeight")){
                String size = data.get("MaxColorWeight").toString();
                intensity = Double.parseDouble(size);
            }

            Layer layer;
            if (layerName != null) {
                layer = SMThemeCartography.getLayerByName(layerName);
            } else {
                layer = SMThemeCartography.getLayerByIndex(layerIndex);
            }

            if (layer != null && intensity != -1 && layer.getTheme() == null) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                LayerHeatmap heatmap = (LayerHeatmap) layer;
                heatmap.setIntensity(intensity / 100.0);
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


    /***************************************************************************************/

    /**
     * 获取数据集中的字段
     * @param layerName 图层名称
     * @param promise
     */
    @ReactMethod
    public void getThemeExpressionByLayerName(String language,String layerName, Promise promise) {
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
                String fieldType = SMThemeCartography.getFieldType(language,fieldInfo);//字段类型
                String fieldTypeStr = fieldInfo.getType().toString();
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("expression", name);
                writeMap.putBoolean("isSelected", false);
                writeMap.putString("datasourceName", dataset.getDatasource().getAlias());
                writeMap.putString("datasetName", dataset.getName());
                writeMap.putString("fieldType", fieldType);
                writeMap.putString("fieldTypeStr", fieldTypeStr);
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
    public void getThemeExpressionByDatasetName(String language,String datasourceAlias, String datasetName,Promise promise) {
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
                String fieldType = SMThemeCartography.getFieldType(language,fieldInfo);//字段类型
                String fieldTypeStr = fieldInfo.getType().toString();
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("expression", name);
                writeMap.putString("fieldType", fieldType);
                writeMap.putString("fieldTypeStr", fieldTypeStr);
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
                } else if (datasource.getAlias().startsWith("Label")) {
                    //排除标注数据源
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
            if (smMapWC.getWorkspace().getDatasources().indexOf(udbName) != -1) {
                datasource = smMapWC.getWorkspace().getDatasources().get(udbName);
            } else {
                datasourceconnection.setEngineType(EngineType.UDB);
                datasourceconnection.setServer(path);
                datasourceconnection.setAlias(udbName);
                datasource = smMapWC.getWorkspace().getDatasources().open(datasourceconnection);
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
                String description = dataset.getDescription();
                if (description.equals("NULL")) {
                    description = "";
                }
                writeMap.putString("description", description);

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
            Datasources datasources = workspace.getDatasources();
            int size = 0;
            for (int i = 0; i < datasources.getCount(); i++) {
                Datasource datasource = datasources.get(i);
                //除了UDB数据源都排除
                if (datasource.getConnectionInfo().getEngineType() == EngineType.UDB) {
                    if (datasource.getAlias().startsWith("Label")) {
                        continue;
                    } else {
                        //排除标注数据源
                        size++;
                    }
                }
            }

            if (size == 0) {
                promise.resolve(false);
            } else {
                promise.resolve(true);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
