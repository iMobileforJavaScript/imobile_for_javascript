package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.FieldInfo;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSFieldInfo extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSFieldInfo";
    private static Map<String, FieldInfo> m_FieldInfoList = new HashMap<String, FieldInfo>();
    JSFieldInfo m_FieldInfos;

    public JSFieldInfo(ReactApplicationContext context) {
        super(context);
    }

    public static FieldInfo getObjFromList(String id) {
        return m_FieldInfoList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(FieldInfo obj) {
        for (Map.Entry entry : m_FieldInfoList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_FieldInfoList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void getRecordCount(String recordsetId, Promise promise){
        try{
//            JSFieldInfo recordset = m_FieldInfoList.get(recordsetId);
//            int recordCount = recordset.getRecordCount();
//
//            WritableMap map = Arguments.createMap();
//            map.putInt("recordCount",recordCount);
//            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}