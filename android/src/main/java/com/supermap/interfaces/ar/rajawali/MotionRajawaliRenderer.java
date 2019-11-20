package com.supermap.interfaces.ar.rajawali;

import android.content.Context;
import android.graphics.Color;
import android.view.MotionEvent;

import com.google.ar.core.Pose;
import com.supermap.data.Point2Ds;
import com.supermap.data.Point3D;

import org.rajawali3d.math.Matrix4;
import org.rajawali3d.math.Quaternion;
import org.rajawali3d.math.vector.Vector3;
import org.rajawali3d.renderer.RajawaliRenderer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class MotionRajawaliRenderer extends RajawaliRenderer {

    private static final float CAMERA_NEAR = 0.01f;
    private static final float CAMERA_FAR = 200f;

    private TouchViewHandler mTouchViewHandler;

    private FrustumAxes mFrustumAxes;
    private Grid mGrid;
    private Trajectory mTrajectory;
    private TrajectoryPointCloud mTrajectoryPointCloud;


    public MotionRajawaliRenderer(Context context){
        super(context);
        mTouchViewHandler = new TouchViewHandler(mContext, getCurrentCamera());
    }

    //设置观看模式
    public void setViewMode(ViewMode viewMode) {
        switch (viewMode) {
            case FIRST_PERSON:
                mTouchViewHandler.setFirstPersonView();
                break;
            case THIRD_PERSON:
                mTouchViewHandler.setThirdPersonView();
                break;
        }
    }

    public ViewMode getViewMode() {
        return mTouchViewHandler.getViweMode();
    }

    @Override
    protected void initScene(){
        //        mGrid = new Grid(100, 1, 1, 0xFFCCCCCC);   //default here. comment by ypp.

//        mGrid = new Grid(100, 1, 1, 0xFFCCCCFF);
//
//
//        mGrid.setPosition(0, -1.3f, 0);
//        getCurrentScene().addChild(mGrid);

        mFrustumAxes = new FrustumAxes(3);
        getCurrentScene().addChild(mFrustumAxes);

        mTrajectory = new Trajectory(Color.GREEN, 1.0f);
        getCurrentScene().addChild(mTrajectory);

        mTrajectoryPointCloud = new TrajectoryPointCloud(Color.WHITE, 1.0f);
        getCurrentScene().addChild(mTrajectoryPointCloud);


//        getCurrentScene().setBackgroundColor(Color.WHITE);//default here. comment by ypp.

        getCurrentScene().setBackgroundColor(Color.BLACK);


        getCurrentCamera().setNearPlane(CAMERA_NEAR);
        getCurrentCamera().setFarPlane(CAMERA_FAR);
        getCurrentCamera().setFieldOfView(37.5);
    }




    public void updateCameraPoseFromMatrix(Matrix4 cameraMatrix){
        Vector3 curPosition = cameraMatrix.getTranslation();
        Quaternion quaternion = new Quaternion();
        quaternion.fromMatrix(cameraMatrix);
        update(curPosition, quaternion);
    }



    private Pose prePose;
    private float [] preTranslation = new float[3];
    private boolean initFlag = false;
    private float totalLength = 0.0f;

    public float getTotalLength(){
        return totalLength;
    }

    public void updateCameraPoseFromMatrix(Pose pose){

        if(!initFlag){
            initFlag    = true;
            prePose     = pose;
            totalLength = 0.0f;
        }else{

            float tempValue =(float) Math.sqrt(Math.pow(pose.getTranslation()[0]-prePose.getTranslation()[0],2 )+
                    Math.pow(pose.getTranslation()[1]-prePose.getTranslation()[1],2 )+
                    Math.pow(pose.getTranslation()[2]-prePose.getTranslation()[2],2 )
                    );
            if(tempValue > 0.1)
            {
                totalLength += tempValue;
                prePose = pose;
            }


        }


        Vector3 curPosition = new Vector3(
                pose.getTranslation()[0],
                pose.getTranslation()[1],
                pose.getTranslation()[2]);

//                pose.getTranslation();

        Quaternion quaternion = new Quaternion(
                pose.getRotationQuaternion()[3],
                pose.getRotationQuaternion()[0],
                pose.getRotationQuaternion()[1],
                pose.getRotationQuaternion()[2]
        );
//                pose.getRotationQuaternion();

        update(curPosition, quaternion);

    }


    public void updateCameraPoseFromVecotr(float [] translation, float [] rotation){
        if(!initFlag){
            initFlag    = true;
            System.arraycopy(translation,0,preTranslation,0,3);
            totalLength = 0.0f;
        }else{

            float tempValue =(float) Math.sqrt(Math.pow(translation[0]-preTranslation[0],2 )+
                    Math.pow(translation[1]-preTranslation[1],2 )+
                    Math.pow(translation[2]-preTranslation[2],2 )
            );
            if(tempValue > 0.1)
            {
                totalLength += tempValue;
                System.arraycopy(translation,0,preTranslation,0,3);
            }


        }


        Vector3 curPosition = new Vector3(
                translation[0],
                translation[1],
                translation[2]);

//                pose.getTranslation();

        Quaternion quaternion = new Quaternion(
                rotation[3],
                rotation[0],
                rotation[1],
                rotation[2]
        );
//                pose.getRotationQuaternion();

        update(curPosition, quaternion);


    }


    public void update(Vector3 curPosition, Quaternion quaternion){
//        mTrajectory.addSegmentTo(curPosition);

        if(mInitNewRoute && mRouteTrajectorys.containsKey(mRouteIndex)){
            mRouteTrajectorys.get(mRouteIndex).addSegmentTo(curPosition);
        }


        mFrustumAxes.setPosition(curPosition.x, curPosition.y, curPosition.z);

        //Conjugating the Quaternion is needed because Rajawali uses left handed convention for quaternions
        mFrustumAxes.setOrientation(quaternion.conjugate());
        mTouchViewHandler.updateCamera(curPosition, quaternion);
    }

    @Override
    public  void onOffsetsChanged(float v, float v1, float v2, float v3, int i, int i1){

    }

    @Override
    public void onTouchEvent(MotionEvent motionEvent){

        mTouchViewHandler.onTouchEvent(motionEvent);

    }


    //user interface for save & load pase data.
    public void  savePoseData( ArrayList<Point3D> out){
//         mTrajectory.savePoseData(out);
        if(mRouteTrajectorys.containsKey(mRouteIndex)){
            mRouteTrajectorys.get(mRouteIndex).savePoseData(out);
        }
    }

    public void clearPoseData(){
        mTrajectory.clearPoseData();


        totalLength = 0.0f;
    }


    public void loadPoseData(ArrayList<Point3D>  src){
        mTrajectory.loadPoseData(src);

        totalLength = (float)_getTotalLengthFromPointList(src);
    }





    private double _getTotalLengthFromPointList(ArrayList<Point3D> src){
        double totalLength = 0.0D;

        if(src == null || src.size()<= 1){
            return totalLength;
        }

        for(int i = 0;i<src.size()-1;i++){
            totalLength  += Math.sqrt(Math.pow(src.get(i).getX()-src.get(i+1).getX(),2)+
                            Math.pow(src.get(i).getY()-src.get(i+1).getY(),2)+
                            Math.pow(src.get(i).getZ()-src.get(i+1).getZ(),2)
                    );
        }

        return totalLength;
    }


    /*
     * 新建路线       void addNewRoute();
     * 保存路线       Point2Ds saveCurrentRoute();
     * 清空当前路线   void clearCurrentRoute();
     * 切换引导模型   void changeGuideModel();
     */


    private Map<Integer,Trajectory> mRouteTrajectorys = new HashMap<>();
    private int mRouteIndex = 0;

    private boolean mInitNewRoute = false;
    public void addNewRoute(){
        mRouteTrajectorys.put(mRouteIndex,new Trajectory(Color.GREEN,1.0f));
        getCurrentScene().addChild(mRouteTrajectorys.get(mRouteIndex));
        mInitNewRoute = true;
    }

    public void saveCurrentRoute(){
        mRouteIndex++;
        mInitNewRoute = false;
    }

    public void clearCurrentRoute(){
        if(mRouteTrajectorys.containsKey(mRouteIndex)){
            mRouteTrajectorys.get(mRouteIndex).resetTrajectory();
        }
    }


}
