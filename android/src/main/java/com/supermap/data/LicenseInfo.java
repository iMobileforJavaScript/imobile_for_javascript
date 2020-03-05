package com.supermap.data;
//import com.supermap.LicenseFeature;

import java.util.ArrayList;

public class LicenseInfo {
    public String signature = "";//唯一表识
    public String licmode = "";
    public String version = "";
    public String startTime = "";
    public String endTime = "";
    public String user = "";
    public String company = "";
    public int licenseType = 0;//0 离线 //1 云许可
    public ArrayList<LicenseFeature> features = new ArrayList<>();

//    public LicenseInfo(){
//        signature = "";
//        licenseType = 0;
//
//    }

}
