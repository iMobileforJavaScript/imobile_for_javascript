package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.realspace.Feature3D;
import com.supermap.realspace.Feature3DSearchOption;
import com.supermap.realspace.Feature3Ds;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/7.
 */

public class JSFeature3Ds extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSFeature3Ds";
    public static Map<String,Feature3Ds> mFeature3DsList=new HashMap<String,Feature3Ds>();
    Feature3Ds mFeature3Ds;

    public JSFeature3Ds(ReactApplicationContext context){super(context);}

    public static String registerId(Feature3Ds feature3Ds){
        if(!mFeature3DsList.isEmpty()) {
            for(Map.Entry entry:mFeature3DsList.entrySet()){
                if(feature3Ds.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mFeature3DsList.put(id,feature3Ds);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void get(String feature3DsId,Integer index,Promise promise){
        try{
            String id ="";
            String type ="";
            mFeature3Ds = mFeature3DsList.get(feature3DsId);
            Object feature3d = mFeature3Ds.get(index);
            if(feature3d instanceof Feature3Ds){
                id = JSFeature3Ds.registerId((Feature3Ds) feature3d);
                type = "feature3Ds";
            }else if(feature3d instanceof Feature3D){
                id = JSFeature3D.registerId((Feature3D) feature3d);
                type = "feature3D";
            }
            WritableMap map = Arguments.createMap();
            map.putString("objectId",id);
            map.putString("type",type);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void findFeature(String feature3DsId,Integer index,Promise promise){
        try{
            mFeature3Ds = mFeature3DsList.get(feature3DsId);
            Feature3D feature = mFeature3Ds.findFeature(index,Feature3DSearchOption.ALLFEATURES);
            
//            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCount(String feature3DsId,Promise promise){
        try{
            mFeature3Ds = mFeature3DsList.get(feature3DsId);
            Integer count = mFeature3Ds.getCount();
            WritableMap map = Arguments.createMap();
            map.putInt("count",count);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
