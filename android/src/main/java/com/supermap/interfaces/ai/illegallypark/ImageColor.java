package com.supermap.interfaces.ai.illegallypark;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.util.Log;

import java.util.*;

/**
 * @Title: ImageColor
 * @Description: 获取一张图片的主颜色
 * @author: tangweiwei
 * @date: 2019/8/22 14:04
 * @version: V9.2
 */
public class ImageColor {
    private String colour;
    private static int r;
    private static int g;
    private static int b;

    private static Map getImageColour(Bitmap image) throws Exception {
        if (image == null) {
            return null;
        }
        int height = image.getHeight();
        int width = image.getWidth();
        Map m = new HashMap();
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                int rgb = image.getPixel(i, j);
                int[] rgbArr = getRGBArr(rgb);
                if (!isGray(rgbArr)) {
                    Integer counter = (Integer) m.get(rgb);
                    if (counter == null)
                        counter = 0;
                    counter++;
                    m.put(rgb, counter);
                }
            }
        }
        return m;
    }

    /**
     * 返回十六进制颜色值
     *
     * @param bitmap
     * @return
     * @throws Exception
     */
    public static String getMostCommonColour(Bitmap bitmap) throws Exception {
        if (bitmap == null) {
            return null;
        }
        Map map = getImageColour(bitmap);
        if (map == null) {
            return null;
        }
        List list = new LinkedList(map.entrySet());
        Collections.sort(list, new Comparator() {
            public int compare(Object o1, Object o2) {
                return ((Comparable) ((Map.Entry) (o1)).getValue())
                        .compareTo(((Map.Entry) (o2)).getValue());
            }
        });
        if (list == null || list.size() <= 0) {
            return null;
        }
        Map.Entry me = (Map.Entry) list.get(list.size() - 1);
        int[] rgb = getRGBArr((Integer) me.getKey());
        r = rgb[0];
        g = rgb[1];
        b = rgb[2];
        Log.e("rgb", rgb[0] + " " + rgb[1] + " " + rgb[2]);
        return Integer.toHexString(rgb[0]) + " " + Integer.toHexString(rgb[1]) + " " + Integer.toHexString(rgb[2]);
    }


    public static int[] getRGBArr(int pixel) {
        int red = (pixel >> 16) & 0xff;
        int green = (pixel >> 8) & 0xff;
        int blue = (pixel) & 0xff;
        return new int[]{red, green, blue};
    }

    public static boolean isGray(int[] rgbArr) throws Exception {
        int rgDiff = rgbArr[0] - rgbArr[1];
        int rbDiff = rgbArr[0] - rgbArr[2];

        int tolerance = 10;

        if (rgDiff > tolerance || rgDiff < -tolerance)
            if (rbDiff > tolerance || rbDiff < -tolerance) {
                return false;
            }
        return true;
    }

    public String returnColour() {
        if (colour.length() == 6) {
            return colour.replaceAll("\\s", "");
        } else {
            return "ffffff";
        }
    }

    public static float[] getHsv() {
        float[] hsv = new float[3];
        Color.RGBToHSV(r, g, b, hsv);
        return hsv;
    }
}