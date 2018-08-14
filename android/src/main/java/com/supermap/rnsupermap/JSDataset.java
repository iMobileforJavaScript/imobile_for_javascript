package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasource;
import com.supermap.data.EncodeType;
import com.supermap.data.Enum;
import com.supermap.data.PrjCoordSys;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/17.
 */
public class JSDataset extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSDataset";
    public static Map<String , Dataset> m_DatasetList = new HashMap<String , Dataset>();
    Dataset m_dataset;

    public JSDataset(ReactApplicationContext context){
        super(context);
    }

    public static Dataset getObjById(String id){
        return m_DatasetList.get(id);
    }



    @Override
    public String getName(){return REACT_CLASS;}

    public static String registerId(Dataset dataset){
        for(Map.Entry entry:m_DatasetList.entrySet())
        {
            if(dataset.equals(entry.getValue())){
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        m_DatasetList.put(id,dataset);
        return id;
    }

    @ReactMethod
    public void toDatasetVector(String datasetId, Promise promise){
        try{
            DatasetVector datasetVector = (DatasetVector)m_DatasetList.get(datasetId);
            String datasetVectorId = JSDatasetVector.registerId(datasetVector);

            WritableMap map = Arguments.createMap();
            map.putString("datasetVectorId",datasetVectorId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getPrjCoordSys(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            PrjCoordSys prjCoordSys = dataset.getPrjCoordSys();
            String prjCoordSysId = JSPrjCoordSys.registerId(prjCoordSys);

            WritableMap map = Arguments.createMap();
            map.putString("prjCoordSysId",prjCoordSysId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void openDataset(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            boolean opened = dataset.open();

            WritableMap map = Arguments.createMap();
            map.putBoolean("opened",opened);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isopen(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            boolean opened = dataset.isOpen();

            WritableMap map = Arguments.createMap();
            map.putBoolean("opened",opened);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getType(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            DatasetType type = dataset.getType();
            int typecode = Enum.getValueByName(DatasetType.class,type.name());

            WritableMap map = Arguments.createMap();
            map.putInt("type",typecode);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDatasource(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            Datasource datasource = dataset.getDatasource();
            String datasourceId = JSDatasource.registerId(datasource);

            WritableMap map = Arguments.createMap();
            map.putString("datasourceId",datasourceId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getEncodeType(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            EncodeType type = dataset.getEncodeType();
            int typecode = Enum.getValueByName(EncodeType.class,type.name());

            WritableMap map = Arguments.createMap();
            map.putInt("type",typecode);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void DSgetName(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            String name = dataset.getName();

            WritableMap map = Arguments.createMap();
            map.putString("name",name);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void close(String datasetId, Promise promise){
        try{
            Dataset dataset = m_DatasetList.get(datasetId);
            dataset.close();
            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}
