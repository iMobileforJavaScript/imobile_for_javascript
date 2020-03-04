package com.supermap.interfaces;

import android.graphics.Point;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.WindowManager;


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
import com.supermap.containts.EventConst;
import com.supermap.data.AltitudeMode;
import com.supermap.data.GeoBox;
import com.supermap.data.GeoPoint3D;
import com.supermap.data.ImageFormatType;
import com.supermap.data.Point2D;
import com.supermap.data.Point3D;
import com.supermap.data.Point3Ds;
import com.supermap.data.Size2D;
import com.supermap.data.Workspace;
import com.supermap.data.WorkspaceConnectionInfo;
import com.supermap.data.WorkspaceType;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.map3D.AnalysisHelper;
import com.supermap.map3D.FlyHelper;
import com.supermap.map3D.LabelHelper;
import com.supermap.map3D.PoiSearchHelper;
import com.supermap.map3D.toolKit.PoiGsonBean;
import com.supermap.map3D.toolKit.TouchUtil;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MeasureListener;
import com.supermap.plugin.LocationManagePlugin;
import com.supermap.realspace.Action3D;
import com.supermap.realspace.BoxClipPart;
import com.supermap.realspace.Camera;
import com.supermap.realspace.Feature3D;
import com.supermap.realspace.Feature3Ds;
import com.supermap.realspace.GlobalImage;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3DType;
import com.supermap.realspace.Layer3Ds;
import com.supermap.realspace.PixelToGlobeMode;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.TerrainLayer;
import com.supermap.realspace.Tracking3DEvent;
import com.supermap.realspace.Tracking3DListener;
import com.supermap.rnsupermap.SceneViewManager;
import com.supermap.smNative.SMSceneWC;
import com.supermap.smNative.collector.SMCollector;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Map;


