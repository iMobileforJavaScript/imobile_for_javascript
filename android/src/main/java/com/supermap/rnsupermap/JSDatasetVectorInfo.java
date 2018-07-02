package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Enum;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSDatasetVectorInfo extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSDatasetVectorInfo";
    protected static Map<String, DatasetVectorInfo> m_DatasetVectorInfoList = new HashMap<String, DatasetVectorInfo>();
    DatasetVectorInfo m_DatasetVectorInfo;

    public JSDatasetVectorInfo(ReactApplicationContext context) {
        super(context);
    }

    public static DatasetVectorInfo getObjFromList(String id) {
        return m_DatasetVectorInfoList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(DatasetVectorInfo obj) {
        for (Map.Entry entry : m_DatasetVectorInfoList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_DatasetVectorInfoList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObjByNameType(String name,int type,Promise promise){
        try{
            DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo(name,(DatasetType) Enum.parse(DatasetType.class,type));
            String datasetVectorInfoId = registerId(datasetVectorInfo);

            WritableMap map = Arguments.createMap();
            map.putString("datasetVectorInfoId",datasetVectorInfoId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}

