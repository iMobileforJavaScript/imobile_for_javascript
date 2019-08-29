package com.supermap.interfaces.ar.rajawali;

import org.rajawali3d.math.Matrix4;

/**
 * Class used to hold device extrinsics information in a way that is easy to use to perform
 * transformations with the ScenePoseCalculator.
 */
public class DeviceExtrinsics {
    // Transformation from the position of the depth camera to the device frame.
    private Matrix4 mDeviceTDepthCamera;

    // Transformation from the position of the color Camera to the device frame.
    private Matrix4 mDeviceTColorCamera;

//    public DeviceExtrinsics(TangoPoseData imuTDevicePose, TangoPoseData imuTColorCameraPose,
//                            TangoPoseData imuTDepthCameraPose) {
//        Matrix4 deviceTImu = ScenePoseCalculator.tangoPoseToMatrix(imuTDevicePose).inverse();
//        Matrix4 imuTColorCamera = ScenePoseCalculator.tangoPoseToMatrix(imuTColorCameraPose);
//        Matrix4 imuTDepthCamera = ScenePoseCalculator.tangoPoseToMatrix(imuTDepthCameraPose);
//        mDeviceTDepthCamera = deviceTImu.clone().multiply(imuTDepthCamera);
//        mDeviceTColorCamera = deviceTImu.multiply(imuTColorCamera);
//    }

    public Matrix4 getDeviceTColorCamera() {
        return mDeviceTColorCamera;
    }

    public Matrix4 getDeviceTDepthCamera() {
        return mDeviceTDepthCamera;
    }
}