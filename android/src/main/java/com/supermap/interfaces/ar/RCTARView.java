package com.supermap.interfaces.ar;

import android.app.ProgressDialog;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.supermap.RNUtils.RNLegendView;
import com.supermap.ar.ARRendererInfoUtil;
import com.supermap.ar.ArObject;
import com.supermap.ar.ArViewAdapter;
import com.supermap.ar.GeoObject;
import com.supermap.ar.OnClickArObjectListener;
import com.supermap.ar.Point3D;
import com.supermap.ar.World;
import com.supermap.component.MapARView;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.onlineservices.CoordinateType;
import com.supermap.onlineservices.POIInfo;
import com.supermap.onlineservices.POIQuery;
import com.supermap.onlineservices.POIQueryParameter;
import com.supermap.onlineservices.POIQueryResult;
import com.supermap.plugin.LocationManagePlugin;
import com.supermap.rnsupermap.R;
import com.supermap.smNative.collector.SMCollector;

import java.util.ArrayList;

public class RCTARView extends SimpleViewManager<MapARView> implements OnClickArObjectListener {
    public static final String REACT_CLASS = "RCTARView";
    ThemedReactContext m_ThemedReactContext;
    MapARView m_View;
    private World mWorld;
    POIInfo[] poiInfos;
    Point2Ds point2Ds;
    double locationy, locationx,naviPointx,naviPointy;
    String naviName,naviAddress;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public MapARView createViewInstance(ThemedReactContext reactContext) {
        m_ThemedReactContext = reactContext;
        ARRendererInfoUtil.saveARRendererMode(reactContext, ARRendererInfoUtil.MODE_PROJECTION);

        m_View = new MapARView(reactContext);
        m_View.setDistanceFactor(0.98f);
        m_View.setMaxDistanceToRender(1500);

        // 创建增强现实世界
        mWorld = CustomWorldHelper.generateMyObjects(reactContext);
        m_View.setWorld(mWorld);
        m_View.setPOIOverlapEnable(true);
        m_View.setOnClickArObjectListener(this);
        CustomArViewAdapter customArViewAdapter = new CustomArViewAdapter(reactContext);
        m_View.setArViewAdapter(customArViewAdapter);
//        mWorld.clearWorld();


        return m_View;
    }


    @ReactProp(name = "ARView")
    public void setStyle(MapARView view, ReadableMap style) {
        naviPointx=style.getDouble("x");
        naviPointy=style.getDouble("y");
        naviName=style.getString("name");
        naviAddress=style.getString("address");
        if(style.getBoolean("isNaviPoint")){
            mWorld.clearWorld();
            LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
            Point2D gpsPoint = new Point2D(gpsDat.dLongitude, gpsDat.dLatitude);
            mWorld.setGeoPosition(gpsPoint.getX(), gpsPoint.getY());
            locationx=gpsPoint.getX();
            locationy=gpsPoint.getY();
            createNaviPointCoordPoi(m_ThemedReactContext.getCurrentActivity().getResources().getDisplayMetrics().widthPixels / 2,
                    m_ThemedReactContext.getCurrentActivity().getResources().getDisplayMetrics().heightPixels / 2);
        }else {
            queryPOI(style.getString("name"));
        }
    }


