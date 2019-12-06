package com.supermap.interfaces.analyst;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.data.Color;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoStyle;
import com.supermap.data.GeoText;
import com.supermap.data.Geometry;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.data.TextPart;
import com.supermap.data.TextStyle;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Selection;
import com.supermap.mapping.TrackingLayer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import de.javagl.obj.Obj;

class History {
    private int currentIndex;

    private ArrayList<HashMap> history;

    public History() {
        history = new ArrayList<>();
    }

    public int getCount() {
        return history.size();
    }

    public int getCurrentIndex() {
        return currentIndex;
    }

    public ArrayList<HashMap> getAllHistory() {
        return history;
    }

    public ArrayList<HashMap> getHistory() {
        return (ArrayList<HashMap>)history.subList(0, currentIndex);
    }

    public HashMap get(int index) {
        return history.get(index);
    }

    public void addHistory(HashMap obj) {
        if (currentIndex < history.size() - 1) {
            List list = history.subList(0, currentIndex + 1);
            ArrayList<HashMap> temp = new ArrayList<>();
            for (int i = 0; i < list.size(); i++) {
                temp.add((HashMap) list.get(i));
            }
            history = temp;
        }
        history.add(obj);
        currentIndex = history.size() - 1;
    }

    public void remove(int index) {
        history.remove(index);
        currentIndex -= 1;
    }

    public void remove(Object obj) {
        history.remove(obj);
        currentIndex -= 1;
    }

    public void clear() {
        history.clear();
        currentIndex = -1;
    }

    public int undo() {
        int preIndex = currentIndex >= 0 ? currentIndex : -1;
        if (currentIndex > -1) {
            currentIndex--;
        }
        return preIndex;
    }

    public int redo() {
        int preIndex = currentIndex < history.size() - 1 ? currentIndex : (history.size() - 1);
        if (currentIndex < history.size() - 1) {
            currentIndex++;
        }
        return preIndex;
    }
}

public class SNetworkAnalyst extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SNetworkAnalyst";
    public Layer layer;
    public Layer nodeLayer;
    public Selection selection;
    public ArrayList<Integer> elementIDs;
    public int startNodeID;
    public int endNodeID;
    public Point2D startPoint;
    public Point2D endPoint;
    public ArrayList<Integer> middleNodeIDs;
    public History history;
    ReactContext mReactContext;

    public static String routeTag = "route";

    public SNetworkAnalyst(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
        history = new History();
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

    public void clearRoutes() {
        if (this.selection != null) {
            this.selection.clear();
        }
        TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();
        int routeIndex = trackingLayer.indexOf(routeTag);
        while (routeIndex >= 0) {
            trackingLayer.remove(routeIndex);
            routeIndex = trackingLayer.indexOf(routeTag);
        }
    }

    public int selectNode(ReadableMap point, Layer nodeLayer, GeoStyle geoStyle, String tag) {
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

            HashMap nodeMap = new HashMap();
            HashMap node = new HashMap();
            node.put("x", x);
            node.put("y", y);
            nodeMap.put("tag", tag);
            nodeMap.put("node", node);
            if (history == null) {
                history = new History();
            }
            history.addHistory(nodeMap);

            geoPoint.dispose();
            rs.close();
            rs.dispose();
        }
        return ID;
    }

    public Point2D selectPoint(ReadableMap point, Layer nodeLayer, GeoStyle geoStyle, String tag) {
        Point2D point2D = null;
        int ID = -1;

        double x = point.getDouble("x");
        double y = point.getDouble("y");
        Point p = new Point((int)x, (int)y);

        Selection hitSelection = nodeLayer.hitTestEx(p, 20);
        if (hitSelection != null && hitSelection.getCount() > 0) {
            Recordset rs = hitSelection.toRecordset();
            GeoPoint geoPoint = (GeoPoint)rs.getGeometry();
//            point2D = geoPoint.getInnerPoint();
//            Point p2 = SMap.getInstance().getSmMapWC().getMapControl().getMap().mapToPixel(point2D);
//            map.putInt("x", p2.getX());
//            map.putInt("x", p2.getY());
            point2D = new Point2D(geoPoint.getX(), geoPoint.getY());

            GeoStyle style = geoStyle;
            if (style == null) {
                style = getGeoStyle(new Size2D(10, 10), new Color(255, 105, 0));
                style.setMarkerSymbolID(3614);
            }
            geoPoint.setStyle(style);

            TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();
            trackingLayer.add(geoPoint, tag);

            geoPoint.dispose();
            rs.close();
            rs.dispose();
        }
        return point2D;
    }

    public int setText(String text, Point2D point, TextStyle textStyle, String tag) {
        TextPart textPart = new TextPart(" " + text, point);
        GeoText geoText = new GeoText(textPart);
        if (textStyle == null) {
            textStyle = new TextStyle();
            textStyle.setFontWidth(6);
            textStyle.setFontHeight(8);
            textStyle.setForeColor(new Color(0, 0, 0));
        }
        geoText.setTextStyle(textStyle);

        TrackingLayer trackingLayer = SMap.getInstance().getSmMapWC().getMapControl().getMap().getTrackingLayer();
        int index = trackingLayer.add(geoText, tag);
        return index;
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

//    public WritableMap undo() {
//        int preIndex = history.undo();
//        WritableMap node = history.get(preIndex);
//        return node;
//    }
//
//    public void redo() {
//        history.redo();
//    }
}