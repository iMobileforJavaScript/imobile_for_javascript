package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.analyst.BufferAnalystGeometry;
import com.supermap.analyst.BufferAnalystParameter;
import com.supermap.data.GeoRegion;
import com.supermap.data.Geometry;
import com.supermap.data.PrjCoordSys;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSBufferAnalystGeometry extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSBufferAnalystGeometry";
    protected static Map<String, BufferAnalystGeometry> m_BufferAnalystGeometryList = new HashMap<String, BufferAnalystGeometry>();
    BufferAnalystGeometry m_BufferAnalystGeometry;

    public JSBufferAnalystGeometry(ReactApplicationContext context) {
        super(context);
    }

    public static BufferAnalystGeometry getObjFromList(String id) {
        return m_BufferAnalystGeometryList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(BufferAnalystGeometry obj) {
        for (Map.Entry entry : m_BufferAnalystGeometryList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_BufferAnalystGeometryList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createBuffer(String geometryId, String bufferAnalystParamId, String prjCoordSysId, Promise promise){
        try{
            BufferAnalystParameter bufferAnalystParameter = JSBufferAnalystParameter.getObjFromList(bufferAnalystParamId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            PrjCoordSys prjCoordSys = JSPrjCoordSys.getObjFromList(prjCoordSysId);
            GeoRegion geoRegion = BufferAnalystGeometry.createBuffer(geometry,bufferAnalystParameter,prjCoordSys);
            String geoRegionId = JSGeoRegion.registerId(geoRegion);

            WritableMap map = Arguments.createMap();
            map.putString("geoRegionId",geoRegionId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

