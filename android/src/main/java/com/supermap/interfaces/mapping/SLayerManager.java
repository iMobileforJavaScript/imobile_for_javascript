package com.supermap.interfaces.mapping;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasets;
import com.supermap.data.Datasources;
import com.supermap.data.Enum;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.Point2D;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Layers;
import com.supermap.mapping.Map;
import com.supermap.mapping.Selection;
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
     *
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
     *
     * @param path
     * @param promise
     */
    @ReactMethod
    public void getLayersByGroupPath(String path, Promise promise) {
        try {
            if (path == null || path.equals(""))
                promise.reject(new Error("Group name can not be empty"));
            WritableArray layers = SMLayer.getLayersByGroupPath(path);
            promise.resolve(layers);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置制定名字图层是否可见
     *
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
     * 设置制定名字图层是否可编辑
     *
     * @param path
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setLayerEditable(String path, boolean value, Promise promise) {
        try {
            SMLayer.setLayerEditable(path, value);
            SMap.getSMWorkspace().getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定名字的图层索引
     *
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
     *
     * @param layerPath
     * @param promise
     */
    @ReactMethod
    public void getLayerAttribute(String layerPath, int page, int size, Promise promise) {
        try {
            WritableMap data = SMLayer.getLayerAttribute(layerPath, page, size);
            promise.resolve(data);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取Selection中对象的属性
     *
     * @param layerPath
     * @param promise
     */
    @ReactMethod
    public void getSelectionAttributeByLayer(String layerPath, int page, int size, Promise promise) {
        try {
            WritableMap data = SMLayer.getSelectionAttributeByLayer(layerPath, page, size);
            promise.resolve(data);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定图层和ID的对象的属性
     *
     * @param layerPath
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void getAttributeByLayer(String layerPath, ReadableArray ids, Promise promise) {
        try {
            WritableMap data = SMLayer.getAttributeByLayer(layerPath, ids);
            promise.resolve(data);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据key和filter查询属性
     * @param layerPath
     * @param params { filter, key, isSelection }// filter 优先级高于key
     * @param page
     * @param size
     * @param promise
     */
    @ReactMethod
    public void searchLayerAttribute(String layerPath, ReadableMap params, int page, int size, Promise promise) {
        try {
            WritableMap recordArray = SMLayer.searchLayerAttribute(layerPath, params, page, size);
            promise.resolve(recordArray);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void searchSelectionAttribute(String layerPath, String searchKey, int page, int size, Promise promise) {
        try {
            WritableMap recordArray = SMLayer.searchSelectionAttribute(layerPath, searchKey, page, size);
            promise.resolve(recordArray);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据数据源序号和数据集序号，添加图层
     *
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
     *
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


    /**
     * 根据图层路径，找到对应的图层并修改指定recordset中的FieldInfo
     *
     * @param layerPath
     * @param fieldInfos
     * @param promise
     */
    @ReactMethod
    public void setLayerFieldInfo(String layerPath, ReadableArray fieldInfos, ReadableMap params, Promise promise) {
        try {
            Layer layer = SMLayer.findLayerByPath(layerPath);

            Layers layers = SMap.getInstance().getSmMapWC().getMapControl().getMap().getLayers();
            Layer editableLayer = null;

            if (layer != null) {
                // 找到原来可编辑图层并记录
                // 三种情况：1.目标图层即为可编辑图层；2.目标图层不为可编辑图层，且layers中不存在编辑图层；3.layers中存在可编辑图层，但不是目标图层
                int status = 1;
                if (!layer.isEditable()) {
                    for (int i = 0; i < layers.getCount(); i++) {
                        if (layers.get(i).isEditable()) {
                            editableLayer = layers.get(i);
                            status = 3;
                            break;
                        }
                    }

                    layer.setEditable(true);
                    if (editableLayer != null) {
                        status = 2;
                    }
                }


                DatasetVector dv = (DatasetVector) layer.getDataset();
                Recordset recordset;

                if (params.hasKey("filter")) {
                    String filter = params.getString("filter");
                    CursorType cursorType = CursorType.DYNAMIC;
                    if (params.hasKey("cursorType")) {
                        cursorType = (CursorType) Enum.parse(CursorType.class, params.getInt("cursorType"));
                    }
                    QueryParameter queryParameter = new QueryParameter();
                    queryParameter.setAttributeFilter(filter);
                    queryParameter.setCursorType(cursorType);
                    recordset = dv.query(queryParameter);
                } else {
                    recordset = dv.getRecordset(false, CursorType.DYNAMIC);
                    if (params.hasKey("index")) {
                        int index = params.getInt("index");
                        index = index >= 0 ? index : (recordset.getRecordCount() - 1);
                        recordset.moveTo(index);
                    }
                }

                recordset.edit();

                for (int i = 0; i < fieldInfos.size(); i++) {
                    ReadableMap info = fieldInfos.getMap(i);
                    String name = info.getString("name");
                    ReadableType valueType = info.getType("value");

                    FieldInfo fieldInfo = recordset.getFieldInfos().get(name);
                    FieldType type = fieldInfo.getType();

                    switch (valueType) {
                        case Number:{
                            if (type == FieldType.INT16) {
                                String value = info.getString("value");
                                recordset.setInt16(name, Short.parseShort(value));
                            } else if (type == FieldType.INT32) {
                                int value = info.getInt("value");
                                recordset.setInt32(name, value);
                            } else if (type == FieldType.INT64) {
                                int value = info.getInt("value");
                                recordset.setInt64(name, value);
                            } else if (type == FieldType.SINGLE) {
                                int value = info.getInt("value");
                                recordset.setSingle(name, value);
                            } else if (type == FieldType.DOUBLE) {
                                Double value = info.getDouble("value");
                                recordset.setDouble(name, value);
                            }
                            break;
                        }
                        case String: {
                            if (type == FieldType.TEXT || type == FieldType.WTEXT
                                    || type == FieldType.LONGBINARY || type == FieldType.BYTE) {
                                String value1 = info.getString("value");
                                recordset.setFieldValue(name, value1);
                            }
                            break;
                        }
                        case Boolean: {
                            if (type == FieldType.BOOLEAN) {
                                boolean boolValue = info.getBoolean("value");
                                recordset.setBoolean(name, boolValue);
                            }
                        }
                    }
//                    String value = info.getString("value");

//                    if (type == FieldType.BOOLEAN) {
//                        boolean boolValue = false;
//                        if (value.equals("true") || value.equals("YES")) {
//                            boolValue = true;
//                        }
//                        recordset.setBoolean(name, boolValue);
//                    } else if (type == FieldType.INT16) {
//                        value = value.equals("") ? "0" : value;
//                        recordset.setInt16(name, Short.parseShort(value));
//                    } else if (type == FieldType.INT32) {
//                        value = value.equals("") ? "0" : value;
//                        recordset.setInt32(name, Integer.parseInt(value));
//                    } else if (type == FieldType.INT64) {
//                        value = value.equals("") ? "0" : value;
//                        recordset.setInt64(name, Integer.parseInt(value));
//                    } else if (type == FieldType.SINGLE) {
//                        value = value.equals("") ? "0" : value;
//                        recordset.setSingle(name, Integer.parseInt(value));
//                    } else if (type == FieldType.DOUBLE) {
//                        value = value.equals("") ? "0" : value;
//                        recordset.setDouble(name, Double.parseDouble(value));
//                    } else if (type == FieldType.DATETIME) {
//
//                    } else if (type == FieldType.TEXT || type == FieldType.WTEXT
//                            || type == FieldType.LONGBINARY || type == FieldType.BYTE) {
//                        recordset.setFieldValue(name, value);
//                    }
                }

                recordset.update();
                recordset.dispose();
                recordset = null;

                // 还原编辑之前的图层可编辑状态
                switch (status) {
                    case 2:
                        layer.setEditable(false);
                        break;
                    case 3:
                        editableLayer.setEditable(true);
                        break;
                    case 1:
                    default:
                        break;
                }
            }


            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 移除指定图层
     *
     * @param defaultIndex 默认显示Map 图层索引
     * @param promise
     */
    @ReactMethod
    public void removeLayerWithIndex(int defaultIndex, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            boolean result = sMap.getSmMapWC().getMapControl().getMap().getLayers().remove(defaultIndex);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 移除指定图层
     *
     * @param layerName 默认显示Map 图层名称
     * @param promise
     */
    @ReactMethod
    public void removeLayerWithName(String layerName, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            boolean result = sMap.getSmMapWC().getMapControl().getMap().getLayers().remove(layerName);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 移除所有图层
     *
     * @param promise
     */
    @ReactMethod
    public void removeAllLayer(Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            sMap.getSmMapWC().getMapControl().getMap().getLayers().clear();
            SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 修改图层名
     *
     * @param promise
     */
    @ReactMethod
    public void renameLayer(String layerName, String relayerName, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Layer layer = sMap.getSmMapWC().getMapControl().getMap().getLayers().get(layerName);
            layer.setCaption(relayerName);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 向上移动图层
     *
     * @param promise
     */
    @ReactMethod
    public void moveUpLayer(String layerName, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            int index = sMap.getSmMapWC().getMapControl().getMap().getLayers().indexOf(layerName);
            if(index!=0){
                int before = index-1;
                Layer beforeLayer = sMap.getSmMapWC().getMapControl().getMap().getLayers().get(before);
                if(beforeLayer.getName().indexOf("@Label_") == -1){
                    sMap.getSmMapWC().getMapControl().getMap().getLayers().moveUp(index);
                    sMap.getSmMapWC().getMapControl().getMap().refresh();
                }
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 向下移动图层
     *
     * @param promise
     */
    @ReactMethod
    public void moveDownLayer(String layerName, Promise promise) {
        try {
            String[] netLayer = new String[]{"roadmap@GoogleMaps",
                    "satellite@GoogleMaps",
                    "terrain@GoogleMaps",
                    "hybrid@GoogleMaps",
                    "vec@TD",
                    "cva@TDWZ",
                    "img@TDYXM",
                    "TrafficMap@BaiduMap",
                    "Standard@OpenStreetMaps",
                    "CycleMap@OpenStreetMaps",
                    "TransportMap@OpenStreetMaps",
                    "quanguo@SuperMapCloud"};
            SMap sMap = SMap.getInstance();
            int index = sMap.getSmMapWC().getMapControl().getMap().getLayers().indexOf(layerName);
            int next = index+1;
            Layer nextLayer = sMap.getSmMapWC().getMapControl().getMap().getLayers().get(next);
            boolean move = true;
            for (int i =0 ;i< netLayer.length;i++){
                if (nextLayer.getName().equals(netLayer[i])){
                    move = false;
                }
            }
            if (move){
                sMap.getSmMapWC().getMapControl().getMap().getLayers().moveDown(index);
                sMap.getSmMapWC().getMapControl().getMap().refresh();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移动到顶层
     *
     * @param promise
     */
    @ReactMethod
    public void moveToTop(String layerName, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            int index = sMap.getSmMapWC().getMapControl().getMap().getLayers().indexOf(layerName);
            sMap.getSmMapWC().getMapControl().getMap().getLayers().moveToTop(index);
            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移动到底层
     *
     * @param promise
     */
    @ReactMethod
    public void moveToBottom(String layerName, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            int index = sMap.getSmMapWC().getMapControl().getMap().getLayers().indexOf(layerName);
            sMap.getSmMapWC().getMapControl().getMap().getLayers().moveToBottom(index);
            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 选中指定图层中的对象
     *
     * @param layerPath
     * @param ids
     * @param promise
     */
    @ReactMethod
    public void selectObj(String layerPath, ReadableArray ids, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(layerPath);
            DatasetVector dv = (DatasetVector)layer.getDataset();
            Selection selection = layer.getSelection();
            selection.clear();

            boolean selectable = layer.isSelectable();
            WritableArray arr = Arguments.createArray();

            if (ids.size() > 0) {
                if (!layer.isSelectable()) {
                    layer.setEditable(true);
                }

                for (int i = 0; i < ids.size(); i++) {
                    int id = ids.getInt(i);
                    selection.add(id);

                    Recordset rs = selection.toRecordset();
                    rs.moveTo(i);
                    Point2D point2D = rs.getGeometry().getInnerPoint();

                    WritableMap idInfo = Arguments.createMap();

                    idInfo.putInt("id", id);
                    idInfo.putDouble("x", point2D.getX());
                    idInfo.putDouble("y", point2D.getY());

                    arr.pushMap(idInfo);
                }
            }

            if (!selectable) {
                layer.setSelectable(false);
            }

            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 选中多个图层中的对象
     *
     * @param data
     * @param promise
     */
    @ReactMethod
    public void selectObjs(ReadableArray data, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            WritableArray arr = Arguments.createArray();

            for (int i = 0; i < data.size(); i++) {
                ReadableMap item = data.getMap(i);
                String layerPath = item.getString("layerPath");
                ReadableArray ids = item.getArray("ids");

                Layer layer = SMLayer.findLayerByPath(layerPath);
                Selection selection = layer.getSelection();
                Recordset rs = null;
                selection.clear();

                boolean selectable = layer.isSelectable();

                if (ids.size() > 0) {
                    if (!layer.isSelectable()) {
                        layer.setEditable(true);
                    }

                    for (int j = 0; j < ids.size(); j++) {
                        int id = ids.getInt(j);
                        selection.add(id);

                        rs = selection.toRecordset();
                        rs.moveTo(i);
                        Point2D point2D = rs.getGeometry().getInnerPoint();

                        WritableMap idInfo = Arguments.createMap();

                        idInfo.putInt("id", id);
                        idInfo.putDouble("x", point2D.getX());
                        idInfo.putDouble("y", point2D.getY());

                        arr.pushMap(idInfo);
                    }
                }

                if (!selectable) {
                    layer.setSelectable(false);
                }

                if (rs != null) {
                    rs.moveFirst();
                }
            }

            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


}
