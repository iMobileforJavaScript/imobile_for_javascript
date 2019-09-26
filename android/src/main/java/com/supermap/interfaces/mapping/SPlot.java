package com.supermap.interfaces.mapping;

import android.os.Handler;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.DatasourceConnectionInfo;
import com.supermap.data.EncodeType;
import com.supermap.data.EngineType;
import com.supermap.data.FieldType;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Point3D;
import com.supermap.data.Point3Ds;
import com.supermap.data.Recordset;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Size2D;
import com.supermap.data.Workspace;
import com.supermap.interfaces.utils.SMFileUtil;
import com.supermap.mapping.Action;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Layers;
import com.supermap.mapping.MapControl;
import com.supermap.plot.AnimationAttribute;
import com.supermap.plot.AnimationBlink;
import com.supermap.plot.AnimationDefine;
import com.supermap.plot.AnimationGO;
import com.supermap.plot.AnimationGroup;
import com.supermap.plot.AnimationGrow;
import com.supermap.plot.AnimationManager;
import com.supermap.plot.AnimationRotate;
import com.supermap.plot.AnimationScale;
import com.supermap.plot.AnimationShow;
import com.supermap.plot.AnimationWay;
import com.supermap.plot.GeoGraphicObject;
import com.supermap.plot.GraphicObjectType;
import com.supermap.smNative.SMMapWC;

import java.io.File;
import java.util.Iterator;
import java.util.Timer;
import java.util.TimerTask;

import static com.supermap.RNUtils.FileUtil.homeDirectory;
import static com.supermap.interfaces.utils.SMFileUtil.copyFiles;
import static com.supermap.plot.AnimationDefine.AnimationType.WayAnimation;


