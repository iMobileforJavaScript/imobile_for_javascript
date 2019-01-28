package com.supermap.map3D.toolKit;

import android.view.MotionEvent;
import android.view.View;

import com.supermap.data.FieldInfos;
import com.supermap.data.GeometryType;
import com.supermap.data.Workspace;
import com.supermap.realspace.Feature3D;
import com.supermap.realspace.Feature3DSearchOption;
import com.supermap.realspace.Feature3Ds;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3DOSGBFile;
import com.supermap.realspace.Layer3DType;
import com.supermap.realspace.Layer3Ds;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.Selection3D;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by zym on 2018/11/8.
 */

public class TouchUtil {



    /**
     * 触摸单体化建筑获取属性
     *
     * @param mSceneControl
     */
    public static Map<String, String> getAttribute(SceneControl mSceneControl) {
        Layer3Ds layer3ds = mSceneControl.getScene().getLayers();
        Map<String, String> attributeMap = new HashMap<>();

        // 返回给定的三维图层集合中三维图层对象的总数。
        int count = layer3ds.getCount();
        if (count > 0) {
            for (int i = 0; i < count; i++) {
                Layer3D layer = layer3ds.get(i);
                // 遍历count之后，得到三维图层对象
                // 返回三维图层的选择集。
                if (layer == null) {
                    continue;
                }
                final Selection3D selection = layer.getSelection();
                if (selection == null) {
                    continue;
                }
                if (layer.getName() == null) {
                    continue;
                }
                // 获取选择集中对象的总数
                if (selection.getCount() > 0) {
                    // 返回选择集中指定几何对象的系统 ID
                    int _nID = selection.get(0);
                    Scene tempScene = mSceneControl.getScene();
                    String sceneUrl = tempScene.getUrl();
                    // 本地数据获取

                    // 不管KML是在线和本地都是一样的方式。
                    // 不管矢量数据是在线和本地都是一样
                    // 只有倾斜数据的时候，本地从UDB中取，在线用json.
                    attributeMap.clear();
                    if (layer.getType() == Layer3DType.KML) {
                        Utils.KMLData(layer, _nID, attributeMap);
//                        layer.getSelection().clear();
                        return attributeMap;
                    }
                    FieldInfos fieldInfos = layer.getFieldInfos();
                    int FieldInfosCount = fieldInfos.getCount();
                    if (FieldInfosCount > 0) {
                        Utils.vect(selection, layer, fieldInfos, attributeMap);
                    } else {
                        // 在线和本地是不一样 本地是UDB 在线是Json
                        if (sceneUrl == null || sceneUrl.isEmpty() || sceneUrl.equals("")) {
                            Workspace mWorkspace = null;
                            mWorkspace = new Workspace();
                            Utils.urlNUll(tempScene, _nID, mWorkspace, attributeMap);
                        }
                        Utils.urlNoNULL(mSceneControl, sceneUrl, _nID, attributeMap);

                    }
                    return attributeMap;
                }
            }
        }
        attributeMap.clear();
        return attributeMap;
    }


    /**
     *获取有图层的所有对象的属性
     *
     * @param mSceneControl
     */
    public static Map<String, String> getAllAttribute(Layer3D layer,SceneControl mSceneControl) {
        Map<String, String> attributeMap = new HashMap<>();
        if (layer == null || layer.getName() == null) {
              return null;
        }
        //如果是kml图层
        if (layer.getType() == Layer3DType.KML) {
            Feature3Ds feature3Ds = layer.getFeatures();
            int feature3DsCount = feature3Ds.getCount();
            for (int featureIndex = 0; featureIndex < feature3DsCount; featureIndex++) {
                Feature3D feature3D = (Feature3D) feature3Ds.get(featureIndex);
                String value = feature3D.getDescription();
                String value1 = feature3D.getName();
                attributeMap.put("name:", value1);
                attributeMap.put("description:", value);

            }
        }

        Scene tempScene = mSceneControl.getScene();
        String sceneUrl = tempScene.getUrl();


        FieldInfos fieldInfos = layer.getFieldInfos();
        int filedInfosCount = fieldInfos.getCount();
        Layer3DOSGBFile layer3d=null;
        if (layer.getType() == Layer3DType.OSGBFILE){
             layer3d = (Layer3DOSGBFile) layer;
        }

        Feature3Ds feature3Ds = layer3d.getFeatures();
        int feature3DsCount = feature3Ds.getCount();
        for (int featureIndex = 0; featureIndex < feature3DsCount; featureIndex++) {
            Feature3D feature3D = (Feature3D) feature3Ds.get(featureIndex);
            if (filedInfosCount > 0) {
                vect(feature3D, layer, fieldInfos, attributeMap);
            } else {
                // 在线和本地是不一样 本地是UDB 在线是Json
                if (sceneUrl == null || sceneUrl.isEmpty() || sceneUrl.equals("")) {
                    Workspace mWorkspace = null;
                    mWorkspace = new Workspace();
                    Utils.urlNUll(tempScene, feature3D.getID(), mWorkspace, attributeMap);
                }else {
                    Utils.urlNoNULL(mSceneControl, sceneUrl, feature3D.getID(), attributeMap);
                }

            }
            return attributeMap;
        }

        return attributeMap;
    }


