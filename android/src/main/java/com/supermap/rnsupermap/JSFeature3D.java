package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Geometry3D;
import com.supermap.realspace.Feature3D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/7.
 */

public class JSFeature3D extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSFeature3D";
    public static Map<String,Feature3D> mFeature3DList=new HashMap<String,Feature3D>();
    Feature3D mFeature3D;

    public JSFeature3D(ReactApplicationContext context){super(context);}

    public static String registerId(Feature3D feature3D){
        if(!mFeature3DList.isEmpty()) {
            for(Map.Entry entry:mFeature3DList.entrySet()){
                if(feature3D.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mFeature3DList.put(id,feature3D);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void setVisable(String feature3DId,boolean isVisable,Promise promise){
        try{
            mFeature3D = mFeature3DList.get(feature3DId);
            mFeature3D.setVisible(isVisable);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getVisable(String feature3DId,Promise promise){
        try{
            mFeature3D = mFeature3DList.get(feature3DId);
            boolean isVisable = mFeature3D.isVisible();
            WritableMap map = Arguments.createMap();
            map.putBoolean("visable",isVisable);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getGeometry3D(String feature3DId,Promise promise){
        try{
            mFeature3D = mFeature3DList.get(feature3DId);
            Geometry3D geo3D = mFeature3D.getGeometry();
            // to do geo3d register

        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDescription(String feature3DId,Promise promise){
        try{
            mFeature3D = mFeature3DList.get(feature3DId);
            String description = mFeature3D.getDescription();
            WritableMap map = Arguments.createMap();
            map.putString("description",description);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFieldValueByIndex(String feature3DId,Integer index,Promise promise){
        try{
            mFeature3D = mFeature3DList.get(feature3DId);
            Object value = mFeature3D.getFieldValue(index);
            WritableMap map = Arguments.createMap();
            map.putString("value",value.toString());
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFieldValueByName(String feature3DId,String name,Promise promise){
        try{
            mFeature3D = mFeature3DList.get(feature3DId);
            Object value = mFeature3D.getFieldValue(name);
            WritableMap map = Arguments.createMap();
            map.putString("value",value.toString());
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getID(String feature3DId,Promise promise){
        try{
            mFeature3D = mFeature3DList.get(feature3DId);
            Integer geoId = mFeature3D.getID();
            WritableMap map = Arguments.createMap();
            map.putInt("id",geoId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
