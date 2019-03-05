package com.supermap.map3D;



import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.supermap.data.AltitudeMode;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoPlacemark;
import com.supermap.data.GeoPoint3D;
import com.supermap.data.GeoStyle;
import com.supermap.data.GeoStyle3D;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Point3D;
import com.supermap.data.Rectangle2D;
import com.supermap.realspace.Feature3D;
import com.supermap.realspace.Feature3Ds;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.TrackingLayer3D;
import com.supermap.map3D.toolKit.GlobalControlHelper;
import com.supermap.map3D.toolKit.HttpUtils;
import com.supermap.map3D.toolKit.JsonPara;
import com.supermap.map3D.toolKit.PoiGsonBean;




import java.net.URLEncoder;
import java.util.ArrayList;

/**
 * Created by zym on 2018/10/30.
 */

public class PoiSearchHelper {

    private static PoiSearchHelper instance = null;
    private static Object object = new Object();

    public static PoiSearchHelper getInstence() {
        if (instance == null) {
            //添加锁，防止多线程调用时被重复创建
            synchronized (object) {
                instance = new PoiSearchHelper();
            }
        }
        return instance;
    }

    //导航搜索网址
    String NavigationUrl = "http://www.supermapol.com/iserver/services/navigation/rest/navigationanalyst/China/pathanalystresults";
    // POI本地搜索网址
    private String poiSearch = "http://www.supermapol.com/iserver/services/localsearch/rest/searchdatas/China/poiinfos";
    //kml地址
    private String currentSceneKMLPath = "/sdcard/SuperMap/initKML/default.kml";
    // 安装包路径
    private String dataPath = null;

    private ArrayList<PoiGsonBean.Location> list = new ArrayList<PoiGsonBean.Location>();


    private SceneControl mSceneControl;
    private Point2Ds point2ds_navigation;


    public PoiSearchHelper init(SceneControl control,String dataPath){
        mSceneControl = control;
        this.dataPath=dataPath;
        point2ds_navigation=new Point2Ds();
        return this;
    }

    public void poiSearch(String keyWords, final PoiSearchCallBack poiSearchCallBack) {
        final String tempURL = poiSearch + ".rjson?keywords=" + URLEncoder.encode(keyWords)
                + "&location=&radius=&leftLocation=&pageSizeNum=10&pageNum=0&Key=tY5A7zRBvPY0fTHDmKkDjjlr";
        HttpUtils.getHttpResponse(tempURL);
        HttpUtils.doHttpUtilsCallBaockListener(new HttpUtils.HttpUtilsCallbackListener() {
            @Override
            public void success(String json) {
                if (json == null) {
                    poiSearchCallBack.poiSearchInfos(null);
                    return;
                }
                ArrayList<PoiGsonBean.PoiInfos> poiInfos = JsonPara.parsePOI(json);
                if (null == poiInfos) {
                    poiSearchCallBack.poiSearchInfos(null);
                    return;
                }
                poiSearchCallBack.poiSearchInfos(poiInfos);
            }
        });
    }

    public void toLocationPoint(PoiGsonBean.PoiInfos poiInfos){
        Point3D point3d = new Point3D(poiInfos.getLocation().getX(), poiInfos.getLocation().getY(),
                1500);
        Point3D point3d2 = new Point3D(poiInfos.getLocation().getX(), poiInfos.getLocation().getY(),
                500);
        Feature3D param = addMarkFile(mSceneControl, poiInfos.getName(), point3d2,
                dataPath, GlobalControlHelper.getCurrentFeature());
        GlobalControlHelper.setCurrentFeature(param);
        mSceneControl.getScene().flyToPoint(point3d);
    }



    // 长按添加地标和poi时添加地标
    public Feature3D addMarkFile(SceneControl sceneControl, String name, Point3D pnt, String datapath,
                                 Feature3D mCurrentFeature3D) {

        GeoStyle3D pointStyle3D = new GeoStyle3D();
        GeoPoint3D geoPoint = new GeoPoint3D(pnt);
        pointStyle3D.setMarkerFile(datapath + "/config/Resource/icon_green.png");
        pointStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
        geoPoint.setStyle3D(pointStyle3D);
        Feature3Ds feature3Ds = null;
        Layer3D layer3d = sceneControl.getScene().getLayers().get("NodeAnimation");
        if (layer3d != null) {
            feature3Ds = layer3d.getFeatures();
        }
        Feature3D feature3D = new Feature3D();
        GeoPlacemark geoPlacemark = new GeoPlacemark(name, geoPoint);
        feature3D.setGeometry(geoPlacemark);

        if (mCurrentFeature3D != null) {
            feature3Ds.remove(mCurrentFeature3D);
            mCurrentFeature3D = null;

        }
        if (feature3Ds != null) {
            mCurrentFeature3D = feature3Ds.add(feature3D);

        }
        return mCurrentFeature3D;

    }


