package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.analyst.BufferEndType;
import com.supermap.analyst.BufferRadiusUnit;
import com.supermap.data.Enum;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSBufferAnalystParameter extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSBufferAnalystParameter";
    protected static Map<String, BufferAnalystParameter> m_BufferAnalystParameterList = new HashMap<String, BufferAnalystParameter>();
    BufferAnalystParameter m_BufferAnalystParameter;

    public JSBufferAnalystParameter(ReactApplicationContext context) {
        super(context);
    }

    public static BufferAnalystParameter getObjFromList(String id) {
        return m_BufferAnalystParameterList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(BufferAnalystParameter obj) {
        for (Map.Entry entry : m_BufferAnalystParameterList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_BufferAnalystParameterList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = new BufferAnalystParameter();
            String bufferAnalystParameterId = registerId(bufferAnalystParameter);

            WritableMap map = Arguments.createMap();
            map.putString("bufferAnalystParameterId",bufferAnalystParameterId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setEndType(String bufferAnalystParameterId,int bufferEndType, Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            bufferAnalystParameter.setEndType((BufferEndType) Enum.parse(BufferEndType.class,bufferEndType));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getEndType(String bufferAnalystParameterId, Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            BufferEndType endType = bufferAnalystParameter.getEndType();
            int typeCode = Enum.getValueByName(BufferEndType.class,endType.name());
            WritableMap map = Arguments.createMap();
            map.putInt("EndType",typeCode);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLeftDistance(String bufferAnalystParameterId,double distance,Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            bufferAnalystParameter.setLeftDistance(distance);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLeftDistance(String bufferAnalystParameterId,Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            Object leftDistance =  bufferAnalystParameter.getLeftDistance();
            if (leftDistance instanceof String){
                WritableMap map = Arguments.createMap();
                map.putString("leftDistance",(String)leftDistance);
                promise.resolve(map);
            }else {
                WritableMap map = Arguments.createMap();
                map.putDouble("leftDistance",(double)leftDistance);
                promise.resolve(map);
            }
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setRightDistance(String bufferAnalystParameterId,double distance,Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            bufferAnalystParameter.setRightDistance(distance);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getRightDistance(String bufferAnalystParameterId,Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            Object rightDistance =  bufferAnalystParameter.getRightDistance();
            if (rightDistance instanceof String){
                WritableMap map = Arguments.createMap();
                map.putString("rightDistance",(String)rightDistance);
                promise.resolve(map);
            }else {
                WritableMap map = Arguments.createMap();
                map.putDouble("rightDistance",(double)rightDistance);
                promise.resolve(map);
            }
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setRadiusUnit(String bufferAnalystParameterId,int unit,Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            bufferAnalystParameter.setRadiusUnit((BufferRadiusUnit) Enum.parse(BufferRadiusUnit.class,unit));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getRadiusUnit(String bufferAnalystParameterId, Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            BufferRadiusUnit unit = bufferAnalystParameter.getRadiusUnit();
            int typeCode = Enum.getValueByName(BufferRadiusUnit.class,unit.name());
            WritableMap map = Arguments.createMap();
            map.putInt("radiusUnit",typeCode);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSemicircleLineSegment(String bufferAnalystParameterId,int value,Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            bufferAnalystParameter.setSemicircleLineSegment(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getSemicircleLineSegment(String bufferAnalystParameterId,Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = getObjFromList(bufferAnalystParameterId);
            int value = bufferAnalystParameter.getSemicircleLineSegment();

            WritableMap map = Arguments.createMap();
            map.putInt("segment",value);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

