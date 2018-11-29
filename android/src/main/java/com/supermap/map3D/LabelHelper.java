package com.supermap.map3D;

import android.content.Context;
import android.graphics.Point;
import android.os.Handler;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.ScaleAnimation;
import android.widget.ImageView;
import android.widget.RelativeLayout;


import com.supermap.data.AltitudeMode;
import com.supermap.data.Color;
import com.supermap.data.GeoLine3D;
import com.supermap.data.GeoPlacemark;
import com.supermap.data.GeoPoint3D;
import com.supermap.data.GeoRegion3D;
import com.supermap.data.GeoStyle3D;
import com.supermap.data.Point3D;
import com.supermap.data.Point3Ds;
import com.supermap.realspace.Action3D;
import com.supermap.realspace.Feature3D;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3DType;
import com.supermap.realspace.PixelToGlobeMode;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.Tracking3DEvent;
import com.supermap.map3D.toolKit.Utils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by zym on 2018/11/12.
 */

public class LabelHelper {

    private static LabelHelper instance = null;
    private static Object object = new Object();

    public static LabelHelper getInstence() {
        if (instance == null) {
            //添加锁，防止多线程被重复创建
            synchronized (object) {
                instance = new LabelHelper();
            }
        }
        return instance;
    }

    private Context context;
    private static SceneControl mSceneControl;
    // 定义一个全局变量 存储Point3D
    private ArrayList<Point3D> myPoint3DArrayList;
    // 声明一个全局的节点动画轨迹对象
    private GeoLine3D geoline3d = null;
    //    private boolean isDrawLine,isDrawArea,isPoint;
    private boolean isEdit;
    private EnumLabelOperate labelOperate;
    //保存到kml路径
    private String kmlPath = "", kmlName = "";
    //文本点击回调
    private DrawTextListener drawTextListener;
    //兴趣点回调
    private DrawFavoriteListener drawFavoriteListener;
    //环绕点回调
    private CircleFlyCallBack circleFlyCallBack;
    //文本缓存列表
    private List<String> geoTextStrList;
    //兴趣点feature3d
    private Feature3D favoriteFeature3D;
    //绕点选择frature3d
    private Feature3D circleFeature3D;
    // 长按时添加一个动画
    private ImageView favoriteAnimImageView;
    private Animation animationImageView;
    //绕点飞行添加点动画view
    private ImageView circleAnimImageView;

    private Layer3D favoriteLayer3d, mLayer3d;


    /**
     * 初始化
     *
     * @param context
     * @param control
     * @param path
     * @return
     */
    public LabelHelper initSceneControl(Context context, final SceneControl control, String path, String kmlName) {
        this.context = context;
        this.mSceneControl = control;
        this.kmlPath = path;
        this.kmlName = kmlName;

        myPoint3DArrayList = new ArrayList<>();
        geoTextStrList = new ArrayList<>();

        addKML();
        reSet();

        return this;
    }

    /**
     * 添加监听
     */
    private void addTrackingListener() {
        mSceneControl.setAction(Action3D.CREATEPOINT3D);
    }

    /**
     * 设置属性动画图片
     *
     * @param favoriteAnimImageView
     */
    public void setFavoriteAnimImageView(ImageView favoriteAnimImageView) {
        this.favoriteAnimImageView = favoriteAnimImageView;
        animationImageView = new ScaleAnimation(0.0f, 1.5f, 0.0f, 1.5f, Animation.RELATIVE_TO_SELF, 0.5f,
                Animation.RELATIVE_TO_SELF, 0.5f);
        animationImageView.setDuration(300);
    }

    /**
     * 设置属性动画图片
     *
     * @param circleAnimImageView
     */
    public void setCircleAnimImageView(ImageView circleAnimImageView) {
        this.circleAnimImageView = circleAnimImageView;
        animationImageView = new ScaleAnimation(0.0f, 1.5f, 0.0f, 1.5f, Animation.RELATIVE_TO_SELF, 0.5f,
                Animation.RELATIVE_TO_SELF, 0.5f);
        animationImageView.setDuration(300);
    }


    /**
     * 是否被编辑
     *
     * @return
     */
    public boolean idEdit() {
        return isEdit;
    }

    /**
     * 设置文本位置点击回调
     *
     * @param drawTextListener
     */
    public void setDrawTextListener(DrawTextListener drawTextListener) {
        this.drawTextListener = drawTextListener;
    }