    public void navigationLine(PoiGsonBean.PoiInfos poiInfoStart, PoiGsonBean.PoiInfos poiInfoEnd, final Promise promise){
        final String testNavigationUrl = NavigationUrl
                + ".rjson?pathAnalystParameters=[%7BstartPoint:%7BX:" + poiInfoStart.getLocation().getX()
                + ",y:" + poiInfoStart.getLocation().getY() + "%7D,endPoint:%7Bx:" + poiInfoEnd.getLocation().getX() + ",y:"
                +poiInfoEnd.getLocation().getY()
                + "%7D,passPoints:null,routeType:MINLENGTH%7D]&Key=tY5A7zRBvPY0fTHDmKkDjjlr";

        // 多线程处理http请求和数据解析
        HttpUtils.getHttpResponse(testNavigationUrl);
        HttpUtils.doHttpUtilsCallBaockListener(new HttpUtils.HttpUtilsCallbackListener() {
            @Override
            public void success(String str) {
                String stringNavigation=str;
                String info = stringNavigation.substring(0, 1);
                if(!info.endsWith("{")){
                    if (stringNavigation != null) {
                        String infoo = stringNavigation.substring(1, stringNavigation.length() - 1);
//                        junctionList.clear();
                        list.clear();
                        list=JsonPara.parseNavigation(infoo);
                        doNavigationHandler(mSceneControl, dataPath);
                        promise.resolve(true);
                    }
                }

            }
        });
    }


    // 处理路径导航返回数据构建GeoLine
    public void doNavigationHandler(SceneControl sceneControl, String dataPath) {

        int count = list.size();
        point2ds_navigation.clear();
        for (int i = 0; i < count; i++) {
            point2ds_navigation.add(new Point2D(list.get(i).getX(), list.get(i).getY()));
        }
        GeoLine geoline = new GeoLine(point2ds_navigation);
        GeoStyle geoStyle = new GeoStyle();
        geoStyle.setFillForeColor(new com.supermap.data.Color(255, 255, 255));
        geoStyle.setLineWidth(1);
        geoline.setStyle(geoStyle);
        TrackingLayer3D trackingLayer3D = sceneControl.getScene().getTrackingLayer();
        trackingLayer3D.clear();
        addTrackLayer(sceneControl, dataPath, "起点", list.get(0).getX(), list.get(0).getY());
        addTrackLayerend(sceneControl, dataPath, "终点", list.get(count - 1).getX(), list.get(count - 1).getY());
        sceneControl.getScene().getTrackingLayer().add(geoline, "navigation");
        Rectangle2D rectangle2D = geoline.getBounds();
        sceneControl.getScene().ensureVisible(rectangle2D);
    }

    // 路径导航时的起点 添加TrackLayer；
    public void addTrackLayer(SceneControl sceneControl, String datapath, String name, double x, double y) {

        GeoPoint3D geoPoint3D = new GeoPoint3D(x, y, 0);

        GeoStyle3D pointStyle3D = new GeoStyle3D();

        pointStyle3D.setMarkerFile(datapath + "/config/Resource/icon_start.png");
        pointStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
        geoPoint3D.setStyle3D(pointStyle3D);

        GeoPlacemark geoPlacemark = new GeoPlacemark(name, geoPoint3D);
        sceneControl.getScene().getTrackingLayer().add(geoPlacemark, "poi");

    }

    // 路径导航时的终点 添加TrackLayer；
    public void addTrackLayerend(SceneControl sceneControl, String datapath, String name, double x, double y) {

        GeoPoint3D geoPoint3D = new GeoPoint3D(x, y, 0);

        GeoStyle3D pointStyle3D = new GeoStyle3D();
        // config/Resource/icon_endpoint.png

        pointStyle3D.setMarkerFile(datapath + "/config/Resource/icon_end.png");
        pointStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
        geoPoint3D.setStyle3D(pointStyle3D);

        GeoPlacemark geoPlacemark = new GeoPlacemark(name, geoPoint3D);
        sceneControl.getScene().getTrackingLayer().add(geoPlacemark, "poi");

    }

    public void clearPoint(SceneControl sceneControl){
        Layer3D layer3d = sceneControl.getScene().getLayers().get("NodeAnimation");
        if (layer3d != null) {
            Feature3Ds feature3Ds = layer3d.getFeatures();
            if (GlobalControlHelper.getCurrentFeature()!= null) {
                feature3Ds.remove(GlobalControlHelper.getCurrentFeature());
                GlobalControlHelper.setCurrentFeature(null);
            }
        }
    }


    public interface PoiSearchCallBack{
        void poiSearchInfos(ArrayList<PoiGsonBean.PoiInfos> poiInfos);
    }
}
