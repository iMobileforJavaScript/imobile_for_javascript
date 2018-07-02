package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JSDatasources extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSDatasources";
    public static Map<String , Datasources> m_DatasourceList = new HashMap<String , Datasources>();

    public JSDatasources(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(Datasources datasources){
        for(Map.Entry entry:m_DatasourceList.entrySet())
        {
            if(datasources.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_DatasourceList.put(id,datasources);
        return id;
    }

    @ReactMethod
    public void open(String datasourcesId,String datasourceConnectionInfoId,Promise promise){
        try{
            Datasources datasources = m_DatasourceList.get(datasourcesId);
            DatasourceConnectionInfo datasourceConnectionInfo = JSDatasourceConnectionInfo.getObjById(datasourceConnectionInfoId);
            Datasource datasource = datasources.open(datasourceConnectionInfo);
            String datasourceId = JSDatasource.registerId(datasource);

            WritableMap map = Arguments.createMap();
            map.putString("datasourceId",datasourceId);

            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getByName(String datasourcesId,String datasrouceName,Promise promise){
        try{
            Datasources datasources = m_DatasourceList.get(datasourcesId);
            Datasource datasource = datasources.get(datasrouceName);
            String datasourceId = JSDatasource.registerId(datasource);

            WritableMap map = Arguments.createMap();
            map.putString("datasourceId",datasourceId);

            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void get(String datasourcesId,int datasrouceName,Promise promise){
        try{
            Datasources datasources = m_DatasourceList.get(datasourcesId);
            Datasource datasource = datasources.get(datasrouceName);
            String datasourceId = JSDatasource.registerId(datasource);

            WritableMap map = Arguments.createMap();
            map.putString("datasourceId",datasourceId);

            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCount(String datasourcesId,Promise promise){
        try{
            Datasources datasources = m_DatasourceList.get(datasourcesId);
            int count = datasources.getCount();
            WritableMap map = Arguments.createMap();
            map.putInt("count",count);

            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAlias(String datasourcesId,int index,Promise promise){
        try{
            Datasources datasources = m_DatasourceList.get(datasourcesId);
            Datasource dataSoure = datasources.get(index);
            String name = dataSoure.getAlias();
            WritableMap map = Arguments.createMap();
            map.putString("alias",name);

            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