    /**
     * 设置兴趣点位置回调
     *
     * @param drawFavoriteListener
     */
    public void setDrawFavoriteListener(DrawFavoriteListener drawFavoriteListener) {
        this.drawFavoriteListener = drawFavoriteListener;
    }

    /**
     * 设置环绕点位置回调
     * @param circleFlyCallBack
     */
    public void setCircleFlyCallBack(CircleFlyCallBack circleFlyCallBack){
        this.circleFlyCallBack=circleFlyCallBack;
    }

    /**
     * 开始绘制面积
     */
    public void startDrawArea() {
        labelOperate = EnumLabelOperate.DRAWAREA;
        myPoint3DArrayList.clear();
    }

    /**
     * 开始绘制文本
     */
    public void startDrawText() {
        reSet();
        labelOperate = EnumLabelOperate.DRAWTEXT;
    }

    /**
     * 开始绘制线段
     */
    public void startDrawLine() {
        labelOperate = EnumLabelOperate.DRAWLINE;
        myPoint3DArrayList.clear();
    }

    /**
     * 开始绘制点
     */
    public void startDrawPoint() {
        labelOperate = EnumLabelOperate.DRAWPOINT;
        myPoint3DArrayList.clear();
    }

    /**
     * 开始绘制兴趣点
     */
    public void startDrawFavorite() {
        reSet();
        labelOperate = EnumLabelOperate.DRAWFAVORITE;

    }

    /**
     * 返回
     */
    public void back() {
        if (labelOperate == EnumLabelOperate.DRAWFAVORITE) {
            favoriteCancel();
            return;
        }
        if (myPoint3DArrayList.size() > 0) {
            isEdit = true;
        } else {
            isEdit = false;
            return;
        }

        myPoint3DArrayList.remove(myPoint3DArrayList.size() - 1);

        show();
    }

    /**
     * 清除所有标注
     */
    public void clearAllLabel() {
        mSceneControl.getScene().getLayers().removeLayerWithName("NodeAnimation");
        reSet();
        if (deleteSingleFile(kmlPath + kmlName)) {
            mLayer3d = null;
            addKML();
        }
        //清空后无法保存成kml文件，考虑用删除kml文件的方式
        //layer3d.getFeatures().toKMLFile(kmlPath);
    }


    /**
     * 保存
     */
    public void save() {
        if (!isEdit) {
            return;
        }
        final Layer3D layer3d = mSceneControl.getScene().getLayers().get("NodeAnimation");

        switch (labelOperate) {
            case DRAWPOINT:
                for (Point3D point3D : myPoint3DArrayList) {
                    GeoStyle3D geoPoint3dStyle = new GeoStyle3D();
                    geoPoint3dStyle.setFillForeColor((new Color(255, 255, 0)));
                    geoPoint3dStyle.setAltitudeMode(AltitudeMode.ABSOLUTE);
                    final GeoPoint3D geoPoint3D = new GeoPoint3D(point3D);
                    geoPoint3D.setStyle3D(geoPoint3dStyle);
                    layer3d.getFeatures().add(geoPoint3D);
                }
                break;
            case DRAWLINE:
                //保存线
                layer3d.getFeatures().add(geoline3d);
            case DRAWAREA:
                GeoRegion3D geoRegion3D = getRegion(myPoint3DArrayList);
                if (geoRegion3D != null) {
                    layer3d.getFeatures().add(geoRegion3D);
                }

                break;
            case DRAWTEXT:
                for (int index = 0; index < myPoint3DArrayList.size(); index++) {
                    Point3D point3D = myPoint3DArrayList.get(index);
                    GeoPlacemark geoPlacemark = getGeoText3D(point3D,geoTextStrList.get(index));
                    layer3d.getFeatures().add(geoPlacemark);

                }
                break;
            case DRAWFAVORITE:
                if (favoriteFeature3D == null) {
                    return;
                }
                layer3d.getFeatures().add(favoriteFeature3D);
                Layer3D favoriteLayer3d = mSceneControl.getScene().getLayers().get("Favorite");
                favoriteLayer3d.getFeatures().remove(favoriteFeature3D);
                favoriteFeature3D = null;

                break;


        }
        //保存
        layer3d.getFeatures().toKMLFile(kmlPath + kmlName);
        mSceneControl.getScene().getTrackingLayer().clear();
        myPoint3DArrayList.clear();
        geoTextStrList.clear();
        isEdit = false;
        favoriteCancel();
    }

