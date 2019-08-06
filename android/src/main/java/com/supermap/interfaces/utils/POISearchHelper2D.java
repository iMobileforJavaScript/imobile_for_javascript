package com.supermap.interfaces.utils;

import android.graphics.Bitmap;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.facebook.react.bridge.ReactApplicationContext;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.map3D.toolKit.HttpUtils;
import com.supermap.map3D.toolKit.JsonPara;
import com.supermap.map3D.toolKit.PoiGsonBean;
import com.supermap.mapping.CallOut;
import com.supermap.mapping.CalloutAlignment;
import com.supermap.mapping.MapControl;
import com.supermap.rnsupermap.R;

import java.net.URI;
import java.net.URLEncoder;
import java.util.ArrayList;

public class POISearchHelper2D {

    public static POISearchHelper2D instance = null;
    private static Object object = new Object();

    private MapControl m_mapControl;
    private ArrayList<PoiGsonBean.PoiInfos> m_searchResult = new ArrayList<PoiGsonBean.PoiInfos>();
    private CallOut m_callout;
    private ReactApplicationContext m_context;
    private String tagName = "POISEARCH_2D_POINT";

    // POI本地搜索网址
    private String poiSearch = "http://www.supermapol.com/iserver/services/localsearch/rest/searchdatas/China/poiinfos";

    private ArrayList<PoiGsonBean.Location> list = new ArrayList<PoiGsonBean.Location>();



    public static POISearchHelper2D getInstence() {
        if (instance == null) {
            //添加锁，防止多线程调用时被重复创建
            synchronized (object) {
                instance = new POISearchHelper2D();
            }
        }
        return instance;
    }

    public void initMapControl(MapControl mapControl,ReactApplicationContext context){
        m_mapControl = mapControl;
        m_context = context;
    }


    public void poiSearch(String keyWords,final PoiSearchCallBack poiSearchCallBack){
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
                m_searchResult = poiInfos;
                poiSearchCallBack.poiSearchInfos(poiInfos);
            }
        });
    }

    public boolean toLocationPoint(int index){
        boolean needDelete = true;
        PoiGsonBean.PoiInfos curPOI = m_searchResult.get(index);

        Point2D point = new Point2D(curPOI.getLocation().getX(),curPOI.getLocation().getY());
        Point2Ds point2Ds = new Point2Ds();
        point2Ds.add(point);

        PrjCoordSys sourcePrjCoordSys = new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
        CoordSysTransParameter coordSysTransParameter = new CoordSysTransParameter();

        CoordSysTranslator.convert(
                point2Ds,
                sourcePrjCoordSys,
                m_mapControl.getMap().getPrjCoordSys(),
                coordSysTransParameter,
                CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

        final Point2D mapPoint = point2Ds.getItem(0);
        final String name = curPOI.getName();

        if(m_callout == null){
            m_callout = new CallOut(m_context);
            m_callout.setStyle(CalloutAlignment.LEFT_BOTTOM);
            m_callout.setBackground(0,0);
            needDelete = false;
        }
        final boolean finalNeedDelete = needDelete;
        m_context.getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ImageView imageView = new ImageView(m_context);
                imageView.setImageResource(R.drawable.icon_red);
                imageView.setAdjustViewBounds(true);
                imageView.setMaxWidth(60);
                imageView.setMaxHeight(60);

                TextView textView = new TextView(m_context);
                textView.setHeight(60);
                textView.setWidth(180);
                textView.setText(name);

                LinearLayout linearLayout = new LinearLayout(m_context);
                linearLayout.setLayoutParams(new LinearLayout.LayoutParams(240,60));
                linearLayout.addView(imageView);
                linearLayout.addView(textView);

                m_callout.setContentView(linearLayout);
                // 20处理默认callout背景位置偏差
                double x = mapPoint.getX() - 20;
                double y = mapPoint.getY() - 20;
                m_callout.setLocation(x,y);
                if(finalNeedDelete){
                    m_mapControl.getMap().getMapView().removeCallOut(tagName);
                }
                m_mapControl.getMap().getMapView().addCallout(m_callout,tagName);
                m_mapControl.getMap().getMapView().showCallOut();
                if(m_mapControl.getMap().getScale() < 0.000011947150294723098){
                    m_mapControl.getMap().setScale(0.000011947150294723098);
                }
                m_mapControl.getMap().setCenter(mapPoint);
                m_mapControl.getMap().refresh();
            }
        });
        return true;
    }
    public interface PoiSearchCallBack{
        void poiSearchInfos(ArrayList<PoiGsonBean.PoiInfos> poiInfos);
    }
}
