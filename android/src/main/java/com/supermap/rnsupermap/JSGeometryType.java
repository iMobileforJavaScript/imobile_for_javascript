package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/7/23.
 */

public class JSGeometryType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSGeometryType";

    public JSGeometryType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("GEOPOINT", 1);
        constants.put("GEOLINE", 3);
        constants.put("GEOREGION", 5);
        constants.put("GEOTEXT", 7);
        constants.put("GEOCOMPOUND", 1000);
        constants.put("GEOROUNDRECTANGLE", 13);
        constants.put("GEOCIRCLE", 15);
        constants.put("GEOELLIPSE", 20);
        constants.put("GEOPIE", 21);
        constants.put("GEOARC", 24);
        constants.put("GEOELLIPTICARC", 25);
        constants.put("GEOCARDINAL", 27);
        constants.put("GEOBSPLINE", 29);
        constants.put("GEOPOINT3D", 101);
        constants.put("GEOLINE3D", 103);
        constants.put("GEOREGION3D", 105);
        constants.put("GEOCHORD", 23);
        constants.put("GEORECTANGLE", 12);
        constants.put("GEOLINEM", 35);
        constants.put("GEOMODEL", 1201);
        constants.put("GEOPLACEMARK", 108);
        constants.put("GEOGRAPHICOBJECT", 3000);
        return constants;
    }
}