package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.analyst.spatialanalyst.OverlayAnalyst;
import com.supermap.analyst.spatialanalyst.OverlayAnalystParameter;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSOverlayAnalystParameter extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSOverlayAnalystParameter";
    protected static Map<String, OverlayAnalystParameter> m_OverlayAnalystParameterList = new HashMap<String, OverlayAnalystParameter>();
    OverlayAnalystParameter m_OverlayAnalystParameter;

    public JSOverlayAnalystParameter(ReactApplicationContext context) {
        super(context);
    }

    public static OverlayAnalystParameter getObjFromList(String id) {
        return m_OverlayAnalystParameterList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(OverlayAnalystParameter obj) {
        for (Map.Entry entry : m_OverlayAnalystParameterList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_OverlayAnalystParameterList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj( Promise promise){
        try{
            OverlayAnalystParameter overlayAnalystParameter = new OverlayAnalystParameter();
            String overlayAnalystParameterId = registerId(overlayAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putString("overlayAnalystParameterId",overlayAnalystParameterId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setTolerance(String overlayAnalystParameterId, Double rate, Promise promise){
        try{
            OverlayAnalystParameter overlayAnalystParameter = getObjFromList(overlayAnalystParameterId);
            overlayAnalystParameter.setTolerance(rate);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getTolerance(String overlayAnalystParameterId,Promise promise){
        try{
            OverlayAnalystParameter overlayAnalystParameter = getObjFromList(overlayAnalystParameterId);
            double tolerance = overlayAnalystParameter.getTolerance();

            WritableMap map = Arguments.createMap();
            map.putDouble("tolerance",tolerance);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getOperationRetainedFields(String overlayAnalystParameterId,Promise promise){
        try{
            OverlayAnalystParameter overlayAnalystParameter = getObjFromList(overlayAnalystParameterId);
            String[] fields = overlayAnalystParameter.getOperationRetainedFields();

            WritableArray array = Arguments.createArray();
            for(int i = 0; i < fields.length; i++){
                array.pushString(fields[i]);
            }

            WritableMap map = Arguments.createMap();
            map.putArray("fields",array);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setOperationRetainedFields(String overlayAnalystParameterId, ReadableArray fields, Promise promise){
        try{
            OverlayAnalystParameter overlayAnalystParameter = getObjFromList(overlayAnalystParameterId);
            int size = fields.size();
            String [] array = new String[size];
            for(int i = 0; i < size; i++){
                array[i] = fields.getString(i);
            }
            overlayAnalystParameter.setOperationRetainedFields(array);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getSourceRetainedFields(String overlayAnalystParameterId,Promise promise){
        try{
            OverlayAnalystParameter overlayAnalystParameter = getObjFromList(overlayAnalystParameterId);
            String[] fields = overlayAnalystParameter.getSourceRetainedFields();

            WritableArray array = Arguments.createArray();
            for(int i = 0; i < fields.length; i++){
                array.pushString(fields[i]);
            }

            WritableMap map = Arguments.createMap();
            map.putArray("fields",array);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSourceRetainedFields(String overlayAnalystParameterId, ReadableArray fields, Promise promise){
        try{
            OverlayAnalystParameter overlayAnalystParameter = getObjFromList(overlayAnalystParameterId);
            int count = fields.size();
            String [] array = new String[count];
            for(int i = 0; i < count; i++){
                String value = fields.getString(i);
                array[i] = value;

            }
            overlayAnalystParameter.setSourceRetainedFields(array);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

