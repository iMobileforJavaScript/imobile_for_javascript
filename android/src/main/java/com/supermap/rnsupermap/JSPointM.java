package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.PointM;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSPointM extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSPointM";
    public static Map<String, PointM> m_PointMList = new HashMap<String, PointM>();
    PointM m_PointM;

    public JSPointM(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static PointM getObjFromList(String id) {
        return m_PointMList.get(id);
    }

    public static String registerId(PointM obj) {
        for (Map.Entry entry : m_PointMList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_PointMList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObjByXYM(int x, int y, int m, Promise promise) {
        try {
            PointM pointM = new PointM(x, y, m);
            String pointMId = registerId(pointM);

            promise.resolve(pointMId);
        } catch (Exception e) {
            promise.reject(e);
        }
    }



    @ReactMethod
    public void createObj(Promise promise){
        try{
            PointM pointM = new PointM();
            String pointMId = registerId(pointM);

            promise.resolve(pointMId);
        }catch (Exception e){
            promise.reject(e);
        }
    }


    @ReactMethod
    public void getX(String pointMId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            double x = pointM.getX();

            promise.resolve(x);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getY(String pointMId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            double y = pointM.getY();

            promise.resolve(y);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getM(String pointMId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            double m = pointM.getM();

            promise.resolve(m);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回当前 PointM 对象的一个拷贝
     *
     * @param pointMId
     * @param promise
     */
    @ReactMethod
    public void clone(String pointMId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            PointM clonePoint = pointM.clone();
            String clonePointId = registerId(clonePoint);

            promise.resolve(clonePointId);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 指定此 PointM 结构体对象是否与指定的 PointM 有相同的 X、Y、M 值
     *
     * @param pointMId
     * @param targetId
     * @param promise
     */
    @ReactMethod
    public void equals(String pointMId, String targetId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            PointM pointMTarget = getObjFromList(targetId);
            boolean result = pointM.equals(pointMTarget);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回一个空的 PointM 对象
     *
     * @param promise
     */
    @ReactMethod
    public void getEMPTY(Promise promise) {
        try {
            PointM pointM = PointM.getEMPTY();
            String pointMId = registerId(pointM);

            promise.resolve(pointMId);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回此 PointM 结构体对象的哈希代码
     * @param pointMId
     * @param promise
     */
    @ReactMethod
    public void hashCode(String pointMId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            int value = pointM.hashCode();

            promise.resolve(value);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回一个值，该值指示 PointM 对象是否为空
     * @param pointMId
     * @param promise
     */
    @ReactMethod
    public void isEmpty(String pointMId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            boolean value = pointM.isEmpty();

            promise.resolve(value);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置此 PointM 结构体对象的度量值
     * @param pointMId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setM(String pointMId, double value, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            pointM.setM(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置此 PointM 结构体对象的 X 坐标，即 X 方向的分量
     * @param pointMId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setX(String pointMId, double value, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            pointM.setX(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置此 PointM 结构体对象的 Y 坐标，即 Y 方向的分量
     * @param pointMId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setY(String pointMId, double value, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            pointM.setY(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 创建一个表示此 PointM 结构体对象的可读字符串，如 PointM(2,3,4)，返回“{X=2.0,Y=3.0,M=4.0}”
     * @param pointMId
     * @param promise
     */
    @ReactMethod
    public void toString(String pointMId, Promise promise) {
        try {
            PointM pointM = getObjFromList(pointMId);
            String value = pointM.toString();

            promise.resolve(value);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}