    /**
     * 添加文本标注
     *
     * @param point
     * @param text
     */
    public void addGeoText(Point3D point, String text) {

        GeoPlacemark geoText3D = getGeoText3D(point, text);
        mSceneControl.getScene().getTrackingLayer().add(geoText3D, "text");
        myPoint3DArrayList.add(point);
        geoTextStrList.add(text);
        isEdit = true;

    }

    /**
     * 点击弹出环绕点
     *
     * @param event
     */
    public void showCirclePoint(MotionEvent event) {

        double x = event.getX() - 28.1;
        double y = event.getY() - 0.5;
        if (x < 0) {
            x = 0;
        }
        if (y < 0) {
            y = 0;
        }
        final Point pnt = new Point();
        pnt.set((int) x, (int) y);

//        mSceneControl.setAction(Action3D.PAN3D);
        if (circleAnimImageView != null) {
            // 添加一个动画
            circleAnimImageView.setVisibility(View.VISIBLE);
            circleAnimImageView.startAnimation(animationImageView);
            setLayout(circleAnimImageView, (int) event.getX() - Utils.dp2px(context, 50) / 2,
                    (int) event.getY() - Utils.dp2px(context, 48));

            new Handler().postDelayed(new Runnable() {
                public void run() {
                    circleAnimImageView.setVisibility(View.GONE);
                    callBackCircle(pnt);
                }
            }, 300);
        } else {
            callBackCircle(pnt);
        }
    }

    /**
     * 回调环绕点
     */
    private void callBackCircle(Point pnt) {
        addCirclePoint(pnt);
        if (circleFlyCallBack != null) {
            circleFlyCallBack.circleFly(pnt);
        }
    }

    /**
     * 添加环绕飞行的点
     *
     * @param point
     */
    public void addCirclePoint(Point point) {

        Layer3D favoriteLayer3d = mSceneControl.getScene().getLayers().get("Favorite");
        Point3D pnt3d = mSceneControl.getScene().pixelToGlobe(point, PixelToGlobeMode.TERRAINANDMODEL);


        final GeoStyle3D pointStyle3D = new GeoStyle3D();
        GeoPoint3D geoPoint = new GeoPoint3D(pnt3d);
        String dataPath = context.getApplicationContext().getFilesDir().getAbsolutePath();
//        context.getResources().getDrawable(R.drawable.icon_green);
        // 兴趣点点出的情况，当前Feature3D对象为mFavorite_Feature3D
        String markfilePath = dataPath + "/config/Resource/" + "icon_red.png";
        pointStyle3D.setMarkerFile(markfilePath);
        pointStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
        geoPoint.setStyle3D(pointStyle3D);
        GeoPlacemark geoPlacemark = new GeoPlacemark("", geoPoint);
        if (circleFeature3D == null) {
            circleFeature3D = favoriteLayer3d.getFeatures().add(geoPlacemark);
        } else {
            circleFeature3D.setGeometry(geoPlacemark);
        }
    }

    /**
     * 清除环绕飞行的点
     */
    public void clearCirclePoint() {
        if (circleFeature3D == null) {
            return;
        }
        Layer3D favoriteLayer3d = mSceneControl.getScene().getLayers().get("Favorite");
        favoriteLayer3d.getFeatures().remove(circleFeature3D);
        circleFeature3D=null;
    }

    /**
     * 环绕飞行
     */
    public void circleFly() {

        if (circleFeature3D == null) {
            return;
        }
        GeoPlacemark geo = (GeoPlacemark) circleFeature3D.getGeometry();
        GeoPoint3D gp = (GeoPoint3D) geo.getGeometry();
        double x = gp.getX();
        double y = gp.getY();
        double z = gp.getZ();
        GeoPoint3D geoPoint3D = new GeoPoint3D(x, y, z + 100);
        mSceneControl.getScene().flyCircle(geoPoint3D, 2);
    }


    /**
     * 回调兴趣点
     *
     * @param pnt3d
     */
    private void callBackFavorite(Point3D pnt3d,Point pnt) {
        addFavoriteText(pnt3d, "");
        // 根据手指点击之后微调屏幕坐标
        if (drawFavoriteListener != null) {
            drawFavoriteListener.OnclickPoint(pnt);
        }
    }

