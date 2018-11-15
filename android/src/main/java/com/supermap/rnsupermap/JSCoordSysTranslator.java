package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.Enum;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Geometry;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Point3D;
import com.supermap.data.Point3Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSCoordSysTranslator extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSCoordSysTranslator";
    CoordSysTranslator m_PrjCoordSys;

    public JSCoordSysTranslator(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    /**
     * 根据源投影坐标系与目标投影坐标系对几何对象进行投影转换，结果将直接改变源几何对象
     * @param geometryId
     * @param sourcePrjCoordSysId
     * @param targetPrjCoordSysId
     * @param coordSysTransParameterId
     * @param coordSysTransMethod
     * @param promise
     */
    @ReactMethod
    public static void convertByGeometry(String geometryId, String sourcePrjCoordSysId, String targetPrjCoordSysId,
                               String coordSysTransParameterId, int coordSysTransMethod, Promise promise) {
        try{
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            PrjCoordSys sourcePrjCoordSys = JSPrjCoordSys.getObjFromList(sourcePrjCoordSysId);
            PrjCoordSys targetPrjCoordSys = JSPrjCoordSys.getObjFromList(targetPrjCoordSysId);
            CoordSysTransParameter coordSysTransParameter = JSCoordSysTransParameter.getObjFromList(coordSysTransParameterId);
            CoordSysTransMethod method = (CoordSysTransMethod) Enum.parse(CoordSysTransMethod.class, coordSysTransMethod);


            boolean result = CoordSysTranslator.convert(geometry, sourcePrjCoordSys, targetPrjCoordSys, coordSysTransParameter, method);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
     * @param point2DIds
     * @param sourcePrjCoordSysId
     * @param targetPrjCoordSysId
     * @param coordSysTransParameterId
     * @param coordSysTransMethod
     * @param promise
     */
    @ReactMethod
    public static void convertByPoint2Ds(ReadableArray point2DIds, String sourcePrjCoordSysId, String targetPrjCoordSysId,
                                         String coordSysTransParameterId, int coordSysTransMethod, Promise promise) {
        try{
            Point2Ds point2Ds = new Point2Ds();
            for (int i = 0; i < point2DIds.size(); i++) {
                Point2D point2D = JSPoint2D.getObjFromList(point2DIds.getString(i));
                point2Ds.add(point2D);
            }

            PrjCoordSys sourcePrjCoordSys = JSPrjCoordSys.getObjFromList(sourcePrjCoordSysId);
            PrjCoordSys targetPrjCoordSys = JSPrjCoordSys.getObjFromList(targetPrjCoordSysId);
            CoordSysTransParameter coordSysTransParameter = JSCoordSysTransParameter.getObjFromList(coordSysTransParameterId);
            CoordSysTransMethod method = (CoordSysTransMethod) Enum.parse(CoordSysTransMethod.class, coordSysTransMethod);

            boolean result = CoordSysTranslator.convert(point2Ds, sourcePrjCoordSys, targetPrjCoordSys, coordSysTransParameter, method);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据源投影坐标系与目标投影坐标系对三维点集合对象进行投影转换，结果将直接改变源坐标点串
     * @param point3DIds
     * @param sourcePrjCoordSysId
     * @param targetPrjCoordSysId
     * @param coordSysTransParameterId
     * @param coordSysTransMethod
     * @param promise
     */
    @ReactMethod
    public static void convertByPoint3Ds(ReadableArray point3DIds, String sourcePrjCoordSysId, String targetPrjCoordSysId,
                               String coordSysTransParameterId, int coordSysTransMethod, Promise promise) {
        try{
            Point3Ds point3Ds = new Point3Ds();
            for (int i = 0; i < point3DIds.size(); i++) {
                Point3D point3D = JSPoint3D.getObjFromList(point3DIds.getString(i));
                point3Ds.add(point3D);
            }

            PrjCoordSys sourcePrjCoordSys = JSPrjCoordSys.getObjFromList(sourcePrjCoordSysId);
            PrjCoordSys targetPrjCoordSys = JSPrjCoordSys.getObjFromList(targetPrjCoordSysId);
            CoordSysTransParameter coordSysTransParameter = JSCoordSysTransParameter.getObjFromList(coordSysTransParameterId);
            CoordSysTransMethod method = (CoordSysTransMethod) Enum.parse(CoordSysTransMethod.class, coordSysTransMethod);


            boolean result = CoordSysTranslator.convert(point3Ds, sourcePrjCoordSys, targetPrjCoordSys, coordSysTransParameter, method);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 在同一地理坐标系下，该方法用于将指定的Point2Ds 类的点对象的地理坐标转换到投影坐标
     * @param point2DIds
     * @param prjCoordSysId
     * @param promise
     */
    @ReactMethod
    public static void forward(ReadableArray point2DIds, String prjCoordSysId, Promise promise) {
        try{
            Point2Ds point2Ds = new Point2Ds();
            for (int i = 0; i < point2DIds.size(); i++) {
                Point2D point2D = JSPoint2D.getObjFromList(point2DIds.getString(i));
                point2Ds.add(point2D);
            }
            PrjCoordSys prjCoordSys = JSPrjCoordSys.getObjFromList(prjCoordSysId);


            boolean result = CoordSysTranslator.forward(point2Ds, prjCoordSys);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 在同一投影坐标系下，该方法用于将指定的Point2Ds 类的点对象的投影坐标转换到地理坐标
     * @param point2DIds
     * @param prjCoordSysId
     * @param promise
     */
    @ReactMethod
    public static void inverse(ReadableArray point2DIds, String prjCoordSysId, Promise promise) {
        try{
            Point2Ds point2Ds = new Point2Ds();
            for (int i = 0; i < point2DIds.size(); i++) {
                Point2D point2D = JSPoint2D.getObjFromList(point2DIds.getString(i));
                point2Ds.add(point2D);
            }
            PrjCoordSys prjCoordSys = JSPrjCoordSys.getObjFromList(prjCoordSysId);


            boolean result = CoordSysTranslator.inverse(point2Ds, prjCoordSys);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

