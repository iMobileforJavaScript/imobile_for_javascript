package com.supermap.RNUtils;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Enum;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Recordset;
import com.supermap.data.Rectangle2D;
import com.supermap.navi.NaviInfo;
import com.supermap.navi.NaviPath;
import com.supermap.navi.NaviStep;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by will on 2017/2/13.
 */

public class JsonUtil {
    /**
     * Rectangle 转 JSON 方法
     * @param rectangle2D
     */
    public static WritableMap rectangleToJson(Rectangle2D rectangle2D){
        double top = rectangle2D.getTop();
        double bottom = rectangle2D.getBottom();
        double left = rectangle2D.getLeft();
        double height = rectangle2D.getHeight();
        double width = rectangle2D.getWidth();
        double right = rectangle2D.getRight();

        Point2D center = rectangle2D.getCenter();
        double x = center.getX();
        double y = center.getY();
        WritableMap centerMap = Arguments.createMap();
        centerMap.putDouble("x" , x);
        centerMap.putDouble("y" , y);

        WritableMap wMap = Arguments.createMap();
        wMap.putMap("center",centerMap);
        wMap.putDouble("top",top);
        wMap.putDouble("bottom",bottom);
        wMap.putDouble("left",left);
        wMap.putDouble("height",height);
        wMap.putDouble("width",width);
        wMap.putDouble("right",right);
        return wMap;
    }

    /**
     * json转Rectangle方法
     * @param readableMap
     * @return
     * @throws Exception
     */
    public static Rectangle2D jsonToRectangle(ReadableMap readableMap) throws Exception{
        Rectangle2D r;
        double left = readableMap.getDouble("left");
        double bottom = readableMap.getDouble("bottom");
        if (readableMap.hasKey("top") && readableMap.hasKey("right")) {
            double top = readableMap.getDouble("top");
            double right = readableMap.getDouble("right");

            r = new Rectangle2D(left, bottom, right, top);
        }else {
            double width = readableMap.getDouble("width");
            double height = readableMap.getDouble("height");
            Point2D leftBottom = new Point2D(left,bottom);

            r = new Rectangle2D(leftBottom,width,height);
        }
        return r;
    }

    public static WritableMap recordsetToMap(Recordset recordset, int page, int size) {
        return recordsetToMap(recordset, page, size, null);
    }

    /**
     * 将记录集recordset转换成Map
     * @param recordset 动态记录集
     * @param page      页码
     * @param size      每页的数量
     * @param filterKey 过滤条件
     * @return
     */
    public static WritableMap recordsetToMap(Recordset recordset, int page, int size, String filterKey) {
        //获取字段信息
        FieldInfos fieldInfos = recordset.getFieldInfos();
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
        //JS数组，存放
        WritableArray recordArray = Arguments.createArray();
        WritableMap map = Arguments.createMap();

        map.putInt("total", recordset.getRecordCount());
        map.putInt("currentPage", page);

        // 计算分页，并移动到指定起始位置
        int currentIndex = page * size;
        int endIndex = currentIndex + size;
        if (currentIndex < recordset.getRecordCount()) {
            recordset.moveTo(currentIndex);

            while (!recordset.isEmpty() && !recordset.isEOF() && currentIndex < endIndex) {
                WritableArray recordArr;
                if (filterKey != null && !filterKey.equals("")){
                    recordArr = parseRecordset(recordset, fields, filterKey);
                } else {
                    recordArr = parseRecordset(recordset, fields);
                }

                if (recordArr != null) {
                    recordArray.pushArray(recordArr);
                    currentIndex++;
                }
                recordset.moveNext();
            }
        }
        map.putArray("data", recordArray);
        map.putInt("startIndex", (page * size));

        return map;
    }

    private static WritableArray parseRecordset(Recordset recordset, Map<String, Map<String, Object>> fields) {
        return parseRecordset(recordset, fields, null);
    }

