package com.supermap.interfaces.ar;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.util.AttributeSet;
import android.util.Log;
import android.view.*;
import android.widget.RelativeLayout;
import android.widget.Toast;
import com.google.ar.core.*;
import com.google.ar.core.exceptions.*;
import com.google.ar.sceneform.ArSceneView;
import com.google.ar.sceneform.FrameTime;
import com.google.ar.sceneform.HitTestResult;
import com.google.ar.sceneform.Scene;
import com.google.ar.sceneform.rendering.ModelRenderable;
import com.google.ar.sceneform.ux.FootprintSelectionVisualizer;
import com.google.ar.sceneform.ux.PlaneDiscoveryController;
import com.google.ar.sceneform.ux.TransformationSystem;
import com.google.ar.sceneform.ux.TransformableNode;

import java.util.Set;

public abstract class SceneView extends RelativeLayout implements Scene.OnPeekTouchListener, Scene.OnUpdateListener {

    private static final String TAG = SceneView.class.getSimpleName();

    private Activity mContext = null;
    private LayoutInflater inflater;

    public SceneView(Context context) {
        super(context);
        mContext = (Activity) context;
        inflater = LayoutInflater.from(mContext);

        initView();
    }

    public SceneView(Context context, AttributeSet attrs) {
        super(context, attrs);
        mContext = (Activity) context;
        inflater = LayoutInflater.from(mContext);

        initView();
    }

    public SceneView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = (Activity) context;
        inflater = LayoutInflater.from(mContext);

