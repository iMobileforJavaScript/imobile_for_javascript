package com.supermap.component;

import android.content.Context;
import android.opengl.GLSurfaceView;
import android.util.AttributeSet;
import android.view.MotionEvent;

public class ArrowRenderGLSurfaceView extends GLSurfaceView {

    private static final String TAG = "ArrowRenderGLSV";

    public ArrowRenderGLSurfaceView(Context context) {
        super(context);
    }

    public ArrowRenderGLSurfaceView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        return super.dispatchTouchEvent(event);
    }
}
