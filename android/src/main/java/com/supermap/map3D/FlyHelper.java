package com.supermap.map3D;

import android.os.Handler;
import android.os.Message;

import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.AltitudeMode;
import com.supermap.data.Color;
import com.supermap.data.GeoLine3D;
import com.supermap.data.GeoStyle3D;
import com.supermap.data.Point3D;
import com.supermap.data.Point3Ds;
import com.supermap.realspace.Action3D;
import com.supermap.realspace.Camera;
import com.supermap.realspace.FlyManager;
import com.supermap.realspace.FlyStatus;
import com.supermap.realspace.Route;
import com.supermap.realspace.RouteStop;
import com.supermap.realspace.RouteStops;
import com.supermap.realspace.Routes;
import com.supermap.realspace.SceneControl;

import java.io.File;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by zym on 2018/10/25.
 * Function:飞行助手
 */

public class FlyHelper {

    private static FlyHelper instance = null;
    private static Object object = new Object();

    public static FlyHelper getInstence() {
        if (instance == null) {
            //添加锁，防止多线程调用时被重复创建
            synchronized (object) {
                instance = new FlyHelper();
            }
        }
        return instance;
    }

    private String mSceneDirPath;
    private SceneControl mSceneControl;
    private FlyManager flyManager;
    private ArrayList<String> flyRouteNames;
    private String flyRoute;
    private Routes routes;
    private int routeIndex=-1;
    public boolean isFlying = false;
    private boolean isStop = false;

    private Timer flyProgressTimer;
    private TimerTask flyProgressTimerTask;
    private Handler flyProgressHandler;

    private FlyProgress flyProgress;

    private RouteStops mRouteStops;
    private Point3Ds point3Ds=new Point3Ds();
    private Route route;
    /**
     * 初始化飞行场景
     *
     * @param control
     * @return true表示初始化成功，false表示"该场景下无飞行路线"
     */
    public FlyHelper init(SceneControl control) {
        mSceneControl = control;
        return this;
    }

    /**
     * 设置飞行进度回调
     *
     * @param flyProgress
     * @return
     */
    public FlyHelper setFlyProgress(FlyProgress flyProgress) {
        this.flyProgress = flyProgress;
        return this;
    }

    /**
     * 获取飞行路径列表
     *
     * @return
     */
    public ArrayList getFlyRouteNames(String sceneDirPath) {
        if (mSceneControl == null ) {
            return null;
        }
        if (sceneDirPath == null || sceneDirPath.equals("")) {
            return null;
        }
        mSceneDirPath = sceneDirPath;
        flyRouteNames = new ArrayList<String>();
        flyManager = mSceneControl.getScene().getFlyManager();
        String currentSceneName = mSceneControl.getScene().getName();
        flyRoute = getFlyRoutePath(sceneDirPath, currentSceneName);
        if (flyRoute == null) {
            return null;
        } else {
            routes = flyManager.getRoutes();
            boolean hasRoutes = routes.fromFile(flyRoute);
            if (hasRoutes) {
                int numOfRoutes = routes.getCount();
                for (int i = 0; i < numOfRoutes; i++) {
                    flyRouteNames.add(routes.getRouteName(i));
                }
            }
        }
        return flyRouteNames;
    }

    /**
     * 设置飞行路径
     *
     * @param position
     */
    public FlyHelper setPosition(int position) {
        routeIndex=position;
        return this;
    }

    /**
     * 开始飞行
     */
    public void flyStart() {
        if (mSceneControl == null || flyManager == null) {
            return;
        }
        if (!isFlying) {
            if (isStop) {
                flyManager = mSceneControl.getScene().getFlyManager();
                routes = flyManager.getRoutes();
                routes.fromFile(flyRoute);

                routes.setCurrentRoute(routeIndex);
                isStop = false;
            }
            mSceneControl.setAction(Action3D.PAN3D);
            flyManager.play();
            refreashFlyProgress();
            isFlying = true;
        }
    }

    /**
     * 暂停飞行
     */
    public void flyPause() {
        if (mSceneControl == null || flyManager == null) {
            return;
        }
        if (isFlying) {
            flyManager.pause();
            mSceneControl.setAction(Action3D.PANSELECT3D);
            isFlying = false;
        }
    }

    /**
     * 开始飞行或者暂停飞行
     */
    public void flyPauseOrStart() {
        if (mSceneControl == null || flyManager == null) {
            return;
        }
        if (!isFlying) {
            if (isStop) {
                flyManager = mSceneControl.getScene().getFlyManager();
                routes = flyManager.getRoutes();
                routes.fromFile(flyRoute);
                routes.setCurrentRoute(routeIndex);
                isStop = false;
            }
            mSceneControl.setAction(Action3D.PAN3D);
            flyManager.play();
            refreashFlyProgress();
            isFlying = true;
        } else {
            flyManager.pause();
            mSceneControl.setAction(Action3D.PANSELECT3D);
            isFlying = false;
        }
    }

