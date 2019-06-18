/**
 * @Author: Asort
 * Date:    2019/5/31
 * project: iTablet
 * package: iTablet
 * class:
 * description: ScaleView辅助显示类 返回信息给RN层，由RN层绘制View显示比例尺
 */
package com.supermap.interfaces.utils;

import android.util.DisplayMetrics;
import android.view.WindowManager;

import com.facebook.react.bridge.ReactApplicationContext;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSysType;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapParameterChangedListener;
import com.supermap.mapping.ScaleType;

public class ScaleViewHelper {
    public SMap sMap;
    public Map mMap;
    public  static final double[] SCALES = new double[]{0.0000000021276595744680852,0.0000000042553191489361703,0.0000000085106382978723407,0.000000017021276595744681,0.000000034042553191489363,
    0.000000068085106382978725,0.00000013617021276595745,0.0000002723404255319149,0.0000005446808510638298,0.0000010893617021276596,
    0.0000021787234042553192,0.0000043574468085106384,0.0000087148936170212768,0.000017429787234042554,0.000034859574468085107,
    0.000069719148936170215,0.00013943829787234043,0.00027887659574468086,0.00055775319148936172,0.00105775319148936172,0.00205775319148936172};
    public static final String[] SCALESTEXT = new String[]{"<5米","5米","10米", "20米", "50米", "100米", "200米", "500米", "1千米", "2千米", "5千米", "10千米", "20千米", "25千米", "50千米", "100千米", "200千米", "500千米", "1000千米", "2000千米",">2000千米"};
    public static final String[] SCALESTEXTGlobal = new String[]{"<5m","5m","10m", "20m", "50m", "100m", "200m", "500m", "1km", "2km", "5km", "10km", "20km", "25km", "50km", "100km", "200km", "500km", "1000km", "2000km",">2000km"};
    public static final int[] DISTANCES = new int[]{5,10,20,50,100,200,500,1000,2000,5000,10000,20000,25000,50000,100000,200000,500000,1000000,2000000};
    public int mScaleLevel;
    public String mScaleText;
    public float mScaleWidth;
    public ReactApplicationContext mContext;
    public ScaleType mScaleType;
    public MapParameterChangedListener mapParameterChangedListener;
    public ScaleViewHelper(ReactApplicationContext context){
        this.mScaleType = ScaleType.Global;
        this.mContext = context;
        this.sMap = SMap.getInstance();
        this.mMap = this.sMap.getSmMapWC().getMapControl().getMap();
    }

    public ScaleViewHelper(ReactApplicationContext context, ScaleType scaleType){
        this.mScaleType = scaleType;
        this.mContext = context;
        this.sMap = SMap.getInstance();
        this.mMap = this.sMap.getSmMapWC().getMapControl().getMap();
    }

    public void addScaleChangeListener(MapParameterChangedListener mapParameterChangedListener){
        this.mapParameterChangedListener = mapParameterChangedListener;
        sMap.getSmMapWC().getMapControl().setMapParamChangedListener(mapParameterChangedListener);
    }

    public void removeScaleChangeListener(){
        sMap.getSmMapWC().getMapControl().removeMapParamChangedListener(mapParameterChangedListener);
        this.mapParameterChangedListener = null;
    }

    public int getScaleLevel(){
        double nScale = this.mMap.getScale();
        int nLevel = 0;

        for(int i = 0; i < SCALES.length-1; ++i) {
            if (nScale >= SCALES[i] && nScale < SCALES[i + 1]) {
                nLevel = SCALES.length -1 - i;
                break;
            }
        }

        if (nScale < SCALES[0]) {
            nLevel = 20;
        }else if (nScale > SCALES[SCALES.length - 1]) {
            nLevel = 0;
        }

        return nLevel;
    }

    public double getMapScale() {
        double mScale = 0.0D;
        double dx = 0.0D;
        double dy = 0.0D;
        WindowManager windowManager = mContext.getCurrentActivity().getWindowManager();
        int width = windowManager.getDefaultDisplay().getWidth();
        int height = windowManager.getDefaultDisplay().getHeight();
        Point screenCenter = new Point(width/2,height/2);
        Point point2 = new Point(screenCenter.getX() + 10,screenCenter.getY());

        Point2D mapPos = mMap.pixelToMap(screenCenter);
        Point2D mapPos2 = mMap.pixelToMap(point2);

        Point2Ds points = new Point2Ds();
        points.add(mapPos);
        points.add(mapPos2);

        if(mMap.getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE){
            dx = Math.abs(points.getItem(0).getX() - points.getItem(1).getX());
            dy = Math.abs(points.getItem(0).getY() - points.getItem(1).getY());
        }else {
            dx = Math.abs(points.getItem(0).getX() - points.getItem(1).getX())*111319.489;
            dy = Math.abs(points.getItem(0).getY() - points.getItem(1).getY())*111319.489;
        }
        mScale = Math.sqrt(dx * dx + dy * dy);

        return 10/mScale;
    }

    public String getScaleText(int level) {
        String strText = null;
        if (level >= 0 && level < SCALESTEXT.length) {
          if(mScaleType == ScaleType.Global){
              strText = SCALESTEXTGlobal[level];
          }else if(mScaleType == ScaleType.Chinese){
              strText = SCALESTEXT[level];
          }
        }

        return strText;
    }

    public float getScaleWidth(int level) {
        int nlenth = 0;
        DisplayMetrics dm = new DisplayMetrics();
        mContext.getCurrentActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
        float dpi = dm.density;
        if(level == 0){
            nlenth = 20;
        }else if (level > 19){
            nlenth = 30;
        }else {
            double pixMapScale = this.getMapScale();
            nlenth = DISTANCES[level -1];
            nlenth = (int)(pixMapScale * nlenth + 0.7);
        }
        return nlenth / dpi;
    }
}
