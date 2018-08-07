package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.data.ColorGradientType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.mapping.RangeMode;
import com.supermap.mapping.Theme;
import com.supermap.mapping.ThemeLabel;
import com.supermap.mapping.ThemeRange;
import com.supermap.mapping.ThemeUnique;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSTheme extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTheme";
    protected static Map<String, Theme> m_ThemeList = new HashMap<String, Theme>();
    Theme m_Theme;

    public JSTheme(ReactApplicationContext context) {
        super(context);
    }

    public static Theme getObjFromList(String id) {
        return m_ThemeList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Theme obj) {
        System.out.println("=====iTablet=====JSTheme===0==" + m_ThemeList.size());

        for (Map.Entry entry : m_ThemeList.entrySet()) {
            System.out.println("=====iTablet=====JSTheme===1==" + entry + "==" + obj);
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }
        System.out.println("=====iTablet=====JSTheme===2==" + obj);
        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ThemeList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void makeThemeLabel(String datasetVectorId, String rangeExpress, int rangeMode, double rangeParameter,
                               int colorGradientType, Promise promise) {
        try {
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            ThemeLabel themeLabel = ThemeLabel.makeDefault(datasetVector, rangeExpress, (RangeMode) Enum.parse(RangeMode.class, rangeMode)
                    , rangeParameter, (ColorGradientType) Enum.parse(ColorGradientType.class, colorGradientType));

            String themeId = registerId(themeLabel);
            WritableMap map = Arguments.createMap();
            map.putString("themeId", themeId);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void makeThemeRange(String datasetVectorId, String rangeExpress, int rangeMode, double rangeParameter,
                               int colorGradientType, Promise promise) {
        try {
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            ThemeRange themeRange = ThemeRange.makeDefault(datasetVector, rangeExpress, (RangeMode) Enum.parse(RangeMode.class, rangeMode)
                    , rangeParameter, (ColorGradientType) Enum.parse(ColorGradientType.class, colorGradientType));

            String themeId = registerId(themeRange);
            WritableMap map = Arguments.createMap();
            map.putString("themeId", themeId);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void makeThemeUnique(String datasetVectorId, String uniqueExpression,
                                int colorGradientType, Promise promise) {
        try {
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            ThemeUnique themeUnique = ThemeUnique.makeDefault(datasetVector, uniqueExpression, (ColorGradientType) Enum.parse(ColorGradientType.class, colorGradientType));

            String themeId = registerId(themeUnique);
            WritableMap map = Arguments.createMap();
            map.putString("themeId", themeId);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getType(String themeId, Promise promise) {
        try {
            Theme theme = getObjFromList(themeId);
            int type = theme.getType().value();
            promise.resolve(type);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}

