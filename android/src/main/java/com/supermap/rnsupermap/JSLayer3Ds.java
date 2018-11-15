package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.mapping.Layer;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3Ds;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/7.
 */

public class JSLayer3Ds extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLayer3Ds";
    public static Map<String,Layer3Ds> mLayer3DsList=new HashMap<String,Layer3Ds>();
    Layer3Ds mLayer3Ds;

    public JSLayer3Ds(ReactApplicationContext context){super(context);}

    public static String registerId(Layer3Ds layer3Ds){
        if(!mLayer3DsList.isEmpty()) {
            for(Map.Entry entry:mLayer3DsList.entrySet()){
                if(layer3Ds.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mLayer3DsList.put(id,layer3Ds);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void getByName(String layer3DsId,String name,Promise promise){
        try{
            mLayer3Ds = mLayer3DsList.get(layer3DsId);
            Layer3D layer3D = mLayer3Ds.get(name);
            String layer3DId = JSLayer3D.registerId(layer3D);
            WritableMap map = Arguments.createMap();
            map.putString("layerId",layer3DId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getByIndex(String layer3DsId,Integer index,Promise promise){
        try{
            mLayer3Ds = mLayer3DsList.get(layer3DsId);
            Layer3D layer3D = mLayer3Ds.get(index);
            String layer3DId = JSLayer3D.registerId(layer3D);
            WritableMap map = Arguments.createMap();
            map.putString("layerId",layer3DId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCount(String layer3DsId,Promise promise){
        try{
            mLayer3Ds = mLayer3DsList.get(layer3DsId);
            Integer count = mLayer3Ds.getCount();
            WritableMap map = Arguments.createMap();
            map.putInt("count",count);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
