package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.GeoStyle;
import com.supermap.mapping.ThemeUniqueItem;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSThemeUniqueItem extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSThemeUniqueItem";
    protected static Map<String, ThemeUniqueItem> m_ThemeUniqueItemList = new HashMap();
    ThemeUniqueItem m_ThemeUniqueItem;

    public JSThemeUniqueItem(ReactApplicationContext context) {
        super(context);
    }

    public static ThemeUniqueItem getObjFromList(String id) {
        return m_ThemeUniqueItemList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(ThemeUniqueItem obj) {
        for (Map.Entry entry : m_ThemeUniqueItemList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ThemeUniqueItemList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            ThemeUniqueItem item = new ThemeUniqueItem();
            String id = registerId(item);

            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图子项的名称
     * @param themeUniqueItemId
     * @param promise
     */
    @ReactMethod
    public void getCaption(String themeUniqueItemId, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            String caption = themeUniqueItem.getCaption();
            promise.resolve(caption);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图子项所对应的显示风格
     * @param themeUniqueItemId
     * @param promise
     */
    @ReactMethod
    public void getStyle(String themeUniqueItemId, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            GeoStyle style = themeUniqueItem.getStyle();
            String styleId = JSGeoStyle.registerId(style);

            promise.resolve(styleId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图子项的单值
     * @param themeUniqueItemId
     * @param promise
     */
    @ReactMethod
    public void getUnique(String themeUniqueItemId, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            String value = themeUniqueItem.getUnique();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图子项是否可见
     * @param themeUniqueItemId
     * @param promise
     */
    @ReactMethod
    public void isVisible(String themeUniqueItemId, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            boolean visible = themeUniqueItem.isVisible();
            promise.resolve(visible);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图子项的名称
     * @param themeUniqueItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setCaption(String themeUniqueItemId, String value, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            themeUniqueItem.setCaption(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图子项所对应的显示风格
     * @param themeUniqueItemId
     * @param styleId
     * @param promise
     */
    @ReactMethod
    public void setStyle(String themeUniqueItemId, String styleId, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            GeoStyle style = JSGeoStyle.getObjFromList(styleId);
            themeUniqueItem.setStyle(style);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图子项的单值
     * @param themeUniqueItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setUnique(String themeUniqueItemId, String value, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            themeUniqueItem.setUnique(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置单值专题图子项是否可见
     * @param themeUniqueItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setVisible(String themeUniqueItemId, boolean value, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            themeUniqueItem.setVisible(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图子项格式化字符串
     * @param themeUniqueItemId
     * @param promise
     */
    @ReactMethod
    public void toString(String themeUniqueItemId, Promise promise){
        try{
            ThemeUniqueItem themeUniqueItem = getObjFromList(themeUniqueItemId);
            String string = themeUniqueItem.toString();
            promise.resolve(string);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

