package com.supermap.smNative;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Enum;
import com.supermap.data.FieldInfos;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.Layers;
import com.supermap.mapping.Map;
import com.supermap.mapping.Selection;
import com.supermap.mapping.Theme;

public class SMLayer {
    public static WritableArray getLayersByType(int type, String path) {
        Map map = SMap.getSMWorkspace().getMapControl().getMap();
        Layers layers = map.getLayers();
        int count = layers.getCount();

        WritableArray arr = Arguments.createArray();
        if (path == null || path.equals("")) {
            for (int i = 0; i < count; i++) {
                Layer layer = layers.get(i);
                Dataset dataset = layer.getDataset();

                if (dataset == null || type == -1 || dataset.getType() == Enum.parse(DatasetType.class, type)) {
                        WritableMap info = getLayerInfo(layer, path);
                        arr.pushMap(info);
                }
            }
        } else {
            Layer layer = findLayerByPath(path);
            if (layer.getDataset() == null) {
                LayerGroup layerGroup = (LayerGroup) layer;
                for (int i = 0; i < layerGroup.getCount(); i++) {
                    Layer mLayer = layerGroup.get(i);
                        WritableMap info = getLayerInfo(mLayer, path);
                        arr.pushMap(info);
                }
            }
        }

        return arr;
    }

    public static WritableArray getLayersByGroupPath(String path) {
        Map map = SMap.getSMWorkspace().getMapControl().getMap();
        Layers layers = map.getLayers();
        LayerGroup layerGroup = null;
        Layer layer;
        WritableArray arr = Arguments.createArray();
        String[] pathParams = path.split("/");

        if (path.equals("") || pathParams.length == 1) {
            layer = layers.get(pathParams[0]);
        } else {
            layer = findLayerByPath(path);
        }

        if (layer.getDataset() == null) {
            layerGroup = (LayerGroup) layer;
        } else {
            return arr;
        }

        for (int i = 0; i < layerGroup.getCount(); i++) {
            Layer mLayer = layerGroup.get(i);
            WritableMap info = getLayerInfo(mLayer, path);
            arr.pushMap(info);
        }

        return arr;
    }

    public static void setLayerVisible(String path, boolean value) {
        Layer layer = findLayerByPath(path);
        layer.setVisible(value);
    }

    public static void setLayerEditable(String path, boolean value) {
        Layer layer = findLayerByPath(path);
        layer.setEditable(value);
    }

    public static WritableMap getLayerInfo(Layer layer, String path) {
        Dataset dataset = layer.getDataset();
        int intType = -1;
        if (dataset != null) { // 没有数据集的Layer是LayerGroup
            intType = dataset.getType().value();
        }
        Theme theme = layer.getTheme();
        int themeType = 0;
        if (theme != null) {
            themeType = theme.getType().value();
        }

        WritableMap wMap = Arguments.createMap();
        LayerGroup layerGroup = layer.getParentGroup();
        String groupId = "";
        String groupName = "";
        if (layerGroup != null) {
            groupName = layerGroup.getName();
        }

        path = path == null || path.equals("") ? layer.getName() : (path + "/" + layer.getName());

        wMap.putString("name", layer.getName());
        wMap.putString("caption", layer.getCaption());
        wMap.putString("description", layer.getDescription());
        wMap.putBoolean("isEditable", layer.isEditable());
        wMap.putBoolean("isVisible", layer.isVisible());
        wMap.putBoolean("isSelectable", layer.isSelectable());
//            wMap.putBoolean("isSnapable", layer.isSnapable()); // TODO 对象被释放
        wMap.putBoolean("isSnapable", true);
        wMap.putString("layerGroupId", groupId);
        wMap.putString("groupName", groupName);
        wMap.putInt("themeType", themeType);
        wMap.putString("path", path);

        if (dataset != null && intType >= 0) { // 没有数据集的Layer是LayerGroup
            wMap.putInt("type", intType);
            wMap.putString("datasetName", dataset.getName());
            wMap.putString("datasourceAlias", dataset.getDatasource().getConnectionInfo().getAlias());
        } else {
            wMap.putString("type", "layerGroup");
        }

        return wMap;
    }

    public static Layer findLayerByPath(String path) {
        if (path == null || path.equals("")) return null;
        Map map = SMap.getSMWorkspace().getMapControl().getMap();
        Layers layers = map.getLayers();

        String[] pathParams = path.split("/");
        Layer layer;
        LayerGroup layerGroup;
        layer = layers.get(pathParams[0]);
        for (int i = 1; i < pathParams.length; i++) {
            if (layer.getDataset() == null) {
                layerGroup = (LayerGroup) layer;
                layer = layerGroup.getLayerByName(pathParams[i]);
            } else {
                break;
            }
        }
        return layer;
    }

