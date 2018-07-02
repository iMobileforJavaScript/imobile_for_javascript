package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.DatasourceConnectionInfo;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JSDatasourceConnectionInfo extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSDatasourceConnectionInfo";
    public static Map<String,DatasourceConnectionInfo> m_DatasourceConnectionInfoList=new HashMap<String,DatasourceConnectionInfo>();
    public DatasourceConnectionInfo m_DatasourceConnectionInfo;


    public JSDatasourceConnectionInfo(ReactApplicationContext context){
        super(context);
    }

    public static DatasourceConnectionInfo getObjById(String id){
        return m_DatasourceConnectionInfoList.get(id);
    }

    @Override
    public String getName(){
        return REACT_CLASS;
    }

    public static String registerId(DatasourceConnectionInfo dci){
        for(Map.Entry entry:m_DatasourceConnectionInfoList.entrySet()){
            if(dci.equals(entry.getValue())){
                return (String)entry.getKey();
            }
        }

        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_DatasourceConnectionInfoList.put(id,dci);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            m_DatasourceConnectionInfo=new DatasourceConnectionInfo();
            String datasourceConnectionInfoId = registerId(m_DatasourceConnectionInfo);

            WritableMap map = Arguments.createMap();
            map.putString("datasourceConnectionInfoId",datasourceConnectionInfoId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setServer(String datasourceConnectionInfoId,String url,Promise promise){
        try{
            m_DatasourceConnectionInfo = m_DatasourceConnectionInfoList.get(datasourceConnectionInfoId);
            m_DatasourceConnectionInfo.setServer(url);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setEngineType(String datasourceConnectionInfoId,String engineType,Promise promise){
        try{
            m_DatasourceConnectionInfo = m_DatasourceConnectionInfoList.get(datasourceConnectionInfoId);
            m_DatasourceConnectionInfo.setEngineType(JS_EngineType.typeOf(engineType));

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAlias(String datasourceConnectionInfoId,String alias,Promise promise){
        try{
            m_DatasourceConnectionInfo = m_DatasourceConnectionInfoList.get(datasourceConnectionInfoId);
            m_DatasourceConnectionInfo.setAlias(alias);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
