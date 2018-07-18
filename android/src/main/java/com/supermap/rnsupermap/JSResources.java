package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Resources;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSResources extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSResources";
    private static Map<String, Resources> m_ResourcesList = new HashMap<String, Resources>();
    Resources m_Resources;

    public JSResources(ReactApplicationContext context) {
        super(context);
    }

    public static Resources getObjFromList(String id) { return m_ResourcesList.get(id); }

    @Override
    public String getName() { return REACT_CLASS; }

    public static String registerId(Resources obj) {
        for (Map.Entry entry : m_ResourcesList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ResourcesList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            Resources resources = new Resources();
            String resourcesId = registerId(resources);

            promise.resolve(resourcesId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 释放该对象所占用的资源
     * @param resourcesId
     * @param promise
     */
    @ReactMethod
    public void dispose(String resourcesId, Promise promise){
        try{
            Resources resources = getObjFromList(resourcesId);
            resources.dispose();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