    @Override
    public void onClickArObject(ArrayList<ArObject> arrayList) {
        Log.e("++++++++++", "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    }

    private class CustomArViewAdapter extends ArViewAdapter {
        LayoutInflater inflater;

        public CustomArViewAdapter(Context context) {
            super(context);
            inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        }

        @Override
        public View getView(ArObject arObject, View recycledView, ViewGroup parent) {
            return recycledView;
        }
    }

    private void createNaviPointCoordPoi(int x,int y){
//        Point3D point = m_View.getIntersectionPoint(x, y);
//        if (point != null) {
            GeoObject tempArObject = new GeoObject(System.currentTimeMillis());
            tempArObject.setGeoPosition(naviPointx,naviPointy);
            tempArObject.setName(naviName.replace("/", ""));
            updateImagesByStaticView(tempArObject, naviName, naviAddress, new Point2D(naviPointx,naviPointy));
            mWorld.addArObject(tempArObject);
//        }
    }

    private void createScreenCoordPoi(int x, int y) {
//        Point3D point = m_View.getIntersectionPoint(x, y);
//        if (point != null) {
            for (int i = 0; i < point2Ds.getCount(); i++) {
                GeoObject tempArObject = new GeoObject(System.currentTimeMillis() + i);
                tempArObject.setGeoPosition(point2Ds.getItem(i).getX(),
                        point2Ds.getItem(i).getY());
                tempArObject.setName(i + poiInfos[i].getName().replace("/", ""));
                updateImagesByStaticView(tempArObject, poiInfos[i].getName(), poiInfos[i].getAddress(), point2Ds.getItem(i));
                mWorld.addArObject(tempArObject);
            }
//        }

    }


    private void updateImagesByStaticView(ArObject arObject, String name, String address, Point2D point2D) {
        View view = m_ThemedReactContext.getCurrentActivity().getLayoutInflater().inflate(R.layout.ar_object_view_wrapcontent, null);

        TextView textView = view.findViewById(R.id.tv_name);
        textView.setText(name);

        TextView m_address = view.findViewById(R.id.tv_address);
        m_address.setText(address);

        TextView m_info = view.findViewById(R.id.info);
        m_info.setText(String.valueOf(getDistance(point2D.getY(), point2D.getX(), locationy, locationx) + "米"));


        ImageView iv = (ImageView) view.findViewById(R.id.ai_ar_content);
        iv.setImageDrawable(m_ThemedReactContext.getResources().getDrawable(R.mipmap.address));

        m_View.storeArObjectViewAndUri(view, arObject);
    }

    private static double EARTH_RADIUS = 6378.137;

    private static double rad(double d) {
        return d * Math.PI / 180.0;
    }

    //计算经纬度距离
    public static int getDistance(double lat1, double lng1, double lat2,
                                  double lng2) {
        double radLat1 = rad(lat1);
        double radLat2 = rad(lat2);
        double a = radLat1 - radLat2;
        double b = rad(lng1) - rad(lng2);
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
                + Math.cos(radLat1) * Math.cos(radLat2)
                * Math.pow(Math.sin(b / 2), 2)));
        s = s * EARTH_RADIUS;
        s = Math.round(s * 10000d) / 10000d;
        s = s * 1000;
        return (int) s;
    }

    public void queryPOI(String str) {
        LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
        Point2D gpsPoint = new Point2D(gpsDat.dLongitude, gpsDat.dLatitude);
        mWorld.setGeoPosition(gpsPoint.getX(), gpsPoint.getY());
        locationx=gpsPoint.getX();
        locationy=gpsPoint.getY();
        POIQuery poiQuery = new POIQuery(m_ThemedReactContext);
        POIQueryParameter queryParameter = new POIQueryParameter();
        //			用户申请的钥匙
        queryParameter.setKey("fvV2osxwuZWlY0wJb8FEb2i5");
//			查询的关键字
        queryParameter.setKeywords(str);
        //			在某个范围内查询
        queryParameter.setCity("成都市");

        queryParameter.setPageSize(10);

        queryParameter.setLocation(gpsPoint.getX(), gpsPoint.getY());

        queryParameter.setRadius("1000");

        queryParameter.setCoordinateType(CoordinateType.NAVINFO_AMAP_LONGITUDE_LATITUDE);
//			进行POI查询
        poiQuery.query(queryParameter);
        //			查看POI查询是否成功
        poiQuery.setPOIQueryCallback(new POIQuery.POIQueryCallback() {
            @Override
            public void querySuccess(POIQueryResult queryResult) {
                poiInfos = queryResult.getPOIInfos();
                point2Ds = new Point2Ds();
                for (int i = 0; i < poiInfos.length; i++) {
                    Point2D point2D = poiInfos[i].getLocation();
                    point2Ds.add(point2D);
                }
                createScreenCoordPoi(m_ThemedReactContext.getCurrentActivity().getResources().getDisplayMetrics().widthPixels / 2,
                        m_ThemedReactContext.getCurrentActivity().getResources().getDisplayMetrics().heightPixels / 2);
            }

            @Override
            public void queryFailed(String errInfo) {
            }
        });


    }


}
