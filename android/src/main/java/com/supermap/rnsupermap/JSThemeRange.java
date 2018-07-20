package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.mapping.ThemeRange;
import com.supermap.mapping.ThemeRangeItem;

import java.util.HashMap;
import java.util.Map;

public class JSThemeRange extends JSTheme {
    public static final String REACT_CLASS = "JSThemeRange";
    protected static Map<String, ThemeRange> m_ThemeRangeList = new HashMap();
    ThemeRange m_ThemeRange;

    public JSThemeRange(ReactApplicationContext context) {
        super(context);
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            ThemeRange theme = new ThemeRange();
            String themeId = registerId(theme);

            promise.resolve(themeId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    // TODO 方法待完善

    @ReactMethod
    public void dispose(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            m_ThemeRange.dispose();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 删除分段专题图的子项
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void clear(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            m_ThemeRange.clear();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }



    /**
     * 设置分段字段表达式
     * @param themeLabelId
     * @param expression
     * @param promise
     */
    @ReactMethod
    public void setRangeExpression(String themeLabelId, String expression, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeLabelId);
            m_ThemeRange.setRangeExpression(expression);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }


    /**
     * 返回分段字段表达式
     * @param themeLabelId
     * @param promise
     */
    @ReactMethod
    public void getRangeExpression(String themeLabelId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeLabelId);
            String value = m_ThemeRange.getRangeExpression();
            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 把一个分段专题图子项添加到分段列表的开头
     * @param themeLabelId
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void addToHead(String themeLabelId, String themeLabelItemId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeLabelId);
            ThemeRangeItem item = JSThemeRangeItem.getObjFromList(themeLabelItemId);
            boolean result = m_ThemeRange.addToHead(item);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 把一个分段专题图子项添加到分段列表的尾部
     * @param themeLabelId
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void addToTail(String themeLabelId, String themeLabelItemId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeLabelId);
            ThemeRangeItem item = JSThemeRangeItem.getObjFromList(themeLabelItemId);
            boolean result = m_ThemeRange.addToTail(item);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分段专题图中分段的个数
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void getCount(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            int value = m_ThemeRange.getCount();
            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回指定序号的分段专题图中分段专题图子项
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void getItem(String themeRangeId, int value, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            ThemeRangeItem item = m_ThemeRange.getItem(value);
            String itemId = JSThemeRangeItem.registerId(item);

            promise.resolve(itemId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回分段专题图中指定分段字段值在当前分段序列中的序号
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void indexOf(String themeRangeId, int value, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            int index = m_ThemeRange.indexOf(value);

            promise.resolve(index);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