    /**
     * 停止飞行
     */
    public void flyStop() {
        if (flyManager != null) {
            flyManager.stop();
            mSceneControl.setAction(Action3D.PANSELECT3D);
            if(flyProgressTimerTask!=null){
                flyProgressTimerTask.cancel();
            }
            isFlying = false;
            isStop = true;
        }
    }

    // 实时更新飞行模式下飞行进度
    public void refreashFlyProgress() {

        flyProgressTimer = new Timer();

        flyProgressHandler = new Handler() {
            double duration = flyManager.getDuration();

            public void handleMessage(Message msg) {

                switch (msg.what) {
                    case 0:

                        if (flyManager.getStatus() == FlyStatus.PLAY) {
                            if (flyProgress == null) {
                                break;
                            }
                            double progress = flyManager.getProgress();
                            double percent = progress / duration * 100;
                            int tempPercent = (int) Math.ceil(percent);
                            flyProgress.flyProgress(tempPercent);
                        } else if (flyManager.getStatus() == FlyStatus.STOP) {
                            flyProgressTimerTask.cancel();
                        }
                        break;

                    default:
                        break;
                }

            }

        };

        flyProgressTimerTask = new TimerTask() {

            @Override
            public void run() {
                flyProgressHandler.sendEmptyMessage(0);
            }
        };

        flyProgressTimer.schedule(flyProgressTimerTask, 0, 10);

    }

    /**
     * 进度接口
     */
    public interface FlyProgress {
        void flyProgress(int progress);
    }


    /**
     *   根据场景名称获取同名的飞行路线，需要确认飞行文件的存放位置
     */
    private String getFlyRoutePath(String localDataPath, String sceneName) {
        String flyRoutePath = "";

        if (new File(localDataPath).exists()) {
            File flist = new File(localDataPath);
            File[] mFileList = flist.listFiles();
            for (int i = 0; i <mFileList.length ; i++) {
                if(!mFileList[i].isDirectory()){
                    flyRoutePath=mFileList[i].getAbsolutePath();
                    String suffix=flyRoutePath.substring(flyRoutePath.lastIndexOf(".")+1);
                    if(suffix.equals("fpf")){
                        return flyRoutePath;
                    }
                }
            }
        }
        return null;
    }

    public void saveCurrentRouteStop(){
        if(mRouteStops==null){
            route=new Route();
            route.setStopsVisible(true);
            route.setLinesVisible(true);
            route.setFlyAlongTheRoute(true);
            mRouteStops=route.getStops();
        }
        RouteStop routeStop=new RouteStop();
        Camera camera=new Camera(mSceneControl.getScene().getFirstPersonCamera());
        routeStop.setCamera(camera);
        mRouteStops.add(routeStop);
        point3Ds.add(new Point3D(camera.getLongitude(),camera.getLatitude(),camera.getAltitude()));
        if(point3Ds.getCount()>=2){
            GeoStyle3D lineStyle3D=new GeoStyle3D();
            lineStyle3D.setLineColor(new Color(255,255,0));
            lineStyle3D.setAltitudeMode(AltitudeMode.ABSOLUTE);
            lineStyle3D.setLineWidth(5);
            GeoLine3D geoLine3D=new GeoLine3D(point3Ds);
            geoLine3D.setStyle3D(lineStyle3D);
            mSceneControl.getScene().getTrackingLayer().add(geoLine3D,"line");
        }
    }

    public void saveRoutStop(){
        flyManager=mSceneControl.getScene().getFlyManager();
        Routes routes=flyManager.getRoutes();
        int index=routes.add(route);
        routes.setCurrentRoute(index);
        flyManager.play();
        try {
            mSceneControl.getScene().getWorkspace().save();
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void clearRoutStops (){
        point3Ds.clear();
        mSceneControl.getScene().getTrackingLayer().clear();
        int count =mRouteStops.getCount();
        for (int i=0;i<count;i++){
            mRouteStops.remove(0);
        }
    }

    public WritableArray getStopList(){
        WritableArray array = null;
        int count =mRouteStops.getCount();
        for (int i = 0; i <count ; i++) {
            WritableMap map = null;
            map.putString("Name",mRouteStops.get(i).getName());
            array.pushMap(map);
        }
        return array;
    }

    public RouteStop getStop(String name){
        RouteStop routeStop=mRouteStops.get(name);
        return routeStop;
    }

    public boolean removeStop(String name){
        if( mRouteStops.get(name)!=null){
            mRouteStops.remove(name);
            return true;
        }else {
            return false;
        }
    }
}
