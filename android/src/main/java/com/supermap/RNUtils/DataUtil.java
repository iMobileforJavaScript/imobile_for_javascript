package com.supermap.RNUtils;

import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lonecloud on 17/3/12.
 * 用于对Object进行解析并且转换成Map键值对的形式
 *
 * @author lonecloud
 * @version 1.0
 */
public class DataUtil {

    private static final String JAVAP = "java.";
    private static final String JAVADATESTR = "java.util.Date";

    /**
     * 获取利用反射获取类里面的值和名称
     *
     * @param obj
     * @return
     * @throws IllegalAccessException
     */
    public static Map<String, Object> objectToMap(Object obj) throws IllegalAccessException {
        Map<String, Object> map = new HashMap<>();
        Class<?> clazz = obj.getClass();
        System.out.println(clazz);
        for (Field field : clazz.getDeclaredFields()) {
            field.setAccessible(true);
            String fieldName = field.getName();
            Object value = field.get(obj);
            map.put(fieldName, value);
        }
        return map;
    }

    /**
     * 利用递归调用将Object中的值全部进行获取
     *
     * @param timeFormatStr 格式化时间字符串默认<strong>2017-03-10 10:21</strong>
     * @param obj           对象
     * @param excludeFields 排除的属性
     * @return
     * @throws IllegalAccessException
     */
    public static Map<String, String> objectToMapString(String timeFormatStr, Object obj, String... excludeFields) throws IllegalAccessException {
        Map<String, String> map = new HashMap<>();

        if (excludeFields.length!=0){
            List<String> list = Arrays.asList(excludeFields);
            objectTransfer(timeFormatStr, obj, map, list);
        }else{
            objectTransfer(timeFormatStr, obj, map,null);
        }
        return map;
    }


    /**
     * 递归调用函数
     *
     * @param obj           对象
     * @param map           map
     * @param excludeFields 对应参数
     * @return
     * @throws IllegalAccessException
     */
    private static Map<String, String> objectTransfer(String timeFormatStr, Object obj, Map<String, String> map, List<String> excludeFields) throws IllegalAccessException {
        boolean isExclude=false;
        //默认字符串
        String formatStr = "YYYY-MM-dd HH:mm:ss";
        //设置格式化字符串
        if (timeFormatStr != null && !timeFormatStr.isEmpty()) {
            formatStr = timeFormatStr;
        }
        if (excludeFields!=null){
            isExclude=true;
        }
        Class<?> clazz = obj.getClass();
        //获取值
        for (Field field : clazz.getDeclaredFields()) {
            String fieldName = clazz.getSimpleName() + "." + field.getName();
            //判断是不是需要跳过某个属性
            if (isExclude&&excludeFields.contains(fieldName)){
                continue;
            }
            //设置属性可以被访问
            field.setAccessible(true);
            Object value = field.get(obj);
            Class<?> valueClass = value.getClass();
            if (valueClass.isPrimitive()) {
                map.put(fieldName, value.toString());

            } else if (valueClass.getName().contains(JAVAP)) {//判断是不是基本类型
                if (valueClass.getName().equals(JAVADATESTR)) {
                    //格式化Date类型
                    SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
                    Date date = (Date) value;
                    String dataStr = sdf.format(date);
                    map.put(fieldName, dataStr);
                } else {
                    map.put(fieldName, value.toString());
                }
            } else {
                objectTransfer(timeFormatStr, value, map,excludeFields);
            }
        }
        return map;
    }

    public static String getDataType(Object data) {
        String typeName = data.getClass().getName();
        int length= typeName.lastIndexOf(".");
        String type = typeName.substring(length + 1);
        return type;
    }

    public static int[] rnArrayToIntArray(ReadableArray array) {
        int[] newArray = new int[array.size()];
        for (int i = 0; i < array.size(); i++) {
            newArray[i] = array.getInt(i);
        }

        return newArray;
    }

    public static String[] rnArrayToStringArray(ReadableArray array) {
        String[] newArray = new String[array.size()];
        for (int i = 0; i < array.size(); i++) {
            newArray[i] = array.getString(i);
        }

        return newArray;
    }

    public static int[] arrayToIntArray(ArrayList<Integer> array) {
        int[] newArray = new int[array.size()];
        for (int i = 0; i < array.size(); i++) {
            newArray[i] = array.get(i);
        }

        return newArray;
    }

    public static WritableArray array2DToRnArray(int[][] array) {
        WritableArray newArray = Arguments.createArray();
        for (int i = 0; i < array.length; i++) {
            WritableArray subArrary = Arguments.createArray();
            for (int j = 0; j < array[i].length; j++) {
                subArrary.pushInt(array[i][j]);
            }
            newArray.pushArray(subArrary);
        }

        return newArray;
    }

    public static <T> T getEnum(Class<T> clazz,int index){
        T[] c=clazz.getEnumConstants();
        return c[index];
    }

    public static String getMediaPathFromUri(Context context, Uri uri) {
        String[] proj = { MediaStore.Images.Media.DATA, MediaStore.Video.Media.DATA };
        Cursor cursor = context.getContentResolver().query(uri, proj,null,null,null);
        int actualMediaColumnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        String mediaPath = cursor.getString(actualMediaColumnIndex);
        return mediaPath;
    }
}