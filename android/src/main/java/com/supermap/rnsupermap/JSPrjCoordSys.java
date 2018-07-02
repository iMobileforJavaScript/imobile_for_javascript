package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.PrjCoordSys;

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
}

