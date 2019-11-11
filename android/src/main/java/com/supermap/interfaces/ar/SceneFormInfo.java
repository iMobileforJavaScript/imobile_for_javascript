package com.supermap.interfaces.ar;

import com.supermap.data.GeoLine3D;
import com.supermap.data.GeoPoint3D;
import com.supermap.data.Point3D;

public class SceneFormInfo {
    private int ID = 0;

    private String name = "";
    private String type = "";//POI类型
    private String person = "";
    private String time = "";
    private String address = "";
    private String picpath = "";//文件夹路径

    private String notes = "";

    private double locationX = 0;
    private double locationY = 0;

    private GeoLine3D geoLine3D = null;

    private GeoPoint3D geoPoint3D = null;

    public void setName(String name) {
        this.name = name;
    }

    public void setGeoLine3D(GeoLine3D geoLine3D) {
        this.geoLine3D = geoLine3D;
    }

    public void setPerson(String person) {
        this.person = person;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public int getID() {
        return ID;
    }

    public String getName() {
        return name;
    }

    public GeoLine3D getGeoLine3D() {
        return geoLine3D;
    }

    public GeoPoint3D getGeoPoint3D() {
        return geoPoint3D;
    }

    public String getType() {
        return type;
    }

    public String getPerson() {
        return person;
    }

    public String getTime() {
        return time;
    }

    public String getAddress() {
        return address;
    }

    public String getPicpath() {
        return picpath;
    }

    public String getNotes() {
        return notes;
    }

    public double getLocationX() {
        return locationX;
    }

    public double getLocationY() {
        return locationY;
    }

    public SceneFormInfo(SceneFormInfo.Builder builder) {
        this.ID = builder.ID;
        this.name = builder.name;
        this.type = builder.type;
        this.person = builder.person;
        this.time = builder.time;
        this.address = builder.address;
        this.picpath = builder.picpath;
        this.notes = builder.notes;
        this.geoLine3D = builder.geoLine3D;
        this.geoPoint3D = builder.geoPoint3D;

        this.locationX = builder.locationX;
        this.locationY = builder.locationY;
    }

    public static class Builder{
        private int ID = 0;
        private GeoLine3D geoLine3D;
        private GeoPoint3D geoPoint3D;

        private String name = "";
        private String type = "";
        private String person = "";
        private String time = "";
        private String address = "";
        private String picpath = "";
        private String notes = "";

        private double locationX = 0;
        private double locationY = 0;

        public Builder() {
        }

        public SceneFormInfo.Builder ID(int ID) {
            this.ID = ID;
            return this;
        }

        public SceneFormInfo.Builder name(String name) {
            this.name = name;
            return this;
        }
        public SceneFormInfo.Builder type(String type) {
            this.type = type;
            return this;
        }
        public SceneFormInfo.Builder person(String person) {
            this.person = person;
            return this;
        }
        public SceneFormInfo.Builder time(String time) {
            this.time = time;
            return this;
        }
        public SceneFormInfo.Builder address(String address) {
            this.address = address;
            return this;
        }
        public SceneFormInfo.Builder picpath(String picpath) {
            this.picpath = picpath;
            return this;
        }
        public SceneFormInfo.Builder notes(String notes) {
            this.notes = notes;
            return this;
        }
        public SceneFormInfo.Builder locationX(double locationX) {
            this.locationX = locationX;
            return this;
        }
        public SceneFormInfo.Builder locationY(double locationY) {
            this.locationY = locationY;
            return this;
        }
        public SceneFormInfo.Builder geoLine3D(GeoLine3D geoLine3D) {
            this.geoLine3D = geoLine3D;
            return this;
        }

        public SceneFormInfo.Builder geoPoint3D(GeoPoint3D geoPoint3D) {
            this.geoPoint3D = geoPoint3D;
            return this;
        }


        public SceneFormInfo build() {
            return new SceneFormInfo(this);
        }
    }
}
