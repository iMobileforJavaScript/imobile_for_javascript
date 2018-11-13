package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.TextStyle;
import com.supermap.mapping.ThemeLabel;
import com.supermap.mapping.ThemeLabelItem;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSThemeLabelItem extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSThemeLabelItem";
    protected static Map<String, ThemeLabelItem> m_ThemeLabelItemList = new HashMap();
    ThemeLabelItem m_ThemeLabelItem;

    public JSThemeLabelItem(ReactApplicationContext context) {
        super(context);
    }

    public static ThemeLabelItem getObjFromList(String id) {
        return m_ThemeLabelItemList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(ThemeLabelItem obj) {
        for (Map.Entry entry : m_ThemeLabelItemList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_ThemeLabelItemList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            ThemeLabelItem item = new ThemeLabelItem();
            String id = registerId(item);

            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回标签专题图子项的名称
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void getCaption(String themeLabelItemId, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            String caption = themeLabelItem.getCaption();
            promise.resolve(caption);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回标签专题图子项的分段终止值
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void getEnd(String themeLabelItemId, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            double end = themeLabelItem.getEnd();
            promise.resolve(end);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回标签专题图子项的分段起始值
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void getStart(String themeLabelItemId, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            double start = themeLabelItem.getStart();
            promise.resolve(start);
        }catch (Exception e){
            promise.reject(e);
        }
    }


    /**
     * 返回标签专题图子项所对应的显示风格
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void getStyle(String themeLabelItemId, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            TextStyle style = themeLabelItem.getStyle();
            String styleId = JSTextStyle.registerId(style);

            promise.resolve(styleId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回标签专题图子项是否可见
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void isVisible(String themeLabelItemId, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            boolean visible = themeLabelItem.isVisible();
            promise.resolve(visible);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标签专题图子项的名称
     * @param themeLabelItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setCaption(String themeLabelItemId, String value, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            themeLabelItem.setCaption(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标签专题图子项的分段终止值
     * @param themeLabelItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setEnd(String themeLabelItemId, double value, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            themeLabelItem.setEnd(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }


    /**
     * 设置标签专题图子项的分段起始值
     * @param themeLabelItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setStart(String themeLabelItemId, double value, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            themeLabelItem.setStart(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标签专题图子项所对应的显示风格
     * @param themeLabelItemId
     * @param styleId
     * @param promise
     */
    @ReactMethod
    public void setStyle(String themeLabelItemId, String styleId, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            TextStyle style = JSTextStyle.getObjFromList(styleId);
            themeLabelItem.setStyle(style);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标签专题图子项是否可见
     * @param themeLabelItemId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setVisible(String themeLabelItemId, boolean value, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            themeLabelItem.setVisible(value);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回标签专题图子项格式化字符串
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void toString(String themeLabelItemId, Promise promise){
        try{
            ThemeLabelItem themeLabelItem = getObjFromList(themeLabelItemId);
            String string = themeLabelItem.toString();
            promise.resolve(string);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

