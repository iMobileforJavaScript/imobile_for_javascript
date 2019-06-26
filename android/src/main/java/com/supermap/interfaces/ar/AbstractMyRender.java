package com.supermap.interfaces.ar;

import android.opengl.GLSurfaceView;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

/**
 * Created by szu on 2017/2/23.
 */

public abstract class AbstractMyRender implements GLSurfaceView.Renderer {

    public int renderTimes = 0;


    public int allIndexs = 0;  //用来指代直行指引

    public float ratio;
    //    围绕X轴旋转的角度
    public float xrotate = 0f;
    //    围绕Y轴旋转的角度
    public float yrotate = 0f;
    //    围绕Z轴旋转的角度
    public float zrotate = 0f;
    /*
            这是第一步
     */

    @Override
    public void onSurfaceCreated(GL10 gl10, EGLConfig eglConfig) {
//        清屏色
        gl10.glClearColor(0f, 0f, 0f, 1f);
//        启用顶点缓冲区数组
        gl10.glEnableClientState(GL10.GL_VERTEX_ARRAY);
    }

    /*
            这是第二步
     */
    @Override
    public void onSurfaceChanged(GL10 gl10, int i, int i1) {
//设置视口
        gl10.glViewport(0, 0, i, i1);
        ratio = (float) i / (float) i1;
//      投影矩阵
        gl10.glMatrixMode(GL10.GL_PROJECTION);
//      加载单位矩阵
        gl10.glLoadIdentity();
//      设置平截头体
        gl10.glFrustumf(-ratio, ratio, -1, 1, 3f, 7f);
    }

    /*
            这是第三步
     */
    public abstract void onDrawFrame(GL10 gl10);
}
