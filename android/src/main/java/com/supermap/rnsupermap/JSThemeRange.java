package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.ColorGradientType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.data.GeoStyle;
import com.supermap.mapping.RangeMode;
import com.supermap.mapping.ThemeRange;
import com.supermap.mapping.ThemeRangeItem;
import com.supermap.mapping.ThemeUnique;

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

    @ReactMethod
    public void createObjClone(String themeId, Promise promise){
        try{
            ThemeRange origin = (ThemeRange) JSTheme.getObjFromList(themeId);
            ThemeRange theme = new ThemeRange(origin);
            String newThemeId = registerId(theme);

            promise.resolve(newThemeId);
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
            m_ThemeRangeList.remove(themeRangeId);
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
     * 设置范围分段专题图的舍入精度
     * @param themeLabelId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setPrecision(String themeLabelId, double value, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeLabelId);
            m_ThemeRange.setPrecision(value);
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

    /**
     * 根据给定的矢量数据集、分段字段表达式、分段模式和相应的分段参数生成默认的分段专题图
     * @param datasetVectorId
     * @param expression
     * @param rangeMode
     * @param rangeParameter
     * @param promise
     */
    @ReactMethod
    public void makeDefault(String datasetVectorId, String expression, int rangeMode, double rangeParameter, Promise promise){
        try{
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            RangeMode rm = (RangeMode) Enum.parse(RangeMode.class, rangeMode);
            m_ThemeRange = ThemeRange.makeDefault(datasetVector, expression, rm, rangeParameter);

            String id = registerId(m_ThemeRange);
            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数和颜色渐变模式生成默认的分段专题图
     * @param datasetVectorId
     * @param expression
     * @param rangeMode
     * @param rangeParameter
     * @param colorGradientType
     * @param promise
     */
    @ReactMethod
    public void makeDefaultWithColorGradient(String datasetVectorId, String expression, int rangeMode, double rangeParameter, int colorGradientType, Promise promise){
        try{
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            ColorGradientType colorGType = (ColorGradientType) Enum.parse(ColorGradientType.class, colorGradientType);
            RangeMode rm = (RangeMode) Enum.parse(RangeMode.class, rangeMode);
            m_ThemeRange = ThemeRange.makeDefault(datasetVector, expression, rm, rangeParameter, colorGType);

            String id = registerId(m_ThemeRange);
            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 对分段专题图中分段的风格进行反序显示
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void reverseStyle(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            m_ThemeRange.reverseStyle();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置是否固定偏移量
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setOffsetFixed(String themeRangeId, boolean value, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            m_ThemeRange.setOffsetFixed(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置X偏移量
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setOffsetX(String themeRangeId, String value, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            m_ThemeRange.setOffsetX(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回X偏移量
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void getOffsetX(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            String value = m_ThemeRange.getOffsetX();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置Y偏移量
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setOffsetY(String themeRangeId, String value, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            m_ThemeRange.setOffsetY(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回Y偏移量
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void getOffsetY(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            String value = m_ThemeRange.getOffsetY();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据给定的拆分分段值将一个指定序号的分段专题图子项拆分成两个具有各自风格和名称的分段专题图子项
     * @param themeRangeId
     * @param index
     * @param splitValue
     * @param style1Id
     * @param caption1
     * @param style2Id
     * @param caption2
     * @param promise
     */
    @ReactMethod
    public void split(String themeRangeId, int index, double splitValue, String style1Id, String caption1, String style2Id, String caption2, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            GeoStyle style1 = JSGeoStyle.getObjFromList(style1Id);
            GeoStyle style2 = JSGeoStyle.getObjFromList(style2Id);
            boolean result = m_ThemeRange.split(index, splitValue, style1, caption1, style2, caption2);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 合并一个从指定序号起始的给定个数的分段专题图子项，并赋给合并后分段专题图子项显示风格和名称
     * @param themeRangeId
     * @param index
     * @param count
     * @param styleId
     * @param caption
     * @param promise
     */
    @ReactMethod
    public void merge(String themeRangeId, int index, int count, String styleId, String caption, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            GeoStyle style = JSGeoStyle.getObjFromList(styleId);
            boolean result = m_ThemeRange.merge(index, count, style, caption);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回是否固定偏移量
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void isOffsetFixed(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            boolean result = m_ThemeRange.isOffsetFixed();

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取自定义段长
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void getCustomInterval(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            double value = m_ThemeRange.getCustomInterval();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回当前的分段模式
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void getRangeMode(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            RangeMode mode = m_ThemeRange.getRangeMode();

            promise.resolve(mode.value());
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取范围分段专题图的舍入精度
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void getPrecision(String themeRangeId, Promise promise){
        try{
            m_ThemeRange = (ThemeRange)getObjFromList(themeRangeId);
            double value = m_ThemeRange.getPrecision();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

