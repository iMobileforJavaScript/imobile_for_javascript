package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Geometry;
import com.supermap.data.QueryParameter;
import com.supermap.data.SpatialQueryMode;
import com.supermap.data.Enum;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSQueryParameter extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSQueryParameter";
    protected static Map<String, QueryParameter> m_QueryParameterList = new HashMap<String, QueryParameter>();
    QueryParameter m_QueryParameter;

    public JSQueryParameter(ReactApplicationContext context) {
        super(context);
    }

    public static QueryParameter getObjFromList(String id) {
        return m_QueryParameterList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(QueryParameter obj) {
        for (Map.Entry entry : m_QueryParameterList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_QueryParameterList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            QueryParameter qp = new QueryParameter();
            String queryParameterId = registerId(qp);

            WritableMap map = Arguments.createMap();
            map.putString("queryParameterId",queryParameterId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAttributeFilter(String queryParameterId, String value, Promise promise){
        try{
            QueryParameter qp = getObjFromList(queryParameterId);
            qp.setAttributeFilter(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setGroupBy(String queryParameterId, ReadableArray values,Promise promise){
        try{
            String attributes[] = {};
            for(int i=0;i<values.size();i++){
                attributes[i] = values.getString(i);
            }
            QueryParameter qp = getObjFromList(queryParameterId);
            qp.setGroupBy(attributes);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setHasGeometry(String queryParameterId,boolean hasGeometry,Promise promise){
        try{
            QueryParameter qp = getObjFromList(queryParameterId);
            qp.setHasGeometry(hasGeometry);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setResultFields(String queryParameterId,ReadableArray fields,Promise promise){
        try{
            String attributes[] = {};
            for(int i=0;i<fields.size();i++){
                attributes[i] = fields.getString(i);
            }
            QueryParameter qp = getObjFromList(queryParameterId);
            qp.setResultFields(attributes);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setOrderBy(String queryParameterId,ReadableArray fields,Promise promise){
        try{
            String attributes[] = {};
            for(int i=0;i<fields.size();i++){
                attributes[i] = fields.getString(i);
            }
            QueryParameter qp = getObjFromList(queryParameterId);
            qp.setOrderBy(attributes);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSpatialQueryObject(String queryParameterId,String geometryId,Promise promise){
        try{
            QueryParameter qp = getObjFromList(queryParameterId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            qp.setSpatialQueryObject(geometry);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSpatialQueryMode(String queryParameterId,int queryMode,Promise promise){
        try{
            QueryParameter qp = getObjFromList(queryParameterId);
            qp.setSpatialQueryMode((SpatialQueryMode)Enum.parse(SpatialQueryMode.class,queryMode));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}

