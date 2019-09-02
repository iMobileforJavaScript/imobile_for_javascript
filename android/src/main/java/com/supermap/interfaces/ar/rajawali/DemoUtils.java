package com.supermap.interfaces.ar.rajawali;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.Gravity;
import android.widget.Toast;
import com.google.ar.core.ArCoreApk;
import com.google.ar.core.Config;
import com.google.ar.core.Session;
import com.google.ar.core.exceptions.*;

public class DemoUtils {
  private static final String TAG = "SceneformDemoUtils";

  public static void displayError(
      final Context context, final String errorMsg, @Nullable final Throwable problem) {
    final String tag = context.getClass().getSimpleName();
    final String toastText;
    if (problem != null && problem.getMessage() != null) {
      Log.e(tag, errorMsg, problem);
      toastText = errorMsg + ": " + problem.getMessage();
    } else if (problem != null) {
      Log.e(tag, errorMsg, problem);
      toastText = errorMsg;
    } else {
      Log.e(tag, errorMsg);
      toastText = errorMsg;
    }

    new Handler(Looper.getMainLooper())
        .post(
                new Runnable() {
                  @Override
                  public void run() {
                    Toast toast = Toast.makeText(context, toastText, Toast.LENGTH_LONG);
                    toast.setGravity(Gravity.CENTER, 0, 0);
                    toast.show();
                  }
                });
  }

  private static final String CAMERA_PERMISSION = Manifest.permission.CAMERA;
  private static final String LOCATION_PERMISSION = Manifest.permission.ACCESS_FINE_LOCATION;

  private static boolean hasPermission(Activity activity) {
    return ContextCompat.checkSelfPermission(activity, CAMERA_PERMISSION)
            == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(activity, LOCATION_PERMISSION)
            == PackageManager.PERMISSION_GRANTED;
  }

  public static Session createArSession(Activity activity, boolean installRequested)
      throws UnavailableException {
    Session session = null;
    if (hasPermission(activity)) {
      switch (ArCoreApk.getInstance().requestInstall(activity, !installRequested)) {
        case INSTALL_REQUESTED:
          return null;
        case INSTALLED:
          break;
      }
      session = new Session(activity);

      Config config = new Config(session);
      config.setUpdateMode(Config.UpdateMode.LATEST_CAMERA_IMAGE);
      session.configure(config);
    }
    return session;
  }


  public static void handleSessionException(
      Activity activity, UnavailableException sessionException) {

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
      Log.e(TAG, "Exception: " + sessionException);
    }
    Toast.makeText(activity, message, Toast.LENGTH_LONG).show();
  }
}
