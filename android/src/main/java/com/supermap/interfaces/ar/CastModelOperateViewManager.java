package com.supermap.interfaces.ar;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Build;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
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
public class CastModelOperateViewManager extends SimpleViewManager<FrameLayout> {

    public static final String REACT_CLASS = "RCTCastModelOperateView";
    private ThemedReactContext mReactContext = null;

    private AugmentedImageFragment mArFragment;
    private boolean model1Added = false;
    private ViewRenderable mViewRenderable;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected FrameLayout createViewInstance(ThemedReactContext reactContext) {
        Log.d("CastModelOperateView", "createViewInstance");
        mReactContext = reactContext;

        model1Added = false;

        Activity currentActivity = reactContext.getCurrentActivity();
        ReactFragmentActivity fragmentActivity = (ReactFragmentActivity) currentActivity;
        FragmentManager supportFragmentManager = fragmentActivity.getSupportFragmentManager();

//        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
//                ViewGroup.LayoutParams.MATCH_PARENT);
//        FrameLayout frameLayout = new FrameLayout(currentActivity);
//        frameLayout.setLayoutParams(params);

        FrameLayout frameLayout = (FrameLayout) View.inflate(fragmentActivity, R.layout.cast_model_operate, null);
        mArFragment = (AugmentedImageFragment) supportFragmentManager.findFragmentById(R.id.ar_fragment);


        mArFragment.getArSceneView().getScene().addOnUpdateListener(this::onUpdateFrame);

//        SCastModelOperateView.setInstance(mArFragment);

        return frameLayout;
    }

    /**
     * Registered with the Sceneform Scene object, this method is called at the start of each frame.
     *
     * @param frameTime - time since last frame.
     */
    private void onUpdateFrame(FrameTime frameTime) {
        if (mArFragment  == null || mArFragment.getArSceneView()  ==  null) {
            return;
        }
        Frame frame = mArFragment.getArSceneView().getArFrame();

        // If there is no frame, just return.
        if (frame == null) {
            return;
        }

        Collection<AugmentedImage> updatedAugmentedImages = frame.getUpdatedTrackables(AugmentedImage.class);
        for (AugmentedImage augmentedImage : updatedAugmentedImages) {
            switch (augmentedImage.getTrackingState()) {
                case PAUSED:
                    // When an image is in PAUSED state, but the camera is not PAUSED, it has been detected,
                    // but not yet tracked.
                    String name = augmentedImage.getName();
//                    String text = "Detected Image :" + augmentedImage.getIndex() + "--" + name;
                    if (name.contains("supermap")){
                        String text = "请持稳设备,已经检测到图像: " + "GTC2019";
                        SnackbarHelper.getInstance().showMessage(mReactContext.getCurrentActivity(), text);
                    }
                    break;
                case TRACKING:
                    // Have to switch to UI Thread to update View.

                    // Create a new anchor for newly found images.
                    if (augmentedImage.getName().contains("supermap") && !model1Added){
                        renderObjectByImage(mArFragment, augmentedImage.createAnchor(augmentedImage.getCenterPose()));
                        model1Added = true;
                        SnackbarHelper.getInstance().hide(mReactContext.getCurrentActivity());
                    }
                    break;
                case STOPPED:
                    break;
            }
        }
    }

    private void renderObjectByImage(ArFragment fragment, Anchor anchor){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            ViewRenderable.builder()
                    .setView(mReactContext.getCurrentActivity(),R.layout.lytgtcroute)
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
                    .setView(mReactContext.getCurrentActivity(),R.layout.lytgtcabc)
                    //   .setHorizontalAlignment(ViewRenderable.HorizontalAlignment.RIGHT)
                    .build()
                    .thenAccept(viewRenderable -> addNodeToSceneByImage(fragment, anchor, viewRenderable))
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

    private void addNodeToSceneByImage(ArFragment fragment, Anchor anchor, Renderable renderable){
        Quaternion eular = Quaternion.eulerAngles(new Vector3(-90,0,0));
        Quaternion eular2 = Quaternion.eulerAngles(new Vector3(0,0,-90));
        Quaternion e2M = Quaternion.multiply(eular,eular2);
        AnchorNode sun = new AnchorNode(anchor);

        sun.setLocalScale(new Vector3(0.5f,0.5f,0.5f));

        TransformableNode sunVisual = new TransformableNode(fragment.getTransformationSystem());
        sunVisual.setRenderable(renderable);
        sunVisual.setParent(sun);
        sunVisual.setLocalPosition(new Vector3(0,-0.1f,0));
        sunVisual.setLocalScale(new Vector3(0.1f,0.1f,0.1f));
        sunVisual.setWorldScale(new Vector3(0.0005f,0.0005f,0.0005f));
//        node.setLocalRotation(eular); //如果你想开启水平放置，就打开此注释

        Node solarControls = new Node();
        solarControls.setParent(sun);
        solarControls.setRenderable(mViewRenderable);
        solarControls.setLocalPosition(new Vector3(0.40f, -0.05f, 0.0f));
//        solarControls.setLocalScale(new Vector3(0.005f, 0.005f, 0.005f));

//        View gtcRouteView = mViewRenderable.getView();
//        WebView gtcRouteWebsite = gtcRouteView.findViewById(R.id.webview);
//        gtcRouteWebsite.getSettings().setJavaScriptEnabled(true);
//        gtcRouteWebsite.loadUrl(WEBSITE);

        sunVisual.setOnTapListener(
                (hitTestResult, motionEvent) -> {
                    solarControls.setEnabled(!solarControls.isEnabled());
                }
        );

        fragment.getArSceneView().getScene().addChild(sun);
        sunVisual.select();
    }

}
