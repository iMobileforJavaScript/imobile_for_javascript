package com.supermap.interfaces.mapping;

import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

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
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.analyst.TopologyProcessing;
import com.supermap.analyst.TopologyProcessingOptions;
import com.supermap.analyst.networkanalyst.NetworkBuilder;
import com.supermap.analyst.networkanalyst.NetworkSplitMode;
import com.supermap.containts.EventConst;
import com.supermap.data.Color;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.Datasources;
import com.supermap.data.EncodeType;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoStyle;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Recordset;
import com.supermap.mapping.CalloutAlignment;
import com.supermap.mapping.EditHistoryType;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.Layers;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;
import com.supermap.mapping.TrackingLayer;
import com.supermap.navi.NaviInfo;
import com.supermap.navi.NaviListener;
import com.supermap.navi.NaviPath;
import com.supermap.navi.NaviStep;
import com.supermap.navi.Navigation3;
import com.supermap.plugin.LocationManagePlugin;
import com.supermap.plugin.SpeakPlugin;
import com.supermap.plugin.Speaker;
import com.supermap.rnsupermap.R;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.collector.SMCollector;
import com.supermap.smNative.components.InfoCallout;
import com.supermap.smNative.components.SNavigation2;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import static com.supermap.RNUtils.FileUtil.homeDirectory;

