package com.supermap.rnsupermap;

import android.content.Context;
import android.widget.ImageView;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.supermap.component.MapWrapView;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.CallOut;
import com.supermap.mapping.CalloutAlignment;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JSMapView extends ReactContextBaseJavaModule {
//    private static MapView mapView = null;
    private static MapWrapView mapView = null;
    private static Map<String,MapView> mapViewList=new HashMap<String,MapView>();
    private static MapControl mapControl = null;
    Context m_Context = null;
//    MapView mapView;
    CallOut m_callout;
    String m_PointName;

    public static final int STARTPOINT = R.drawable.startpoint;
    public static final int DESTPOINT = R.drawable.destpoint;


    @Override
    public String getName(){return "JSMapView";}

    public JSMapView(ReactApplicationContext reactContext){
        super(reactContext);
        m_Context =reactContext.getApplicationContext();
    }

    /**
     * 提供给MapView视图组件用于创建MapView实例的方法。
     * @param reactContext
     * @return
     */
    public static MapWrapView createInstance(ThemedReactContext reactContext){
        mapView = new MapWrapView(reactContext.getBaseContext());
        mapControl = mapView.getMapControl();
        return mapView;
    }

    public static MapWrapView getMapView(){
        return mapView;
    }

    public static MapControl getMapControl(){
        return mapControl;
    }

    public static void setInstance(MapWrapView mMapView){
        mapView = mMapView;
        mapControl = mapView.getMapControl();
        SMap.setInstance(mapControl);
    }

    public void disposeMapControl(){
        getCurrentActivity().runOnUiThread(new DisposeThread());
    }

    class DisposeThread implements Runnable {

        public DisposeThread() {
        }

        @Override
        public void run() {
            if (mapControl != null) {
                mapControl.dispose();
                mapControl = null;
            }
        }
    }

    /**
//     * 在native层注册一个MapView的Id，并返回该ID供JS层调用；
//     * 注册前先判断该MapView是否已经存在，如果存在，返回已经存在的ID，如果不存在，创建新的ID以返回。
//     * @param mapView
//     * @return
//     */
    public static String registerId(MapView mapView){
        for(Map.Entry entry:mapViewList.entrySet()){
            if(mapView.equals(entry.getValue())){
                return (String)entry.getKey();
            }
        }
        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mapViewList.put(id,mapView);
        System.out.print(id);
        return id;
    }

    /**
     * 根据ID获得MapView实例
     * @param id
     * @return
     */
    public static MapView getObjById(String id){
        return mapViewList.get(id);
    }

//    /**
//     * 获取MapControl实例id。
//     * @param promise
//     */
//    @ReactMethod
//    public void getMapControl( Promise promise){
//        try{
//            MapView mapView = mapViewList.get(mapViewId);
//            MapControl mapControl=mapView.getMapControl();
//            String mapControlId=JSMapControl.registerId(mapControl);
//            WritableMap map= Arguments.createMap();
//            map.putString("mapControlId",mapControlId);
//            promise.resolve(map);
//        }catch(Exception e){
//            promise.reject(e);
//        }
//    }

    @ReactMethod
    public void refresh(Promise promise){
        try{
//            mapView = mapViewList.get(mapViewId);
            mapView.refresh();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addPoint(String point2DId,String pointName,Promise promise){
        try{
            int idDrawable = 0;
//            MapView mapView = mapViewList.get(mapViewId);
            com.supermap.mapping.Map map= mapView.getMapControl().getMap();
            Point2D point2D = JSPoint2D.m_Point2DList.get(point2DId);

//            if(pointName.contentEquals("startpoint")){
//                if(R.drawable.startpoint){
//                    idDrawable = R.drawable.startpoint;
//                }
//            }
//            else if(pointName.contentEquals("destpoint")){
//                if(R.drawable.destpoint){
//                    idDrawable = R.drawable.destpoint;
//                }
//            }

            showPointByCallout(mapView,point2D,pointName,idDrawable);

            if (map.getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
                PrjCoordSys srcPrjCoordSys = map.getPrjCoordSys();
                Point2Ds point2Ds = new Point2Ds();
                point2Ds.add(point2D);
                PrjCoordSys desPrjCoordSys = new PrjCoordSys();
                desPrjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                // 转换投影坐标
                CoordSysTranslator.convert(point2Ds, srcPrjCoordSys,
                        desPrjCoordSys, new CoordSysTransParameter(),
                        CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

                point2D = point2Ds.getItem(0);
            }

            JSPoint2D.m_Point2DList.put(point2DId,point2D);

            WritableMap wMap = Arguments.createMap();
            wMap.putString("eth_point2DId",point2DId);

            promise.resolve(wMap);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addCallOut(String callOutId,String pointName,Promise promise){
        try{
//            mapView = mapViewList.get(mapViewId);
            m_callout = JSCallOut.getObjFromList(callOutId);
            m_PointName = pointName;
//            mapView.addCallout(m_callout,pointName);
            getCurrentActivity().runOnUiThread(addCallOutThread);

            promise.resolve(true);
        }catch (Exception e ){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void showCallOut(Promise promise){
        try{
//            mapView = mapViewList.get(mapViewId);
            getCurrentActivity().runOnUiThread(showCallOutThread);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    private void showPointByCallout(MapView mapView, Point2D point, final String pointName,
                                    final int idDrawable) {
        CallOut callOut = new CallOut(getCurrentActivity());
        callOut.setStyle(CalloutAlignment.BOTTOM);
        callOut.setCustomize(true);
        callOut.setLocation(point.getX(), point.getY());
        ImageView imageView = new ImageView(getCurrentActivity());
        imageView.setBackgroundResource(idDrawable);
        callOut.setContentView(imageView);
        m_callout = callOut;
        mapView = mapView;
        m_PointName = pointName;

        getCurrentActivity().runOnUiThread(addCallOutThread);

//        Point2D ptInner = mapView.getMapControl().getMap().getCenter();
//        ImageView imgView = new ImageView(getCurrentActivity());
//        imgView.setImageResource(R.drawable.close);
//
//        m_callout = new CallOut(getCurrentActivity());
//        m_callout.setContentView(imgView);
//
//        m_callout.setStyle(CalloutAlignment.BOTTOM);
//        m_callout.setLocation(ptInner.getX(), ptInner.getY());
//        mapView.removeAllCallOut();
//        getCurrentActivity().runOnUiThread(addCallOutThread);

    }

    Runnable addCallOutThread = new Runnable(){
        @Override
        public void run(){
            if (m_PointName != null && !m_PointName.equals("")) {
                mapView.addCallout(m_callout, m_PointName);
            } else {
                mapView.addCallout(m_callout);
            }

            mapView.showCallOut();
        }
    };


    Runnable showCallOutThread = new Runnable(){
        @Override
        public void run(){
            mapView.showCallOut();
        }
    };
}
