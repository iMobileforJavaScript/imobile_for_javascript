package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Point2D;
import com.supermap.data.TextPart;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
/**
 * Created by Yang Shanglong on 2018/7/12.
 */

public class JSTextPart extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSTextPart";
    private static Map<String, TextPart> m_TextPartList = new HashMap<String, TextPart>();
    TextPart m_TextPart;

    public JSTextPart(ReactApplicationContext context) {
        super(context);
    }

    public static TextPart getObjFromList(String id) { return m_TextPartList.get(id); }

    @Override
    public String getName() { return REACT_CLASS; }

    public static String registerId(TextPart obj) {
        for (Map.Entry entry : m_TextPartList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_TextPartList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            TextPart textPart = new TextPart();
            String textPartId = registerId(textPart);

            promise.resolve(textPartId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjWithPoint2D(String text, String anchorPointId, Promise promise){
        try{
            Point2D point2D = JSPoint2D.getObjFromList(anchorPointId);
            TextPart textPart = new TextPart(text, point2D);
            String textPartId = registerId(textPart);

            promise.resolve(textPartId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 释放此对象所占用的资源
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void dispose(String textPartId, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            textPart.dispose();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回此文本子对象实例的锚点，其类型为 Point2D
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void getAnchorPoint(String textPartId, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            Point2D point2D = textPart.getAnchorPoint();
            String point2DId = JSPoint2D.registerId(point2D);

            promise.resolve(point2DId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回此文本子对象的旋转角度
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void getRotation(String textPartId, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            double rotation = textPart.getRotation();

            promise.resolve(rotation);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回此文本子对象的文本内容
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void getText(String textPartId, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            String text = textPart.getText();

            promise.resolve(text);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置此文本子对象锚点的横坐标
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void getX(String textPartId, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            double x = textPart.getX();

            promise.resolve(x);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 置此文本子对象锚点的纵坐标
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void getY(String textPartId, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            double y = textPart.getY();

            promise.resolve(y);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置此文本子对象实例的锚点，其类型为 Point2D
     * @param textPartId
     * @param point2DId
     * @param promise
     */
    @ReactMethod
    public void setAnchorPoint(String textPartId, String point2DId, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            Point2D point2D = JSPoint2D.getObjFromList(point2DId);
            textPart.setAnchorPoint(point2D);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置此文本子对象的旋转角度
     * @param textPartId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setRotation(String textPartId, double value, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            textPart.setRotation(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置此文本子对象的文本内容
     * @param textPartId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setText(String textPartId, String value, Promise promise){
        try{
            TextPart textPart = getObjFromList(textPartId);
            textPart.setText(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

