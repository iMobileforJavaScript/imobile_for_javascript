package com.supermap.interfaces.mapping;

import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.data.GeoStyle;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Workspace;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;

import java.util.HashMap;
import java.util.Map;

public class SMapSuspension extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SMapSuspension";
    private static ReactApplicationContext context;
    public static Map<String, MapView> m_MapWrapViewList = new HashMap<String, MapView>();
    public MapView mapView;
    public MapControl m_mapControl;

    public SMapSuspension(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
    }

    @Override
    public String getName()  {
        return REACT_CLASS;
    }


    /**
     *选择指定mapview
     *
     * @param promise
     */
    @ReactMethod
    public void openMap(String mapid, Promise promise) {
        try {
            Log.e("+++++++++++++++++++","hhhhhhhhhhhhhhhhhhhhh"+mapid);
            mapView = m_MapWrapViewList.get(mapid);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     *打开地图
     *
     * @param promise
     */
    @ReactMethod
    public void openMapByName(String strMapName, ReadableMap mapParam, Promise promise) {
        try {
            Workspace workspace = new Workspace();
            m_mapControl = mapView.getMapControl();
            m_mapControl.getMap().setWorkspace(workspace);
            boolean result = SMap.getInstance().smMapWC.openMapName(strMapName, workspace, mapParam);
            if(result){
                m_mapControl.getMap().open(strMapName);
                m_mapControl.getMap().refresh();
                m_mapControl.getMap().setARRotateByCenterEnable(true);
                m_mapControl.getMap().setAlphaOverlay(true);
//                m_mapControl.setMapOverlay(true);               //设置透明的

//                mapView.addOverlayMap(m_mapControl);

                //设置AR地图模式
//                m_mapControl.getMap().setIsArmap(true);
//                m_mapControl.getMap().setARMapAlpha(0.5f);//透明度
//                m_mapControl.getMap().setARScrollEnable(true);
                m_mapControl.enableRotateTouch(true); //设置是否支持旋转
                m_mapControl.enableSlantTouch(true);  //设置是否支持俯仰

                //设置手势监听器
                m_mapControl.setGestureDetector(new GestureDetector(m_mapControl.getContext(), mGestrueListener));
                m_mapControl.getMap().SetSlantAngle(30);  //不是固定旋转的话 给他一个初始角度值。


            }
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    long startDrawTime = System.currentTimeMillis();
    long endDrawTime = System.currentTimeMillis();
    public static double rotateValueOfARMap = 0.0f;
    public static double elevateValueOfARMap = 0.0f;
    private GestureDetector.OnGestureListener mGestrueListener = new GestureDetector.OnGestureListener() {
        @Override
        public boolean onDown(MotionEvent e) { return true; }

        @Override
        public void onShowPress(MotionEvent e) { }

        @Override
        public boolean onSingleTapUp(MotionEvent e) { return true; }

        @Override
        public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {

            unlockMap();
            if (e2.getPointerCount() > 1){
                return true;
            }
            endDrawTime = System.currentTimeMillis();
            if(endDrawTime - startDrawTime > 20)
            {
                if (Math.abs(distanceX) > Math.abs(distanceY)) {
                    rotateValueOfARMap += distanceX/3  ;
                } else {
                    elevateValueOfARMap += distanceY * 5;

                    m_mapControl.getMap().setARRotateCenter(m_mapControl.getMap().getCenter());
                    m_mapControl.getMap().setARScrollValue((float) elevateValueOfARMap);
                }
                m_mapControl.getMap().setAngle(m_mapControl.getMap().getAngle() + distanceX/3);
            }

            startDrawTime = endDrawTime;
            m_mapControl.getMap().refresh();
            return true;
        }
        @Override
        public void onLongPress(MotionEvent e) {

        }
        @Override
        public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
            return false;
        }
    };

    //地图滑动
    private void unlockMap() {
        Rectangle2D viewBounds = m_mapControl.getMap().getViewBounds();
        m_mapControl.getMap().setLockedViewBounds(viewBounds);
        m_mapControl.getMap().setViewBoundsLocked(false);
    }

    /**
     *关闭地图
     *
     * @param promise
     */
    @ReactMethod
    public void closeMap(Promise promise){
        try {
            if(mapView!=null){
                mapView.getMapControl().getMap().close();
            }
            m_MapWrapViewList.clear();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

}