        initView();
    }

    /**
     * Invoked when an ARCore plane is tapped.
     */
    public interface OnTapArPlaneListener {
        /**
         * Called when an ARCore plane is tapped. The callback will only be invoked if no {@link
         * com.google.ar.sceneform.Node} was tapped.
         *
         * @param hitResult   The ARCore hit result that occurred when tapping the plane
         * @param plane       The ARCore Plane that was tapped
         * @param motionEvent the motion event that triggered the tap
         * @see #setOnTapArPlaneListener(SceneView.OnTapArPlaneListener)
         */
        void onTapPlane(HitResult hitResult, Plane plane, MotionEvent motionEvent);
    }

    private boolean installRequested;
    private boolean sessionInitializationFailed = false;
    private ArSceneView arSceneView;
    private PlaneDiscoveryController planeDiscoveryController;
    private TransformationSystem transformationSystem;
    private GestureDetector gestureDetector;
    private boolean isStarted;

    @Nullable
    private SceneView.OnTapArPlaneListener onTapArPlaneListener;

    @SuppressWarnings({"initialization"})
    private final ViewTreeObserver.OnWindowFocusChangeListener onFocusListener =
            (hasFocus -> onWindowFocusChanged(hasFocus));

    /**
     * Gets the ArSceneView for this fragment.
     */
    public ArSceneView getArSceneView() {
        return arSceneView;
    }

    /**
     * Gets the plane discovery controller, which displays instructions for how to scan for planes.
     */
    public PlaneDiscoveryController getPlaneDiscoveryController() {
        return planeDiscoveryController;
    }

    /**
     * Gets the transformation system, which is used by {@link TransformableNode} for detecting
     * gestures and coordinating which node is selected.
     */
    public TransformationSystem getTransformationSystem() {
        return transformationSystem;
    }

    /**
     * Registers a callback to be invoked when an ARCore Plane is tapped. The callback will only be
     * invoked if no {@link com.google.ar.sceneform.Node} was tapped.
     *
     * @param onTapArPlaneListener the {@link SceneView.OnTapArPlaneListener} to attach
     */
    public void setOnTapArPlaneListener(@Nullable SceneView.OnTapArPlaneListener onTapArPlaneListener) {
        this.onTapArPlaneListener = onTapArPlaneListener;
    }

    @SuppressWarnings({"initialization"})
    // Suppress @UnderInitialization warning.
    private void initView() {
        arSceneView = new ArSceneView(mContext);

        ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);
        arSceneView.setLayoutParams(layoutParams);

        // Setup the instructions view.(addview顺序?)
        View instructionsView = loadPlaneDiscoveryView(inflater, null);
        if (instructionsView != null) {
            this.addView(instructionsView);
        }
        planeDiscoveryController = new PlaneDiscoveryController(instructionsView);

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N) {
            // Enforce API level 24
            return;
        }

        transformationSystem = makeTransformationSystem();

        gestureDetector =
                new GestureDetector(
                        getContext(),
                        new GestureDetector.SimpleOnGestureListener() {
                            @Override
                            public boolean onSingleTapUp(MotionEvent e) {
                                onSingleTap(e);
                                return true;
                            }

                            @Override
                            public boolean onDown(MotionEvent e) {
                                return true;
                            }
                        });

        arSceneView.getScene().addOnPeekTouchListener(this);
        arSceneView.getScene().addOnUpdateListener(this);

        if (isArRequired()) {
            // Request permissions
            //请求权限
        }

        // Make the app immersive and don't turn off the display.
        arSceneView.getViewTreeObserver().addOnWindowFocusChangeListener(onFocusListener);
        this.addView(arSceneView);
    }

    /**
     * Returns true if this application is AR Required, false if AR Optional. This is called when
     * initializing the application and the session.
     */
    public abstract boolean isArRequired();

    protected final boolean requestInstall() throws UnavailableException {
        switch (ArCoreApk.getInstance().requestInstall(mContext, !installRequested)) {
            case INSTALL_REQUESTED:
                installRequested = true;
                return true;
            case INSTALLED:
                break;
        }
        return false;
    }

    /**
     * Initializes the ARCore session. The CAMERA permission is checked before checking the
     * installation state of ARCore. Once the permissions and installation are OK, the method
     * #getSessionConfiguration(Session session) is called to get the session configuration to use.
     * Sceneform requires that the ARCore session be updated using LATEST_CAMERA_IMAGE to avoid
     * blocking while drawing. This mode is set on the configuration object returned from the
     * subclass.
     */
    protected final void initializeSession() {
        // Only try once
        if (sessionInitializationFailed) {
            return;
        }
        // if we have the camera permission, create the session
        if (ContextCompat.checkSelfPermission(mContext, "android.permission.CAMERA")
                == PackageManager.PERMISSION_GRANTED) {

            UnavailableException sessionException = null;
            try {
                if (requestInstall()) {
                    return;
                }

                Session session = createSession();

                Config config = getSessionConfiguration(session);
                // Force the non-blocking mode for the session.

                config.setUpdateMode(Config.UpdateMode.LATEST_CAMERA_IMAGE);
                session.configure(config);
                getArSceneView().setupSession(session);
                return;
            } catch (UnavailableException e) {
                sessionException = e;
            } catch (Exception e) {
                sessionException = new UnavailableException();
                sessionException.initCause(e);
            }
            sessionInitializationFailed = true;
            handleSessionException(sessionException);

        } else {
            //请求权限
            Log.e(TAG, "Sceneform requires android.permission.CAMERA");
        }
    }

    private Session createSession()
            throws UnavailableSdkTooOldException, UnavailableDeviceNotCompatibleException,
            UnavailableArcoreNotInstalledException, UnavailableApkTooOldException {
        Session session = createSessionWithFeatures();
        if (session == null) {
            session = new Session(mContext);
        }
        return session;
    }

    Session createSessionWithFeatures()
            throws UnavailableSdkTooOldException, UnavailableDeviceNotCompatibleException,
            UnavailableArcoreNotInstalledException, UnavailableApkTooOldException {
        return new Session(mContext, getSessionFeatures());
    }

    /**
     * Creates the transformation system used by this fragment. Can be overridden to create a custom
     * transformation system.
     */
    protected TransformationSystem makeTransformationSystem() {
        FootprintSelectionVisualizer selectionVisualizer = new FootprintSelectionVisualizer();

        TransformationSystem transformationSystem =
                new TransformationSystem(getResources().getDisplayMetrics(), selectionVisualizer);

        setupSelectionRenderable(selectionVisualizer);

        return transformationSystem;
    }

    @SuppressWarnings({"AndroidApiChecker", "FutureReturnValueIgnored"})
    protected void setupSelectionRenderable(FootprintSelectionVisualizer selectionVisualizer) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            ModelRenderable.builder()
                    .setSource(mContext, com.google.ar.sceneform.ux.R.raw.sceneform_footprint)
                    .build()
                    .thenAccept(
                            renderable -> {
                                // If the selection visualizer already has a footprint renderable, then it was set to
                                // something custom. Don't override the custom visual.
                                if (selectionVisualizer.getFootprintRenderable() == null) {
                                    selectionVisualizer.setFootprintRenderable(renderable);
                                }
                            })
                    .exceptionally(
                            throwable -> {
                                Toast toast =
                                        Toast.makeText(
                                                getContext(), "Unable to load footprint renderable", Toast.LENGTH_LONG);
                                toast.setGravity(Gravity.CENTER, 0, 0);
                                toast.show();
                                return null;
                            });
        }
    }

    protected abstract void handleSessionException(UnavailableException sessionException);

    protected abstract Config getSessionConfiguration(Session session);

    /**
     * Specifies additional features for creating an ARCore {@link Session}. See
     * {@link Session.Feature}.
     */

    protected abstract Set<Session.Feature> getSessionFeatures();

    public void onWindowFocusChanged(boolean hasFocus) {
        Activity activity = mContext;
        if (hasFocus && activity != null) {
            // Standard Android full-screen functionality.
            activity
                    .getWindow()
                    .getDecorView()
                    .setSystemUiVisibility(
                            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                                    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                    | View.SYSTEM_UI_FLAG_FULLSCREEN
                                    | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
            activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }
    }

    @Override
    public void onPeekTouch(HitTestResult hitTestResult, MotionEvent motionEvent) {
        transformationSystem.onTouch(hitTestResult, motionEvent);

        if (hitTestResult.getNode() == null) {
            gestureDetector.onTouchEvent(motionEvent);
        }
    }

    @Override
    public void onUpdate(FrameTime frameTime) {
        Frame frame = arSceneView.getArFrame();
        if (frame == null) {
            return;
        }

        for (Plane plane : frame.getUpdatedTrackables(Plane.class)) {
            if (plane.getTrackingState() == TrackingState.TRACKING) {
                planeDiscoveryController.hide();
            }
        }
    }

    private void start() {
        if (isStarted) {
            return;
        }

        if (mContext != null) {
            isStarted = true;
            try {
                arSceneView.resume();
            } catch (CameraNotAvailableException ex) {
                sessionInitializationFailed = true;
            }
            if (!sessionInitializationFailed) {
                planeDiscoveryController.show();
            }
        }
    }

    private void stop() {
        if (!isStarted) {
            return;
        }

        isStarted = false;
        planeDiscoveryController.hide();
        arSceneView.pause();
    }

    // Load the default view we use for the plane discovery instructions.
    @Nullable
    private View loadPlaneDiscoveryView(LayoutInflater inflater, @Nullable ViewGroup container) {
        return inflater.inflate(com.google.ar.sceneform.ux.R.layout.sceneform_plane_discovery_layout, container, false);
    }

    private void onSingleTap(MotionEvent motionEvent) {
        Frame frame = arSceneView.getArFrame();

        transformationSystem.selectNode(null);

        // Local variable for nullness static-analysis.
        SceneView.OnTapArPlaneListener onTapArPlaneListener = this.onTapArPlaneListener;

        if (frame != null && onTapArPlaneListener != null) {
            if (motionEvent != null && frame.getCamera().getTrackingState() == TrackingState.TRACKING) {
                for (HitResult hit : frame.hitTest(motionEvent)) {
                    Trackable trackable = hit.getTrackable();
                    if (trackable instanceof Plane && ((Plane) trackable).isPoseInPolygon(hit.getHitPose())) {
                        Plane plane = (Plane) trackable;
                        onTapArPlaneListener.onTapPlane(hit, plane, motionEvent);
                        break;
                    }
                }
            }
        }
    }

    /*
     * ****************************************************************************************
     * 生命周期顺序
     * ****************************************************************************************
     * */
    public void onResume() {
        if (isArRequired() && arSceneView.getSession() == null) {
            initializeSession();
        }
        start();
    }

    public void onPause() {
        stop();
    }

    public void onDestroyView() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            arSceneView.getViewTreeObserver().removeOnWindowFocusChangeListener(onFocusListener);
        }
    }

    public void onDestroy() {
        stop();
        arSceneView.destroy();
    }

}