public class SPlot extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SPlot";
    ReactContext mReactContext;

    private static SMap sMap;

    String rootPath = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();
    private static WritableMap plotLibMap;

    public SPlot(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext=reactContext;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    /**
     * 初始化标绘符号库
     *
     * @param plotSymbolPaths 标号路径列表
     * @param isFirst         是否是第一次初始化，第一次初始化需要新建一个点标号再删掉
     * @param newName         创建默认地图的地图名
     * @param isDefaultNew    是否是创建默认地图，创建默认地图不能从mapControl获取地图名，地图名由参数newName传入
     * @param promise
     */
    @ReactMethod
    public void initPlotSymbolLibrary(ReadableArray plotSymbolPaths, boolean isFirst, String newName, boolean isDefaultNew, Promise promise) {
        try {
            sMap = SMap.getInstance();
            final MapControl mapControl = sMap.smMapWC.getMapControl();

            Dataset dataset = null;
            Layer cadLayer = null;
            String userpath = null, name = "PlotEdit_" + (isDefaultNew ? newName : mapControl.getMap().getName());
            if (plotSymbolPaths.size() > 0) {
                String[] strArr = plotSymbolPaths.getString(0).split("/");
                for (int index = 0; index < strArr.length; index++) {
                    if (strArr[index].equals("User") && (index + 1) < strArr.length) {
                        userpath = strArr[index + 1];
                        break;
                    }
                }
            }

//            String plotDatasourceName="Plotting_" + userpath + "#";
            String plotDatasourceName = "Plotting_" + name + "#";
            plotDatasourceName.replace(".", "");
            Workspace workspace = mapControl.getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get(plotDatasourceName);
            Datasource datasource = null;
            if (opendatasource == null) {
                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias(plotDatasourceName);
                info.setEngineType(EngineType.UDB);
                String server = rootPath + "/iTablet/User/" + userpath + "/Data/Datasource/" + plotDatasourceName + ".udb";
                info.setServer(server);

                datasource = workspace.getDatasources().open(info);
                if (datasource == null) {
                    String serverUDD = rootPath + "/iTablet/User/" + userpath + "/Data/Datasource/" + plotDatasourceName + ".udd";
                    info.setServer(server);
                    File file = new File(server);
                    if (file.exists()) {
                        file.delete();
                    }
                    File fileUdd = new File(serverUDD);
                    if (fileUdd.exists()) {
                        fileUdd.delete();
                    }
                    datasource = workspace.getDatasources().create(info);
                }
                if (datasource == null) {
                    datasource = workspace.getDatasources().open(info);
                }
                info.dispose();
            } else {
                datasource = opendatasource;
            }

            if (datasource == null) {
                promise.resolve(null);
                return;
            }
            Datasets datasets = datasource.getDatasets();

            for (int i = 0; i < mapControl.getMap().getLayers().getCount(); i++) {
                Layer tempLayer = mapControl.getMap().getLayers().get(i);
                if (tempLayer.getName().startsWith("PlotEdit_") && tempLayer.getDataset() != null) {
                    if (tempLayer.getDataset().getType() == DatasetType.CAD) {
                        dataset = tempLayer.getDataset();
                        cadLayer = tempLayer;
                    }
                } else {
                    tempLayer.setEditable(false);
                }
            }
            DatasetVector datasetVector;
            String datasetName;
            if (dataset == null) {
                datasetName = datasets.getAvailableDatasetName(name);
                DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
                datasetVectorInfo.setType(DatasetType.CAD);
                datasetVectorInfo.setEncodeType(EncodeType.NONE);
                datasetVectorInfo.setName(datasetName);
                datasetVector = datasets.create(datasetVectorInfo);


                dataset = datasets.get(datasetName);
                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                Layer layer = map.getLayers().add(dataset, true);
                layer.setEditable(true);
                datasetVectorInfo.dispose();
                datasetVector.close();
            } else {
                cadLayer.setEditable(true);
//                Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
////                Layer editLayer = layers.get(name + "@" + datasource.getAlias());
//                Layer editLayer = layers.get(dataset.getName());
//                if (editLayer != null) {
//                    editLayer.setEditable(true);
//                } else {
//
//                    Dataset ds = dataset;
//                    com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
//                    Layer layer = map.getLayers().add(ds, true);
//                    layer.setEditable(true);
//                }
            }


            plotLibMap=Arguments.createMap();
            WritableMap writeMap = Arguments.createMap();
            for (int i = 0; i < plotSymbolPaths.size(); i++) {
                int libId = (int) mapControl.addPlotLibrary(plotSymbolPaths.getString(i));
                String libName = mapControl.getPlotSymbolLibName((long) libId);
                writeMap.putInt(libName, libId);
                plotLibMap.putInt(libName, libId);

//                if (isFirst && libName.equals("警用标号")) {
//                    Point2Ds point2Ds = new Point2Ds();
//                    Point2D point2D=new Point2D(mapControl.getMap().getViewBounds().getLeft()-100,mapControl.getMap().getViewBounds().getTop()-100);
//                    point2Ds.add(point2D);
//                    mapControl.addPlotObject(libId, 20100, point2Ds);
//                    mapControl.cancel();
//                    final Dataset finalDataset = dataset;
//                    new Thread() {
//                        @Override
//                        public void run() {
//                            super.run();
//                            try {
//                                Thread.sleep(100);
//                                Recordset recordset = ((DatasetVector) finalDataset).getRecordset(false, CursorType.DYNAMIC);
//                                recordset.moveLast();
//                                recordset.delete();
//                                recordset.update();
//                                recordset.dispose();
//                                mapControl.getMap().refresh();
//                                mapControl.setAction(Action.PAN);
//                            } catch (InterruptedException e) {
//                                e.printStackTrace();
//                            }
//                        }
//                    }.start();
//                }
            }

            mapControl.getMap().refresh();

            promise.resolve(writeMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移除标绘库
     *
     * @param plotSymbolIds
     * @param promise
     */
    @ReactMethod
    public void removePlotSymbolLibraryArr(ReadableArray plotSymbolIds, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            for (int i = 0; i < plotSymbolIds.size(); i++) {
                mapControl.removePlotLibrary(plotSymbolIds.getInt(i));
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标绘符号
     *
     * @param promise
     */
    @ReactMethod
    public void setPlotSymbol(int libID, int symbolCode, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            for (int i = 0; i < mapControl.getMap().getLayers().getCount(); i++) {
                Layer tempLayer = mapControl.getMap().getLayers().get(i);
                if (tempLayer.getName().startsWith("PlotEdit_") && tempLayer.getDataset() != null) {
                    if (tempLayer.getDataset().getType() == DatasetType.CAD) {
                        tempLayer.setEditable(true);

//                         if (plotLibMap.hasKey("警用标号")) {
//                             try {
//                                 Point2Ds point2Ds = new Point2Ds();
//                                 Point2D point2D = new Point2D(mapControl.getMap().getViewBounds().getLeft() - 100, mapControl.getMap().getViewBounds().getTop() - 100);
//                                 point2Ds.add(point2D);
//                                 mapControl.addPlotObject(421, 20100, point2Ds);
// //                                mapControl.cancel();
//                                 Dataset finalDataset = tempLayer.getDataset();
//                                 Recordset recordset = ((DatasetVector) finalDataset).getRecordset(false, CursorType.DYNAMIC);
//                                 recordset.moveLast();
//                                 recordset.delete();
//                                 recordset.update();
//                                 recordset.dispose();
//                                 mapControl.getMap().refresh();
//                                 mapControl.setAction(Action.PAN);
//                             } catch (Exception e) {
//                                 e.printStackTrace();
//                             }

//                         }
                    }
                } else {
                    tempLayer.setEditable(false);
                }
            }

            mapControl.setPlotSymbol(libID, symbolCode);
            mapControl.setAction(Action.CREATEPLOT);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加cad图层
     *
     * @param layerName
     * @param promise
     */
    @ReactMethod
    public void addCadLayer(String layerName, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            Layer cadLayer = mapControl.getMap().getLayers().get(layerName);
            if (cadLayer == null) {
                DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
                datasetVectorInfo.setType(DatasetType.CAD);
                datasetVectorInfo.setName(layerName);
                DatasetVector datasetVector = (DatasetVector) sMap.smMapWC.getWorkspace().getDatasources().get(0).getDatasets().get(layerName);
                if (datasetVector == null) {
                    datasetVector = sMap.smMapWC.getWorkspace().getDatasources().get(0).getDatasets().create(datasetVectorInfo);
                }
                cadLayer = mapControl.getMap().getLayers().add(datasetVector, true);
            }
            cadLayer.setEditable(true);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 导入标绘模板库
     *
     * @param fromPath
     */
    @ReactMethod
    public static void importPlotLibData(String fromPath, Promise promise) {
        try {
            promise.resolve(importPlotLibDataMethod(fromPath));
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 导入标绘模板库
     *
     * @param fromPath
     */
    public static boolean importPlotLibDataMethod(String fromPath) {
        String toPath = homeDirectory + "/iTablet/User/" + SMap.getInstance().smMapWC.getUserName() + "/Data" + "/Plotting/";
        boolean result = copyFiles(fromPath, toPath, "plot", "Symbol", "SymbolIcon", false);
        return result;
    }

    /**
     * 根据标绘库id获取标绘库名称
     *
     * @param libId
     */
    @ReactMethod
    public static void getPlotSymbolLibNameById(int libId, Promise promise) {
        try {

            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            String libName = mapControl.getPlotSymbolLibName((long) libId);
            promise.resolve(libName);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    private static Timer m_timer;
//    private static AnimationManager am;

    /**
     * 初始化态势推演
     */
    @ReactMethod
    public static void initAnimation(Promise promise) {
        try {

            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
//            am = AnimationManager.getInstance();
            //开启定时器
            if (m_timer == null) {
                m_timer = new Timer();
            }
            m_timer.schedule(new TimerTask() {
                @Override
                public void run() {
                    AnimationManager.getInstance().excute();
                }
            }, 0, 100);
            mapControl.setAnimations();
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }

    }

    /**
     * 读取态势推演xml文件
     */
    @ReactMethod
    public static void readAnimationXmlFile(String filePath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            if (m_timer == null) {
                m_timer = new Timer();
            }
            //开启定时器
            m_timer.schedule(new TimerTask() {
                @Override
                public void run() {
                    AnimationManager.getInstance().excute();
                }
            }, 0, 100);
            Layers layers = mapControl.getMap().getLayers();
            int count = layers.getCount();
            for (int i = 0; i < count; i++) {
                if (layers.get(i).getDataset().getType() == DatasetType.CAD) {
                    layers.get(i).setEditable(true);
                }
            }

            mapControl.setAnimations();
            AnimationManager.getInstance().deleteAll();
            AnimationManager.getInstance().getAnimationFromXML(filePath);
            if(AnimationManager.getInstance().getGroupCount()>0){
                String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
                AnimationManager.getInstance().getGroupByIndex(0).setGroupName(animationGroupName);
            }


            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 播放态势推演动画
     */
    @ReactMethod
    public static void animationPlay(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            if(AnimationManager.getInstance().getGroupCount()>0){
                Rectangle2D rectangle2D=new Rectangle2D();
                AnimationGroup animationGroup=AnimationManager.getInstance().getGroupByIndex(0);
                int animationCount=animationGroup.getAnimationCount();
                if(animationCount>0){
                    for (int i=0;i<animationCount;i++){
                        AnimationGO animationGO=animationGroup.getAnimationByIndex(i);
                        String layerName=animationGO.getLayerName();
                        DatasetVector datasetVector= (DatasetVector) mapControl.getMap().getLayers().get(layerName).getDataset();

                        Recordset recordset = datasetVector.query("SmID=" + animationGO.getGeometry(), CursorType.STATIC);
                        Geometry geometry = recordset.getGeometry();
                        if (geometry != null) {

                            if(i==0){
                                rectangle2D=geometry.getBounds();
                            }else {
                                Rectangle2D boouds=geometry.getBounds();
                                if(boouds.getLeft()<rectangle2D.getLeft()){
                                    rectangle2D.setLeft(boouds.getLeft());
                                }
                                if(boouds.getRight()>rectangle2D.getRight()){
                                    rectangle2D.setRight(boouds.getRight());
                                }
                                if(boouds.getBottom()<rectangle2D.getBottom()){
                                    rectangle2D.setBottom(boouds.getBottom());
                                }
                                if(boouds.getTop()>rectangle2D.getTop()){
                                    rectangle2D.setTop(boouds.getTop());
                                }
                            }
                            geometry.dispose();
                        }
                        recordset.dispose();
                    }
                    double offsetX=(rectangle2D.getRight()-rectangle2D.getLeft())/6;
                    double offsetY=(rectangle2D.getTop()-rectangle2D.getBottom())/6;
                    rectangle2D.setLeft(rectangle2D.getLeft()-offsetX);
                    rectangle2D.setRight(rectangle2D.getRight()+offsetX);
                    rectangle2D.setBottom(rectangle2D.getBottom()-offsetY*1.5);
                    rectangle2D.setTop(rectangle2D.getTop()+offsetY*0.5);

                    if((rectangle2D.getRight()-rectangle2D.getLeft())>0&&(rectangle2D.getTop()-rectangle2D.getBottom())>0){
                        mapControl.getMap().setViewBounds(rectangle2D);
                    }
                }
            }

//            double scale = mapControl.getMap().getScale();
//            mapControl.zoomTo(mapControl.getMap().getScale()+0.1,100);
////            mapControl.getMap().setScale( mapControl.getMap().getScale()+0.1);
//            mapControl.getMap().refresh();
//            mapControl.zoomTo(scale,100);
////            mapControl.getMap().setScale( scale);
            mapControl.getMap().refresh();

            Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    AnimationManager.getInstance().play();
                }
            }, 200);//3秒后执行Runnable中的run方法
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 暂停态势推演动画
     */
    @ReactMethod
    public static void animationPause(Promise promise) {
        try {
            AnimationManager.getInstance().pause();

            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 复位态势推演动画
     */
    @ReactMethod
    public static void animationReset(Promise promise) {
        try {
            AnimationManager.getInstance().reset();

            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 停止态势推演动画
     */
    @ReactMethod
    public static void animationStop(Promise promise) {
        try {
            AnimationManager.getInstance().stop();

            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 关闭态势推演
     */
    @ReactMethod
    public static void animationClose(Promise promise) {
        try {
            m_timer.cancel();
            m_timer = null;
            AnimationManager.getInstance().stop();
            AnimationManager.getInstance().reset();
            AnimationManager.getInstance().deleteAll();
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    private Point2Ds point2Ds;
    private Point2Ds savePoint2Ds;

    /**
     * 创建推演动画对象
     */
    @ReactMethod
    public void createAnimationGo(ReadableMap createInfo, String newPlotMapName, Promise promise) {
        //顺序：路径、闪烁、属性、显隐、旋转、比例、生长
        try {
            if (!createInfo.hasKey("animationMode")) {
                promise.resolve(false);
                return;
            }
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                animationGroup = AnimationManager.getInstance().addAnimationGroup(animationGroupName);
            }

            int animationMode = createInfo.getInt("animationMode");
            AnimationGO animationGO = AnimationManager.getInstance().createAnimation(new AnimationDefine.AnimationType(animationMode, animationMode));
            switch (animationMode) {
                case 0:
                    AnimationWay animationWay = (AnimationWay) animationGO;
                    Point3Ds point3Ds = new Point3Ds();
                    if (createInfo.hasKey("wayPoints")) {
                        ReadableArray array = createInfo.getArray("wayPoints");
                        for (int i = 0; i < array.size(); i++) {
                            ReadableMap map = array.getMap(i);
                            double x = map.getDouble("x");
                            double y = map.getDouble("y");
                            point3Ds.add(new Point3D(x, y, 0));
                        }
                    }
                    animationWay.addPathPts(point3Ds);
                    animationWay.setTrackLineWidth(0.5);
                    animationWay.setPathType(AnimationDefine.PathType.POLYLINE);
                    animationWay.setTrackLineColor(new com.supermap.data.Color(255, 0, 0, 255));
                    animationWay.setPathTrackDir(true);
                    animationWay.showPathTrack(true);
                    animationGO = animationWay;
                    break;
                case 1:
                    AnimationBlink animationBlink = (AnimationBlink) animationGO;
                    animationBlink.setBlinkNumberofTimes(20);
                    animationBlink.setBlinkStyle(AnimationDefine.BlinkAnimationBlinkStyle.NumberBlink);
                    animationBlink.setReplaceStyle(AnimationDefine.BlinkAnimationReplaceStyle.ColorReplace);
                    animationBlink.setBlinkAnimationReplaceColor(new com.supermap.data.Color(0, 0, 255, 255));
                    animationGO = animationBlink;
                    break;
                case 2:
                    AnimationAttribute animationAttribute = (AnimationAttribute) animationGO;
                    animationAttribute.setStartLineColor(new com.supermap.data.Color(255, 0, 0, 255));
                    animationAttribute.setEndLineColor(new com.supermap.data.Color(0, 0, 255, 255));
                    animationAttribute.setLineColorAttr(true);
                    animationAttribute.setStartLineWidth(0);
                    animationAttribute.setEndLineWidth(1);
                    animationAttribute.setLineWidthAttr(true);
                    animationGO = animationAttribute;
                    break;
                case 3:
                    AnimationShow animationShow = (AnimationShow) animationGO;
                    animationShow.setShowEffect(0);
                    animationShow.setShowState(true);
                    animationGO = animationShow;
                    break;
                case 4:
                    AnimationRotate animationRotate = (AnimationRotate) animationGO;
                    animationRotate.setStartAngle(new Point3D(0, 0, 0));
                    animationRotate.setEndAngle(new Point3D(720, 720, 0));
                    animationGO = animationRotate;
                    break;
                case 5:
                    AnimationScale animationScale = (AnimationScale) animationGO;
                    animationScale.setStartScaleFactor(0);
                    animationScale.setEndScaleFactor(1);
                    animationGO = animationScale;
                    break;
                case 6:
                    AnimationGrow animationGrow = (AnimationGrow) animationGO;
                    animationGrow.setStartLocation(0);
                    animationGrow.setEndLocation(1);
                    animationGO = animationGrow;
                    break;
            }
            //清空创建路径动画时的数据
            mapControl.getMap().getTrackingLayer().clear();
            point2Ds = null;
            savePoint2Ds = null;

            if (createInfo.hasKey("startTime") && animationGroup.getAnimationCount() > 0) {
                double startTime = createInfo.getDouble("startTime");
                if (createInfo.hasKey("startMode")) {
                    int startMode = createInfo.getInt("startMode");
                    AnimationGO lastAnimationGo = animationGroup.getAnimationByIndex(animationGroup.getAnimationCount() - 1);
                    switch (startMode) {
                        case 1:         //上一动作播放之后
                            double lastEndTime = lastAnimationGo.getStartTime() + lastAnimationGo.getDuration();
                            startTime += lastEndTime;
                            break;
                        case 2:         //点击开始
                            break;
                        case 3:         //上一动作同时播放
                            double lastStartTime = lastAnimationGo.getStartTime();
                            startTime += lastStartTime;
                            break;
                    }
                }
                animationGO.setStartTime(startTime);
            } else if (createInfo.hasKey("startTime") && animationGroup.getAnimationCount() == 0) {
                int startTime = createInfo.getInt("startTime");
                animationGO.setStartTime(startTime);
            }
            if (createInfo.hasKey("durationTime")) {
                double durationTime = createInfo.getDouble("durationTime");
                animationGO.setDuration(durationTime);
            }
            if (createInfo.hasKey("startMode")) {
                int startMode = createInfo.getInt("startMode");

            }

            String mapName = mapControl.getMap().getName();
            if (mapName == null || mapName.equals("")) {
                if (newPlotMapName != null && !newPlotMapName.equals("")) {
                    mapName = newPlotMapName;
                } else {
                    int layerCount = mapControl.getMap().getLayers().getCount();
                    if (layerCount > 0) {
                        mapName = mapControl.getMap().getLayers().get(layerCount - 1).getName();
                    }
                }
                mapControl.getMap().save(mapName);
            }


            String animationGoName = "动画_" + AnimationManager.getInstance().getGroupByName(animationGroupName).getAnimationCount();
            if (createInfo.hasKey("layerName") && createInfo.hasKey("geoId")) {
                String layerName = createInfo.getString("layerName");
                int geoId = createInfo.getInt("geoId");
                Layer layer = mapControl.getMap().getLayers().get(layerName);
                if (layer != null) {
                    DatasetVector dataset = (DatasetVector) mapControl.getMap().getLayers().get(layerName).getDataset();
                    Recordset recordset = dataset.query("SmID=" + geoId, CursorType.STATIC);
                    Geometry geometry = recordset.getGeometry();
                    if (geometry != null) {
                        animationGO.setName(animationGoName);
//                            String name=mapControl.getMap().getName();
//                            if(name==null||name.equals("")){
//                                mapControl.getMap().save();
//                            }
                        animationGO.setGeometry((GeoGraphicObject) geometry, mapControl.getHandle(), layer.getName());
                        animationGroup.addAnimation(animationGO);
                        geometry.dispose();
                    }
                    recordset.dispose();
                }
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 保存推演动画
     */
    @ReactMethod
    public static void animationSave(String savePath, String fileName, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            File file = new File(savePath);
            if (!file.exists()) {
                file.mkdirs();
            }
//            String mapName=mapControl.getMap().getName();
            String tempPath = savePath + "/" + fileName + ".xml";
            String path = SMFileUtil.formateNoneExistFileName(tempPath, false);
            boolean result = AnimationManager.getInstance().saveAnimationToXML(path);
            AnimationManager.getInstance().reset();
            // AnimationManager.getInstance().deleteAll();


            promise.resolve(result);
        } catch (Exception e) {
            promise.resolve(false);
        }
    }

    /**
     * 获取标绘对象type
     */
    @ReactMethod
    public static void getGeometryTypeById(String layerName, int geoId, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            int type = -1;
            Layer layer = mapControl.getMap().getLayers().get(layerName);
            if (layer != null) {
                DatasetVector dataset = (DatasetVector) mapControl.getMap().getLayers().get(layerName).getDataset();
                Recordset recordset = dataset.query("SmID=" + geoId, CursorType.STATIC);
                Geometry geometry = recordset.getGeometry();
                if (geometry != null) {
                    GeoGraphicObject geoGraphicObject = (GeoGraphicObject) geometry;
                    GraphicObjectType graphicObjectType = geoGraphicObject.getSymbolType();
                    type = graphicObjectType.value();
                    geometry.dispose();
                }
                recordset.dispose();
            }


            promise.resolve(type);
        } catch (Exception e) {
            promise.resolve(-1);
        }
    }


    /**
     * 添加路径动画点获取回退路径动画点
     *
     * @param point
     * @param promise
     */
    @ReactMethod
    public void addAnimationWayPoint(ReadableMap point, boolean isAdd, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            if (!isAdd) {
                if (point2Ds == null || point2Ds.getCount() == 0) {
                    promise.resolve(false);
                    return;
                } else {
                    point2Ds.remove(point2Ds.getCount() - 1);
                }
            } else {
                Point point1 = new Point((int) point.getDouble("x"), (int) point.getDouble("y"));
                Point2D point2D = mapControl.getMap().pixelToMap(point1);
                if (point2Ds == null) {
                    point2Ds = new Point2Ds();
                }
                point2Ds.add(point2D);
            }
            GeoStyle style = new GeoStyle();
            style.setMarkerSize(new Size2D(10, 10));
            style.setLineColor(new Color(255, 105, 0));
            style.setMarkerSymbolID(3614);
            {

                if (point2Ds.getCount() == 0) {
                    mapControl.getMap().getTrackingLayer().clear();
                } else if (point2Ds.getCount() == 1) {
                    mapControl.getMap().getTrackingLayer().clear();
                    GeoPoint geoPoint = new GeoPoint(point2Ds.getItem(0));
                    geoPoint.setStyle(style);
                    mapControl.getMap().getTrackingLayer().add(geoPoint, "point");
                } else if (point2Ds.getCount() > 1) {
                    mapControl.getMap().getTrackingLayer().clear();
                    GeoLine geoLine = new GeoLine(point2Ds);
                    geoLine.setStyle(style);
                    mapControl.getMap().getTrackingLayer().add(geoLine, "line");
                }
                mapControl.getMap().refresh();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 刷新路径动画点
     * @param promise
     */
    @ReactMethod
    public void refreshAnimationWayPoint(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            if(savePoint2Ds==null||savePoint2Ds.getCount()==0){
                point2Ds=null;
                mapControl.getMap().getTrackingLayer().clear();
                promise.resolve(true);
                return;
            }
            point2Ds=new Point2Ds(savePoint2Ds);

            GeoStyle style = new GeoStyle();
            style.setMarkerSize(new Size2D(10, 10));
            style.setLineColor(new Color(255, 105, 0));
            style.setMarkerSymbolID(3614);
            {
                mapControl.getMap().getTrackingLayer().clear();
                if (point2Ds.getCount() == 1) {
                    GeoPoint geoPoint = new GeoPoint(point2Ds.getItem(0));
                    geoPoint.setStyle(style);
                    mapControl.getMap().getTrackingLayer().add(geoPoint, "point");
                } else if (point2Ds.getCount() > 1) {
                    GeoLine geoLine = new GeoLine(point2Ds);
                    geoLine.setStyle(style);
                    mapControl.getMap().getTrackingLayer().add(geoLine, "line");
                }
                mapControl.getMap().refresh();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 结束添加路径动画
     * @param promise
     */
    @ReactMethod
    public void cancelAnimationWayPoint(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            mapControl.getMap().getTrackingLayer().clear();
            point2Ds = null;
            savePoint2Ds = null;
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 结束添加路径动画
     *
     * @param isSave
     * @param promise
     */
    @ReactMethod
    public void endAnimationWayPoint(boolean isSave, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            if (!isSave) {
                AnimationManager.getInstance().deleteAll();
                mapControl.getMap().getTrackingLayer().clear();
                point2Ds = null;
                savePoint2Ds = null;
                promise.resolve(true);
                return;
            }

            WritableArray arr = Arguments.createArray();
            if (point2Ds.getCount() > 0) {
                for (int i = 0; i < point2Ds.getCount(); i++) {
                    WritableMap writeMap = Arguments.createMap();
                    Point2D point2D = point2Ds.getItem(i);
                    writeMap.putDouble("x", point2D.getX());
                    writeMap.putDouble("y", point2D.getY());
                    arr.pushMap(writeMap);
                }
            }
            savePoint2Ds=new Point2Ds(point2Ds);
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据geoId获取对象已设置的动画类型数量
     *
     * @param geoId
     * @param promise
     */
    @ReactMethod
    public void getGeoAnimationTypes(int geoId, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();


            int[] array=new int[7];
            WritableArray arr = Arguments.createArray();
            for (int i = 0; i < array.length; i++) {
                arr.pushInt(0);
            }

            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                promise.resolve(arr);
                return;
            }

            int size=animationGroup.getAnimationCount();
            for (int i = 0; i < size; i++) {
                AnimationGO animationGO=animationGroup.getAnimationByIndex(i);
                int id=animationGO.getGeometry();
                if(id==geoId){
                    int type=animationGO.getAnimationType().value();
                    array[type]+=1;
                }
            }

            arr = Arguments.createArray();
            for (int i = 0; i < array.length; i++) {
                arr.pushInt(array[i]);
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取所有动画节点数据
     *
     * @param promise
     */
    @ReactMethod
    public void getAnimationNodeList(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            WritableArray arr = Arguments.createArray();

            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                promise.resolve(arr);
                return;
            }

            int size=animationGroup.getAnimationCount();
            for (int i = 0; i < size; i++) {
                AnimationGO animationGO=animationGroup.getAnimationByIndex(i);
                WritableMap writeMap = Arguments.createMap();
                writeMap.putInt("index",i);
                writeMap.putString("name",animationGO.getName());
                arr.pushMap(writeMap);
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 删除动画节点
     *
     * @param promise
     */
    @ReactMethod
    public void deleteAnimationNode(String nodeName,Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();


            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                promise.resolve(false);
                return;
            }

            boolean result=animationGroup.deleteAnimation(nodeName);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 删除动画节点
     *
     * @param promise
     */
    @ReactMethod
    public void modifyAnimationNodeName(int index,String newNodeName,Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();


            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                promise.resolve(false);
                return;
            }

            AnimationGO animationGO=animationGroup.getAnimationByIndex(index);
            boolean result=animationGO.setName(newNodeName);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移动节点位置
     *
     * @param promise
     */
    @ReactMethod
    public void moveAnimationNode(int index,boolean isUp,Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();


            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                promise.resolve(false);
                return;
            }


            int size=animationGroup.getAnimationCount();
            if((isUp&&index==0)||(!isUp&&index==size-1)){
                promise.resolve(false);
                return;
            }
            int tempIndex=isUp?index-1:index;
            String tempGroupName="temp";
            AnimationGroup tempGroup=AnimationManager.getInstance().addAnimationGroup(tempGroupName);
            for (int i=0;i<size;i++){
                if(tempIndex==i){
                    AnimationGO animationGO1=AnimationManager.getInstance().createAnimation(animationGroup.getAnimationByIndex(tempIndex).getAnimationType());
                    String xmlStr1=animationGroup.getAnimationByIndex(tempIndex).toXml();
                    animationGO1.fromXml(xmlStr1);

                    AnimationGO animationGO2=AnimationManager.getInstance().createAnimation(animationGroup.getAnimationByIndex(tempIndex+1).getAnimationType());
                    String xmlStr2=animationGroup.getAnimationByIndex(tempIndex+1).toXml();
                    animationGO2.fromXml(xmlStr2);

                    tempGroup.addAnimation(animationGO2);
                    tempGroup.addAnimation(animationGO1);
                    i++;
                }else {
                    AnimationGO animationGO1=AnimationManager.getInstance().createAnimation(animationGroup.getAnimationByIndex(i).getAnimationType());
                    String xmlStr1=animationGroup.getAnimationByIndex(i).toXml();
                    animationGO1.fromXml(xmlStr1);
                    tempGroup.addAnimation(animationGO1);
                }
            }

            AnimationManager.getInstance().getGroupByIndex(0).setGroupName(animationGroupName);
            AnimationManager.getInstance().deleteGroupByName(animationGroupName);
            AnimationManager.getInstance().getGroupByIndex(0).setGroupName(animationGroupName);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取动画节点参数
     *
     * @param promise
     */
    @ReactMethod
    public void getAnimationGoInfo(int index,Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();


            WritableMap writeMap = Arguments.createMap();
            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                promise.resolve(writeMap);
                return;
            }
            int size=animationGroup.getAnimationCount();
            if(index>=0&&index<size){
                AnimationGO animationGO=animationGroup.getAnimationByIndex(index);
                AnimationDefine.AnimationType type=animationGO.getAnimationType();

                writeMap.putString("name",animationGO.getName());
                writeMap.putString("startTime",animationGO.getStartTime()+"");
                writeMap.putString("durationTime",animationGO.getDuration()+"");
                writeMap.putInt("animationType",animationGO.getAnimationType().value());

                switch (type.value()){
                    case 0:
                        break;
                    case 1:
                        AnimationBlink animationBlink=(AnimationBlink)animationGO;
                        writeMap.putInt("blinkStyle",animationBlink.getBlinkStyle().value());
                        writeMap.putString("blinkinterval",animationBlink.getBlinkInterval()+"");
                        writeMap.putString("blinkNumber",animationBlink.getBlinkNumberofTimes()+"");

                        writeMap.putBoolean("blinkAnimationReplaceStyle",animationBlink.getReplaceStyle().value()==0?false:true);
                        writeMap.putInt("blinkAnimationStartColor",animationBlink.getBlinkAnimationStartColor().getRGB());
                        writeMap.putInt("blinkAnimationReplaceColor",animationBlink.getBlinkAnimationReplaceColor().getRGB());
                        break;
                    case 2:
                        AnimationAttribute animationAttribute=(AnimationAttribute)animationGO;
                        writeMap.putBoolean("lineWidthAttr",animationAttribute.getLineWidthAttr());
                        writeMap.putString("startLineWidth",animationAttribute.getStartLineWidth()+"");
                        writeMap.putString("endLineWidth",animationAttribute.getEndLineWidth()+"");
                        writeMap.putBoolean("lineColorAttr",animationAttribute.getLineColorAttr());
                        writeMap.putInt("startLineColor",animationAttribute.getStartLineColor().getRGB());
                        writeMap.putInt("endLineColor",animationAttribute.getEndLineColor().getRGB());

                        writeMap.putBoolean("surroundLineWidthAttr",animationAttribute.getSurroundLineWidthAttr());
                        writeMap.putString("startSurroundLineWidth",animationAttribute.getStartSurroundLineWidth()+"");
                        writeMap.putString("endSurroundLineWidth",animationAttribute.getEndSurroundLineWidth()+"");
                        writeMap.putBoolean("surroundLineColorAttr",animationAttribute.getSurroundLineColorAttr());
                        writeMap.putInt("startSurroundLineColor",animationAttribute.getStartSurroundLineColor().getRGB());
                        writeMap.putInt("endSurroundLineColor",animationAttribute.getEndSurroundLineColor().getRGB());
                        break;
                    case 3:
                        AnimationShow animationShow=(AnimationShow)animationGO;
                        writeMap.putBoolean("showState",animationShow.getShowState());
                        writeMap.putBoolean("showEffect",animationShow.getShowEffect()==0?false:true);
                        break;
                    case 4:
                        AnimationRotate animationRotate=(AnimationRotate)animationGO;
                        writeMap.putInt("rotateDirection", animationRotate.GetRotateDirection().value());
                        WritableMap startAngle=Arguments.createMap();
                        startAngle.putDouble("x",animationRotate.getStartAngle().getX());
                        startAngle.putDouble("y",animationRotate.getStartAngle().getY());
                        writeMap.putMap("startAngle",startAngle);
                        WritableMap endAngle=Arguments.createMap();
                        endAngle.putDouble("x",animationRotate.getEndAngle().getX());
                        endAngle.putDouble("y",animationRotate.getEndAngle().getY());
                        writeMap.putMap("endAngle",endAngle);
                        break;
                    case 5:
                        AnimationScale animationScale=(AnimationScale)animationGO;
                        writeMap.putString("startScale",animationScale.getStartScaleFactor()+"");
                        writeMap.putString("endScale",animationScale.getEndScaleFactor()+"");
                        break;
                    case 6:
                        AnimationGrow animationGrow=(AnimationGrow)animationGO;
                        writeMap.putString("startLocation",animationGrow.getStartLocation()+"");
                        writeMap.putString("endLocation",animationGrow.getEndLocation()+"");
                        break;
                }
            }
            ReadableMapKeySetIterator keySetIterator = writeMap.keySetIterator();
            while (keySetIterator.hasNextKey()) {
                String key = keySetIterator.nextKey();
                ReadableType readableType=writeMap.getType(key);
                if(readableType==ReadableType.String){
                    String str=writeMap.getString(key);
                    if(str.endsWith(".0")){
                        writeMap.putString(key,str.replace(".0",""));
                    }
                }
            }
            promise.resolve(writeMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
    /**
     * 修改动画节点属性
     *
     * @param promise
     */
    @ReactMethod
    public void modifyAnimationNode(int index,ReadableMap nodeInfo,Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();


            String animationGroupName = "Create_Animation_Instance_#"; //默认创建动画分组的名称，名称特殊一点，保证唯一
            AnimationGroup animationGroup = AnimationManager.getInstance().getGroupByName(animationGroupName);
            if (animationGroup == null) {
                promise.resolve(false);
                return;
            }
            int size=animationGroup.getAnimationCount();
            if(index>=0&&index<size){
                AnimationGO animationGO=animationGroup.getAnimationByIndex(index);
                AnimationDefine.AnimationType type=animationGO.getAnimationType();


                if(nodeInfo.hasKey("name")){
                    animationGO.setName(nodeInfo.getString("name"));
                }
                if(nodeInfo.hasKey("startTime")){
                    animationGO.setStartTime(Double.parseDouble(nodeInfo.getString("startTime")));
                }
                if(nodeInfo.hasKey("durationTime")){
                    animationGO.setDuration(Double.parseDouble(nodeInfo.getString("durationTime")));
                }
                switch (type.value()){
                    case 0:
                        break;
                    case 1:
                        AnimationBlink animationBlink=(AnimationBlink)animationGO;
                        if(nodeInfo.hasKey("blinkStyle")){
                            int blinkStyle=nodeInfo.getInt("blinkStyle");
                            AnimationDefine.BlinkAnimationBlinkStyle linkStyle=blinkStyle==0?AnimationDefine.BlinkAnimationBlinkStyle.FrequencyBlink:AnimationDefine.BlinkAnimationBlinkStyle.NumberBlink;
                            animationBlink.setBlinkStyle(linkStyle);
                            if(blinkStyle==0){
                                animationBlink.setBlinkInterval(Double.parseDouble(nodeInfo.getString("blinkinterval")));
                            }else {
                                animationBlink.setBlinkNumberofTimes(Integer.parseInt(nodeInfo.getString("blinkNumber")));
                            }
                        }
                        if(nodeInfo.hasKey("blinkAnimationReplaceStyle")){
                            boolean blinkAnimationReplaceStyle = nodeInfo.getBoolean("blinkAnimationReplaceStyle");
                            animationBlink.setReplaceStyle(blinkAnimationReplaceStyle?AnimationDefine.BlinkAnimationReplaceStyle.ColorReplace:AnimationDefine.BlinkAnimationReplaceStyle.NoColorReplace);
                            if(blinkAnimationReplaceStyle){
                                if(nodeInfo.hasKey("blinkAnimationStartColor")){
                                    Color blinkAnimationStartColor = new Color(nodeInfo.getInt("blinkAnimationStartColor"));
                                    animationBlink.setBlinkAnimationStartColor(blinkAnimationStartColor);
                                }
                                if(nodeInfo.hasKey("blinkAnimationReplaceColor")){
                                    Color blinkAnimationReplaceColor = new Color(nodeInfo.getInt("blinkAnimationReplaceColor"));
                                    animationBlink.setBlinkAnimationReplaceColor(blinkAnimationReplaceColor);
                                }
                            }
                        }
                        break;
                    case 2:
                        AnimationAttribute animationAttribute=(AnimationAttribute)animationGO;

                        if(nodeInfo.hasKey("lineWidthAttr")){
                            boolean lineWidthAttr = nodeInfo.getBoolean("lineWidthAttr");
                            animationAttribute.setLineWidthAttr(lineWidthAttr);
                            if(lineWidthAttr){
                                if(nodeInfo.hasKey("startLineWidth")){
                                    animationAttribute.setStartLineWidth(Double.parseDouble(nodeInfo.getString("startLineWidth")));
                                }
                                if(nodeInfo.hasKey("endLineWidth")){
                                    animationAttribute.setEndLineWidth(Double.parseDouble(nodeInfo.getString("endLineWidth")));
                                }
                            }
                        }
                        if(nodeInfo.hasKey("lineColorAttr")){
                            boolean lineColorAttr = nodeInfo.getBoolean("lineColorAttr");
                            animationAttribute.setLineColorAttr(lineColorAttr);
                            if(lineColorAttr){
                                if(nodeInfo.hasKey("startLineColor")){
                                    Color startLineColor = new Color(nodeInfo.getInt("startLineColor"));
                                    animationAttribute.setStartLineColor(startLineColor);
                                }
                                if(nodeInfo.hasKey("endLineColor")){
                                    Color endLineColor = new Color(nodeInfo.getInt("endLineColor"));
                                    animationAttribute.setEndLineColor(endLineColor);
                                }
                            }
                        }
                        if(nodeInfo.hasKey("surroundLineWidthAttr")){
                            boolean surroundLineWidthAttr = nodeInfo.getBoolean("surroundLineWidthAttr");
                            animationAttribute.setSurroundLineWidthAttr(surroundLineWidthAttr);
                            if(surroundLineWidthAttr){
                                if(nodeInfo.hasKey("startSurroundLineWidth")){
                                    animationAttribute.setStartSurroundLineWidth(Double.parseDouble(nodeInfo.getString("startSurroundLineWidth")));
                                }
                                if(nodeInfo.hasKey("endSurroundLineWidth")){
                                    animationAttribute.setEndSurroundLineWidth(Double.parseDouble(nodeInfo.getString("endSurroundLineWidth")));
                                }
                            }
                        }
                        if(nodeInfo.hasKey("surroundLineColorAttr")){
                            boolean surroundLineColorAttr = nodeInfo.getBoolean("surroundLineColorAttr");
                            animationAttribute.setSurroundLineColorAttr(surroundLineColorAttr);
                            if(surroundLineColorAttr){
                                if(nodeInfo.hasKey("startSurroundLineColor")){
                                    Color startSurroundLineColor = new Color(nodeInfo.getInt("startSurroundLineColor"));
                                    animationAttribute.setStartSurroundLineColor(startSurroundLineColor);
                                }
                                if(nodeInfo.hasKey("endSurroundLineColor")){
                                    Color endSurroundLineColor = new Color(nodeInfo.getInt("endSurroundLineColor"));
                                    animationAttribute.setEndSurroundLineColor(endSurroundLineColor);
                                }
                            }
                        }
                        break;
                    case 3:
                        AnimationShow animationShow=(AnimationShow)animationGO;
                        if(nodeInfo.hasKey("showState")){
                            animationShow.setShowState(nodeInfo.getBoolean("showState"));
                        }
                        if(nodeInfo.hasKey("showEffect")){
                            animationShow.setShowEffect(nodeInfo.getBoolean("showEffect")?1:0);
                        }
                        break;
                    case 4:
                        AnimationRotate animationRotate=(AnimationRotate)animationGO;

                        if(nodeInfo.hasKey("rotateDirection")) {
                            AnimationDefine.RotateDirection rotateDirection = nodeInfo.getInt("rotateDirection") == 0 ? AnimationDefine.RotateDirection.ClockWise : AnimationDefine.RotateDirection.AntiClockWise;
                            animationRotate.setRotateDirection(rotateDirection);
                        }
                        if(nodeInfo.hasKey("startAngle")){
                            ReadableMap startAngle=nodeInfo.getMap("startAngle");
                            Point3D startAnglePoint = new Point3D(startAngle.getDouble("x"), startAngle.getDouble("y"), 0);
                            animationRotate.setStartAngle(startAnglePoint);
                        }
                        if(nodeInfo.hasKey("endAngle")){
                            ReadableMap endAngle=nodeInfo.getMap("endAngle");
                            Point3D endAnglePoint = new Point3D(endAngle.getDouble("x"), endAngle.getDouble("y"), 0);
                            animationRotate.setEndAngle(endAnglePoint);
                        }
                        break;
                    case 5:
                        AnimationScale animationScale=(AnimationScale)animationGO;
                        if(nodeInfo.hasKey("startScale")){
                            animationScale.setStartScaleFactor(Double.parseDouble(nodeInfo.getString("startScale")));
                        }
                        if(nodeInfo.hasKey("endScale")){
                            animationScale.setEndScaleFactor(Double.parseDouble(nodeInfo.getString("endScale")));
                        }
                        break;
                    case 6:
                        AnimationGrow animationGrow=(AnimationGrow)animationGO;
                        if(nodeInfo.hasKey("startLocation")){
                            animationGrow.setStartLocation(Double.parseDouble(nodeInfo.getString("startLocation")));
                        }
                        if(nodeInfo.hasKey("endLocation")){
                            animationGrow.setEndLocation(Double.parseDouble(nodeInfo.getString("endLocation")));
                        }
                        break;
                }
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}
