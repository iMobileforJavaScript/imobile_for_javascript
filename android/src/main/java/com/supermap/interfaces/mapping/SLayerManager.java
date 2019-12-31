package com.supermap.interfaces.mapping;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasets;
import com.supermap.data.Datasources;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoRegion;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.GeometryType;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Recordset;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Size2D;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.Map;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;
import com.supermap.plot.GeoGraphicObject;
import com.supermap.smNative.SMLayer;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.HashMap;

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

    @ReactMethod
    public void setLayerSelectable(String layerPath, boolean s, Promise promise) {
        try {
            Layer layer = SMLayer.findLayerByPath(layerPath);
            layer.setSelectable(s);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLayerSnapable(String layerPath, boolean s, Promise promise) {
        try {
            Layer layer = SMLayer.findLayerByPath(layerPath);
            layer.setSnapable(s);
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
     * @param layerPath
     * @param page
     * @param size
     * @param params 过滤条件
     */
    @ReactMethod
    public void getLayerAttribute(String layerPath, int page, int size, ReadableMap params, Promise promise) {
        try {
            WritableMap data = SMLayer.getLayerAttribute(layerPath, page, size, params);
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
     * 统计
     * @param layerPath
     * @param isSelect
     * @param fieldName
     * @param statisticMode
     * @param promise
     */
    @ReactMethod
    public void statistic(String layerPath, boolean isSelect, String fieldName, int statisticMode, Promise promise) {
        try {
            Double result = SMLayer.statistic(layerPath, isSelect, fieldName, statisticMode);
            promise.resolve(result);
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
     * 根据图层名获取对应xml
     *
     * @param layerPath
     * @param promise
     */
    @ReactMethod
    public void getLayerAsXML(String layerPath, Promise promise) {
        try {
            Layer layer = SMLayer.findLayerByPath(layerPath);

            promise.resolve(layer.toXML());
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 将xml图层插入到当前地图
     *
     * @param index
     * @param xml
     * @param promise
     */
    @ReactMethod
    public void insertXMLLayer(int index, String xml, Promise promise){
        try{
            boolean result = SMLayer.insertXMLLayer(index, xml);
            promise.resolve(result);
        }
        catch(Exception e) {
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

            boolean result = SMLayer.setLayerFieldInfo(layer, fieldInfos, params);

            promise.resolve(result);
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
            boolean result = false;

            HashMap<String,Object>res =  SMLayer.findLayerAndGroupByPath(layerName);
            LayerGroup layerGroup = (LayerGroup)res.get("layerGroup");
            Layer layer =  (Layer)res.get("layer");
            if(layerGroup != null){
                if(layer != null){
                    layerGroup.remove(layer);
                }
            }else{
                if(layer != null){
                    result = sMap.getSmMapWC().getMapControl().getMap().getLayers().remove(layerName);
                }
            }

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

            Layer layer = SMLayer.findLayerByPath(layerName);//sMap.getSmMapWC().getMapControl().getMap().getLayers().get(layerName);
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

            HashMap<String,Object>res =  SMLayer.findLayerAndGroupByPath(layerName);
            LayerGroup layerGroup = (LayerGroup)res.get("layerGroup");
            Layer layer =  (Layer)res.get("layer");
            if(layerGroup != null){
                if(layer != null){
                    int nInsert = layerGroup.indexOf(layer)-1;// indexOfLayer:layer] - 1;
                    if(nInsert>=0) {
                        layerGroup.insert(nInsert, layer);// insert:nInsert Layer:layer];
                    }
                }
            }else{
                if(layer != null){
                    int index = sMap.getSmMapWC().getMapControl().getMap().getLayers().indexOf(layerName);
                    if(index!=0){
                        int before = index-1;
                        Layer beforeLayer = sMap.getSmMapWC().getMapControl().getMap().getLayers().get(before);
                        if(beforeLayer.getName().indexOf("@Label_") == -1){
                            sMap.getSmMapWC().getMapControl().getMap().getLayers().moveUp(index);
                            sMap.getSmMapWC().getMapControl().getMap().refresh();
                        }
                    }
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
                HashMap<String,Object>res =  SMLayer.findLayerAndGroupByPath(layerName);
                LayerGroup layerGroup = (LayerGroup)res.get("layerGroup");
                Layer layer =  (Layer)res.get("layer");
                if(layerGroup != null){
                    if(layer != null){
                        int nInsert = layerGroup.indexOf(layer)+1;// indexOfLayer:layer] - 1;
                        if(nInsert<=layerGroup.getCount()) {
                            layerGroup.insert(nInsert, layer);// insert:nInsert Layer:layer];
                        }
                    }
                }else{
                    if(layer != null){
                        sMap.getSmMapWC().getMapControl().getMap().getLayers().moveDown(index);
                    }
                }

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
            HashMap<String,Object>res =  SMLayer.findLayerAndGroupByPath(layerName);
            LayerGroup layerGroup = (LayerGroup)res.get("layerGroup");
            Layer layer =  (Layer)res.get("layer");
            if(layerGroup != null){
                if(layer != null){
                    int nInsert = 0;// indexOfLayer:layer] - 1;
                    if(nInsert>=0) {
                        layerGroup.insert(nInsert, layer);// insert:nInsert Layer:layer];
                    }
                }
            }else{
                if(layer != null){

                    int index = sMap.getSmMapWC().getMapControl().getMap().getLayers().indexOf(layerName);
                    sMap.getSmMapWC().getMapControl().getMap().getLayers().moveToTop(index);
                }
            }


//            sMap.getSmMapWC().getMapControl().getMap().refresh();
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
            HashMap<String,Object>res =  SMLayer.findLayerAndGroupByPath(layerName);
            LayerGroup layerGroup = (LayerGroup)res.get("layerGroup");
            Layer layer =  (Layer)res.get("layer");
            if(layerGroup != null){
                if(layer != null){
                    int nInsert = layerGroup.getCount();// indexOfLayer:layer] - 1;
                    if(nInsert<=layerGroup.getCount()) {
                        layerGroup.insert(nInsert, layer);// insert:nInsert Layer:layer];
                    }
                }
            }else{
                if(layer != null){

                    int index = sMap.getSmMapWC().getMapControl().getMap().getLayers().indexOf(layerName);
                    sMap.getSmMapWC().getMapControl().getMap().getLayers().moveToBottom(index);
                }
            }


//            sMap.getSmMapWC().getMapControl().getMap().refresh();
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
//            WritableArray arr = Arguments.createArray();

            if (ids.size() > 0) {
                if (!layer.isSelectable()) {
                    layer.setEditable(true);
                }

                for (int i = 0; i < ids.size(); i++) {
                    int id = ids.getInt(i);
                    selection.add(id);

//                    Recordset rs = selection.toRecordset();
//                    rs.moveTo(i);
//                    Point2D point2D = rs.getGeometry().getInnerPoint();
//
//                    WritableMap idInfo = Arguments.createMap();
//
//                    idInfo.putInt("id", id);
//                    idInfo.putDouble("x", point2D.getX());
//                    idInfo.putDouble("y", point2D.getY());
//
//                    arr.pushMap(idInfo);
//
//                    rs.dispose();
                }
            }

            if (!selectable) {
                layer.setSelectable(false);
            }

            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(true);
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
            Map map = sMap.getSmMapWC().getMapControl().getMap();
//            WritableArray arr = Arguments.createArray();

            Rectangle2D bounds = null;
            for (int i = 0; i < data.size(); i++) {
                ReadableMap item = data.getMap(i);
                String layerPath = item.getString("layerPath");
                ReadableArray ids = item.getArray("ids");

                Layer layer = SMLayer.findLayerByPath(layerPath);
                Selection selection = layer.getSelection();

                selection.clear();

                boolean selectable = layer.isSelectable();

                if (ids.size() > 0) {
                    if (!layer.isSelectable()) {
                        layer.setEditable(true);
                    }

                    for (int j = 0; j < ids.size(); j++) {
                        int id = ids.getInt(j);
                        selection.add(id);

//                        rs = selection.toRecordset();
//                        rs.moveTo(i);
//                        Point2D point2D = rs.getGeometry().getInnerPoint();
//
//                        WritableMap idInfo = Arguments.createMap();
//
//                        idInfo.putInt("id", id);
//                        idInfo.putDouble("x", point2D.getX());
//                        idInfo.putDouble("y", point2D.getY());
//
//                        selectObjs.pushMap(idInfo);
//                        rs.dispose();
                    }

                    Recordset rs = selection.toRecordset();
                    Rectangle2D selectionBounds = rs.getBounds();
                    if(selectionBounds != null &&
                            (selectionBounds.getWidth() != 0 && selectionBounds.getHeight() != 0 && selectionBounds.getCenter().getX() != 0 && selectionBounds.getCenter().getY() != 0)){
                        if(!SMap.safeGetType(rs.getDataset().getPrjCoordSys(),map.getPrjCoordSys())){
                            Point2Ds point2Ds = new Point2Ds();
                            Point2D leftBottom = new Point2D(selectionBounds.getLeft(),selectionBounds.getBottom());
                            Point2D rightTop = new Point2D(selectionBounds.getRight(),selectionBounds.getTop());
                            point2Ds.add(leftBottom);
                            point2Ds.add(rightTop);
                            PrjCoordSys desPrjCoordSys = new PrjCoordSys();
                            desPrjCoordSys.setType(rs.getDataset().getPrjCoordSys().getType());
                            CoordSysTranslator.convert(point2Ds, desPrjCoordSys, map.getPrjCoordSys(), new CoordSysTransParameter(), CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

                            leftBottom = point2Ds.getItem(0);
                            rightTop = point2Ds.getItem(1);
                            selectionBounds = new Rectangle2D(leftBottom,rightTop);
                        }
                        if(bounds == null){
                            bounds = new Rectangle2D(selectionBounds);
                        }else{
                            bounds.union(selectionBounds);
                        }
                    }
                    rs.dispose();
                    rs.close();
                }

                if (!selectable) {
                    layer.setSelectable(false);
                }

            }
            if(bounds != null){
                map.setViewBounds(bounds);
                map.setScale(map.getScale() * 0.8);
            }
            map.refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLayerStyle(String layerName, String styleJson, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Layer layer = sMap.getSmMapWC().getMapControl().getMap().getLayers().find(layerName);

            if (layer != null && !styleJson.equals("")) {
                GeoStyle geoStyle = new GeoStyle();
                geoStyle.fromJson(styleJson);
                ((LayerSettingVector) layer.getAdditionalSetting()).setStyle(geoStyle);
            }

            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(true);
        }catch (Exception e) {
            promise.reject(e);
        }
    }
    /**
     * 把多个图层中的对象放到追踪层
     *
     * @param data
     * @param promise
     */
    @ReactMethod
    public void setTrackingLayer(ReadableArray data, boolean isClear, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Map map = sMap.getSmMapWC().getMapControl().getMap();
            TrackingLayer trackingLayer = map.getTrackingLayer();

            if (isClear) {
                trackingLayer.clear();
            }

            WritableArray arr = Arguments.createArray();

            Rectangle2D bounds = null;
            for (int i = 0; i < data.size(); i++) {
                ReadableMap item = data.getMap(i);
                String layerPath = item.getString("layerPath");
                ReadableArray _ids = item.getArray("ids");

                Layer layer = SMLayer.findLayerByPath(layerPath);

                int[] ids = new int[_ids.size()];
                if (ids.length == 0) continue;

                for (int k = 0; k < _ids.size(); k++) {
                    ids[k] = _ids.getInt(k);
                }

                DatasetVector dv = (DatasetVector)layer.getDataset();
                String[] pathParams = layerPath.split("/");
                if (pathParams[pathParams.length - 1].contains("_Node") && dv.getChildDataset() != null) {
                    dv = dv.getChildDataset();
                }

                Recordset recordset = dv.query(ids, CursorType.STATIC);
                PrjCoordSys prjCoordSys = recordset.getDataset().getPrjCoordSys();
                PrjCoordSys mapCoordSys = sMap.smMapWC.getMapControl().getMap().getPrjCoordSys();

                while(!recordset.isEOF()) {
                    GeoStyle geoStyle = null;
                    if (item.hasKey("style")) {
                        String styleJSON = item.getString("style");
                        geoStyle = new GeoStyle();
                        geoStyle.fromJson(styleJSON);
                    }

                    Geometry geometry = recordset.getGeometry();
                    if (geometry != null) {
                        geometry.setStyle(geoStyle);
                    }

                    for (int j = 0; j < ids.length; j++) {
                        int id = ids[j];
                        Point2D point2D = recordset.getGeometry().getInnerPoint();

                        WritableMap idInfo = Arguments.createMap();

                        idInfo.putInt("id", id);
                        idInfo.putDouble("x", point2D.getX());
                        idInfo.putDouble("y", point2D.getY());

                        arr.pushMap(idInfo);
                    }
                    if(!SMap.safeGetType(prjCoordSys,mapCoordSys)){
                        GeoStyle selectStyle = new GeoStyle();
                        selectStyle.setFillForeColor(new Color(0, 255, 0, 128));
                        selectStyle.setLineColor(new Color(70, 128, 223));
                        selectStyle.setLineWidth(1);
                        selectStyle.setMarkerSize(new Size2D(5, 5));

//                        if(geometry.getType()==GeometryType.GEOGRAPHICOBJECT){
//                            GeoGraphicObject obj = (GeoGraphicObject)geometry.clone();
//                            trackingLayer.add(geometry.clone(), "");
//                        }else
                            {

                            GeometryType geoType = recordset.getGeometry().getType();
                            Geometry newGeometry = null;

                            if (geoType == GeometryType.GEOPOINT) {
                                Point2Ds point2Ds = new Point2Ds();
                                point2Ds.add(geometry.getInnerPoint());
                                PrjCoordSys desPrjCoordSys = new PrjCoordSys();
                                desPrjCoordSys.setType(prjCoordSys.getType());
                                CoordSysTranslator.convert(point2Ds, desPrjCoordSys, mapCoordSys, new CoordSysTransParameter(), CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                                newGeometry = new GeoPoint(point2Ds.getItem(0).getX(), point2Ds.getItem(0).getY());
                            } else if (geoType == GeometryType.GEOLINE) {
                                GeoLine line = (GeoLine)geometry;
                                Point2Ds point2Ds;
                                newGeometry = new GeoLine();
                                for (int j = 0; j < line.getPartCount(); j++) {
                                    point2Ds = line.getPart(j);
                                    PrjCoordSys desPrjCoordSys = new PrjCoordSys();
                                    desPrjCoordSys.setType(prjCoordSys.getType());
                                    CoordSysTranslator.convert(point2Ds, desPrjCoordSys, mapCoordSys, new CoordSysTransParameter(), CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                                    ((GeoLine) newGeometry).addPart(point2Ds);
                                }
                            } else if (geoType == GeometryType.GEOREGION) {
                                GeoRegion region = (GeoRegion)geometry;
                                Point2Ds point2Ds;
                                newGeometry = new GeoRegion();
                                for (int j = 0; j < region.getPartCount(); j++) {
                                    point2Ds = region.getPart(j);
                                    PrjCoordSys desPrjCoordSys = new PrjCoordSys();
                                    desPrjCoordSys.setType(prjCoordSys.getType());
                                    CoordSysTranslator.convert(point2Ds, desPrjCoordSys, mapCoordSys, new CoordSysTransParameter(), CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                                    ((GeoRegion) newGeometry).addPart(point2Ds);
                                }
                            }
                            if (newGeometry != null) {
                                newGeometry.setStyle(selectStyle);
                                geometry = newGeometry;
                            }
                        }
                    }
                //    if(geometry.getType()!=GeometryType.GEOGRAPHICOBJECT)
                    {
                        trackingLayer.add(geometry, "");
                    }
                    Rectangle2D tmpBounds = geometry.getBounds();
                    if(tmpBounds != null ){
                        if(bounds == null){
                            bounds = new Rectangle2D(tmpBounds);
                        }else{
                            bounds.union(tmpBounds);
                        }
                    }
                    recordset.moveNext();
                }
                recordset.dispose();
            }

            if(bounds != null){
                if(bounds.getHeight()>0 && bounds.getWidth()>0){
                    map.setViewBounds(bounds);
                    map.setScale(map.getScale() * 0.8);
                }else{
                    map.setCenter(bounds.getCenter());
                }

            }
            sMap.getSmMapWC().getMapControl().getMap().refresh();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void clearTrackingLayer(Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Map map = sMap.getSmMapWC().getMapControl().getMap();
            TrackingLayer trackingLayer = map.getTrackingLayer();

            trackingLayer.clear();
            sMap.getSmMapWC().getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addAttributeFieldInfo(String layerPath,boolean isSelect,ReadableMap fieldInfoMap,Promise promise) {
        try {
            boolean result=SMLayer.addRecordsetFieldInfo(layerPath,isSelect,fieldInfoMap);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
    @ReactMethod
    public void removeRecordsetFieldInfo(String layerPath,boolean isSelect,String attributeName,Promise promise) {
        try {
            boolean result=SMLayer.removeRecordsetFieldInfo(layerPath,isSelect,attributeName);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
