package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.realspace.Layer3D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/7.
 */

public class JSLayer3D extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLayer3D";
    public static Map<String,Layer3D> mLayer3DList=new HashMap<String,Layer3D>();
    Layer3D mLayer3D;

    public JSLayer3D(ReactApplicationContext context){super(context);}

    public static String registerId(Layer3D layer3D){
        if(!mLayer3DList.isEmpty()) {
            for(Map.Entry entry:mLayer3DList.entrySet()){
                if(layer3D.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mLayer3DList.put(id,layer3D);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void updateData(String layer3DId,Promise promise){
        try{
        //android 端无此接口
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setVisable(String layer3DId,boolean isVisable,Promise promise){
        try{
            mLayer3D = mLayer3DList.get(layer3DId);
            mLayer3D.setVisible(isVisable);
            WritableMap map = Arguments.createMap();
            map.putBoolean("isVisable",isVisable);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getVisable(String layer3DId,Promise promise){
        try{
            mLayer3D = mLayer3DList.get(layer3DId);
            boolean isVisable = mLayer3D.isVisible();
            WritableMap map = Arguments.createMap();
            map.putBoolean("isVisable",isVisable);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setRelease(String layer3DId,boolean release,Promise promise){
        try{
            mLayer3D = mLayer3DList.get(layer3DId);
            mLayer3D.setReleaseWhenInvisible(release);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getRelease(String layer3DId,Promise promise){
        try{
            mLayer3D = mLayer3DList.get(layer3DId);
            boolean isRelease = mLayer3D.isReleaseWhenInvisible();
            WritableMap map = Arguments.createMap();
            map.putBoolean("isRelease",isRelease);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
