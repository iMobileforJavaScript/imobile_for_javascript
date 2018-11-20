package com.supermap.interfaces;

import android.graphics.Color;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Environment;
import com.supermap.data.FillGradientMode;
import com.supermap.data.GeoStyle;
import com.supermap.data.Size2D;
import com.supermap.mapping.*;

/**
 * 地图制图类
 */
public class SMCartography extends ReactContextBaseJavaModule {

    public static final String REACT_CLASS = "SMCartography";
    private static ReactApplicationContext context;

    public SMCartography(ReactApplicationContext context) {
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
     * 设置点符号的ID, layerIndex:图层索引
     *
     * @param promise
     */
    @ReactMethod
    public void setMakerSymbolID(int makerSymbolID, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setMarkerSize(int mm, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setMarkerColor(String color, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setMarkerAngle(int angle, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setMarkerAlpha(int alpha, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setLineSymbolID(int lineSymbolID, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setLineWidth(int mm, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setLineColor(String lineColor, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
//    public void setLineAlpha(int alpha, int layerIndex, Promise promise)  {
//        try {
//            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillSymbolID(int FillSymbolID, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillForeColor(String fillForeColor, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillBackColor(String fillBackColor, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillOpaqueRate(int fillOpaqueRate, int layerIndex, Promise promise) {
        try {
            LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillLinearGradient(int layerIndex, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillRadialGradient(int layerIndex, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillSquareGradient(int layerIndex, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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
    public void setFillNoneGradient(int layerIndex, Promise promise) {
        try {
            if (!Environment.isOpenGLMode()) {
                LayerSettingVector layerSettingVector = getLayerSettingVector(layerIndex);
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


    /*文本风格
    * ********************************************************************************************/


    /**
     * 获取矢量图层设置类
     *
     * @param layerIndex 图层索引
     * @return
     */
    private LayerSettingVector getLayerSettingVector(int layerIndex) {
        try {
            Layer layer = getLayerByIndex(layerIndex);
            //判断是否是专题图
            if (layer != null && layer.getTheme() == null) {
                if (layer.getAdditionalSetting() != null && layer.getAdditionalSetting().getType() == LayerSettingType.VECTOR) {
                    layer.setEditable(true);
                    return (LayerSettingVector) layer.getAdditionalSetting();
                } else {
                    return null;
                }
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据图层索引获取图层对象
     *
     * @return
     */
    private Layer getLayerByIndex(int layerIndex) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Layers layers = mapControl.getMap().getLayers();
            return layers.get(layerIndex);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
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
