package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.data.PrjCoordSysType;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSCoordSysTransParameter extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSCoordSysTransParameter";
    public static Map<String, CoordSysTransParameter> m_CoordSysTransParameterList = new HashMap<String, CoordSysTransParameter>();
    CoordSysTransParameter m_CoordSysTransParameter;

    public JSCoordSysTransParameter(ReactApplicationContext context) {
        super(context);
    }

    public static CoordSysTransParameter getObjFromList(String id) {
        return m_CoordSysTransParameterList.get(id);
    }

    public static void removeObjFromList(String id) {
        m_CoordSysTransParameterList.remove(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(CoordSysTransParameter coordSysTransParameter) {
        for (Map.Entry entry : m_CoordSysTransParameterList.entrySet()) {
            if (coordSysTransParameter.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_CoordSysTransParameterList.put(id, coordSysTransParameter);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            CoordSysTransParameter m_CoordSysTransParameter = new CoordSysTransParameter();
            String coordSysTransParameterId = registerId(m_CoordSysTransParameter);

            promise.resolve(coordSysTransParameterId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 对CoordSysTransParameter的clone
     *
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void clone(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            CoordSysTransParameter cloneParameter = coordSysTransParameter.clone();
            String cloneParameterId = JSCoordSysTransParameter.registerId(cloneParameter);

            promise.resolve(cloneParameterId);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 释放该对象所占用的资源
     *
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void dispose(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.dispose();
            removeObjFromList(coordSysTransParameterId);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据 XML 字符串构建 CoordSysTransParameter 对象，成功返回 true
     *
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void fromXML(String coordSysTransParameterId, String value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            boolean result = coordSysTransParameter.fromXML(value);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回 X 轴的旋转角度
     *
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void getRotateX(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            double result = coordSysTransParameter.getRotateX();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回 Z 轴的旋转角度
     *
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void getRotateZ(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            double result = coordSysTransParameter.getRotateZ();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回 Y 轴的旋转角度
     *
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void getRotateY(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            double result = coordSysTransParameter.getRotateY();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回投影比例尺差
     *
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void getScaleDifference(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            double result = coordSysTransParameter.getScaleDifference();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置 X 轴的旋转角度
     *
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void getTranslateX(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            double result = coordSysTransParameter.getTranslateX();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回 Y 轴的坐标偏移量
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void getTranslateY(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            double result = coordSysTransParameter.getTranslateY();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回 Z 轴的坐标偏移量
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void getTranslateZ(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            double result = coordSysTransParameter.getTranslateZ();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置 X 轴的旋转角度
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setRotateX(String coordSysTransParameterId, double value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.setRotateX(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置 Y 轴的旋转角度
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setRotateY(String coordSysTransParameterId, double value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.setRotateY(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置 Z 轴的旋转角度
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setRotateZ(String coordSysTransParameterId, double value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.setRotateZ(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置投影比例尺差
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setScaleDifference(String coordSysTransParameterId, double value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.setScaleDifference(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置 X 轴的坐标偏移量
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTranslateX(String coordSysTransParameterId, double value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.setTranslateX(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置 Y 轴的坐标偏移量
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTranslateY(String coordSysTransParameterId, double value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.setTranslateY(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置 Z 轴的坐标偏移量
     * @param coordSysTransParameterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setTranslateZ(String coordSysTransParameterId, double value, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            coordSysTransParameter.setTranslateZ(value);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 将该 CoordSysTransParameter 对象输出为 XML 字符串
     * @param coordSysTransParameterId
     * @param promise
     */
    @ReactMethod
    public void toXML(String coordSysTransParameterId, Promise promise) {
        try {
            CoordSysTransParameter coordSysTransParameter = getObjFromList(coordSysTransParameterId);
            String result = coordSysTransParameter.toXML();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}

