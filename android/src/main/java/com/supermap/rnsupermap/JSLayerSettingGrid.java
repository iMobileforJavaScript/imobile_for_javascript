/**
 * Created by Yang Shanglong on 2018/6/25.
 */
package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.DatasetType;
import com.supermap.data.Enum;
import com.supermap.data.Color;
import com.supermap.data.GeoStyle;
import com.supermap.mapping.LayerSettingType;
import com.supermap.mapping.LayerSettingGrid;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSLayerSettingGrid extends JSLayerSetting {
    public static final String REACT_CLASS = "JSLayerSettingGrid";
    protected static Map<String, LayerSettingGrid> m_LayerSettingGridList = new HashMap<String, LayerSettingGrid>();
    LayerSettingGrid m_LayerSettingGrid;

    public JSLayerSettingGrid(ReactApplicationContext context) {
        super(context);
    }

//    public static LayerSettingGrid getObjFromList(String id) {
//        return m_LayerSettingGridList.get(id);
//    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

//    public static String registerId(LayerSettingGrid obj) {
//        for (Map.Entry entry : m_LayerSettingGridList.entrySet()) {
//            if (obj.equals(entry.getValue())) {
//                return (String) entry.getKey();
//            }
//        }
//
//        Calendar calendar = Calendar.getInstance();
//        String id = Long.toString(calendar.getTimeInMillis());
//        m_LayerSettingGridList.put(id, obj);
//        return id;
//    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            LayerSettingGrid layerSettingGrid = new LayerSettingGrid();
            String layerSettingGridId = registerId(layerSettingGrid);

            WritableMap map = Arguments.createMap();
            map.putString("_layerSettingGridId_",layerSettingGridId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

     /**
     * 获取栅格图层特殊值
     */
    @ReactMethod
    public void getSpecialValue(String layerSettingGridId, Promise promise){
        try{
            LayerSettingGrid layerSettingGrid = (LayerSettingGrid) getObjFromList(layerSettingGridId);
            double specialValue = layerSettingGrid.getSpecialValue();

            WritableMap map = Arguments.createMap();
            map.putDouble("specialValue",specialValue);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置栅格图层特殊值
     */
    @ReactMethod
    public void setSpecialValue(String layerSettingGridId, double specialValue, Promise promise){
        try{
            LayerSettingGrid layerSettingGrid = (LayerSettingGrid) getObjFromList(layerSettingGridId);
            layerSettingGrid.setSpecialValue(specialValue);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取栅格类型
     */
    @ReactMethod
    public void getType(String layerSettingGridId, Promise promise){
        try{
            LayerSettingGrid layerSettingGrid = (LayerSettingGrid) getObjFromList(layerSettingGridId);
            LayerSettingType layerSettingType = layerSettingGrid.getType();
            int type = Enum.getValueByName(LayerSettingType.class,layerSettingType.name());

            WritableMap map = Arguments.createMap();
            map.putInt("type",type);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取栅格图层指定的特殊值是否要透明显示
     */
    @ReactMethod
    public void isSpecialValueTransparent(String layerSettingGridId, Promise promise){
        try {
            LayerSettingGrid layerSettingGrid = (LayerSettingGrid) getObjFromList(layerSettingGridId);
            boolean isSpecialValueTransparent = layerSettingGrid.isSpecialValueTransparent();

            WritableMap map = Arguments.createMap();
            map.putBoolean("isSpecialValueTransparent",isSpecialValueTransparent);
            promise.resolve(map);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置栅格图层指定的特殊值是否要透明显示
     */
    @ReactMethod
    public void setSpecialValueTransparent(String layerSettingGridId, boolean specialValueTransparent, Promise promise){
        try{
            LayerSettingGrid layerSettingGrid = (LayerSettingGrid) getObjFromList(layerSettingGridId);
            layerSettingGrid.setSpecialValueTransparent(specialValueTransparent);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取栅格图层当前指定特殊值对应的像元要显示的颜色
     */
    @ReactMethod
    public void getSpecialValueColor(String layerSettingGridId, Promise promise){
        try{
            LayerSettingGrid layerSettingGrid = new LayerSettingGrid();
            Color color = layerSettingGrid.getSpecialValueColor();

            int R = color.getR();
            int G = color.getG();
            int B = color.getB();
            int A = color.getA();

            WritableMap map = Arguments.createMap();
            map.putInt("R", R);
            map.putInt("G", G);
            map.putInt("B", B);
            map.putInt("A", A);

            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置栅格图层当前指定特殊值对应的像元要显示的颜色
     */
    @ReactMethod
    public void setSpecialValueColor(String layerSettingGridId, int r, int g, int b, int a, Promise promise){
        try{
            LayerSettingGrid layerSettingGrid = (LayerSettingGrid) getObjFromList(layerSettingGridId);
            Color specialValueColor = new Color(a, g, b, a);
            layerSettingGrid.setSpecialValueColor(specialValueColor);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

