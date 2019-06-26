package com.supermap.interfaces.ar;

import android.content.Context;
import android.opengl.GLU;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

/**
 * Created by ypp on 2019.5.27
 */

public class DynamicArrowRender extends AbstractMyRender {
    private boolean isEnable = true;
    private boolean isPortrait = true;
    private int POI_Guide_Mode = 1;

    DynamicArrowRender() {
    }

    @Override
    public void onSurfaceCreated(GL10 gl10, EGLConfig eglConfig) {
        gl10.glClearColor(0, 0, 0, 0f);                    //        清屏色
        gl10.glEnableClientState(GL10.GL_VERTEX_ARRAY); //        启用顶点缓冲区数组
        gl10.glEnableClientState(GL10.GL_COLOR_ARRAY);  //        颜色缓冲区
        gl10.glEnable(GL10.GL_DEPTH_TEST);              //        启用深度测试
    }

    @Override
    public void onSurfaceChanged(GL10 gl10, int i, int i1) {
        gl10.glViewport(0, 0, i, i1);
//        ratio = (float)i/(float)i1;
        gl10.glMatrixMode(GL10.GL_PROJECTION);
        gl10.glLoadIdentity();
//      gl10.glFrustumf(-ratio,ratio,-1,1,3f,7f);
        gl10.glFrustumf(-1, 1, -2, 2, 3f, 50f);  //default
//      gl10.glFrustumf(-2,2,-1,1,3f,50f);
//      gl10.glFrustumf(-2,2,-2,2,3f,50f);

    }

    public void setEnable(boolean enable) {
        this.isEnable = enable;
    }

    public void setPortrait(boolean isPortrait) {
        this.isPortrait = isPortrait;
    }

    public void setGuideMode(int POI_Guide_Mode) {
        this.POI_Guide_Mode = POI_Guide_Mode;
    }

    @Override
    public void onDrawFrame(GL10 gl10) {
        gl10.glClear(GL10.GL_COLOR_BUFFER_BIT | GL10.GL_DEPTH_BUFFER_BIT);

        if (!isEnable) {
            return;
        }

        gl10.glMatrixMode(GL10.GL_MODELVIEW);
        gl10.glLoadIdentity();

        gl10.glTranslatef(0, -2.5f, 0);

        GLU.gluLookAt(gl10, 0, 0, 5, 0, 0, 0, 0, 1, 0);

        if (isPortrait) {
            gl10.glRotatef(xrotate, 1, 0, 0);
            gl10.glRotatef(yrotate, 0, 1, 0);
        } else {
            gl10.glRotatef(-yrotate, 1, 0, 0);
            gl10.glRotatef(xrotate, 0, 1, 0);
        }

        gl10.glRotatef(zrotate, 0, 0, 1);  //跟随着方位角旋转


        //这个地方控制箭头绘制，绘制左右直线
        if (POI_Guide_Mode == 0) { //右转
            new drawArrowRIght(gl10, 8).Draw();
        } else if (POI_Guide_Mode == 1) { //直行
            new drawArrowStraight(gl10, 8).Draw();
        } else if (POI_Guide_Mode == 2) { //左转
            new drawArrowLeft(gl10, 8).Draw();
        }

    }


    //  直行
    public static class drawArrowStraight {
        public int times;
        private GL10 gl10;

        public void Draw() {
            int i = 0;
            for (i = 0; i < times; i++) {
                BufferUtil.DrawArrow(gl10, i, 40);
                gl10.glTranslatef(0f, 1f, 0f);
            }
        }

        public drawArrowStraight(GL10 gl10, int times) {
            this.gl10 = gl10;
            this.times = times;
        }
    }

    //  左转
    public static class drawArrowLeft {
        public int times;
        private GL10 gl10;

        public void Draw() {
            int i = 0;
            for (i = 0; i < times; i++) {
                BufferUtil.DrawArrow(gl10, i, 40);
                gl10.glTranslatef(0f, 1f, 0f);
            }
            gl10.glRotatef(90, 0, 0, 1);
            for (; i < times + 5; i++) {
                BufferUtil.DrawArrow(gl10, i, 40);
                gl10.glPushMatrix();
                gl10.glTranslatef(0f, 0.62f, 0f);
            }
        }

        public drawArrowLeft(GL10 gl10, int times) {
            this.gl10 = gl10;
            this.times = times;
        }
    }

    //  右转
    public static class drawArrowRIght {
        public int times;
        private GL10 gl10;

        public void Draw() {
            int i = 0;
            for (i = 0; i < times; i++) {
                BufferUtil.DrawArrow(gl10, i, 40);
                gl10.glTranslatef(0f, 0.5f, 0f);  //0.5表示间距
            }
            gl10.glRotatef(-90, 0, 0, 1);
            for (; i < times + 5; i++) {
                BufferUtil.DrawArrow(gl10, i, 40);
                gl10.glPushMatrix();
                gl10.glTranslatef(0f, 0.62f, 0f);
            }
        }

        public drawArrowRIght(GL10 gl10, int times) {
            this.gl10 = gl10;
            this.times = times;
        }
    }


    //  预留，控制指引动态增减
    public static class getDistance {
        public static int Distance;
        public static int DrawNum;

        public static int getDrawNum() {
            return DrawNum;
        }

        public void setDrawNum(int drawNum) {
            DrawNum = drawNum;
        }

        public static int getDistance() {
            return Distance;
        }

        public void setDistance(int distance) {
            Distance = distance;
        }
    }

}

