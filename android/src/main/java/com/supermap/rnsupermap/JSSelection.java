package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.GeoStyle;
import com.supermap.data.Recordset;
import com.supermap.mapping.Selection;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSSelection extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSelection";
    private static Map<String, Selection> m_SelectionList = new HashMap<String, Selection>();
    Selection m_Selection;

    public JSSelection(ReactApplicationContext context) {
        super(context);
    }

    public static Selection getObjFromList(String id) {
        return m_SelectionList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Selection obj) {
        for (Map.Entry entry : m_SelectionList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_SelectionList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void fromRecordset(String selectionId,String recordsetId,Promise promise){
        try{
            Selection selection = m_SelectionList.get(selectionId);
            Recordset recordset = JSRecordset.getObjFromList(recordsetId);
            Boolean fromRecordset = selection.fromRecordset(recordset);

            WritableMap map = Arguments.createMap();
            map.putBoolean("fromRecordset",fromRecordset);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setStyle(String selectionId,String geoStyleId,Promise promise){
        try{
            Selection selection = m_SelectionList.get(selectionId);
            GeoStyle geoStyle = JSGeoStyle.getObjFromList(geoStyleId);
            selection.setStyle(geoStyle);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void clear(String selectionId,Promise promise){
        try{
            Selection selection = m_SelectionList.get(selectionId);
            selection.clear();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void toRecordset(String selectionId,Promise promise){
        try{
            Selection selection = getObjFromList(selectionId);
            Recordset recordset = selection.toRecordset();
            String recordsetId = JSRecordset.registerId(recordset);

            WritableMap map = Arguments.createMap();
            map.putString("recordsetId",recordsetId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