    /**
     * 点击弹出兴趣点
     *
     * @param pnt3d 地图上显示图标的位置
     */
    private void showFavorite(final Point3D pnt3d) {
        final Point pnt=mSceneControl.getScene().globeToPixel(pnt3d);
        if (favoriteAnimImageView != null) {
            // 添加一个动画
            favoriteAnimImageView.setVisibility(View.VISIBLE);
            favoriteAnimImageView.startAnimation(animationImageView);
//            setLayout(favoriteAnimImageView, pnt.x - Utils.dp2px(context, 50) / 2,pnt.y - Utils.dp2px(context, 48));
            setLayout(favoriteAnimImageView, pnt.x ,pnt.y - Utils.dp2px(context, 48));

            new Handler().postDelayed(new Runnable() {
                public void run() {
                    favoriteAnimImageView.setVisibility(View.GONE);
                    callBackFavorite(pnt3d,pnt);
                }
            }, 300);
        } else {
            callBackFavorite(pnt3d,pnt);
        }
    }

    /**
     * 添加兴趣点标注
     *
     * @param pnt3d
     * @param text
     */
    private void addFavoriteText(Point3D pnt3d, String text) {

        Layer3D favoriteLayer3d = mSceneControl.getScene().getLayers().get("Favorite");
//        Point3D pnt3d = mSceneControl.getScene().pixelToGlobe(point, PixelToGlobeMode.TERRAINANDMODEL);


        final GeoStyle3D pointStyle3D = new GeoStyle3D();
        GeoPoint3D geoPoint = new GeoPoint3D(pnt3d);
        String dataPath = context.getApplicationContext().getFilesDir().getAbsolutePath();
//        context.getResources().getDrawable(R.drawable.icon_green);
        // 兴趣点点出的情况，当前Feature3D对象为mFavorite_Feature3D
        String markfilePath = dataPath + "/config/Resource/" + "icon_green.png";
        pointStyle3D.setMarkerFile(markfilePath);
        pointStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
        geoPoint.setStyle3D(pointStyle3D);
        GeoPlacemark geoPlacemark = new GeoPlacemark(text, geoPoint);
        if (favoriteFeature3D == null) {
            favoriteFeature3D = favoriteLayer3d.getFeatures().add(geoPlacemark);
        } else {
            favoriteFeature3D.setGeometry(geoPlacemark);
        }

        isEdit = true;
    }

    /**
     * 添加兴趣点标注
     *
     * @param text
     */
    public void setFavoriteText(String text){
        if(favoriteFeature3D==null){
            return;
        }
        GeoPlacemark geoPlacemark = (GeoPlacemark) favoriteFeature3D.getGeometry();
        geoPlacemark.setName(text);
        favoriteFeature3D.setGeometry(geoPlacemark);

    }

    /**
     * 取消兴趣点
     */
    public void favoriteCancel() {
        if (favoriteFeature3D == null) {
            return;
        }
        Layer3D favoriteLayer3d = mSceneControl.getScene().getLayers().get("Favorite");
        favoriteLayer3d.getFeatures().remove(favoriteFeature3D);
        favoriteFeature3D = null;
        isEdit = false;
    }


    /**
     * 保存兴趣点
     */
    public void saveFavoritePoint() {
        if (favoriteFeature3D == null) {
            return;
        }
        Layer3D layer3d = mSceneControl.getScene().getLayers().get("NodeAnimation");
        layer3d.getFeatures().add(favoriteFeature3D);
        //保存
        layer3d.getFeatures().toKMLFile(kmlPath + kmlName);
        Layer3D favoriteLayer3d = mSceneControl.getScene().getLayers().get("Favorite");
        favoriteLayer3d.getFeatures().remove(favoriteFeature3D);
        favoriteFeature3D = null;
        reSet();
    }

    /**
     * 清除跟踪层数据
     */
    public void clearTrackingLayer() {
        mSceneControl.getScene().getTrackingLayer().clear();
//        mSceneControl.getScene().getLayers().get("Favorite").getFeatures().clear();
        myPoint3DArrayList.clear();
        geoTextStrList.clear();
        isEdit = false;
    }

    /**
     * 重置数据
     */
    public void reSet() {
        mSceneControl.getScene().getTrackingLayer().clear();
        labelOperate = EnumLabelOperate.NULL;
        myPoint3DArrayList.clear();
        geoTextStrList.clear();
        isEdit = false;
        favoriteCancel();
    }


