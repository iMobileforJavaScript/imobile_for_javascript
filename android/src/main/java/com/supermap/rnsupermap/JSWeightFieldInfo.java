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

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSWeightFieldInfo extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSWeightFieldInfo";
    protected static Map<String, WeightFieldInfo> m_WeightFieldInfoList = new HashMap<String, WeightFieldInfo>();
    WeightFieldInfo m_WeightFieldInfo;

    public JSWeightFieldInfo(ReactApplicationContext context) {
        super(context);
    }

    public static WeightFieldInfo getObjFromList(String id) {
        return m_WeightFieldInfoList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(WeightFieldInfo obj) {
        for (Map.Entry entry : m_WeightFieldInfoList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_WeightFieldInfoList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            WeightFieldInfo weightFieldInfo = new WeightFieldInfo();
            String weightFieldInfoId = registerId(weightFieldInfo);

            promise.resolve(weightFieldInfoId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回正向权值字段
     * @param weightFieldInfoId
     * @param promise
     */
    @ReactMethod
    public void getFTWeightField(String weightFieldInfoId, Promise promise){
        try{
            WeightFieldInfo weightFieldInfo = getObjFromList(weightFieldInfoId);

            String ftWeightField = weightFieldInfo.getFTWeightField();

            promise.resolve(ftWeightField);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回权值字段信息的名称
     * @param weightFieldInfoId
     * @param promise
     */
    @ReactMethod
    public void getName(String weightFieldInfoId, Promise promise){
        try{
            WeightFieldInfo weightFieldInfo = getObjFromList(weightFieldInfoId);

            String name = weightFieldInfo.getName();

            promise.resolve(name);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回反向权值字段
     * @param weightFieldInfoId
     * @param promise
     */
    @ReactMethod
    public void getTFWeightField(String weightFieldInfoId, Promise promise){
        try{
            WeightFieldInfo weightFieldInfo = getObjFromList(weightFieldInfoId);

            String tfWeightField = weightFieldInfo.getTFWeightField();

            promise.resolve(tfWeightField);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置正向权值字段
     * @param weightFieldInfoId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFTWeightField(String weightFieldInfoId, String value, Promise promise){
        try{
            WeightFieldInfo weightFieldInfo = getObjFromList(weightFieldInfoId);

            weightFieldInfo.setFTWeightField(value);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置权值字段信息的名称
     * @param weightFieldInfoId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setName(String weightFieldInfoId, String value, Promise promise){
        try{
            WeightFieldInfo weightFieldInfo = getObjFromList(weightFieldInfoId);

            weightFieldInfo.setName(value);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置反向权值字段
     * @param weightFieldInfoId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTFWeightField(String weightFieldInfoId, String value, Promise promise){
        try{
            WeightFieldInfo weightFieldInfo = getObjFromList(weightFieldInfoId);

             weightFieldInfo.setTFWeightField(value);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}

