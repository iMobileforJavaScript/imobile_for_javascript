package com.supermap.interfaces.analyst;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.analyst.networkanalyst.TransportationAnalyst;
import com.supermap.analyst.networkanalyst.TransportationAnalystParameter;
import com.supermap.analyst.networkanalyst.TransportationAnalystResult;
import com.supermap.analyst.networkanalyst.TransportationAnalystSetting;
import com.supermap.analyst.networkanalyst.WeightFieldInfo;
import com.supermap.analyst.networkanalyst.WeightFieldInfos;
import com.supermap.data.Color;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasource;
import com.supermap.data.GeoLineM;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoStyle;
import com.supermap.data.Geometry;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;
import com.supermap.smNative.Network_tool;
import com.supermap.smNative.SMParameter;

import java.util.ArrayList;
import java.util.Map;

public class SNetworkAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SNetworkAnalyst";
    public Layer layer;
    public Layer nodeLayer;
    public Selection selection;
    public  ArrayList<Integer> elementIDs;
    public int startNodeID;
    public int endNodeID;
    public Point2D startPoint;
    public Point2D endPoint;
    public  ArrayList<Integer> middleNodeIDs;
    ReactContext mReactContext;

    public SNetworkAnalyst(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    private GeoStyle getGeoStyle(Size2D size2D, Color color) {
        GeoStyle geoStyle = new GeoStyle();
        geoStyle.setMarkerSize(size2D);
        geoStyle.setLineColor(color);
        return geoStyle;
    }

    public void displayResult(int[] ids, Selection selection) {
        if (selection != null) {
            TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();
            for (int i = 0; i < ids.length; i++) {
                selection.add(ids[i]);
            }
            Recordset recordset = selection.toRecordset();
            while (!recordset.isEOF()) {
                Geometry geometry = recordset.getGeometry();
                GeoStyle style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
                geometry.setStyle(style);
                trackingLayer.add(geometry, "");
                recordset.moveNext();
            }
            SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
        }
    }

    public void clear() {
        if (this.selection != null) {
            this.selection.clear();
        }
        SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer().clear();
    }

    public int selectPoint(ReadableMap point, Layer nodeLayer, GeoStyle geoStyle, String tag) {
        int ID = -1;

        double x = point.getDouble("x");
        double y = point.getDouble("y");
        Point p = new Point((int)x, (int)y);

        Selection hitSelection = nodeLayer.hitTestEx(p, 20);
        if (hitSelection != null && hitSelection.getCount() > 0) {
            Recordset rs = hitSelection.toRecordset();
            GeoPoint geoPoint = (GeoPoint)rs.getGeometry();
            ID = rs.getID();

            GeoStyle style = geoStyle;
            if (style == null) {
                style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
                style.setMarkerSymbolID(3614);
            }
            geoPoint.setStyle(style);

            TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();
            trackingLayer.add(geoPoint, tag);
            SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();

            geoPoint.dispose();
            rs.close();
            rs.dispose();
        }
        return ID;
    }

    public Point2D selectByPoint(ReadableMap point, Layer nodeLayer, GeoStyle geoStyle, String tag) {
        Point2D point2D = null;

        double x = point.getDouble("x");
        double y = point.getDouble("y");
        Point p = new Point(Integer.parseInt(x + ""), Integer.parseInt(y + ""));

        Selection hitSelection = nodeLayer.hitTestEx(p, 20);
        if (hitSelection != null && hitSelection.getCount() > 0) {
            Recordset rs = hitSelection.toRecordset();
            GeoPoint geoPoint = (GeoPoint)rs.getGeometry();
            point2D = geoPoint.getInnerPoint();

            GeoStyle style = geoStyle;
            if (style == null) {
                style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
                style.setMarkerSymbolID(3614);
            }
            geoPoint.setStyle(style);

            TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();
            trackingLayer.add(geoPoint, tag);
            SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();

            geoPoint.dispose();
            rs.close();
            rs.dispose();
        }
        return point2D;
    }

    public void removeTagFromTrackingLayer(String tag) {
        TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();
        for (int i = 0; i < trackingLayer.getCount(); i++) {
            String currentTag = trackingLayer.getTag(i);
            if (currentTag.equals(tag)) {
                trackingLayer.remove(i);
                break;
            }
        }
    }
}