    /**
     * 获取一个记录中的各项属性值
     *
     * @param recordset 记录（静态）
     * @param fields    该记录中的所有属性
     * @return
     */
    private static WritableArray parseRecordset(Recordset recordset, Map<String, Map<String, Object>> fields, String filterKey) {
//        WritableMap map = Arguments.createMap();
        WritableArray array = Arguments.createArray();
        ArrayList<WritableMap> list = new ArrayList();

        boolean isMatching = false;

        for (Map.Entry<String,  Map<String, Object>> field : fields.entrySet()) {
            WritableMap keyMap = Arguments.createMap();
            WritableMap itemWMap = Arguments.createMap();
            String name = field.getKey();
            Map<String, Object> fieldInfo = field.getValue();

            for (Map.Entry<String, Object> item : fieldInfo.entrySet()) {
                String key = item.getKey();
                Object v = item.getValue();

                if (v == null) {
                    itemWMap.putString(key, "");
                    continue;
                }

                switch (key) {
                    case "caption":
                    case "defaultValue":
                    case "name":
                        itemWMap.putString(key, (String) v);
                        break;
                    case "isRequired":
                    case "isSystemField":
                        itemWMap.putBoolean(key, (Boolean) v);
                        break;
                    case "maxLength":
                        itemWMap.putInt("maxLength", (int) v);
                        break;
                    case "type":
                        FieldType type = (FieldType) v;
                        itemWMap.putInt(key, type.value());

                        Object fieldValue = recordset.getFieldValue(name);

                        if (fieldValue == null) {
                            keyMap.putString("value", "");
                        } else if (type == FieldType.DOUBLE) {
                            Double d = (Double) fieldValue;
                            keyMap.putDouble("value", d);
                        } else if (type == FieldType.SINGLE) {
                            BigDecimal b = new BigDecimal(fieldValue.toString());
                            Double d = b.doubleValue();
                            keyMap.putDouble("value", d);
                        } else if (type == FieldType.CHAR ||
                                type == FieldType.TEXT ||
                                type == FieldType.WTEXT ||
                                type == FieldType.DATETIME
                                ) {
                            keyMap.putString("value", fieldValue.toString());
                        } else if (type == FieldType.INT16) {
                            keyMap.putInt("value", ((Short) fieldValue).intValue());
                        } else if (type == FieldType.INT32) {
                            keyMap.putInt("value", (int) fieldValue);
                        } else if (type == FieldType.INT64) {
                            keyMap.putInt("value", ((Long) fieldValue).intValue());
                        } else if (type == FieldType.LONGBINARY || type == FieldType.BYTE) {
                            keyMap.putString("value", fieldValue.toString());
                        } else {
                            keyMap.putBoolean("value", (Boolean) fieldValue);
                        }

                        if (filterKey != null && !filterKey.equals("") && !isMatching){
                            String strV = fieldValue.toString();
                            isMatching = strV.contains(filterKey);
                        }

                        break;
                }
            }

            keyMap.putMap("fieldInfo", itemWMap);
            keyMap.putString("name", name);

//            map.putMap(name, keyMap);
            if (name.toLowerCase().equals("smid")) {
                list.add(0, keyMap);
            } else {
                list.add(keyMap);
            }
        }

        if (filterKey != null && !filterKey.equals("")){
            if (isMatching) {
                for (int i = 0; i < list.size(); i++) {
                    array.pushMap(list.get(i));
                }
                return array;
            }
            return null;
        }

        for (int i = 0; i < list.size(); i++) {
            array.pushMap(list.get(i));
        }

        return array;
    }

    /**
     * 修正toGeoJson方法返回的字符串中包含“,,”跳空数组元素的情况。
     * @param json
     * @return
     */
    static public String rectifyGeoJSON(String json){
        String geojson = json.replaceAll(",,",",");
        return geojson;
    }

    /**
     * recordset.toGeoJson（）方法只能返回十条geoJSON记录，此方法用于迭代返回所有记录，
     * @param {string[]} recordset - 返回字符串数组，每个数组元素的值为recordset.toGeoJson（）每返回的一批（即十条）记录。
     * @return
     */
    static public String[] recordsetToGeoJsons(Recordset recordset){
        int total = recordset.getRecordCount();
        recordset.moveFirst();
        int batches = 0;
        String[] geoJsons = {};
        if(batches / total == 0 ){
            batches = batches / total - 1;
        }else {
            batches = batches / total;
        }
        for(int i = 0 ; i < batches ; i++){
            geoJsons[i] = recordset.toGeoJSON(true,10);
        }
        return geoJsons;
    }

