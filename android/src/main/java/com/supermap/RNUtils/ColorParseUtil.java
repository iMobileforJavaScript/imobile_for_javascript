package com.supermap.RNUtils;

import com.supermap.data.Color;

/**
 * 颜色工具类
 * Created by Administrator on 2018/11/30.
 */

public class ColorParseUtil {

    public static Color getColor(String color) {
        int parseColor = android.graphics.Color.parseColor(color);
        int[] rgb = getRGB(parseColor);

        return new com.supermap.data.Color(rgb[0], rgb[1], rgb[2]);
    }

    /**
     * 16进制颜色码转换为RGB
     */
    public static int[] getRGB(int color) {
        int[] rgb = new int[3];

        int r = (color & 0xff0000) >> 16;
        int g = (color & 0xff00) >> 8;
        int b = color & 0xff;

        rgb[0] = r;
        rgb[1] = g;
        rgb[2] = b;

        return rgb;
    }
}
