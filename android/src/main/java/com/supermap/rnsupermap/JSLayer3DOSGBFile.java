package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.realspace.Camera;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3DOSGBFile;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/9.
 */

public class JSLayer3DOSGBFile extends ReactContextBaseJavaModule{
    public static final String REACT_CLASS = "JSLayer3DOSGBFile";
    Layer3DOSGBFile mLayerOSGB;
    public JSLayer3DOSGBFile(ReactApplicationContext context){super(context);}
    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void setObjectsColor(String layer3DId,Integer index,Integer red,Integer green,Integer blue,Integer alpha,Promise promise){
        try{
            mLayerOSGB =(Layer3DOSGBFile)JSLayer3D.mLayer3DList.get(layer3DId);
            Color color = new Color(red,green,blue,alpha);
            int[] x ={index};
            mLayerOSGB.setObjectsColor(x,color);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setObjectsVisible(String layer3DId,Integer index,boolean visable,Promise promise){
        try{
            mLayerOSGB =(Layer3DOSGBFile)JSLayer3D.mLayer3DList.get(layer3DId);
            int[] x ={index};
            mLayerOSGB.setObjectsVisible(x,visable);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
