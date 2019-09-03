package com.supermap.interfaces.ar.rajawali;

import android.opengl.GLES20;

import com.supermap.data.Point3D;

import org.rajawali3d.Geometry3D;
import org.rajawali3d.Object3D;
import org.rajawali3d.materials.Material;
import org.rajawali3d.math.vector.Vector3;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.util.ArrayList;



public class Trajectory extends Object3D {

    private static final int MAX_NUMBER_OF_VERTICES = 100000;
    private Vector3 mLastPoint = new Vector3(0,0,0);
    private static final double mMinDistance = 0.05;
    private FloatBuffer mVertexBuffer;
    private int mTrajectoryCount;

    private ArrayList<Point3D> mPoseData = new ArrayList<>();


    public Trajectory(int color, float thickness){
        super();
        init(true);
        Material m = new Material();
        m.setColor(color);
        setMaterial(m);
        mVertexBuffer = ByteBuffer.allocateDirect(MAX_NUMBER_OF_VERTICES * Geometry3D.FLOAT_SIZE_BYTES * 3).order(ByteOrder.nativeOrder()).asFloatBuffer();
    }

    protected void init(boolean createVBOs){
        float[] vertices = new float[MAX_NUMBER_OF_VERTICES * 3];
        int[] indices = new int[MAX_NUMBER_OF_VERTICES];
        for(int i=0; i<indices.length; ++i){
            indices[i] = i;
        }

        setData(vertices, GLES20.GL_STATIC_DRAW,
                null, GLES20.GL_STATIC_DRAW,
                null, GLES20.GL_STATIC_DRAW,
                null,  GLES20.GL_STATIC_DRAW,
                indices, GLES20.GL_STATIC_DRAW,
                createVBOs);
    }

    public void addSegmentTo(Vector3 vertex){
        if(mTrajectoryCount >= MAX_NUMBER_OF_VERTICES){
            return;
        }
        if(mLastPoint.length() > 1e-05 && vertex.distanceTo(mLastPoint) < mMinDistance){
            return;
        }

        mVertexBuffer.position(mTrajectoryCount * 3);
        mVertexBuffer.put((float) vertex.x);
        mVertexBuffer.put((float) vertex.y);
        mVertexBuffer.put((float) vertex.z);

        //save pose data.
        mPoseData.add(new Point3D(vertex.x,vertex.y,vertex.z));

        mTrajectoryCount++;

        mLastPoint = vertex.clone();

        mGeometry.setNumIndices(mTrajectoryCount);
        mGeometry.getVertices().position(0);
        mGeometry.changeBufferData(mGeometry.getVertexBufferInfo(), mVertexBuffer, 0, mTrajectoryCount * 3);
    }

    public void resetTrajectory(){
        mTrajectoryCount = 0;
    }

    public void preRender(){
        super.preRender();
        setDrawingMode(GLES20.GL_LINE_STRIP);
    }

    public Vector3 getLastPoint(){
        return mLastPoint;
    }



    //user interface for save & load pase data.
    public void  savePoseData(ArrayList<Point3D> out){
        if(out == null){
            return;
        }
        out.clear();
        for(Point3D p : mPoseData) {
            out.add(p.clone());
        }
    }

    public void clearPoseData(){
        mPoseData.clear();//also clear pose data.

        this.mVertexBuffer.clear();
        mTrajectoryCount = 0;

        mGeometry.setNumIndices(mTrajectoryCount);
        mGeometry.getVertices().position(0);
        mGeometry.changeBufferData(mGeometry.getVertexBufferInfo(), mVertexBuffer, 0, mTrajectoryCount * 3);
    }

    public void loadPoseData(ArrayList<Point3D> src){
        if(src == null ||src.size() == 0){
            return;
        }

        synchronized (Trajectory.this){

            clearPoseData();

            System.out.println("Seperator.");
            for(int i = 0;i<src.size();i++){
                mVertexBuffer.put((float) src.get(i).getX());
                mVertexBuffer.put((float) src.get(i).getY());
                mVertexBuffer.put((float) src.get(i).getZ());
                mTrajectoryCount++;
            }
            Point3D lastPosePoint;
            if(src.size() == 1){
                 lastPosePoint = src.get(0);
            }else{
                 lastPosePoint = src.get(src.size()- 1);
            }
            mLastPoint = new Vector3(lastPosePoint.getX(),lastPosePoint.getY(),lastPosePoint.getZ());

            mVertexBuffer.position(mTrajectoryCount * 3);

            mGeometry.setNumIndices(mTrajectoryCount);
            mGeometry.getVertices().position(0);
            mGeometry.changeBufferData(mGeometry.getVertexBufferInfo(), mVertexBuffer, 0, mTrajectoryCount * 3);
        }



    }

    //----------------------------------------




}

