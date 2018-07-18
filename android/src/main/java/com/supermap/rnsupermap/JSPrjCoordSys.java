package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Enum;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSPrjCoordSys extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSPrjCoordSys";
    protected static Map<String, PrjCoordSys> m_PrjCoordSysList = new HashMap<String, PrjCoordSys>();
    PrjCoordSys m_PrjCoordSys;

    public JSPrjCoordSys(ReactApplicationContext context) {
        super(context);
    }

    public static PrjCoordSys getObjFromList(String id) {
        return m_PrjCoordSysList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(PrjCoordSys obj) {
        for (Map.Entry entry : m_PrjCoordSysList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_PrjCoordSysList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            PrjCoordSys m_PrjCoordSys = new PrjCoordSys();
            String prjCoordSysId = registerId(m_PrjCoordSys);

            promise.resolve(prjCoordSysId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjWithType(int type, Promise promise){
        try{
            PrjCoordSysType prjCoordSysType = (PrjCoordSysType) Enum.parse(PrjCoordSysType.class, type);
            PrjCoordSys m_PrjCoordSys = new PrjCoordSys(prjCoordSysType);
            String prjCoordSysId = registerId(m_PrjCoordSys);

            promise.resolve(prjCoordSysId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getType(String prjCoordSysId, Promise promise){
        try{
            PrjCoordSys prjCoordSys= getObjFromList(prjCoordSysId);
            PrjCoordSysType type = prjCoordSys.getType();
            int typeInt = type.value();
            promise.resolve(typeInt);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setType(String prjCoordSysId, int type, Promise promise){
        try{
            PrjCoordSys prjCoordSys= getObjFromList(prjCoordSysId);
            prjCoordSys.setType((PrjCoordSysType) Enum.parse(PrjCoordSysType.class, type));
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

