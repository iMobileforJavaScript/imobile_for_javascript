package com.supermap.rnsupermap;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.analyst.networkanalyst.SupplyCenter;
import com.supermap.analyst.networkanalyst.SupplyCenterType;
import com.supermap.data.Enum;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSSupplyCenter extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSupplyCenter";
    protected static Map<String, SupplyCenter> m_SupplyCenterList = new HashMap<String, SupplyCenter>();
    SupplyCenter m_SupplyCenter;

    public JSSupplyCenter(ReactApplicationContext context) {
        super(context);
    }

    public static SupplyCenter getObjFromList(String id) {
        return m_SupplyCenterList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(SupplyCenter obj) {
        for (Map.Entry entry : m_SupplyCenterList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_SupplyCenterList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            SupplyCenter supplyCenter = new SupplyCenter();
            String supplyCenterId = registerId(supplyCenter);

            promise.resolve(supplyCenterId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回资源供给中心点的 ID
     * @param supplyCenterId
     * @param promise
     */
    @ReactMethod
    public void getID(String supplyCenterId, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            int id = supplyCenter.getID();

            promise.resolve(id);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回资源供给中心的最大耗费（阻值）
     * @param supplyCenterId
     * @param promise
     */
    @ReactMethod
    public void getMaxWeight(String supplyCenterId, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            double value = supplyCenter.getMaxWeight();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回资源供给中心的资源量
     * @param supplyCenterId
     * @param promise
     */
    @ReactMethod
    public void getResourceValue(String supplyCenterId, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            double value = supplyCenter.getResourceValue();

            promise.resolve(value);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回网络分析中资源供给中心点的类型
     * @param supplyCenterId
     * @param promise
     */
    @ReactMethod
    public void getType(String supplyCenterId, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            SupplyCenterType type = supplyCenter.getType();
            int typeInt = type.value();

            promise.resolve(typeInt);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置资源供给中心点的 ID
     * @param supplyCenterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setID(String supplyCenterId, int value, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            supplyCenter.setID(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置资源供给中心的最大耗费（阻值）
     * @param supplyCenterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setMaxWeight(String supplyCenterId, double value, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            supplyCenter.setMaxWeight(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置资源供给中心的资源量
     * @param supplyCenterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setResourceValue(String supplyCenterId, double value, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            supplyCenter.setResourceValue(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置网络分析中资源供给中心点的类型
     * @param supplyCenterId
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setType(String supplyCenterId, int value, Promise promise){
        try{
            SupplyCenter supplyCenter = getObjFromList(supplyCenterId);
            SupplyCenterType type = (SupplyCenterType) Enum.parse(SupplyCenterType.class, value);
            supplyCenter.setType(type);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

