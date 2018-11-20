package com.supermap.rnsupermap;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasource;
import com.supermap.services.DataDownloadService;

import java.util.Calendar;
import java.util.Map;

public class JSDataDownloadService extends JSServiceBase {
    public static final String REACT_CLASS = "JSDataDownloadService";

    public JSDataDownloadService(ReactApplicationContext context) {
        super(context);
    }

    public static DataDownloadService getObjFromList(String id) {
        return (DataDownloadService)m_ServiceBaseList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(DataDownloadService obj) {
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
            DataDownloadService dataDownloadService = new DataDownloadService(url);
            String dataDownloadServiceId = registerId(dataDownloadService);

            WritableMap map = Arguments.createMap();
            map.putString("_dataDownloadServiceId_",dataDownloadServiceId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void download(String dataDownloadServiceId,final String fullUrl,final int fromIndex,final int toIndex,Promise promise){
        try{
            final DataDownloadService dataDownloadService = getObjFromList(dataDownloadServiceId);
            Handler downLoadHandler = new Handler();
            downLoadHandler.post(new Runnable() {
                @Override
                public void run() {
                    dataDownloadService.download(fullUrl,fromIndex,toIndex);
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void downloadByName(String dataDownloadServiceId,final String serviceName,final String datasourceName,final String datasetName,final int fromIndex,final int toIndex,Promise promise){
        try{
            final DataDownloadService dataDownloadService = getObjFromList(dataDownloadServiceId);
            Handler downLoadHandler = new Handler();
            downLoadHandler.post(new Runnable() {
                @Override
                public void run() {
                    dataDownloadService.download(serviceName,datasourceName,datasetName,fromIndex,toIndex);
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void downloadAll(String dataDownloadServiceId,final String fullUrl,Promise promise){
        try{
            final DataDownloadService dataDownloadService = getObjFromList(dataDownloadServiceId);
            Handler downLoadHandler = new Handler();
            downLoadHandler.post(new Runnable() {
                @Override
                public void run() {
                    dataDownloadService.downloadAll(fullUrl);
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void downloadAllByName(String dataDownloadServiceId,final String serviceName,final String datasourceName,final String datasetName,Promise promise){
        try{
            final DataDownloadService dataDownloadService = getObjFromList(dataDownloadServiceId);
            Handler downLoadHandler = new Handler();
            downLoadHandler.post(new Runnable() {
                @Override
                public void run() {
                    dataDownloadService.downloadAll(serviceName,datasourceName,datasetName);
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void downloadDataset(String dataDownloadServiceId,final String urlDatset,String datasourceId,Promise promise){
        try{
            final DataDownloadService dataDownloadService = getObjFromList(dataDownloadServiceId);
            final Datasource datasource = JSDatasource.m_DatasourceList.get(datasourceId);
            Handler downLoadHandler = new Handler();
            downLoadHandler.post(new Runnable() {
                @Override
                public void run() {
                    dataDownloadService.downloadDataset(urlDatset,datasource);
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void updateDataset(String dataDownloadServiceId,final String urlDatset,String datasetId,Promise promise){
        try{
            final DataDownloadService dataDownloadService = getObjFromList(dataDownloadServiceId);
            final Dataset dataset = JSDataset.getObjById(datasetId);
            Handler downLoadHandler = new Handler();
            downLoadHandler.post(new Runnable() {
                @Override
                public void run() {
                    dataDownloadService.updateDataset(urlDatset,(DatasetVector)dataset);
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

