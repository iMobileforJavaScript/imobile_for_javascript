package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.Dataset;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Workspace;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Layers;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapLoadedListener;
import com.supermap.mapping.MapOperateListener;
import com.supermap.mapping.Theme;
import com.supermap.mapping.TrackingLayer;

import java.util.Calendar;
import java.util.HashMap;

/**
 * Created by will on 2016/6/16.
 */
public class JSMap extends ReactContextBaseJavaModule {
    
    private static java.util.Map<String,Map> mapList=new HashMap<String,Map>();
    private static final String NAVIGATION_STARTPOINT = "STARTPOINT";
    private static final String NAVIGATION_DESTPOINT = "DESTPOINT";
    private static final String MAP_LOADED = "com.supermap.RN.JSMap.map_loaded";
    private static final String MAP_OPENED = "com.supermap.RN.JSMap.map_opened";
    private static final String MAP_CLOSED = "com.supermap.RN.JSMap.map_closed";
    private Map m_Map;
    ReactContext mReactContext;
    
    @Override
    public String getName(){return "JSMap";}
    
    public JSMap(ReactApplicationContext context){
        super(context);
        mReactContext = context;
    }
    
    public static Map getObjFromList(String id) {
        return mapList.get(id);
    }
    
    public java.util.Map<String, Object> getConstants() {
        final java.util.Map<String, Object> constants = new HashMap<>();
        constants.put(NAVIGATION_STARTPOINT, "startpoint");
        constants.put(NAVIGATION_DESTPOINT, "destpoint");
        return constants;
    }
    
    public static String registerId(Map map){
        String mapId;
        for(java.util.Map.Entry entry:mapList.entrySet()){
            if(map.equals(entry.getValue())){
                mapId=(String)entry.getKey();
                return mapId;
            }
        }
        Calendar cale = Calendar.getInstance();
        mapId = Long.toString(cale.getTimeInMillis());
        mapList.put(mapId,map);
        return mapId;
    }
    
    public static String getIdWithObj(Map map){
        String mapId;
        try{
            for(java.util.Map.Entry entry:mapList.entrySet()){
                if(map.equals(entry.getValue())){
                    mapId=(String)entry.getKey();
                    return mapId;
                }
            }
            throw new Exception("the map you find is not exist!");
        }catch (Exception e){
            return e.getMessage();
        }
    }
    
