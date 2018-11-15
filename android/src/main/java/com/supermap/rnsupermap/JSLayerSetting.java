package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.mapping.LayerSetting;
import com.supermap.mapping.LayerSettingType;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSLayerSetting extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLayerSetting";
    protected static Map<String, LayerSetting> m_LayerSettingList = new HashMap<String, LayerSetting>();
    LayerSetting m_LayerSetting;

    public JSLayerSetting(ReactApplicationContext context) {
        super(context);
    }

    public static LayerSetting getObjFromList(String id) {
        return m_LayerSettingList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(LayerSetting obj) {
        for (Map.Entry entry : m_LayerSettingList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_LayerSettingList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void getType(String layerSettingId, Promise promise){
        try{
            LayerSetting layerSetting = getObjFromList(layerSettingId);
            LayerSettingType layerSettingType = layerSetting.getType();
            String type;
            if(layerSettingType == LayerSettingType.GRID){
                type = "GRID";
            }else if(layerSettingType == LayerSettingType.IMAGE){
                type = "IMAGE";
            }else{
                type = "VECTOR";
            }
            promise.resolve(type);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}

