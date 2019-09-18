package com.supermap.interfaces.ai.illegallypark;

public class CarColorUtil {

    public static String getCarColor(int r, int g, int b) {
        if (isBlack(r, g, b)) {
            return "黑色";
        }
        if (isWhite(r, g, b)) {
            return "白色";
        }
        if (isRed(r, g, b)) {
            return "红色";
        }
        return "其他";
    }

    /**
     * 视觉黑色
     *
     * @param r
     * @param g
     * @param b
     * @return
     */
    private static boolean isBlack(int r, int g, int b) {
        if ((r >= 0 && r <= 16) && (g >= 0 && g <= 16) && (b >= 0 && b <= 16)) {
            return true;
        }
        return false;
    }

    /**
     * 视觉白色
     *
     * @param r
     * @param g
     * @param b
     * @return
     */
    private static boolean isWhite(int r, int g, int b) {
        if ((r >= 240 && r <= 255) && (g >= 240 && g <= 255) && (b >= 240 && b <= 255)) {
            return true;
        }
        return false;
    }

    /**
     * 视觉红色
     *
     * @param r
     * @param g
     * @param b
     * @return
     */
    private static boolean isRed(int r, int g, int b) {
        if ((r >= 200 && r <= 255) && (g >= 0 && g <= 50) && (b >= 0 && b <= 50)) {
            return true;
        }
        return false;
    }

    public static String getColorByHSV(int h_maxVal, int s_maxVal, int v_maxVal) {
        String color = "";
        if (v_maxVal < 0.10) {
            color = "黑色";
        } else if ((v_maxVal > 0.10 || v_maxVal < 0.27) && s_maxVal < 0.1) {
            color = "深灰色";
        } else if ((v_maxVal > 0.27 || v_maxVal < 0.76) && s_maxVal < 0.1) {
            color = "灰色";
        } else if (v_maxVal >= 0.76 && s_maxVal < 0.16) {
            color = "白色";
        } else {
            if (h_maxVal <= 15 || h_maxVal > 339) {
                color = "红色";
            } else if (h_maxVal > 15 && h_maxVal <= 48) {
                color = "黄色";
            } else if (h_maxVal > 48 && h_maxVal <= 109) {
                color = "绿色";
            } else {
                color = "其他";
            }
        }
        return color;
    }
}
