package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Workspace;
import com.supermap.realspace.Layer3Ds;
import com.supermap.realspace.Scene;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class JSScene extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSScene";
    protected static Map<String, Scene> m_SceneList = new HashMap<String, Scene>();
    Scene m_Scene;

    public JSScene(ReactApplicationContext context) {
        super(context);
    }

    public static Scene getObjFromList(String id) {
        return m_SceneList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Scene obj) {
        for (Map.Entry entry : m_SceneList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_SceneList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void setWorkspace(String sceneControlId, String workspaceId, Promise promise){
        try{
            Workspace workspace = JSWorkspace.getObjById(workspaceId);
            m_Scene = getObjFromList(sceneControlId);
            m_Scene.setWorkspace(workspace);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void open(String sceneControlId, String scene, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            boolean opened = m_Scene.open(scene);

            WritableMap map = Arguments.createMap();
            map.putBoolean("opened",opened);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void open1(String sceneControlId, String iserverUrl,String scene, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            boolean opened = m_Scene.open(iserverUrl,scene);

            WritableMap map = Arguments.createMap();
            map.putBoolean("opened",opened);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void open2(String sceneControlId, String iserverUrl,String scene,String passWord, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            boolean opened = m_Scene.open(iserverUrl,scene,passWord);

            WritableMap map = Arguments.createMap();
            map.putBoolean("opened",opened);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void ensureVisible(String sceneControlId, ReadableMap rectangle2D, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            Rectangle2D rectangle2D1 = JsonUtil.jsonToRectangle(rectangle2D);
            m_Scene.ensureVisible(rectangle2D1);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getWorkspace(String sceneControlId, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            Workspace workspace = m_Scene.getWorkspace();
            String workspaceId = JSWorkspace.registerId(workspace);

            WritableMap map = Arguments.createMap();
            map.putString("workspaceId",workspaceId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getLayer3Ds(String sceneControlId, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            Layer3Ds layer3Ds = m_Scene.getLayers();
            String layer3DId = JSLayer3Ds.registerId(layer3Ds);

            WritableMap map = Arguments.createMap();
            map.putString("layer3dsId",layer3DId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void flyToPoint(String sceneControlId,String point3DId , Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            Layer3Ds layer3Ds = m_Scene.getLayers();
            String layer3DId = JSLayer3Ds.registerId(layer3Ds);

            WritableMap map = Arguments.createMap();
            map.putString("layer3dsId",layer3DId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void refresh(String sceneControlId, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            m_Scene.refresh();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void pan(String sceneControlId,double offsetLongitude ,double offsetLatitude , Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            m_Scene.pan(offsetLongitude,offsetLatitude);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void viewEntire(String sceneControlId, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            m_Scene.viewEntire();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void zoom(String sceneControlId,double ratio, Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            m_Scene.zoom(ratio);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void close(String sceneControlId,Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            m_Scene.close();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String sceneControlId,Promise promise){
        try{
            m_Scene = getObjFromList(sceneControlId);
            m_Scene.dispose();
            Iterator iterator = m_SceneList.keySet().iterator();
            while(iterator.hasNext()){
                Object s = iterator.next();
                m_Scene.equals(s);

                iterator.remove();
            }

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

