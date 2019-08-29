package com.supermap.interfaces.ar.rajawali;

import android.content.Context;
import android.graphics.Color;
import android.view.MotionEvent;
import com.google.ar.core.Pose;
import org.rajawali3d.math.Matrix4;
import org.rajawali3d.math.Quaternion;
import org.rajawali3d.math.vector.Vector3;
import org.rajawali3d.renderer.RajawaliRenderer;

/**
 * Created by yanhang on 1/9/17.
 */

public class MotionRajawaliRenderer extends RajawaliRenderer {

    private static final float CAMERA_NEAR = 0.01f;
    private static final float CAMERA_FAR = 200f;

    private TouchViewHandler mTouchViewHandler;

    private FrustumAxes mFrustumAxes;
    private Grid mGrid;
    private Trajectory mTrajectory;

    public MotionRajawaliRenderer(Context context) {
        super(context);
        mTouchViewHandler = new TouchViewHandler(mContext, getCurrentCamera());
    }

    @Override
    protected void initScene() {
        //        mGrid = new Grid(100, 1, 1, 0xFFCCCCCC);   //default here. comment by ypp.

        mGrid = new Grid(100, 1, 1, 0xFFCCCCFF);

        mGrid.setPosition(0, -1.3f, 0);
        getCurrentScene().addChild(mGrid);

        mFrustumAxes = new FrustumAxes(3);
        getCurrentScene().addChild(mFrustumAxes);

        mTrajectory = new Trajectory(Color.RED, 1.0f);
        getCurrentScene().addChild(mTrajectory);

//        getCurrentScene().setBackgroundColor(Color.WHITE);//default here. comment by ypp.

        getCurrentScene().setBackgroundColor(Color.TRANSPARENT);


        getCurrentCamera().setNearPlane(CAMERA_NEAR);
        getCurrentCamera().setFarPlane(CAMERA_FAR);
        getCurrentCamera().setFieldOfView(37.5);
    }

//
//    public void updateCameraPose(TangoPoseData cameraPose){
//
//
//        float[] rotation = cameraPose.getRotationAsFloats();
//        float[] translation = cameraPose.getTranslationAsFloats();
//        Vector3 curPosition = new Vector3(translation[0], translation[1], translation[2]);
//        Quaternion quaternion = new Quaternion(rotation[3], rotation[0], rotation[1], rotation[2]);
//        update(curPosition, quaternion);
//
//
//
//
//    }
//

    public void updateCameraPoseFromMatrix(Matrix4 cameraMatrix) {
        Vector3 curPosition = cameraMatrix.getTranslation();
        Quaternion quaternion = new Quaternion();
        quaternion.fromMatrix(cameraMatrix);
        update(curPosition, quaternion);
    }

    private Pose prePose;
    private boolean initFlag = false;
    private float totalLength = 0.0f;

    public float getTotalLength() {
        return totalLength;
    }

    public void updateCameraPoseFromMatrix(Pose pose) {

        if (!initFlag) {
            initFlag = true;
            prePose = pose;
            totalLength = 0.0f;
        } else {

            float tempValue = (float) Math.sqrt(Math.pow(pose.getTranslation()[0] - prePose.getTranslation()[0], 2) +
                    Math.pow(pose.getTranslation()[1] - prePose.getTranslation()[1], 2) +
                    Math.pow(pose.getTranslation()[2] - prePose.getTranslation()[2], 2)
            );
            if (tempValue > 0.1) {
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


    public void update(Vector3 curPosition, Quaternion quaternion) {
        mTrajectory.addSegmentTo(curPosition);

        mFrustumAxes.setPosition(curPosition.x, curPosition.y, curPosition.z);

        //Conjugating the Quaternion is needed because Rajawali uses left handed convention for quaternions
        mFrustumAxes.setOrientation(quaternion.conjugate());
        mTouchViewHandler.updateCamera(curPosition, quaternion);
    }

    @Override
    public void onOffsetsChanged(float v, float v1, float v2, float v3, int i, int i1) {

    }

    @Override
    public void onTouchEvent(MotionEvent motionEvent) {

        mTouchViewHandler.onTouchEvent(motionEvent);

    }
}
