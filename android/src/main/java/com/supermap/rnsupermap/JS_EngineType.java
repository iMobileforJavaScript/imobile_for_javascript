package com.supermap.rnsupermap;

import com.supermap.data.EngineType;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JS_EngineType {

    private static Map<String,EngineType> engingTypeMap=new HashMap<String,EngineType>(){
        {
            put("Rest", EngineType.Rest);
            put("IMAGEPLUGINS", EngineType.IMAGEPLUGINS);
            put("OGC", EngineType.OGC);
            put("UDB", EngineType.UDB);
            put("SuperMapCloud", EngineType.SuperMapCloud);
            put("GoogleMaps", EngineType.GoogleMaps);
            put("BaiDu", EngineType.BaiDu);
            put("OpenStreetMaps", EngineType.OpenStreetMaps);
        }
    };

    public static EngineType typeOf(String type){
        return engingTypeMap.get(type);
    }
}
