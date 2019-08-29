package com.supermap.interfaces.ar.rajawali;

import org.rajawali3d.math.Quaternion;
import org.rajawali3d.math.vector.Vector3;

/**
 * Convenience class to encapsulate a position and orientation combination using Rajawali classes.
 */
public class Pose {
    private final Quaternion mOrientation;
    private final Vector3 mPosition;

    public Pose(Vector3 position, Quaternion orientation) {
        this.mOrientation = orientation;
        this.mPosition = position;
    }

    public Quaternion getOrientation() {
        return mOrientation;
    }

    public Vector3 getPosition() {
        return mPosition;
    }

    public String toString() {
        return "p:" + mPosition + ",q:" + mOrientation;
    }
}