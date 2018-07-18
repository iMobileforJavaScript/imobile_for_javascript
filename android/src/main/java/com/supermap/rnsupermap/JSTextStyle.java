package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Color;
import com.supermap.data.TextAlignment;
import com.supermap.data.TextStyle;
import com.supermap.data.Enum;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
* Created by Yang Shanglong on 2018/7/12.
*/

public class JSTextStyle extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTextStyle";
    private static Map<String, TextStyle> m_TextStyleList = new HashMap<String, TextStyle>();
    TextStyle m_TextStyle;

    public JSTextStyle(ReactApplicationContext context) {
        super(context);
    }

    public static TextStyle getObjFromList(String id) { return m_TextStyleList.get(id); }

    @Override
    public String getName() { return REACT_CLASS; }

    public static String registerId(TextStyle obj) {
        for (Map.Entry entry : m_TextStyleList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_TextStyleList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            TextStyle textStyle = new TextStyle();
            String textStyleId = registerId(textStyle);

            promise.resolve(textStyleId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回当前 TextStyle 对象的一个拷贝
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void clone(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            TextStyle newTextStyle = textStyle.clone();
            String newTextStyleId = registerId(newTextStyle);

            promise.resolve(newTextStyle);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 释放该对象所占用的资源
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void dispose(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.dispose();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 将指定的几何对象绘制成图片
     * @param textStyleId
     * @param geometryId
     * @param resourcesId
     * @param fileName
     * @param promise
     */
    @ReactMethod
    public void drawToPNG(String textStyleId, String geometryId, String resourcesId, String fileName, Promise promise){
        // TODO 待做
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
//            textStyle.dispose();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本的对齐方式
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getAlignment(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            TextAlignment textAlignment = textStyle.getAlignment();
            int ta = textAlignment.value();

            promise.resolve(ta);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本的背景色
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getBackColor(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            Color color = textStyle.getBackColor();
            int r = color.getR();
            int g = color.getG();
            int b = color.getB();
            int a = color.getA();

            WritableMap map = Arguments.createMap();
            map.putInt("r", r);
            map.putInt("g", g);
            map.putInt("b", b);
            map.putInt("a", a);

            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取背景半透明度
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getBackTransparency(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            int backTransparency = textStyle.getBackTransparency();

            promise.resolve(backTransparency);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本字体的高度
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getFontHeight(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            double fontHeight = textStyle.getFontHeight();

            promise.resolve(fontHeight);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本字体的名称
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getFontName(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            String name = textStyle.getFontName();

            promise.resolve(name);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取注记字体的缩放比例
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getFontScale(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            double scale = textStyle.getFontScale();

            promise.resolve(scale);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本的宽度
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getFontWidth(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            double width = textStyle.getFontWidth();

            promise.resolve(width);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本的前景色
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getForeColor(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            Color color = textStyle.getForeColor();
            int r = color.getR();
            int g = color.getG();
            int b = color.getB();
            int a = color.getA();

            WritableMap map = Arguments.createMap();
            map.putInt("r", r);
            map.putInt("g", g);
            map.putInt("b", b);
            map.putInt("a", a);

            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本是否采用斜体，true 表示采用斜体
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getItalic(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean isItalic = textStyle.getItalic();

            promise.resolve(isItalic);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回字体倾斜角度，正负度之间，以度为单位，精确到0.1度
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getItalicAngle(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            double italicAngle = textStyle.getItalicAngle();

            promise.resolve(italicAngle);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回是否以轮廓的方式来显示文本的背景
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getOutline(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean isOutline = textStyle.getOutline();

            promise.resolve(isOutline);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本旋转的角度
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getRotation(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            double rotation = textStyle.getRotation();

            promise.resolve(rotation);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本是否有阴影
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getShadow(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean hasShadow = textStyle.getShadow();

            promise.resolve(hasShadow);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本字体是否加删除线
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getStrikeout(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean strikeout = textStyle.getStrikeout();

            promise.resolve(strikeout);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本字体是否加下划线
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getUnderline(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean underline = textStyle.getUnderline();

            promise.resolve(underline);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本字体的磅数，表示粗体的具体数值
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void getWeight(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            int backTransparency = textStyle.getWeight();

            promise.resolve(backTransparency);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回注记背景是否透明
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void isBackOpaque(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean isBackOpaque = textStyle.isBackOpaque();

            promise.resolve(isBackOpaque);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回注记是否为粗体字
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void isBold(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean isBold = textStyle.isBold();

            promise.resolve(isBold);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本大小是否固定
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void isSizeFixed(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            boolean isSizeFixed = textStyle.isSizeFixed();

            promise.resolve(isSizeFixed);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本大小是否固定
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void setAlignment(String textStyleId, int textAlignmentValue, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            TextAlignment textAlignment = (TextAlignment)Enum.parse(TextAlignment.class, textAlignmentValue);
            textStyle.setAlignment(textAlignment);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本的背景色
     * @param textStyleId
     * @param r
     * @param g
     * @param b
     * @param a
     * @param promise
     */
    @ReactMethod
    public void setBackColor(String textStyleId, int r, int g, int b, int a, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            Color color = new Color(r, g, b, a);
            textStyle.setBackColor(color);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本背景是否不透明，true 表示文本背景不透明
     * @param textStyleId
     * @param backOpaque
     * @param promise
     */
    @ReactMethod
    public void setBackOpaque(String textStyleId, boolean backOpaque, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setBackOpaque(backOpaque);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置背景透明度
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setBackTransparency(String textStyleId, int value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setBackTransparency(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本是否为粗体字，true 表示为粗
     * @param textStyleId
     * @param isBold
     * @param promise
     */
    @ReactMethod
    public void setBold(String textStyleId, boolean isBold, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setBold(isBold);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本字体的高度
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFontHeight(String textStyleId, double value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setFontHeight(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本字体的名称
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFontName(String textStyleId, String value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setFontName(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置注记字体的缩放比例
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFontScale(String textStyleId, double value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setFontScale(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本的宽度
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setFontWidth(String textStyleId, double value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setFontWidth(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本的前景色
     * @param textStyleId
     * @param r
     * @param g
     * @param b
     * @param a
     * @param promise
     */
    @ReactMethod
    public void setForeColor(String textStyleId, int r, int g, int b, int a, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            Color color = new Color(r, g, b, a);
            textStyle.setForeColor(color);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本是否采用斜体，true 表示采用斜体
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setItalic(String textStyleId, boolean value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setItalic(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置字体倾斜角度，正负度之间，以度为单位，精确到0.1度
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setItalicAngle(String textStyleId, double value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setItalicAngle(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置是否以轮廓的方式来显示文本的背景
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setOutline(String textStyleId, boolean value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setOutline(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本旋转的角度
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setRotation(String textStyleId, double value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setRotation(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本是否有阴影
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setShadow(String textStyleId, boolean value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setShadow(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本大小是否固定
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setSizeFixed(String textStyleId, boolean value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setSizeFixed(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本字体是否加删除线
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setStrikeout(String textStyleId, boolean value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setStrikeout(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本字体是否加下划线
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setUnderline(String textStyleId, boolean value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setUnderline(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本字体的磅数，表示粗体的具体数值
     * @param textStyleId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setWeight(String textStyleId, int value, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            textStyle.setWeight(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回一个表示此文本风格类对象的格式化字符串
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void toString(String textStyleId, Promise promise){
        try{
            TextStyle textStyle = getObjFromList(textStyleId);
            String value = textStyle.toString();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

