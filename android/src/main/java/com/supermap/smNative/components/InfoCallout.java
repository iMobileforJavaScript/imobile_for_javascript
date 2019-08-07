package com.supermap.smNative.components;

import android.content.Context;
import android.view.View;

import com.supermap.mapping.CallOut;

import java.util.ArrayList;
import java.util.Date;

/**
 * @Author: shanglongyang
 * Date:        2019/5/17
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class InfoCallout extends CallOut {

    private String id;
    private String description;
    private String layerName;
    private String mediaName;
    private ArrayList<String> mediaFilePaths;
//    private String type;
    int geoID;
    private String modifiedDate;
    private String httpAddress;

    public String getID() {
        return id;
    }

//    public void setID(String id) {
//        this.id = id;
//    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLayerName() {
        if(layerName != null){
            return layerName;
        }else {
            return "";
        }
    }

    public void setLayerName(String layerName) {
        this.layerName = layerName;
        if (this.geoID >= 0) {
            this.id = this.layerName + "-" + this.geoID;
        }
    }

    public String getMediaName() {
        return mediaName;
    }

    public void setMediaName(String mediaName) {
        this.mediaName = mediaName;
    }

    public ArrayList<String> getMediaFilePaths() {
        return mediaFilePaths;
    }

    public void setMediaFilePaths(ArrayList<String> mediaFilePaths) {
        this.mediaFilePaths = mediaFilePaths;
    }

    public int getGeoID() {
        return geoID;
    }

    public void setGeoID(int geoID) {
        this.geoID = geoID;
        if (this.layerName != null && !this.layerName.equals("")) {
            this.id = this.layerName + "-" + this.geoID;
        }
    }

    public String getHttpAddress() {
        return httpAddress;
    }

    public void setHttpAddress(String httpAddress) {
        this.httpAddress = httpAddress;
    }

    public String getModifiedDate() {
        return modifiedDate;
    }

    public void setModifiedDate(String modifiedDate) {
        this.modifiedDate = modifiedDate;
    }

    public InfoCallout(Context context) {
        super(context);
        this.id = new Date().getTime() + "";
    }

    public InfoCallout(Context context, View view) {
        super(context, view);
        this.id = new Date().getTime() + "";
    }


    @Override
    public boolean performClick() {
        super.performClick();
        return true;
    }

}
