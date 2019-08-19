package com.supermap.interfaces.mapping;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.FileUtil;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.DatasetType;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.EncodeType;
import com.supermap.data.EngineType;
import com.supermap.data.Recordset;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Workspace;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Map;
import com.supermap.smNative.SMAnalyst;
import com.supermap.smNative.SMDatasource;
import com.supermap.smNative.SMLayer;

import java.io.File;
import java.util.HashMap;

public class SDatasource extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SDatasource";
    private static SDatasource analyst;
    ReactContext mReactContext;

    public SDatasource(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    /**
     * 创建数据源
     * @param params
     * @param promise
     */
    @ReactMethod
    public void createDatasource(ReadableMap params, Promise promise) {
        try {
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            Datasource datasource = null;
            DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(params.toHashMap());

            String server = params.getString("server");
            String serverParentPath = server.substring(0, server.lastIndexOf("/"));
            FileUtil.createDirectory(serverParentPath);

            datasource = workspace.getDatasources().create(info);
            if (params.toHashMap().containsKey("description")){
                String description = params.toHashMap().get("description").toString();
                datasource.setDescription(description);
            }
            promise.resolve(datasource != null);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createDatasourceOfLabel(ReadableMap params, Promise promise) {
        try {
            Workspace workspace = new Workspace();
            Datasource datasource = null;
            DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(params.toHashMap());

            String server = params.getString("server");
            String serverParentPath = server.substring(0, server.lastIndexOf("/"));
            FileUtil.createDirectory(serverParentPath);

            datasource = workspace.getDatasources().create(info);
            if (params.toHashMap().containsKey("description")){
                String description = params.toHashMap().get("description").toString();
                datasource.setDescription(description);
            }
            if(workspace!=null){
                workspace.close();
                workspace.dispose();
            }
            promise.resolve(datasource != null);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 打开数据源
     * @param params
     * @param promise
     */
    @ReactMethod
    public void openDatasource(ReadableMap params, Promise promise) {
        try {
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            Datasource datasource = null;
            DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(params.toHashMap());

            datasource = workspace.getDatasources().open(info);

            promise.resolve(datasource != null);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 重命名数据源
     * @param oldName
     * @param newName
     * @param promise
     */
    @ReactMethod
    public void renameDatasource(String oldName, String newName, Promise promise) {
        try {
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            Datasources datasources = workspace.getDatasources();
            datasources.RenameDatasource(oldName, newName);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 通过alias关闭数据源
     * @param alias
     * @param promise
     */
    @ReactMethod
    public void closeDatasourceByAlias(String alias, Promise promise) {
        try {
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            Datasources datasources = workspace.getDatasources();

            Boolean isClosed = true;
            if (alias == null || alias.equals("")) {
                datasources.closeAll();
            } else {
                isClosed = datasources.close(alias);
            }
            promise.resolve(isClosed);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 通过index关闭数据源
     * @param index
     * @param promise
     */
    @ReactMethod
    public void closeDatasourceByIndex(int index, Promise promise) {
        try {
            Workspace workspace = SMap.getSMWorkspace().getWorkspace();
            Datasources datasources = workspace.getDatasources();

            Boolean isClosed = true;
            if (index == -1) {
                datasources.closeAll();
            } else {
                isClosed = datasources.close(index);
            }
            promise.resolve(isClosed);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 删除数据源
     * @param path
     * @param promise
     */
    @ReactMethod
    public void deleteDatasource(String path, Promise promise) {
        try {
            boolean result = FileUtil.deleteFile(path);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 新建数据集
     * @param datasourceAlias
     * @param datasetName
     * @param datasetName
     * @param type
     */
    @ReactMethod
    public void createDataset(String datasourceAlias, String datasetName, int type, Promise promise) {
        DatasetVectorInfo datasetVectorInfo = null;
        try {
            DatasetType datasetType;
            if(type == 149) {
                datasetType = DatasetType.CAD;
            } else if(type == 7){
                datasetType = DatasetType.TEXT;
            } else if(type == 5){
                datasetType = DatasetType.REGION;
            } else if (type == 3) {
                datasetType = DatasetType.LINE;
            } else {
                datasetType = DatasetType.POINT;
            }

            Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
            Datasources datasources = workspace.getDatasources();
            Datasets datasets =  datasources.get(datasourceAlias).getDatasets();
            boolean hasDataset = datasets.contains(datasetName);
//            DatasetVector datasetVector = null;
            if(hasDataset){
                promise.resolve(false);
            } else {
                datasetVectorInfo = new DatasetVectorInfo();
                datasetVectorInfo.setType(datasetType);
                datasetVectorInfo.setName(datasetName);
                datasets.create(datasetVectorInfo);
                datasetVectorInfo.dispose();
                promise.resolve(true);
            }
        } catch (Exception e) {
            if(datasetVectorInfo != null) {
                datasetVectorInfo.dispose();
            }
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteDataset(String datasourceAlias, String datasetName, Promise promise) {
        try {
            Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
            Datasources datasources = workspace.getDatasources();
            Datasets datasets =  datasources.get(datasourceAlias).getDatasets();

            int index=datasets.indexOf(datasetName);
            promise.resolve(datasets.delete(index));
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isAvailableDatasetName(String datasourceAlias, String datasetName, Promise promise) {
        try {
            Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
            Datasources datasources = workspace.getDatasources();
            Datasets datasets =  datasources.get(datasourceAlias).getDatasets();
            promise.resolve(datasets.isAvailableDatasetName(datasetName));
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 从不同数据源中复制数据机
     * @param
     * @param promise
     */
    @ReactMethod
    public void copyDataset(String dataSourcePath, String toDataSourcePath, ReadableArray datasets, Promise promise) {
        try {
            Datasource datasource;
            Datasource toDataSource;
            Workspace workspace = null;
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();
            DatasourceConnectionInfo datasourceconnection2 = new DatasourceConnectionInfo();
            datasourceconnection.setEngineType(EngineType.UDB);
            datasourceconnection.setServer(dataSourcePath);
            datasourceconnection.setAlias("dataSource");
            datasourceconnection2.setEngineType(EngineType.UDB);
            datasourceconnection2.setServer(toDataSourcePath);
            datasourceconnection2.setAlias("toDataSource");
            workspace=new Workspace();
            datasource=workspace.getDatasources().open(datasourceconnection);
            toDataSource=workspace.getDatasources().open(datasourceconnection2);
            for (int i = 0; i < datasets.size(); i++) {
                DatasetVector datasetVector= (DatasetVector) datasource.getDatasets().get(datasets.getString(i));
                String datasetName=toDataSource.getDatasets().getAvailableDatasetName(datasetVector.getName());
                toDataSource.copyDataset(datasetVector,datasetName,EncodeType.INT32);
            }
            workspace.getDatasources().closeAll();
            workspace.dispose();
            datasourceconnection.dispose();
            datasourceconnection2.dispose();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDatasetToGeoJson(String datasourceAlias, String datasetName, String path, Promise promise) {
        try {
            File file = new File(path);
            Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
            Datasources datasources = workspace.getDatasources();
            DatasetVector datasetVector= (DatasetVector) datasources.get(datasourceAlias).getDatasets().get(datasetName);
            int re = datasetVector.toGeoJSON(file);

            promise.resolve(re);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void importDatasetFromGeoJson(String datasourceAlias, String datasetName, String path, int type, Promise promise) {
        try {

            DatasetType datasetType;
            if(type == 5){
                datasetType = DatasetType.REGION;
            } else if (type == 3) {
                datasetType = DatasetType.LINE;
            } else {
                datasetType = DatasetType.POINT;
            }
            File file = new File(path);
            Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
            Datasources datasources = workspace.getDatasources();
            Datasets datasets =  datasources.get(datasourceAlias).getDatasets();
            boolean hasDataset = datasets.contains(datasetName);
            DatasetVector datasetVector = null;
            if(hasDataset){
                datasetVector= (DatasetVector) datasets.get(datasetName);
            } else {
                DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
                datasetVectorInfo.setType(datasetType);
                datasetVectorInfo.setName(datasetName);
                datasetVector = datasets.create(datasetVectorInfo);
                datasetVectorInfo.dispose();
            }

            int re = datasetVector.fromGeoJSON(file);

            promise.resolve(re);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *  根据名称移除UDB中数据集
     *  @param path UDB在内存中路径
     * @param promise
     */
    @ReactMethod
    public void removeDatasetByName(String path,String name, Promise promise) {
        try {
            File tempFile = new File(path.trim());
            String[] strings = tempFile.getName().split("\\.");
            String udbName = strings[0];
            Datasource datasource;
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();
            Workspace   workspace=new Workspace();
            datasourceconnection.setEngineType(EngineType.UDB);
            datasourceconnection.setServer(path);
            datasourceconnection.setAlias(udbName);
            datasource=workspace.getDatasources().open(datasourceconnection);
            int index=datasource.getDatasets().indexOf(name);
            datasource.getDatasets().delete(index);
            if(workspace!=null){
                workspace.getDatasources().closeAll();
                workspace.close();
                workspace.dispose();
            }
            datasourceconnection.dispose();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取数据源列表
     * @param promise
     */
    @ReactMethod
    public void getDatasources(Promise promise) {
        try {
            WritableArray dsArr = Arguments.createArray();
            Workspace workspace = SMap.getInstance().getSmMapWC().getWorkspace();
            Datasources datasources = workspace.getDatasources();

            for (int i = 0; i < datasources.getCount(); i++) {
                Datasource datasource = datasources.get(i);
                DatasourceConnectionInfo info = datasource.getConnectionInfo();

                WritableMap dataInfo = Arguments.createMap();
                dataInfo.putString("alias", info.getAlias());
                dataInfo.putInt("engineType", info.getEngineType().value());
                dataInfo.putString("server", info.getServer());
                dataInfo.putString("driver", info.getDriver());
                dataInfo.putString("user", info.getUser());
                dataInfo.putBoolean("readOnly", info.isReadOnly());
                dataInfo.putString("password", info.getPassword());

                dsArr.pushMap(dataInfo);
            }

            promise.resolve(dsArr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定数据源中的数据集中的字段信息
     * @param
     * @param promise
     */
    @ReactMethod
    public void getFieldInfos(ReadableMap infoMap, ReadableMap filter, boolean autoOpen, Promise promise) {
        try {
            HashMap<String, Object> data = infoMap.toHashMap();

            String alias = null;

            if (data.containsKey("Alias")) {
                alias = data.get("Alias").toString();
            } else if (data.containsKey("alias")) {
                alias = data.get("alias").toString();
            }
            String datasetName = data.get("datasetName").toString();

            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();

            Datasource datasource = datasources.get(alias);
            if (datasource == null && autoOpen) {
                Workspace workspace = SMap.getSMWorkspace().getWorkspace();
                DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(data);

                datasource = workspace.getDatasources().open(info);
            } else if (datasource == null || datasource.getConnectionInfo().getEngineType() != EngineType.UDB) {
                //除了UDB数据源都排除
                promise.resolve(Arguments.createMap());
                return;
            }

            Dataset dataset = datasource.getDatasets().get(datasetName);
            WritableArray infos = Arguments.createArray();
            if (dataset != null) {
                Recordset recordset = ((DatasetVector)dataset).getRecordset(false, CursorType.STATIC);
                infos = JsonUtil.getFieldInfos(recordset, filter);
            }

            promise.resolve(infos);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定数据源中的数据集
     * @param
     * @param promise
     */
    @ReactMethod
    public void getDatasetsByDatasource(ReadableMap infoMap, boolean autoOpen, Promise promise) {
        try {
            HashMap<String, Object> data = infoMap.toHashMap();

            String alias = null;

            if (data.containsKey("Alias")) {
                alias = data.get("Alias").toString();
            } else if (data.containsKey("alias")) {
                alias = data.get("alias").toString();
            }

            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();

            Datasource datasource = datasources.get(alias);
            if (datasource == null && autoOpen) {
                Workspace workspace = SMap.getSMWorkspace().getWorkspace();
                DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(data);

                datasource = workspace.getDatasources().open(info);
            } else if (datasource == null || datasource.getConnectionInfo().getEngineType() != EngineType.UDB) {
                //除了UDB数据源都排除
                promise.resolve(Arguments.createMap());
                return;
            }

            Datasets datasets = datasource.getDatasets();
            int datasetsCount = datasets.getCount();

            WritableArray arr = Arguments.createArray();
            for (int j = 0; j < datasetsCount; j++) {
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("datasetName", datasets.get(j).getName());
                writeMap.putInt("datasetType", datasets.get(j).getType().value());
                writeMap.putString("datasourceName", datasource.getAlias());
                arr.pushMap(writeMap);
            }

            WritableMap map = Arguments.createMap();
            String datasourceAlias = datasource.getAlias();
            map.putString("alias", datasourceAlias);

            WritableMap writableMap = Arguments.createMap();
            writableMap.putArray("list", arr);
            writableMap.putMap("datasource", map);

            promise.resolve(writableMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据数据源目录，获取指定数据源中的数据集（非工作空间已存在的数据源）
     * @param infoMap
     * @param promise
     */
    @ReactMethod
    public void getDatasetsByExternalDatasource(ReadableMap infoMap, Promise promise) {
        try {
            HashMap<String, Object> data = infoMap.toHashMap();
            Workspace workspaceTemp = new Workspace();
//            String alias = "";
//
//            if (data.containsKey("Alias")) {
//                alias = data.get("Alias").toString();
//            } else if (data.containsKey("alias")) {
//                alias = data.get("alias").toString();
//            }

            DatasourceConnectionInfo info = SMDatasource.convertDicToInfo(data);
            Datasource datasource = workspaceTemp.getDatasources().open(info);

            Datasets datasets = datasource.getDatasets();
            int datasetsCount = datasets.getCount();

            WritableArray arr = Arguments.createArray();
            for (int j = 0; j < datasetsCount; j++) {
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("datasetName", datasets.get(j).getName());
                writeMap.putInt("datasetType", datasets.get(j).getType().value());
                writeMap.putString("datasourceName", datasource.getAlias());
                arr.pushMap(writeMap);
            }

            promise.resolve(arr);

            info.dispose();
            workspaceTemp.close();
            workspaceTemp.dispose();

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取数据集范围
     * @param sourceData 数据源和数据集信息
     * @param promise
     */
    @ReactMethod
    public void getDatasetBounds(ReadableMap sourceData, Promise promise) {
        try {
            DatasetVector sourceDataset = (DatasetVector)SMAnalyst.getDatasetByDictionary(sourceData);

            WritableMap boundPoints = Arguments.createMap();
            if (sourceDataset != null) {
                Rectangle2D bounds = sourceDataset.computeBounds();
                boundPoints.putDouble("left", bounds.getLeft());
                boundPoints.putDouble("bottom", bounds.getBottom());
                boundPoints.putDouble("right", bounds.getRight());
                boundPoints.putDouble("top", bounds.getTop());
                boundPoints.putDouble("width", bounds.getWidth());
                boundPoints.putDouble("height", bounds.getHeight());
            }

            promise.resolve(boundPoints);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}
