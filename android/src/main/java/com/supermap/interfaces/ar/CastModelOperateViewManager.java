package com.supermap.interfaces.ar;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Build;
import android.support.v4.app.FragmentManager;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import com.facebook.react.ReactFragmentActivity;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.google.ar.core.Anchor;
import com.google.ar.core.AugmentedImage;
import com.google.ar.core.Frame;
import com.google.ar.sceneform.AnchorNode;
import com.google.ar.sceneform.FrameTime;
import com.google.ar.sceneform.Node;
import com.google.ar.sceneform.math.Quaternion;
import com.google.ar.sceneform.math.Vector3;
import com.google.ar.sceneform.rendering.Renderable;
import com.google.ar.sceneform.rendering.ViewRenderable;
import com.google.ar.sceneform.ux.ArFragment;
import com.google.ar.sceneform.ux.TransformableNode;
import com.supermap.rnsupermap.R;

import java.util.Collection;

/**
 * AR投放
 */
public class CastModelOperateViewManager extends SimpleViewManager<ImobileSceneViewManager> {

    public static final String REACT_CLASS = "RCTCastModelOperateView";
    private ThemedReactContext mReactContext = null;

    private boolean model1Added = false;
    private ViewRenderable mViewRenderable;

    private ImobileSceneViewManager mSceneViewManager = null;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected ImobileSceneViewManager createViewInstance(ThemedReactContext reactContext) {
        Log.d("CastModelOperateView", "createViewInstance");
        mReactContext = reactContext;

        model1Added = false;

        Activity currentActivity = reactContext.getCurrentActivity();

        mSceneViewManager = new ImobileSceneViewManager(currentActivity);

        mSceneViewManager.getArSceneView().getScene().addOnUpdateListener(this::onUpdateFrame);
        mSceneViewManager.onResume();

        SCastModelOperateView.setInstance(mSceneViewManager);

        return mSceneViewManager;
    }

    /**
     * Registered with the Sceneform Scene object, this method is called at the start of each frame.
     *
     * @param frameTime - time since last frame.
     */
    private void onUpdateFrame(FrameTime frameTime) {
        Frame frame = mSceneViewManager.getArSceneView().getArFrame();

        if (frame == null) {
            return;
        }

        Collection<AugmentedImage> augmentedImages = frame.getUpdatedTrackables(AugmentedImage.class);
        for (AugmentedImage augmentedImage : augmentedImages) {
            switch (augmentedImage.getTrackingState()) {
                case PAUSED:
                    // When an image is in PAUSED state, but the camera is not PAUSED, it has been detected,
                    // but not yet tracked.
                    String text = "Detected Image " + augmentedImage.getIndex();
                    SnackbarHelper.getInstance().showMessage(mReactContext.getCurrentActivity(), text);
                    break;
                case TRACKING:
                    // Have to switch to UI Thread to update View.
                    if (augmentedImage.getName().contains("supermap") && !model1Added) {
                        renderObjectByImage(mSceneViewManager, augmentedImage.createAnchor(augmentedImage.getCenterPose()));
                        model1Added = true;
                    }
                    break;
                case STOPPED:
                    break;
            }
        }
    }

    private void renderObjectByImage(SceneViewManager sceneViewManager, Anchor anchor) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            ViewRenderable.builder()
                    .setView(mReactContext.getCurrentActivity(), R.layout.lytgtcroute)
                    //   .setHorizontalAlignment(ViewRenderable.HorizontalAlignment.RIGHT)
                    .build()
                    .thenAccept(viewRenderable -> {
                                mViewRenderable = viewRenderable;
                            }

                    )
                    .exceptionally((throwable -> {
                        return null;
                    }));
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            ViewRenderable.builder()
                    .setView(mReactContext.getCurrentActivity(), R.layout.lytgtcabc)
                    //   .setHorizontalAlignment(ViewRenderable.HorizontalAlignment.RIGHT)
                    .build()
                    .thenAccept(viewRenderable -> addNodeToSceneByImage(sceneViewManager, anchor, viewRenderable))
                    .exceptionally((throwable -> {
                        AlertDialog.Builder builder = new AlertDialog.Builder(mReactContext.getCurrentActivity());
                        builder.setMessage(throwable.getMessage())
                                .setTitle("Error!");
                        AlertDialog dialog = builder.create();
                        dialog.show();
                        return null;
                    }));
        }
    }

    private void addNodeToSceneByImage(SceneViewManager sceneViewManager, Anchor anchor, Renderable renderable) {
        Quaternion eular = Quaternion.eulerAngles(new Vector3(-90, 0, 0));
        Quaternion eular2 = Quaternion.eulerAngles(new Vector3(0, 0, -90));
        Quaternion e2M = Quaternion.multiply(eular, eular2);
        AnchorNode sun = new AnchorNode(anchor);

        sun.setLocalScale(new Vector3(0.5f, 0.5f, 0.5f));

        TransformableNode sunVisual = new TransformableNode(sceneViewManager.getTransformationSystem());
        sunVisual.setRenderable(renderable);
        sunVisual.setParent(sun);
        sunVisual.setLocalPosition(new Vector3(0, -0.1f, 0));
        sunVisual.setLocalScale(new Vector3(0.1f, 0.1f, 0.1f));
        sunVisual.setWorldScale(new Vector3(0.0005f, 0.0005f, 0.0005f));
//        node.setLocalRotation(eular); //如果你想开启水平放置，就打开此注释

        Node solarControls = new Node();
        solarControls.setParent(sun);
        solarControls.setRenderable(mViewRenderable);
        solarControls.setLocalPosition(new Vector3(0.40f, -0.05f, 0.0f));
//        solarControls.setLocalScale(new Vector3(0.005f, 0.005f, 0.005f));

//        View gtcRouteView = mGTCRouteViewRenderable.getView();
//        WebView gtcRouteWebsite = gtcRouteView.findViewById(R.id.webview);
//        gtcRouteWebsite.getSettings().setJavaScriptEnabled(true);
//        gtcRouteWebsite.loadUrl(WEBSITE);

        sunVisual.setOnTapListener(
                (hitTestResult, motionEvent) -> {
                    solarControls.setEnabled(!solarControls.isEnabled());
                }
        );

        mSceneViewManager.getArSceneView().getScene().addChild(sun);
        sunVisual.select();
    }

}