    /**
     * 结束页面时调用
     */
    public void closePage(){
        reSet();
        mSceneControl.getScene().getLayers().removeLayerWithName("NodeAnimation");
        mLayer3d=null;
        mSceneControl.getScene().getLayers().removeLayerWithName("Favorite");
        favoriteLayer3d=null;
        circleFeature3D=null;
    }

    /**
     * @author：Supermap
     * @注释 ：创建本地KML图层，并且添加KML图层
     */
    private void addKML() {

//        Layer3D mLayer3d = mSceneControl.getScene().getLayers().get("NodeAnimation");
        if (mLayer3d == null) {
            makeFilePath(kmlPath, kmlName);
            mLayer3d = mSceneControl.getScene().getLayers().addLayerWith(kmlPath + kmlName, Layer3DType.KML, true, "NodeAnimation");
        }
//        Layer3D favoriteLayer3d = mSceneControl.getScene().getLayers().get("Favorite");
        if (favoriteLayer3d == null) {
            makeFilePath(kmlPath, "Favorite.mkl");
            favoriteLayer3d = mSceneControl.getScene().getLayers().addLayerWith(kmlPath + "Favorite.mkl", Layer3DType.KML, true, "Favorite");
        }
    }


    /**
     * 标注操作
     */
    public void labelOperate(Tracking3DEvent event) {
//    public void labelOperate(MotionEvent event){

        if (labelOperate == EnumLabelOperate.NULL) {
            return;
        }

        // 根据手指点击之后微调屏幕坐标
//        double x = event.getX() - 28.1;
//        double y = event.getY() - 0.5;
//        if (x < 0) {
//            x = 0;
//        }
//        if (y < 0) {
//            y = 0;
//        }
//        final android.graphics.Point pnt = new android.graphics.Point();
//        pnt.set((int) x, (int) y);
        //直接返回的三维的点会卡死，暂时用回之前的二维转三维的点
        Point3D pnt3d = new Point3D(event.getX(), event.getY(), event.getZ());
//        Point3D pnt3d = mSceneControl.getScene().pixelToGlobe(pnt, PixelToGlobeMode.TERRAINANDMODEL);


        if (labelOperate == EnumLabelOperate.DRAWTEXT) {
            if (drawTextListener != null) {
                drawTextListener.OnclickPoint(pnt3d);
            }
            return;
        } else if (labelOperate == EnumLabelOperate.DRAWFAVORITE) {
            //弹出兴趣点
            showFavorite(pnt3d);
            return;
        }
        myPoint3DArrayList.add(pnt3d);
        isEdit = true;
        show();
    }


    private void show() {

        favoriteCancel();
        mSceneControl.getScene().getTrackingLayer().clear();
        int count = myPoint3DArrayList.size();
        if (count == 0) {
            return;
        }
        Point3D[] points;
        switch (labelOperate) {
            case DRAWPOINT:
                for (Point3D point3D : myPoint3DArrayList) {
                    GeoStyle3D geoPoint3dStyle = new GeoStyle3D();
                    geoPoint3dStyle.setMarkerColor((new Color(255, 255, 0)));
                    geoPoint3dStyle.setAltitudeMode(AltitudeMode.ABSOLUTE);
                    final GeoPoint3D geoPoint3D = new GeoPoint3D(point3D);
                    geoPoint3D.setStyle3D(geoPoint3dStyle);
                    mSceneControl.getScene().getTrackingLayer().add(geoPoint3D, "point");
                }
                return;
            case DRAWLINE:
                points = new Point3D[count];
                for (int i = 0; i < count; i++) {
                    points[i] = myPoint3DArrayList.get(i);
                }
                drawLineByPoints(points);

                break;
            case DRAWAREA:
                GeoRegion3D geoRegion3D = getRegion(myPoint3DArrayList);
                if (geoRegion3D != null) {
                    mSceneControl.getScene().getTrackingLayer().add(geoRegion3D, "georegion");
                }
                break;
            case DRAWTEXT:
                for (int position = 0; position < myPoint3DArrayList.size(); position++) {
                    GeoPlacemark geoText3D = getGeoText3D(myPoint3DArrayList.get(position), geoTextStrList.get(position));
                    mSceneControl.getScene().getTrackingLayer().add(geoText3D, "text");
                }
                break;
            case NULL:
                break;
        }
    }

