/**
 * Created by Yang Shanglong on 2018/6/25.
 */

package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.DatasetType;
import com.supermap.data.Datasource;
import com.supermap.data.Enum;
import com.supermap.data.Color;
import com.supermap.data.GeoStyle;
import com.supermap.data.ColorSpaceType;
import com.supermap.mapping.LayerSettingType;
import com.supermap.rnsupermap.R.attr;
import com.supermap.mapping.ImageDisplayMode;
import com.supermap.mapping.ImageStretchOption;
import com.supermap.mapping.LayerSettingImage;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSLayerSettingImage extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLayerSettingImage";
    protected static Map<String, LayerSettingImage> m_LayerSettingImageList = new HashMap<String, LayerSettingImage>();
    LayerSettingImage m_LayerSettingImage;

    public JSLayerSettingImage(ReactApplicationContext context) {
        super(context);
    }

    public static LayerSettingImage getObjFromList(String id) {
        return m_LayerSettingImageList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(LayerSettingImage obj) {
        for (Map.Entry entry : m_LayerSettingImageList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_LayerSettingImageList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(Promise promise){
        try{
            LayerSettingImage layerSettingImage = new LayerSettingImage();
            String layerSettingImageId = registerId(layerSettingImage);

            WritableMap map = Arguments.createMap();
            map.putString("_layerSettingImageId_",layerSettingImageId);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getType(String layerSettingImageId, String geoStyleId, Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            LayerSettingType layerSettingType = layerSettingImage.getType();
            int type = Enum.getValueByName(LayerSettingType.class,layerSettingType.name());

            WritableMap map = Arguments.createMap();
            map.putInt("type", type);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    // /**
    //  * 通过SLD文件，想图层集合中添加图层
    //  */
    // @ReactMethod
    // public void add(String layerSettingImageId, Datasource datasourse, String strSLDFilePath, Promise promise){
    //     try{
    //         LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
    //         layerSettingImage.add(datasourse, strSLDFilePath);

    //         promise.resolve(true);
    //     }catch (Exception e){
    //         promise.reject(e);
    //     }
    // }

    // /**
    //  * 获取所有图层集合，返回字符串数组
    //  */
    // @ReactMethod
    // public void getAllSubLayers(String layerSettingImageId, Promise promise){
    //     try{
    //         LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
    //         String[] allSubLayers = layerSettingImage.getAllSubLayers();

    //         WritableMap map = Arguments.createMap();
    //         map.putArray("allSubLayers", allSubLayers);
    //         promise.resolve(map);
    //     }catch (Exception e){
    //         promise.reject(e);
    //     }
    // }

    /**
     * 获取图层的最大缓存数
     */
    @ReactMethod
    public void getCacheMaxSize(String layerSettingImageId, Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            int cacheMaxSize = layerSettingImage.getCacheMaxSize();

            WritableMap map = Arguments.createMap();
            map.putInt("cacheMaxSize", cacheMaxSize);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    // /**
    //  * 获取当前影像图层的波段索引
    //  */
    // @ReactMethod
    // public void getDisplayBandIndexes(String layerSettingImageId, Promise promise){
    //     try{
    //         LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
    //         int[] displayBandIndexes = layerSettingImage.getDisplayBandIndexes();

    //         WritableMap map = Arguments.createMap();
    //         map.putArray("displayBandIndexes", displayBandIndexes);
    //         promise.resolve(map);
    //     }catch (Exception e){
    //         promise.reject(e);
    //     }
    // }

    // /**
    //  * 获取影像图层的色彩显示模式
    //  */
    // @ReactMethod
    // public void getDisplayMode(String layerSettingImageId, Promise promise){
    //     try{
    //         LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
    //         ImageDisplayMode imageDisplayMode = layerSettingImage.getDisplayMode();

    //         WritableMap map = Arguments.createMap();
    //         map.putInt("imageDisplayMode", imageDisplayMode);
    //         promise.resolve(map);
    //     }catch (Exception e){
    //         promise.reject(e);
    //     }
    // }

    // /**
    //  * 获取影像拉伸参数，没有颜色表或者数量为0，则标示支持拉伸显示；反之，则会使用颜色表显示影像
    //  */
    // @ReactMethod
    // public void getImageStretchOption(String layerSettingImageId, Promise promise){
    //     try{
    //         LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
    //         ImageStretchOption imageStretchOption = layerSettingImage.getImageStretchOption();

    //         WritableMap map = Arguments.createMap();
    //         map.putInt("imageStretchOption", imageStretchOption);
    //         promise.resolve(map);
    //     }catch (Exception e){
    //         promise.reject(e);
    //     }
    // }

    // /**
    //  * 获取地图制定图层集合（针对Rest服务）
    //  */
    // @ReactMethod
    // public void getMapLayersID(String layerSettingImageId, Promise promise){
    //     try{
    //         LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
    //         String mapLayersID = layerSettingImage.getMapLayersID();

    //         WritableMap map = Arguments.createMap();
    //         map.putInt("mapLayersID", mapLayersID);
    //         promise.resolve(map);
    //     }catch (Exception e){
    //         promise.reject(e);
    //     }
    // }

    /**
     * 获取当前指定的透明背景色
     */
    @ReactMethod
    public void getTransparentColor(String layerSettingImageId, Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            Color color = layerSettingImage.getTransparentColor();

            int R = color.getR();
            int G = color.getG();
            int B = color.getB();
            int A = color.getA();

            WritableMap map = Arguments.createMap();
            map.putInt("R", R);
            map.putInt("G", G);
            map.putInt("B", B);
            map.putInt("A", A);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取当前透明背景色的容限值【0-255】，0便是指定颜色可以透明显示；255标示所有颜色豆浆显示透明
     */
    @ReactMethod
    public void getTransparentColorTolerance(String layerSettingImageId, Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            int mapLayersID = layerSettingImage.getTransparentColorTolerance();

            WritableMap map = Arguments.createMap();
            map.putInt("mapLayersID", mapLayersID);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 获取当前透明背景色的容限值【0-255】，0便是指定颜色可以透明显示；255标示所有颜色豆浆显示透明
     */
    @ReactMethod
    public void isTransparent(String layerSettingImageId, Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            boolean isTransparent = layerSettingImage.isTransparent();

            WritableMap map = Arguments.createMap();
            map.putBoolean("isTransparent", isTransparent);
            promise.resolve(map);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置图层最大缓存数
     */
    @ReactMethod
    public void setCacheMaxSize(String layerSettingImageId, int maxSize,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            layerSettingImage.setCacheMaxSize(maxSize);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置当前影像图层显示的波段索引
     */
    @ReactMethod
    public void setDisplayBandIndexes(String layerSettingImageId, int[] bandIndexes,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            layerSettingImage.setDisplayBandIndexes(bandIndexes);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    // /**
    //  * 设置当前影像图层显示的波段索引
    //  */
    // @ReactMethod
    // public void setDisplayColorSpaceType(String layerSettingImageId, ColorSpaceType colorSpaceType,Promise promise){
    //     try{
    //         LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
    //         layerSettingImage.setDisplayColorSpaceType(colorSpaceType);

    //         promise.resolve(true);
    //     }catch (Exception e){
    //         promise.reject(e);
    //     }
    // }

    /**
     * 设置影像显示模式
     */
    @ReactMethod
    public void setDisplayMode(String layerSettingImageId, ImageDisplayMode mode,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            layerSettingImage.setDisplayMode(mode);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置图层波段Image的拉伸模式
     */
    @ReactMethod
    public void setImageStretchOption(String layerSettingImageId, ImageStretchOption option,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            layerSettingImage.setImageStretchOption(option);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置地图指定图层集合
     */
    @ReactMethod
    public void setMapLayersID(String layerSettingImageId, String laysersID,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            layerSettingImage.setMapLayersID(laysersID);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置影像图层背景色是否透明
     */
    @ReactMethod
    public void setTransparent(String layerSettingImageId, boolean enable,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            layerSettingImage.setTransparent(enable);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置影像图层背景透明色
     */
    @ReactMethod
    public void setTransparentColor(String layerSettingImageId, int r, int g, int b, int a,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            Color color = new Color(r, g, b, a);
            layerSettingImage.setTransparentColor(color);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置当前透明背景色的容限值【0-255】，0便是指定颜色可以透明显示；255标示所有颜色豆浆显示透明
     */
    @ReactMethod
    public void setTransparentColorTolerance(String layerSettingImageId, int value,Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            layerSettingImage.setTransparentColorTolerance(value);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    /**
     * 设置当前影像图层显示的波段索引
     */
    @ReactMethod
    public void setVisibleSubLayers(String layerSettingImageId, ReadableArray subLayers, Promise promise){
        try{
            LayerSettingImage layerSettingImage = getObjFromList(layerSettingImageId);
            String[] list = new String[subLayers.size()];
            for (int i = 0; i < subLayers.size(); i++) {
                list[i] = subLayers.getString(i);
            }
            layerSettingImage.setVisibleSubLayers(list);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }
   
}

