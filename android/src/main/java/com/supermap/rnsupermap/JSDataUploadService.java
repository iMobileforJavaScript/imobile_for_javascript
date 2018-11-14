package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.services.DataUploadService;
import com.supermap.services.Feature;

import java.util.Calendar;
import java.util.Map;

public class JSDataUploadService extends JSServiceBase {
    public static final String REACT_CLASS = "JSDataUploadService";
    DataUploadService m_DataUploadService;

    public JSDataUploadService(ReactApplicationContext context) {
        super(context);
    }

    public static DataUploadService getObjFromList(String id) {
        return (DataUploadService)m_ServiceBaseList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(DataUploadService obj) {
        for (Map.Entry entry : m_ServiceBaseList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ServiceBaseList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(String url,Promise promise){
        try{
            DataUploadService dataUploadService = new DataUploadService(url);
            String dataUploadServiceId = registerId(dataUploadService);

            WritableMap map = Arguments.createMap();
            map.putString("_dataUploadServiceId_",dataUploadServiceId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addDataset(String dataUploadServiceId,String fullUrl,String datasetName,int datasetType,
                           Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            dataUploadService.addDataset(fullUrl,datasetName,(DatasetType) Enum.parse(DatasetType.class,datasetType));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void cloneDataset(String dataUploadServiceId,String serviceName,String datasourceName,String destDatasetName,
                           String srcDatasourceName,String srcDatasetName,Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            dataUploadService.addDataset(serviceName,datasourceName,destDatasetName,srcDatasourceName,srcDatasetName);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addFeature(String dataUploadServiceId,String fullUrl,String featureId,Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            Feature feature = JSFeature.getObjFromList(featureId);

            dataUploadService.addFeature(fullUrl,feature);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addFeatureByName(String dataUploadServiceId,String serviceName,String datasourceName,
                                 String datasetName,String featureId,Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            Feature feature = JSFeature.getObjFromList(featureId);

            dataUploadService.addFeature(serviceName,datasourceName,datasetName,feature);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteFeature(String dataUploadServiceId, String fullUrl, ReadableArray featureIDs, Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            int featureId[] = {};
            for(int i=0;i<featureIDs.size();i++){
                featureId[i] = featureIDs.getInt(i);
            }
            dataUploadService.deleteFeature(fullUrl,featureId);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteFeatureByName(String dataUploadServiceId,String serviceName, String datasourceName,
                                    String datasetName, ReadableArray featureIDs, Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            int featureId[] = {};
            for(int i=0;i<featureIDs.size();i++){
                featureId[i] = featureIDs.getInt(i);
            }
            dataUploadService.deleteFeature(serviceName,datasourceName,datasetName,featureId);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void modifyFeature(String dataUploadServiceId,String fullUrl,int featureID,String featureId,Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            Feature feature = JSFeature.getObjFromList(featureId);

            dataUploadService.modifyFeature(fullUrl,featureID,feature);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void modifyFeatureByName(String dataUploadServiceId,String serviceName, String datasourceName,
                                    String datasetName, int featureID,String featureId, Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            Feature feature = JSFeature.getObjFromList(featureId);
            dataUploadService.modifyFeature(serviceName,datasourceName,datasetName,featureID,feature);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void commitDataset(String dataUploadServiceId,String urlDataset,String datasetId,Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            Dataset dataset = JSDataset.getObjById(datasetId);
            dataUploadService.commitDataset(urlDataset,(DatasetVector)dataset);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteDataset(String dataUploadServiceId, String fullUrl, Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            dataUploadService.deleteDataset(fullUrl);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteDatasetByName(String dataUploadServiceId,String serviceName, String datasourceName,
                                    String datasetName, Promise promise){
        try{
            DataUploadService dataUploadService =  getObjFromList(dataUploadServiceId);
            dataUploadService.deleteDataset(serviceName,datasourceName,datasetName);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

