package com.supermap.smNative.collector;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.supermap.RNUtils.DateUtil;
import com.supermap.RNUtils.LocationTransfer;
import com.supermap.RNUtils.MediaUtil;
import com.supermap.component.MapWrapView;
import com.supermap.data.Color;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CursorType;
import com.supermap.data.DatasetVector;
import com.supermap.data.FieldType;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoLineM;
import com.supermap.data.GeoStyle;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.data.Size2D;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.components.InfoCallout;

import java.lang.reflect.Array;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * @Author: shanglongyang
 * Date:        2019/5/28
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class SMMediaCollector {
    private static SMMediaCollector instance;
    private static String mediaPath;
    public static String sdcard = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();

    public SMMediaCollector() {
//        this.context = context;
    }

    public static SMMediaCollector getInstance() {
        if (instance == null) {
            instance = new SMMediaCollector();
        }
        return instance;
    }

    public static String getMediaPath() {
        return mediaPath;
    }

    public static void setMediaPath(String mediaPath) {
        SMMediaCollector.mediaPath = mediaPath;
    }

    public static boolean hasMediaData(Layer layer) {
        DatasetVector dsVector = (DatasetVector)layer.getDataset();

        int tag1 = dsVector.getFieldInfos().indexOf("MediaName");
        int tag2 = dsVector.getFieldInfos().indexOf("ModifiedDate");
        int tag3 = dsVector.getFieldInfos().indexOf("MediaFilePaths");
        int tag4 = dsVector.getFieldInfos().indexOf("Description");
        int tag5 = dsVector.getFieldInfos().indexOf("HttpAddress");

        if(tag1==-1 || tag2==-1 || tag3==-1 || tag4==-1 || tag5==-1)
            return false;
        if (dsVector.getFieldInfos().get(tag1).getType() != FieldType.TEXT)
            return false;
        if (dsVector.getFieldInfos().get(tag2).getType() != FieldType.TEXT)
            return false;
        if (dsVector.getFieldInfos().get(tag3).getType() != FieldType.TEXT)
            return false;
        if (dsVector.getFieldInfos().get(tag4).getType() != FieldType.TEXT)
            return false;
        if (dsVector.getFieldInfos().get(tag5).getType() != FieldType.TEXT)
            return false;
//        if (dsVector.getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)
//            return false;

        return true;
    }

    public static SMMedia findMediaByLayer(Layer layer, int geoID) {
        SMMedia smMedia = new SMMedia();

        DatasetVector dsVector = (DatasetVector)layer.getDataset();
        Recordset recordset;

        if (!hasMediaData(layer)) {
            return null;
        }

        String filter = "SmID=" + geoID;
        QueryParameter parameter = new QueryParameter();
        parameter.setAttributeFilter(filter);
        parameter.setCursorType(CursorType.STATIC);
        recordset = dsVector.query(parameter);

        smMedia.setDatasourse(layer.getDataset().getDatasource());
        smMedia.setDataset(layer.getDataset());
        smMedia.setFileName((String)recordset.getFieldValue("MediaName"));

        String paths = (String)recordset.getFieldValue("MediaFilePaths");
        if (paths == null) paths = "";
        ArrayList<String> pathArr = new ArrayList<>();
        if (paths.indexOf(",") > 0) {
            pathArr = new ArrayList<>(Arrays.asList(paths.split(",")));
        } else {
            pathArr.add(paths);
        }
        smMedia.setPaths(pathArr);

        double x = recordset.getGeometry().getInnerPoint().getX();
        double y = recordset.getGeometry().getInnerPoint().getY();
        smMedia.setLocation(new Point2D(x, y));

        recordset.dispose();

        return smMedia;
    }

    public static ArrayList<SMMedia>findMediasByLayer(Layer layer) {
        ArrayList<SMMedia> medias = new ArrayList<>();

        DatasetVector datasetVector = (DatasetVector)layer.getDataset();

        if (!hasMediaData(layer)) {
            return null;
        }

        Recordset recordset = datasetVector.getRecordset(false, CursorType.STATIC);
        recordset.moveFirst();

        while (!recordset.isEOF()) {
            SMMedia media = new SMMedia();

            media.setDatasourse(layer.getDataset().getDatasource());
            media.setDataset(layer.getDataset());
            media.setFileName((String)recordset.getFieldValue("MediaName"));

            String paths = (String)recordset.getFieldValue("MediaFilePaths");
            ArrayList<String> pathArr = (ArrayList<String>)Arrays.asList(paths.split(","));
            media.setPaths(pathArr);

            double x = recordset.getGeometry().getInnerPoint().getX();
            double y = recordset.getGeometry().getInnerPoint().getY();
            media.setLocation(new Point2D(x, y));

            medias.add(media);

            recordset.moveNext();
        }

        recordset.dispose();

        return medias;
    }

    public static void addMedias(Context context, Layer layer, View.OnTouchListener listener) {
        if (hasMediaData(layer)) {
            DatasetVector datasetVector = (DatasetVector)layer.getDataset();
            Recordset recordset = datasetVector.getRecordset(false, CursorType.STATIC);
            recordset.moveFirst();
            while (!recordset.isEOF()) {
                SMMedia media = new SMMedia();

                media.setDatasourse(layer.getDataset().getDatasource());
                media.setDataset(layer.getDataset());
                media.setFileName((String)recordset.getFieldValue("MediaName"));

                String paths = (String)recordset.getFieldValue("MediaFilePaths");
                ArrayList<String> pathArr = new ArrayList<>(Arrays.asList(paths.split(",")));
                media.setPaths(pathArr);

                double x = recordset.getGeometry().getInnerPoint().getX();
                double y = recordset.getGeometry().getInnerPoint().getY();
                media.setLocation(new Point2D(x, y));

                String imgPath = sdcard + media.getPaths().get(0);
                InfoCallout callout = SMLayer.addCallOutWithLongitude(context, x, y, imgPath);
                callout.setMediaName(media.getFileName());
                callout.setMediaFilePaths(media.getPaths());
                callout.setLayerName(layer.getName());
                callout.setHttpAddress("");
                callout.setDescription("");

                Date date = new Date();
                callout.setModifiedDate(DateUtil.formatDateToString(date, "yyyy-MM-dd HH:mm:ss"));
                callout.setGeoID(Integer.parseInt(recordset.getFieldValue("SmID").toString()));

                if (listener != null) {
                    callout.setOnTouchListener(listener);
                }

                recordset.moveNext();
            }

            recordset.dispose();
        }
    }

    public static void showMediasByLayer(Context context, Layer layer, View.OnTouchListener listener) {
        if (hasMediaData(layer)) {
            DatasetVector datasetVector = (DatasetVector)layer.getDataset();
            Recordset recordset = datasetVector.getRecordset(false, CursorType.STATIC);
            recordset.moveFirst();
            ArrayList<InfoCallout> callouts = new ArrayList<>();
            while (!recordset.isEOF()) {
                String paths = (String)recordset.getFieldValue("MediaFilePaths");
                String fileName = (String)recordset.getFieldValue("MediaName");
                if (paths == null && (fileName == null || fileName.equals("TourLine"))) {
                    recordset.moveNext();
                    continue;
                }
                SMMedia media = new SMMedia();

                media.setDatasourse(layer.getDataset().getDatasource());
                media.setDataset(layer.getDataset());
                media.setFileName(fileName);
                ArrayList<String> pathArr;
                if (paths != null) {
                    pathArr = new ArrayList<>(Arrays.asList(paths.split(",")));
                } else {
                    pathArr = new ArrayList<>();
                }
                media.setPaths(pathArr);

                double x = recordset.getGeometry().getInnerPoint().getX();
                double y = recordset.getGeometry().getInnerPoint().getY();
                media.setLocation(new Point2D(x, y));

                InfoCallout callout = getCalloutByMedia(context, media, recordset, layer.getName(), listener);

                callouts.add(callout);
                recordset.moveNext();
            }

            addCallouts(callouts);

            recordset.dispose();
        }
    }

    public static InfoCallout getCalloutByMedia(Context context, SMMedia media, Recordset recordset, String layerName, View.OnTouchListener listener) {
        int imgSize = 60;

        Point2D pt = new Point2D(media.getLocation().getX(), media.getLocation().getY());

        final InfoCallout callout = new InfoCallout(context);

        String imagePath = sdcard + media.getPaths().get(0);
        String extension = imagePath.substring(imagePath.lastIndexOf(".") + 1);

        final ImageView img = new ImageView(context);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(imgSize, imgSize);
        img.setLayoutParams(layoutParams);
        img.setMinimumHeight(imgSize);
        img.setMinimumWidth(imgSize);

        if (extension.equals("mp4")) {
            img.setImageBitmap(MediaUtil.getScreenShotImageFromVideoPath(imagePath, imgSize, imgSize));
        } else {
            img.setImageBitmap(MediaUtil.getLocalBitmap(imagePath, imgSize, imgSize));
        }
        callout.setContentView(img);
        callout.setLocation(pt.getX(), pt.getY());

        callout.setMediaName(media.getFileName());
        callout.setMediaFilePaths(media.getPaths());
        callout.setLayerName(layerName);
        callout.setHttpAddress("");
        callout.setDescription("");


        Date date = new Date();
        callout.setModifiedDate(DateUtil.formatDateToString(date, "yyyy-MM-dd HH:mm:ss"));
        callout.setGeoID(Integer.parseInt(recordset.getFieldValue("SmID").toString()));

        if (listener != null) {
            callout.setOnTouchListener(listener);
        }

        return callout;
    }

    public static InfoCallout createCalloutByMedia(Context context, SMMedia media, Recordset recordset, String layerName, View.OnTouchListener listener) {
        int imgSize = 60;

        Point2D pt = new Point2D(media.getLocation().getX(), media.getLocation().getY());

        final InfoCallout callout = new InfoCallout(context);

        String imagePath = sdcard + media.getPaths().get(0);
        String extension = imagePath.substring(imagePath.lastIndexOf(".") + 1);

        final ImageView img = new ImageView(context);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(imgSize, imgSize);
        img.setLayoutParams(layoutParams);
        img.setMinimumHeight(imgSize);
        img.setMinimumWidth(imgSize);

        if (extension.equals("mp4")) {
            img.setImageBitmap(MediaUtil.getScreenShotImageFromVideoPath(imagePath, imgSize, imgSize));
        } else {
            img.setImageBitmap(MediaUtil.getLocalBitmap(imagePath, imgSize, imgSize));
        }
        callout.setContentView(img);
        callout.setLocation(pt.getX(), pt.getY());

        callout.setMediaName(media.getFileName());
        callout.setMediaFilePaths(media.getPaths());
        callout.setLayerName(layerName);
        callout.setHttpAddress("");
        callout.setDescription("");

        Date date = new Date();
        callout.setModifiedDate(DateUtil.formatDateToString(date, "yyyy-MM-dd HH:mm:ss"));
        callout.setGeoID(Integer.parseInt(recordset.getFieldValue("SmID").toString()));

        String paths = "";
        for (int i = 0; i < callout.getMediaFilePaths().size(); i++) {
            paths += callout.getMediaFilePaths().get(i) + (i == callout.getMediaFilePaths().size() - 1 ? "" : ",");
        }

        recordset.edit();
        recordset.setFieldValue("ModifiedDate", callout.getModifiedDate());
        recordset.setFieldValue("MediaFilePaths", paths);
        recordset.setFieldValue("Description", callout.getDescription());
        recordset.setFieldValue("HttpAddress", callout.getHttpAddress());
        recordset.update();

        if (listener != null) {
            callout.setOnTouchListener(listener);
        }

        return callout;
    }

    public static void addCallouts(final ArrayList<InfoCallout> callouts) {
        final SMap sMap = SMap.getInstance();
        sMap.getActivity().runOnUiThread(new Runnable(){
            @Override
            public void run(){
                Map map = SMap.getInstance().getSmMapWC().getMapControl().getMap();
                MapWrapView mapWrapView = (MapWrapView)map.getMapView();
                for (int i = 0; i < callouts.size(); i++) {
                    InfoCallout callout = callouts.get(i);
                    mapWrapView.addCallout(callout, callout.getID());
                }
                map.setCenter(new Point2D(callouts.get(0).getLocationX(), callouts.get(0).getLocationY()));
                if (map.getScale() < 0.000011947150294723098) {
                    map.setScale(0.000011947150294723098);
                }
                map.refresh();

                mapWrapView.showCallOut();
            }
        });
    }

    public static InfoCallout addCalloutByMedia(Context context, SMMedia media, Recordset recordset, String layerName, View.OnTouchListener listener) {
        Point2D pt = new Point2D(media.getLocation().getX(), media.getLocation().getY());

        String imgPath = sdcard + media.getPaths().get(0);
        InfoCallout callout = SMLayer.addCallOutWithLongitude(context, pt.getX(), pt.getY(), imgPath);
        callout.setMediaName(media.getFileName());
        callout.setMediaFilePaths(media.getPaths());
        callout.setLayerName(layerName);
        callout.setHttpAddress("");
        callout.setDescription("");

        Date date = new Date();
        callout.setModifiedDate(DateUtil.formatDateToString(date, "yyyy-MM-dd HH:mm:ss"));
        callout.setGeoID(Integer.parseInt(recordset.getFieldValue("SmID").toString()));

        String paths = "";
        for (int i = 0; i < callout.getMediaFilePaths().size(); i++) {
            paths += callout.getMediaFilePaths().get(i) + (i == callout.getMediaFilePaths().size() - 1 ? "" : ",");
        }

        recordset.edit();
        recordset.setFieldValue("ModifiedDate", callout.getModifiedDate());
        recordset.setFieldValue("MediaFilePaths", paths);
        recordset.setFieldValue("Description", callout.getDescription());
        recordset.setFieldValue("HttpAddress", callout.getHttpAddress());
        recordset.update();

        if (listener != null) {
            callout.setOnTouchListener(listener);
        }
        return callout;
    }

    public static void addLineByMedias(ArrayList<SMMedia> medias, DatasetVector dataset) {
        Point2Ds mPoints = new Point2Ds();
        for (int i = 0; i < medias.size(); i++) {
            Point2D pt = new Point2D(medias.get(i).getLocation().getX(), medias.get(i).getLocation().getY());
            mPoints.add(pt);
        }

        GeoLine mLine = new GeoLine(mPoints);
        GeoStyle style = new GeoStyle();
        style.setMarkerSize(new Size2D(2, 2));
        style.setLineColor(new Color(70, 128, 233));
        style.setLineWidth(1);
        style.setMarkerSymbolID(351);
        style.setFillForeColor(new Color(70, 128, 233));
        mLine.setStyle(style);

        Recordset mRecordset = dataset.getRecordset(false, CursorType.DYNAMIC);

        mRecordset.addNew(mLine);
        mRecordset.moveLast();
        if (mRecordset.edit()) {
            mRecordset.setString("MediaName", "TourLine");
        }

        mRecordset.update();
        mRecordset.dispose();
    }
}
