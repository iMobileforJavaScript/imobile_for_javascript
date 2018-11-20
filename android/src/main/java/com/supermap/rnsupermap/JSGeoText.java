package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.GeoText;
import com.supermap.data.TextPart;
import com.supermap.data.TextStyle;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
/**
 * Created by Yang Shanglong on 2018/7/12.
 */

public class JSGeoText extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSGeoText";
    private static Map<String, GeoText> m_GeoTextList = new HashMap<String, GeoText>();
    GeoText m_GeoText;

    public JSGeoText(ReactApplicationContext context) {
        super(context);
    }

    public static GeoText getObjFromList(String id) { return m_GeoTextList.get(id); }

    @Override
    public String getName() { return REACT_CLASS; }

    public static String registerId(GeoText obj) {
        for (Map.Entry entry : m_GeoTextList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_GeoTextList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            GeoText geoText = new GeoText();
            String geoTextId = registerId(geoText);

            promise.resolve(geoTextId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObjWithTextPart(String textPartId,Promise promise){
        try{
            TextPart textPart = JSTextPart.getObjFromList(textPartId);
            GeoText geoText = new GeoText(textPart);
            String geoTextId = registerId(geoText);

            promise.resolve(geoTextId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 释放此对象所占用的资源
     * @param geoTextId
     * @param promise
     */
    @ReactMethod
    public void dispose(String geoTextId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            geoText.dispose();
            m_GeoTextList.remove(geoTextId);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 在文本对象中添加文本子对象
     * @param geoTextId
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void addPart(String geoTextId, String textPartId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            TextPart textPart = JSTextPart.getObjFromList(textPartId);
            int index = geoText.addPart(textPart);

            promise.resolve(index);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回此文本对象的指定序号的子对象
     * @param geoTextId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void getPart(String geoTextId, int index, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            TextPart textPart = geoText.getPart(index);
            String textPartId = JSTextPart.registerId(textPart);

            promise.resolve(textPartId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本对象的子对象个数
     * @param geoTextId
     * @param promise
     */
    @ReactMethod
    public void getPartCount(String geoTextId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            int count = geoText.getPartCount();

            promise.resolve(count);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本对象的内容
     * @param geoTextId
     * @param promise
     */
    @ReactMethod
    public void getText(String geoTextId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            String text = geoText.getText();

            promise.resolve(text);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回文本对象的文本风格
     * @param geoTextId
     * @param promise
     */
    @ReactMethod
    public void getTextStyle(String geoTextId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            TextStyle textStyle = geoText.getTextStyle();
            String textStyleId = JSTextStyle.registerId(textStyle);

            promise.resolve(textStyleId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 在此文本对象的指定位置插入一个文本子对象
     * @param geoTextId
     * @param index
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void insertPart(String geoTextId, int index, String textPartId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            TextPart textPart = JSTextPart.getObjFromList(textPartId);
            geoText.insertPart(index, textPart);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 判定该文本对象是否为空，即其子对象的个数是否为0
     * @param geoTextId
     * @param promise
     */
    @ReactMethod
    public void isEmpty(String geoTextId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            boolean isEmpty = geoText.isEmpty();

            promise.resolve(isEmpty);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 删除此文本对象的指定序号的文本子对象
     * @param geoTextId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void removePart(String geoTextId, int index, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            boolean result = geoText.removePart(index);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 修改此文本对象的指定序号的子对象，即用新的文本子对象来替换原来的文本子对象
     * @param geoTextId
     * @param index
     * @param textPartId
     * @param promise
     */
    @ReactMethod
    public void setPart(String geoTextId, int index, String textPartId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            TextPart textPart = JSTextPart.getObjFromList(textPartId);
            boolean result = geoText.setPart(index, textPart);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置文本对象的文本风格
     * @param geoTextId
     * @param textStyleId
     * @param promise
     */
    @ReactMethod
    public void setTextStyle(String geoTextId, String textStyleId, Promise promise){
        try{
            GeoText geoText = getObjFromList(geoTextId);
            TextStyle textStyle = JSTextStyle.getObjFromList(textStyleId);
            geoText.setTextStyle(textStyle);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

