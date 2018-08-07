package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Size2D;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSSize2D extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSize2D";
    private static Map<String, Size2D> m_Size2DList = new HashMap<String, Size2D>();
    Size2D m_Size2D;

    public JSSize2D(ReactApplicationContext context) {
        super(context);
    }

    public static Size2D getObjFromList(String id) {
        return m_Size2DList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Size2D obj) {
        for (Map.Entry entry : m_Size2DList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_Size2DList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(int w, int h, Promise promise) {
        try {
            Size2D size2D = new Size2D(w, h);
            String size2DId = registerId(size2D);

            promise.resolve(size2DId);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回一个新的 Size2D 对象，其宽度和高度值为大于等于指定 Size2D 对象对应值的最小整数值，例如给定 Size2D(2.3,6.8)，则生成的新的对象为 Size2D(3,7)
     * @param size2DId
     * @param promise
     */
    @ReactMethod
    public void ceiling(String size2DId, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            Size2D newSize2D = Size2D.ceiling(size2D);
            String newSize2DId = registerId(newSize2D);

            promise.resolve(newSize2DId);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回当前 Size2D 对象的一个拷贝
     * @param size2DId
     * @param promise
     */
    @ReactMethod
    public void clone(String size2DId, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            Size2D newSize2D = size2D.clone();
            String newSize2DId = registerId(newSize2D);

            promise.resolve(newSize2DId);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 判定此 Size2D 是否与指定 Size2D 有相同的坐标
     * @param size2DId1
     * @param size2DId2
     * @param promise
     */
    @ReactMethod
    public void equals(String size2DId1, String size2DId2, Promise promise) {
        try {
            Size2D size2D1 = getObjFromList(size2DId1);
            Size2D size2D2 = getObjFromList(size2DId2);
            boolean result = size2D1.equals(size2D2);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回此 Size2D 的垂直分量，即高度
     * @param size2DId
     * @param promise
     */
    @ReactMethod
    public void getHeight(String size2DId, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            double result = size2D.getHeight();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回此 Size2D 的水平分量，即宽度
     * @param size2DId
     * @param promise
     */
    @ReactMethod
    public void getWidth(String size2DId, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            double result = size2D.getWidth();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 判断当前 Size2D 对象是否为空，即是否宽度和高度均为 -1.7976931348623157e+308
     * @param size2DId
     * @param promise
     */
    @ReactMethod
    public void isEmpty(String size2DId, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            boolean result = size2D.isEmpty();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回一个新的 Size2D 对象，其宽度和高度值是通过对给定 Size2D 对象的对应值进行四舍五入得到，例如给定 Size2D(2.3,6.8)， 则四舍五入后的新的对象为 Size2D(2,7)
     * @param size2DId
     * @param promise
     */
    @ReactMethod
    public void round(String size2DId, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            Size2D result = Size2D.round(size2D);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置此 Size2D 的垂直分量，即高度
     * @param size2DId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setHeight(String size2DId, double value, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            size2D.setHeight(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置此 Size2D 的水平分量，即宽度
     * @param size2DId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setWidth(String size2DId, double value, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            size2D.setWidth(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回一个此 Size2D 对象宽度和高度的格式化字符串
     * @param size2DId
     * @param promise
     */
    @ReactMethod
    public void toString(String size2DId, Promise promise) {
        try {
            Size2D size2D = getObjFromList(size2DId);
            String result = size2D.toString();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}

