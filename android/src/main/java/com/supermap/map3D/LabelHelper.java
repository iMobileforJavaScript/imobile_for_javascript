package com.supermap.map3D;

import android.content.Context;
import android.graphics.Point;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;

import com.supermap.data.AltitudeMode;
import com.supermap.data.Color;
import com.supermap.data.GeoLine3D;
import com.supermap.data.GeoPlacemark;
import com.supermap.data.GeoPoint3D;
import com.supermap.data.GeoStyle3D;
import com.supermap.data.GeoText3D;
import com.supermap.data.Point3D;
import com.supermap.data.Point3Ds;
import com.supermap.data.TextPart3D;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3DType;
import com.supermap.realspace.PixelToGlobeMode;
import com.supermap.realspace.SceneControl;

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

    private SceneControl mSceneControl;
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
    //文本缓存列表
    private List<String> geoTextStrList;


    /**
     * 初始化
     *
     * @param context
     * @param control
     * @param path
     * @return
     */
    public LabelHelper initSceneControl(Context context, final SceneControl control, String path, String kmlName) {
        this.mSceneControl = control;
        this.kmlPath = path;
        this.kmlName = kmlName;
        GestureDetector gestureDetector = new GestureDetector(context, new gestureListener());
        mSceneControl.setGestureDetector(gestureDetector);
        myPoint3DArrayList = new ArrayList<>();
        geoTextStrList=new ArrayList<>();

        addKML();
        return this;
    }

    /**
     * 设置文本位置点击回调
     * @param drawTextListener
     */
    public void setDrawTextListener(DrawTextListener drawTextListener){
        this.drawTextListener=drawTextListener;
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
     * 返回
     */
    public void back() {
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
        Layer3D layer3d = mSceneControl.getScene().getLayers().get("NodeAnimation");

        switch (labelOperate) {
            case DRAWPOINT:
                for (Point3D point3D : myPoint3DArrayList) {
                    GeoStyle3D geoPoint3dStyle = new GeoStyle3D();
                    geoPoint3dStyle.setFillForeColor((new Color(255, 255, 0)));
                    geoPoint3dStyle.setAltitudeMode(AltitudeMode.ABSOLUTE);
                    GeoPoint3D geoPoint3D = new GeoPoint3D(point3D);
                    geoPoint3D.setStyle3D(geoPoint3dStyle);
                    //保存点
                    layer3d.getFeatures().add(geoPoint3D);
                }
                break;
            case DRAWLINE:
            case DRAWAREA:
                //保存线
                layer3d.getFeatures().add(geoline3d);
                break;
            case DRAWTEXT:
                for (int index = 0; index < myPoint3DArrayList.size(); index++) {
                    Point3D point3D = myPoint3DArrayList.get(index);
                    GeoPlacemark geoPlacemark = new GeoPlacemark(geoTextStrList.get(index), new GeoPoint3D(point3D));
                    layer3d.getFeatures().add(geoPlacemark);
                }
                break;

        }
        //保存
        layer3d.getFeatures().toKMLFile(kmlPath + kmlName);
        reSet();
    }

    /**
     * 添加文本标注
     * @param point
     * @param text
     */
    public void addGeoText(Point point, String text){

        Point3D pnt3d = mSceneControl.getScene().pixelToGlobe(point, PixelToGlobeMode.TERRAINANDMODEL);
        GeoPlacemark geoPlacemark = new GeoPlacemark(text, new GeoPoint3D(pnt3d));
        mSceneControl.getScene().getTrackingLayer().add(geoPlacemark, "text");

        myPoint3DArrayList.add(pnt3d);
        geoTextStrList.add(text);
        isEdit = true;
    }


    /**
     * 重置数据
     */
    private void reSet() {
        mSceneControl.getScene().getTrackingLayer().clear();
        labelOperate = EnumLabelOperate.NULL;
        myPoint3DArrayList.clear();
        geoTextStrList.clear();
        isEdit = false;
    }

    /**
     * @author：Supermap
     * @注释 ：创建本地KML图层，并且添加KML图层
     */
    private void addKML() {

        makeFilePath(kmlPath, kmlName);
        mSceneControl.getScene().getLayers().addLayerWith(kmlPath + kmlName, Layer3DType.KML, true,
                "NodeAnimation");

    }

    // 点击创建路线之后，在点击屏幕 获取路线。
    Point3D pnt3d;

    class gestureListener implements GestureDetector.OnGestureListener {

        @Override
        public boolean onDown(MotionEvent event) {
            // TODO Auto-generated method stub

            return true;
        }

        @Override
        public boolean onFling(MotionEvent arg0, MotionEvent arg1, float arg2, float arg3) {
            // TODO Auto-generated method stub
            // Log.v("MyGesture", "onFling()");
            return true;
        }

        @Override
        public void onLongPress(MotionEvent event) {
            // TODO Auto-generated method stub
        }

        @Override
        public boolean onScroll(MotionEvent arg0, MotionEvent arg1, float arg2, float arg3) {
            // TODO Auto-generated method stub
            return true;
        }

        @Override
        public void onShowPress(MotionEvent arg0) {
            // TODO Auto-generated method stub
        }

        @Override
        public boolean onSingleTapUp(MotionEvent event) {
            // TODO Auto-generated method stub
            if (labelOperate == EnumLabelOperate.NULL) {
                return false;
            }

            // 根据手指点击之后微调屏幕坐标
            double x = event.getX() - 28.1;
            double y = event.getY() - 0.5;
            final Point pnt = new Point();
            pnt.set((int) x, (int) y);

            pnt3d = mSceneControl.getScene().pixelToGlobe(pnt, PixelToGlobeMode.TERRAINANDMODEL);


            if(labelOperate==EnumLabelOperate.DRAWTEXT){
                if(drawTextListener!=null) {
                    drawTextListener.OnclickPoint(pnt);
                }
                return false;
            }
            myPoint3DArrayList.add(pnt3d);
            isEdit = true;

            show();
            return false;
        }
    }

    private void show() {

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
                    GeoPoint3D geoPoint3D = new GeoPoint3D(point3D);
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
                points = new Point3D[count + 1];
                int i = 0;
                for (; i < count; i++) {
                    points[i] = myPoint3DArrayList.get(i);
                }
                points[i] = points[0];
                drawLineByPoints(points);
                break;
            case DRAWTEXT:
                for (int position = 0; position < myPoint3DArrayList.size(); position++) {
                    Point3D point3D = myPoint3DArrayList.get(position);

                    TextPart3D textPart3D=new TextPart3D();
                    textPart3D.setAnchorPoint(point3D);
                    textPart3D.setText(geoTextStrList.get(position));

                    GeoText3D geoText3D = new GeoText3D(textPart3D);
                    mSceneControl.getScene().getTrackingLayer().add(geoText3D, "text");

                }
                break;
            case NULL:
                break;
        }
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

    public interface DrawTextListener {
        void OnclickPoint(Point pnt);
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
        DRAWTEXT
    }

}
