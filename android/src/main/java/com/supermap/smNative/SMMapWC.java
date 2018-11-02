package com.supermap.smNative;

import com.supermap.data.Dataset;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.EngineType;
import com.supermap.data.Enum;
import com.supermap.data.Workspace;
import com.supermap.data.WorkspaceConnectionInfo;
import com.supermap.data.WorkspaceType;
import com.supermap.data.WorkspaceVersion;
import com.supermap.mapping.MapControl;
import com.supermap.data.DatasetType;

import java.util.Map;

public class SMMapWC {
    Workspace workspace;
    MapControl mapControl;

    public Workspace getWorkspace() {
        return workspace;
    }

    public void setWorkspace(Workspace workspace) {
        this.workspace = workspace;
    }

    public MapControl getMapControl() {
        return mapControl;
    }

    public void setMapControl(MapControl mapControl) {
        this.mapControl = mapControl;
    }

    public boolean openWorkspace(Map data) {
        try {
            WorkspaceConnectionInfo info = new WorkspaceConnectionInfo();
            if (data.containsKey("name")) {
                info.setName(data.get("name").toString());
            }
            if (data.containsKey("password")) {
                info.setPassword(data.get("password").toString());
            }
            if (data.containsKey("server")) {
                info.setServer(data.get("server").toString());
            }
            if (data.containsKey("type")) {
                Double type = Double.parseDouble(data.get("type").toString());
                info.setType((WorkspaceType) Enum.parse(WorkspaceType.class, type.intValue()));
            }
            if (data.containsKey("user")) {
                info.setUser(data.get("user").toString());
            }
            if (data.containsKey("version")) {
                Double version = Double.parseDouble(data.get("version").toString());
                info.setVersion((WorkspaceVersion) Enum.parse(WorkspaceVersion.class, version.intValue()));
            }

            boolean result = this.workspace.open(info);
            info.dispose();
            this.mapControl.getMap().setWorkspace(this.workspace);
            return result;
        } catch (Exception e) {
            throw e;
        }
    }

    public Datasource openDatasource(Map data) {
        try {
            DatasourceConnectionInfo info = new DatasourceConnectionInfo();
            if (data.containsKey("alias")){
                String alias = data.get("alias").toString();
                info.setAlias(alias);

                if (this.workspace.getDatasources().indexOf(alias) != -1) {
                    this.workspace.getDatasources().close(alias);
                }
            }
            if (data.containsKey("engineType")){
                Double type = Double.parseDouble(data.get("engineType").toString());
                info.setEngineType((EngineType) Enum.parse(EngineType.class, type.intValue()));
            }
            if (data.containsKey("server")){
                info.setServer(data.get("server").toString());
            }


            if (data.containsKey("driver")) info.setDriver(data.get("driver").toString());
            if (data.containsKey("user")) info.setUser(data.get("user").toString());
            if (data.containsKey("readOnly")) info.setReadOnly(Boolean.parseBoolean(data.get("readOnly").toString()));
            if (data.containsKey("password")) info.setPassword(data.get("password").toString());
            if (data.containsKey("webCoordinate")) info.setWebCoordinate(data.get("webCoordinate").toString());
            if (data.containsKey("webVersion")) info.setWebVersion(data.get("webVersion").toString());
            if (data.containsKey("webFormat")) info.setWebFormat(data.get("webFormat").toString());
            if (data.containsKey("webVisibleLayers")) info.setWebVisibleLayers(data.get("webVisibleLayers").toString());
            if (data.containsKey("webExtendParam")) info.setWebExtendParam(data.get("webExtendParam").toString());

            Datasource dataSource = this.workspace.getDatasources().open(info);
            info.dispose();

            return dataSource;
        } catch (Exception e) {
            throw e;
        }
    }

    public Dataset addDatasetByName(String name, int datasetType, String datasourceName, String datasourcePath) {
        try {
            String dsName = name;
            if (dsName.equals("")) {
                switch (datasetType) {
                    case 1: // POINT
                        dsName = "COL_POINT";
                        break;
                    case 3: // LINE
                        dsName = "COL_LINE";
                        break;
                    case 5: // REGION
                        dsName = "COL_REGION";
                        break;
                    default:
                        dsName = "COL_POINT";
                        break;
                }
            }

            Datasource datasource = workspace.getDatasources().get(datasourceName);
            if (datasource == null || datasource.isReadOnly()) {
                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias(datasourceName);
                info.setEngineType(EngineType.UDB);
                info.setServer(datasourcePath + "/" + datasourceName + ".udb");

                datasource = workspace.getDatasources().create(info);
            }

            Datasets datasets = datasource.getDatasets();
            Dataset dataset = datasets.get(dsName);

            if (dataset == null) {
                String dsAvailableName = datasets.getAvailableDatasetName(dsName);
                DatasetVectorInfo info = new DatasetVectorInfo(dsAvailableName, (DatasetType)Enum.parse(DatasetType.class, datasetType));
                dataset = datasets.create(info);
            }

            return dataset;
        } catch (Exception e) {
            throw e;
        }
    }
}