    public static int getLayerIndex(String name){
        Map map = SMap.getSMWorkspace().getMapControl().getMap();
        Layers layers = map.getLayers();
        int index = layers.indexOfByCaption(name);
        return index;
    }

    public static WritableMap getLayerAttribute(String path, int page, int size) {
        Layer layer = findLayerByPath(path);
        DatasetVector dv = (DatasetVector) layer.getDataset();

        Recordset recordset = dv.getRecordset(false, CursorType.DYNAMIC);
        int nCount = recordset.getRecordCount() > size ? size : recordset.getRecordCount();
        WritableMap data = JsonUtil.recordsetToMap(recordset, page, nCount);
        return data;
    }

    public static WritableMap getSelectionAttributeByLayer(String path, int page, int size) {
        Layer layer = findLayerByPath(path);
        Selection selection = layer.getSelection();

        Recordset recordset = selection.toRecordset();
        recordset.moveFirst();

        int nCount = recordset.getRecordCount() > size ? size : recordset.getRecordCount();
        WritableMap data = JsonUtil.recordsetToMap(recordset, page, nCount);

        recordset.dispose();

        return data;
    }

    public static WritableMap getAttributeByLayer(String path, ReadableArray ids) {
        Layer layer = findLayerByPath(path);
        String filter = "";

        for (int i = 0; i < ids.size(); i++) {
            if (i == 0) {
                filter = "SmID=" + ids.getInt(i);
            } else {
                filter += "OR SmID=" + ids.getInt(i);
            }
        }

        QueryParameter queryParameter = new QueryParameter();
        queryParameter.setCursorType(CursorType.STATIC);
        queryParameter.setAttributeFilter(filter);

        Recordset recordset = ((DatasetVector)layer.getDataset()).query(queryParameter);
        recordset.moveFirst();

        int nCount = recordset.getRecordCount();
        WritableMap data = JsonUtil.recordsetToMap(recordset, 0, nCount);

        recordset.dispose();

        return data;
    }

    public static String getLayerPath(Layer layer) {
        String path = layer.getName();
        while (layer.getParentGroup() != null) {
            path = layer.getParentGroup().getName() + "/" + path;
        }
        return path;
    }

    public static WritableMap searchLayerAttribute(String layerPath, ReadableMap params, int start, int number) {
        String filter = params.hasKey("filter") ? params.getString("filter") : "";
        String key = params.hasKey("key") ? params.getString("key") : "";

        Layer layer = SMLayer.findLayerByPath(layerPath);
        DatasetVector dv = (DatasetVector) layer.getDataset();
        QueryParameter queryParameter = new QueryParameter();
        Recordset recordset = null;

        if (filter != null && filter.length() > 0) {
            queryParameter.setAttributeFilter(filter);
            queryParameter.setCursorType(CursorType.STATIC);
            recordset = dv.query(queryParameter);
        } else if (key != null && key.length() > 0) {
            FieldInfos fieldInfos = dv.getFieldInfos();
            int count = fieldInfos.getCount();
//            String str = "";
            String sql = "";
            for (int i = 0; i < count; i++) {
//                    str = str + fieldInfos.get(i).getName() + ",";
//                    if (i == count - 1) {
//                        str = str + fieldInfos.get(i).getName();
//                    }

                if (i == 0) {
                    sql = fieldInfos.get(i).getName() + " LIKE '%" + key + "%'";
                } else {
                    sql = sql + " OR " + fieldInfos.get(i).getName() + " LIKE '%" + key + "%'";
                }
            }
//                sql = "CONCAT(" + str + ") LIKE '%" + key + "%'";
            queryParameter.setAttributeFilter(sql);
            queryParameter.setCursorType(CursorType.STATIC);
            recordset = dv.query(queryParameter);
        } else {
            recordset = ((DatasetVector) layer.getDataset()).getRecordset(false, CursorType.STATIC);
        }
//            int nCount = recordset.getRecordCount()>20 ?20:recordset.getRecordCount();
        WritableMap data = JsonUtil.recordsetToMap(recordset, start, number);
        recordset.dispose();

        return data;
    }

    public static WritableMap searchSelectionAttribute(String path, String searchKey, int page, int size) {
        Layer layer = findLayerByPath(path);
        Selection selection = layer.getSelection();

        Recordset recordset = selection.toRecordset();
        recordset.moveFirst();

        int nCount = recordset.getRecordCount() > size ? size : recordset.getRecordCount();
        WritableMap data = JsonUtil.recordsetToMap(recordset, page, nCount, searchKey);

        recordset.dispose();

        return data;
    }
}
