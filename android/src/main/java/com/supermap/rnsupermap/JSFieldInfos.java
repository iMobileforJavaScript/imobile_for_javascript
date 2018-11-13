package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSFieldInfos extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSFieldInfos";
    private static Map<String, FieldInfos> m_FieldInfosList = new HashMap<String, FieldInfos>();
    JSFieldInfos m_FieldInfos;

    public JSFieldInfos(ReactApplicationContext context) {
        super(context);
    }

    public static FieldInfos getObjFromList(String id) {
        return m_FieldInfosList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(FieldInfos obj) {
        for (Map.Entry entry : m_FieldInfosList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_FieldInfosList.put(id, obj);
        return id;
    }


    /**
     * 添加FieldInfo
     * @param fieldInfosId
     * @param fieldInfoId
     * @param promise
     */
    @ReactMethod
    public void add(String fieldInfosId, String fieldInfoId,Promise promise){
        try{
            FieldInfos fieldInfos = getObjFromList(fieldInfosId);
            FieldInfo fieldInfo = JSFieldInfo.getObjFromList(fieldInfoId);

            int index = fieldInfos.add(fieldInfo);

            WritableMap map = Arguments.createMap();
            map.putInt("index", index);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 释放对象
     * @param fieldInfosId
     * @param promise
     */
    @ReactMethod
    public void dispose(String fieldInfosId, Promise promise){
        try{
            FieldInfos fieldInfos = getObjFromList(fieldInfosId);

            fieldInfos.dispose();
            m_FieldInfosList.remove(fieldInfosId);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 通过index获取FieldInfo
     * @param fieldInfosId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void getByIndex(String fieldInfosId, int index, Promise promise){
        try{
            FieldInfos fieldInfos = getObjFromList(fieldInfosId);

            FieldInfo fieldInfo = fieldInfos.get(index);
            String fieldInfoId = JSFieldInfo.registerId(fieldInfo);

            WritableMap map = Arguments.createMap();
            map.putString("fieldInfoId", fieldInfoId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据名字获取FieldInfo
     * @param fieldInfosId
     * @param name
     * @param promise
     */
    @ReactMethod
    public void getByName(String fieldInfosId, String name, Promise promise){
        try{
            FieldInfos fieldInfos = getObjFromList(fieldInfosId);

            FieldInfo fieldInfo = fieldInfos.get(name);
            String fieldInfoId = JSFieldInfo.registerId(fieldInfo);

            WritableMap map = Arguments.createMap();
            map.putString("fieldInfoId", fieldInfoId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取FieldInfos中FieldInfo的数量
     * @param fieldInfosId
     * @param promise
     */
    @ReactMethod
    public void getCount(String fieldInfosId, Promise promise){
        try{
            FieldInfos fieldInfos = getObjFromList(fieldInfosId);
            int count = fieldInfos.getCount();

            WritableMap map = Arguments.createMap();
            map.putInt("count", count);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}