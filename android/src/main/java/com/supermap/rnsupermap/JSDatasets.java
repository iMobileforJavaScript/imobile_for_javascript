package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JSDatasets extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSDatasets";
    public static Map<String , Datasets> m_DatasetsList = new HashMap<String,Datasets>();
    Datasets m_datasets;

    public JSDatasets(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(Datasets datasets){
        for(Map.Entry entry:m_DatasetsList.entrySet())
        {
            if(datasets.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_DatasetsList.put(id,datasets);
        return id;
    }

    @ReactMethod
    public void get(String datasetsId, int index, Promise promise){
        try{
            m_datasets = m_DatasetsList.get(datasetsId);
            Dataset dataset = m_datasets.get(index);
            String datasetId = JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCount(String datasetsId, Promise promise){
        try{
            m_datasets = m_DatasetsList.get(datasetsId);
            int count = m_datasets.getCount();

            WritableMap map = Arguments.createMap();
            map.putInt("count", count);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getByName(String datasetsId, String index, Promise promise){
        try{
            m_datasets = m_DatasetsList.get(datasetsId);
            Dataset dataset = m_datasets.get(index);
            String datasetId = JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAvailableDatasetName(String datasetsId,String name,Promise promise){
        try{
            Datasets datasets = m_DatasetsList.get(datasetsId);
            String datasetName = datasets.getAvailableDatasetName(name);

            WritableMap map = Arguments.createMap();
            map.putString("datasetName",datasetName);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void create(String datasetsId,String datasetVectorInfoId,Promise promise){
        try{
            Datasets datasets = m_DatasetsList.get(datasetsId);
            DatasetVectorInfo datasetVectorInfo = JSDatasetVectorInfo.getObjFromList(datasetVectorInfoId);
            DatasetVector datasetVector = datasets.create(datasetVectorInfo);
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            WritableMap map = Arguments.createMap();
            map.putString("datasetVectorId",datasetVectorId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
