package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.supermap.data.Color;
import com.supermap.data.ColorGradientType;
import com.supermap.data.Colors;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.data.GeoStyle;
import com.supermap.mapping.ThemeUnique;
import com.supermap.mapping.ThemeUniqueItem;

import java.util.HashMap;
import java.util.Map;

public class JSThemeUnique extends JSTheme {
    public static final String REACT_CLASS = "JSThemeUnique";
    protected static Map<String, ThemeUnique> m_ThemeUniqueList = new HashMap();
    ThemeUnique m_ThemeUnique;

    public JSThemeUnique(ReactApplicationContext context) {
        super(context);
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            ThemeUnique theme = new ThemeUnique();
            String themeId = registerId(theme);

            promise.resolve(themeId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjClone(String themeUniqueId, Promise promise){
        try{
            ThemeUnique old = (ThemeUnique) getObjFromList(themeUniqueId);
            ThemeUnique theme = new ThemeUnique(old);
            String themeId = registerId(theme);

            old.dispose();

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
    public void dispose(String themeUniqueId, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            m_ThemeUnique.dispose();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 添加单值专题图子项
     * @param themeUniqueId
     * @param themeUniqueItemId
     * @param promise
     */
    @ReactMethod
    public void add(String themeUniqueId, String themeUniqueItemId, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            ThemeUniqueItem item = JSThemeUniqueItem.getObjFromList(themeUniqueItemId);
            int index = m_ThemeUnique.add(item);
            promise.resolve(index);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 删除一个指定序号的单值专题图子项
     * @param themeUniqueId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void remove(String themeUniqueId, int index, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            boolean result = m_ThemeUnique.remove(index);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 将给定的单值专题图子项插入到指定序号的位置
     * @param themeUniqueId
     * @param index
     * @param themeUniqueItemId
     * @param promise
     */
    @ReactMethod
    public void insert(String themeUniqueId, int index, String themeUniqueItemId, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            ThemeUniqueItem item = JSThemeUniqueItem.getObjFromList(themeUniqueItemId);
            boolean result = m_ThemeUnique.insert(index, item);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据给定的矢量数据集、单值专题图字段表达式和颜色渐变模式生成默认的单值专题图
     * @param datasetVectorId
     * @param expression
     * @param promise
     */
    @ReactMethod
    public void makeDefault(String datasetVectorId, String expression, Promise promise){
        try{
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            m_ThemeUnique = ThemeUnique.makeDefault(datasetVector, expression);

            String id = registerId(m_ThemeUnique);
            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据给定的矢量数据集、单值专题图字段表达式和颜色渐变模式生成默认的单值专题图
     * @param datasetVectorId
     * @param expression
     * @param colorGradientType
     * @param promise
     */
    @ReactMethod
    public void makeDefaultWithColorGradient(String datasetVectorId, String expression, int colorGradientType, Promise promise){
        try{
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            ColorGradientType colorGType = (ColorGradientType) Enum.parse(ColorGradientType.class, colorGradientType);
            m_ThemeUnique = ThemeUnique.makeDefault(datasetVector, expression, colorGType);

            String id = registerId(m_ThemeUnique);
            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据指定的面数据集、颜色字段名称、颜色生成默认的四色单值专题图
     * @param datasetVectorId
     * @param expression
     * @param colors
     * @param promise
     */
    @ReactMethod
    public void makeDefaultWithColors(String datasetVectorId, String expression, ReadableArray colors, Promise promise){
        try{
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);

            Colors colors1 = new Colors();
            for (int i = 0; i < colors.size(); i++) {
                ReadableMap map = colors.getMap(i);
                Color color = new Color(map.getInt("x"), map.getInt("y"), map.getInt("b"));
                colors1.add(color);
            }

            m_ThemeUnique = ThemeUnique.makeDefault(datasetVector, expression, colors1);

            String id = registerId(m_ThemeUnique);
            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 删除单值专题图的子项
     * @param themeUniqueId
     * @param promise
     */
    @ReactMethod
    public void clear(String themeUniqueId, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            m_ThemeUnique.clear();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图中分段的个数
     * @param themeUniqueId
     * @param promise
     */
    @ReactMethod
    public void getCount(String themeUniqueId, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            int value = m_ThemeUnique.getCount();
            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回指定序号的单值专题图中单值专题图子项
     * @param themeUniqueId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void getItem(String themeUniqueId, int value, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            ThemeUniqueItem item = m_ThemeUnique.getItem(value);
            String itemId = JSThemeUniqueItem.registerId(item);

            promise.resolve(itemId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图中指定分段字段值在当前分段序列中的序号
     * @param themeUniqueId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void indexOf(String themeUniqueId, String value, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            int index = m_ThemeUnique.indexOf(value);

            promise.resolve(index);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回单值专题图的默认风格
     * @param themeUniqueId
     * @param promise
     */
    @ReactMethod
    public void getDefaultStyle(String themeUniqueId, Promise promise){
        try{
            m_ThemeUnique = (ThemeUnique)getObjFromList(themeUniqueId);
            GeoStyle style = m_ThemeUnique.getDefaultStyle();
            String styleId = JSGeoStyle.registerId(style);

            promise.resolve(styleId);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

