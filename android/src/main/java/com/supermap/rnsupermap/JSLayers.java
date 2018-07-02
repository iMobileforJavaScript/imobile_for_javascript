package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Dataset;
import com.supermap.data.Enum;
import com.supermap.data.DatasetType;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Layers;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JSLayers extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLayers";
    public static Map<String , Layers> m_LayersList = new HashMap<String , Layers>();
    Layers m_Layers;

    public JSLayers(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(Layers layers){
        for(Map.Entry entry:m_LayersList.entrySet())
        {
            if(layers.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_LayersList.put(id,layers);
        return id;
    }

    @ReactMethod
    public void add(String layersId, String datasetId,boolean b, Promise promise){
        try{
            m_Layers = m_LayersList.get(layersId);
            Dataset dataset = JSDataset.getObjById(datasetId);
            m_Layers.add(dataset,b);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void get(String layersId,int index,Promise promise){
        try{
            m_Layers = m_LayersList.get(layersId);
            Layer layer = m_Layers.get(index);
            String layerId = JSLayer.registerId(layer);

            WritableMap map = Arguments.createMap();
            map.putString("layerId",layerId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getByName(String layersId,String index,Promise promise){
        try{
            m_Layers = m_LayersList.get(layersId);
            Layer layer = m_Layers.get(index);
            String layerId = JSLayer.registerId(layer);

            WritableMap map = Arguments.createMap();
            map.putString("layerId",layerId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCount(String layersId,Promise promise){
        try{
            m_Layers = m_LayersList.get(layersId);
            int count = m_Layers.getCount();

            WritableMap map = Arguments.createMap();
            map.putInt("count",count);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
