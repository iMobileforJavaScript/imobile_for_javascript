package com.supermap.interfaces.ar;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.PixelFormat;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.opengl.GLSurfaceView;
import android.view.View;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.supermap.component.ArrowRenderGLSurfaceView;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by zzb on 2019/06/18.
 */
public class RCTArrowRenderView extends SimpleViewManager<ArrowRenderGLSurfaceView> {

    public static final String REACT_CLASS="RCTArrowRenderView";

    ThemedReactContext m_ThemedReactContext;

    private DynamicArrowRender render;//AR动态导航渲染

    private SensorManager mSensorManager = null;
    private Sensor mOrientationSensor = null;
    private Sensor mGravitySensor;  //加入重力传感器，检测设备面部是否朝下
    private Sensor mAccelerometerSensor;
    private Sensor mMagneticField;


    private static int indexOfChange = 0;

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public ArrowRenderGLSurfaceView createViewInstance(ThemedReactContext reactContext){
        m_ThemedReactContext = reactContext;

        //--------------------传感器
        mSensorManager = (SensorManager) m_ThemedReactContext.getCurrentActivity().getSystemService(Context.SENSOR_SERVICE);

        mOrientationSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ORIENTATION);  //方向传感器
        mGravitySensor = mSensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY); //重力传感器
        mAccelerometerSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);//加速度传感器
        mMagneticField = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);//磁场传感器

        mSensorManager.registerListener(sensorEventListener, mOrientationSensor, SensorManager.SENSOR_DELAY_NORMAL);
        mSensorManager.registerListener(sensorEventListener, mGravitySensor, SensorManager.SENSOR_DELAY_NORMAL);
        mSensorManager.registerListener(sensorEventListener, mAccelerometerSensor, SensorManager.SENSOR_DELAY_NORMAL);
        mSensorManager.registerListener(sensorEventListener, mMagneticField, SensorManager.SENSOR_DELAY_NORMAL);

        //----------------------  AR绘制控制----------------------
        render = new DynamicArrowRender();
        Timer timer = new Timer();
        timer.schedule(new TimerTask() {
            public void run() {
                BufferUtil.indexOfDraw = indexOfChange % 15;  //15代表总箭头个数
                indexOfChange++;
            }
        }, 1000, 200);
        //---------------------------------------------------------

        ArrowRenderGLSurfaceView glSurfaceView = new ArrowRenderGLSurfaceView(m_ThemedReactContext.getCurrentActivity());

        glSurfaceView.setZOrderOnTop(true);  //Opengl es 1.0 .
        glSurfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 0);//这一步和下面的setFormat都是为了能够使surfaceView能够显示出来
//        glSurfaceView.setZOrderMediaOverlay(true);
        glSurfaceView.setRenderer(render);
        glSurfaceView.setRenderMode(GLSurfaceView.RENDERMODE_CONTINUOUSLY);//GLSurfaceView.RENDERMODE_CONTINUOUSLY:持续渲染(默认)
        //GLSurfaceView.RENDERMODE_WHEN_DIRTY:脏渲染,命令渲染
        glSurfaceView.getHolder().setFormat(PixelFormat.TRANSLUCENT);//设置glview为透明的

        return glSurfaceView;
    }

    @ReactProp(name = "orientation", defaultInt = 1)
    public void setOrientation(GLSurfaceView view, int orientation) {
        //ORIENTATION_LANDSCAPE = 2 ; ORIENTATION_PORTRAIT = 1;
        if (view != null && render != null) {
            if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
                render.setPortrait(false);
            } else if (orientation == Configuration.ORIENTATION_PORTRAIT) {
                render.setPortrait(true);
            }
        }
    }

    @ReactProp(name = "mode", defaultInt = 1)
    public void setMode(GLSurfaceView view, int mode) {
        // 0 turnRight; 1 goStraight; 2 turnLeft;
        if (view != null && render != null) {
            render.setGuideMode(mode);
        }
    }

    @ReactProp(name = "enable", defaultBoolean= true)
    public void setMode(GLSurfaceView view, boolean enable) {
        if (view != null && render != null) {
            render.setEnable(enable);
            if (enable) {
                view.setVisibility(View.VISIBLE);
            } else {
                view.setVisibility(View.GONE);
            }
        }
    }

    //注册传感器监听器
    private SensorEventListener sensorEventListener = new SensorEventListener() {
        public void onSensorChanged(SensorEvent event) {

            switch (event.sensor.getType()) {
                case Sensor.TYPE_ACCELEROMETER:
                    break;
                case Sensor.TYPE_MAGNETIC_FIELD:
                    break;
                case Sensor.TYPE_ORIENTATION:
                    render.zrotate = event.values[0];
                    render.xrotate = event.values[1];
                    render.yrotate = event.values[2];
                    break;
                default:
                    break;
            }
        }

        public void onAccuracyChanged(Sensor sensor, int accuracy) {

        }

    };


}
