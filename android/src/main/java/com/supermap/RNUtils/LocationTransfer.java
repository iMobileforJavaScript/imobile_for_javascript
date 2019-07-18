package com.supermap.RNUtils;

import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;

/**
 * @Author: shanglongyang
 * Date:        2019/7/18
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class LocationTransfer {
    public static Point2D mapCoordToLatitudeAndLongitude (Point2D point2D) {
        SMap sMap = SMap.getInstance();
        final MapControl mapControl = sMap.getSmMapWC().getMapControl();
        final Map map = mapControl.getMap();

        final Point2D pt = point2D;
        PrjCoordSys Prj = map.getPrjCoordSys();
        Point2Ds points = new Point2Ds();
        points.add(pt);
        PrjCoordSys desPrjCoorSys = new PrjCoordSys();
        desPrjCoorSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
        CoordSysTranslator.convert(points, Prj, desPrjCoorSys,
                new CoordSysTransParameter(),
                CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

        pt.setX(points.getItem(0).getX());
        pt.setY(points.getItem(0).getY());
        return pt;
    }

    public static Point2Ds mapCoordToLatitudeAndLongitude (Point2Ds point2Ds) {
        SMap sMap = SMap.getInstance();
        final MapControl mapControl = sMap.getSmMapWC().getMapControl();
        final Map map = mapControl.getMap();

        PrjCoordSys Prj = map.getPrjCoordSys();
        PrjCoordSys desPrjCoorSys = new PrjCoordSys();
        desPrjCoorSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
        CoordSysTranslator.convert(point2Ds, Prj, desPrjCoorSys,
                new CoordSysTransParameter(),
                CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
        return point2Ds;
    }

    public static Point2D latitudeAndLongitudeToMapCoord (Point2D point2D) {
        SMap sMap = SMap.getInstance();
        final MapControl mapControl = sMap.getSmMapWC().getMapControl();
        final Map map = mapControl.getMap();

        final Point2D pt = point2D;
        PrjCoordSys Prj = map.getPrjCoordSys();
        Point2Ds points = new Point2Ds();
        points.add(pt);
        PrjCoordSys desPrjCoorSys = new PrjCoordSys();
        desPrjCoorSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
        CoordSysTranslator.convert(points, desPrjCoorSys, Prj,
                new CoordSysTransParameter(),
                CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

        pt.setX(points.getItem(0).getX());
        pt.setY(points.getItem(0).getY());
        return pt;
    }

    public static Point2Ds latitudeAndLongitudeToMapCoord (Point2Ds point2Ds) {
        SMap sMap = SMap.getInstance();
        final MapControl mapControl = sMap.getSmMapWC().getMapControl();
        final Map map = mapControl.getMap();

        PrjCoordSys Prj = map.getPrjCoordSys();
        PrjCoordSys desPrjCoorSys = new PrjCoordSys();
        desPrjCoorSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
        CoordSysTranslator.convert(point2Ds, desPrjCoorSys, Prj,
                new CoordSysTransParameter(),
                CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
        return point2Ds;
    }
}
