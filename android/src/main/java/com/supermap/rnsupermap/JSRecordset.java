package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.DataUtil;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.Dataset;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.Geometry;
import com.supermap.data.Recordset;
import com.supermap.data.Enum;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSRecordset extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSRecordset";
    private static Map<String, Recordset> m_RecordsetList = new HashMap<String, Recordset>();
    Recordset m_Recordset;

    public JSRecordset(ReactApplicationContext context) {
        super(context);
    }

    public static Recordset getObjFromList(String id) {
        return m_RecordsetList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(Recordset obj) {
        for (Map.Entry entry : m_RecordsetList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_RecordsetList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void getRecordCount(String recordsetId, Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            int recordCount = recordset.getRecordCount();

            WritableMap map = Arguments.createMap();
            map.putInt("recordCount",recordCount);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dispose(String recordsetId,Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            recordset.dispose();
            m_RecordsetList.remove(recordsetId);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getGeometry(String recordsetId,Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            Geometry geometry = recordset.getGeometry();
            String geometryId = JSGeometry.registerId(geometry);

            WritableMap map = Arguments.createMap();
            map.putString("geometryId",geometryId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isEOF(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            boolean isEOF = recordset.isEOF();

            promise.resolve(isEOF);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDataset(String recordsetId,Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            Dataset dataset = recordset.getDataset();
            String datasetId = JSDataset.registerId(dataset);

            WritableMap map = Arguments.createMap();
            map.putString("datasetId",datasetId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveFirst(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            boolean result = recordset.moveFirst();

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveNext(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            recordset.moveNext();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveLast(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            recordset.moveLast();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void movePrev(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            recordset.movePrev();

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void moveTo(String recordsetId, int index, Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            recordset.moveTo(index);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addNew(String recordsetId,String geometryId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);
            boolean result = recordset.addNew(geometry);

            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void edit(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            boolean isEdit = recordset.edit();

            promise.resolve(isEdit);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void update(String recordsetId,Promise promise){
        try{
            Recordset recordset = getObjFromList(recordsetId);
            boolean isUpdate = recordset.update();

            promise.resolve(isUpdate);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFieldCount(String recordsetId,Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            int count = recordset.getFieldCount();

            WritableMap map = Arguments.createMap();
            map.putInt("count", count);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取记录集recordset的中的FieldInfos，promise返回array
     * @param recordsetId 动态记录集
     * @param count 计数器
     * @param size 记录数
     * @param promise
     */
    @ReactMethod
    public void getFieldInfosArray(String recordsetId, int count, int size, Promise promise){
        try{
//            Recordset recordset = m_RecordsetList.get(recordsetId);
//
//            recordset.moveFirst();
//
//            WritableArray recordArray = JsonUtil.recordsetToMap(recordset, count, size);
//
//            promise.resolve(recordArray);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取记录集recordset的中的一个FieldInfos，promise返回array
     * @param recordsetId
     * @param promise
     */
    @ReactMethod
    public void getFieldInfo(String recordsetId, Promise promise){
        try{
//            Recordset recordset = m_RecordsetList.get(recordsetId);
//            WritableArray recordArray = JsonUtil.recordsetToMap(recordset, 0, 1);
//
//            promise.resolve(recordArray);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据要修改的字段名称，设定记录集中相对应字段的值
     * @param recordsetId
     * @param info {name, value}
     * @param promise
     */
    @ReactMethod
    public void setFieldValueByName(String recordsetId, int position, ReadableMap info, Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);

            boolean result = false;
            boolean editResult;
            boolean updateResult;

//            recordset.moveFirst();
            if (position >= 0) {
                recordset.moveTo(position);
            }
            editResult = recordset.edit();
            Map<String, Object> map = info.toHashMap();
            for (Map.Entry<String, Object> item : map.entrySet()) {
                String name = item.getKey();
                Object value = item.getValue();
                if (value == null) {
                    result = recordset.setFieldValueNull(name);
                } else {
                    result = recordset.setFieldValue(name, value);
                }
            }

            updateResult = recordset.update();
            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("result", result);
            wMap.putBoolean("editResult", editResult);
            wMap.putBoolean("updateResult", updateResult);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据要修改的字段的序号，设定记录集中相对应字段的值
     * @param recordsetId
     * @param info {index, value}
     * @param promise
     */
    @ReactMethod
    public void setFieldValueByIndex(String recordsetId, ReadableMap info, Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);

            boolean result = false;
            boolean editResult;
            boolean updateResult;

            recordset.moveFirst();
            editResult = recordset.edit();

            Map<String, Object> map = info.toHashMap();
            for (Map.Entry<String, Object> item : map.entrySet()) {
                int index = Integer.parseInt(item.getKey());
                Object value = item.getValue();
                if (value == null) {
                    result = recordset.setFieldValueNull(index);
                } else {
                    result = recordset.setFieldValue(index, value);
                }
            }

            updateResult = recordset.update();
            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("result", result);
            wMap.putBoolean("editResult", editResult);
            wMap.putBoolean("updateResult", updateResult);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 向当前记录集添加FieldInfo
     * @param recordsetId
     * @param info
     * @param promise
     */
    @ReactMethod
    public void addFieldInfo(String recordsetId, ReadableMap info, Promise promise){
        try{
            Recordset recordset = m_RecordsetList.get(recordsetId);
            boolean editResult;
            boolean updateResult;

            recordset.moveFirst();
            editResult = recordset.edit();

            FieldInfos fieldInfos = recordset.getFieldInfos();
            FieldInfo fieldInfo = new FieldInfo();
            Map<String, Object> map = info.toHashMap();
            for (Map.Entry<String, Object> item : map.entrySet()) {
                String name = item.getKey();
                Object value = item.getValue();
                switch (name) {
                    case "caption":
                        fieldInfo.setCaption((String) value);
                        break;
                    case "name":
                        fieldInfo.setName((String) value);
                        break;
                    case "type":
                        fieldInfo.setType((FieldType) Enum.parse(FieldType.class, ((Number) value).intValue()));
                        break;
                    case "maxLength":
                        fieldInfo.setMaxLength(((Number) value).intValue());
                        break;
                    case "defaultValue":
                        fieldInfo.setDefaultValue((String) value);
                        break;
                    case "isRequired":
                        fieldInfo.setRequired((boolean) value);
                        break;
                    case "isZeroLengthAllowed":
                        fieldInfo.setZeroLengthAllowed((boolean) value);
                        break;
                }
            }

            int index = fieldInfos.add(fieldInfo);

            updateResult = recordset.update();

            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("editResult", editResult);
            wMap.putInt("index", index);
            wMap.putBoolean("updateResult", updateResult);
            promise.resolve(wMap);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 删除当前记录集指定名称的FieldInfo
     * @param recordsetId
     * @param name
     * @param promise
     */
    @ReactMethod
    public void removeFieldInfo(String recordsetId, String name, Promise promise) {
        try {
            Recordset recordset = m_RecordsetList.get(recordsetId);
            boolean result = false;
            boolean editResult;
            boolean updateResult;

            recordset.moveFirst();
            editResult = recordset.edit();

            FieldInfos fieldInfos = recordset.getFieldInfos();
            result = fieldInfos.remove(name);

            updateResult = recordset.update();

            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("editResult", editResult);
            wMap.putBoolean("result", result);
            wMap.putBoolean("updateResult", updateResult);
            promise.resolve(wMap);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 删除当前记录集指定id的记录
     * @param recordsetId
     * @param id
     * @param promise
     */
    @ReactMethod
    public void deleteById(String recordsetId, int id, Promise promise) {
        try {
            Recordset recordset = m_RecordsetList.get(recordsetId);
            recordset.seekID(id);
            boolean result = recordset.delete();

            promise.resolve(result);
        } catch (Exception e){
            promise.reject(e);
        }
    }
}