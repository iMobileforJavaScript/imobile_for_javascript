package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Geometry;
import com.supermap.services.FeatureSet;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSFeatureSet extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSFeatureSet";
    protected static Map<String, FeatureSet> m_FeatureSetList = new HashMap<String, FeatureSet>();
    FeatureSet m_FeatureSet;

    public JSFeatureSet(ReactApplicationContext context) {
        super(context);
    }

    public static FeatureSet getObjFromList(String id) {
        return m_FeatureSetList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(FeatureSet obj) {
        for (Map.Entry entry : m_FeatureSetList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_FeatureSetList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void deleteAll(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            featureSet.deleteAll();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void delete(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            featureSet.delete();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFeatureCount(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            int count = featureSet.getFeatureCount();

            promise.resolve(count);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFieldValue(String featureSetId,String fieldName,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            String value = featureSet.getFieldValue(fieldName).toString();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getGeometry(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            Geometry geometry = featureSet.getGeometry();
            String geometryId = JSGeometry.registerId(geometry);

            WritableMap map = Arguments.createMap();
            map.putString("geometryId",geometryId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isReadOnly(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            featureSet.isReadOnly();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveFirst(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            featureSet.moveFirst();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveLast(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            featureSet.moveLast();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveNext(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            featureSet.moveNext();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void movePrev(String featureSetId,Promise promise){
        try{
            FeatureSet featureSet = getObjFromList(featureSetId);
            featureSet.movePrev();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}

