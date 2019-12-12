package com.supermap.smNative.components;

import android.util.Log;

import com.supermap.data.Color;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Recordset;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.TrackingLayer;
import com.supermap.navi.Navigation2;

/**
 * Author:     Asort
 * Date:        2019/12/9
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */

public class SNavigation2 {
    private MapControl mapControl;
    private Navigation2 navigation;
    private Point2D startPoint;
    private Point2D endPoint;
    private Point2D nearStartPoint;
    private Point2D nearEndPoint;
    private DatasetVector lineDataset;
    private Dataset pointDataset;
    private String modelPath;
    private GeoStyle routeStyle;
    private PrjCoordSys prjCoordSys;

    public Navigation2 getNavigation(){
        return navigation;
    }
    public SNavigation2(MapControl mapController){
        mapControl = mapController;
        navigation = mapControl.getNavigation2();
    }

    public void setNetworkDataset(DatasetVector dataset){
        lineDataset = dataset;
        pointDataset = dataset.getChildDataset();
        navigation.setNetworkDataset(dataset);
    }

    public void setRouteStyle(GeoStyle style){
        routeStyle = style;
        navigation.setRouteStyle(style);
    }

    public void setStartPoint(double x, double y) {
        startPoint = new Point2D(x, y);
        navigation.setStartPoint(x,y);
    }

    public void setDestinationPoint(double x, double y) {
        endPoint = new Point2D(x, y);
        navigation.setDestinationPoint(x,y);
    }

    public boolean loadModel(String filePath){
        modelPath = filePath;
        return navigation.loadModel(filePath);
    }

    /**
     * 重新进行路径分析 保证分析结果存在
     * @return boolean
     */
    public boolean reAnalyst(){
        try{
            GeoPoint sPoint = new GeoPoint(startPoint);
            DatasetVector datasetVector = (DatasetVector)pointDataset;
            Recordset recordset = datasetVector.query(sPoint,0.001,CursorType.STATIC);
            if(recordset.getRecordCount() == 0){
                recordset = datasetVector.query(sPoint,0.005,CursorType.STATIC);
            }
            Geometry geo = null;
            double dLen = 1000000.0;
            while (!recordset.isEOF()){
                geo = recordset.getGeometry();
                Point2D tmpPoint = geo.getInnerPoint();
                double len = Math.sqrt( Math.pow( (startPoint.getX() - tmpPoint.getX()),2) + Math.pow( (startPoint.getY() - tmpPoint.getY()),2));
                if(dLen > len){
                    Recordset lineRecordset = lineDataset.query(geo,0,CursorType.STATIC);
                    if(lineRecordset.getRecordCount() != 0){
                        dLen = len;
                        nearStartPoint = tmpPoint;
                    }
                    lineRecordset.close();
                    lineRecordset.dispose();
                }

                recordset.moveNext();
            }
            recordset.close();
            recordset.dispose();

            GeoPoint ePoint = new GeoPoint(endPoint);
            Recordset recordset1 = datasetVector.query(ePoint,0.001,CursorType.STATIC);
            if(recordset1.getRecordCount() == 0){
                recordset1 = datasetVector.query(ePoint,0.005,CursorType.STATIC);
            }

            double dLen1 = 1000000.0;
            while (!recordset1.isEOF()){
                geo = recordset1.getGeometry();
                Point2D tmpPoint = geo.getInnerPoint();
                double len = Math.sqrt( Math.pow( (endPoint.getX() - tmpPoint.getX()),2) + Math.pow( (endPoint.getY() - tmpPoint.getY()),2));
                if(dLen1 > len){
                    Recordset lineRecordset = lineDataset.query(geo,0,CursorType.STATIC);
                    if(lineRecordset.getRecordCount() != 0){
                        dLen1 = len;
                        nearEndPoint = tmpPoint;
                    }
                    lineRecordset.close();
                    lineRecordset.dispose();
                }

                recordset1.moveNext();
            }
            recordset1.close();
            recordset1.dispose();
            if(geo != null){
                geo.dispose();
            }

            boolean isFind = false;
            if(nearStartPoint != null && nearEndPoint != null){
                navigation.setStartPoint(nearStartPoint.getX(),nearStartPoint.getY());
                navigation.setDestinationPoint(nearEndPoint.getX(),nearEndPoint.getY());
                isFind = navigation.routeAnalyst();
                if(!isFind){
                    startPoint = null;
                    endPoint = null;
                    nearStartPoint = null;
                    nearEndPoint = null;
                }
            }
            return isFind;
        }catch (Exception e){
            Log.e("ReAnalyst Error",e.toString());
            return false;
        }
    }

    /**
     * 添加引导线（起点和起点邻近点、终点和终点临界点的 之间的虚线）
     * @param mapPrjCoordSys
     */
    public void addGuideLineOnTrackingLayer(PrjCoordSys mapPrjCoordSys){
        prjCoordSys = mapPrjCoordSys;
        Point2D start = getMapPoint(startPoint,prjCoordSys);
        Point2D nearStart = getMapPoint(nearStartPoint,prjCoordSys);
        Point2D end = getMapPoint(endPoint,prjCoordSys);
        Point2D nearEnd = getMapPoint(nearEndPoint,prjCoordSys);

        TrackingLayer layer = mapControl.getMap().getTrackingLayer();

        GeoStyle guideLine = new GeoStyle();
        guideLine.setLineWidth(2.0);
        guideLine.setLineColor(new Color(82,198,233));
        guideLine.setLineSymbolID(2);

        Point2Ds startPoints = new Point2Ds();
        startPoints.add(start);
        startPoints.add(nearStart);

        GeoLine startLine = new GeoLine(startPoints);
        startLine.setStyle(guideLine);
        layer.add(startLine,"startLine");

        Point2Ds endPoints = new Point2Ds();
        endPoints.add(end);
        endPoints.add(nearEnd);

        GeoLine endLine = new GeoLine(endPoints);
        endLine.setStyle(routeStyle);
        layer.add(endLine,"endLine");

        mapControl.getMap().refresh();

        startPoint = null;
        endPoint = null;
        nearStartPoint = null;
        nearEndPoint = null;
    }

    private Point2D getMapPoint(Point2D pt, PrjCoordSys prjCoordSys){
        Point2D point2D = null;
        double x = pt.getX();
        double y = pt.getY();
        if(x > -180 && x < 180 && y > -90 && y < 90){
            Point2Ds point2Ds = new Point2Ds();
            point2Ds.add(pt);
            PrjCoordSys desPrjCoordSys = new PrjCoordSys();
            desPrjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            CoordSysTranslator.convert(point2Ds,desPrjCoordSys,prjCoordSys,new CoordSysTransParameter(),CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
            point2D = point2Ds.getItem(0);
        }else{
            point2D = pt;
        }
        return point2D;
    }
}