    /**
     * 将Point2Ds转成JSON格式
     * @param point2Ds - Point2Ds对象
     * @return {WritableArray} - Json数组，元素为{x:---,y;---}坐标对对象。
     * @throws Exception
     */
    public static WritableArray point2DsToJson(Point2Ds point2Ds) throws Exception{
        try{
            WritableArray array = Arguments.createArray();
            for(int i = 0 ; i < point2Ds.getCount();i++ ){
                Point2D point2D = point2Ds.getItem(i);
                WritableMap jsonPoint2D = Arguments.createMap();
                jsonPoint2D.putDouble("x",point2D.getX());
                jsonPoint2D.putDouble("y",point2D.getY());
                array.pushMap(jsonPoint2D);
            }
            return array;
        }catch (Exception e){
            throw e;
        }
    }

    /**
     * 将JSON格式转成Point2Ds
     * @param array - Json数组
     * @return Point2Ds
     * @throws Exception
     */
    public static Point2Ds jsonToPoint2Ds(ReadableArray array) throws Exception {
        Point2Ds point2Ds = new Point2Ds();
        for (int i = 0; i < array.size(); i++) {
            Double x = array.getMap(i).getDouble("x");
            Double y = array.getMap(i).getDouble("y");
            Point2D point2D = new Point2D(x, y);
            point2Ds.add(point2D);
        }
        if (point2Ds.getCount() == 0) throw new Error("输入的点对象数组为空");
        return point2Ds;
    }

    /**
     * 导航信息转Json
     * @param naviInfo - 导航信息对象
     * @return
     * @throws Exception
     */
    public static WritableMap naviInfoToJson(NaviInfo naviInfo) throws Exception{
        WritableMap map = Arguments.createMap();
        map.putString("curRoadName",naviInfo.CurRoadName);
        map.putDouble("direction",naviInfo.Direction);
        map.putInt("iconType",naviInfo.IconType);
        map.putString("nextRoadName",naviInfo.NextRoadName);
        map.putInt("routeRemainDis",naviInfo.RouteRemainDis);
        map.putDouble("routeRemainTime",naviInfo.RouteRemainTime);
        map.putInt("segRemainDis",naviInfo.SegRemainDis);

        return map;
    }

    /**
     * naviPath转JSON
     * @param naviPath
     * @return
     */
    public static WritableMap naviPathToJson(NaviPath naviPath){
        WritableMap map = Arguments.createMap();
        List<NaviStep> naviSteps = naviPath.getStep();
        WritableArray steps = Arguments.createArray();
        for(int i = 0; i < naviSteps.size(); i++){
            NaviStep naviStep = naviSteps.get(i);
            double stepLength = naviStep.getLength();
            String stepName = naviStep.getName();
            double stepTime = naviStep.getTime();
            int stepSwerve = naviStep.getToSwerve();
            WritableMap point = Arguments.createMap();
            point.putDouble("x",naviStep.getPoint().getX());
            point.putDouble("y",naviStep.getPoint().getY());

            WritableMap step = Arguments.createMap();
            step.putMap("point",point);
            step.putDouble("length",stepLength);
            step.putString("name",stepName);
            step.putDouble("time",stepTime);
            step.putInt("turnType",stepSwerve);
            steps.pushMap(step);
        }

        map.putArray("pathInfo",steps);
        return map;
    }

    /**
     * 将Point2Ds转成JSON格式
     * @param point2Ds - Point2Ds对象
     * @return {WritableArray} - Json数组，元素为{x:---,y;---}坐标对对象。
     * @throws Exception
     */
    public static WritableArray pathGuidesToJson(Point2Ds point2Ds) throws Exception{
        try{
            WritableArray array = Arguments.createArray();
            for(int i = 0 ; i < point2Ds.getCount();i++ ){
                Point2D point2D = point2Ds.getItem(i);
                WritableMap jsonPoint2D = Arguments.createMap();
                jsonPoint2D.putDouble("x",point2D.getX());
                jsonPoint2D.putDouble("y",point2D.getY());
                array.pushMap(jsonPoint2D);
            }
            return array;
        }catch (Exception e){
            throw e;
        }
    }
}
