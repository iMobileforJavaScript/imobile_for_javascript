package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.GPSUtil;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.plugin.LocationManagePlugin;
import com.supermap.track.Track;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSTrack extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTrack";
    protected static Map<String, Track> m_TrackList = new HashMap<String, Track>();
    Track m_Track;
    ReactApplicationContext mContext;

    public JSTrack(ReactApplicationContext context) {
        super(context);
        mContext = context;
    }

    public static Track getObjFromList(String id) {
        return m_TrackList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Track obj) {
        for (Map.Entry entry : m_TrackList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_TrackList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            Track track = new Track(mContext);
            String trackId = registerId(track);

            WritableMap map = Arguments.createMap();
            map.putString("_trackId_",trackId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createDataset(String trackId, String datasourceId, String name, Promise promise){
        try{
            Track track = getObjFromList(trackId);
            Datasource datasource = JSDatasource.m_DatasourceList.get(datasourceId);
            DatasetVector datasetVector = track.createDataset(datasource,name);
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            WritableMap map = Arguments.createMap();
            map.putString("datasetVectorId",datasetVectorId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCustomLocation(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            boolean customLocation = track.getCustomLocation();

            WritableMap map = Arguments.createMap();
            map.putBoolean("customLocation",customLocation);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDataset(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            Dataset dataset = track.getDataset();
            String datasetId = JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDistanceInterval(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            double distanceInterval = track.getDistanceInterval();

            WritableMap map = Arguments.createMap();
            map.putDouble("distanceInterval",distanceInterval);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMatchDatasets(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            Datasets datasets = track.getMatchDatasets();
            String datasetsId = JSDatasets.registerId(datasets);

            WritableMap map = Arguments.createMap();
            map.putString("datasetsId",datasetsId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getTimeInterval(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            int timeInterval = track.getTimeInterval();

            WritableMap map = Arguments.createMap();
            map.putInt("timeInterval",timeInterval);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isSpeedDirectionEnable(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            boolean isSpeedDirectionEnable = track.isSpeedDirectionEnable();

            WritableMap map = Arguments.createMap();
            map.putBoolean("isSpeedDirectionEnable",isSpeedDirectionEnable);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setCustomLocation(String trackId,boolean bCustomLocation,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            track.setCustomLocation(bCustomLocation);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setDataset(String trackId,String datasetId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            Dataset dataset = JSDataset.getObjById(datasetId);
            track.setDataset(dataset);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setDistanceInterval(String trackId,double interval,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            track.setDistanceInterval(interval);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setGPSData(String trackId, ReadableMap jsonGpsData, Promise promise){
        try{
            Track track = getObjFromList(trackId);
            LocationManagePlugin.GPSData gspData = GPSUtil.convertToGPSData(jsonGpsData);
            track.setGPSData(gspData);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setMatchDatasets(String trackId,String datasetsId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            Datasets datasets = JSDatasets.m_DatasetsList.get(datasetsId);
            track.setMatchDatasets(datasets);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setSpeedDirectionEnable(String trackId,boolean speedDirectionEnable,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            track.setSpeedDirectionEnable(speedDirectionEnable);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setTimeInterval(String trackId,int timeInterval,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            track.setTimeInterval(timeInterval);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void startTrack(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            track.startTrack();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void stopTrack(String trackId,Promise promise){
        try{
            Track track = getObjFromList(trackId);
            track.stopTrack();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

