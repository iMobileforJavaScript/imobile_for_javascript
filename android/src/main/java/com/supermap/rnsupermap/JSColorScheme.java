package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.mapping.imChart.ColorScheme;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/5/31.
 */

public class JSColorScheme extends ReactContextBaseJavaModule {
    private static final String MODULE_NAME = "JSColorScheme";
    private static Map<String,ColorScheme> m_ColorSchemeList = new HashMap<String, ColorScheme>();
    ColorScheme m_ColorScheme;

    public JSColorScheme(ReactApplicationContext context){super(context);}
    public static ColorScheme getObjFromList(String id){return m_ColorSchemeList.get(id);}

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    public static String registerId (ColorScheme Obj){
        for (Map.Entry entry : m_ColorSchemeList.entrySet()) {
            if (Obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ColorSchemeList.put(id, Obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try {
            ColorScheme colorScheme = new ColorScheme();
            String schemeId = registerId(colorScheme);

            WritableMap map = Arguments.createMap();
            map.putString("colorSchemeId",schemeId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setColors(String id, ReadableArray colorArr, Promise promise){
        try {
            int length = colorArr.size();
            Color [] array = new Color[length];
            for (int i = 0; i<length;i++){
                ReadableArray arr = colorArr.getArray(i);
                int alpha = arr.getInt(0);
                int red = arr.getInt(1);
                int green = arr.getInt(2);
                int blue = arr.getInt(3);
                Color color = new Color(red,green,blue,alpha);
                array[i] = color;
            }
            ColorScheme colorScheme = getObjFromList(id);
            colorScheme.setColors(array);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getColors(String id, Promise promise){
        try {
            ColorScheme colorScheme = getObjFromList(id);
            Color[] arr = colorScheme.getColors();
            int length = arr.length;
            WritableArray colorArr = Arguments.createArray();
            for (int i=0;i<length;i++){
                int color = arr[i].getRGBA();
                colorArr.pushInt(color);
            }

            WritableMap map = Arguments.createMap();
            map.putArray("colors",colorArr);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSegmentValue(String id, ReadableArray value, Promise promise){
        try {
            ColorScheme colorScheme = getObjFromList(id);
            float[] arr = new  float[value.size()];
            for (int i=0;i<value.size(); i++){
                arr[i] = (float) value.getDouble(i);
            }
            colorScheme.setSegmentValue(arr);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getSegmentValue(String id, Promise promise){
        try {
            ColorScheme colorScheme = getObjFromList(id);
            float [] arr = colorScheme.getSegmentValue();
            WritableArray writeArr = Arguments.createArray();
            for (int i=0;i<arr.length; i++){
                writeArr.pushDouble(arr[i]);
            }

            WritableMap map = Arguments.createMap();
            map.putArray("segmentValue",writeArr);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
