package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.DatasetType;
import com.supermap.data.Enum;
import com.supermap.data.GeoStyle;
import com.supermap.mapping.LayerSettingType;
import com.supermap.mapping.LayerSettingVector;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSLayerSettingVector extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLayerSettingVector";
    protected static Map<String, LayerSettingVector> m_LayerSettingVectorList = new HashMap<String, LayerSettingVector>();
    LayerSettingVector m_LayerSettingVector;

    public JSLayerSettingVector(ReactApplicationContext context) {
        super(context);
    }

    public static LayerSettingVector getObjFromList(String id) {
        return m_LayerSettingVectorList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(LayerSettingVector obj) {
        for (Map.Entry entry : m_LayerSettingVectorList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_LayerSettingVectorList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            LayerSettingVector layerSettingVector = new LayerSettingVector();
            String layerSettingVectorId = registerId(layerSettingVector);

            WritableMap map = Arguments.createMap();
            map.putString("_layerSettingVectorId_",layerSettingVectorId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getStyle(String layerSettingVectorId,Promise promise){
        try{
            LayerSettingVector layerSettingVector = getObjFromList(layerSettingVectorId);
            GeoStyle style = layerSettingVector.getStyle();
            String geoStyleId = JSGeoStyle.registerId(style);

            WritableMap map = Arguments.createMap();
            map.putString("geoStyleId",geoStyleId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setStyle(String layerSettingVectorId,String geoStyleId,Promise promise){
        try{
            LayerSettingVector layerSettingVector = getObjFromList(layerSettingVectorId);
            GeoStyle style = JSGeoStyle.getObjFromList(geoStyleId);
            layerSettingVector.setStyle(style);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getType(String layerSettingVectorId,Promise promise){
        try{
            LayerSettingVector layerSettingVector = getObjFromList(layerSettingVectorId);
            LayerSettingType layerSettingType = layerSettingVector.getType();
            int type = Enum.getValueByName(LayerSettingType.class,layerSettingType.name());

            WritableMap map = Arguments.createMap();
            map.putInt("type",type);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

