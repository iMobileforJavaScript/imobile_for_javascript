package com.supermap.interfaces;

import android.util.Log;
import com.facebook.react.bridge.*;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.*;
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

            int datasourceIndex = 0;
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
     * @param uniqueExpression 单值专题图字段表达式
     * @param layerName 图层名称
     * @param promise
     */
    @ReactMethod
    public void setUniqueExpression(String uniqueExpression, String layerName, Promise promise) {
        try {
            Layer layer = SMThemeCartography.getLayerByName(layerName);
            if (layer != null && layer.getTheme() != null) {
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


     /*分段专题图
    * ********************************************************************************************/


     /*栅格分段专题图
    * ********************************************************************************************/


}
