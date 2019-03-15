package com.supermap.interfaces.mapping;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.supermap.RNUtils.FileUtil;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.EncodeType;
import com.supermap.data.EngineType;
import com.supermap.data.Workspace;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Map;
import com.supermap.smNative.SMDatasource;
import com.supermap.smNative.SMLayer;

import java.io.File;

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
     * 从不同数据源中复制数据机
     * @param
     * @param promise
     */
    @ReactMethod
    public void copyDataset(String dataSourcePath, String toDataSourcePath, ReadableArray datasets, Promise promise) {
        try {
            File tempFile = new File(dataSourcePath.trim());
            File tempFile2 = new File(toDataSourcePath.trim());
            String[] strings = tempFile.getName().split("\\.");
            String[] strings2 = tempFile2.getName().split("\\.");
            String udbName = strings[0];
            String udbName2 = strings2[0];
            Datasource datasource;
            Datasource toDataSource;
            Workspace workspace = null;
            SMap sMap = SMap.getInstance();
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();
            DatasourceConnectionInfo datasourceconnection2 = new DatasourceConnectionInfo();
            datasourceconnection.setEngineType(EngineType.UDB);
            datasourceconnection.setServer(dataSourcePath);
            datasourceconnection.setAlias(udbName);
            datasourceconnection2.setEngineType(EngineType.UDB);
            datasourceconnection2.setServer(toDataSourcePath);
            datasourceconnection2.setAlias(udbName2);
            if(sMap.getSmMapWC().getMapControl()==null){
                workspace=new Workspace();
                datasource=workspace.getDatasources().open(datasourceconnection);
                toDataSource=workspace.getDatasources().open(datasourceconnection2);
                for (int i = 0; i < datasets.size(); i++) {
                    DatasetVector datasetVector= (DatasetVector) datasource.getDatasets().get(datasets.getString(i));
                    String datasetName=toDataSource.getDatasets().getAvailableDatasetName(datasetVector.getName());
                    toDataSource.copyDataset(datasetVector,datasetName,EncodeType.INT32);
                }
            }
            workspace.dispose();
            datasourceconnection.dispose();
            datasourceconnection2.dispose();
            promise.resolve(true);
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
            Workspace workspace = null;
            SMap sMap = SMap.getInstance();
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();

//            if (sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().indexOf(udbName) != -1) {
//                sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().close(udbName);
//            }
            if(sMap.getSmMapWC().getMapControl()==null){
                workspace=new Workspace();
                datasourceconnection.setEngineType(EngineType.UDB);
                datasourceconnection.setServer(path);
                datasourceconnection.setAlias(udbName);
                datasource=workspace.getDatasources().open(datasourceconnection);
                datasource.getDatasets().delete(name);
            }else {
                sMap.getSmMapWC().getMapControl().getMap().setWorkspace(sMap.getSmMapWC().getWorkspace());
                if (sMap.getSmMapWC().getMapControl().getMap().getWorkspace().getDatasources().indexOf(udbName) != -1) {
                    datasource = sMap.getSmMapWC().getMapControl().getMap().getWorkspace().getDatasources().get(udbName);
                    datasource.getDatasets().delete(name);
                } else {
                    datasourceconnection.setEngineType(EngineType.UDB);
                    datasourceconnection.setServer(path);
                    datasourceconnection.setAlias(udbName);
                    datasource = sMap.getSmMapWC().getMapControl().getMap().getWorkspace().getDatasources().open(datasourceconnection);
                    datasource.getDatasets().delete(name);
                }
            }
            if(workspace!=null){
                workspace.dispose();
            }
            datasourceconnection.dispose();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}
