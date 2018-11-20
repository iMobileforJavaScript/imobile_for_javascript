package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Maps;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/7/1.
 */
public class JSMaps extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSMaps";
    public static Map<String,Maps> mMapList=new HashMap<String,Maps>();
    Maps m_Maps;

    public JSMaps(ReactApplicationContext reactContext){
        super(reactContext);
    }
    public static String registerId(Maps maps){
        if(!mMapList.isEmpty()) {
            for(Map.Entry entry:mMapList.entrySet()){
                if(maps.equals(entry.getValue())){
                    return (String)entry.getKey();
                }
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mMapList.put(id,maps);
        return id;
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    @ReactMethod
    public void get(String mapsId,Integer index, Promise promise){
        try{
            m_Maps = mMapList.get(mapsId);
            String mapName = m_Maps.get(index);

            WritableMap map = Arguments.createMap();
            map.putString("mapName",mapName);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCount(String mapsId,Promise promise){
        try{
            m_Maps = mMapList.get(mapsId);
            int count = m_Maps.getCount();

            WritableMap map = Arguments.createMap();
            map.putInt("count",count);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