    // 属性查询时的矢量数据
    public static void vect(Feature3D feature3D, Layer3D layer, FieldInfos fieldInfos, Map<String, String> attributeMap) {
        Feature3D feature = null;
        Layer3DOSGBFile layer3d = null;
        if (layer.getType() == Layer3DType.OSGBFILE) {

            layer3d = (Layer3DOSGBFile) layer;
            //Selection3D selection3d = layer3d.getSelection();
        } else if (layer.getType() == Layer3DType.VECTORFILE) {
            feature = feature3D;
        }
        int count = 0;
        Object[] str = null;
        if (feature == null) {
            str = layer3d.getAllFieldValueOfLastSelectedObject();
            if (str != null) {
                count = str.length;
            }
        } else {
            count = fieldInfos.getCount();
        }

        for (int j = 0; j < count; j++) {
            String name = fieldInfos.get(j).getName();
            //是否过滤
            if (name.toLowerCase().startsWith("sm")) {
                continue;
            }
            String strValue;
            Object value;
            if (feature == null) {
                value = str[j];
            } else {
                value = feature.getFieldValue(name);
            }
            if (value.equals("NULL")) {
                strValue = "";
            } else {
                strValue = value.toString();
            }
            attributeMap.put(name, strValue);
        }

    }

    /**
     * 获取被选中的兴趣点Feature3D
     *
     * @param mSceneControl
     * @return
     */
    public static Feature3D getSelectFeature3D(SceneControl mSceneControl) {
        Layer3Ds layer3ds = mSceneControl.getScene().getLayers();
        // 返回给定的三维图层集合中三维图层对象的总数。
        int count = layer3ds.getCount();
        if (count <= 0) {
            return null;
        }
        // 遍历count之后，得到三维图层对象
        for (int i = 0; i < count; i++) {
            Layer3D layer = layer3ds.get(i);
            if (layer == null) {
                continue;
            }
            final Selection3D selection = layer.getSelection();
            if (selection == null) {
                continue;
            }
            if (layer.getName() == null) {
                continue;
            }
            // 获取选择集中对象的总数
            if (selection.getCount() <= 0) {
                continue;
            }
            // 返回选择集中指定几何对象的系统 ID
            int _nID = selection.get(0);
            //是否是kml图层
            if (layer.getType() == Layer3DType.KML) {
                return null;
            }
            Feature3Ds fer = layer.getFeatures();
            //Feature3Ds是否为空
            if (fer == null && fer.getCount() <= 0) {
                return null;
            }
            Feature3D fer3d = fer.findFeature(_nID, Feature3DSearchOption.ALLFEATURES);
            if (fer3d != null && fer3d.getGeometry().getType() == GeometryType.GEOPLACEMARK) {
                return fer3d;
            }else {
                return null;
            }

        }
        return null;
    }

    /**
     * 设置Feature3D的name
     */
    public static void setFeature3DName(Feature3D feature3D,String name){
        feature3D.setName(name);
    }

    /**
     * 设置Feature3D的Description
     */
    public static void setDescription(Feature3D feature3D,String description){
        feature3D.setDescription(description);
    }


    /**
     * 清除选择集
     *
     * @param sceneControl
     */
    public static void clearSelect(SceneControl sceneControl) {
        Layer3Ds layer3ds = sceneControl.getScene().getLayers();
        int count = layer3ds.getCount();
        for (int i = 0; i < count; i++) {
            Selection3D selection3d = layer3ds.get(i).getSelection();
            selection3d.clear();
        }
    }


    public interface OsgbAttributeCallBack {
        void attributeInfo(Map<String, String> attributeMap);
    }
}
