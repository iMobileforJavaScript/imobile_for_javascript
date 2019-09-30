package com.supermap.map3D;

import android.os.Bundle;
import android.os.Message;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.GeoPoint3D;
import com.supermap.data.GeoStyle3D;
import com.supermap.data.Point3D;
import com.supermap.interfaces.SScene;
import com.supermap.realspace.Action3D;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.Sightline;
import com.supermap.realspace.Tracking3DEvent;
import com.supermap.realspace.Tracking3DListener;

import java.text.DecimalFormat;

/**
 * Created by zym on 2018/10/25.
 * Function:分析助手
 */

public class AnalysisHelper {

    private static AnalysisHelper instance = null;
    private static Object object = new Object();
    public static AnalysisHelper getInstence(){
        if(instance==null){
            //添加锁，防止多线程被重复创建
            synchronized (object){
                instance=new AnalysisHelper();
            }
        }
        return instance;
    }

    Sightline mSightline;
    private DistanceCallBack distanceCallBack;      //距离回调
    private AreaCallBack areaCallBack;      //面积回调
    private PerspectiveCallBack perspectiveCallBack;      //通视回调
    private SceneControl mSceneControl;


    public AnalysisHelper initSceneControl(final SceneControl control){
        this.mSceneControl=control;
        return this;
    }

    public void initAnalysis(SceneControl sceneControl, Tracking3DEvent tracking3DEvent){

        if(sceneControl.getAction() == Action3D.CREATEPOINT3D){
            perspective(tracking3DEvent);
        }else if (sceneControl.getAction() == Action3D.MEASUREDISTANCE3D) {
            measureDistance(tracking3DEvent);
        } else if (sceneControl.getAction() == Action3D.MEASUREAREA3D) {
            measureSureArea(tracking3DEvent);
        }
    }

    /**
     * 设置测量距离回调
     * @param disCallBack
     * @return
     */
    public AnalysisHelper setMeasureDisCallBack(DistanceCallBack disCallBack){
        this.distanceCallBack=disCallBack;
        return this;
    }

    /**
     * 设置测量面积回调
     * @param areaCallBack
     * @return
     */
    public AnalysisHelper setMeasureAreaCallBack(AreaCallBack areaCallBack){
        this.areaCallBack=areaCallBack;
        return this;
    }

    /**
     * 设置通视回调
     * @param perspectiveCallBack
     * @return
     */
    public AnalysisHelper setPerspectiveCallBack(PerspectiveCallBack perspectiveCallBack){
        this.perspectiveCallBack=perspectiveCallBack;
        return this;
    }

    // 开启距离测量分析
    public void startMeasureAnalysis() {
        if(mSceneControl!=null){
            mSceneControl.setAction(Action3D.MEASUREDISTANCE3D);
        }

    }

    // 开启测量面积分析
    public void startSureArea() {
        if(mSceneControl!=null) {
            mSceneControl.setAction(Action3D.MEASUREAREA3D);
        }
    }

    //开始通视分析
    public void startPerspectiveAnalysis() {
        if(mSceneControl==null){
            return;
        }
        if(mSightline==null){
            mSightline = new Sightline(mSceneControl.getScene());
        }
        mSceneControl.setAction(Action3D.CREATEPOINT3D);
    }

    // 结束通视分析
    public void endPerspectiveAnalysis() {
        if(mSceneControl==null){
            return;
        }
        mSceneControl.getScene().getTrackingLayer().clear();
        mSightline.clearResult();
        mSightline.dispose();
        mSightline = null;
        mSceneControl.setAction(Action3D.PANSELECT3D);

    }


    // 关闭所有情况下的分析
    public void closeAnalysis() {
        if(mSceneControl!=null) {
            mSceneControl.setAction(Action3D.PANSELECT3D);
        }
    }

    // 测量距离
    private void measureDistance(Tracking3DEvent event) {
        // 加点
        // 更新总距离长度
        double totalLength = event.getTotalLength();
        WritableMap writeMap = Arguments.createMap();
        writeMap.putDouble("length",totalLength);
        writeMap.putDouble("x",event.getX());
        writeMap.putDouble("y",event.getY());
        writeMap.putDouble("z",event.getZ());
        if(distanceCallBack!=null) {

            distanceCallBack.distanceResult(writeMap);
        }
    }

    // 测量面积
    private void measureSureArea(Tracking3DEvent event) {
        // 加点
        // 更新测量面积
        double totalArea = event.getTotalArea();
        WritableMap writeMap = Arguments.createMap();
        writeMap.putDouble("totalArea",totalArea);
        writeMap.putDouble("x",event.getX());
        writeMap.putDouble("y",event.getY());
        writeMap.putDouble("z",event.getZ());
        if(areaCallBack!=null) {
            areaCallBack.areaResult(writeMap);
        }
    }

    //通视
    private void perspective(Tracking3DEvent event){
        if (mSightline != null) {

            Point3D p3D = new Point3D(event.getX(), event.getY(), event.getZ());

            if (mSightline.getvViewerPosition().getX() == 0) {
                mSightline.setViewerPosition(p3D);
                mSightline.build();
                // 加点
                Point3D point3d = new Point3D(event.getX(), event.getY(), event.getZ());
                GeoPoint3D geoPoint3D = new GeoPoint3D(point3d);
                GeoStyle3D geoStyle3D = new GeoStyle3D();
                geoPoint3D.setStyle3D(geoStyle3D);
                mSceneControl.getScene().getTrackingLayer().add(geoPoint3D, "point");
            } else {
                mSightline.addTargetPoint(p3D);
                // 加点
                Point3D point3d = new Point3D(event.getX(), event.getY(), event.getZ());
                GeoPoint3D geoPoint3D = new GeoPoint3D(point3d);
                GeoStyle3D geoStyle3D = new GeoStyle3D();
                geoPoint3D.setStyle3D(geoStyle3D);
                mSceneControl.getScene().getTrackingLayer().add(geoPoint3D, "point");
            }

            double x = mSightline.getvViewerPosition().getX();
            double y = mSightline.getvViewerPosition().getY();
            double z = mSightline.getvViewerPosition().getZ();
            int count = mSightline.getPointCount();
            DecimalFormat df = new DecimalFormat("#.00");
            String LocationX = df.format(x);
            String LocationY = df.format(x);
            String LocationZ = df.format(z);
            if(perspectiveCallBack!=null) {
                perspectiveCallBack.perspectiveResult(LocationX, LocationY, LocationZ, count);
            }

        }
    }

    /**
     * 测量距离回调
     */
    public interface DistanceCallBack {
        void distanceResult(WritableMap distance);
    }

    /**
     * 测量面积回调
     */
    public interface AreaCallBack {
        void areaResult(WritableMap area);
    }

    /**
     *  通视测量回调
     */
    public interface PerspectiveCallBack{
        void perspectiveResult(String LocationX, String LocationY, String LocationZ, int count);
    }
}
