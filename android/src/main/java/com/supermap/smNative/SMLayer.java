package com.supermap.smNative;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.RNUtils.MediaUtil;
import com.supermap.component.ImageWrapView;
import com.supermap.component.MapWrapView;
import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasource;
import com.supermap.data.Enum;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.QueryParameter;
import com.supermap.data.Recordset;
import com.supermap.data.Workspace;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerHeatmap;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.Layers;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.Selection;
import com.supermap.mapping.Theme;
import com.supermap.mapping.dyn.DynamicView;
import com.supermap.smNative.components.InfoCallout;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.HashMap;

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

        boolean isHeatmap = layer instanceof LayerHeatmap;//是否是热力图层

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
        wMap.putBoolean("isHeatmap", isHeatmap);

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

    public static HashMap<String,Object> findLayerAndGroupByPath(String path) {
        if (path == null || path.equals("")) return null;
        Map map = SMap.getSMWorkspace().getMapControl().getMap();
        Layers layers = map.getLayers();

        String[] pathParams = path.split("/");
        Layer layer = null;
        LayerGroup layerGroup = null;
        layer = layers.get(pathParams[0]);
        for (int i = 1; i < pathParams.length; i++) {
            if (layer.getDataset() == null) {
                layerGroup = (LayerGroup) layer;
                layer = layerGroup.getLayerByName(pathParams[i]);
            } else {
                break;
            }
        }
        HashMap<String,Object> res = new HashMap<>();
        res.put("layer",layer);
        res.put("layerGroup",layerGroup);
        return res;
    }

    public static Layer findLayerWithName(String name) {
        if (name == null || name.equals("")) return null;
        Map map = SMap.getSMWorkspace().getMapControl().getMap();
        Layers layers = map.getLayers();

        return layers.find(name);
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

    public static Layer findLayerByDatasetName(String datasetName) {
        if (datasetName == null || datasetName.equals("")) return null;
        Map map = SMap.getInstance().getSmMapWC().mapControl.getMap();
        Layers layers = map.getLayers();
        Layer targetlayer = null;
        int count = layers.getCount();
        for (int i = 0; i < count; i++) {
            Layer layer = layers.get(i);
            Dataset dataset = layer.getDataset();

            if (dataset.getName().equals(datasetName)) {
                targetlayer = layer;
                break;
            }
        }
        return targetlayer;
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

    public static Layer addLayerByName(String datasourceName, String datasetName) {
        SMap sMap = SMap.getInstance();
        Workspace workspace = sMap.getSmMapWC().getWorkspace();
        Map map = sMap.getSmMapWC().getMapControl().getMap();
        if (!datasourceName.equals("") && !datasetName.equals("")) {
            Datasource datasource = workspace.getDatasources().get(datasourceName);
            Dataset dataset = datasource.getDatasets().get(datasetName);
            Layer layer = map.getLayers().add(dataset, true);

            map.setVisibleScalesEnabled(false);
            map.refresh();
            return layer;
        }
        return null;
    }

    public static Layer addLayerByIndex(String datasourceName, int datasetIndex) {
        SMap sMap = SMap.getInstance();
        Workspace workspace = sMap.getSmMapWC().getWorkspace();
        Map map = sMap.getSmMapWC().getMapControl().getMap();
        if (!datasourceName.equals("") && datasetIndex >= 0) {
            Datasource datasource = workspace.getDatasources().get(datasourceName);
            Dataset dataset = datasource.getDatasets().get(datasetIndex);
            Layer layer = map.getLayers().add(dataset, true);

            map.setVisibleScalesEnabled(false);
            map.refresh();
            return layer;
        }
        return null;
    }

    public static Layer addLayerByIndex(int datasourceIndex, String datasetName) {
        SMap sMap = SMap.getInstance();
        Workspace workspace = sMap.getSmMapWC().getWorkspace();
        Map map = sMap.getSmMapWC().getMapControl().getMap();
        if (datasourceIndex >= 0) {
            Datasource datasource = workspace.getDatasources().get(datasourceIndex);
            Dataset dataset = datasource.getDatasets().get(datasetName);
            Layer layer = map.getLayers().add(dataset, true);

            map.setVisibleScalesEnabled(false);
            map.refresh();
            return layer;
        }
        return null;
    }

    public static Layer addLayerByName(int datasourceIndex, int datasetIndex) {
        SMap sMap = SMap.getInstance();
        Workspace workspace = sMap.getSmMapWC().getWorkspace();
        Map map = sMap.getSmMapWC().getMapControl().getMap();
        if (datasourceIndex >= 0 && datasetIndex >= 0) {
            Datasource datasource = workspace.getDatasources().get(datasourceIndex);
            Dataset dataset = datasource.getDatasets().get(datasetIndex);
            Layer layer = map.getLayers().add(dataset, true);

            map.setVisibleScalesEnabled(false);
            map.refresh();
            return layer;
        }
        return null;
    }

    public static boolean setLayerFieldInfo(Layer layer, ReadableArray fieldInfos, ReadableMap params) {
        if (layer == null) return false;
        Layers layers = SMap.getInstance().getSmMapWC().getMapControl().getMap().getLayers();
        Layer editableLayer = null;

        // 找到原来可编辑图层并记录
        // 三种情况：1.目标图层即为可编辑图层；2.目标图层不为可编辑图层，且layers中不存在编辑图层；3.layers中存在可编辑图层，但不是目标图层
        int status = 1;
        if (!layer.isEditable()) {
            for (int i = 0; i < layers.getCount(); i++) {
                if (layers.get(i).isEditable()) {
                    editableLayer = layers.get(i);
                    status = 3;
                    break;
                }
            }

            layer.setEditable(true);
            if (editableLayer != null) {
                status = 2;
            }
        }


        DatasetVector dv = (DatasetVector) layer.getDataset();
        Recordset recordset;

        if (params.hasKey("filter")) {
            String filter = params.getString("filter");
            CursorType cursorType = CursorType.DYNAMIC;
            if (params.hasKey("cursorType")) {
                cursorType = (CursorType) Enum.parse(CursorType.class, params.getInt("cursorType"));
            }
            QueryParameter queryParameter = new QueryParameter();
            queryParameter.setAttributeFilter(filter);
            queryParameter.setCursorType(cursorType);
            recordset = dv.query(queryParameter);
        } else {
            recordset = dv.getRecordset(false, CursorType.DYNAMIC);
            if (params.hasKey("index")) {
                int index = params.getInt("index");
                index = index >= 0 ? index : (recordset.getRecordCount() - 1);
                recordset.moveTo(index);
            }
        }

        recordset.edit();

        for (int i = 0; i < fieldInfos.size(); i++) {
            ReadableMap info = fieldInfos.getMap(i);
            String name = info.getString("name");
            ReadableType valueType = info.getType("value");

            FieldInfo fieldInfo = recordset.getFieldInfos().get(name);
            FieldType type = fieldInfo.getType();

            switch (valueType) {
                case Number:{
                    if (type == FieldType.INT16) {
                        String value = info.getString("value");
                        recordset.setInt16(name, Short.parseShort(value));
                    } else if (type == FieldType.INT32) {
                        int value = info.getInt("value");
                        recordset.setInt32(name, value);
                    } else if (type == FieldType.INT64) {
                        int value = info.getInt("value");
                        recordset.setInt64(name, value);
                    } else if (type == FieldType.SINGLE) {
                        int value = info.getInt("value");
                        recordset.setSingle(name, value);
                    } else if (type == FieldType.DOUBLE) {
                        Double value = info.getDouble("value");
                        recordset.setDouble(name, value);
                    }
                    break;
                }
                case String: {
                    if (type == FieldType.TEXT || type == FieldType.WTEXT
                            || type == FieldType.LONGBINARY || type == FieldType.BYTE) {
                        String value1 = info.getString("value");
                        recordset.setFieldValue(name, value1);
                    }
                    break;
                }
                case Boolean: {
                    if (type == FieldType.BOOLEAN) {
                        boolean boolValue = info.getBoolean("value");
                        recordset.setBoolean(name, boolValue);
                    }
                }
            }
        }

        recordset.update();
        recordset.dispose();
        recordset = null;

        // 还原编辑之前的图层可编辑状态
        switch (status) {
            case 2:
                layer.setEditable(false);
                break;
            case 3:
                editableLayer.setEditable(true);
                break;
            case 1:
            default:
                break;
        }
        return true;
    }

    public static InfoCallout addCallOutWithLongitude(final Context context, double longitude, double latitude, final String imagePath) {
        int imgSize = 60;

        SMap sMap = SMap.getInstance();
        final MapControl mapControl = sMap.getSmMapWC().getMapControl();
        final Map map = mapControl.getMap();

        final Point2D pt = new Point2D(longitude, latitude);
        if (map.getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
            PrjCoordSys Prj = map.getPrjCoordSys();
            Point2Ds points = new Point2Ds();
            points.add(pt);
            PrjCoordSys desPrjCoorSys = new PrjCoordSys();
            desPrjCoorSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            CoordSysTranslator.convert(points, desPrjCoorSys, Prj,
                    new CoordSysTransParameter(),
                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

            pt.setX(points.getItem(0).getX());
            pt.setY(points.getItem(0).getY());
        }

        final InfoCallout callout = new InfoCallout(context);

        String extension = imagePath.substring(imagePath.lastIndexOf(".") + 1);

        final ImageView img = new ImageView(context);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(imgSize, imgSize);
        img.setLayoutParams(layoutParams);
        img.setMinimumHeight(imgSize);
        img.setMinimumWidth(imgSize);

        if (extension.equals("mp4")) {
            img.setImageBitmap(MediaUtil.getScreenShotImageFromVideoPath(imagePath, imgSize, imgSize));
        } else {
            img.setImageBitmap(MediaUtil.getLocalBitmap(imagePath, imgSize, imgSize));
        }

        sMap.getActivity().runOnUiThread(new Runnable(){
            @Override
            public void run(){
                callout.setContentView(img);
                callout.setLocation(pt.getX(), pt.getY());

                MapWrapView mapWrapView = (MapWrapView)map.getMapView();

                mapWrapView.addCallout(callout, callout.getID());

                map.setCenter(pt);
                if (map.getScale() < 0.000011947150294723098) {
                    map.setScale(0.000011947150294723098);
                }
                map.refresh();

                mapWrapView.showCallOut();
            }
        });

        return callout;
    }
}
