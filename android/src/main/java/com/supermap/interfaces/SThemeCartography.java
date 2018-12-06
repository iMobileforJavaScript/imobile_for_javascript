package com.supermap.interfaces;

import android.util.Log;
import com.facebook.react.bridge.*;
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


     /*分段专题图
    * ********************************************************************************************/


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
