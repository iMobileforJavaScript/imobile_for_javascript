package com.supermap.interfaces;

import android.graphics.Color;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.LayerSettingGrid;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.smNative.SMCartography;

/**
 * 地图制图类
 */
public class SCartography extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SCartography";
    private static ReactApplicationContext context;

    public SCartography(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }


     /*点风格
    * ********************************************************************************************/
    /**
     * 设置点符号的ID, layerName:图层名称
     *
     * @param promise
     */
    @ReactMethod
    public void setMakerSymbolID(int makerSymbolID, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle style = layerSettingVector.getStyle();
                style.setMarkerSymbolID(makerSymbolID);
                layerSettingVector.setStyle(style);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置点符号的大小：1-100mm
     *
     * @param promise
     */
    @ReactMethod
    public void setMarkerSize(int mm, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle style = layerSettingVector.getStyle();
                style.setMarkerSize(new Size2D(mm, mm));
                layerSettingVector.setStyle(style);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置点符号的颜色，color: 十六进制颜色码
     *
     * @param promise
     */
    @ReactMethod
    public void setMarkerColor(String color, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                int parseColor = Color.parseColor(color);
                int[] rgb = getRGB(parseColor);
                com.supermap.data.Color makerColor = new com.supermap.data.Color(rgb[0], rgb[1], rgb[2]);

                GeoStyle style = layerSettingVector.getStyle();
                style.setLineColor(makerColor);
                layerSettingVector.setStyle(style);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置点符号的旋转角度：0-360°
     *
     * @param promise
     */
    @ReactMethod
    public void setMarkerAngle(int angle, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle style = layerSettingVector.getStyle();
                style.setMarkerAngle(angle);
                layerSettingVector.setStyle(style);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置点符号的透明度：0-100%
     *
     * @param promise
     */
    @ReactMethod
    public void setMarkerAlpha(int alpha, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle style = layerSettingVector.getStyle();
                style.setFillOpaqueRate(100 - alpha);
                layerSettingVector.setStyle(style);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /*线风格
    * ********************************************************************************************/
    /**
     * 设置线符号的ID(设置边框符号的ID)
     *
     * @param promise
     */
    @ReactMethod
    public void setLineSymbolID(int lineSymbolID, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle geoStyle = layerSettingVector.getStyle();
                geoStyle.setLineSymbolID(lineSymbolID);
                layerSettingVector.setStyle(geoStyle);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置线宽：1-10mm(边框符号宽度)
     *
     * @param promise
     */
    @ReactMethod
    public void setLineWidth(int mm, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle geoStyle = layerSettingVector.getStyle();
                double width = (double) mm / 10;
                geoStyle.setLineWidth(width);
                layerSettingVector.setStyle(geoStyle);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置线颜色(边框符号颜色)
     *
     * @param promise
     */
    @ReactMethod
    public void setLineColor(String lineColor, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                int parseColor = Color.parseColor(lineColor);
                int[] rgb = getRGB(parseColor);
                com.supermap.data.Color color = new com.supermap.data.Color(rgb[0], rgb[1], rgb[2]);

                GeoStyle geoStyle = layerSettingVector.getStyle();
                geoStyle.setLineColor(color);
                layerSettingVector.setStyle(geoStyle);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

//    /**
//     * 设置线的透明度：1-100%
//     *
//     * @param promise
//     */
//    @ReactMethod
//    public void setLineAlpha(int alpha, String layerName, Promise promise)  {
//        try {
//            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
//            if (layerSettingVector != null) {
//                GeoStyle geoStyle = layerSettingVector.getStyle();
//
//                //设置透明度(待添加接口)
//
//                layerSettingVector.setStyle(geoStyle);
//
//                SMap.getSMWorkspace().getMapControl().getMap().refresh();
//
//                promise.resolve(true);
//            } else {
//                promise.resolve(false);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            promise.reject(e);
//        }
//    }


     /*面风格
    * ********************************************************************************************/
    /**
     * 设置面符号的ID
     *
     * @param promise
     */
    @ReactMethod
    public void setFillSymbolID(int FillSymbolID, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle geoStyle = layerSettingVector.getStyle();
                geoStyle.setFillSymbolID(FillSymbolID);
                layerSettingVector.setStyle(geoStyle);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
  }

    /**
     * 设置前景色
     *
     * @param promise
     */
    @ReactMethod
    public void setFillForeColor(String fillForeColor, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                int parseColor = android.graphics.Color.parseColor(fillForeColor);
                int[] rgb = getRGB(parseColor);
                com.supermap.data.Color color = new com.supermap.data.Color(rgb[0], rgb[1], rgb[2]);

                GeoStyle geoStyle = layerSettingVector.getStyle();
                geoStyle.setFillForeColor(color);
                layerSettingVector.setStyle(geoStyle);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置背景色
     *
     * @param promise
     */
    @ReactMethod
    public void setFillBackColor(String fillBackColor, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                int parseColor = android.graphics.Color.parseColor(fillBackColor);
                int[] rgb = getRGB(parseColor);
                com.supermap.data.Color color = new com.supermap.data.Color(rgb[0], rgb[1], rgb[2]);

                GeoStyle geoStyle = layerSettingVector.getStyle();
                geoStyle.setFillBackColor(color);
                layerSettingVector.setStyle(geoStyle);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置透明度（0-100）
     *
     * @param promise
     */
    @ReactMethod
    public void setFillOpaqueRate(int fillOpaqueRate, String layerName, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
            if (layerSettingVector != null) {
                GeoStyle geoStyle = layerSettingVector.getStyle();
                geoStyle.setFillOpaqueRate(100 - fillOpaqueRate);//此接口是设置不透明度
                layerSettingVector.setStyle(geoStyle);

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置线性渐变
     *
     * @param promise
     */
    @ReactMethod
    public void setFillLinearGradient(String layerName, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
                if (layerSettingVector != null) {
                    GeoStyle geoStyle = layerSettingVector.getStyle();
                    geoStyle.setFillGradientMode(FillGradientMode.LINEAR);
                    layerSettingVector.setStyle(geoStyle);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                } else {
                    promise.resolve(false);
                }
            } else {
                // "OpenGL不支持颜色渐变"
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置辐射渐变
     *
     * @param promise
     */
    @ReactMethod
    public void setFillRadialGradient(String layerName, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
                if (layerSettingVector != null) {
                    GeoStyle geoStyle = layerSettingVector.getStyle();
                    geoStyle.setFillGradientMode(FillGradientMode.RADIAL);
                    layerSettingVector.setStyle(geoStyle);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                } else {
                    promise.resolve(false);
                }
            } else {
                // "OpenGL不支持颜色渐变"
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置方形渐变
     *
     * @param promise
     */
    @ReactMethod
    public void setFillSquareGradient(String layerName, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
                if (layerSettingVector != null) {
                    GeoStyle geoStyle = layerSettingVector.getStyle();
                    geoStyle.setFillGradientMode(FillGradientMode.SQUARE);
                    layerSettingVector.setStyle(geoStyle);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                } else {
                    promise.resolve(false);
                }
            } else {
                // "OpenGL不支持颜色渐变"
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置无渐变
     *
     * @param promise
     */
    @ReactMethod
    public void setFillNoneGradient(String layerName, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = SMCartography.getLayerSettingVector(layerName);
                if (layerSettingVector != null) {
                    GeoStyle geoStyle = layerSettingVector.getStyle();
                    geoStyle.setFillGradientMode(FillGradientMode.NONE);
                    layerSettingVector.setStyle(geoStyle);

                    SMap.getSMWorkspace().getMapControl().getMap().refresh();

                    promise.resolve(true);
                } else {
                    promise.resolve(false);
                }
            } else {
                // "OpenGL不支持颜色渐变"
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    //设置边框符号的ID ，边框符号宽度 ，边框符号颜色可直接使用线风格对应的接口


    /*栅格风格
    * ********************************************************************************************/
    /**
     * 设置透明度(0-100%)
     *
     * @param promise
     */
    @ReactMethod
    public void setGridOpaqueRate(int gridOpaqueRate, String layerName, Promise promise) {
        try {
            LayerSettingGrid layerSettingGrid = SMCartography.getLayerSettingGrid(layerName);
            if (layerSettingGrid != null) {
//                layerSettingGrid.setOpaqueRate(100 - gridOpaqueRate); //新增接口，待打开

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置亮度(-100%-100%)
     *
     * @param promise
     */
    @ReactMethod
    public void setGridContrast(int gridContrast, String layerName, Promise promise) {
        try {
            LayerSettingGrid layerSettingGrid = SMCartography.getLayerSettingGrid(layerName);
            if (layerSettingGrid != null) {
//                layerSettingGrid.setContrast(gridContrast); //新增接口，待打开

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置对比度(-100%-100%)
     *
     * @param promise
     */
    @ReactMethod
    public void setGridBrightness(int gridBrightness, String layerName, Promise promise) {
        try {
            LayerSettingGrid layerSettingGrid = SMCartography.getLayerSettingGrid(layerName);
            if (layerSettingGrid != null) {
//                layerSettingGrid.setBrightness(gridBrightness); //新增接口，待打开

                SMap.getSMWorkspace().getMapControl().getMap().refresh();

                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /*文本风格
    * ********************************************************************************************/
    private boolean saveGeoText(Recordset recordset, Geometry geometry) {
        recordset.edit();
        recordset.setGeometry(geometry);
        boolean update = recordset.update();

        SMap.getSMWorkspace().getMapControl().getMap().refresh();

        recordset.close();
        recordset.dispose();

        return update;
    }

    /**
     * 设置文本字体的名称
     *
     * @param fontName 字体名称，例如：“宋体”
     * @param promise
     */
    @ReactMethod
    public void  setTextFont(String fontName, int geometryID, String layerName, Promise promise) {
        try {
            Recordset recordset = SMCartography.getRecordset(geometryID, layerName);
            Geometry geometry = SMCartography.getGeoText(recordset);
            if (recordset != null && geometry != null) {
                GeoText geoText = (GeoText) geometry;
                TextStyle textStyle = geoText.getTextStyle();
                textStyle.setFontName(fontName);
                geoText.setTextStyle(textStyle);

                boolean update = saveGeoText(recordset, geometry);

                promise.resolve(update);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置字号
     *
     * @param promise
     */
    @ReactMethod
    public void  setTextFontSize(int size, int geometryID, String layerName, Promise promise) {
        try {
            Recordset recordset = SMCartography.getRecordset(geometryID, layerName);
            Geometry geometry = SMCartography.getGeoText(recordset);
            if (recordset != null && geometry != null) {
                GeoText geoText = (GeoText) geometry;
                TextStyle textStyle = geoText.getTextStyle();
                textStyle.setFontHeight((double) size);
                geoText.setTextStyle(textStyle);

                boolean update = saveGeoText(recordset, geometry);

                promise.resolve(update);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置字体颜色
     *
     * @param promise
     */
    @ReactMethod
    public void  setTextFontColor(String color, int geometryID, String layerName, Promise promise) {
        try {
            Recordset recordset = SMCartography.getRecordset(geometryID, layerName);
            Geometry geometry = SMCartography.getGeoText(recordset);
            if (recordset != null && geometry != null) {
                int parseColor = Color.parseColor(color);
                int[] rgb = getRGB(parseColor);
                com.supermap.data.Color textColor = new com.supermap.data.Color(rgb[0], rgb[1], rgb[2]);

                GeoText geoText = (GeoText) geometry;
                TextStyle textStyle = geoText.getTextStyle();
                textStyle.setForeColor(textColor);
                geoText.setTextStyle(textStyle);

                boolean update = saveGeoText(recordset, geometry);

                promise.resolve(update);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置旋转角度
     *
     * @param promise
     */
    @ReactMethod
    public void  setTextFontRotation(int angle, int geometryID, String layerName, Promise promise) {
        try {
            Recordset recordset = SMCartography.getRecordset(geometryID, layerName);
            Geometry geometry = SMCartography.getGeoText(recordset);
            if (recordset != null && geometry != null) {
                GeoText geoText = (GeoText) geometry;
                TextStyle textStyle = geoText.getTextStyle();
                textStyle.setRotation(angle);
                geoText.setTextStyle(textStyle);

                boolean update = saveGeoText(recordset, geometry);

                promise.resolve(update);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置位置
     * @param textAlignment 例如:“TOPLEFT” “TOPCENTER” ...
     * @param promise
     */
    @ReactMethod
    public void  setTextFontPosition(String textAlignment, int geometryID, String layerName, Promise promise) {
        try {
            Recordset recordset = SMCartography.getRecordset(geometryID, layerName);
            Geometry geometry = SMCartography.getGeoText(recordset);
            if (recordset != null && geometry != null) {
                GeoText geoText = (GeoText) geometry;
                TextStyle textStyle = geoText.getTextStyle();
                TextAlignment alignment = SMCartography.getTextAlignment(textAlignment);
                if (alignment != null) {
                    textStyle.setAlignment(alignment);
                    geoText.setTextStyle(textStyle);
                    boolean update = saveGeoText(recordset, geometry);
                    promise.resolve(update);
                } else {
                    promise.resolve(false);
                }
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置字体风格(加粗BOLD、斜体ITALIC、下划线UNDERLINE、删除线STRIKEOUT、轮廓OUTLINE、阴影SHADOW)
     * @param style 例如:“BOLD” “ITALIC” ...
     * @param whether  设置为true或false
     * @param promise
     */
    @ReactMethod
    public void  setTextStyle(String style, boolean whether, int geometryID, String layerName, Promise promise) {
        try {
            Recordset recordset = SMCartography.getRecordset(geometryID, layerName);
            Geometry geometry = SMCartography.getGeoText(recordset);
            if (recordset != null && geometry != null) {
                GeoText geoText = (GeoText) geometry;
                TextStyle textStyle = geoText.getTextStyle();
                switch (style) {
                    case "BOLD":
                        textStyle.setBold(whether);
                        break;
                    case "ITALIC":
                        textStyle.setItalic(whether);
                        break;
                    case "UNDERLINE":
                        textStyle.setUnderline(whether);
                        break;
                    case "STRIKEOUT":
                        textStyle.setStrikeout(whether);
                        break;
                    case "OUTLINE":
                        textStyle.setOutline(whether);
                        break;
                    case "SHADOW":
                        textStyle.setShadow(whether);
                        break;
                }
                geoText.setTextStyle(textStyle);

                boolean update = saveGeoText(recordset, geometry);

                promise.resolve(update);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /**
     * 16进制颜色码转换为RGB
     */
    private int[] getRGB(int color) {
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
