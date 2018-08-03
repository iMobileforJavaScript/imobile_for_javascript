package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.ColorGradientType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.data.GeoStyle;
import com.supermap.data.TextStyle;
import com.supermap.mapping.AlongLineDirection;
import com.supermap.mapping.LabelBackShape;
import com.supermap.mapping.RangeMode;
import com.supermap.mapping.ThemeLabel;
import com.supermap.mapping.ThemeLabelItem;

import java.util.HashMap;
import java.util.Map;

public class JSThemeLabel extends JSTheme {
    public static final String REACT_CLASS = "JSThemeLabel";
    protected static Map<String, ThemeLabel> m_ThemeLabelList = new HashMap();
    ThemeLabel m_ThemeLabel;

    public JSThemeLabel(ReactApplicationContext context) {
        super(context);
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            ThemeLabel theme = new ThemeLabel();
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
    public void dispose(String themeLabelId, String expression, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            m_ThemeLabel.dispose();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标注字段表达式
     * @param themeLabelId
     * @param expression
     * @param promise
     */
    @ReactMethod
    public void setLabelExpression(String themeLabelId, String expression, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            m_ThemeLabel.setLabelExpression(expression);
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
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            String value = m_ThemeLabel.getRangeExpression();
            promise.resolve(value);
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
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            m_ThemeLabel.setRangeExpression(expression);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 把一个标签专题图子项添加到分段列表的开头
     * @param themeLabelId
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void addToHead(String themeLabelId, String themeLabelItemId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            ThemeLabelItem item = JSThemeLabelItem.getObjFromList(themeLabelItemId);
            boolean result = m_ThemeLabel.addToHead(item);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 把一个标签专题图子项添加到分段列表的尾部
     * @param themeLabelId
     * @param themeLabelItemId
     * @param promise
     */
    @ReactMethod
    public void addToTail(String themeLabelId, String themeLabelItemId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            ThemeLabelItem item = JSThemeLabelItem.getObjFromList(themeLabelItemId);
            boolean result = m_ThemeLabel.addToTail(item);
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 删除标签专题图的子项
     * @param themeLabelId
     * @param promise
     */
    @ReactMethod
    public void clear(String themeLabelId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            m_ThemeLabel.clear();
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回标签专题图中分段的个数
     * @param themeLabelId
     * @param promise
     */
    @ReactMethod
    public void getCount(String themeLabelId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            int value = m_ThemeLabel.getCount();
            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回指定序号的标签专题图中标签专题图子项
     * @param themeLabelId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void getItem(String themeLabelId, int value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            ThemeLabelItem item = m_ThemeLabel.getItem(value);
            String itemId = JSThemeLabelItem.registerId(item);

            promise.resolve(itemId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回标签专题图中指定分段字段值在当前分段序列中的序号
     * @param themeLabelId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void indexOf(String themeLabelId, double value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            int index = m_ThemeLabel.indexOf(value);

            promise.resolve(index);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置统一文本风格
     * @param themeLabelId
     * @param styleId
     * @param promise
     */
    @ReactMethod
    public void setUniformStyle(String themeLabelId, String styleId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            TextStyle textStyle = JSTextStyle.getObjFromList(styleId);
            m_ThemeLabel.setUniformStyle(textStyle);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回统一文本风格
     * @param themeLabelId
     * @param promise
     */
    @ReactMethod
    public void getUniformStyle(String themeLabelId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            TextStyle textStyle = m_ThemeLabel.getUniformStyle();
            String textStyleId = JSTextStyle.registerId(textStyle);


            promise.resolve(textStyleId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 合并一个从指定序号起始的给定个数的标签专题图子项，并赋给合并后标签专题图子项显示风格和名称
     * @param themeLabelId
     * @param index
     * @param count
     * @param styleId
     * @param caption
     * @param promise
     */
    @ReactMethod
    public void merge(String themeLabelId, int index, int count, String styleId, String caption, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            TextStyle style = JSTextStyle.getObjFromList(styleId);
            boolean result = m_ThemeLabel.merge(index, count, style, caption);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据给定的拆分分段值将一个指定序号的标签专题图子项拆分成两个具有各自风格和名称的标签专题图子项
     * @param themeLabelId
     * @param index
     * @param splitValue
     * @param styleId1
     * @param caption1
     * @param styleId2
     * @param caption2
     * @param promise
     */
    @ReactMethod
    public void split(String themeLabelId, int index, double splitValue, String styleId1, String caption1, String styleId2, String caption2, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeLabelId);
            TextStyle style1 = JSTextStyle.getObjFromList(styleId1);
            TextStyle style2 = JSTextStyle.getObjFromList(styleId2);

            boolean result = m_ThemeLabel.split(index, splitValue, style1, caption1, style2, caption2);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据给定的矢量数据集、分段字段表达式、分段模式和相应的分段参数生成默认的标签专题图
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
            m_ThemeLabel = ThemeLabel.makeDefault(datasetVector, expression, rm, rangeParameter);

            String id = registerId(m_ThemeLabel);
            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数和颜色渐变模式生成默认的标签专题图
     * @param datasetVectorId
     * @param expression
     * @param rangeMode
     * @param rangeParameter
     * @param colorGradientType
     * @param promise
     */
    @ReactMethod
    public void makeDefault(String datasetVectorId, String expression, int rangeMode, double rangeParameter, int colorGradientType, Promise promise){
        try{
            DatasetVector datasetVector = JSDatasetVector.getObjFromList(datasetVectorId);
            RangeMode rm = (RangeMode) Enum.parse(RangeMode.class, rangeMode);
            ColorGradientType colorGType = (ColorGradientType) Enum.parse(ColorGradientType.class, colorGradientType);
            m_ThemeLabel = ThemeLabel.makeDefault(datasetVector, expression, rm, rangeParameter, colorGType);

            String id = registerId(m_ThemeLabel);
            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 对标签专题图中分段的风格进行反序显示
     * @param themeRangeId
     * @param promise
     */
    @ReactMethod
    public void reverseStyle(String themeRangeId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            m_ThemeLabel.reverseStyle();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置是否以全方向文本避让
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setAllDirectionsOverlappedAvoided(String themeRangeId, boolean value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            m_ThemeLabel.setAllDirectionsOverlappedAvoided(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置是否沿线显示文本
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setAlongLine(String themeRangeId, boolean value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            m_ThemeLabel.setAlongLine(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标签沿线标注方向
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setAlongLineDirection(String themeRangeId, int value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            AlongLineDirection alongLineDirection = (AlongLineDirection) Enum.parse(AlongLineDirection.class, value);

            m_ThemeLabel.setAlongLineDirection(alongLineDirection);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置沿线文本间隔比率，该方法只对沿线标注起作用
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setAlongLineSpaceRatio(String themeRangeId, double value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            m_ThemeLabel.setAlongLineSpaceRatio(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 当沿线显示文本时，是否将文本角度固定
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setAngleFixed(String themeRangeId, boolean value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            m_ThemeLabel.setAngleFixed(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标签专题图中的标签背景的形状类型
     * @param themeRangeId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setBackShape(String themeRangeId, int value, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            LabelBackShape labelBackShape = (LabelBackShape) Enum.parse(ColorGradientType.class, value);
            m_ThemeLabel.setBackShape(labelBackShape);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置标签专题图中的标签背景风格,OpenGL不支持标签背景透明度
     * @param themeRangeId
     * @param styleId
     * @param promise
     */
    @ReactMethod
    public void setBackStyle(String themeRangeId, String styleId, Promise promise){
        try{
            m_ThemeLabel = (ThemeLabel)getObjFromList(themeRangeId);
            GeoStyle style = JSGeoStyle.getObjFromList(styleId);
            m_ThemeLabel.setBackStyle(style);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

