package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Enum;
import com.supermap.services.QueryMode;
import com.supermap.services.QueryService;
import com.supermap.services.ServiceQueryParameter;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSQueryService extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSQueryService";
    protected static Map<String, QueryService> m_QueryServiceList = new HashMap<String, QueryService>();
    QueryService m_QueryService;

    public JSQueryService(ReactApplicationContext context) {
        super(context);
    }

    public static QueryService getObjFromList(String id) {
        return m_QueryServiceList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;

    }

    public static String registerId(QueryService obj) {
        for (Map.Entry entry : m_QueryServiceList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_QueryServiceList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(String url, Promise promise){
        try{
            QueryService queryService = new QueryService(url);
            String queryServiceId = registerId(queryService);

            WritableMap map = Arguments.createMap();
            map.putString("_queryServiceId_",queryServiceId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void query(String queryServiceId,String serviceQueryParameterId,int mode, Promise promise){
        try{
            QueryService queryService = getObjFromList(queryServiceId);
            ServiceQueryParameter serviceQueryParameter = JSServiceQueryParameter.getObjFromList(serviceQueryParameterId);
            queryService.query(serviceQueryParameter, (QueryMode)Enum.parse(QueryMode.class,mode));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void queryByUrl(String queryServiceId,String url,String serviceQueryParameterId,int mode, Promise promise){
        try{
            QueryService queryService = getObjFromList(queryServiceId);
            ServiceQueryParameter serviceQueryParameter = JSServiceQueryParameter.getObjFromList(serviceQueryParameterId);
            queryService.query(url,serviceQueryParameter, (QueryMode)Enum.parse(QueryMode.class,mode));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

