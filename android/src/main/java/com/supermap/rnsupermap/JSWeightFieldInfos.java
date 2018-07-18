/**
 * Created by Yangshanglong on 2018/7/11.
 */
package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSWeightFieldInfos extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSWeightFieldInfos";
    protected static Map<String, WeightFieldInfos> m_WeightFieldInfosList = new HashMap<String, WeightFieldInfos>();
    WeightFieldInfos m_WeightFieldInfos;

    public JSWeightFieldInfos(ReactApplicationContext context) {
        super(context);
    }

    public static WeightFieldInfos getObjFromList(String id) {
        return m_WeightFieldInfosList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(WeightFieldInfos obj) {
        for (Map.Entry entry : m_WeightFieldInfosList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_WeightFieldInfosList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = new WeightFieldInfos();
            String weightFieldInfosId = registerId(weightFieldInfos);

            promise.resolve(weightFieldInfosId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 用于在权值字段信息集合中加入一个元素
     * @param weightFieldInfosId
     * @param weightFieldInfoId
     * @param promise
     */
    @ReactMethod
    public void add(String weightFieldInfosId, String weightFieldInfoId, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);
            WeightFieldInfo weightFieldInfo = JSWeightFieldInfo.getObjFromList(weightFieldInfoId);

            weightFieldInfos.add(weightFieldInfo);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 用于从权值字段信息集合移除全部权值字段信息对象
     * @param weightFieldInfosId
     * @param promise
     */
    @ReactMethod
    public void clear(String weightFieldInfosId, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);

            weightFieldInfos.clear();

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据 Index 返回权值字段信息集合对象中的权值字段信息对象
     * @param weightFieldInfosId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void getByIndex(String weightFieldInfosId, int index, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);
            WeightFieldInfo weightFieldInfo = weightFieldInfos.get(index);

            String weightFieldInfoId = JSWeightFieldInfo.registerId(weightFieldInfo);

            promise.resolve(weightFieldInfoId);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据名称返回权值字段信息集合对象中的权值字段信息对象
     * @param weightFieldInfosId
     * @param name
     * @param promise
     */
    @ReactMethod
    public void getByName(String weightFieldInfosId, String name, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);
            WeightFieldInfo weightFieldInfo = weightFieldInfos.get(name);

            String weightFieldInfoId = JSWeightFieldInfo.registerId(weightFieldInfo);

            promise.resolve(weightFieldInfoId);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回给定的权值字段信息集合中元素的总数
     * @param weightFieldInfosId
     * @param promise
     */
    @ReactMethod
    public void getCount(String weightFieldInfosId, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);

            int count = weightFieldInfos.getCount();

            promise.resolve(count);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据指定的名称，返回权值字段信息对象的序号
     * @param weightFieldInfosId
     * @param name
     * @param promise
     */
    @ReactMethod
    public void indexOf(String weightFieldInfosId, String name, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);

            int index = weightFieldInfos.indexOf(name);

            promise.resolve(index);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 用于从权值字段信息集合移除指定序号的权值字段信息对象
     * @param weightFieldInfosId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void removeByIndex(String weightFieldInfosId, int index, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);

            boolean result = weightFieldInfos.remove(index);

            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 从权值字段信息集合中移除指定名称的项
     * @param weightFieldInfosId
     * @param name
     * @param promise
     */
    @ReactMethod
    public void removeByName(String weightFieldInfosId, String name, Promise promise){
        try{
            WeightFieldInfos weightFieldInfos = getObjFromList(weightFieldInfosId);

            boolean result = weightFieldInfos.remove(name);

            promise.resolve(result);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}

