package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.GeoStyle;
import com.supermap.data.TextStyle;
import com.supermap.mapping.ThemeRangeItem;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSThemeRangeItem extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSThemeRangeItem";
    protected static Map<String, ThemeRangeItem> m_ThemeRangeItemList = new HashMap();
    ThemeRangeItem m_ThemeRangeItem;

    public JSThemeRangeItem(ReactApplicationContext context) {
        super(context);
    }

    public static ThemeRangeItem getObjFromList(String id) {
        return m_ThemeRangeItemList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(ThemeRangeItem obj) {
        for (Map.Entry entry : m_ThemeRangeItemList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ThemeRangeItemList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            ThemeRangeItem item = new ThemeRangeItem();
            String id = registerId(item);

            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分段专题图子项的名称
     * @param themeRangeItemId
     * @param promise
     */
    @ReactMethod
    public void getCaption(String themeRangeItemId, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            String caption = themeRangeItem.getCaption();
            promise.resolve(caption);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分段专题图子项的分段终止值
     * @param themeRangeItemId
     * @param promise
     */
    @ReactMethod
    public void getEnd(String themeRangeItemId, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            double end = themeRangeItem.getEnd();
            promise.resolve(end);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分段专题图子项的分段起始值
     * @param themeRangeItemId
     * @param promise
     */
    @ReactMethod
    public void getStart(String themeRangeItemId, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            double start = themeRangeItem.getStart();
            promise.resolve(start);
        }catch (Exception e){
            promise.reject(e);
        }
    }


    /**
     * 返回分段专题图子项所对应的显示风格
     * @param themeRangeItemId
     * @param promise
     */
    @ReactMethod
    public void getStyle(String themeRangeItemId, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            GeoStyle style = themeRangeItem.getStyle();
            String styleId = JSGeoStyle.registerId(style);

            promise.resolve(styleId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分段专题图子项是否可见
     * @param themeRangeItemId
     * @param promise
     */
    @ReactMethod
    public void isVisible(String themeRangeItemId, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            boolean visible = themeRangeItem.isVisible();
            promise.resolve(visible);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分段专题图子项的名称
     * @param themeRangeItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setCaption(String themeRangeItemId, String value, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            themeRangeItem.setCaption(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分段专题图子项的分段终止值
     * @param themeRangeItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setEnd(String themeRangeItemId, double value, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            themeRangeItem.setEnd(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }


    /**
     * 设置分段专题图子项的分段起始值
     * @param themeRangeItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setStart(String themeRangeItemId, double value, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            themeRangeItem.setStart(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分段专题图子项所对应的显示风格
     * @param themeRangeItemId
     * @param styleId
     * @param promise
     */
    @ReactMethod
    public void setStyle(String themeRangeItemId, String styleId, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            GeoStyle style = JSGeoStyle.getObjFromList(styleId);
            themeRangeItem.setStyle(style);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置分段专题图子项是否可见
     * @param themeRangeItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setVisible(String themeRangeItemId, boolean value, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            themeRangeItem.setVisible(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分段专题图子项格式化字符串
     * @param themeRangeItemId
     * @param promise
     */
    @ReactMethod
    public void toString(String themeRangeItemId, Promise promise){
        try{
            ThemeRangeItem themeRangeItem = getObjFromList(themeRangeItemId);
            String string = themeRangeItem.toString();
            promise.resolve(string);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