public class SNavigationManager extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SNavigationManager";
    private static SMap sMap = null;
    private static SpeakPlugin mSpeakPlugin;
    private static ReactContext mReactContext;
    private SNavigation2 sNavigation2;
    private InfoCallout m_callout;
    private Datasource incrementDatasource;
    private String incrementLineDatasetName;
    private String incrementNetworkDatasetName;
    private boolean incrementLayerAdded = false;
    private Point2Ds GpsPoint2Ds = new Point2Ds();

    public SNavigationManager(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    /**
     * 初始化导航语音播报
     * @param promise
     */
    @ReactMethod
    public void initSpeakPlugin(Promise promise){
        try {
            SpeakPlugin speakPlugin= SpeakPlugin.getInstance();
            speakPlugin.setSpeakSpeed(5000);
            speakPlugin.setSpeaker(Speaker.YUNXIA);
            speakPlugin.setSpeakVolum(32768);
            boolean isLaungched =speakPlugin.laugchPlugin();
            if(isLaungched){
                mSpeakPlugin = speakPlugin;
            }
            promise.resolve(isLaungched);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 销毁语音播报
     * @param promise
     */
    @ReactMethod
    public void destroySpeakPlugin(Promise promise){
        try{
            boolean isDestroyed = true;
            if(mSpeakPlugin != null){
                isDestroyed = mSpeakPlugin.terminatePlugin();
            }
            promise.resolve(isDestroyed);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 清除导航路线
     *
     * @param promise
     */
    @ReactMethod
    public void clearTrackingLayer(Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().getTrackingLayer().clear();
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 获取导航路径长度
     *
     * @param isIndoor 是否是室内
     * @param promise
     */
    @ReactMethod
    public void getNavPathLength(boolean isIndoor, Promise promise) {
        try {
            sMap = SMap.getInstance();
            NaviPath naviPath;
            if (isIndoor) {
                naviPath = sMap.getSmMapWC().getMapControl().getNavigation3().getNaviPath();
            } else {
                if(sNavigation2 != null){
                    naviPath = sNavigation2.getNavigation().getNaviPath();
                }else {
                    naviPath = sMap.smMapWC.getMapControl().getNavigation2().getNaviPath();
                }
            }
            WritableMap map = Arguments.createMap();
            map.putInt("length", (int) naviPath.getLength());
            promise.resolve(map);
        } catch (Exception e) {
            WritableMap map = Arguments.createMap();
            map.putInt("length",0);
            promise.resolve(map);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 获取导航路径详情
     *
     * @param isIndoor
     * @param promise
     */
    @ReactMethod
    public void getPathInfos(boolean isIndoor, Promise promise) {
        try {
            sMap = SMap.getInstance();
            NaviPath naviPath;
            if (isIndoor) {
                naviPath = sMap.getSmMapWC().getMapControl().getNavigation3().getNaviPath();
            } else {
                if(sNavigation2 != null){
                    naviPath = sNavigation2.getNavigation().getNaviPath();
                }else {
                    naviPath = sMap.smMapWC.getMapControl().getNavigation2().getNaviPath();
                }
            }
            ArrayList<NaviStep> naviStep = naviPath.getStep();
            WritableArray array = Arguments.createArray();
            for (int i = 0; i < naviStep.size(); i++) {
                WritableMap map = Arguments.createMap();
                NaviStep naviStep1 = naviStep.get(i);

                //String routeName = naviStep1.getName();
                int roadLength = (int) naviStep1.getLength();
                int type = naviStep1.getToSwerve();
                //map.putString("routeName", routeName);
                map.putDouble("roadLength", roadLength);
                map.putInt("turnType", type);
                array.pushMap(map);
            }
            promise.resolve(array);
        } catch (Exception e) {
            WritableArray array = Arguments.createArray();
            promise.resolve(array);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 绘制在线路径分析的路径
     * @param pathInfos
     * @param promise
     */
    @ReactMethod
    public void drawOnlinePath(ReadableArray pathInfos, Promise promise){
        try {
            sMap = SMap.getInstance();
            TrackingLayer trackingLayer = sMap.smMapWC.getMapControl().getMap().getTrackingLayer();
            trackingLayer.clear();
            Point2Ds point2Ds = new Point2Ds();

            for(int i = 0; i < pathInfos.size(); i++){
                ReadableMap map = pathInfos.getMap(i);
                double x = map.getDouble("x");
                double y = map.getDouble("y");

                Point2D point2D = new Point2D(x,y);
                point2Ds.add(point2D);
            }

            GeoLine geoLine = new GeoLine(point2Ds);
            GeoStyle geoStyle = new GeoStyle();

            Color color = new Color(0,191,255);
            geoStyle.setLineSymbolID(15);
            geoStyle.setLineColor(color);
            geoLine.setStyle(geoStyle);

            trackingLayer.add(geoLine,"线路");
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }
    /**
     * 设置行业导航参数
     *
     * @param promise
     */
    @ReactMethod
    public void startNavigation(ReadableMap selectedItem, Promise promise) {
        try {
            sMap = SMap.getInstance();
            String networkDatasetName = selectedItem.getString("datasetName");
            String datasourceName = selectedItem.getString("datasourceName");
            String netModelFileName = selectedItem.getString("modelFileName");

            String strUserName = sMap.smMapWC.getUserName();
            String strRootPath = homeDirectory + "/iTablet/User/";
            String netModelPath = strRootPath + strUserName + "/Data/Datasource/" + netModelFileName + ".snm";

            Datasource datasource =  SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().get(datasourceName);
            Dataset dataset = datasource.getDatasets().get(networkDatasetName);
            if (dataset != null) {
                // 初始化行业导航对象
                DatasetVector networkDataset = (DatasetVector) dataset;
                if(sNavigation2 == null){
                    sNavigation2 = new SNavigation2(sMap.smMapWC.getMapControl());
                }
                GeoStyle style = new GeoStyle();
                style.setLineSymbolID(964882);
                style.setLineColor(new Color(82,198,233));
                sNavigation2.setRouteStyle(style);
                sNavigation2.setNetworkDataset(networkDataset);    // 设置网络数据集
                sNavigation2.loadModel(netModelPath);  // 加载网络模型
                sNavigation2.getNavigation().addNaviInfoListener(new NaviListener() {
                    @Override
                    public void onStopNavi() {
                        mSpeakPlugin.stopPlay();
                        // TODO Auto-generated method stub
                        Log.e("+++++++++++++", "-------------****************");
                        mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit(EventConst.STOPNAVIAGTION, true);
                    }

                    @Override
                    public void onStartNavi() {
                        // TODO Auto-generated method stub
                        Log.e("+++++++++++++", "-------------****************");
                    }

                    @Override
                    public void onNaviInfoUpdate(NaviInfo arg0) {
                        // TODO Auto-generated method stub
                        Log.e("+++++++++++++", "-------------****************");
                    }

                    @Override
                    public void onAarrivedDestination() {
                        // TODO Auto-generated method stub
                        Log.e("+++++++++++++", "-------------****************");
                        mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit(EventConst.INDUSTRYNAVIAGTION, true);
                    }

                    @Override
                    public void onAdjustFailure() {
                        // TODO Auto-generated method stub
                        Log.e("+++++++++++++", "-------------****************");
                    }

                    @Override
                    public void onPlayNaviMessage(String arg0) {
                        mSpeakPlugin.playSound(arg0);
                        // TODO Auto-generated method stub
                        Log.e("+++++++++++++", "-------------****************");
                    }
                });
                sNavigation2.getNavigation().enablePanOnGuide(true);
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 清除行业导航起始点
     */
    private void clearOutdoorPoint() {
        sMap = SMap.getInstance();
        MapView mapView = sMap.smMapWC.getMapControl().getMap().getMapView();
        mapView.removeCallOut("startpoint");
        mapView.removeCallOut("endpoint");
    }

    /**
     * 是否在导航过程中（处理是否退出fullMap）
     *
     * @param promise
     */
    @ReactMethod
    public void isGuiding(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = SMap.getInstance().smMapWC.getMapControl();
            boolean isIndoorGuiding = mapControl.getNavigation3().isGuiding();
            boolean isOutdoorGuiding = false;
            if(sNavigation2 != null){
                isOutdoorGuiding = sNavigation2.getNavigation().isGuiding();
            }
            WritableMap map = Arguments.createMap();
            map.putBoolean("isOutdoorGuiding",isOutdoorGuiding);
            map.putBoolean("isIndoorGuiding",isIndoorGuiding);
            promise.resolve(map);
        } catch (Exception e) {
            WritableMap map = Arguments.createMap();
            map.putBoolean("isOutdoorGuiding",false);
            map.putBoolean("isIndoorGuiding",false);
            promise.resolve(map);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 行业导航路径分析
     *
     * @param promise
     */
    @ReactMethod
    public void beginNavigation(double x, double y, double x2, double y2, Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            sNavigation2.setStartPoint(x,y);
            sNavigation2.setDestinationPoint(x2,y2);
            sNavigation2.getNavigation().setPathVisible(true);

            boolean isFind = sNavigation2.getNavigation().routeAnalyst();
            if(!isFind){
                isFind = sNavigation2.reAnalyst();
                if(isFind){
                    sNavigation2.addGuideLineOnTrackingLayer(map.getPrjCoordSys());
                }
            }else{
                map.refresh();
            }
            promise.resolve(isFind);
        } catch (Exception e) {
            SMap sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            boolean isFind = sNavigation2.reAnalyst();
            if(isFind){
                sNavigation2.addGuideLineOnTrackingLayer(map.getPrjCoordSys());
            }
            promise.resolve(isFind);
        }
    }

    /**
     * 进行行业导航
     *
     * @param promise
     */
    @ReactMethod
    public void outdoorNavigation(final int naviType, Promise promise) {
        try {
            sMap = SMap.getInstance();
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if(sNavigation2 != null){
                        sNavigation2.getNavigation().enablePanOnGuide(true);
                        sNavigation2.getNavigation().startGuide(naviType);
                        sNavigation2.getNavigation().setCarUpFront(false);
                    }
                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 设置室内导航
     *
     * @param promise
     */
    @ReactMethod
    public void startIndoorNavigation(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Datasource naviDatasource = null;
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            for(int i = 0; i < datasources.getCount(); i++){
                Datasource datasource = datasources.get(i);
                Datasets datasets = datasource.getDatasets();
                if(datasets.contains("FloorRelationTable")){
                    naviDatasource = datasource;
                    break;
                }
            }
            if(naviDatasource != null){
                Navigation3 mNavigation3 = sMap.getSmMapWC().getMapControl().getNavigation3();
                GeoStyle style = new GeoStyle();
                style.setLineSymbolID(964882);
                mNavigation3.setRouteStyle(style);
                GeoStyle styleHint = new GeoStyle();
                styleHint.setLineWidth(2);
                styleHint.setLineColor(new com.supermap.data.Color(82, 198, 223));
                styleHint.setLineSymbolID(2);
                mNavigation3.setHintRouteStyle(styleHint);
                mNavigation3.setDeviateTolerance(10);
                mNavigation3.addNaviInfoListener(new NaviListener() {
                    @Override
                    public void onStopNavi() {
                        mSpeakPlugin.stopPlay();
                        // TODO Auto-generated method stub
                        mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit(EventConst.STOPNAVIAGTION, true);
                    }

                    @Override
                    public void onStartNavi() {
                        // TODO Auto-generated method stub
                    }

                    @Override
                    public void onPlayNaviMessage(String message) {
                        // TODO Auto-generated method stub
                        mSpeakPlugin.playSound(message);
                    }

                    @Override
                    public void onNaviInfoUpdate(NaviInfo naviInfo) {
                        // TODO Auto-generated method stub
                        Log.e("++++++++++++++++++", "" + naviInfo.CurRoadName);
                    }

                    @Override
                    public void onAdjustFailure() {
                        // TODO Auto-generated method stub

                    }

                    @Override
                    public void onAarrivedDestination() {
                        // TODO Auto-generated method stub
                        mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit(EventConst.INDUSTRYNAVIAGTION, true);
                    }
                });

                mNavigation3.setDatasource(naviDatasource);
                promise.resolve(true);
            }else {
                promise.resolve(false);
                Log.e("navigation error:","naviDatasource can't be null");
            }
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 室内导航路径分析
     *
     * @param promise
     */
    @ReactMethod
    public void beginIndoorNavigation(Promise promise) {
        try {
            sMap = SMap.getInstance();
            boolean result = sMap.getSmMapWC().getMapControl().getNavigation3().routeAnalyst();
            promise.resolve(result);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 进行室内导航
     *
     * @param promise
     */
    @ReactMethod
    public void indoorNavigation(final int naviType, Promise promise) {
        try {
            sMap = SMap.getInstance();
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    sMap.getSmMapWC().getMapControl().getNavigation3().startGuide(naviType);
                    sMap.getSmMapWC().getMapControl().getMap().setFullScreenDrawModel(true);        // 设置整屏绘制
                    sMap.getSmMapWC().getMapControl().getNavigation3().setCarUpFront(true);          // 设置车头向上

                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 判断当前工作空间是否存在线数据集（增量路网前置条件）
     *
     * @param promise
     */
    @ReactMethod
    public void hasLineDataset(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Datasources dataSources = sMap.smMapWC.getWorkspace().getDatasources();
            boolean hasLineDataset = false;
            for (int i = 0; i < dataSources.getCount(); i++) {
                Datasets datasets = dataSources.get(i).getDatasets();
                for (int j = 0; j < datasets.getCount(); j++) {
                    Dataset dataset = datasets.get(j);
                    if (dataset.getType() == DatasetType.LINE) {
                        hasLineDataset = true;
                        break;
                    }
                }

            }
            promise.resolve(hasLineDataset);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 设置当前楼层ID
     * @param floorID
     * @param promise
     */
    @ReactMethod
    public void setCurrentFloorID(String floorID, Promise promise){
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getFloorListView().setCurrentFloorId(floorID);
            promise.resolve(true);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 获取当前楼层ID
     *
     * @param promise
     */
    @ReactMethod
    public void getCurrentFloorID(Promise promise) {
        try {
            sMap = SMap.getInstance();
            String floorID = "";
            FloorListView floorListView = sMap.smMapWC.getFloorListView();
            if(floorListView != null && floorListView.getVisibility() == View.VISIBLE){
                floorID = floorListView.getCurrentFloorId();
            }
            promise.resolve(floorID);
        } catch (Exception e) {
            promise.resolve("");
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 切换到指定楼层
     *
     * @param floorID
     * @param promise
     */
    @ReactMethod
    public void setCurrentFloor(String floorID, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getFloorListView().setCurrentFloorId(floorID);
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     *  打开含有ModelFileLinkTable的数据源，用于室外导航
     * @param params
     * @param promise
     */
    @ReactMethod
    public void openNavDatasource(ReadableMap params, Promise promise){
        try {
            sMap = SMap.getInstance();
            String alias = params.getString("alias");
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            Datasource datasource = datasources.get(alias);
            if(datasource == null){
                datasource = sMap.smMapWC.openNavDatasource(params.toHashMap());
                if(datasource != null){
                    Dataset linkTable = datasource.getDatasets().get("ModelFileLinkTable");
                    if(linkTable == null){
                        datasources.close(datasource.getAlias());
                    }
                }
            }
            promise.resolve(true);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 获取当前工作空间含有网络数据集的数据源
     *
     * @param promise
     */
    @ReactMethod
    public void getNetworkDataset(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            WritableArray array = Arguments.createArray();
            for (int i = 0, count = datasources.getCount(); i < count; i++) {
                Datasource datasource = datasources.get(i);
                Datasets datasets = datasource.getDatasets();
                Dataset linkTable = datasets.get("ModelFileLinkTable");
                if(linkTable != null) {
                    DatasetVector datasetVector = (DatasetVector) linkTable;
                    Recordset recordset = datasetVector.getRecordset(false, CursorType.STATIC);
                    do {
                        Object networkDataset = recordset.getFieldValue("NetworkDataset");
                        Object networkModelFile = recordset.getFieldValue("NetworkModelFile");
                        if (networkDataset != null && networkModelFile != null) {
                            WritableMap writableMap = Arguments.createMap();
                            writableMap.putString("name", networkDataset.toString());
                            writableMap.putString("modelFileName", networkModelFile.toString());
                            writableMap.putString("datasourceName", datasource.getAlias());
                            array.pushMap(writableMap);
                        }
                    }while(recordset.moveNext());
                    recordset.close();
                    recordset.dispose();
                }
            }
            promise.resolve(array);
        } catch (Exception e) {
            WritableArray array = Arguments.createArray();
            promise.resolve(array);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 将当前楼层路网数据集所在线数据集添加到地图上
     *
     * @param promise
     */
    @ReactMethod
    public void addNetWorkDataset(Promise promise) {
        try {
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    sMap = SMap.getInstance();
                    Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
                    Dataset floorRelationTable = null;

                    String floorID = sMap.smMapWC.getFloorListView().getCurrentFloorId();
                    if(floorID != null){
                        //室内
                        for(int i = 0; i < datasources.getCount(); i++){
                            Datasource datasource = datasources.get(i);
                            Datasets datasets = datasource.getDatasets();
                            if(datasets.contains("FloorRelationTable")){
                                incrementDatasource = datasource;
                                floorRelationTable = datasets.get("FloorRelationTable");
                                break;
                            }
                        }
                        DatasetVector datasetVector = (DatasetVector)floorRelationTable;
                        Recordset recordset = datasetVector.getRecordset(false,CursorType.STATIC);
                        do{
                            Object FL_ID = recordset.getFieldValue("FL_ID");
                            if(FL_ID != null && FL_ID.toString().equals(floorID)){
                                incrementLineDatasetName = recordset.getFieldValue("LineDatasetName").toString();
                                incrementNetworkDatasetName = recordset.getFieldValue("NetworkName").toString();
                                break;
                            }
                        } while (recordset.moveNext());
                        recordset.close();
                        recordset.dispose();
                    }
                    if(incrementLineDatasetName != null && incrementDatasource != null){
                        Dataset dataset = incrementDatasource.getDatasets().get(incrementLineDatasetName);
                        Layer layer = sMap.getSmMapWC().getMapControl().getMap().getLayers().add(dataset, true);
                        layer.setEditable(true);
                        promise.resolve(true);
                    }else {
                        promise.resolve(false);
                    }
                }
            });
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 将路网数据集和线数据集从地图移除
     *
     * @param promise
     */
    @ReactMethod
    public void removeNetworkDataset(Promise promise) {
        try {
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    String datasourceName = incrementDatasource.getAlias();
                    sMap = SMap.getInstance();
                    Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
                    Layer layer = layers.getByCaption(incrementLineDatasetName + "@" + datasourceName);
                    layers.remove(layer);
                    if (incrementNetworkDatasetName != null) {
                        DatasetVector datasetVector = (DatasetVector) incrementDatasource.getDatasets().get(incrementNetworkDatasetName);
                        String name = datasetVector.getChildDataset().getName();
                        Layer networkLayer = layers.getByCaption(name + "@" + datasourceName);
                        if (networkLayer != null) {
                            layers.remove(networkLayer);
                        }
                    }
                    if (GpsPoint2Ds.getCount() > 0) {
                        GpsPoint2Ds.clear();
                    }
                    incrementLayerAdded = false;
                    promise.resolve(true);
                }
            });
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

//    /**
//     * 判断当前工作空间是否存在网络数据集（导航前置条件）
//     *
//     * @param promise
//     */
//    @ReactMethod
//    public void hasNetworkDataset(Promise promise) {
//        try {
//            sMap = SMap.getInstance();
//            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
//
//            boolean hasNetworkDataset = false;
//            for (int i = 0, count = datasources.getCount(); i < count; i++) {
//                Datasets datasets = datasources.get(i).getDatasets();
//                for (int j = 0, len = datasets.getCount(); j < len; j++) {
//                    Dataset dataset = datasets.get(j);
//                    if (dataset.getType() == DatasetType.NETWORK) {
//                        hasNetworkDataset = true;
//                        break;
//                    }
//                }
//            }
//            promise.resolve(hasNetworkDataset);
//        } catch (Exception e) {
//            promise.resolve(false);
//            Log.e("navigation error:",e.toString());
////            promise.reject(e);
//        }
//    }

    /**
     * 生成路网
     *
     * @param promise
     */
    @ReactMethod
    public void buildNetwork(Promise promise) {
        try {
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    sMap = SMap.getInstance();

                    if(incrementLayerAdded){
                        sMap.smMapWC.getMapControl().getMap().getLayers().remove(0);
                    }
                    DatasetVector lineDataset = (DatasetVector)incrementDatasource.getDatasets().get(incrementLineDatasetName);


                    String datasetName = incrementLineDatasetName+"_tmpDataset";

                    incrementDatasource.getDatasets().delete(datasetName);

                    DatasetVector datasetVector = (DatasetVector) incrementDatasource.copyDataset(
                            lineDataset, datasetName, EncodeType.NONE);
                    // 构造拓扑处理选项topologyProcessingOptions，各属性设置成false
                    TopologyProcessingOptions topologyProcessingOptions = new TopologyProcessingOptions();
                    topologyProcessingOptions.setLinesIntersected(true);
                    TopologyProcessing.clean(datasetVector, topologyProcessingOptions);

                    incrementDatasource.getDatasets().delete(incrementNetworkDatasetName);

                    String[] lineFieldNames = new String[datasetVector.getFieldInfos().getCount()];
                    for (int i = 0; i < datasetVector.getFieldInfos().getCount(); i++) {
                        lineFieldNames[i] = datasetVector.getFieldInfos().get(i).getCaption();
                    }

                    DatasetVector datasets[] = {datasetVector};
                    NetworkBuilder.buildNetwork(datasets, null, lineFieldNames, null,
                            incrementDatasource, incrementNetworkDatasetName, NetworkSplitMode.LINE_SPLIT_BY_POINT, 0.0000001);

                    Layers layers = sMap.getSmMapWC().getMapControl().getMap().getLayers();
                    DatasetVector datasetVector2 = (DatasetVector) incrementDatasource.getDatasets().get(incrementNetworkDatasetName);
                    layers.add(datasetVector2.getChildDataset(), true);
                    incrementLayerAdded = true;
                    promise.resolve(true);
                }
            });
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * GPS开始
     *
     * @param promise
     */
    @ReactMethod
    public void gpsBegin(Promise promise) {
        try {
            sMap = SMap.getInstance();
            LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
            Point2D gpsPoint = new Point2D(gpsDat.dLongitude, gpsDat.dLatitude);
            Log.e("+++++++++++++++++++", "" + gpsPoint);
            GpsPoint2Ds.add(gpsPoint);
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 添加GPS轨迹
     *
     * @param promise
     */
    @ReactMethod
    public void addGPSRecordset(Promise promise) {
        try {
            if (GpsPoint2Ds.getCount() > 0) {
                sMap = SMap.getInstance();
                DatasetVector dataset = (DatasetVector) incrementDatasource.getDatasets().get(incrementLineDatasetName);
                if (dataset != null) {
                    dataset.setReadOnly(false);
                }
                Recordset recordset = dataset.getRecordset(false, CursorType.DYNAMIC);
                GeoLine geoline = new GeoLine();
                geoline.addPart(GpsPoint2Ds);
                recordset.addNew(geoline);
                recordset.update();
                int id[] = new int[1];
                id[0] = recordset.getID();
                recordset.close();
                geoline.dispose();
                recordset.dispose();
                Recordset recordset1 = dataset.query(id, CursorType.DYNAMIC);
                sMap.smMapWC.getMapControl().getEditHistory().batchBegin();
                sMap.smMapWC.getMapControl().getEditHistory().addHistoryType(EditHistoryType.ADDNEW, recordset1, true);
                sMap.smMapWC.getMapControl().getEditHistory().batchEnd();
                recordset1.close();
                recordset1.dispose();
                sMap.smMapWC.getMapControl().getMap().refresh();
                //提交完清空
                if (GpsPoint2Ds.getCount() > 0) {
                    GpsPoint2Ds.clear();
                }
                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 获取点所在的所有导航数据源（室内）数据集（室外）相关信息
     * @param x
     * @param y
     * @param promise
     */
    @ReactMethod
    public void getPointBelongs(double x, double y, Promise promise){
        try{
            sMap = SMap.getInstance();
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            WritableArray array = Arguments.createArray();
            for (int i = 0; i < datasources.getCount(); i++) {
                Datasource datasource = datasources.get(i);
                Datasets datasets = datasource.getDatasets();
                boolean isIndoor = datasets.contains("FloorRelationTable");
                boolean isOutdoor = datasets.contains("ModelFileLinkTable");
                if(isIndoor || isOutdoor){
                    WritableMap map = Arguments.createMap();
                    boolean needPush = false;
                    for (int j = 0; j < datasets.getCount(); j++) {
                        Dataset dataset = datasets.get(j);
                        //经纬度点
                        Point2D point2D = new Point2D(x,y);
                        if(!SMap.safeGetType(dataset.getPrjCoordSys(),PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)){
                            point2D = getMapPoint(x,y);
                        }
                        if(dataset.getType() == DatasetType.NETWORK && dataset.getBounds().contains(point2D)){
                            if(isIndoor){
                                map.putString("datasourceName",datasource.getAlias());
                                map.putBoolean("isIndoor",true);
                                needPush = true;
                                break;
                            }else if(isOutdoor){
                                Dataset linkTable = datasets.get("ModelFileLinkTable");
                                if(linkTable != null){
                                    DatasetVector datasetVector = (DatasetVector)linkTable;
                                    Recordset recordset = datasetVector.getRecordset(false,CursorType.STATIC);
                                    while (!recordset.isEOF()){
                                        String networkDatasetName = (String) recordset.getFieldValue("NetworkDataset");
                                        String netModelFileName = (String) recordset.getFieldValue("NetworkModelFile");
                                        if(networkDatasetName.equals(dataset.getName())){
                                            map.putString("modelFileName",netModelFileName);
                                            map.putString("datasourceName",datasource.getAlias());
                                            map.putString("datasetName",networkDatasetName);
                                            map.putBoolean("isIndoor",false);
                                            needPush = true;
                                            break;
                                        }
                                        recordset.moveNext();
                                    }
                                    recordset.close();
                                    recordset.dispose();
                                }
                            }
                        }
                    }
                    if(needPush){
                        array.pushMap(map);
                    }
                }
            }
            promise.resolve(array);
        }catch (Exception e){
            promise.resolve(Arguments.createArray());
            Log.e("navigation error:",e.toString());
        }
    }


    /**
     * 获取到起始点距离最近的门的位置
     * @param params
     * @param promise
     */
    @ReactMethod
    public void getDoorPoint(ReadableMap params, Promise promise){
        try{
            sMap = SMap.getInstance();
            String datasourceName =  params.getString("datasourceName");
            double startX = params.getDouble("startX");
            double startY = params.getDouble("startY");
            double endX = params.getDouble("endX");
            double endY = params.getDouble("endY");
            double doorX = 0.0;
            double doorY = 0.0;
            String floorID = "";
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            Datasource datasource = datasources.get(datasourceName);
            WritableMap map = Arguments.createMap();
            if(datasource != null){
                Dataset connectionInfoTable = datasource.getDatasets().get("connectionInfoTable");
                if(connectionInfoTable != null){
                    DatasetVector datasetVector = (DatasetVector)connectionInfoTable;
                    Recordset recordset = datasetVector.getRecordset(false,CursorType.STATIC);
                    double dLen = 1000000.0;
                    while (!recordset.isEOF()){
                        double latitude = Double.parseDouble(recordset.getFieldValue("latitude").toString());
                        double longtitude = Double.parseDouble(recordset.getFieldValue("longtitude").toString());
                        String FL_ID = recordset.getFieldValue("FL_ID").toString();
                        double curLen1 = Math.sqrt( Math.pow((longtitude - startX),2) + Math.pow((latitude-startY),2) );
                        double curLen2 = Math.sqrt( Math.pow((longtitude - endX),2) + Math.pow((latitude-endY),2) );
                        if(curLen1 + curLen2 < dLen){
                            dLen = curLen1 + curLen2;
                            doorX = longtitude;
                            doorY = latitude;
                            floorID = FL_ID;
                        }
                        recordset.moveNext();
                    }
                    recordset.close();
                    recordset.dispose();
                    map.putDouble("x",doorX);
                    map.putDouble("y",doorY);
                    map.putString("floorID",floorID);
                    promise.resolve(map);
                }else{
                    promise.resolve(map);
                }
            }else{
                promise.resolve(map);
            }
        }catch (Exception e){
            WritableMap map = Arguments.createMap();
            promise.resolve(map);
            Log.e("navigation error:",e.toString());
        }
    }

    /**
     * 添加引导线吗
     * @param startPoint
     * @param endPoint
     * @param promise
     */
    @ReactMethod
    public void addLineOnTrackingLayer(ReadableMap startPoint, ReadableMap endPoint, Promise promise){
        try{
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    sMap = SMap.getInstance();
                    TrackingLayer trackingLayer = sMap.smMapWC.getMapControl().getMap().getTrackingLayer();

                    double startX = startPoint.getDouble("x");
                    double startY = startPoint.getDouble("y");
                    double endX = endPoint.getDouble("x");
                    double endY = endPoint.getDouble("y");

                    Point2D start = getMapPoint(startX,startY);
                    Point2D end = getMapPoint(endX,endY);

                    Point2Ds point2Ds = new Point2Ds();
                    point2Ds.add(start);
                    point2Ds.add(end);

                    GeoStyle guideLineStyle = new GeoStyle();
                    guideLineStyle.setLineWidth(2.0);
                    guideLineStyle.setLineColor(new Color(0,145,239));
                    guideLineStyle.setLineSymbolID(0);

                    GeoLine geoLine = new GeoLine(point2Ds);
                    geoLine.setStyle(guideLineStyle);

                    trackingLayer.add(geoLine,"");
                    sMap.smMapWC.getMapControl().getMap().refresh();
                    promise.resolve(true);
                }
            });
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
        }
    }
    /**
     * 判断是否是室内点
     *
     * @param promise
     */
    @ReactMethod
    public void isIndoorPoint(double x, double y, Promise promise) {
        try {
            sMap = SMap.getInstance();
            boolean isindoor = false;
            Datasource naviDatasource = null;
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            for(int i = 0; i < datasources.getCount(); i++){
                Datasource datasource = datasources.get(i);
                Datasets datasets = datasource.getDatasets();
                if(datasets.contains("FloorRelationTable")){
                    naviDatasource = datasource;
                    break;
                }
            }
            if (naviDatasource != null) {
                Datasets datasets = naviDatasource.getDatasets();
                Point2D mapCenter = sMap.smMapWC.getMapControl().getMap().getCenter();
                mapCenter = getPoint(mapCenter.getX(),mapCenter.getY());
                for(int i = 0; i < datasets.getCount(); i++){
                    Dataset dataset = datasets.get(i);
                    if(dataset.getBounds().contains(mapCenter) && dataset.getBounds().contains(x,y)){
                        isindoor = true;
                        break;
                    }
                }
            }
            promise.resolve(isindoor);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 添加起始点
     *
     * @param promise
     */
    @ReactMethod
    public void getStartPoint(double x, double y, boolean isindoor, String floorID, Promise promise) {
        try {
            sMap = SMap.getInstance();
            if (floorID == null || floorID.equals("")) {
                floorID = sMap.getSmMapWC().getFloorListView().getCurrentFloorId();
            }
            if (isindoor) {
                sMap.getSmMapWC().getMapControl().getNavigation3().setStartPoint(x, y, floorID);
            } else {
                Point2D point2d = getMapPoint(x,y);
                showPointByCallout(point2d.getX(), point2d.getY(), "startpoint");
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 添加终点
     *
     * @param promise
     */
    @ReactMethod
    public void getEndPoint(double x, double y, boolean isindoor, String floorID, Promise promise) {
        try {
            sMap = SMap.getInstance();
            if (floorID == null || floorID.equals("")) {
                floorID = sMap.getSmMapWC().getFloorListView().getCurrentFloorId();
            }
            if (isindoor) {
                sMap.getSmMapWC().getMapControl().getNavigation3().setDestinationPoint(x, y, floorID);
                sMap.getSmMapWC().getMapControl().getNavigation3().setCurrentFloorId(floorID);
            } else {
                Point2D point2d = getMapPoint(x,y);
                showPointByCallout(point2d.getX(), point2d.getY(), "endpoint");
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 清除导航路径 保留起始点
     * @param promise
     */
    @ReactMethod
    public void clearPath(Promise promise){
        try{
            sMap = SMap.getInstance();
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if(sNavigation2 != null){
                        sNavigation2.getNavigation().cleanPath();
                    }
                    sMap.smMapWC.getMapControl().getMap().getTrackingLayer().clear();
                    sMap.smMapWC.getMapControl().getNavigation3().cleanPath();
                    sMap.smMapWC.getMapControl().getMap().refresh();
                }
            });
            promise.resolve(true);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
        }
    }

    /**
     * 清除起终点
     *
     * @param promise
     */
    @ReactMethod
    public void clearPoint(Promise promise) {
        try {
            sMap = SMap.getInstance();
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if(sNavigation2 != null){
                        sNavigation2.getNavigation().cleanPath();
                    }
                    sMap.smMapWC.getMapControl().getMap().getTrackingLayer().clear();
                    sMap.getSmMapWC().getMapControl().getNavigation3().cleanPath();
                    clearOutdoorPoint();
                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 停止导航
     *
     * @param promise
     */
    @ReactMethod
    public void stopGuide(Promise promise) {
        try {
            sMap = SMap.getInstance();
            mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if(sNavigation2 != null){
                        sNavigation2.getNavigation().stopGuide();
                    }
                    sMap.getSmMapWC().getMapControl().getNavigation3().stopGuide();
                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 获取当前地理坐标
     * @param promise
     */
    @ReactMethod
    public void getCurrentMapPosition(Promise promise){
        try {
            sMap = SMap.getInstance();
            LocationManagePlugin.GPSData gpsData = SMCollector.getGPSPoint();
            Point2Ds point2Ds = new Point2Ds();
            Point2D point2D = new Point2D(gpsData.dLongitude, gpsData.dLatitude);
            point2Ds.add(point2D);

            PrjCoordSys mapCoordaSys = sMap.smMapWC.getMapControl().getMap().getPrjCoordSys();
            PrjCoordSys prjCoordSys = new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            CoordSysTranslator.convert(point2Ds, prjCoordSys, mapCoordaSys, new CoordSysTransParameter(), CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

            Point2D point = point2Ds.getItem(0);
            WritableMap map = Arguments.createMap();
            map.putDouble("x",point.getX());
            map.putDouble("y",point.getY());
            promise.resolve(map);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }

    }
    /**
     * 将地图上的点转换为经纬坐标点
     *
     * @param
     * @return
     */
    private Point2D getPoint(double x, double y) {
        Point2D point2D;
        if (SMap.getInstance().getSmMapWC().getMapControl().getMap().getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
            PrjCoordSys srcPrjCoordSys = SMap.getInstance().getSmMapWC().getMapControl().getMap().getPrjCoordSys();
            Point2Ds point2Ds = new Point2Ds();
            point2Ds.add(new Point2D(x, y));
            PrjCoordSys desPrjCoordSys = new PrjCoordSys();
            desPrjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            // 转换投影坐标
            CoordSysTranslator.convert(point2Ds, srcPrjCoordSys,
                    desPrjCoordSys, new CoordSysTransParameter(),
                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
            point2D = point2Ds.getItem(0);
        } else {
            point2D = new Point2D(x, y);
        }
        return point2D;
    }

    /**
     * 经纬坐标点转地理坐标点
     * @param x
     * @param y
     * @return
     */
    private Point2D getMapPoint(double x, double y){
        Point2D point2D;
        if (x >= -180 && x <= 180 && y >= -90 && y <= 90) {
            PrjCoordSys srcPrjCoordSys = SMap.getInstance().getSmMapWC().getMapControl().getMap().getPrjCoordSys();
            Point2Ds point2Ds = new Point2Ds();
            point2Ds.add(new Point2D(x, y));
            PrjCoordSys desPrjCoordSys = new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            // 转换投影坐标
            CoordSysTranslator.convert(
                    point2Ds,
                    desPrjCoordSys,
                    srcPrjCoordSys,
                    new CoordSysTransParameter(),
                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
            point2D = point2Ds.getItem(0);
        } else {
            point2D = new Point2D(x, y);
        }
        return point2D;
    }

    private void showPointByCallout(final double x, final double y, final String pointName) {
        final MapView mapView = SMap.getInstance().getSmMapWC().getMapControl().getMap().getMapView();

        mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {

                mapView.removeCallOut(pointName);

                m_callout = new InfoCallout(mReactContext);
                m_callout.setStyle(CalloutAlignment.BOTTOM);
                m_callout.setBackground(0, 0);

                DisplayMetrics dm = new DisplayMetrics();
                getCurrentActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
                double density = dm.density;

                int markerSize = 50;
                RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams((int) (markerSize * density), (int) (markerSize * density));
                m_callout.setCustomize(true);
                m_callout.setLayoutParams(params);

                ImageView imageView = new ImageView(mReactContext);

                imageView.setAdjustViewBounds(true);

                if (pointName.equals("startpoint")) {
                    imageView.setImageResource(R.drawable.icon_scene_tool_start);
                } else {
                    imageView.setImageResource(R.drawable.icon_scene_tool_end);
                }

                params = new RelativeLayout.LayoutParams((int) (markerSize * density), (int) (markerSize * density));
                params.setMargins(0, 10, 0, 0);
                imageView.setLayoutParams(params);

                m_callout.addView(imageView);
                m_callout.setLocation(x, y);
                mapView.addCallout(m_callout, pointName);
                mapView.showCallOut();
            }
        });

    }


    /**
     * 打开实时路况信息
     *
     * @param promise
     */
    @ReactMethod
    public void openTrafficMap(ReadableMap data, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Map params = data.toHashMap();
            Datasource datasource = sMap.smMapWC.openDatasource(params);
            Layers layers = sMap.getSmMapWC().getMapControl().getMap().getLayers();
            Point2D center = sMap.getSmMapWC().getMapControl().getMap().getCenter();
            double scale = sMap.getSmMapWC().getMapControl().getMap().getScale();
            boolean isadd = false;
            for (int i = 0; i < layers.getCount(); i++) {
                if (layers.get(i).getName().equals("tencent@TrafficMap")) {
                    isadd = true;
                }
            }
            if (!isadd) {
                sMap.getSmMapWC().getMapControl().getMap().getLayers().add(datasource.getDatasets().get(0), true);
                sMap.getSmMapWC().getMapControl().getMap().setScale(scale);
                sMap.getSmMapWC().getMapControl().getMap().setCenter(center);
                sMap.getSmMapWC().getMapControl().getMap().refresh();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 判断是否打开实时路况
     *
     * @param promise
     */
    @ReactMethod
    public void isOpenTrafficMap(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Layers layers = sMap.getSmMapWC().getMapControl().getMap().getLayers();
            boolean isadd = false;
            for (int i = 0; i < layers.getCount(); i++) {
                if (layers.get(i).getName().equals("tencent@TrafficMap")) {
                    isadd = true;
                }
            }
            promise.resolve(isadd);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 移除实时路况
     *
     * @param promise
     */
    @ReactMethod
    public void removeTrafficMap(String layerName, Promise promise) {
        try {
            SMap sMap = SMap.getInstance();
            Point2D center = sMap.getSmMapWC().getMapControl().getMap().getCenter();
            double scale = sMap.getSmMapWC().getMapControl().getMap().getScale();

            boolean result = false;

            HashMap<String, Object> res = SMLayer.findLayerAndGroupByPath(layerName);
            LayerGroup layerGroup = (LayerGroup) res.get("layerGroup");
            Layer layer = (Layer) res.get("layer");
            if (layerGroup != null) {
                if (layer != null) {
                    layerGroup.remove(layer);
                }
            } else {
                if (layer != null) {
                    result = sMap.getSmMapWC().getMapControl().getMap().getLayers().remove(layerName);
                }
            }

            sMap.getSmMapWC().getMapControl().getMap().setScale(scale);
            sMap.getSmMapWC().getMapControl().getMap().setCenter(center);
            sMap.getSmMapWC().getMapControl().getMap().refresh();

            promise.resolve(result);
        } catch (Exception e) {
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }


    /**
     * 拷贝室外地图网络模型snm文件
     *
     * @param promise
     */
    @ReactMethod
    public void copyNaviSnmFile(ReadableArray files, Promise promise) {
        try{
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        sMap = SMap.getInstance();
                        for(int i = 0; i < files.size(); i++){
                            ReadableMap map = files.getMap(i);
                            sMap.getSmMapWC().copyNaviSnmFile(map);
                        }
                        promise.resolve(true);
                    } catch (Exception e) {
                        promise.reject(e);
                    }
                }}).start();
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
        }
    }

//    /**
//     * 判断当前地图是否是室内地图
//     *
//     * @param promise
//     */
//    @ReactMethod
//    public void isIndoorMap(Promise promise) {
//        try {
//            sMap = SMap.getInstance();
//            boolean isIndoor = false;
//            FloorListView floorListView = sMap.smMapWC.getFloorListView();
//            if (floorListView != null) {
//                if (floorListView.getCurrentFloorId() != null && floorListView.getVisibility() == View.VISIBLE) {
//                    isIndoor = true;
//                }
//            }
//            promise.resolve(isIndoor);
//        } catch (Exception e) {
//            promise.resolve(false);
//            Log.e("navigation error:",e.toString());
////            promise.reject(e);
//        }
//    }


    /**
     * 判断点是否在数据集bounds内
     * @param point
     * @param datasetName
     * @param promise
     */
    @ReactMethod
    public void isInBounds(ReadableMap point, String datasetName, Promise promise){
        try {
            sMap = SMap.getInstance();
            boolean inBounds = false;
            double x = point.getDouble("x");
            double y = point.getDouble("y");
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            for(int i = 0; i < datasources.getCount(); i++){
                Datasource datasource = datasources.get(i);
                Datasets datasets = datasource.getDatasets();
                Dataset dataset = datasets.get(datasetName);
                if(dataset != null){
                    Point2D point2D = new Point2D(x,y);
                    if(!SMap.safeGetType(dataset.getPrjCoordSys(),PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)){
                        point2D = getMapPoint(x,y);
                    }
                    if(dataset.getBounds().contains(point2D)){
                        inBounds = true;
                    }
                }
            }
            promise.resolve(inBounds);
        }catch (Exception e){
            promise.resolve(false);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

    /**
     * 获取楼层相关数据，并初始化楼层控件 额外返回一个数据源名称，用于判断是否需要重新获取楼层信息
     * @param promise
     */
    @ReactMethod
    public void getFloorData(Promise promise){
        try {
            sMap = SMap.getInstance();
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            Datasource curDatasource = null;
            Dataset floorRelationTable = null;
            for(int i = 0; i < datasources.getCount(); i++){
                Datasource datasource = datasources.get(i);
                Datasets datasets = datasource.getDatasets();
                if(datasets.contains("FloorRelationTable")){
                    curDatasource = datasource;
                    floorRelationTable = datasets.get("FloorRelationTable");
                    break;
                }
            }

            WritableMap map = Arguments.createMap();
            WritableArray array = Arguments.createArray();

            if(floorRelationTable != null){
                FloorListView floorListView = new FloorListView(mReactContext.getCurrentActivity());
                floorListView.setLayoutParams(new LinearLayout.LayoutParams(1,1));
                floorListView.linkMapControl(sMap.smMapWC.getMapControl());
                sMap.smMapWC.setFloorListView(floorListView);

                DatasetVector datasetVector = (DatasetVector)floorRelationTable;
                Recordset recordset = datasetVector.getRecordset(false,CursorType.STATIC);

                do{
                    Object FL_ID = recordset.getFieldValue("FL_ID");
                    Object FL_NAME = recordset.getFieldValue("FloorName");
                    if(FL_ID != null && FL_NAME != null){
                        String floorID = FL_ID.toString();
                        String floorName = FL_NAME.toString();
                        WritableMap writableMap = Arguments.createMap();
                        writableMap.putString("name",floorName);
                        writableMap.putString("id",floorID);
                        array.pushMap(writableMap);
                    }
                }while(recordset.moveNext());

                recordset.close();
                recordset.dispose();
                String currentFloorID = floorListView.getCurrentFloorId() == null ? "" : floorListView.getCurrentFloorId();
                map.putString("datasource",curDatasource.getAlias());
                map.putString("currentFloorID",currentFloorID);
                map.putArray("data",array);
            }else {
                map.putString("datasource","");
            }

            promise.resolve(map);
        }catch (Exception e){
            WritableMap map = Arguments.createMap();
            map.putString("datasource","");
            promise.resolve(map);
            Log.e("navigation error:",e.toString());
//            promise.reject(e);
        }
    }

//    /**
//     * 判断搜索结果的两个点是否在某个路网数据集的bounds内，返回结果用于行业导航。无结果则进行在线路径分析
//     * @param navStartPoint
//     * @param navEndPoint
//     * @param promise
//     */
//    @ReactMethod
//    public void isPointsInMapBounds(ReadableMap navStartPoint, ReadableMap navEndPoint, Promise promise){
//        try {
//
//            WritableMap map = Arguments.createMap();
//
//            double x1 = navStartPoint.getDouble("x");
//            double y1 = navStartPoint.getDouble("y");
//            double x2 = navEndPoint.getDouble("x");
//            double y2 = navEndPoint.getDouble("y");
//
//            Datasource networkDatasource = null;
//            Dataset networkDataset = null;
//
//            sMap = SMap.getInstance();
//            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
//            for(int i = 0; i < datasources.getCount(); i++){
//                Datasource datasource = datasources.get(i);
//                Datasets datasets = datasource.getDatasets();
//                for(int j = 0; j < datasets.getCount(); j++){
//                    Dataset dataset = datasets.get(j);
//                    Rectangle2D bounds = dataset.getBounds();
//                    if(dataset.getType() == DatasetType.NETWORK && bounds.contains(x1,y1) && bounds.contains(x2,y2)){
//                        networkDataset = dataset;
//                        networkDatasource = datasource;
//                        break;
//                    }
//                }
//            }
//            if(networkDataset != null){
//                Datasets datasets = networkDatasource.getDatasets();
//                Dataset linkTable = datasets.get("ModelFileLinkTable");
//                if(linkTable != null){
//                    DatasetVector datasetVector = (DatasetVector)linkTable;
//                    Recordset recordset = datasetVector.getRecordset(false,CursorType.STATIC);
//                    do{
//                        Object networkDatasetObj = recordset.getFieldValue("NetworkDataset");
//                        Object netModelObj = recordset.getFieldValue("NetworkModelFile");
//                        if(netModelObj != null && networkDatasetObj != null){
//                            String networkDatasetName = networkDatasetObj.toString();
//                            String netModelFileName = netModelObj.toString();
//                            map.putString("name",networkDatasetName);
//                            map.putString("modelFileName",netModelFileName);
//                            map.putString("datasourceName",networkDatasource.getAlias());
//                        }
//                    }while(recordset.moveNext());
//                    recordset.close();
//                    recordset.dispose();
//                }
//            }
//            promise.resolve(map);
//        }catch (Exception e){
//            WritableMap map = Arguments.createMap();
//            promise.resolve(map);
//            Log.e("navigation error:",e.toString());
////            promise.reject(e);
//        }
//    }

}
