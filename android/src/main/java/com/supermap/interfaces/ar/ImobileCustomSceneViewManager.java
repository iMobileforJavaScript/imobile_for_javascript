package com.supermap.interfaces.ar;

import android.app.ActivityManager;
import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import com.google.ar.core.AugmentedImageDatabase;
import com.google.ar.core.Config;
import com.google.ar.core.Session;

import java.io.IOException;
import java.io.InputStream;

public class ImobileCustomSceneViewManager extends CustomSceneViewManager {

    private Context mContext = null;

    private static final String TAG = "ImobileSceneViewManager";

    // This is the name of the image in the sample database.  A copy of the image is in the assets
    // directory.  Opening this image on your computer is a good quick way to test the augmented image
    // matching.
    private static final String DEFAULT_IMAGE_NAME = "supermap.png";

    // Do a runtime check for the OpenGL level available at runtime to avoid Sceneform crashing the
    // application.
    private static final double MIN_OPENGL_VERSION = 3.0;

    public ImobileCustomSceneViewManager(Context context) {
        super(context);
        mContext = context;

        init();
    }

    public ImobileCustomSceneViewManager(Context context, AttributeSet attrs) {
        super(context, attrs);
        mContext = context;

        init();
    }

    public ImobileCustomSceneViewManager(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = context;

        init();
    }

    private void init() {
        // Sceneform eventually.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            Log.e(TAG, "Sceneform requires Android N or later");
        }

        String openGlVersionString = ((ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE))
                        .getDeviceConfigurationInfo()
                        .getGlEsVersion();
        Log.d(TAG, "AugmentedImageFragment: openGlVersion=" + openGlVersionString);
        if (Double.parseDouble(openGlVersionString) < MIN_OPENGL_VERSION) {
            Log.e(TAG, "Sceneform requires OpenGL ES 3.0 or later");
        }

        // Turn off the plane discovery since we're only looking for images
        getPlaneDiscoveryController().hide();
        getPlaneDiscoveryController().setInstructionView(null);
        getArSceneView().getPlaneRenderer().setEnabled(false);
    }

    @Override
    protected Config getSessionConfiguration(Session session) {
        Config config = super.getSessionConfiguration(session);
        if (!setupAugmentedImageDatabase(config, session)) {
            Log.e(TAG, "无法设置增强图像数据库");
        }
        return config;
    }

    private boolean setupAugmentedImageDatabase(Config config, Session session) {
        AugmentedImageDatabase augmentedImageDatabase;

        AssetManager assetManager = getContext() != null ? getContext().getAssets() : null;
        if (assetManager == null) {
            Log.e(TAG, "Context is null, cannot intitialize image database.");
            return false;
        }

        // There are two ways to configure an AugmentedImageDatabase:
        // 1. Add Bitmap to DB directly
        // 2. Load a pre-built AugmentedImageDatabase
        // Option 2) has
        // * shorter setup time
        // * doesn't require images to be packaged in apk.
        Bitmap augmentedImageBitmap = loadAugmentedImageBitmap(assetManager);
        if (augmentedImageBitmap == null) {
            return false;
        }

        augmentedImageDatabase = new AugmentedImageDatabase(session);
        augmentedImageDatabase.addImage(DEFAULT_IMAGE_NAME, augmentedImageBitmap);
        // If the physical size of the image is known, you can instead use:
        //     augmentedImageDatabase.addImage("image_name", augmentedImageBitmap, widthInMeters);
        // This will improve the initial detection speed. ARCore will still actively estimate the
        // physical size of the image as it is viewed from multiple viewpoints.

        //自动对焦
        config.setFocusMode(Config.FocusMode.AUTO);

        config.setAugmentedImageDatabase(augmentedImageDatabase);
        return true;
    }

    private Bitmap loadAugmentedImageBitmap(AssetManager assetManager) {
        try (InputStream is = assetManager.open(DEFAULT_IMAGE_NAME)) {
            return BitmapFactory.decodeStream(is);
        } catch (IOException e) {
            Log.e(TAG, "IO exception loading augmented image bitmap.", e);
        }
        return null;
    }

}
