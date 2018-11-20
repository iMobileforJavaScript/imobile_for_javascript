package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Color;
import com.supermap.data.GeoStyle3D;
import com.supermap.data.Geometry3D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2018/5/8.
 */

public class JSGeometry3D extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSGeometry3D";
    public static Map<String,Geometry3D> mGeometry3DList=new HashMap<String,Geometry3D>();
    Geometry3D mGeometry3D;

    public JSGeometry3D(ReactApplicationContext context){super(context);}

    public static String registerId(Geometry3D geometry3D){
        if(!mGeometry3DList.isEmpty()) {
            for(Map.Entry entry:mGeometry3DList.entrySet()){
                if(geometry3D.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mGeometry3DList.put(id,geometry3D);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void setColor(String geo3DId,int red,int green,int blue,int alpha,Promise promise){
        try{
            mGeometry3D = mGeometry3DList.get(geo3DId);
            GeoStyle3D style3D = mGeometry3D.getStyle3D();
            Color color = new Color(red,green,blue,alpha);
            style3D.setFillForeColor(color);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
