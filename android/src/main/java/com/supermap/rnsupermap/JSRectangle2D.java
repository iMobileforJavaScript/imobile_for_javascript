package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Point2D;
import com.supermap.data.Rectangle2D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSRectangle2D extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSRectangle2D";
    private static Map<String, Rectangle2D> m_Rectangle2DList = new HashMap<String, Rectangle2D>();
    Rectangle2D m_Rectangle2D;

    public JSRectangle2D(ReactApplicationContext context) {
        super(context);
    }

    public static Rectangle2D getObjFromList(String id) {
        return m_Rectangle2DList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Rectangle2D obj) {
        for (Map.Entry entry : m_Rectangle2DList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_Rectangle2DList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObjBy2Pt(String rightTopId, String leftBottomId, Promise promise){
        try{
            Point2D ptRightTop = JSPoint2D.m_Point2DList.get(rightTopId);
            Point2D ptLeftBottom = JSPoint2D.m_Point2DList.get(leftBottomId);
            Rectangle2D rectangle2D = new Rectangle2D(ptRightTop,ptLeftBottom);
            String rectangle2DId = registerId(rectangle2D);

            WritableMap map = Arguments.createMap();
            map.putString("rectangle2DId",rectangle2DId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            Rectangle2D rectangle2D = new Rectangle2D();
            String rectangle2DId = registerId(rectangle2D);

            WritableMap map = Arguments.createMap();
            map.putString("rectangle2DId",rectangle2DId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

