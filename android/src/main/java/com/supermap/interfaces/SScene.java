package com.supermap.interfaces;

import android.view.MotionEvent;
import android.view.View;

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
import com.supermap.containts.EventConst;
import com.supermap.data.ImageFormatType;
import com.supermap.data.Workspace;
import com.supermap.map3D.FlyHelper;
import com.supermap.map3D.PoiSearchHelper;
import com.supermap.map3D.toolKit.PoiGsonBean;
import com.supermap.map3D.toolKit.TouchUtil;
import com.supermap.mapping.MeasureListener;
import com.supermap.realspace.Camera;
import com.supermap.realspace.Layer3DType;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;
import com.supermap.smNative.SMSceneWC;

import java.net.URL;
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
            int count=scene.getLayers().getCount();
            if (scene.getLayers().getCount() > 0) {
                for (int i = 0; i <count; i++) {
                    String name = scene.getLayers().get(i).getName();
                    boolean visible = scene.getLayers().get(i).isVisible();
                    boolean selectable = scene.getLayers().get(i).isSelectable();
                    WritableMap map = Arguments.createMap();
                    map.putString("name", name);
                    map.putBoolean("visible", visible);
                    map.putBoolean("selectable", selectable);
                    if(i == count - 1){
                        map.putBoolean("basemap",true);
                    }
                    arr.pushMap(map);
                }
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public  void  changeBaseMap(String oldLayer, String Url, String Layer3DType,String layerName,String imageFormatType,double dpi, Boolean addToHead){
        sScene = getInstance();
        Scene scene = sScene.smSceneWc.getSceneControl().getScene();
        if(oldLayer!=null){
            scene.getLayers().removeLayerWithName(oldLayer);
        }
        com.supermap.realspace.Layer3DType layer3DType = null;
        com.supermap.data.ImageFormatType imageFormatType1=null;
         switch (Layer3DType){
             case "IMAGEFILE":
                     layer3DType=com.supermap.realspace.Layer3DType.IMAGEFILE;
                 break;
             case "KML":
                 layer3DType=com.supermap.realspace.Layer3DType.KML;
                 break;

             case "l3dBingMaps":
                 layer3DType=com.supermap.realspace.Layer3DType.l3dBingMaps;
                 break;

             case "OSGBFILE":
                 layer3DType=com.supermap.realspace.Layer3DType.OSGBFILE;
                 break;

             case "VECTORFILE":
                 layer3DType=com.supermap.realspace.Layer3DType.VECTORFILE;
                 break;
             case "WMTS":
                 layer3DType=com.supermap.realspace.Layer3DType.WMTS;
                 break;
         }

         switch (imageFormatType){
             case "BMP":
                 imageFormatType1=ImageFormatType.BMP;
                 break;
             case "DXTZ":
                 imageFormatType1=ImageFormatType.DXTZ;
                 break;

             case "GIF":
                 imageFormatType1=ImageFormatType.GIF;
                 break;

             case "JPG":
                 imageFormatType1=ImageFormatType.JPG;
                 break;

             case "JPG_PNG":
                 imageFormatType1=ImageFormatType.JPG_PNG;
                 break;
             case "NONE":
                 imageFormatType1=ImageFormatType.NONE;
                 break;
             case "PNG":
                 imageFormatType1=ImageFormatType.PNG;
                 break;
         }
         if(dpi == Double.parseDouble(null)&&imageFormatType==null){
             scene.getLayers().add(Url,layer3DType,layerName,addToHead);
         }else {
             scene.getLayers().add(Url,layer3DType,layerName,imageFormatType1,dpi,addToHead);
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
                map.putString("flyName", flyName);
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
            Camera camera=scene.getCamera();
            camera.setHeading(0);
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
            final SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            sceneControl.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    switch (event.getAction()) {
                        case (MotionEvent.ACTION_UP):
                            WritableMap map = Arguments.createMap();
                            Map<String, String> attributeMap = TouchUtil.getAttribute(sceneControl, event);
                            for (Map.Entry<String, String> entry : attributeMap.entrySet()) {
                                map.putString(entry.getKey(), entry.getValue());
                            }
                            mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_ATTRIBUTE, map);
                            break;
//                      case(MotionEvent.ACTION_SCROLL):
//                          mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.SSCENE_REMOVE_ATTRIBUTE, false);
//                          break;
                    }
                    return false;
                }
            });
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除对象列表属性
     *
     * @param promise
     */
    @ReactMethod
    public void clearAttribute(Promise promise) {
        try {
            sScene = getInstance();
            Scene scene = sScene.smSceneWc.getSceneControl().getScene();
            int count =scene.getLayers().getCount();
            for (int i = 0; i <count ; i++) {
                scene.getLayers().get(i).getSelection().clear();
            }
          promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 移除触控器
     *
     * @param promise
     */
    @ReactMethod
    public void removeOnTouchListener(Promise promise) {
        try {
            sScene = getInstance();
            final SceneControl sceneControl = sScene.smSceneWc.getSceneControl();
            sceneControl.setOnTouchListener(null);
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
