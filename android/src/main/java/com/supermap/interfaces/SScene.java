package com.supermap.interfaces;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.Map3DEventConst;
import com.supermap.data.Workspace;
import com.supermap.map3D.PoiSearchHelper;
import com.supermap.map3D.toolKit.PoiGsonBean;
import com.supermap.mapping.MeasureListener;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;
import com.supermap.smNative.SMSceneWC;

import java.util.ArrayList;
import java.util.Map;

public class SScene extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SScene";
    private static SScene sScene;
    private static ReactApplicationContext context;
    private static MeasureListener mMeasureListener;
    private SMSceneWC smSceneWc;
    ReactContext mReactContext;
    public SScene(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext=context;
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
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();

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
    public  void getMapList(Promise promise){
        try {
            sScene = getInstance();
            int count =sScene.smSceneWc.getWorkspace().getScenes().getCount();
            WritableArray arr = Arguments.createArray();
            if (count > 0) {
                for (int i = 0; i <count ; i++) {
                    String name=sScene.smSceneWc.getWorkspace().getScenes().get(i);
                    WritableMap map = Arguments.createMap();
                    map.putString("name", name);
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取当前场景图层列表
     *
     * @param promise
     */
    @ReactMethod
    public  void getLayerList(Promise promise){
        try {
            sScene = getInstance();
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getLayers().getCount() > 0) {
                for (int i = 0; i <scene.getLayers().getCount() ; i++) {
                    String name=scene.getLayers().get(i).getName();
                    boolean visible=scene.getLayers().get(i).isVisible();
                    boolean selectable=scene.getLayers().get(i).isSelectable();
                    WritableMap map = Arguments.createMap();
                    map.putString("name", name);
                    map.putBoolean("visible", visible);
                    map.putBoolean("selectable", selectable);
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置场景图层是否可见
     *
     * @param promise
     */
    @ReactMethod
    public  void setVisible(String name,boolean value,Promise promise){
        try {
            sScene = getInstance();
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getLayers().getCount() > 0) {
                scene.getLayers().get(name).setVisible(value);
            }
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置场景图层是否可选择
     *
     * @param promise
     */
    @ReactMethod
    public  void setSelectable(String name,boolean value,Promise promise){
        try {
            sScene = getInstance();
            Scene scene=sScene.smSceneWc.getSceneControl().getScene();
            WritableArray arr = Arguments.createArray();
            if (scene.getLayers().getCount() > 0) {
                scene.getLayers().get(name).setSelectable(value);
            }
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     *搜索关键字显示有关信息
     * @param promise
     */
    @ReactMethod
    public  void pointSearch(String name, final Promise promise){
        try {

             PoiSearchHelper.getInstence().poiSearch(name, new PoiSearchHelper.PoiSearchCallBack() {
                 @Override
                 public void poiSearchInfos(ArrayList<PoiGsonBean.PoiInfos> poiInfos) {
                     WritableArray arr = Arguments.createArray();
                     for (int i = 0; i <poiInfos.size() ; i++) {
                          String pointName =poiInfos.get(i).getName();
                         WritableMap map = Arguments.createMap();
                         map.putString("pointName", pointName);
                         arr.pushMap(map);
                     }
                     mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(Map3DEventConst.POINTSEARCH_KEYWORDS, arr);
                 }
             });
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     *初始化位置搜索
     * @param promise
     */
    @ReactMethod
    public  void pointSearch(Promise promise){
        try {
            sScene = getInstance();
            SceneControl sceneControl=sScene.smSceneWc.getSceneControl();
            String dataPath=getReactApplicationContext().getFilesDir().getAbsolutePath();
            PoiSearchHelper.getInstence().init(sceneControl,dataPath);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }



    /**
     * 关闭工作空间及地图控件
     *
     * @param promise
     */
    @ReactMethod
    public void closeWorkspace(Promise promise) {
        try {
            getCurrentActivity().runOnUiThread(new SScene.DisposeThread(promise));
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
                if(workspace!=null){
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
