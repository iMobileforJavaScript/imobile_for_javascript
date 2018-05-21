package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Point3D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/9.
 */

public class JSPoint3D extends ReactContextBaseJavaModule{
    public static final String REACT_CLASS = "JSPoint3D";
    public static Map<String,Point3D> mPoint3DList=new HashMap<String,Point3D>();
    Point3D mPoint3D;

    public JSPoint3D(ReactApplicationContext context){super(context);}

    public static String registerId(Point3D point3D){
        if(!mPoint3DList.isEmpty()) {
            for(Map.Entry entry:mPoint3DList.entrySet()){
                if(point3D.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mPoint3DList.put(id,point3D);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void createObj(double lon,double lat,double alt,Promise promise){
        try{
            mPoint3D = new Point3D(lon,lat,alt);
            String point3DId = JSPoint3D.registerId(mPoint3D);
            WritableMap map = Arguments.createMap();
            map.putString("pointId",point3DId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getX(String pointId,Promise promise){
        try{
            mPoint3D = mPoint3DList.get(pointId);
            double x = mPoint3D.getX();
            WritableMap map = Arguments.createMap();
            map.putDouble("x",x);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getY(String pointId,Promise promise){
        try{
            mPoint3D = mPoint3DList.get(pointId);
            double y = mPoint3D.getY();
            WritableMap map = Arguments.createMap();
            map.putDouble("y",y);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getZ(String pointId,Promise promise){
        try{
            mPoint3D = mPoint3DList.get(pointId);
            double z = mPoint3D.getY();
            WritableMap map = Arguments.createMap();
            map.putDouble("z",z);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setX(String pointId,double x,Promise promise){
        try{
            mPoint3D = mPoint3DList.get(pointId);
            mPoint3D.setX(x);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setY(String pointId,double y,Promise promise){
        try{
            mPoint3D = mPoint3DList.get(pointId);
            mPoint3D.setY(y);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setZ(String pointId,double z,Promise promise){
        try{
            mPoint3D = mPoint3DList.get(pointId);
            mPoint3D.setZ(z);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
