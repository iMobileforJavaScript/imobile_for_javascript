package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.supermap.analyst.networkanalyst.SupplyCenter;
import com.supermap.analyst.networkanalyst.SupplyCenters;
import com.supermap.analyst.networkanalyst.SupplyCenters;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSSupplyCenters extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSupplyCenters";
    protected static Map<String, SupplyCenters> m_SupplyCentersList = new HashMap<String, SupplyCenters>();
    SupplyCenters m_SupplyCenters;

    public JSSupplyCenters(ReactApplicationContext context) {
        super(context);
    }

    public static SupplyCenters getObjFromList(String id) {
        return m_SupplyCentersList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(SupplyCenters obj) {
        for (Map.Entry entry : m_SupplyCentersList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_SupplyCentersList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            SupplyCenters supplyCenters = new SupplyCenters();
            String supplyCentersId = registerId(supplyCenters);

            promise.resolve(supplyCentersId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 添加资源供给中心对象到此集合中，添加成功返回被添加对象的序号
     * @param supplyCentersId
     * @param supplyCenterId
     * @param promise
     */
    @ReactMethod
    public void add(String supplyCentersId, String supplyCenterId, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            SupplyCenter supplyCenter = JSSupplyCenter.getObjFromList(supplyCenterId);
            
            int index = supplyCenters.add(supplyCenter);

            promise.resolve(index);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 以数组形式向集合中添加资源供给中心对象，添加成功，返回添加的资源供给中心对象的个数
     * @param supplyCentersId
     * @param supplyCenterIds
     * @param promise
     */
    @ReactMethod
    public void addRange(String supplyCentersId, ReadableArray supplyCenterIds, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            SupplyCenter[] supplyCentersArr = new SupplyCenter[supplyCenterIds.size()];
            for (int i = 0; i < supplyCenterIds.size(); i++) {
                String supplyCenterId = supplyCenterIds.getString(i);
                SupplyCenter supplyCenter = JSSupplyCenter.getObjFromList(supplyCenterId);
                supplyCentersArr[i] = supplyCenter;
            }
            int count = supplyCenters.addRange(supplyCentersArr);

            promise.resolve(count);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 清空集合中的资源供给中心对象
     * @param supplyCentersId
     * @param promise
     */
    @ReactMethod
    public void clear(String supplyCentersId, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            supplyCenters.clear();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回此资源供给中心集合对象中指定序号的资源供给中心对象
     * @param supplyCentersId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void get(String supplyCentersId, int index, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            SupplyCenter supplyCenter = supplyCenters.get(index);
            String supplyCenterId = JSSupplyCenter.registerId(supplyCenter);

            promise.resolve(supplyCenterId);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 在资源供给中心集合中删除指定序号的资源供给中心对象
     * @param supplyCentersId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void remove(String supplyCentersId, int index, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            boolean result = supplyCenters.remove(index);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 在资源供给中心集合中从指定序号开始，删除指定个数的资源供给中心对
     * @param supplyCentersId
     * @param index
     * @param count
     */
    @ReactMethod
    public void removeRange(String supplyCentersId, int index, int count, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            int result = supplyCenters.removeRange(index, count);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 返回资源供给中心点的个数
     * @param supplyCentersId
     * @param promise
     */
    @ReactMethod
    public void getCount(String supplyCentersId, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            int count = supplyCenters.getCount();

            promise.resolve(count);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置此资源供给中心集合对象中指定序号的资源供给中心对象
     * @param supplyCentersId
     * @param index
     * @param supplyCenterId
     * @param promise
     */
    @ReactMethod
    public void set(String supplyCentersId, int index, String supplyCenterId, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            SupplyCenter supplyCenter = JSSupplyCenter.getObjFromList(supplyCenterId);
            supplyCenters.set(index, supplyCenter);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 将资源供给中心集合对象转换为资源供给中心对象数组
     * @param supplyCentersId
     * @param promise
     */
    @ReactMethod
    public void toArray(String supplyCentersId, Promise promise){
        try{
            SupplyCenters supplyCenters = getObjFromList(supplyCentersId);
            SupplyCenter[] arr = supplyCenters.toArray();

            WritableArray array = Arguments.createArray();
            for (int i = 0; i < arr.length; i++) {
                String supplyCenterId = JSSupplyCenter.registerId(arr[i]);
                array.pushString(supplyCenterId);
            }

            promise.resolve(array);
        }catch (Exception e){
            promise.reject(e);
        }
    }
}

