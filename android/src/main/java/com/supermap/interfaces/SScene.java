package com.supermap.interfaces;

import android.graphics.Point;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;

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
import com.supermap.data.GeoPoint3D;
import com.supermap.data.ImageFormatType;
import com.supermap.data.Point3D;
import com.supermap.data.Workspace;
import com.supermap.map3D.AnalysisHelper;
import com.supermap.map3D.FlyHelper;
import com.supermap.map3D.LabelHelper;
import com.supermap.map3D.PoiSearchHelper;
import com.supermap.map3D.toolKit.PoiGsonBean;
import com.supermap.map3D.toolKit.TouchUtil;
import com.supermap.mapping.MeasureListener;
import com.supermap.realspace.Action3D;
import com.supermap.realspace.Camera;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.Tracking3DEvent;
import com.supermap.realspace.Tracking3DListener;
import com.supermap.smNative.SMSceneWC;
import android.os.Looper;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
//import java.util.logging.Handler;

public class SScene extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SScene";
    private static SScene sScene;
    private static ReactApplicationContext context;
    private static MeasureListener mMeasureListener;
    private SMSceneWC smSceneWc;
    ReactContext mReactContext;
    private static SingleTapUpAction singleTapUpAction=SingleTapUpAction.NULL;
    private static LongPressAction longPressAction=LongPressAction.CIRCLEPOINT;
    private TouchUtil.OsgbAttributeCallBack osgbAttributeCallBack;
    private Tracking3DListener tracking3DListener;
    private static gestureListener gestureListener;
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
        Workspace workspace = sScene.smSceneWc.getWorkspace();
        String path = workspace.getConnectionInfo().getServer();
        String result = path.substring(0, path.lastIndexOf("/")) + "/files/";
        final String kmlName = "NodeAnimation.kml";
        sScene=getInstance();
        SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
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
        sScene=getInstance();
        sScene.smSceneWc.getSceneControl().setAction(Action3D.PANSELECT3D);
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
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();

            if (sScene.smSceneWc.getWorkspace().getScenes().getCount() > 0) {
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
            int count = sScene.smSceneWc.getWorkspace().getScenes().getCount();
            WritableArray arr = Arguments.createArray();
            if (count > 0) {
                for (int i = 0; i < count; i++) {
                    String name = sScene.smSceneWc.getWorkspace().getScenes().get(i);
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
                    map.putString("name", name);
                    map.putBoolean("visible", visible);
                    map.putBoolean("selectable", selectable);
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public void changeBaseMap(String oldLayer, String Url, String Layer3DType, String layerName, String imageFormatType, double dpi, Boolean addToHead,Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            if (oldLayer != null) {
                scene.getLayers().removeLayerWithName(oldLayer);
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

    /**
     * 添加地形图层
     *
     * @param promise
     */
    @ReactMethod
    public void addTerrainLayer(String url,String name,Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            scene.getTerrainLayers().clear();
            scene.getTerrainLayers().add(url,name);
            scene.refresh();
            int i=scene.getTerrainLayers().getCount();
            promise.resolve(i);
        } catch (Exception e) {
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
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
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
    public void pointSearch(Promise promise) {
        try {
            sScene = getInstance();
            SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            String dataPath = getReactApplicationContext().getFilesDir().getAbsolutePath();
            PoiSearchHelper.getInstence().init(sceneControl, dataPath);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
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
            String path = sScene.smSceneWc.getWorkspace().getConnectionInfo().getServer();
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
R
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
                    //切换到绕点飞行
                case "startShowCirclePoint":
                    sScene.startShowCirclePoint();
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
    public void startDrawFavorite( Promise promise) {
        try {
            LabelHelper.getInstence().startDrawFavorite();//SSCENE_FAVORITE
            LabelHelper.getInstence().setDrawFavoriteListener(new LabelHelper.DrawFavoriteListener() {
                @Override
                public void OnclickPoint(Point pnt) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("pointX", pnt.x);
                    map.putInt("pointY", pnt.y);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_FAVORITE, map);
                  LabelHelper.getInstence().setFavoriteText("兴趣点");
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
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();
            double heading=scene.getCamera().getHeading();
            promise.resolve(heading);
        } catch (Exception e) {
            promise.reject(e);
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
                public void distanceResult(double distance) {
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
                public void areaResult(double area) {
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
     * 关闭工作空间及地图控件
     */
    @ReactMethod
    public void closeWorkspace(Promise promise) {
        try {
            getCurrentActivity().runOnUiThread(new DisposeThread(promise));
            LabelHelper.getInstence().closePage();
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
                sScene.smSceneWc.setWorkspace(null);
                promise.resolve(true);
            } catch (Exception e) {
                promise.resolve(e);
            }
        }
    }

}
