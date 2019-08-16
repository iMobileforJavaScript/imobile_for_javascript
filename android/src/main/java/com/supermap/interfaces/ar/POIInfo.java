package com.supermap.interfaces.ar;

public class POIInfo {
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

    public void setName(String name) {
        this.name = name;
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

    public POIInfo(POIInfo.Builder builder) {
        this.ID = builder.ID;
        this.name = builder.name;
        this.type = builder.type;
        this.person = builder.person;
        this.time = builder.time;
        this.address = builder.address;
        this.picpath = builder.picpath;
        this.notes = builder.notes;

        this.locationX = builder.locationX;
        this.locationY = builder.locationY;
    }

    public static class Builder{
        private int ID = 0;

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

        public POIInfo.Builder ID(int ID) {
            this.ID = ID;
            return this;
        }

        public POIInfo.Builder name(String name) {
            this.name = name;
            return this;
        }
        public POIInfo.Builder type(String type) {
            this.type = type;
            return this;
        }
        public POIInfo.Builder person(String person) {
            this.person = person;
            return this;
        }
        public POIInfo.Builder time(String time) {
            this.time = time;
            return this;
        }
        public POIInfo.Builder address(String address) {
            this.address = address;
            return this;
        }
        public POIInfo.Builder picpath(String picpath) {
            this.picpath = picpath;
            return this;
        }
        public POIInfo.Builder notes(String notes) {
            this.notes = notes;
            return this;
        }
        public POIInfo.Builder locationX(double locationX) {
            this.locationX = locationX;
            return this;
        }
        public POIInfo.Builder locationY(double locationY) {
            this.locationY = locationY;
            return this;
        }

        public POIInfo build() {
            return new POIInfo(this);
        }
    }
}
