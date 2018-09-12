package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by yangshanglong on 2018/6/28.
 */
public class JSLayerGroup extends JSLayer {
    public static final String REACT_CLASS = "JSLayerGroup";
    public static Map<String,LayerGroup> mLayerGroupList=new HashMap<String,LayerGroup>();
    LayerGroup mLayerGroup;

    public JSLayerGroup(ReactApplicationContext context){super(context);}

//    public static LayerGroup getObjById(String id){
//        return mLayerGroupList.get(id);
//    }

//    public static String registerId(LayerGroup layerGroup){
//        if(!mLayerGroupList.isEmpty()) {
//            for(Map.Entry entry:mLayerGroupList.entrySet()){
//                if(layerGroup.equals(entry.getValue())){
//                    return (String)entry.getKey();
//                }
//            }
//        }
//
//        Calendar calendar=Calendar.getInstance();
//        String id=Long.toString(calendar.getTimeInMillis());
//        mLayerGroupList.put(id,layerGroup);
//        return id;
//    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    /**
     * 向当前分组图层中添加新的图层
     * @param layerGroupId
     * @param layerId
     * @param promise
     */
    @ReactMethod
    public void add(String layerGroupId, String layerId, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            Layer layer = JSLayer.getLayer(layerId);
            mLayerGroup.add(layer);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 向当前分组图层中添加一个新的分组图层，即嵌套一个分组图层
     * @param layerGroupId
     * @param layerGroupName
     * @param promise
     */
    @ReactMethod
    public void addGroup(String layerGroupId, String layerGroupName, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            LayerGroup layerGroup = mLayerGroup.addGroup(layerGroupName);
            String newLGId = registerId(layerGroup);

            promise.resolve(newLGId);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回图层集合中指定索引的图层对象
     * @param layerGroupId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void get(String layerGroupId, int value, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            Layer layer = mLayerGroup.get(value);
            String layerId = JSLayer.registerId(layer);

            promise.resolve(layerId);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回给定的图层集合中图层对象的总数
     * @param layerGroupId
     * @param promise
     */
    @ReactMethod
    public void getCount(String layerGroupId, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            int count = mLayerGroup.getCount();

            promise.resolve(count);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回指定图层在当前分组图层下的索引值
     * @param layerGroupId
     * @param layerId
     * @param promise
     */
    @ReactMethod
    public void indexOf(String layerGroupId, String layerId, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            Layer layer = JSLayer.getLayer(layerId);
            int index = mLayerGroup.indexOf(layer);

            promise.resolve(index);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 向当前分组图层中的指定位置插入新的图层
     * @param layerGroupId
     * @param index
     * @param layerId
     * @param promise
     */
    @ReactMethod
    public void insert(String layerGroupId, int index, String layerId, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            Layer layer = JSLayer.getLayer(layerId);
            mLayerGroup.insert(index, layer);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 向当前分组图层中的指定索引位置添加一个新的分组图层，即嵌套一个分组图层
     * @param layerGroupId
     * @param index
     * @param groupName
     * @param promise
     */
    @ReactMethod
    public void insertGroup(String layerGroupId, int index, String groupName, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            mLayerGroup.insertGroup(index, groupName);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 从分组图层中移除指定的图层
     * @param layerGroupId
     * @param layerId
     * @param promise
     */
    @ReactMethod
    public void remove(String layerGroupId, String layerId, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            Layer layer = JSLayer.getLayer(layerId);
            boolean result = mLayerGroup.remove(layer);

            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 从当前分组图层中移除指定的分组图层
     * @param layerGroupId
     * @param groupId
     * @param promise
     */
    @ReactMethod
    public void removeGroup(String layerGroupId, String groupId, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            LayerGroup group = (LayerGroup) getLayer(groupId);
            boolean result = mLayerGroup.removeGroup(group);

            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 取消当前分组图层的分组管理，取消后，当前分组图层下的所有内容将移到当前分组图层的上一级进行管理
     * @param layerGroupId
     * @param promise
     */
    @ReactMethod
    public void ungroup(String layerGroupId, Promise promise){
        try{
            mLayerGroup = (LayerGroup) JSLayer.getLayer(layerGroupId);
            boolean result = mLayerGroup.ungroup();

            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
