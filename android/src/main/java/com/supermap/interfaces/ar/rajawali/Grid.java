package com.supermap.interfaces.ar.rajawali;

import android.opengl.GLES20;
import org.rajawali3d.materials.Material;
import org.rajawali3d.math.vector.Vector3;
import org.rajawali3d.primitives.Line3D;

import java.util.Stack;

/**
 * Rajawali object which represents the 'floor' of the current scene.
 * This is a static grid placed in the scene to provide perspective in the
 * various views.
 */
public class Grid extends Line3D {
    public Grid(int size, int step, float thickness, int color) {
        super(calculatePoints(size, step), thickness, color);
        Material material = new Material();
        material.setColor(color);
        this.setMaterial(material);
    }

    private static Stack<Vector3> calculatePoints(int size, int step) {
        Stack<Vector3> points = new Stack<Vector3>();

        // Rows
        for (float i = -size / 2f; i <= size / 2f; i += step) {
            points.add(new Vector3(i, 0, -size / 2f));
            points.add(new Vector3(i, 0, size / 2f));
        }

        // Columns
        for (float i = -size / 2f; i <= size / 2f; i += step) {
            points.add(new Vector3(-size / 2f, 0, i));
            points.add(new Vector3(size / 2f, 0, i));
        }

        return points;
    }

    @Override
    protected void init(boolean createVBOs) {
        super.init(createVBOs);
        setDrawingMode(GLES20.GL_LINES);
    }
}
