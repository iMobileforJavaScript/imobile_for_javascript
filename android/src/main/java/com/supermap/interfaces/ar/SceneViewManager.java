package com.supermap.interfaces.ar;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import com.google.ar.core.Config;
import com.google.ar.core.Session;
import com.google.ar.core.exceptions.*;

import java.util.Collections;
import java.util.Set;

public class SceneViewManager extends SceneView {

    private static final String TAG = "SceneViewManager";

    public SceneViewManager(Context context) {
        super(context);
    }

    public SceneViewManager(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SceneViewManager(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    public boolean isArRequired() {
        return true;
    }

    @Override
    protected void handleSessionException(UnavailableException sessionException) {
        String message;
        if (sessionException instanceof UnavailableArcoreNotInstalledException) {
            message = "Please install ARCore";
        } else if (sessionException instanceof UnavailableApkTooOldException) {
            message = "Please update ARCore";
        } else if (sessionException instanceof UnavailableSdkTooOldException) {
            message = "Please update this app";
        } else if (sessionException instanceof UnavailableDeviceNotCompatibleException) {
            message = "This device does not support AR";
        } else {
            message = "Failed to create AR session";
        }
        Log.e(TAG, "Error: " + message, sessionException);
    }

    @Override
    protected Config getSessionConfiguration(Session session) {
        return new Config(session);
    }

    @Override
    protected Set<Session.Feature> getSessionFeatures() {
        return Collections.emptySet();
    }

}