    /**
     * 获取GeoText3D
     *
     * @param point3D
     * @param text
     */
    private GeoPlacemark getGeoText3D(Point3D point3D, String text) {
        GeoStyle3D pointStyle3D = new GeoStyle3D();
        GeoPoint3D geoPoint = new GeoPoint3D(point3D);
        pointStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
        geoPoint.setStyle3D(pointStyle3D);
        GeoPlacemark GeoPlacemark = new GeoPlacemark(text, geoPoint);

        return GeoPlacemark;
    }

    /**
     * 根据点画线
     *
     * @param points
     */
    private void drawLineByPoints(Point3D[] points) {
        if (points.length == 0) {
            return;
        }
        Point3Ds point3ds = new Point3Ds(points);
        if (point3ds.getCount() > 1) {
            GeoStyle3D lineStyle3D = new GeoStyle3D();
            lineStyle3D.setLineColor(new Color(255, 255, 0));
            lineStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
            lineStyle3D.setLineWidth(5);
            geoline3d = new GeoLine3D(point3ds);
            geoline3d.setStyle3D(lineStyle3D);
            mSceneControl.getScene().getTrackingLayer().add(geoline3d, "geoline");
        }
    }

    /**
     * 绘制面
     *
     * @param point3DArrayList
     */
    private GeoRegion3D getRegion(ArrayList<Point3D> point3DArrayList) {
        if (point3DArrayList.size() < 3) {
            return null;
        }
        int count = myPoint3DArrayList.size();

        Point3D[] points = new Point3D[count];
        for (int i = 0; i < count; i++) {
            points[i] = myPoint3DArrayList.get(i);
        }

        Point3Ds point3Ds = new Point3Ds(points);
        GeoRegion3D geoRegion3D = null;
        if (point3Ds.getCount() >= 3) {
            geoRegion3D = new GeoRegion3D(point3Ds);
            GeoStyle3D regionStyle3D = new GeoStyle3D();
            regionStyle3D.setLineColor(new Color(255, 255, 0));
            regionStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
            regionStyle3D.setLineWidth(5);

            geoRegion3D.setStyle3D(regionStyle3D);
        }
        return geoRegion3D;
    }


    /**
     * @author：Supermap
     * @注释 ：生成文件
     */
    private File makeFilePath(String filePath, String fileName) {
        File file = null;
        makeRootDirectory(filePath);
        try {
            file = new File(filePath + "/" + fileName);
            if (!file.exists()) {
                file.createNewFile();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return file;
    }

    /**
     * @author：Supermap
     * @注释 ：生成文件夹
     */
    private void makeRootDirectory(String filePath) {
        File file = null;
        try {
            file = new File(filePath);
            if (!file.exists()) {
                file.mkdirs();
            }
        } catch (Exception e) {
            Log.i("error:", e + "");
        }

    }

    /**
     * 删除单个文件
     *
     * @param filePath$Name 要删除的文件的文件名
     * @return 单个文件删除成功返回true，否则返回false
     */
    private boolean deleteSingleFile(String filePath$Name) {
        File file = new File(filePath$Name);
        // 如果文件路径所对应的文件存在，并且是一个文件，则直接删除
        if (file.exists() && file.isFile()) {
            if (file.delete()) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 设置控件所在的位置YY，并且不改变宽高，
     * XY为绝对位置
     */
    private void setLayout(View view, int x, int y) {
        ViewGroup.MarginLayoutParams margin = new ViewGroup.MarginLayoutParams(view.getLayoutParams());
        margin.setMargins(x, y, x + margin.width, y + margin.height);
        //margin.setMargins(x,y, x+100, y+100);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(margin);
        view.setLayoutParams(layoutParams);
    }

    public interface DrawTextListener {
        void OnclickPoint(Point3D pnt);
    }

    public interface DrawFavoriteListener {
        void OnclickPoint(Point pnt);
    }

    public interface CircleFlyCallBack{
        void circleFly(Point pnt);
    }

    public enum EnumLabelOperate {
        /**
         * 空操作
         */
        NULL,
        /**
         * 打点
         */
        DRAWPOINT,
        /**
         * 画线
         */
        DRAWLINE,
        /**
         * 画面
         */
        DRAWAREA,
        /**
         * 文字
         */
        DRAWTEXT,
        /**
         * 兴趣点
         */
        DRAWFAVORITE
    }

}
