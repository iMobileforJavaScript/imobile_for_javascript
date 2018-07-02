package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Size2D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSSize2D extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSize2D";
    private static Map<String, Size2D> m_Size2DList = new HashMap<String, Size2D>();
    Size2D m_Size2D;

    public JSSize2D(ReactApplicationContext context) {
        super(context);
    }

    public static Size2D getObjFromList(String id) {
        return m_Size2DList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Size2D obj) {
        for (Map.Entry entry : m_Size2DList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_Size2DList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(int w,int h,Promise promise){
        try{
            Size2D size2D = new Size2D(w,h);
            String size2DId = registerId(size2D);

            WritableMap map = Arguments.createMap();
            map.putString("size2DId",size2DId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