    @ReactMethod
    public void setWorkspace(String mapId,String workspaceId,Promise promise){
        try{
            Workspace workspace=JSWorkspace.getObjById(workspaceId);
            Map map=mapList.get(mapId);
            map.setWorkspace(workspace);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void open(String mapId,String mapName,Promise promise){
        try{
            Map map=mapList.get(mapId);
            map.open(mapName);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void refresh(String mapId,Promise promise){
        try{
            Map map=mapList.get(mapId);
            map.refresh();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void close(String mapId,Promise promise){
        try{
            Map map=mapList.get(mapId);
            map.close();
            System.out.print("map closed");
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void getLayer(String mapId,int layerIndex,Promise promise){
        try{
            m_Map = mapList.get(mapId);
            Layer layer = m_Map.getLayers().get(layerIndex);
            String layerId = JSLayer.registerId(layer);
            
            WritableMap map = Arguments.createMap();
            map.putString("layerId",layerId);
            
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void addDataset(String mapId,String datasetId,boolean addToHead,Promise promise){
        try{
            m_Map = mapList.get(mapId);
            Dataset dataset = JSDataset.getObjById(datasetId);
            
            m_Map.getLayers().add(dataset,addToHead);
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void getLayersCount(String mapId,Promise promise){
        try{
            m_Map = mapList.get(mapId);
            int count = m_Map.getLayers().getCount();
            
            WritableMap map = Arguments.createMap();
            map.putInt("count",count);
            
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void getLayers(String mapId,Promise promise){
        try{
            m_Map = mapList.get(mapId);
            Layers layers = m_Map.getLayers();
            String layersId = JSLayers.registerId(layers);
            
            WritableMap map = Arguments.createMap();
            map.putString("layersId",layersId);
            
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void pixelToMap(String mapId, String pointId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Point point = JSPoint.m_PointList.get(pointId);
            
            Point2D point2D = map.pixelToMap(point);
            String point2DId = JSPoint2D.registerId(point2D);
            
            WritableMap writableMap = Arguments.createMap();
            writableMap.putString("point2DId",point2DId);
            writableMap.putDouble("x",point2D.getX());
            writableMap.putDouble("y",point2D.getY());
            promise.resolve(writableMap);
        }catch(Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void mapToPixel(String mapId, String point2DId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Point2D point2D = JSPoint2D.m_Point2DList.get(point2DId);
            
            Point point = map.mapToPixel(point2D);
            String pointId = JSPoint.registerId(point);
            
            WritableMap writableMap = Arguments.createMap();
            writableMap.putString("pointId",pointId);
            writableMap.putInt("x",point.getX());
            writableMap.putInt("y",point.getY());
            promise.resolve(writableMap);
        }catch(Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void setCenter(String mapId,String point2DId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Point2D point2D = JSPoint2D.m_Point2DList.get(point2DId);
            map.setCenter(point2D);
            
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void getTrackingLayer(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            TrackingLayer trackingLayer = map.getTrackingLayer();
            String trackingLayerId = JSTrackingLayer.registerId(trackingLayer);
            
            WritableMap wMap = Arguments.createMap();
            wMap.putString("trackingLayerId",trackingLayerId);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void save(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            boolean saved = map.save();

            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("saved",saved);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void saveAs(String mapId,String mapName,Promise promise){
        try{
            Map map = mapList.get(mapId);
            boolean saved = map.saveAs(mapName);
            
            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("saved",saved);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void getBounds(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Rectangle2D rectangle2D = map.getBounds();
            
            WritableMap wMap = JsonUtil.rectangleToJson(rectangle2D);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void getViewBounds(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Rectangle2D rectangle2D = map.getViewBounds();
            
            WritableMap wMap = JsonUtil.rectangleToJson(rectangle2D);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void setViewBound(String mapId, ReadableMap readableMap,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Rectangle2D rectangle2D = JsonUtil.jsonToRectangle(readableMap);
            
            map.setViewBounds(rectangle2D);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void isDynamicProjection(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            boolean is = map.isDynamicProjection();
            
            WritableMap map1 = Arguments.createMap();
            map1.putBoolean("is",is);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void setDynamicProjection(String mapId,boolean value,Promise promise){
        try{
            Map map = mapList.get(mapId);
            map.setDynamicProjection(value);
            
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void setMapLoadedListener(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            map.setMapLoadedListener(new MapLoadedListener() {
                @Override
                public void onMapLoaded() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(MAP_LOADED,null);
                }
            });
            
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void setMapOperateListener(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            map.setMapOperateListener(new MapOperateListener() {
                @Override
                public void mapOpened() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(MAP_OPENED,null);
                }
                
                @Override
                public void mapClosed() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(MAP_CLOSED,null);
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void pan(String mapId,double offsetX,double offsetY,Promise promise){
        try{
            Map map = mapList.get(mapId);
            map.pan(offsetX,offsetY);
            
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void viewEntire(String mapId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            map.viewEntire();
            
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void zoom(String mapId,double ratio,Promise promise){
        try{
            Map map = mapList.get(mapId);
            map.zoom(ratio);
            
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void getLayerByName(String mapId,String layerName,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Layer layer = map.getLayers().get(layerName);
            String layerId = JSLayer.registerId(layer);
            
            WritableMap map1 = Arguments.createMap();
            map1.putString("layerId",layerId);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void addLayer(String mapId,String datasetId,boolean addToHead,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Dataset dataset = JSDataset.getObjById(datasetId);
            Layer layer = map.getLayers().add(dataset,addToHead);
            String layerId = JSLayer.registerId(layer);
            
            WritableMap map1 = Arguments.createMap();
            map1.putString("layerId",layerId);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void addThemeLayer(String mapId,String datasetId,String themeId,boolean addToHead,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Dataset dataset = JSDataset.getObjById(datasetId);
            Theme theme = JSTheme.getObjFromList(themeId);
            Layer layer = map.getLayers().add(dataset,theme,addToHead);
            String layerId = JSLayer.registerId(layer);

            WritableMap map1 = Arguments.createMap();
            map1.putString("layerId",layerId);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCenter(String mapId,String datasetId,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Point2D point2D = map.getCenter();
            String point2DId = JSPoint2D.registerId(point2D);
            
            WritableMap map1 = Arguments.createMap();
            map1.putString("point2DId",point2DId);
            map1.putDouble("x",point2D.getX());
            map1.putDouble("y",point2D.getY());
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void removeLayerByName(String mapId,String datasetId,String layerName,Promise promise){
        try{
            Map map = mapList.get(mapId);
            String layerId = JSLayer.registerId(map.getLayers().get(layerName));
            map.getLayers().remove(layerName);
            
            WritableMap map1 = Arguments.createMap();
            map1.putString("layerId",layerId);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void removeLayerByIndex(String mapId,String datasetId,int index,Promise promise){
        try{
            Map map = mapList.get(mapId);
            String layerId = JSLayer.registerId(map.getLayers().get(index));
            map.getLayers().remove(index);
            
            WritableMap map1 = Arguments.createMap();
            map1.putString("layerId",layerId);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void contains(String mapId,String datasetId,String name,Promise promise){
        try{
            Map map = mapList.get(mapId);
            Boolean isContain = map.getLayers().contains(name);
            
            WritableMap map1 = Arguments.createMap();
            map1.putBoolean("isContain",isContain);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void moveDown(String mapId,String name,Promise promise){
        try{
            Map map = mapList.get(mapId);
            int layerIndex = map.getLayers().indexOf(name);
            Boolean moved = map.getLayers().moveDown(layerIndex);
            
            WritableMap map1 = Arguments.createMap();
            map1.putBoolean("moved",moved);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    
    @ReactMethod
    public void moveUp(String mapId,String name,Promise promise){
        try{
            Map map = mapList.get(mapId);
            int layerIndex = map.getLayers().indexOf(name);
            Boolean moveUp = map.getLayers().moveUp(layerIndex);
            
            WritableMap map1 = Arguments.createMap();
            map1.putBoolean("moveUp",moveUp);
            promise.resolve(map1);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
