package com.supermap.interfaces.mapping;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.supermap.data.Dataset;
import com.supermap.data.Datasets;
import com.supermap.data.Datasources;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Map;
import com.supermap.smNative.SMLayer;

import org.apache.http.cookie.SM;

public class SLayerManager extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SLayerManager";
    private static SLayerManager analyst;
//    private static ReactApplicationContext context;
    ReactContext mReactContext;

    public SLayerManager(ReactApplicationContext context) {
        super(context);
//        this.context = context;
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    /**
     * 获取制定类型的图层, type = -1 为所有类型
     * @param type
     * @param path
     * @param promise
     */
    @ReactMethod
    public void getLayersByType(int type, String path, Promise promise) {
        try {
            WritableArray layers = SMLayer.getLayersByType(type, path);
            promise.resolve(layers);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定名字的LayerGroup
     * @param path
     * @param promise
     */
    @ReactMethod
    public void getLayersByGroupPath(String path, Promise promise) {
        try {
            if (path == null || path.equals("")) promise.reject(new Error("Group name can not be empty"));
            WritableArray layers = SMLayer.getLayersByGroupPath(path);
            promise.resolve(layers);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置制定名字图层是否可见
     * @param path
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setLayerVisible(String path, boolean value, Promise promise) {
        try {
            SMLayer.setLayerVisible(path, value);
            SMap.getSMWorkspace().getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定名字的图层索引
     * @param name
     * @param promise
     */
    @ReactMethod
    public void getLayerIndexByName(String name, Promise promise) {
        try {
            int index = SMLayer.getLayerIndex(name);
            promise.resolve(index);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取图层属性
     * @param layerPath
     * @param promise
     */
    @ReactMethod
    public void getLayerAttribute(String layerPath, Promise promise) {
        try {
            WritableArray data = SMLayer.getLayerAttribute(layerPath);
            promise.resolve(data);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取Selection中对象的属性
     * @param layerPath
     * @param promise
     */
    @ReactMethod
    public void getSelectionAttributeByLayer(String layerPath, Promise promise) {
        try {
            WritableArray data = SMLayer.getSelectionAttributeByLayer(layerPath);
            promise.resolve(data);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据数据源序号和数据集序号，添加图层
     * @param datasourceIndex
     * @param datasetIndex
     * @param promise
     */
    @ReactMethod
    public void addLayerByIndex(int datasourceIndex, int datasetIndex, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Datasources datasources = sMap.getSmMapWC().getWorkspace().getDatasources();
            Boolean result = false;
            if (datasources != null && datasources.getCount() > datasourceIndex) {
                Datasets dss = datasources.get(datasourceIndex).getDatasets();
                if (dss.getCount() > datasetIndex) {
                    Map map = sMap.getSmMapWC().getMapControl().getMap();
                    Dataset ds = dss.get(datasetIndex);
                    Layer layer = map.getLayers().add(ds, true);
                    map.setVisibleScalesEnabled(false);

                    result = layer != null;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据数据源名称和数据集序号，添加图层
     * @param datasourceName
     * @param datasetIndex
     * @param promise
     */
    @ReactMethod
    public void addLayerByName(String datasourceName, int datasetIndex, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Datasources datasources = sMap.getSmMapWC().getWorkspace().getDatasources();
            Boolean result = false;
            if (datasources != null && datasources.get(datasourceName) != null) {
                Datasets dss = datasources.get(datasourceName).getDatasets();
                if (dss.getCount() > datasetIndex) {
                    Map map = sMap.getSmMapWC().getMapControl().getMap();
                    Dataset ds = dss.get(datasetIndex);
                    Layer layer = map.getLayers().add(ds, true);
                    map.setVisibleScalesEnabled(false);

                    result = layer != null;
                }
            }
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}
