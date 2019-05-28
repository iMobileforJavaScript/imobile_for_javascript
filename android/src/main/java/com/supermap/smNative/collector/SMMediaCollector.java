package com.supermap.smNative.collector;

import android.content.Context;

import com.supermap.data.CursorType;
import com.supermap.data.DatasetVector;
import com.supermap.data.FieldType;
import com.supermap.data.Point2D;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.mapping.Layer;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;

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

    public static SMMedia findMediaByLayer(Layer layer, int geoID) {
        SMMedia smMedia = new SMMedia();

        DatasetVector dsVector = (DatasetVector)layer.getDataset();
        Recordset recordset;

        int tag1 = dsVector.getFieldInfos().indexOf("MediaFileName");
        int tag2 = dsVector.getFieldInfos().indexOf("ModifiedDate");
        int tag3 = dsVector.getFieldInfos().indexOf("MediaFilePaths");
        int tag4 = dsVector.getFieldInfos().indexOf("Description");
        int tag5 = dsVector.getFieldInfos().indexOf("HttpAddress");

        if(tag1==-1 || tag2==-1 || tag3==-1 || tag4==-1 || tag5==-1)
            return null;
        if (dsVector.getFieldInfos().get(tag1).getType() != FieldType.TEXT)
            return null;
        if (dsVector.getFieldInfos().get(tag2).getType() != FieldType.TEXT)
            return null;
        if (dsVector.getFieldInfos().get(tag3).getType() != FieldType.TEXT)
            return null;
        if (dsVector.getFieldInfos().get(tag4).getType() != FieldType.TEXT)
            return null;
        if (dsVector.getFieldInfos().get(tag5).getType() != FieldType.TEXT)
            return null;
        if (dsVector.getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)
            return null;

        String filter = "SmID=" + geoID;
        QueryParameter parameter = new QueryParameter();
        parameter.setAttributeFilter(filter);
        parameter.setCursorType(CursorType.STATIC);
        recordset = dsVector.query(parameter);

        smMedia.setDatasourse(layer.getDataset().getDatasource());
        smMedia.setDataset(layer.getDataset());
        smMedia.setFileName((String)recordset.getFieldValue("MediaFileName"));

        String paths = (String)recordset.getFieldValue("MediaFilePaths");
        ArrayList<String> pathArr = (ArrayList<String>)Arrays.asList(paths.split(","));
        smMedia.setPaths(pathArr);

        double x = Double.parseDouble(recordset.getFieldValue("SmX").toString());
        double y = Double.parseDouble(recordset.getFieldValue("SmY").toString());
        smMedia.setLocation(new Point2D(x, y));

        recordset.dispose();

        return smMedia;
    }
}
