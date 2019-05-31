package com.supermap.smNative.collector;

import android.graphics.Bitmap;

import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasource;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.GeoPoint;
import com.supermap.data.Point2D;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Recordset;
import com.supermap.interfaces.utils.SMFileUtil;
import com.supermap.plugin.LocationManagePlugin;

import java.io.File;
import java.util.ArrayList;

/**
 * @Author: shanglongyang
 * Date:        2019/5/17
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class SMMedia {
    private Datasource datasourse;
    private Dataset dataset;
//    private String datasetName;
//    private String mediaType;
//    private String path;
    private ArrayList<String> paths;
    private String fileName;
//    private Bitmap data;
    private Point2D location;

    public Datasource getDatasourse() {
        return datasourse;
    }

    public void setDatasourse(Datasource datasourse) {
        this.datasourse = datasourse;
    }

    public Dataset getDataset() {
        return dataset;
    }

    public void setDataset(Dataset dataset) {
        this.dataset = dataset;
    }

    public ArrayList<String> getPaths() {
        return paths;
    }

    public void setPaths(ArrayList<String> paths) {
        this.paths = paths;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public Point2D getLocation() {
        return location;
    }

    public void setLocation(Point2D location) {
        this.location = location;
    }

    public SMMedia() {
        this.location = getCurrentLocation();
    }

    public SMMedia(String fileName) {
        this.fileName = fileName;

        this.location = getCurrentLocation();
    }

    private Point2D getCurrentLocation() {
        LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
        Point2D pt =  new Point2D(gpsDat.dLongitude,gpsDat.dLatitude);

        return pt;
    }

    public boolean setMediaDataset(Datasource datasource, String datasetName) {
        this.datasourse = datasource;

        DatasetVector pDatasetVector;
        FieldInfo fieldInfo;
        int index = datasource.getDatasets().indexOf(datasetName);
        if (index > -1) {
            // Dataset存在
            pDatasetVector = (DatasetVector)datasource.getDatasets().get(index);
            if (pDatasetVector.getType() != DatasetType.POINT) return false;
            FieldInfos fieldInfos = pDatasetVector.getFieldInfos();
//            int tag1 = fieldInfos.indexOf("MediaFileName");
//            int tag2 = fieldInfos.indexOf("MediaFileType");
//            int tag3 = fieldInfos.indexOf("ModifiedDate");
//            int tag4 = fieldInfos.indexOf("MediaFilePaths");
//            int tag5 = fieldInfos.indexOf("Description");
//            int tag6 = fieldInfos.indexOf("HttpAddress");
//
//            if(tag1==-1 || tag2==-1 || tag3==-1 || tag4==-1 || tag5==-1) return false;
//            if(fieldInfos.get(tag1).getType() != FieldType.TEXT) return false;
//            if(fieldInfos.get(tag2).getType() != FieldType.INT16) return false;
//            if(fieldInfos.get(tag3).getType()!= FieldType.TEXT) return false;
//            if(fieldInfos.get(tag4).getType()!= FieldType.TEXT) return false;
//            if(fieldInfos.get(tag5).getType()!= FieldType.TEXT) return false;
//            if(fieldInfos.get(tag6).getType()!= FieldType.TEXT) return false;

            if (fieldInfos.indexOf("MediaFileName") == -1) {
                fieldInfo = new FieldInfo();
                fieldInfo.setType(FieldType.TEXT);
                fieldInfo.setName("MediaFileName");
                fieldInfos.add(fieldInfo);
                fieldInfo.dispose();
            }
//            if (fieldInfos.indexOf("MediaFileType") == -1) {
//                fieldInfo = new FieldInfo();
//                fieldInfo.setType(FieldType.INT16);
//                fieldInfo.setName("MediaFileType");
//                fieldInfos.add(fieldInfo);
//                fieldInfo.dispose();
//            }
            if (fieldInfos.indexOf("ModifiedDate") == -1) {
                fieldInfo = new FieldInfo();
                fieldInfo.setType(FieldType.TEXT);
                fieldInfo.setName("ModifiedDate");
                fieldInfos.add(fieldInfo);
                fieldInfo.dispose();
            }
            if (fieldInfos.indexOf("Description") == -1) {
                fieldInfo = new FieldInfo();
                fieldInfo.setType(FieldType.TEXT);
                fieldInfo.setName("Description");
                fieldInfos.add(fieldInfo);
                fieldInfo.dispose();
            }
            if (fieldInfos.indexOf("MediaFilePaths") == -1) {
                fieldInfo = new FieldInfo();
                fieldInfo.setType(FieldType.TEXT);
                fieldInfo.setName("MediaFilePaths");
                fieldInfo.setMaxLength(600);
                fieldInfos.add(fieldInfo);
                fieldInfo.dispose();
            }
            if (fieldInfos.indexOf("HttpAddress") == -1) {
                fieldInfo = new FieldInfo();
                fieldInfo.setType(FieldType.TEXT);
                fieldInfo.setName("HttpAddress");
                fieldInfos.add(fieldInfo);
                fieldInfo.dispose();
            }


            if(pDatasetVector.getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) return false;
        } else {
            // Dataset不存在
            try {
                DatasetVectorInfo info = new DatasetVectorInfo(datasetName, DatasetType.CAD);
                pDatasetVector = datasource.getDatasets().create(info);
            } catch (Exception e) {
                return false;
            }

            if (pDatasetVector == null) {
                return false;
            }
            FieldInfos fieldInfos = pDatasetVector.getFieldInfos();

            fieldInfo = new FieldInfo();
            fieldInfo.setType(FieldType.TEXT);
            fieldInfo.setName("MediaFileName");
            fieldInfos.add(fieldInfo);
            fieldInfo.dispose();

//            fieldInfo = new FieldInfo();
//            fieldInfo.setType(FieldType.INT16);
//            fieldInfo.setName("MediaFileType");
//            fieldInfos.add(fieldInfo);
//            fieldInfo.dispose();

            fieldInfo = new FieldInfo();
            fieldInfo.setType(FieldType.TEXT);
            fieldInfo.setName("ModifiedDate");
            fieldInfos.add(fieldInfo);
            fieldInfo.dispose();

            fieldInfo = new FieldInfo();
            fieldInfo.setType(FieldType.TEXT);
            fieldInfo.setName("Description");
            fieldInfos.add(fieldInfo);
            fieldInfo.dispose();

            fieldInfo = new FieldInfo();
            fieldInfo.setType(FieldType.TEXT);
            fieldInfo.setName("MediaFilePaths");
            fieldInfo.setMaxLength(600);
            fieldInfos.add(fieldInfo);
            fieldInfo.dispose();

            fieldInfo = new FieldInfo();
            fieldInfo.setType(FieldType.TEXT);
            fieldInfo.setName("HttpAddress");
            fieldInfos.add(fieldInfo);
            fieldInfo.dispose();

            pDatasetVector.setPrjCoordSys(new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE));
        }

        this.dataset = pDatasetVector;
        return true;
    }

    public void saveLocationDataToDataset() {
        GeoPoint point = new GeoPoint();

        Recordset recordset = ((DatasetVector)this.dataset).getRecordset(false, CursorType.DYNAMIC);
        recordset.edit();

        point.setX(this.location.getX());
        point.setY(this.location.getY());
        boolean result = recordset.addNew(point);
        recordset.setString("MediaFileName", this.fileName);

        recordset.update();
        recordset.dispose();
    }

    public boolean saveMedia(ArrayList<String> filePaths, String toDictionary, boolean addNew) {
        this.paths = SMFileUtil.copyFiles(filePaths, toDictionary);

        if (paths != null && addNew) saveLocationDataToDataset();

        return paths != null;
    }

    public boolean addMediaFiles(ArrayList<String> files) {
        if (files == null || files.size() == 0) return false;
        ArrayList<String> addingArr = new ArrayList<>();

        for (int i = 0; i < files.size(); i++) {
            boolean exsit = false;
            if (!new File(files.get(i)).exists()) continue;
            for (int j = 0; j < this.paths.size(); j++) {
                if (files.get(i).equals(this.paths.get(j))) {
                    exsit = true;
                    break;
                }
            }
            if (!exsit) {
                addingArr.add(files.get(i));
            }
        }

        this.paths.addAll(addingArr);

        return true;
    }

    public boolean deleteMediaFiles(ArrayList<String> files) {
        if (files == null || files.size() == 0) return false;
        ArrayList<String> addingArr = new ArrayList<>();

        for (int i = 0; i < files.size(); i++) {
            if (!new File(files.get(i)).exists()) continue;
            for (int j = 0; j < this.paths.size(); j++) {
                if (files.get(i).equals(this.paths.get(j)) && new File(files.get(i)).delete()) {
                    this.paths.remove(j);
                    break;
                }
            }
        }

        return true;
    }
}
