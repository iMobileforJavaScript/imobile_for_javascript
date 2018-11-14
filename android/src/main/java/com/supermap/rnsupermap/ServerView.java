package com.supermap.rnsupermap;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.data.Dataset;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.Datasources;
import com.supermap.data.EngineType;
import com.supermap.data.Environment;
import com.supermap.data.Workspace;
import com.supermap.mapping.Layers;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;

/**
 * Created by will on 2016/6/14.
 */
public class ServerView extends SimpleViewManager<MapView> {
    public static final String REACT_NAME="ServerView";
    private final String sdcard = android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();
    MapView m_MapView;
    Workspace m_Workspace;
    MapControl m_MapControl;
    Map m_Map;
    DatasourceConnectionInfo dsInfo;
    Datasources m_Datasources;
    Datasource m_Datasource;
    Datasets m_Datasets;
    Dataset m_Dataset;
    Layers m_Layers;

    @Override
    public String getName(){
        return REACT_NAME;
    }

    @Override
    public MapView createViewInstance(ThemedReactContext reactContext){

        // 设置许可路径
        Environment.setLicensePath(sdcard + "/SuperMap/license/");
        // 初始化环境
        Environment.initialization(reactContext.getBaseContext());

        m_Workspace = new Workspace();
        m_MapView=new MapView(reactContext.getBaseContext());
        m_MapControl=m_MapView.getMapControl();

        m_Map = m_MapControl.getMap();
        m_Map.setWorkspace(m_Workspace);

        dsInfo=new DatasourceConnectionInfo();

        System.out.print("dsInfo----------------------");
        dsInfo.setServer("http://192.168.13.239:8090/iserver/services/map-china400/rest/maps/China");
        dsInfo.setEngineType(EngineType.Rest);
        dsInfo.setAlias("ChinaRest");

        m_Datasources=m_Workspace.getDatasources();
        m_Datasource=m_Datasources.open(dsInfo);

        if(m_Datasource!=null){
            m_Layers=m_Map.getLayers();
            m_Datasets=m_Datasource.getDatasets();
            m_Dataset=m_Datasets.get(0);
            m_Layers.add(m_Dataset,true);
            m_Map.refresh();
        }
        return m_MapView;
    }
}
