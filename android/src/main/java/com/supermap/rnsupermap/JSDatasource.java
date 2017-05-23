package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.github.mikephil.charting.data.DataSet;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceEncrytionType;
import com.supermap.data.EncodeType;
import com.supermap.data.Enum;
import com.supermap.data.PrjCoordSys;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JSDatasource extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSDatasource";
    public static Map<String , Datasource> m_DatasourceList = new HashMap<String , Datasource>();
    Datasource m_datasource;

    public JSDatasource(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(Datasource datasource){
        for(Map.Entry entry:m_DatasourceList.entrySet())
        {
            if(datasource.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_DatasourceList.put(id,datasource);
        return id;
    }

    @ReactMethod
    public void getDatasets(String datasourceId,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            Datasets datasets = m_datasource.getDatasets();
            String datasetsId=JSDatasets.registerId(datasets);

            WritableMap map = Arguments.createMap();
            map.putString("datasetsId",datasetsId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDataset(String datasourceId,int index,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            Dataset dataset = m_datasource.getDatasets().get(index);
            String datasetId= JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDatasetByName(String datasourceId,String name,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            Dataset dataset = m_datasource.getDatasets().get(name);
            String datasetId= JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAvailableDatasetName(String datasourceId,String name,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            String datasetName = m_datasource.getDatasets().getAvailableDatasetName(name);

            WritableMap map = Arguments.createMap();
            map.putString("datasetName",datasetName);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createDatasetVector(String datasourceId,String datasetVectorInfoId,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            DatasetVectorInfo datasetVectorInfo = JSDatasetVectorInfo.getObjFromList(datasetVectorInfoId);
            DatasetVector datasetVector = m_datasource.getDatasets().create(datasetVectorInfo);
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            WritableMap map = Arguments.createMap();
            map.putString("datasetVectorId",datasetVectorId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void copyDataset(String datasourceId,String datasetId,String desDatasetName,int encodeType,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            Dataset dataset = JSDataset.getObjById(datasetId);
            Dataset desDataset = m_datasource.copyDataset(dataset,desDatasetName,(EncodeType) Enum.parse(EncodeType.class,encodeType));
            String datasetId1 = JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId1);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
/*
    @ReactMethod
    public void changepassword(String datasourceId,String oldPassword,String newPassword,int datasourceEncrytionType,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            boolean changed = m_datasource.changePassword(oldPassword,newPassword,
                    (DatasourceEncrytionType)Enum.parse(DatasourceEncrytionType.class,datasourceEncrytionType));

            WritableMap map = Arguments.createMap();
            map.putBoolean("changed",changed);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
*/
    @ReactMethod
    public void getPrjCoordSys(String datasourceId,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            PrjCoordSys prjCoordSys = m_datasource.getPrjCoordSys();
            String prjCoordSysId = JSPrjCoordSys.registerId(prjCoordSys);

            WritableMap map = Arguments.createMap();
            map.putString("prjCoordSysId",prjCoordSysId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void containDataset(String datasourceId,String datasetName,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            boolean contain = m_datasource.getDatasets().contains(datasetName);

            WritableMap map = Arguments.createMap();
            map.putBoolean("contain",contain);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteDataset(String datasourceId,String datasetName,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            boolean deleted = m_datasource.getDatasets().delete(datasetName);

            WritableMap map = Arguments.createMap();
            map.putBoolean("deleted",deleted);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDatasetCount(String datasourceId,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            int count = m_datasource.getDatasets().getCount();

            WritableMap map = Arguments.createMap();
            map.putInt("count",count);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createDatasetVectorDirectly(String datasourceId,String nameOrInfoObj,int datasetType,int encodeType,Promise promise){
        try {
            m_datasource = m_DatasourceList.get(datasourceId);
            DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo(nameOrInfoObj,(DatasetType)Enum.parse(DatasetType.class,datasetType));
            datasetVectorInfo.setEncodeType((EncodeType)Enum.parse(EncodeType.class,encodeType));
            DatasetVector datasetVector = m_datasource.getDatasets().create(datasetVectorInfo);
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            WritableMap map = Arguments.createMap();
            map.putString("datasetVectorId",datasetVectorId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}