public class SScene extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SScene";
    private static SScene sScene;
    private static Camera defaultCamera;
    private static ReactApplicationContext context;
    private SMSceneWC smSceneWc;
    ReactContext mReactContext;
    private static SingleTapUpAction singleTapUpAction=SingleTapUpAction.NULL;
    private static LongPressAction longPressAction=LongPressAction.CIRCLEPOINT;
    private TouchUtil.OsgbAttributeCallBack osgbAttributeCallBack;
    private Tracking3DListener tracking3DListener;
    private static gestureListener gestureListener;
    //    private ArrayList<PoiGsonBean.PoiInfos> pointList;
    private ArrayList <ArrayList<PoiGsonBean.PoiInfos>> pointList=new ArrayList<ArrayList<PoiGsonBean.PoiInfos>>();
    private PoiGsonBean.PoiInfos firstPoint;
    private PoiGsonBean.PoiInfos secondPoint;
    public SScene(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static SScene getInstance() {
        if (sScene == null) {
            sScene = new SScene(context);
        }
        return sScene;
    }

    public static SScene getInstance(ReactApplicationContext context) {
        if (sScene == null) {
            sScene = new SScene(context);
        }
        return sScene;
    }

    public static void setInstance(SceneControl sceneControl) {
        sScene = getInstance();
        if (sScene.smSceneWc == null) {
            sScene.smSceneWc = new SMSceneWC();
        }

        sScene.smSceneWc.setSceneControl(sceneControl);

        if (sScene.smSceneWc.getWorkspace() == null) {
            sScene.smSceneWc.setWorkspace(new Workspace());
        }
    }



    public void setSceneControl() {
        setGestureDetector();
        setTracking3DListener();
        initLabelHelper();
        initAnalysisHelper();
    }

    /**
     * 设置手势监听
     */
    private void setGestureDetector() {
        sScene=getInstance();
        SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
        if(gestureListener==null){
            gestureListener=new gestureListener();
        }
        GestureDetector gestureDetector1 = new GestureDetector(context, gestureListener);
        sceneControl.setGestureDetector(gestureDetector1);

    }

    /**
     * 设置Tracking3DListener监听的问题
     * 1.返回的三维点在绘制的时候程序卡死，和iearth的通视卡死效果一样
     */
    private void setTracking3DListener() {
        sScene=getInstance();
        SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
        final Handler handler = new Handler(Looper.getMainLooper());
        tracking3DListener = new Tracking3DListener() {
            @Override
            public void tracking(final Tracking3DEvent tracking3DEvent) {
                sScene=getInstance();
                final SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
                handler.post(new Runnable() {

                    @Override
                    public void run() {
                        switch (singleTapUpAction) {
                            case NULL:
                                break;
                            case LABEL:
                                LabelHelper.getInstence().labelOperate(tracking3DEvent);
                                break;
                            case MEASURE:
                                AnalysisHelper.getInstence().initAnalysis(sceneControl,tracking3DEvent);
                                break;
                        }
                    }
                });
            }
        };
        sceneControl.addTrackingListener(tracking3DListener);
    }

    /**
     * 初始化LabelHelper
     */
    private void initLabelHelper() {
        sScene=getInstance();
        SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
        Workspace workspace = sceneControl.getScene().getWorkspace();
        String path = workspace.getConnectionInfo().getServer();
        String result = path.substring(0, path.lastIndexOf("/")) + "/files/";
        final String kmlName = "NodeAnimation.kml";
        sScene=getInstance();

        LabelHelper.getInstence().initSceneControl(context, sceneControl, result, kmlName);
    }

    /**
     * 初始化AnalysisHelper
     */
    private void initAnalysisHelper(){
        sScene=getInstance();
        SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
        AnalysisHelper.getInstence().initSceneControl(sceneControl);


    }

    class gestureListener implements GestureDetector.OnGestureListener {

        @Override
        public boolean onDown(MotionEvent event) {
            // TODO Auto-generated method stub

            return true;
        }

        @Override
        public boolean onFling(MotionEvent arg0, MotionEvent arg1, float arg2, float arg3) {
            // TODO Auto-generated method stub
            // Log.v("MyGesture", "onFling()");
            return true;
        }

        @Override
        public void onLongPress(final MotionEvent event) {
            // TODO Auto-generated method stub

            switch (longPressAction) {
                case NULL:
                    break;
                case CIRCLEPOINT:
                    LabelHelper.getInstence().showCirclePoint(event);
                    break;
            }

        }

        @Override
        public boolean onScroll(MotionEvent arg0, MotionEvent arg1, float arg2, float arg3) {
            // TODO Auto-generated method stub
            return true;
        }

        @Override
        public void onShowPress(MotionEvent arg0) {
            // TODO Auto-generated method stub


        }

        @Override
        public boolean onSingleTapUp(MotionEvent event) {
            // TODO Auto-generated method stub
            switch (singleTapUpAction) {
                case NULL:
                    break;
                case LABEL:
//                    LabelHelper.getInstence().labelOperate(event);
                    break;
                case ATTRIBUTE:
                    if (osgbAttributeCallBack != null) {
                        sScene=getInstance();
                        SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
                        osgbAttributeCallBack.attributeInfo(TouchUtil.getAttribute(sceneControl));
                    }
                    break;
            }
            return false;
        }
    }

    /**
     * 回调属性值
     */
    public void callBackttribute() {
        osgbAttributeCallBack = new TouchUtil.OsgbAttributeCallBack() {
            @Override
            public void attributeInfo(Map<String, String> attributeMap) {
                WritableMap map = Arguments.createMap();
                for (Map.Entry<String, String> entry : attributeMap.entrySet()) {
                    map.putString(entry.getKey(), entry.getValue());
                }
                mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_ATTRIBUTE, map);
            }
        };
    }

    /**
     * 开始旋转点
     */
    public void startShowCirclePoint() {
        longPressAction=LongPressAction.CIRCLEPOINT;
    }

    /**
     * 开始标注操作
     */
    public void startLabelOperate() {
        sScene=getInstance();
        SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
        sceneControl.setAction(Action3D.CREATEPOINT3D);
        singleTapUpAction = SingleTapUpAction.LABEL;

    }

    public void endShowCirclePoint(){
        longPressAction=LongPressAction.NULL;
    }
    /**
     * 开始获取属性值
     */
    public void startTouchAttribute() {
        singleTapUpAction = SingleTapUpAction.ATTRIBUTE;
    }

    /**
     * 开始测量
     */
    public void startMeasure(){
        singleTapUpAction=SingleTapUpAction.MEASURE;
    }

    /**
     * 清除单点手势监听
     */
    public void clearSingTapUpAction() {
        singleTapUpAction = SingleTapUpAction.NULL;
    }

    enum LongPressAction {
        /**
         * 空操作
         */
        NULL,
        /**
         * 长按出现旋转点
         */
        CIRCLEPOINT
    }


    enum SingleTapUpAction {
        /**
         * 空操作
         */
        NULL,
        /**
         * 标注
         */
        LABEL,
        /**
         * 属性
         */
        ATTRIBUTE,
        /**
         * 测量
         */
        MEASURE
    }


    public static SMSceneWC getSMWorkspace() {
        return getInstance().smSceneWc;
    }

    /**
     * 打开工作空间
     *
     * @param data
     * @param promise
     */
    @ReactMethod
    public void openWorkspace(ReadableMap data, Promise promise) {
        try {
            sScene = getInstance();
            Map params = data.toHashMap();
            boolean result = sScene.smSceneWc.openWorkspace(params);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据名字显示场景
     *
     * @param name
     * @param promise
     */
    @ReactMethod
    public void openMap(String name, Promise promise) {
        try {
            sScene = getInstance();
            if (sScene.smSceneWc.getWorkspace().getScenes().getCount() > 0) {
                Scene scene=sScene.smSceneWc.getSceneControl().getScene();
                String mapName = name;
                scene.open(mapName);
                scene.refresh();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取场景列表
     *
     * @param promise
     */
    @ReactMethod
    public void getMapList(Promise promise) {
        try {
            sScene = getInstance();
            int count = sScene.smSceneWc.getSceneControl().getScene().getWorkspace().getScenes().getCount();
            WritableArray arr = Arguments.createArray();
            if (count > 0) {
                for (int i = 0; i < count; i++) {
                    String name = sScene.smSceneWc.getSceneControl().getScene().getWorkspace().getScenes().get(i);
                    WritableMap map = Arguments.createMap();
                    map.putString("name", name);
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取当前场景图层列表
     *
     * @param promise
     */
    @ReactMethod
    public void getLayerList(Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            int count = scene.getLayers().getCount();
            if (scene.getLayers().getCount() > 0) {
                for (int i = 0; i < count; i++) {
                    String name = scene.getLayers().get(i).getName();
                    boolean visible = scene.getLayers().get(i).isVisible();
                    boolean selectable = scene.getLayers().get(i).isSelectable();
                    WritableMap map = Arguments.createMap();
                    String type =scene.getLayers().get(i).getType().toString();
                    map.putString("name", name);
                    map.putBoolean("visible", visible);
                    map.putBoolean("selectable", selectable);
                    map.putString("type",type);
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void changeBaseLayer(int type,Promise promise){
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            if(scene==null){
                promise.resolve(false);
                return;
            }
//            if( scene.getLayers().get("TianDiTu")!=null){
//                promise.resolve(true);
//                return;
//            }
//            scene.getLayers().removeLayerWithName1("TianDiTu");
//            scene.getLayers().removeLayerWithName1("BingMap");

            Thread.sleep(1000);
            Layer3D layer3d = null;

            if(type==1){//tianditu
                String  tiandituUrl = "http://t0.tianditu.com/img_c/wmts";
                layer3d = scene.getLayers().add(tiandituUrl,Layer3DType.l3dBingMaps,"TianDiTu",ImageFormatType.JPG_PNG,96,false);
            }else if (type==2){//bingMap
                String  tiandituUrl = "http://t0.tianditu.com/img_c/wmts";
                layer3d = scene.getLayers().add(tiandituUrl,Layer3DType.l3dBingMaps,"BingMap",ImageFormatType.JPG_PNG,96,false);
//                layer3d = scene.getLayers().add("",Layer3DType.l3dBingMaps,"BingMap",false);


            }
            promise.resolve(layer3d!=null);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    @ReactMethod
    public void addLayer3D(String Url, String Layer3DType, String layerName, String imageFormatType, double dpi, Boolean addToHead,String token,Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            if(scene==null){
                promise.resolve(false);
                return;
            }
            com.supermap.realspace.Layer3DType layer3DType = null;
            ImageFormatType imageFormatType1 = null;
            switch (Layer3DType) {
                case "IMAGEFILE":
                    layer3DType = com.supermap.realspace.Layer3DType.IMAGEFILE;
                    break;
                case "KML":
                    layer3DType = com.supermap.realspace.Layer3DType.KML;
                    break;

                case "l3dBingMaps":
                    layer3DType = com.supermap.realspace.Layer3DType.l3dBingMaps;
                    break;

                case "OSGBFILE":
                    layer3DType = com.supermap.realspace.Layer3DType.OSGBFILE;
                    break;

                case "VECTORFILE":
                    layer3DType = com.supermap.realspace.Layer3DType.VECTORFILE;
                    break;
                case "WMTS":
                    layer3DType = com.supermap.realspace.Layer3DType.WMTS;
                    break;
            }

            switch (imageFormatType) {
                case "BMP":
                    imageFormatType1 = ImageFormatType.BMP;
                    break;
                case "DXTZ":
                    imageFormatType1 = ImageFormatType.DXTZ;
                    break;

                case "GIF":
                    imageFormatType1 = ImageFormatType.GIF;
                    break;

                case "JPG":
                    imageFormatType1 = ImageFormatType.JPG;
                    break;

                case "JPG_PNG":
                    imageFormatType1 = ImageFormatType.JPG_PNG;
                    break;
                case "NONE":
                    imageFormatType1 = ImageFormatType.NONE;
                    break;
                case "PNG":
                    imageFormatType1 = ImageFormatType.PNG;
                    break;
            }
            if (imageFormatType == null) {
                scene.getLayers().add(Url, layer3DType, layerName, addToHead);

            }
            else {
                scene.getLayers().add(Url, layer3DType, layerName, imageFormatType1, dpi, addToHead);

            }
            scene.refresh();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }

    }


    @ReactMethod
    public void ensureVisibleLayer(String layerName,Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            Layer3D layer3d = scene.getLayers().get(layerName);
            if(layer3d!=null){
                scene.ensureVisible(layer3d.getBounds());
            }else{
                TerrainLayer layerT = scene.getTerrainLayers().get(layerName);
                if(layerT!=null){
                    scene.ensureVisible(layerT.getBounds());
                }
            }
            promise.resolve(true);
        }catch (Exception e) {
            promise.reject(e);
        }
    }
    /**
     * 获取当前场景地形图层列表
     *
     * @param promise
     */
    @ReactMethod
    public void getTerrainLayerList(Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getTerrainLayers().getCount() > 0) {
                for (int i = 0; i < scene.getTerrainLayers().getCount(); i++) {
                    String name = scene.getTerrainLayers().get(i).getName();
                    boolean visible = scene.getTerrainLayers().get(i).isVisible();
                    WritableMap map = Arguments.createMap();
                    map.putString("name", name);
                    map.putBoolean("visible", visible);
                    map.putString("type", "Terrain");
                    map.putBoolean("basemap", false);
                    map.putBoolean("selectable", false);
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 添加影像缓存
     *
     * @param promise
     */
    @ReactMethod
    public void addImageCacheLayer(String ImageCachePath, String layerName, Promise promise) {
        try {
            if(ImageCachePath.contains("iserver/services")){
                String name =  addImageOnlineLayer(ImageCachePath);
                promise.resolve(name);
            }else {
                sScene = getInstance();
                Scene scene = sScene.smSceneWc.getSceneControl().getScene();
                int n = 1;
                String AvailableName = layerName;
                while (true) {
                    if (scene.getLayers().get(AvailableName) != null) {
                        AvailableName = layerName + "#" + n++;//[layerName stringByAppendingFormat:@"#%i",n++];
                    } else {
                        break;
                    }
                }
                sScene.smSceneWc.getSceneControl().isRender(false);
//            Layer3D layer3D =  scene.getLayers().add("http://192.168.0.104:8090/iserver/services/3D-srtm_58_06-dem/rest/realspace/datas/srtm_58_06_1@dem",Layer3DType.IMAGEFILE,AvailableName,true);
                Layer3D layer3D = scene.getLayers().addLayerWith(ImageCachePath, Layer3DType.IMAGEFILE, true, AvailableName);
                sScene.smSceneWc.getSceneControl().isRender(true);
                promise.resolve(layer3D.getName());
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    private String addImageOnlineLayer(String url) {

        sScene = getInstance();
        Scene scene = sScene.smSceneWc.getSceneControl().getScene();
        String[] res = url.split("/");
        String layerName =  res[res.length-1];
        int n = 1;
        String AvailableName = layerName;
        while(true){
            if(scene.getLayers().get(AvailableName) != null){
                AvailableName = layerName + "#" + n++;//[layerName stringByAppendingFormat:@"#%i",n++];
            }else{
                break;
            }
        }
        sScene.smSceneWc.getSceneControl().isRender(false);
        //"http://192.168.0.104:8090/iserver/services/3D-srtm_58_06-dem/rest/realspace/datas/srtm_58_06_1@dem"
        Layer3D layer3D =  scene.getLayers().add(url,Layer3DType.IMAGEFILE,AvailableName,true);
    //            Layer3D layer3D = scene.getLayers().addLayerWith(ImageCachePath,Layer3DType.IMAGEFILE,true,AvailableName);
        sScene.smSceneWc.getSceneControl().isRender(true);
        return  layer3D.getName();

    }

    /**
     * 删除影像图层
     *
     * @param promise
     */
    @ReactMethod
    public void removeImageCacheLayer(String layerName, Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            sScene.smSceneWc.getSceneControl().isRender(false);
            boolean b = scene.getLayers().removeLayerWithName(layerName);
            sScene.smSceneWc.getSceneControl().isRender(true);
            Thread.sleep(1000);
//            Layer3D layer = scene.getLayers().get(layerName);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加影像缓存
     *
     * @param promise
     */
    @ReactMethod
    public void addTerrainCacheLayer(String terrainCache, String layerName, Promise promise) {
        try {

            if(terrainCache.contains("iserver/services")){
               String name =  addTerrainOnlineLayer(terrainCache);
               promise.resolve(name);
            }else {
                sScene = getInstance();
                Scene scene = sScene.smSceneWc.getSceneControl().getScene();
                int n = 1;
                String AvailableName = layerName;
                while (true) {
                    if (scene.getTerrainLayers().get(AvailableName) != null) {
                        AvailableName = layerName + "#" + n++;//[layerName stringByAppendingFormat:@"#%i",n++];
                    } else {
                        break;
                    }
                }
                sScene.smSceneWc.getSceneControl().isRender(false);
                TerrainLayer layer = scene.getTerrainLayers().add(terrainCache, true, AvailableName, "");//addLayerWith(terrainCache,Layer3DType.IMAGEFILE,true,AvailableName);
//            TerrainLayer layer = scene.getTerrainLayers().addIserver("http://192.168.0.104:8090/iserver/services/3D-srtm_58_06-dem/rest/realspace/datas/srtm_58_06_1@dem_Terrain","onlineLayer");
                sScene.smSceneWc.getSceneControl().isRender(true);
                promise.resolve(layer.getName());
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    private String addTerrainOnlineLayer(String url) {

        sScene = getInstance();
        Scene scene = sScene.smSceneWc.getSceneControl().getScene();
        String[] res = url.split("/");
        String layerName =  res[res.length-1];
        int n = 1;
        String AvailableName = layerName;
        while(true){
            if(scene.getTerrainLayers().get(AvailableName) != null){
                AvailableName = layerName + "#" + n++;//[layerName stringByAppendingFormat:@"#%i",n++];
            }else{
                break;
            }
        }
        String name = "";
        sScene.smSceneWc.getSceneControl().isRender(false);
        //"http://192.168.0.104:8090/iserver/services/3D-srtm_58_06-dem/rest/realspace/datas/srtm_58_06_1@dem_Terrain"
//            TerrainLayer layer = scene.getTerrainLayers().add(terrainCache,true,AvailableName,"");//addLayerWith(terrainCache,Layer3DType.IMAGEFILE,true,AvailableName);
        TerrainLayer layer = scene.getTerrainLayers().addIserver(url,AvailableName);
        sScene.smSceneWc.getSceneControl().isRender(true);

        if(layer!=null){
            name = layer.getName();
        }
        return name;
    }

    /**
     * 删除地形图层
     *
     * @param promise
     */
    @ReactMethod
    public void removeTerrainCacheLayer(String layerName, Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            sScene.smSceneWc.getSceneControl().isRender(false);
            boolean b = scene.getTerrainLayers().removeLayerWithName(layerName);
            sScene.smSceneWc.getSceneControl().isRender(true);
            promise.resolve(b);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置场景地形图层是否可见
     *
     * @param promise
     */
    @ReactMethod
    public void setTerrainLayerListVisible(String name, boolean value, Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getTerrainLayers().getCount() > 0) {
                scene.getTerrainLayers().get(name).setVisible(value);
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置场景图层是否可见
     *
     * @param promise
     */
    @ReactMethod
    public void setVisible(String name, boolean value, Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getLayers().getCount() > 0) {
                scene.getLayers().get(name).setVisible(value);
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置场景图层是否可选择
     *
     * @param promise
     */
    @ReactMethod
    public void setSelectable(String name, boolean value, Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getLayers().getCount() > 0) {
                scene.getLayers().get(name).setSelectable(value);
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置场景所有图层是否可选择
     *
     * @param promise
     */
    @ReactMethod
    public void setAllLayersSelection( boolean value, Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getLayers().getCount() > 0) {
                for (int i = 0; i < scene.getLayers().getCount(); i++) {
                    scene.getLayers().get(i).setSelectable(value);
                }
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 搜索关键字显示位置相关信息列表
     *
     * @param promise
     */
    @ReactMethod
    public void pointSearch(String name, final Promise promise) {
        try {
            PoiSearchHelper.getInstence().poiSearch(name, new PoiSearchHelper.PoiSearchCallBack() {
                @Override
                public void poiSearchInfos(ArrayList<PoiGsonBean.PoiInfos> poiInfos) {
                    WritableArray arr = Arguments.createArray();
                    for (int i = 0; i < poiInfos.size(); i++) {
                        String pointName = poiInfos.get(i).getName();
                        WritableMap map = Arguments.createMap();
                        map.putString("pointName", pointName);
                        arr.pushMap(map);
                    }
                    if(poiInfos.size()>0){
                        pointList.add(poiInfos);
                    }

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.POINTSEARCH_KEYWORDS, arr);
                }
            });
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 初始化位置搜索
     *
     * @param promise
     */
    @ReactMethod
    public void initPointSearch(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            String dataPath = context.getApplicationContext().getFilesDir().getAbsolutePath();
            PoiSearchHelper.getInstence().init(sceneControl, dataPath);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 传入map，飞到指定位置
     * @param map = {
     *            "x": double,
     *            "y": double,
     *            "pointName": String
     *            }
     * @param promise
     */
    @ReactMethod
    public void toLocationPoint(ReadableMap map,Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            sceneControl.getScene().getTrackingLayer().clear();

            String name = map.getString("pointName");
            double x = map.getDouble("x");
            double y = map.getDouble("y");

            PoiGsonBean.PoiInfos poiInfos= new PoiGsonBean.PoiInfos();
            PoiGsonBean.Location location = new PoiGsonBean.Location();
            location.setX(x);
            location.setY(y);

            poiInfos.setLocation(location);
            poiInfos.setName(name);
            PoiSearchHelper.getInstence().toLocationPoint(poiInfos);
            sceneControl.getScene().refresh();
//            pointList.clear();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 记录起点与终点
     *
     * @param promise
     */
    @ReactMethod
    public void savePoint(int index,String pointType,Promise promise) {
        try {

            int count=pointList.size();
            switch (pointType){
                case "firstPoint":
                    firstPoint=(PoiGsonBean.PoiInfos) pointList.get(count-1).get(index);
                    break;
                case "secondPoint":
                    secondPoint=(PoiGsonBean.PoiInfos) pointList.get(count-1).get(index);
                    break;
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 三维在线路径分析
     *
     * @param promise
     */
    @ReactMethod
    public void navigationLine(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            PoiSearchHelper.getInstence().clearPoint(sceneControl);
            PoiSearchHelper.getInstence().navigationLine(firstPoint,secondPoint,promise);
            pointList.clear();
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    private void showAllFileWithPath(String path ,String fileter, WritableArray resArr){

        File fileManger =  new File(path);
        if (fileManger.exists()) {
            if(fileManger.isDirectory()){
                String  subPath = null;
                File[] mFileList = fileManger.listFiles();
                for (int i = 0; i <mFileList.length ; i++) {
                    subPath =  mFileList[i].getPath();
                    showAllFileWithPath(subPath,fileter,resArr);
                }
            }else {
                try {
                    String[]  arr = path.split("/");
                    if(arr.length != 0) {
                        String fileName = arr[arr.length - 1];
                        String suffix = fileName.substring(fileName.lastIndexOf("."));
                        if (suffix.toUpperCase().equals(fileter.toUpperCase())) {
                            WritableMap map = Arguments.createMap();
                            map.putString("name", fileName);
                            map.putString("path", path);
                            resArr.pushMap(map);
                        }else if(suffix.toUpperCase().equals((fileter+"Online").toUpperCase())){
                            WritableMap map = Arguments.createMap();
                            map.putString("name", fileName);

                            File file = new File(path);
                            FileInputStream fileInputStream = new FileInputStream(file);
                            InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
                            BufferedReader reader = new BufferedReader(inputStreamReader);
                            String url = reader.readLine();
                            reader.close();
                            map.putString("path", url);
                            resArr.pushMap(map);
                        }
                    }
                }catch (Exception e){
                    return;
                }

            }
        }
    }


    /**
            * 地形缓存
     *
             * @param promise
     */
    @ReactMethod
    public void setImageCacheName(String url ,Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            String path = sceneControl.getScene().getWorkspace().getConnectionInfo().getServer();
            String strDir = path.substring(0, path.lastIndexOf("/")) + "/image";

            String[] res = url.split("/");
            String layerName =  res[res.length-1];

            File file = new File(strDir+'/'+layerName+".sci3dOnline");
            int n = 1;
            while(file.exists()){
                file = new File(strDir+'/'+layerName+  "_"+ n + ".sctOnline");
                n++;
            }

            Boolean bREs = false;
            bREs = file.createNewFile();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false), "UTF-8"));
            writer.write(url);
            writer.close();

            promise.resolve(bREs);

//            WritableArray arr = Arguments.createArray();
//            showAllFileWithPath(strDir,".sci3d",arr);

//            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取影像缓存
     *
     * @param promise
     */
    @ReactMethod
    public void getImageCacheNames(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            String path = sceneControl.getScene().getWorkspace().getConnectionInfo().getServer();
            String strDir = path.substring(0, path.lastIndexOf("/")) + "/image";

            WritableArray arr = Arguments.createArray();
            showAllFileWithPath(strDir,".sci3d",arr);
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 地形缓存
     *
     * @param promise
     */
    @ReactMethod
    public void setTerrainCacheName(String url,Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            String path = sceneControl.getScene().getWorkspace().getConnectionInfo().getServer();

            String strDir = path.substring(0, path.lastIndexOf("/")) + "/terrain";

            String[] res = url.split("/");
            String layerName =  res[res.length-1];

            File file = new File(strDir+'/'+layerName+".sctOnline");
            int n = 1;
            while(file.exists()){
                file = new File(strDir+'/'+layerName+  "_"+ n + ".sctOnline");
                n++;
            }

            Boolean bREs = false;
            bREs = file.createNewFile();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false), "UTF-8"));
            writer.write(url);
            writer.close();

            promise.resolve(bREs);
        } catch (Exception e) {
            promise.reject(e);
        }
    }



    /**
     * 获取地形缓存
     *
     * @param promise
     */
    @ReactMethod
    public void getTerrainCacheNames(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            String path = sceneControl.getScene().getWorkspace().getConnectionInfo().getServer();

            String strDir = path.substring(0, path.lastIndexOf("/")) + "/terrain";

            WritableArray arr = Arguments.createArray();
            showAllFileWithPath(strDir,".sct",arr);

            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取当前sScene中心点 相机位置 场景未打开则返回定位
     * @param promise
     */
    @ReactMethod
    public void getSceneCenter(Promise promise){
        try{
            sScene = SScene.getInstance();
            Camera camera = sScene.smSceneWc.getSceneControl().getScene().getCamera();
            double x = camera.getLongitude();
            double y  = camera.getLatitude();
            WritableMap map = Arguments.createMap();
            map.putDouble("x",x);
            map.putDouble("y",y);
            promise.resolve(map);
        }catch (Exception e){
            LocationManagePlugin.GPSData gpsData = SMCollector.getGPSPoint();
            double x = gpsData.dLongitude;
            double y  = gpsData.dLatitude;
            WritableMap map = Arguments.createMap();
            map.putDouble("x",x);
            map.putDouble("y",y);
            promise.resolve(map);
        }
    }
    /**
     * 获取飞行列表
     *
     * @param promise
     */
    @ReactMethod
    public void getFlyRouteNames(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            String path = sceneControl.getScene().getWorkspace().getConnectionInfo().getServer();
            String result = path.substring(0, path.lastIndexOf("/")) + "/";
            FlyHelper.getInstence().init(sceneControl);
            ArrayList arrayList = FlyHelper.getInstence().getFlyRouteNames(result);
            WritableArray arr = Arguments.createArray();
            for (int i = 0; i < arrayList.size(); i++) {
                String flyName = arrayList.get(i).toString();
                int index = i;
                WritableMap map = Arguments.createMap();
                map.putString("title", flyName);
                map.putInt("index", index);
                arr.pushMap(map);
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取工作空间所在地址
     *
     * @param promise
     */
    @ReactMethod
    public void getWorkspacePath(Promise promise) {
        try {
            sScene = getInstance();
            String path = sScene.smSceneWc.getWorkspace().getConnectionInfo().getServer();
            promise.resolve(path);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置飞行
     *
     * @param promise
     */
    @ReactMethod
    public void setPosition(int index, Promise promise) {
        try {
            FlyHelper.getInstence().setPosition(index);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 开始飞行
     *
     * @param promise
     */
    @ReactMethod
    public void flyStart(Promise promise) {
        try {
            FlyHelper.getInstence().flyPause();
            FlyHelper.getInstence().flyStart();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 暂停飞行
     *
     * @param promise
     */
    @ReactMethod
    public void flyPause(Promise promise) {
        try {
            FlyHelper.getInstence().flyPause();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 暂停或开始飞行
     *
     * @param promise
     */
    @ReactMethod
    public void flyPauseOrStart(Promise promise) {
        try {
            FlyHelper.getInstence().flyPauseOrStart();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 结束飞行
     *
     * @param promise
     */
    @ReactMethod
    public void flyStop(Promise promise) {
        try {
            FlyHelper.getInstence().flyStop();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取飞行进度
     *
     * @param promise
     */
    @ReactMethod
    public void getFlyProgress(Promise promise) {
        try {
            FlyHelper.getInstence().setFlyProgress(new FlyHelper.FlyProgress() {
                @Override
                public void flyProgress(int progress) {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_FLY, progress);
                }
            });
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 场景放大缩小
     *
     * @param promise
     */
    @ReactMethod
    public void zoom(double scale, Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            scene.zoom(scale);
            scene.refresh();
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 指北针
     *
     * @param promise
     */
    @ReactMethod
    public void setHeading(Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            Camera camera = scene.getCamera();
            camera.setHeading(0);
            scene.setCamera(camera);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置sceneControl手势监听
     *
     * @param promise
     */
    @ReactMethod
    public void setListener(Promise promise) {
        try {
            sScene=getInstance();
            sScene.setSceneControl();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置触控器获取对象属性
     *
     * @param promise
     */
    @ReactMethod
    public void getAttribute(Promise promise) {
        try {
            sScene = getInstance();
            sScene.startTouchAttribute();
            sScene.callBackttribute();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置绕点飞行监听
     * 获取绕点飞行的屏幕坐标
     *
     * @param promise
     */
    @ReactMethod
    public void getFlyPoint(Promise promise) {
        try {
            sScene = getInstance();
            sScene.startShowCirclePoint();
            LabelHelper.getInstence().setCircleFlyCallBack(new LabelHelper.CircleFlyCallBack() {
                @Override
                public void circleFly(Point pnt) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("pointX", pnt.x);
                    map.putInt("pointY", pnt.y);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_CIRCLEFLY, map);
                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 开始环绕飞行
     *
     * @param promise
     */
    @ReactMethod
    public void setCircleFly(Promise promise) {
        try {
            sScene = getInstance();
            LabelHelper.getInstence().circleFly();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 停止环绕飞行
     *
     * @param promise
     */
    @ReactMethod
    public void stopCircleFly(Promise promise) {
        try {
            sScene = getInstance();
            sScene.smSceneWc.getSceneControl().getScene().flyCircle(new GeoPoint3D(1,1,1),0);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除飞行点
     *
     * @param promise
     */
    @ReactMethod
    public void clearCirclePoint(Promise promise) {
        try {
            sScene = getInstance();
            LabelHelper.getInstence().clearCirclePoint();
            sScene.smSceneWc.getSceneControl().setAction(Action3D.PANSELECT3D);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除选择对象
     */
    @ReactMethod
    public void clearSelection(Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            int count = scene.getLayers().getCount();
            for (int i = 0; i < count; i++) {
                scene.getLayers().get(i).getSelection().clear();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 切换手势监听
     */
    @ReactMethod
    public void checkoutListener(String listenEvent,Promise promise) {
        sScene=getInstance();
        try {
            switch (listenEvent){
                //切换到对象属性监听
                case "startTouchAttribute":
                    sScene.startTouchAttribute();
                    sScene.startShowCirclePoint();
                    break;
                //切换到量算监听
                case "startMeasure":
                    sScene.startMeasure();
                    sScene.endShowCirclePoint();
                    break;
                //切换到标注操作
                case "startLabelOperate":
                    sScene.startLabelOperate();
                    sScene.endShowCirclePoint();
                    break;
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 标注点绘线
     */
    @ReactMethod
    public void startDrawLine(Promise promise) {
        try {
            LabelHelper.getInstence().startDrawLine();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 标注点绘面
     */
    @ReactMethod
    public void startDrawArea(Promise promise) {
        try {
            LabelHelper.getInstence().startDrawArea();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 标注撤销
     */
    @ReactMethod
    public void symbolback(Promise promise) {
        try {
            LabelHelper.getInstence().back();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭所有标注
     */
    @ReactMethod
    public void closeAllLabel(Promise promise) {
        try {
            sScene = getInstance();
            LabelHelper.getInstence().clearAllLabel();
            sScene.smSceneWc.getSceneControl().getScene().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 清除所有标注
     */
    @ReactMethod
    public void clearAllLabel(Promise promise) {
        try {
            LabelHelper.getInstence().reSet();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除当前编辑下的所有标注
     */
    @ReactMethod
    public void clearcurrentLabel(Promise promise) {
        try {
            LabelHelper.getInstence().clearTrackingLayer();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 保存所有标注
     */
    @ReactMethod
    public void save(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            LabelHelper.getInstence().save();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 标注绘制文本
     */
    @ReactMethod
    public void startDrawText(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            LabelHelper.getInstence().startDrawText();
            LabelHelper.getInstence().setDrawTextListener(new LabelHelper.DrawTextListener() {
                @Override
                public void OnclickPoint(Point3D pnt) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("pointX", pnt.getX());
                    map.putDouble("pointY", pnt.getY());
                    map.putDouble("pointZ", pnt.getZ());
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_SYMBOL, map);
                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 标注添加文本
     */
    @ReactMethod
    public void addGeoText(double x, double y,double z, String text, Promise promise) {
        try {
            Point3D point3D=new Point3D(x,y,z);
            LabelHelper.getInstence().addGeoText(point3D, text);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 标注兴趣点
     */
    @ReactMethod
    public void startDrawFavorite(final String text,Promise promise) {
        try {
            LabelHelper.getInstence().startDrawFavorite();//SSCENE_FAVORITE
            LabelHelper.getInstence().setDrawFavoriteListener(new LabelHelper.DrawFavoriteListener() {
                @Override
                public void OnclickPoint(Point pnt) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("pointX", pnt.x);
                    map.putInt("pointY", pnt.y);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_FAVORITE, map);
                    LabelHelper.getInstence().setFavoriteText(text);
                }
            });
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指北角度
     */
    @ReactMethod
    public void getcompass( Promise promise) {
        try {
            sScene = getInstance();
            if(sScene.smSceneWc.getSceneControl()==null){
                promise.resolve(0);
            }else{
                Scene scene=sScene.smSceneWc.getSceneControl().getScene();
                double heading=scene.getCamera().getHeading();
                promise.resolve(heading);
            }
        } catch (Exception e) {
            promise.resolve(0);
        }
    }

    /**
     * 三维量算分析
     *
     * @param promise
     */
    @ReactMethod
    public void setMeasureLineAnalyst(Promise promise) {
        try {
            AnalysisHelper.getInstence().setMeasureDisCallBack(new AnalysisHelper.DistanceCallBack() {
                @Override
                public void distanceResult(WritableMap distance) {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ANALYST_MEASURELINE, distance);
                }
            }).startMeasureAnalysis();
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 三维面积分析
     *
     * @param promise
     */
    @ReactMethod
    public void setMeasureSquareAnalyst(Promise promise) {
        try {
            AnalysisHelper.getInstence().setMeasureAreaCallBack(new AnalysisHelper.AreaCallBack() {
                @Override
                public void areaResult(WritableMap area) {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.ANALYST_MEASURESQUARE, area);
                }

            }).startSureArea();
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭所有分析
     *
     * @param promise
     */
    @ReactMethod
    public void closeAnalysis(Promise promise) {
        try {
            sScene=getInstance();
            AnalysisHelper.getInstence().closeAnalysis();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移除当前工作空间的KML图层
     */
    @ReactMethod
    public void removeKMLOfWorkcspace(Promise promise) {
        try {
            LabelHelper.getInstence().closePage();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注属性列表
     */
    @ReactMethod
    public void getLableAttributeList(Promise promise) {
        try {
            sScene=getInstance();
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();

            if( scene.getLayers().indexOf("NodeAnimation") == -1){
                promise.resolve(null);
            }else {
                Layer3D layer3D=scene.getLayers().get("NodeAnimation");
                Feature3Ds feature3Ds=layer3D.getFeatures();
                int count =feature3Ds.getCount();
                WritableArray array=Arguments.createArray();
                for (int i = 0; i <count ; i++) {
                    Feature3D feature3D= (Feature3D) feature3Ds.get(i);
                    WritableMap map=Arguments.createMap();
                    Point3D p3d = feature3D.getGeometry().getInnerPoint3D();
                    map.putString("description",feature3D.getDescription());
                    map.putInt("id",feature3D.getID());
                    map.putString("name",feature3D.getName());
                    array.pushMap(map);
                }
                promise.resolve(array);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取设置相关信息
     */
    @ReactMethod
    public void getSetting(Promise promise) {
        try {
            sScene=getInstance();
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();
            WritableMap map=Arguments.createMap();
            map.putString("sceneNmae",scene.getName());
            map.putDouble("heading",scene.getCamera().getHeading());
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *
     *
     * @param data
     * @param promise
     */
    @ReactMethod
    public void import3DWorkspace(ReadableMap data,Boolean bPrivate, Promise promise) {
        try {
            sScene = getInstance();
            Map params = data.toHashMap();
            params.put("type",data.getInt("type")+"");
            if(sScene.smSceneWc==null){
                sScene.smSceneWc = new SMSceneWC();
            }
            boolean result = sScene.smSceneWc.import3DWorkspaceInfo(params,bPrivate);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *
     *
     * @param name
     * @param promise
     */
    @ReactMethod
    public void openScence(String name,Boolean bPrivate, Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
            boolean result=false;
            if(!SceneViewManager.getResultOfInitScene()){
                promise.resolve(result);
                return;
            }
            if(sceneControl!=null){
                result=sScene.smSceneWc.openScenceName(name,sceneControl,bPrivate);
            }
            if(result){
                defaultCamera=sceneControl.getScene().getCamera();
            }
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *
     *
     * @param
     * @param promise
     */
    @ReactMethod
    public void is3DWorkspace(ReadableMap data, Promise promise) {
        try {
            sScene = getInstance();
            Map params = data.toHashMap();
            params.put("type",data.getInt("type")+"");
            if(sScene.smSceneWc==null){
                sScene.smSceneWc = new SMSceneWC();
            }
            boolean result=sScene.smSceneWc.is3DWorkspaceInfo(params);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *
     *
     * @param
     * @param promise
     */
    @ReactMethod
    public void setCustomerDirectory(String path, Promise promise) {
        try {
            sScene = getInstance();
            sScene.smSceneWc.setCustomerDirectory(path);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *
     *
     * @param
     * @param promise
     */
    @ReactMethod
    public void export3DScenceName(String strScenceName, String strDesFolder,Boolean bPrivate, Promise promise) {
        try {
            sScene = getInstance();
            sScene.smSceneWc.export3DScenceName(strScenceName,strDesFolder,bPrivate);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *
     *
     * @param
     * @param promise
     */
    @ReactMethod
    public void resetCamera( Promise promise) {
        try {
            sScene = getInstance();
            if(defaultCamera!=null){
                sScene.smSceneWc.getSceneControl().getScene().setCamera(defaultCamera);
                promise.resolve(true);
            }else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }



    /**
     *
     */
    @ReactMethod
    public void flyToFeatureById(int id,Promise promise) {
        try {
            sScene=getInstance();
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();
            if(!scene.getLayers().get("NodeAnimation").getName().equals("NodeAnimation")) {
                promise.resolve(false);
            }else {
                Layer3D layer3D=scene.getLayers().get("NodeAnimation");
                Feature3D feature3D= (Feature3D) layer3D.getFeatures().get(id);
                if(feature3D==null){
                    promise.resolve(false);
                }else {
                    Point3D point3D=feature3D.getGeometry().getInnerPoint3D();
                    Camera camera=new Camera(point3D.getX(),point3D.getY(),point3D.getZ());
                    scene.flyToCamera(camera,AltitudeMode.ABSOLUTE.value(),false);
                    promise.resolve(true);
                }
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     *
     *
     * @param
     * @param promise
     */
    @ReactMethod
    public void setNavigationControlVisible(Boolean value,Promise promise) {
        try {
            sScene = getInstance();
            sScene.smSceneWc.getSceneControl().setNavigationControlVisible(value);
            promise.resolve(false);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *
     *
     * @param
     * @param promise
     */
    @ReactMethod
    public void setAction(String action,Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
            switch (action){
                case "CREATELINE3D":
                    sceneControl.setAction(Action3D.CREATELINE3D);
                    break;
                case "CREATEPOINT3D":
                    sceneControl.setAction(Action3D.CREATEPOINT3D);
                    break;
                case "CREATEPOLYGON3D":
                    sceneControl.setAction(Action3D.CREATEPOLYGON3D);
                    break;
                case "CREATEPOLYLINE3D":
                    sceneControl.setAction(Action3D.CREATEPOLYLINE3D);
                    break;
                case "MEASUREAREA3D":
                    sceneControl.setAction(Action3D.MEASUREAREA3D);
                    break;
                case "MEASUREDISTANCE3D":
                    sceneControl.setAction(Action3D.MEASUREDISTANCE3D);
                    break;
                case "NULL":
                    sceneControl.setAction(Action3D.NULL);
                    break;
                case "PAN3D":
                    sceneControl.setAction(Action3D.PAN3D);
                    break;
                case "PANSELECT3D":
                    sceneControl.setAction(Action3D.PANSELECT3D);
                    break;
            }
            sceneControl.getScene().refresh();
            promise.resolve(false);
        } catch (Exception e) {
            promise.reject(e);
        }
    }



    /**
     *
     *根据name获取图层属性
     * @param
     * @param promise
     */
    @ReactMethod
    public void getAttributeByName(String name,Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
            Layer3D layer3D=sceneControl.getScene().getLayers().get(name);
            if(layer3D==null){
                promise.resolve(null);
            }else {
                Map<String, String> attributeMap= TouchUtil.getAllAttribute(layer3D,sceneControl);
                WritableMap map = Arguments.createMap();
                for (Map.Entry<String, String> entry : attributeMap.entrySet()) {
                    map.putString(entry.getKey(), entry.getValue());
                }
                promise.resolve(map);
            }

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加飞行站点
     */
    @ReactMethod
    public void saveCurrentRoutStop(Promise promise) {
        try {
            FlyHelper.getInstence().saveCurrentRouteStop();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 记录站点并飞行
     */
    @ReactMethod
    public void saveRoutStop(Promise promise) {
        try {
            FlyHelper.getInstence().saveRoutStop();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 停止站飞行
     */
    @ReactMethod
    public void pauseRoutStop(Promise promise) {
        try {
            FlyHelper.getInstence().routStopPasue();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除所有站点
     */
    @ReactMethod
    public void clearRoutStops(Promise promise) {
        try {
            FlyHelper.getInstence().clearRoutStops();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取所有站点
     */
    @ReactMethod
    public void getRoutStops(Promise promise) {
        try {
            ReadableArray array=FlyHelper.getInstence().getStopList();
            promise.resolve(array);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移除站点
     */
    @ReactMethod
    public void removeByName(String name,Promise promise) {
        try {
            FlyHelper.getInstence().removeStop(name);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /*************************           三维裁剪相关开始           ***************************/

//    /**
//     * cross裁剪
//     * @param posMap 全double
//     * {
//     *  posX:"",    //中心点x坐标
//     *  posY:"",    //中心点y坐标
//     *  posZ:"",    //中心点z坐标
//     *  width:"",   //平面宽
//     *  height:"",  //平面高
//     *  extrudeDistance:"" 拉伸高度
//     *  rotX:"",    //x旋转值
//     *  rotY:"",    //y旋转值
//     *  rotZ:"",    //z旋转值
//     * }
//     */
//    @ReactMethod
//    public void clipSenceCross(ReadableMap posMap, Promise promise){
//        try{
//            sScene = SScene.getInstance();
//            Layer3Ds layer3Ds = sScene.smSceneWc.getSceneControl().getScene().getLayers();
//
//            Point3D position = new Point3D();
//            position.setX(posMap.getDouble("posX"));
//             position.setY(posMap.getDouble("posY"));
//            position.setZ(posMap.getDouble("posZ"));
//
//            Point2D dimension = new Point2D();
//            dimension.setX(posMap.getDouble("width"));
//            dimension.setY(posMap.getDouble("height"));
//
//            for(int i = 0; i < layer3Ds.getCount(); i++){
//                Layer3D layer3D = layer3Ds.get(i);
//                layer3D.setCustomClipCross(position,dimension,posMap.getDouble("rotX"),posMap.getDouble("rotY"),posMap.getDouble("rotZ"),posMap.getDouble("extrudeDistance"));
//            }
//            promise.resolve(true);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//    }

    /**
     * box裁剪
     * @param posMap 全double
     * {
     *   startX:"",    //起点x坐标
     *   startY:"",    //起点y坐标
     *   endX:"",   //终点x坐标
     *   endY:"",  //终点y坐标
     *   layers:[],  //参加裁剪的图层
     *   clipInner:boolean 裁剪位置 true 裁剪内部 false 裁剪外部
     *   ************************可选参数 携带了以下参数可以不用传起点 终点坐标***************
     *   width:"", //底面长
     *   length:"", //底面宽
     *   height:"", //高度
     *   X:"",  //中心点坐标
     *   Y:"",
     *   Z:"",
     *   zRot:"", //z旋转
     *   lineColor:""，//裁剪线颜色
     *   ********************************************************************
     * }
     *
     * @param promise
     */
    @ReactMethod
    public void clipByBox(ReadableMap posMap , Promise promise){
        try{
            WritableMap returnMap = Arguments.createMap();
            boolean useCook = false;
            double zRot = 0;
            if(posMap.hasKey("width")){
                useCook = true;
                zRot = posMap.getDouble("zRot");
            }
            sScene = SScene.getInstance();
            Layer3Ds layer3Ds = sScene.smSceneWc.getSceneControl().getScene().getLayers();

            Point3D centerPoint;
            double width;
            double length;
            double height;
            double x,y,z;
            GeoBox box = new GeoBox();
            Size2D size2D = new Size2D();

            if(!useCook){
                Point point = new Point();
                Point point1 = new Point();

                DisplayMetrics dm = new DisplayMetrics();
                mReactContext.getCurrentActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
                double density = dm.density;

                point.set((int)(posMap.getInt("startX") * density),(int)(posMap.getInt("startY") * density));
                point1.set((int)(posMap.getInt("endX") * density),(int)( posMap.getInt("endY") * density));


                Point3D startPoint = sScene.smSceneWc.getSceneControl().getScene().pixelToGlobe(point,PixelToGlobeMode.TERRAINANDMODEL);
                Point3D endPoint = sScene.smSceneWc.getSceneControl().getScene().pixelToGlobe(point1,PixelToGlobeMode.TERRAINANDMODEL);

                x = (startPoint.getX() + endPoint.getX())/2;
                y = (startPoint.getY() + endPoint.getY())/2;
                z = (startPoint.getZ() + endPoint.getZ())/2;

                //经纬度差值转距离 单位米
                double R = 6371393;
                width = Math.abs((endPoint.getX() - startPoint.getX()) * Math.PI * R * Math.cos((endPoint.getY() + startPoint.getY()) / 2 *Math.PI / 180) /180);
                length = Math.abs((endPoint.getY() - startPoint.getY()) * Math.PI *R / 180);
                height = Math.abs(startPoint.getZ() - endPoint.getZ());
                //确保最小裁剪宽度为1
                if(width < 1.0){
                    width = 1.0;
                }
                if(length <= 1.0){
                    length = 1.0;
                }
                if(height <= 1.0){
                    height = 1.0;
                }
            }else{
                x = posMap.getDouble("X");
                y = posMap.getDouble("Y");
                z = posMap.getDouble("Z");

                width = posMap.getDouble("width");
                length = posMap.getDouble("length");
                height = posMap.getDouble("height");

            }
            centerPoint = new Point3D(x,y,z);

            size2D.setWidth(width);
            size2D.setHeight(length);

            box.setPosition(centerPoint);
            box.setBottomSize(size2D);
            box.setHeight(height);

            BoxClipPart part;
            boolean clipInner = posMap.getBoolean("clipInner");
            if(clipInner){
                part = BoxClipPart.CLIP_INNER;
            }else {
                part = BoxClipPart.CLIP_OUTER;
            }

            boolean needFilter = true;
            ReadableArray layers = posMap.getArray("layers");

            if(layers.size() == 0 && !posMap.getBoolean("isCliped")){
                needFilter = false;
            }
            if(needFilter){
                ReadableMap map;
                for(int i = 0; i < layer3Ds.getCount(); i++){
                    Layer3D layer3D = layer3Ds.get(i);
                    layer3D.clearCustomClipPlane();
                    for (int j = 0; j < layers.size(); j++){
                        map = layers.getMap(j);
                        if(map.getBoolean("selected") && map.getString("name").equals(layer3D.getName())){
                            layer3D.clipByBox(box,part);
                        }
                    }
                }
            }else{
                for(int i = 0; i < layer3Ds.getCount(); i++){
                    Layer3D layer3D = layer3Ds.get(i);
                    layer3D.clearCustomClipPlane();
                    layer3D.clipByBox(box,part);
                }
            }
            sScene.smSceneWc.getSceneControl().getScene().refresh();
            returnMap.putDouble("width",width);
            returnMap.putDouble("height",height);
            returnMap.putDouble("length",length);
            returnMap.putDouble("zRot",zRot);
            returnMap.putDouble("X",x);
            returnMap.putDouble("Y",y);
            returnMap.putDouble("Z",z);
            returnMap.putBoolean("clipInner",clipInner);
            promise.resolve(returnMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }
//
//    /**
//     *    平面裁剪
//     * @param pointMap 三个点坐标对象 全double
//     * {
//     *     x1:"",
//     *     y1:"",
//     *     z1:"",
//     *     x2:"",
//     *     y2:"",
//     *     z2:"",
//     *     x3:"",
//     *     y3:"",
//     *     z3:"",
//     * }
//     * @param promise
//     */
//    @ReactMethod
//    public void clipSencePlane(ReadableMap pointMap, Promise promise){
//        try{
//            sScene = SScene.getInstance();
//            Layer3Ds layer3Ds = sScene.smSceneWc.getSceneControl().getScene().getLayers();
//
//
//            Point3D p1 = new Point3D();
//            Point3D p2 = new Point3D();
//            Point3D p3 = new Point3D();
//
//            p1.setX(pointMap.getDouble("x1"));
//            p1.setY(pointMap.getDouble("y1"));
//            p1.setZ(pointMap.getDouble("z1"));
//            p2.setX(pointMap.getDouble("x2"));
//            p2.setY(pointMap.getDouble("y2"));
//            p2.setZ(pointMap.getDouble("z2"));
//            p3.setX(pointMap.getDouble("x3"));
//            p3.setY(pointMap.getDouble("y3"));
//            p3.setZ(pointMap.getDouble("z3"));
//
//            for(int i = 0; i < layer3Ds.getCount(); i++){
//                Layer3D layer3D = layer3Ds.get(i);
//                layer3D.setCustomClipPlane(p1,p2,p3);
//            }
//
//            promise.resolve(true);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//
//    }

    @ReactMethod
    public void clipSenceClear(Promise promise){
        try{
            sScene = SScene.getInstance();
            Layer3Ds layer3Ds = sScene.smSceneWc.getSceneControl().getScene().getLayers();
            for(int i = 0; i < layer3Ds.getCount(); i++){
                Layer3D layer3D = layer3Ds.get(i);
                layer3D.clearCustomClipPlane();
            }
            sScene.smSceneWc.getSceneControl().getScene().refresh();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
    /*************************           三维裁剪相关结束           ***************************/

    /**
     * 根据点刷新距离测量和面积测量结果
     */
    @ReactMethod
    public void displayDistanceOrArea(ReadableArray pointArray, Promise promise) {
        try {


            Point3Ds point3Ds=new Point3Ds();
            for (int i=0;i<pointArray.size();i++){
                ReadableMap map=pointArray.getMap(i);
                Point3D point3D=new Point3D(map.getDouble("x"),map.getDouble("y"),map.getDouble("z"));
                point3Ds.add(point3D);
            }
            sScene = SScene.getInstance();
            sScene.smSceneWc.getSceneControl().setAction(sScene.smSceneWc.getSceneControl().getAction());
            sScene.smSceneWc.getSceneControl().displayDistanceOrArea(point3Ds);

        } catch (Exception e) {
            promise.reject(e);
        }
    }
    /**
     * 关闭工作空间及地图控件
     */
    @ReactMethod
    public void closeWorkspace(Promise promise) {
        try {
            LabelHelper.getInstence().closePage();
            getCurrentActivity().runOnUiThread(new DisposeThread(promise));
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭工作空间及地图控件
     */
    @ReactMethod
    public void saveWorkspace(Promise promise) {
        try {
            sScene=getInstance();
            sScene.smSceneWc.getWorkspace().save();
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    class DisposeThread implements Runnable {

        private Promise promise;

        public DisposeThread(Promise promise) {
            this.promise = promise;
        }

        @Override
        public void run() {
            try {
                sScene = getInstance();
                Workspace workspace = sScene.smSceneWc.getSceneControl().getScene().getWorkspace();
                sScene.smSceneWc.getSceneControl().getScene().close();
                if (workspace != null) {
                    workspace.close();
                }
                defaultCamera=null;
                sScene.smSceneWc.setWorkspace(null);
                promise.resolve(true);
            } catch (Exception e) {
                promise.resolve(e);
            }
        }
    }


    /************************************** 导航模块 START ****************************************/


    Workspace mWorkspace;

    /**
     * 打开三维导航工作空间及地图
     * @param promise
     */
    @ReactMethod
    public void open3DNavigationMap(Promise promise){
        try {
            sScene = getInstance();

            mWorkspace = new Workspace();

            WorkspaceConnectionInfo m_info = new WorkspaceConnectionInfo();
            m_info.setServer(android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString() + "/SuperMap/Demos/3DNaviDemo/凯德Mall/凯德Mall.sxwu");
            m_info.setType(WorkspaceType.SXWU);
            mWorkspace.open(m_info);

            sScene.smSceneWc.getSceneControl().setNavigationControlVisible(true);

            sScene.smSceneWc.getSceneControl().sceneControlInitedComplete(new SceneControl.SceneControlInitedCallBackListenner() {

                @Override
                public void onSuccess(String arg0) {
                    // TODO Auto-generated method stub
//                    mNavigation3D = sScene.smSceneWc.getSceneControl().getNavigation();

                    Scene mScene = sScene.smSceneWc.getSceneControl().getScene();
                    mScene.setWorkspace(mWorkspace);

                    // 打开工作空间中地图的第2幅地图
                    String mapName = mWorkspace.getScenes().get(0);
                    mScene.open(mapName);
                }
            });

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /************************************** 导航模块 END ****************************************/

    /**
     * 获取工作空间文件里的所有场景xml
     */
    @ReactMethod
    public void getSceneXMLfromWorkspace(String serverUrl, Promise promise) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Workspace ws = new Workspace();
                    WorkspaceConnectionInfo workspaceConnectionInfo = new WorkspaceConnectionInfo();
                    workspaceConnectionInfo.setServer(serverUrl);
                    String tempStr = serverUrl.toLowerCase();
                    if(tempStr.endsWith(".smwu")){
                        workspaceConnectionInfo.setType(WorkspaceType.SMWU);
                    } else if(tempStr.endsWith(".sxwu")) {
                        workspaceConnectionInfo.setType(WorkspaceType.SXWU);
                    } else if(tempStr.endsWith(".smw")) {
                        workspaceConnectionInfo.setType(WorkspaceType.SMW);
                    } else if(tempStr.endsWith(".sxw")) {
                        workspaceConnectionInfo.setType(WorkspaceType.SXW);
                    }

                    WritableArray scenes = Arguments.createArray();

                    if(ws.open(workspaceConnectionInfo)){
                        for(int i = 0; i < ws.getScenes().getCount(); i++) {
                            WritableMap scene = Arguments.createMap();
                            scene.putString("name", ws.getScenes().get(i));
                            scene.putString("xml", ws.getScenes().getSceneXML(i));
                            scenes.pushMap(scene);
                        }
                    }

                    ws.close();
                    ws.dispose();
                    promise.resolve(scenes);
                } catch (Exception e) {
                    promise.reject(e);
                }
            }
        }).start();
    }
}