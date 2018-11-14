package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.realspace.Camera;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/9.
 */

public class JSCamera extends ReactContextBaseJavaModule{
    public static final String REACT_CLASS = "JSCamera";
    public static Map<String,Camera> mCameraList=new HashMap<String,Camera>();
    Camera mCamera;

    public JSCamera(ReactApplicationContext context){super(context);}

    public static String registerId(Camera camera){
        if(!mCameraList.isEmpty()) {
            for(Map.Entry entry:mCameraList.entrySet()){
                if(camera.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mCameraList.put(id,camera);
        return id;
    }

    public static Camera getObjFromList(String id) {
        return mCameraList.get(id);
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void createObj(double lon,double lat,double alt,double heading,double tilt,Promise promise){
        try{
            Camera camrea = new Camera(lon,lat,alt);
            camrea.setHeading(heading);
            camrea.setTilt(tilt);
            String cameraId = JSCamera.registerId(camrea);
            WritableMap map = Arguments.createMap();
            map.putString("cameraId",cameraId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLon(String cameraId,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            double lon = mCamera.getLongitude();
            WritableMap map = Arguments.createMap();
            map.putDouble("lon",lon);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLat(String cameraId,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            double lat = mCamera.getLatitude();
            WritableMap map = Arguments.createMap();
            map.putDouble("lat",lat);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAlt(String cameraId,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            double alt = mCamera.getAltitude();
            WritableMap map = Arguments.createMap();
            map.putDouble("alt",alt);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLon(String cameraId,Double lon,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            mCamera.setLongitude(lon);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLat(String cameraId,Double lat,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            mCamera.setLatitude(lat);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAlt(String cameraId,Double alt,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            mCamera.setAltitude(alt);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setHeading(String cameraId,Double heading,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            mCamera.setHeading(heading);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getHeading(String cameraId,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            double heading = mCamera.getHeading();
            WritableMap map = Arguments.createMap();
            map.putDouble("heading",heading);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setTilt(String cameraId,Double tilt,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            mCamera.setTilt(tilt);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getTilt(String cameraId,Promise promise){
        try{
            mCamera = mCameraList.get(cameraId);
            double tilt = mCamera.getTilt();
            WritableMap map = Arguments.createMap();
            map.putDouble("tilt",tilt);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
