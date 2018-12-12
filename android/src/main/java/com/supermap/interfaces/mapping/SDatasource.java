package com.supermap.interfaces.mapping;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.supermap.RNUtils.FileUtil;
import com.supermap.data.Dataset;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.Workspace;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Map;
import com.supermap.smNative.SMDatasource;
import com.supermap.smNative.SMLayer;

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
}
