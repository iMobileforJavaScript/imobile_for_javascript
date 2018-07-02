package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Dataset;
import com.supermap.data.Recordset;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.LayerSetting;
import com.supermap.mapping.LayerSettingImage;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.Selection;

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

    public static LayerGroup getObjById(String id){
        return mLayerGroupList.get(id);
    }

    public static String registerId(LayerGroup layerGroup){
        if(!mLayerGroupList.isEmpty()) {
            for(Map.Entry entry:mLayerGroupList.entrySet()){
                if(layerGroup.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mLayerGroupList.put(id,layerGroup);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void add(String layerGroupId, String layerId, Promise promise){
        try{
            mLayerGroup = mLayerGroupList.get(layerGroupId);
            Layer layer = JSLayer.getLayer(layerId);
            mLayerGroup.add(layer);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
