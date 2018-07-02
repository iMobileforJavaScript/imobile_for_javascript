package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Dataset;
import com.supermap.data.Geometry;
import com.supermap.data.Recordset;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSRecordset extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSRecordset";
    private static Map<String, Recordset> m_RecordsetList = new HashMap<String, Recordset>();
    Recordset m_Recordset;

    public JSRecordset(ReactApplicationContext context) {
        super(context);
    }

    public static Recordset getObjFromList(String id) {
        return m_RecordsetList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Recordset obj) {
        for (Map.Entry entry : m_RecordsetList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_RecordsetList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void getRecordCount(String recordsetId, Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            int recordCount = recordset.getRecordCount();

            WritableMap map = Arguments.createMap();
            map.putInt("recordCount",recordCount);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String recordsetId,Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            recordset.dispose();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getGeometry(String recordsetId,Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            Geometry geometry = recordset.getGeometry();
            String geometryId = JSGeometry.registerId(geometry);

            WritableMap map = Arguments.createMap();
            map.putString("geometryId",geometryId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isEOF(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            boolean isEOF = recordset.isEOF();

            promise.resolve(isEOF);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDataset(String recordsetId,Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            Dataset dataset = recordset.getDataset();
            String datasetId = JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveNext(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            recordset.moveNext();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addNew(String recordsetId,String geometryId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            recordset.addNew(geometry);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void update(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            recordset.update();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}