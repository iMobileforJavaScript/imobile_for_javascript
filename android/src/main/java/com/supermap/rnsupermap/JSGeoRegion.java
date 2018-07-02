package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.supermap.data.GeoRegion;

import java.util.Calendar;
import java.util.Map;

public class JSGeoRegion extends JSGeometry {
    public static final String REACT_CLASS = "JSGeoRegion";
    GeoRegion m_GeoRegion;

    public JSGeoRegion(ReactApplicationContext context) {
        super(context);
    }

    public static GeoRegion getObjFromList(String id) {
        return (GeoRegion)m_GeometryList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(GeoRegion obj) {
        for (Map.Entry entry : m_GeometryList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_GeometryList.put(id, obj);
        return id;
    }
}

