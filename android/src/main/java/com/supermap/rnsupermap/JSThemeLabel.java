package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.TextStyle;
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

}

