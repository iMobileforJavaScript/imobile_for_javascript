package com.supermap.rnsupermap;

import android.view.GestureDetector;
import android.view.MotionEvent;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSSceneControl extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSceneControl";
    protected static Map<String, SceneControl> m_SceneControlList = new HashMap<String, SceneControl>();
    SceneControl m_SceneControl;
    ReactContext mReactContext;
    private static final String LONGPRESS_EVENT = "com.supermap.RN.Mapcontrol.long_press_event";
    private static final String SCROLL_EVENT = "com.supermap.RN.Mapcontrol.scroll_event";

    public JSSceneControl(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    public static SceneControl getObjFromList(String id) {
        return m_SceneControlList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(SceneControl obj) {
        for (Map.Entry entry : m_SceneControlList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_SceneControlList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void getScene(String sceneControlId, Promise promise){
        try{
            m_SceneControl = getObjFromList(sceneControlId);
            Scene scene = m_SceneControl.getScene();
            String sceneId = JSScene.registerId(scene);

            WritableMap map = Arguments.createMap();
            map.putString("sceneId",sceneId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setGestureDetector(String sceneControlId, Promise promise){
        try{
            m_SceneControl = getObjFromList(sceneControlId);
            m_SceneControl.setGestureDetector(new GestureDetector(new GestureDetector.SimpleOnGestureListener(){
                public void onLongPress(MotionEvent event){
                    WritableMap map = Arguments.createMap();
                    map.putInt("x",(int)event.getX());
                    map.putInt("y",(int)event.getY());

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(LONGPRESS_EVENT,map);
                }
                public boolean onScroll(MotionEvent e1, MotionEvent e2,
                                        float distanceX, float distanceY){
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(SCROLL_EVENT,null);
                    return false;
                }
            }));

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

