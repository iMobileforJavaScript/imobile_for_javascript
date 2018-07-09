package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.JsonWriter;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.RNUtils.N_R_EventSender;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.data.CursorType;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.Geometry;
import com.supermap.data.Point2D;
import com.supermap.data.QueryListener;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.data.Rectangle2D;
import com.supermap.data.SpatialIndexType;

import org.json.JSONArray;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import static com.facebook.react.bridge.ReadableType.Array;

public class JSDatasetVector extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSDatasetVector";
    public static final String QUERYBYFILTER = "com.supermap.RN.JSDatasetVector.query_by_filter";
    private static Map<String, DatasetVector> m_DatasetVectorList = new HashMap<String, DatasetVector>();
    DatasetVector m_DatasetVector;
    ReactContext mReactContext;

    public JSDatasetVector(ReactApplicationContext context) {
        super(context);
    }

    public static DatasetVector getObjFromList(String id) {
        return m_DatasetVectorList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(DatasetVector obj) {
        for (Map.Entry entry : m_DatasetVectorList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_DatasetVectorList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void queryInBuffer(String datasetVectorId, String rectangle2DId, int cursorType, Promise promise) {
        try {
            DatasetVector datasetVector = m_DatasetVectorList.get(datasetVectorId);
            Rectangle2D rectangle2D = JSRectangle2D.getObjFromList(rectangle2DId);
            Recordset recordset = datasetVector.query(rectangle2D, (CursorType) Enum.parse(CursorType.class, cursorType));
            String recordsetId = JSRecordset.registerId(recordset);

            WritableMap map = Arguments.createMap();
            map.putString("recordsetId", recordsetId);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getRecordset(String dataVectorId, boolean isEmptyRecordset, int cursorType, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Recordset recordset = datasetVector.getRecordset(isEmptyRecordset, (CursorType) Enum.parse(CursorType.class, cursorType));
            String recordsetId = JSRecordset.registerId(recordset);

            WritableMap map = Arguments.createMap();
            map.putString("recordsetId", recordsetId);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 返回一个recordset的JSON对象，包含records记录数组
     *
     * @param dataVectorId
     * @param queryParameterId
     * @param size
     * @param batch
     * @param promise
     */
    @ReactMethod
    public void query(String dataVectorId, String queryParameterId, int size, int batch, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Recordset recordset;
            QueryParameter queryParameter = null;
            String geoJson = "";    //返回的dataset集合字符串（JSON格式）
            if (queryParameterId.equals("0")) {
                recordset = datasetVector.getRecordset(false, CursorType.STATIC);
            } else {
                queryParameter = JSQueryParameter.getObjFromList(queryParameterId);
                recordset = datasetVector.query(queryParameter);
            }

            String recordsetId = JSRecordset.registerId(recordset);
            if(recordset.getRecordCount() == 0) throw new Error("No records be found.");
            //获取字段信息
//            FieldInfos fieldInfos = recordset.getFieldInfos();
//            Map<String, FieldType> fields = new HashMap<>();
//
//            for (int i = 0; i < fieldInfos.getCount(); i++) {
//                fields.put(fieldInfos.get(i).getName(), fieldInfos.get(i).getType());
//            }
            //JS数组，存放
//            WritableArray recordArray = Arguments.createArray();

            //分批处理
            int totalCount = recordset.getRecordCount(); //记录总数
            int batches;    //总批数
            size = size > 10 ? 10 : size ;  //一次返回最多10条记录
            if (totalCount % size != 0) {
                batches = totalCount / size + 1;
            } else {
                batches = totalCount / size;
            }
            recordset.moveFirst();

            //batch超出范围
            batch = batch < 1 ? 1 : batch ;
            batch = batch > batches ? batches : batch;
            recordset.moveTo(size * (batch - 1));
            geoJson = recordset.toGeoJSON(true,size);
            geoJson = JsonUtil.rectifyGeoJSON(geoJson);
//            int count = 0;
//            while (!recordset.isEmpty() && !recordset.isEOF() && count < size) {
//                WritableMap recordsMap = parseRecordset(recordset, fields);
//                recordArray.pushMap(recordsMap);
//                recordset.moveNext();
//                count++;
//            }

            WritableMap returnMap = Arguments.createMap();
//            returnMap.putArray("records", recordArray);
            returnMap.putString("geoJson",geoJson);
            returnMap.putString("queryParameterId", queryParameterId);
            returnMap.putInt("counts", totalCount);
            returnMap.putInt("batch", batch);
            returnMap.putInt("size", size);
            returnMap.putString("recordsetId", recordsetId);

            promise.resolve(returnMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取一个记录中的各项属性值
     *
     * @param recordset 记录（静态）
     * @param fields    该记录中的所有属性
     * @return
     */
    private WritableMap parseRecordset(Recordset recordset, Map<String, FieldType> fields) {
        WritableMap map = Arguments.createMap();

        for (Map.Entry field : fields.entrySet()) {
            String name = (String) field.getKey();
            FieldType type = (FieldType) field.getValue();
            if (type == FieldType.DOUBLE) {
                Double d = (Double) recordset.getFieldValue(name);
                map.putDouble(name, (Double) recordset.getFieldValue(name));
            } else if (type == FieldType.SINGLE) {
                BigDecimal b = new BigDecimal(recordset.getFieldValue(name).toString());
                Double d = b.doubleValue();
                map.putDouble(name, d);
            } else if (type == FieldType.CHAR ||
                    type == FieldType.TEXT ||
                    type == FieldType.WTEXT ||
                    type == FieldType.DATETIME
                    ) {
                map.putString(name, (String) recordset.getFieldValue(name));
            } else if (type == FieldType.BYTE ||
                    type == FieldType.INT16 ||
                    type == FieldType.INT32 ||
                    type == FieldType.INT64 ||
                    type == FieldType.LONGBINARY
                    ) {
                map.putInt(name, (Integer) recordset.getFieldValue(name));
            } else {
                map.putBoolean(name, (Boolean) recordset.getFieldValue(name));
            }
        }
        return map;
    }

    @ReactMethod
    public void buildSpatialIndex(String dataVectorId, int spatialIndexType, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            boolean built = datasetVector.buildSpatialIndex((SpatialIndexType) Enum.parse(SpatialIndexType.class, spatialIndexType));

            WritableMap map = Arguments.createMap();
            map.putBoolean("built", built);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void dropSpatialIndex(String dataVectorId, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            boolean dropped = datasetVector.dropSpatialIndex();

            WritableMap map = Arguments.createMap();
            map.putBoolean("dropped", dropped);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getSpatialIndexType(String dataVectorId, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            SpatialIndexType s = datasetVector.getSpatialIndexType();
            int type = Enum.getValueByName(SpatialIndexType.class, s.name());

            WritableMap map = Arguments.createMap();
            map.putInt("type", type);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void computeBounds(String dataVectorId, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Rectangle2D rectangle2D = datasetVector.computeBounds();
            WritableMap bounds = JsonUtil.rectangleToJson(rectangle2D);

            WritableMap map = Arguments.createMap();
            map.putMap("bounds", bounds);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void toGeoJSON(String dataVectorId, Boolean hasAttribute, int startId, int endId, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            String geoJSON = datasetVector.toGeoJSON(hasAttribute, startId, endId);
            geoJSON = JsonUtil.rectifyGeoJSON(geoJSON);

            WritableMap map = Arguments.createMap();
            map.putString("geoJSON", geoJSON);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void fromGeoJSON(String dataVectorId, String geoJson, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            boolean done = datasetVector.fromGeoJSON(geoJson);

            WritableMap map = Arguments.createMap();
            map.putBoolean("done", done);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void queryByFilter(String dataVectorId, String attributeFilter,String geometryId,int count, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Geometry geometry = JSGeometry.getObjFromList(geometryId);

            datasetVector.setQueryListener(new QueryListener() {
                @Override
                public void queryResult(Dataset dataset, String fieldName, Vector<Integer> SmIDs) {
                    DatasetVector datasetVector1 = (DatasetVector)dataset;
                    Object[] arr = SmIDs.toArray();
                    int[] ids = {};
                    for ( int i = 0 ; i < arr.length ; i ++ ){
                        ids[i] = (int)arr[i];
                    }
                    Recordset recordset = datasetVector1.query(ids,CursorType.STATIC);
                    String[] geoJson = JsonUtil.recordsetToGeoJsons(recordset);

                    WritableArray writableArray = Arguments.createArray();
                    for (int i = 0 ; i < geoJson.length ; i++ ){
                        writableArray.pushString(geoJson[i]);
                    }
                    N_R_EventSender.sendEvent(mReactContext,QUERYBYFILTER,writableArray);
                }
            });
            datasetVector.queryByFilter(attributeFilter,geometry,count);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getSMID(String dataVectorId, String SQL, Promise promise) {
        try {
            WritableArray arr = new WritableNativeArray();
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Recordset recordset = datasetVector.query(SQL,CursorType.STATIC);

            int count = recordset.getRecordCount();
            for (int num = 0;num<count;num++){
                if (recordset.moveTo(num)){
                    int SmID = (int)recordset.getFieldValue("SMID");
                    arr.pushInt(SmID);
                }
            }
            WritableMap map = Arguments.createMap();
            map.putArray("result", arr);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getFieldValue(String dataVectorId, String SQL, String fieldName, Promise promise) {
        try {
            WritableArray arr = new WritableNativeArray();
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Recordset recordset = datasetVector.query(SQL,CursorType.STATIC);

            int count = recordset.getRecordCount();
            for (int num = 0;num<count;num++){
                if (recordset.moveTo(num)){
                    Object fieldValue = (int)recordset.getFieldValue(fieldName);
                    if (fieldValue instanceof Integer){
                        arr.pushInt((Integer)fieldValue);
                    }else if (fieldValue instanceof String){
                        arr.pushString((String)fieldValue);
                    }else if (fieldValue instanceof Double){
                        arr.pushDouble((Double)fieldValue);
                    }else if (fieldValue instanceof  Float){
                        arr.pushDouble((Double)fieldValue);
                    }else  if (fieldValue instanceof Boolean){
                        arr.pushBoolean((Boolean)fieldValue);
                    }
                }
            }
            WritableMap map = Arguments.createMap();
            map.putArray("result", arr);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getGeoInnerPoint(String dataVectorId, String SQL, Promise promise) {
        try {

            WritableArray arr = new WritableNativeArray();
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Recordset recordset = datasetVector.query(SQL,CursorType.STATIC);

            int count = recordset.getRecordCount();
            for (int num = 0;num<count;num++){
                if (recordset.moveTo(num)){
                    Geometry geo = recordset.getGeometry();
                    Point2D point = geo.getInnerPoint();
                    WritableArray pointArr = new WritableNativeArray();
                    double x = point.getX();
                    double y = point.getY();
                    pointArr.pushDouble(x);
                    pointArr.pushDouble(y);
                    arr.pushArray(pointArr);
                }
            }
            WritableMap map = Arguments.createMap();
            map.putArray("result", arr);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setFieldValueByName(String dataVectorId, ReadableMap info, Promise promise){
        try{
            DatasetVector datasetVector = getObjFromList(dataVectorId);
            Recordset recordset = datasetVector.getRecordset(false, CursorType.DYNAMIC);

            boolean result = false;
            boolean editResult;
            boolean updateResult;

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

//    /**
//     * 向当前记录集添加FieldInfo
//     * @param recordsetId
//     * @param info
//     * @param promise
//     */
//    @ReactMethod
//    public void addFieldInfo(String recordsetId, ReadableMap info, Promise promise){
//        try{
//            Recordset recordset = m_RecordsetList.get(recordsetId);
//
//            queryByFilter();
//
//
//            boolean editResult;
//            boolean updateResult;
//
//            recordset.moveFirst();
//            editResult = recordset.edit();
//
//            FieldInfos fieldInfos = recordset.getFieldInfos();
//            FieldInfo fieldInfo = new FieldInfo();
//
//            Map<String, Object> map = info.toHashMap();
//            for (Map.Entry<String, Object> item : map.entrySet()) {
//                String name = item.getKey();
//                Object value = item.getValue();
//                switch (name) {
//                    case "caption":
//                        fieldInfo.setCaption((String) value);
//                        break;
//                    case "name":
//                        fieldInfo.setName((String) value);
//                        break;
//                    case "type":
//                        fieldInfo.setType((FieldType) Enum.parse(FieldType.class, ((Number) value).intValue()));
//                        break;
//                    case "maxLength":
//                        fieldInfo.setMaxLength(((Number) value).intValue());
//                        break;
//                    case "defaultValue":
//                        fieldInfo.setDefaultValue((String) value);
//                        break;
//                    case "isRequired":
//                        fieldInfo.setRequired((boolean) value);
//                        break;
//                    case "isZeroLengthAllowed":
//                        fieldInfo.setZeroLengthAllowed((boolean) value);
//                        break;
//                }
//            }
//
//            int index = fieldInfos.add(fieldInfo);
//
//            updateResult = recordset.update();
//
//            WritableMap wMap = Arguments.createMap();
//            wMap.putBoolean("editResult", editResult);
//            wMap.putInt("index", index);
//            wMap.putBoolean("updateResult", updateResult);
//            promise.resolve(wMap);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//    }

    /**
     * 获取DataVector的FieldInfos
     * @param dataVectorId
     * @param promise
     */
    @ReactMethod
    public void getFieldInfos(String dataVectorId, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);

            FieldInfos fieldInfos = datasetVector.getFieldInfos();

            WritableMap writableMap = fieldInfosToMap(fieldInfos);

            promise.resolve(writableMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 向当前记录集添加FieldInfo
     * @param dataVectorId
     * @param info
     * @param promise
     */
    @ReactMethod
    public void addFieldInfo(String dataVectorId, ReadableMap info, Promise promise){
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);

            FieldInfos fieldInfos = datasetVector.getFieldInfos();

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

            WritableMap wMap = Arguments.createMap();
            wMap.putInt("index", index);
            promise.resolve(wMap);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据名称修改指定的FieldInfo
     * @param dataVectorId
     * @param infoName
     * @param info
     * @param promise
     */
    @ReactMethod
    public void editFieldInfoByName(String dataVectorId, String infoName, ReadableMap info, Promise promise){
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);

            if (!datasetVector.isOpen()) {
                Boolean isopen = datasetVector.open();
            }

            FieldInfos fieldInfos = datasetVector.getFieldInfos();

            FieldInfo fieldInfo = fieldInfos.get(infoName);

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
            WritableMap wMap = Arguments.createMap();
            wMap.putInt("index", index);
            promise.resolve(wMap);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据序号修改指定的FieldInfo
     * @param dataVectorId
     * @param index
     * @param info
     * @param promise
     */
    @ReactMethod
    public void editFieldInfoByIndex(String dataVectorId, int index, ReadableMap info, Promise promise){
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);

            if (!datasetVector.isOpen()) {
                datasetVector.open();
            }

            FieldInfos fieldInfos = datasetVector.getFieldInfos();

            FieldInfo fieldInfo = fieldInfos.get(index);

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

            int ind = fieldInfos.add(fieldInfo);

            WritableMap wMap = Arguments.createMap();
            wMap.putInt("index", ind);
            promise.resolve(wMap);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据序号删除FieldInfo
     * @param dataVectorId
     * @param index
     * @param promise
     */
    @ReactMethod
    public void removeFieldInfoByIndex(String dataVectorId, int index, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);

            FieldInfos fieldInfos = datasetVector.getFieldInfos();

            Boolean result = fieldInfos.remove(index);

            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("result", result);
            promise.resolve(wMap);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 根据名称删除FieldInfo
     * @param dataVectorId
     * @param name
     * @param promise
     */
    @ReactMethod
    public void removeFieldInfoByName(String dataVectorId, String name, Promise promise) {
        try {
            DatasetVector datasetVector = getObjFromList(dataVectorId);

            FieldInfos fieldInfos = datasetVector.getFieldInfos();

            Boolean result = fieldInfos.remove(name);

            WritableMap wMap = Arguments.createMap();
            wMap.putBoolean("result", result);
            promise.resolve(wMap);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 将FieldInfos转为Map
     * @param fieldInfos
     * @return
     */
    public static WritableMap fieldInfosToMap(FieldInfos fieldInfos){
        //获取字段信息
        Map<String, Map<String, Object>> fields = new HashMap<>();
        for (int i = 0; i < fieldInfos.getCount(); i++) {
            Map<String, Object> subMap = new HashMap<>();
            subMap.put("caption", fieldInfos.get(i).getCaption());
            subMap.put("defaultValue", fieldInfos.get(i).getDefaultValue());
            subMap.put("type", fieldInfos.get(i).getType());
            subMap.put("name", fieldInfos.get(i).getName());
            subMap.put("maxLength", fieldInfos.get(i).getMaxLength());
            subMap.put("isRequired", fieldInfos.get(i).isRequired());
            subMap.put("isSystemField", fieldInfos.get(i).isSystemField());

            fields.put(fieldInfos.get(i).getName(), subMap);
        }

        WritableMap fieldInfosMap = Arguments.createMap();

        for (Map.Entry<String,  Map<String, Object>> field : fields.entrySet()) {
            WritableMap keyMap = Arguments.createMap();
            WritableMap itemWMap = Arguments.createMap();
            String name = field.getKey();
            Map<String, Object> fieldInfo = field.getValue();

            for (Map.Entry<String, Object> item : fieldInfo.entrySet()) {
                String key = item.getKey();
                Object v = item.getValue();

                if (key.equals("caption") || key.equals("defaultValue") || key.equals("name")) {
                    if (v == null) {
                        itemWMap.putString(key, "");
                    } else {
                        itemWMap.putString(key, (String) v);
                    }
                } else if (key.equals("isRequired") || key.equals("isSystemField")) {
                    if (v == null) {
                        itemWMap.putString(key, "");
                    } else {
                        itemWMap.putBoolean(key, (Boolean) v);
                    }
                } else if (key.equals("maxLength")) {
                    if (v == null) {
                        itemWMap.putString(key, "");
                    } else {
                        itemWMap.putInt("maxLength", (Integer) v);
                    }
                } else if (key.equals("type")) {
                    FieldType type = (FieldType) v;
                    if (v == null) {
                        itemWMap.putString(key, "");
                    } else {
                        itemWMap.putInt(key, type.value());
                    }
                }
            }

            keyMap.putMap("fieldInfo", itemWMap);
            keyMap.putString("name", name);

            fieldInfosMap.putMap(name, keyMap);
        }

        return fieldInfosMap;
    }
}

