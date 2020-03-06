/**
 *
 */
package com.supermap.interfaces.mapping;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.AttributeSet;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.datasource.DataSources;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Dynamic;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.events.NativeGestureUtil;
import com.supermap.RNUtils.ColorParseUtil;
import com.supermap.RNUtils.DataUtil;
import com.supermap.RNUtils.FileUtil;
import com.supermap.RNUtils.JsonUtil;
import com.supermap.analyst.TopologyProcessing;
import com.supermap.analyst.TopologyProcessingOptions;
import com.supermap.analyst.networkanalyst.NetworkBuilder;
import com.supermap.analyst.networkanalyst.NetworkSplitMode;
import com.supermap.component.MapWrapView;
import com.supermap.containts.EventConst;
import com.supermap.data.*;
import com.supermap.data.Enum;
import com.supermap.data.Maps;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.data.Point2Ds;
import com.supermap.data.Rectangle2D;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.Resources;
import com.supermap.data.Workspace;
import com.supermap.indoor.FloorListView;
import com.supermap.interfaces.utils.SMFileUtil;
import com.supermap.interfaces.utils.POISearchHelper2D;
import com.supermap.interfaces.utils.ScaleViewHelper;
import com.supermap.map3D.toolKit.PoiGsonBean;
import com.supermap.mapping.Action;
import com.supermap.mapping.CalloutAlignment;
import com.supermap.mapping.ColorLegendItem;
import com.supermap.mapping.EditHistoryType;
import com.supermap.mapping.GeometryAddedListener;
import com.supermap.mapping.GeometryEvent;
import com.supermap.mapping.GeometrySelectedEvent;
import com.supermap.mapping.GeometrySelectedListener;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerSettingVector;
import com.supermap.mapping.Layers;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.Legend;
import com.supermap.mapping.LegendContentChangeListener;
import com.supermap.mapping.LegendItem;
import com.supermap.mapping.LegendView;
import com.supermap.mapping.MapColorMode;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapParameterChangedListener;
import com.supermap.mapping.MapView;
import com.supermap.mapping.MeasureListener;
import com.supermap.mapping.ScaleView;
import com.supermap.mapping.Selection;
import com.supermap.mapping.ThemeGridRange;
import com.supermap.mapping.ThemeRange;
import com.supermap.mapping.ThemeType;
import com.supermap.mapping.ThemeUnique;
import com.supermap.mapping.TrackingLayer;
import com.supermap.mapping.collector.Collector;
import com.supermap.navi.NaviInfo;
import com.supermap.navi.NaviListener;
import com.supermap.navi.NaviPath;
import com.supermap.navi.NaviStep;
import com.supermap.navi.Navigation2;
import com.supermap.navi.Navigation3;
import com.supermap.onlineservices.CoordinateType;
import com.supermap.onlineservices.Geocoding;
import com.supermap.onlineservices.GeocodingData;
import com.supermap.onlineservices.NavigationOnline;
import com.supermap.onlineservices.NavigationOnlineData;
import com.supermap.onlineservices.NavigationOnlineParameter;
import com.supermap.onlineservices.PathInfo;
import com.supermap.onlineservices.RouteType;
import com.supermap.plot.AnimationAttribute;
import com.supermap.plot.AnimationBlink;
import com.supermap.plot.AnimationDefine;
import com.supermap.plot.AnimationGO;
import com.supermap.plot.AnimationGroup;
import com.supermap.plot.AnimationGrow;
import com.supermap.plot.AnimationManager;
import com.supermap.plot.AnimationRotate;
import com.supermap.plot.AnimationScale;
import com.supermap.plot.AnimationShow;
import com.supermap.plot.AnimationWay;
import com.supermap.plot.GeoGraphicObject;
import com.supermap.plot.GraphicObjectType;
import com.supermap.plugin.LocationManagePlugin;
import com.supermap.plugin.SpeakPlugin;
import com.supermap.plugin.Speaker;
import com.supermap.rnsupermap.R;
import com.supermap.smNative.SMMapFixColors;
import com.supermap.smNative.SMMapRender;
import com.supermap.smNative.collector.SMCollector;
import com.supermap.smNative.SMLayer;
import com.supermap.smNative.SMMapWC;
import com.supermap.smNative.SMSymbol;
import com.supermap.data.Color;
import com.supermap.smNative.components.InfoCallout;
import com.supermap.interfaces.utils.StrokeTextView;
import com.supermap.services.LogInfoService;
import com.supermap.smNative.components.SNavigation2;

import org.apache.http.cookie.SM;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.lang.reflect.Array;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import static com.supermap.interfaces.utils.SMFileUtil.copyFiles;
import static com.supermap.RNUtils.FileUtil.homeDirectory;
import static java.lang.Double.isNaN;

public class SMap extends ReactContextBaseJavaModule implements LegendContentChangeListener {
    public static final String REACT_CLASS = "SMap";
    private static SMap sMap;
    private static ReactApplicationContext context;
    private static MeasureListener mMeasureListener;
    private GestureDetector mGestureDetector;
    private GeometrySelectedListener mGeometrySelectedListener;
    private ScaleViewHelper scaleViewHelper;
    private static Boolean hasBigCallout = false;
    private static final int curLocationTag = 118081;
    public static int fillNum;
    public static Color[] fillColors;
    public static Random random;// 用于保存产生随机的线风格颜色的Random对象
    private InfoCallout m_callout;
    String rootPath = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();
    private String lcenseSerialNumberFilePath;
    private boolean hasScaleChangeTask = false;
    private boolean hasBoundsChangeTask = false;
    private ScaleViewHelper getScaleViewHelper() {
        if (scaleViewHelper == null) {
            MapControl mapControl = SMap.getInstance().smMapWC.getMapControl();
            scaleViewHelper = new ScaleViewHelper(context, mapControl);
        }
        if (scaleViewHelper.mapParameterChangedListener == null) {

            scaleViewHelper.addScaleChangeListener(new MapParameterChangedListener() {
                public void scaleChanged(double newScale) {
                    boolean bHasBoundsChangeTask = false;
                    synchronized (this){
                        bHasBoundsChangeTask = hasScaleChangeTask;
                    }
                    if(!bHasBoundsChangeTask){
                        synchronized (this){
                            hasScaleChangeTask = true;
                        }

                        TimerTask scaleChangeTask = new TimerTask() {
                            @Override
                            public void run() {
                                FloorListView floorListView = SMap.getInstance().smMapWC.getFloorListView();
                                double pointScale = 1.0/2500;
                                if(floorListView != null){
                                    if(newScale < pointScale && floorListView.getVisibility() == View.VISIBLE){
                                        floorListView.setVisibility(View.INVISIBLE);
                                    }else if(newScale > pointScale && floorListView.getVisibility() == View.INVISIBLE){
                                        floorListView.setVisibility(View.VISIBLE);
                                    }
                                }
                                if (scaleViewHelper == null)
                                    return;
                                scaleViewHelper.mScaleLevel = scaleViewHelper.getScaleLevel();
                                scaleViewHelper.mScaleText = scaleViewHelper.getScaleText(scaleViewHelper.mScaleLevel);
                                scaleViewHelper.mScaleWidth = scaleViewHelper.getScaleWidth(scaleViewHelper.mScaleLevel);
                                WritableMap map = Arguments.createMap();
                                map.putDouble("width", scaleViewHelper.mScaleWidth);
                                map.putString("title", scaleViewHelper.mScaleText);
                                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(EventConst.SCALEVIEW_CHANGE, map);

                                String currentFloorID = "";
                                if (floorListView != null && floorListView.getVisibility() == View.VISIBLE) {
                                    currentFloorID = floorListView.getCurrentFloorId();
                                }
                                WritableMap map2 = Arguments.createMap();
                                map2.putString("currentFloorID",currentFloorID);
                                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(EventConst.IS_FLOOR_HIDDEN, map2);
                                synchronized (this) {
                                    hasScaleChangeTask = false;
                                }
                            }
                        };
                        Timer timer = new Timer();
                        timer.schedule(scaleChangeTask,200);
                    }
                }

                public void boundsChanged(Point2D newMapCenter) {
                    boolean bHasBoundsChangeTask = false;
                    synchronized (this){
                        bHasBoundsChangeTask = hasBoundsChangeTask;
                    }

                    if(!bHasBoundsChangeTask){
                        synchronized (this){
                            hasBoundsChangeTask = true;
                        }

                        TimerTask boundsChangeTask = new TimerTask() {
                            @Override
                            public void run() {
                                sMap = SMap.getInstance();
                                FloorListView floorListView = sMap.smMapWC.getFloorListView();
                                String currentFloorID = "";
                                if (floorListView != null && floorListView.getVisibility() == View.VISIBLE) {
                                    currentFloorID = floorListView.getCurrentFloorId();
                                }
                                WritableMap map = Arguments.createMap();
                                map.putString("currentFloorID",currentFloorID);
                                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                        .emit(EventConst.IS_FLOOR_HIDDEN, map);
                                synchronized (this){
                                    hasBoundsChangeTask = false;
                                }

                            }
                        };
                        Timer timer = new Timer();
                        timer.schedule(boundsChangeTask,200);
                    }

                }

                public void angleChanged(double newAngle) {
                }

                public void sizeChanged(int width, int height) {
                }
            });
        }
        return scaleViewHelper;
    }

    public Selection getSelection() {
        return selection;
    }

    public void setSelection(Selection selection) {
        this.selection = selection;
    }

    private Selection selection;

    public SMMapWC getSmMapWC() {
        return smMapWC;
    }

    public void setSmMapWC(SMMapWC smMapWC) {
        this.smMapWC = smMapWC;
    }

    public SMMapWC smMapWC;

    private Point2D defaultMapCenter = null;

    public SMap(ReactApplicationContext context) {
        super(context);
        this.context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static SMap getInstance() {
        if (sMap == null) {
            sMap = new SMap(context);
        }
        if (sMap.smMapWC == null) {
            sMap.smMapWC = new SMMapWC();
        }
        setWorkspace(null);
        return sMap;
    }

    public static SMap getInstance(ReactApplicationContext context) {
        if (sMap == null) {
            sMap = new SMap(context);
        }
        if (sMap.smMapWC == null) {
            sMap.smMapWC = new SMMapWC();
        }
        setWorkspace(null);
        return sMap;
    }

    public static void setInstance(MapControl mapControl) {
        sMap = getInstance();
        sMap.smMapWC.setMapControl(mapControl);
        setWorkspace(null);
        if (sMap.smMapWC.getMapControl().getMap() != null && sMap.smMapWC.getMapControl().getMap().getWorkspace() == null) {
            sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());
        }
    }

    public static void setWorkspace(Workspace workspace) {
        if (sMap.smMapWC.getWorkspace() == null) {
            if (workspace == null) {
                Workspace _workspace = new Workspace();
                sMap.smMapWC.setWorkspace(_workspace);
            } else {
                sMap.smMapWC.setWorkspace(workspace);
            }
        }
    }

    public static SMMapWC getSMWorkspace() {
        return getInstance().smMapWC;
    }

    public Activity getActivity() {
        return getCurrentActivity();
    }

    public String getPackageName() {
        return context.getPackageName();
    }

    public String getNativeLibraryDir() {
        return context.getApplicationInfo().nativeLibraryDir;
    }

    public AssetManager getAssets() {
        return context.getAssets();
    }


    //判断坐标系Type是否相等，避免不支持的type转Enum抛异常
    public static boolean safeGetType(PrjCoordSys coordSys1, PrjCoordSys coordSys2) {
        try {
            if (coordSys1.getType() == coordSys2.getType()) {
                return true;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    //判断坐标系Type是否相等，避免不支持的type转Enum抛异常
    public static boolean safeGetType(PrjCoordSys coordSys1, PrjCoordSysType prjCoordSysType) {
        try {
            if (coordSys1.getType() == prjCoordSysType) {
                return true;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 获取许可文件状态
     *
     * @param promise
     */
    @ReactMethod
    public void getEnvironmentStatus(Promise promise) {
        try {
            LicenseStatus status = Environment.getLicenseStatus();
            WritableMap statusMap = Arguments.createMap();
            statusMap.putBoolean("isActivated", status.isActivated());
            statusMap.putBoolean("isLicenseValid", status.isLicenseValid());
            statusMap.putBoolean("isLicenseExist", status.isLicenseExsit());
            statusMap.putBoolean("isTrailLicense", status.isTrailLicense());
            SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
            statusMap.putString("startDate", format.format(status.getStartDate()));
            statusMap.putString("expireDate", format.format(status.getExpireDate()));
            statusMap.putString("version", status.getVersion() + "");
            promise.resolve(statusMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    private void showMarkerHelper(Point2D pt, int tag) {
        final Point2D mapPt = pt;//new Point2D(11584575.605042318,3573118.555091877);
        final String tagStr = tag + "";
        getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
//                    final  Point2D mapPt = new Point2D(11584575.605042318,3573118.555091877);
                GeoPoint point = new GeoPoint(mapPt.getX(), mapPt.getY());
                GeoStyle style = new GeoStyle();
                style.setMarkerSymbolID(118081);
                style.setMarkerSize(new Size2D(6, 6));
                style.setLineColor(new Color(255, 0, 0, 255));
                point.setStyle(style);

                sMap.smMapWC.getMapControl().getMap().getTrackingLayer().add(point, tagStr);
                if (sMap.smMapWC.getMapControl().getMap().getScale() < 1/2785.0) {
                    sMap.smMapWC.getMapControl().getMap().setScale(1 / 2785.0);
                }
                Handler handler = new Handler();
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        sMap.smMapWC.getMapControl().panTo(mapPt, 200); //.getMap().setCenter(mapPt);
                        sMap.smMapWC.getMapControl().getMap().refresh();
                    }
                }, 0);//3秒后执行Runnable中的run方法
            }
        });
    }

    /**
     * 添加marker
     *
     * @param longitude
     * @param latitude
     * @param promise
     */
    @ReactMethod
    public void showMarker(double longitude, double latitude, int tag, Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().getMap().refresh();

            Point2D pt = new Point2D(longitude, latitude);
            if (!safeGetType(sMap.smMapWC.getMapControl().getMap().getPrjCoordSys(), PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)) {
                Point2Ds point2Ds = new Point2Ds();
                point2Ds.add(pt);
                PrjCoordSys prjCoordSys = new PrjCoordSys();
                prjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                CoordSysTransParameter parameter = new CoordSysTransParameter();

                CoordSysTranslator.convert(point2Ds, prjCoordSys, sMap.smMapWC.getMapControl().getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                pt = point2Ds.getItem(0);
                showMarkerHelper(pt, tag);
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    private void deleteMarkerHelper(int tag) {
        final String tagStr = tag + "";
        getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                //  sMap.smMapWC.getMapControl().getMap().getMapView().removeCallOut(tagStr);
                int n = sMap.smMapWC.getMapControl().getMap().getTrackingLayer().indexOf(tagStr);
                if (n != -1) {
                    sMap.smMapWC.getMapControl().getMap().getTrackingLayer().remove(n);
                    sMap.smMapWC.getMapControl().getMap().refresh();
                }
            }
        });
    }

    /**
     * 移除marker
     *
     * @param promise
     */
    @ReactMethod
    public void deleteMarker(int tag, Promise promise) {
        try {
            deleteMarkerHelper(tag);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 刷新地图
     *
     * @param promise
     */
    @ReactMethod
    public void refreshMap(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().getMap().refresh();

            getCurrentActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    ((MapWrapView) sMap.smMapWC.getMapControl().getMap().getMapView()).requestLayout();
                }
            });

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 打开工作空间
     *
     * @param data
     * @param promise
     */
    @ReactMethod
    public void openWorkspace(ReadableMap data, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            boolean result = sMap.smMapWC.openWorkspace(params);
            if (result) {
                if (sMap.getSmMapWC().getMapControl() != null && sMap.getSmMapWC().getMapControl().getMap() != null && !sMap.getSmMapWC().getMapControl().getMap().getName().equals("")) {
//                    sMap.getSmMapWC().getMapControl().getMap().close();
//                    sMap.getSmMapWC().getMapControl().getMap().setWorkspace(sMap.getSmMapWC().getWorkspace());

                    sMap.getSmMapWC().getMapControl().getMap().setVisibleScalesEnabled(false);
                    // sMap.getSmMapWC().getMapControl().setMagnifierEnabled(true);
                    sMap.getSmMapWC().getMapControl().getMap().setAntialias(true);
                    sMap.getSmMapWC().getMapControl().getMap().refresh();
                }
            }

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 仅用于判断在线数据是否可请求到数据
     *
     * @param data
     */
    @ReactMethod
    public void isDatasourceOpen(ReadableMap data, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            Datasource datasource = sMap.smMapWC.openDatasource(params);
            if (datasource != null) {
                promise.resolve(true);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 判断当前数据源别名是否可用，返回可用别名
     *
     * @param alias
     * @param promise
     */
    @ReactMethod
    public void isAvilableAlias(String alias, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            int index = 1;
            while (datasources.indexOf(alias) != -1) {
                alias += "_" + index;
                index++;
            }
            promise.resolve(alias);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 以数据源形式打开工作空间setLayerFieldInfo
     *
     * @param data
     * @param defaultIndex 默认显示Map 图层索引
     * @param promise
     */
    @ReactMethod
    public void openDatasourceWithIndex(ReadableMap data, int defaultIndex, boolean toHead, boolean visable, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            Datasource datasource = sMap.smMapWC.openDatasource(params);
            sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());

            if (datasource != null && defaultIndex >= 0 && datasource.getDatasets().getCount() > 0) {
                Dataset ds = datasource.getDatasets().get(defaultIndex);
                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                map.setDynamicProjection(true);
                Layer layer = map.getLayers().add(ds, toHead);
                layer.setVisible(visable);
                if (ds.getType() == DatasetType.REGION) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setLineSymbolID(5);
                }
                if (ds.getType() == DatasetType.REGION || ds.getType() == DatasetType.REGION3D) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setFillForeColor(this.getFillColor());
                    setting.getStyle().setLineColor(this.getLineColor());
                } else if (ds.getType() == DatasetType.LINE || ds.getType() == DatasetType.NETWORK || ds.getType() == DatasetType.NETWORK3D
                        || ds.getType() == DatasetType.LINE3D) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setLineColor(this.getLineColor());
                    if (ds.getType() == DatasetType.NETWORK || ds.getType() == DatasetType.NETWORK3D) {
                        map.getLayers().add(((DatasetVector) ds).getChildDataset(), true);
                    }
                } else if (ds.getType() == DatasetType.POINT || ds.getType() == DatasetType.POINT3D) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setLineColor(this.getLineColor());
                }
            }
            getScaleViewHelper();
            sMap.smMapWC.getMapControl().getMap().setVisibleScalesEnabled(false);
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 以数据源形式打开工作空间
     *
     * @param data
     * @param defaultName 默认显示Map 图层名称
     * @param promise
     */
    @ReactMethod
    public void openDatasourceWithName(ReadableMap data, String defaultName, boolean toHead, boolean visable, Promise promise) {
        try {
            sMap = getInstance();
            Map params = data.toHashMap();
            Datasource datasource = sMap.smMapWC.openDatasource(params);
            sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());

            if (datasource != null && !defaultName.equals("")) {
                Dataset ds = datasource.getDatasets().get(defaultName);
                sMap.smMapWC.getMapControl().getMap().setDynamicProjection(true);
                Layer layer = sMap.smMapWC.getMapControl().getMap().getLayers().add(ds, toHead);
                layer.setVisible(visable);
            }
            getScaleViewHelper();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 不同于上次选用的填充颜色的颜色
     *
     * @return
     */
    public static Color getFillColor() {

        Color result = new Color(255, 192, 203);
        if (fillNum >= getFillColors().length) {
            fillNum = 0;
        }
        result = getFillColors()[fillNum];
        fillNum++;
        return result;

    }

    /**
     * 获取随机的用于线风格的颜色
     *
     * @return
     */
    public static Color getLineColor() {
        return getRandomLineColor();
    }

    /**
     * 产生随机的用于线风格的颜色 经过初步试验，新产生的线颜色，饱和度【0-240】最好在30-100之间 亮度【0-240】最好在75-120之间
     *
     * @return
     */
    private static Color getRandomLineColor() {
        Color result = new Color(255, 192, 203);
        try {
            if (random == null) {
                random = new Random();
            }
            result = new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255));
        } catch (Exception ex) {
        }
        return result;
    }

    private static Color[] getFillColors() {
        if (fillColors == null) {
            fillColors = new Color[10];
            fillColors[0] = new Color(224, 207, 226);
            fillColors[1] = new Color(151, 191, 242);
            fillColors[2] = new Color(242, 242, 186);
            fillColors[3] = new Color(190, 255, 232);
            fillColors[4] = new Color(255, 190, 232);
            fillColors[5] = new Color(255, 190, 190);
            fillColors[6] = new Color(255, 235, 175);
            fillColors[7] = new Color(233, 255, 190);
            fillColors[8] = new Color(234, 225, 168);
            fillColors[9] = new Color(174, 241, 176);
        }
        return fillColors;
    }

    /**
     * 根据名称关闭数据源，datasourceName为空则全部关闭
     *
     * @param datasourceName
     * @param promise
     */
    @ReactMethod
    public void closeDatasourceWithName(String datasourceName, Promise promise) {
        try {
            sMap = getInstance();
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            Boolean isClose = true;
            if (datasourceName.equals("")) {
                for (int i = 0; i < datasources.getCount(); i++) {
                    if (datasources.get(i) != null && datasources.get(i).isOpened()) {
                        isClose = datasources.close(i) && isClose;
                    }
                }
            } else {
                if (datasources.get(datasourceName) != null) {
                    isClose = datasources.close(datasourceName);
                }
            }

            promise.resolve(isClose);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据序号关闭数据源，index = -1 则全部关闭
     *
     * @param index
     * @param promise
     */
    @ReactMethod
    public void closeDatasourceWithIndex(int index, Promise promise) {
        try {
            sMap = getInstance();
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();
            Boolean isClose = true;
            if (index == -1) {
                for (int i = 0; i < datasources.getCount(); i++) {
                    if (datasources.get(i) != null && datasources.get(i).isOpened()) {
                        isClose = datasources.close(i) && isClose;
                    }
                }
            } else {
                if (datasources.get(index) != null) {
                    isClose = datasources.close(index);
                }
            }

            promise.resolve(isClose);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 工作空间是否被修改
     *
     * @param promise
     */
    @ReactMethod
    public void workspaceIsModified(Promise promise) {
        try {
            sMap = getInstance();
            boolean result = sMap.smMapWC.getWorkspace().isModified();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存工作空间
     *
     * @param promise
     */
    @ReactMethod
    public void saveWorkspace(Promise promise) {
        try {
            sMap = getInstance();
            boolean result = sMap.smMapWC.saveWorkspace();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据工作空间连接信息保存工作空间
     *
     * @param data
     * @param promise
     */
    @ReactMethod
    public void saveWorkspaceWithInfo(ReadableMap data, Promise promise) {
        try {
            sMap = getInstance();
            Map info = data.toHashMap();
            boolean result = sMap.smMapWC.saveWorkspaceWithInfo(info);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取UDB中数据集名称
     *
     * @param path    UDB在内存中路径
     * @param promise
     */
    @ReactMethod
    public void getUDBName(String path, Promise promise) {
        try {
            File tempFile = new File(path.trim());
            String[] strings = tempFile.getName().split("\\.");
            String udbName = strings[0];
            Datasource datasource;
            Workspace workspace = null;
            sMap = getInstance();
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();

//            if (sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().indexOf(udbName) != -1) {
//                sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().close(udbName);
//            }
            if (sMap.smMapWC.getMapControl() == null) {
                workspace = new Workspace();
                datasourceconnection.setEngineType(EngineType.UDB);
                datasourceconnection.setServer(path);
                datasourceconnection.setAlias(udbName);
                datasource = workspace.getDatasources().open(datasourceconnection);
            } else {
                sMap.smMapWC.getMapControl().getMap().setWorkspace(sMap.smMapWC.getWorkspace());
                if (sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().indexOf(udbName) != -1) {
                    datasource = sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().get(udbName);
                } else {
                    datasourceconnection.setEngineType(EngineType.UDB);
                    datasourceconnection.setServer(path);
                    datasourceconnection.setAlias(udbName);
                    datasource = sMap.smMapWC.getMapControl().getMap().getWorkspace().getDatasources().open(datasourceconnection);
                }
            }
            Datasets datasets = datasource.getDatasets();
            int count = datasets.getCount();

            WritableArray arr = Arguments.createArray();
            for (int i = 0; i < count; i++) {
                Dataset dataset = datasets.get(i);
                String name = dataset.getName();
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("title", name);
                String description = dataset.getDescription();
                if (description.equals("NULL")) {
                    description = "";
                }
                writeMap.putString("description", description);
                arr.pushMap(writeMap);
            }
            if (workspace != null) {
                workspace.getDatasources().closeAll();
                workspace.close();
                workspace.dispose();
            }
            datasourceconnection.dispose();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取UDB中数据集名称
     *
     * @param path    UDB在内存中路径
     * @param promise
     */
    @ReactMethod
    public void getUDBNameOfLabel(String path, Promise promise) {
        try {
            File tempFile = new File(path.trim());
            String[] strings = tempFile.getName().split("\\.");
            String udbName = strings[0];
            Datasource datasource;
            sMap = getInstance();
            DatasourceConnectionInfo datasourceconnection = new DatasourceConnectionInfo();
            Workspace workspace = new Workspace();
            datasourceconnection.setEngineType(EngineType.UDB);
            datasourceconnection.setServer(path);
            datasourceconnection.setAlias(udbName);
            datasource = workspace.getDatasources().open(datasourceconnection);
            Datasets datasets = datasource.getDatasets();
            int count = datasets.getCount();
            WritableArray arr = Arguments.createArray();
            for (int i = 0; i < count; i++) {
                Dataset dataset = datasets.get(i);
                String name = dataset.getName();
                WritableMap writeMap = Arguments.createMap();
                writeMap.putString("name", name);
                arr.pushMap(writeMap);
            }
            if (workspace != null) {
                workspace.getDatasources().closeAll();
                workspace.close();
                workspace.dispose();
            }
            datasourceconnection.dispose();
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取工作空间文件内的信息
     */
    @ReactMethod
    public void getLocalWorkspaceInfo(String serverUrl, Promise promise) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Workspace ws = new Workspace();
                    WorkspaceConnectionInfo workspaceConnectionInfo = new WorkspaceConnectionInfo();
                    workspaceConnectionInfo.setServer(serverUrl);
                    String tempStr = serverUrl.toLowerCase();
                    if(tempStr.endsWith(".smwu")){
                        workspaceConnectionInfo.setType(WorkspaceType.SMWU);
                    } else if(tempStr.endsWith(".sxwu")) {
                        workspaceConnectionInfo.setType(WorkspaceType.SXWU);
                    } else if(tempStr.endsWith(".smw")) {
                        workspaceConnectionInfo.setType(WorkspaceType.SMW);
                    } else if(tempStr.endsWith(".sxw")) {
                        workspaceConnectionInfo.setType(WorkspaceType.SXW);
                    }

                    WritableMap workspaceInfos = Arguments.createMap();
                    WritableArray Maps = Arguments.createArray();
                    WritableArray Scenes = Arguments.createArray();
                    WritableArray datasources = Arguments.createArray();

                    if(ws.open(workspaceConnectionInfo)){
                        for(int i = 0; i <  ws.getMaps().getCount(); i++) {
                            Maps.pushString(ws.getMaps().get(i));
                        }

                        for(int i = 0; i < ws.getScenes().getCount(); i++) {
                            Scenes.pushString(ws.getScenes().get(i));
                        }

                        DatasourceConnectionInfo datasourceConnectionInfo = null;
                        for(int i = 0; i < ws.getDatasources().getCount(); i++) {
                            datasourceConnectionInfo = ws.getDatasources().get(i).getConnectionInfo();
                            if(datasourceConnectionInfo.getEngineType() == EngineType.UDB) {
                                WritableMap datasourceInfo = Arguments.createMap();
                                datasourceInfo.putString("alias", datasourceConnectionInfo.getAlias());
                                datasourceInfo.putString("server", datasourceConnectionInfo.getServer());
                                datasources.pushMap(datasourceInfo);
                            }
                        }
                    }

                    workspaceInfos.putArray("maps", Maps);
                    workspaceInfos.putArray("scenes", Scenes);
                    workspaceInfos.putArray("datasources", datasources);

                    ws.close();
                    ws.dispose();
                    promise.resolve(workspaceInfos);
                } catch (Exception e) {
                    promise.reject(e);
                }
            }
        }).start();
    }

    /**
     * 根据名字显示图层
     *
     * @param name
     * @param viewEntire
     * @param center
     * @param promise
     */
    @ReactMethod
    public void openMapByName(String name, boolean viewEntire, ReadableMap center, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();


            Boolean isOpen = false;

            if (maps.getCount() > 0) {
                String mapName = name;

                if (name.equals("")) {
                    mapName = maps.get(0);
                }

                isOpen = map.open(mapName);

                if (isOpen) {
                    getScaleViewHelper();
                    if (viewEntire) {
                        map.viewEntire();
                    }

                    if (center != null && center.hasKey("x") && center.hasKey("y")) {
                        Double x = center.getDouble("x");
                        Double y = center.getDouble("y");
                        Point2D point2D = new Point2D(x, y);
                        map.setCenter(point2D);
                    }

                    defaultMapCenter = new Point2D(map.getCenter());
                    sMap.smMapWC.getMapControl().setAction(Action.PAN);
                    map.setVisibleScalesEnabled(false);
                    map.refresh();
//                    Handler handler = new Handler();
//                    handler.postDelayed(new Runnable() {
//                        @Override
//                        public void run() {
//                            sMap.getSmMapWC().getMapControl().zoomTo(sMap.getSmMapWC().getMapControl().getMap().getScale() * 0.9, 100);
//                        }
//                    }, 100);//3秒后执行Runnable中的run方法
                }
            }

            promise.resolve(isOpen);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 根据序号显示图层
     *
     * @param index
     * @param viewEntire
     * @param center
     * @param promise
     */
    @ReactMethod
    public void openMapByIndex(int index, boolean viewEntire, ReadableMap center, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();

            Boolean isOpen = index < 0;

            if (maps.getCount() > 0 && index >= 0) {
                if (index >= maps.getCount()) index = maps.getCount() - 1;
                String name = maps.get(index);

                isOpen = map.open(name);

                if (isOpen) {
                    getScaleViewHelper();

                    if (viewEntire) {
                        map.viewEntire();
                    }

                    if (center != null && center.hasKey("x") && center.hasKey("y")) {
                        Double x = center.getDouble("x");
                        Double y = center.getDouble("y");
                        Point2D point2D = new Point2D(x, y);
                        map.setCenter(point2D);
                    }
                    defaultMapCenter = new Point2D(map.getCenter());
                    sMap.smMapWC.getMapControl().setAction(Action.PAN);
                    map.setVisibleScalesEnabled(false);
                    map.refresh();
                }
            }
            promise.resolve(isOpen);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取工作空间地图列表
     *
     * @param promise
     */
    @ReactMethod
    public void getMaps(Promise promise) {
        try {
            sMap = getInstance();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();
            WritableArray mapList = Arguments.createArray();
            for (int i = 0; i < maps.getCount(); i++) {
                WritableMap mapInfo = Arguments.createMap();
                String mapName = maps.get(i);
                mapInfo.putString("title", mapName);
                mapList.pushMap(mapInfo);
            }
            promise.resolve(mapList);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取工作空间地图列表
     *
     * @param promise
     */
    @ReactMethod
    public void getMapInfo(Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();

            WritableMap mapInfo = Arguments.createMap();
            mapInfo.putString("name", map.getName());
            mapInfo.putString("description", map.getDescription());
            mapInfo.putBoolean("isModified", map.isModified());

            promise.resolve(mapInfo);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭工作空间及地图控件
     *
     * @param promise
     */
    @ReactMethod
    public void closeWorkspace(Promise promise) {
        try {
//            getCurrentActivity().runOnUiThread(new DisposeThread(promise));
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            Workspace workspace = sMap.smMapWC.getWorkspace();
            com.supermap.mapping.Map map = mapControl.getMap();
            defaultMapCenter = null;
            map.close();
            map.dispose();
//                mapControl.dispose();
            workspace.close();
//            workspace.dispose();

//            sMap.smMapWC.setMapControl(null);
//            sMap.smMapWC.setWorkspace(null);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 关闭地图
     *
     * @param promise
     */
    @ReactMethod
    public void closeMap(Promise promise) {
        try {
            sMap = getInstance();
            if (scaleViewHelper != null) {
                if (scaleViewHelper.mapParameterChangedListener != null) {
                    scaleViewHelper.removeScaleChangeListener();
//                    scaleViewHelper.mapParameterChangedListener = null;
                }
                scaleViewHelper = null;
            }
            if (sMap.smMapWC.getFloorListView() != null) {
                sMap.smMapWC.setFloorListView(null);
            }
            MapControl mapControl = sMap.smMapWC.getMapControl();
            if (mapControl != null) {
                com.supermap.mapping.Map map = mapControl.getMap();
                defaultMapCenter = null;
                deleteMarkerHelper(curLocationTag);
                map.close();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置Selection样式
     *
     * @param layerPath
     * @param styleJson
     * @param promise
     */
    @ReactMethod
    public void setSelectionStyle(String layerPath, String styleJson, Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            Layer layer = SMLayer.findLayerByPath(layerPath);
            Selection selection = layer.getSelection();
            GeoStyle style = new GeoStyle();
            style.fromJson(styleJson);
            selection.setStyle(style);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    private void clearLayerSelection(LayerGroup layerGroup) {
        for (int i = 0; i < layerGroup.getCount(); i++) {
            Layer layer = layerGroup.get(i);
            if (layer instanceof LayerGroup) {
                clearLayerSelection((LayerGroup) layer);
            } else {
                Selection selection = layer.getSelection();
                if (selection != null) {
                    selection.clear();
//                    selection.dispose();
                }
            }
        }
    }

    /**
     * 清除Selection
     *
     * @param promise
     */
    @ReactMethod
    public void clearSelection(Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            Layers layers = mapControl.getMap().getLayers();
            for (int i = 0; i < layers.getCount(); i++) {

                Layer layer = layers.get(i);
                if (layer instanceof LayerGroup) {
                    clearLayerSelection((LayerGroup) layer);
                } else {
                    Selection selection = layer.getSelection();
                    if (selection != null) {
                        selection.clear();
//                        selection.dispose();
                    }
                }
            }
            mapControl.getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    class DisposeThread implements Runnable {

        private Promise promise;

        public DisposeThread(Promise promise) {
            this.promise = promise;
        }

        @Override
        public void run() {
            try {
                sMap = getInstance();
                MapControl mapControl = sMap.smMapWC.getMapControl();
                Workspace workspace = sMap.smMapWC.getWorkspace();
                com.supermap.mapping.Map map = mapControl.getMap();
                mapControl.getEditHistory().dispose();

                map.close();
                map.dispose();
//                mapControl.dispose();
                workspace.close();
                workspace.dispose();

//                sMap.smMapWC.setMapControl(null);
                sMap.smMapWC.setWorkspace(null);
                promise.resolve(true);
            } catch (Exception e) {
                promise.resolve(e);
            }
        }
    }

    @ReactMethod
    public void setAction(int actionType, Promise promise) {
        try {
            sMap = getInstance();
            Action action = (Action) Enum.parse(Action.class, actionType);
            sMap.smMapWC.getMapControl().setAction(action);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public void getAction(Promise promise) {
        try {
            sMap = getInstance();
            Action action = sMap.smMapWC.getMapControl().getAction();
            int actionType = action.value();

            promise.resolve(actionType);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void undo(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().undo();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void redo(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().redo();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addMeasureListener(Promise promise) {
        try {
            sMap = getInstance();
            mMeasureListener = new MeasureListener() {
                @Override
                public void lengthMeasured(double curResult, Point curPoint) {
                    if (isNaN(curResult)) curResult = 0.0;
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curResult", curResult);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MEASURE_LENGTH, map);
                }

                @Override
                public void areaMeasured(double curResult, Point curPoint) {
                    if (isNaN(curResult)) curResult = 0.0;
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curResult", curResult);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MEASURE_AREA, map);
                }

                @Override
                public void angleMeasured(double curAngle, Point curPoint) {
                    if (isNaN(curAngle)) curAngle = 0.0;
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curAngle", curAngle);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MEASURE_ANGLE, map);
                }
            };

            sMap.smMapWC.getMapControl().addMeasureListener(mMeasureListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeMeasureListener(Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().removeMeasureListener(mMeasureListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /******************************************** 地图工具 *****************************************************/
    /**
     * 放大缩小
     *
     * @param scale
     * @param promise
     */
    @ReactMethod
    public void zoom(double scale, Promise promise) {
        try {
            sMap = getInstance();
            double dscale = sMap.getSmMapWC().getMapControl().getMap().getScale() * scale;
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            sMap.getSmMapWC().getMapControl().zoomTo(dscale, 100);
            Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    map.setScale(dscale);
                    map.refresh();
                }
            }, 150);//3秒后执行Runnable中的run方法


            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置比例尺
     *
     * @param scale
     * @param promise
     */
    @ReactMethod
    public void setScale(double scale, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            map.setScale(scale);
            map.refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图手势旋转是否可用
     *
     * @param enable
     * @param promise
     */
    @ReactMethod
    public void enableRotateTouch(boolean enable, Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().enableRotateTouch(enable);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图手势俯仰是否可用
     *
     * @param enable
     * @param promise
     */
    @ReactMethod
    public void enableSlantTouch(boolean enable, Promise promise) {
        try {
            sMap = getInstance();
            sMap.smMapWC.getMapControl().enableSlantTouch(enable);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 地图裁剪
     *
     * @param points
     * @param layersInfo
     * @param mapName
     * @param nModule
     * @param addition
     * @param isPrivate
     * @param promise
     */
    @ReactMethod
    public void clipMap(ReadableArray points, ReadableArray layersInfo, String mapName, String nModule, ReadableMap addition, boolean isPrivate, Promise promise) {
        try {
            if (points.size() == 0) {
                promise.reject("points can not be empty!");
            } else {
                sMap = getInstance();

                Point2Ds point2Ds = new Point2Ds();
                for (int i = 0; i < points.size(); i++) {
                    ReadableMap p = points.getMap(i);
                    Point point = new Point((int) p.getDouble("x"), (int) p.getDouble("y"));
                    Point2D point2D = sMap.smMapWC.getMapControl().getMap().pixelToMap(point);

                    point2Ds.add(point2D);
                }

                GeoRegion region = new GeoRegion(point2Ds);

                if (mapName.equals("")) {
                    mapName = null;
                }
                String[] args = new String[1];
                args[0] = mapName;
                if (sMap.smMapWC.clipMap(sMap.smMapWC.getMapControl().getMap(), region, layersInfo, args)) {
                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putBoolean("result", true);

                    String resultName = args[0];
                    if (resultName != null && !resultName.equals("")) {
                        if (addition.hasKey("filterLayers")) {
                            WritableMap additionMap = Arguments.createMap();
                            ReadableMapKeySetIterator keySetIterator = addition.keySetIterator();
                            while (keySetIterator.hasNextKey()) {
                                String key = keySetIterator.nextKey();
                                if (key.equals("filterLayers")) {
                                    ReadableArray filterLayers = addition.getArray(key);
                                    WritableArray arr = Arguments.createArray();
                                    for (int i = 0; i < filterLayers.size(); i++) {
                                        arr.pushString(filterLayers.getString(i));
                                    }
                                    additionMap.putArray(key, arr);
                                } else {
                                    additionMap.putString(key, addition.getString(key));
                                }
                            }
                            resultName = sMap.smMapWC.saveMapName(resultName, sMap.smMapWC.getWorkspace(), nModule, additionMap, true, true, isPrivate);
                        } else {
                            Map<String, String> additionMap = new HashMap<>();
                            ReadableMapKeySetIterator keySetIterator = addition.keySetIterator();
                            while (keySetIterator.hasNextKey()) {
                                String key = keySetIterator.nextKey();
                                additionMap.put(key, addition.getString(key));
                            }
                            resultName = sMap.smMapWC.saveMapName(resultName, sMap.smMapWC.getWorkspace(), nModule, additionMap, true, true, isPrivate);
                        }

                        //另存后从maps移除当前另存的地图，以免添加地图失败
                        sMap.smMapWC.getWorkspace().getMaps().remove(resultName);
                    }
                    sMap.smMapWC.getMapControl().getMap().refresh();
                    writeMap.putString("mapName", resultName);
                    promise.resolve(writeMap);
                } else {
                    promise.reject(null, "Clip map failed!");
                }

            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /******************************************** 地图工具 END*****************************************************/


    @ReactMethod
    public void submit(Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().submit();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void cancel(Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().cancel();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存地图
     *
     * @param name
     * @param autoNaming    为true的话若有相同名字的地图则自动命名
     * @param saveWorkspace 为true的话若在保存地图的同时，保存工作空间
     * @param promise
     */
    @ReactMethod
    public void saveMap(String name, Boolean autoNaming, Boolean saveWorkspace, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            boolean mapSaved = false;
            boolean wsSaved = false;
            String _name = name;
            if (_name == null || _name.equals("")) {
                if (map.getName() != null && !map.getName().equals("")) {
                    mapSaved = map.save();
                } else if (map.getLayers().getCount() > 0) {
                    _name = map.getLayers().get(0).getName();
                    int i = 0;
                    if (autoNaming) {
                        while (!mapSaved) {
                            _name = i == 0 ? name : (name + i);
                            try {
                                mapSaved = map.save(_name);
                            } catch (Exception e) {
                                mapSaved = false;
                            }
                            i++;
                        }
                    } else {
                        mapSaved = map.save(_name);
                    }
                }
            } else {
                mapSaved = map.save(_name);
            }
            if (saveWorkspace) {
                wsSaved = sMap.smMapWC.getWorkspace().save();
            }
//            wsSaved = true;

            map.refresh();
            if (mapSaved && (!saveWorkspace || wsSaved)) {
                promise.resolve(_name);
            } else {
                promise.resolve(mapSaved && wsSaved);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移除指定位置的地图
     *
     * @param index
     * @param promise
     */
    @ReactMethod
    public void removeMapByIndex(int index, Promise promise) {
        try {
            sMap = getInstance();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();
            boolean result = true;
            if (maps.getCount() > 0 && index < maps.getCount()) {
                if (index == -1) {
                    for (int i = maps.getCount() - 1; i >= 0; i--) {
                        String name = maps.get(i);
                        result = maps.remove(i) && result;
                        sMap.smMapWC.getWorkspace().getResources().getMarkerLibrary().getRootGroup().getChildGroups().remove(name, false);
                        sMap.smMapWC.getWorkspace().getResources().getLineLibrary().getRootGroup().getChildGroups().remove(name, false);
                        sMap.smMapWC.getWorkspace().getResources().getFillLibrary().getRootGroup().getChildGroups().remove(name, false);
                    }
                } else {
                    String name = maps.get(index);
                    result = maps.remove(index);
                    sMap.smMapWC.getWorkspace().getResources().getMarkerLibrary().getRootGroup().getChildGroups().remove(name, false);
                    sMap.smMapWC.getWorkspace().getResources().getLineLibrary().getRootGroup().getChildGroups().remove(name, false);
                    sMap.smMapWC.getWorkspace().getResources().getFillLibrary().getRootGroup().getChildGroups().remove(name, false);
                }
            }

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移除指定名称的地图
     *
     * @param name
     * @param promise
     */
    @ReactMethod
    public void removeMapByName(String name, Promise promise) {
        try {
            sMap = getInstance();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();
            boolean result = true;
            if (maps.getCount() > 0 && (name == null || name.equals(""))) {
                for (int i = 0; i < maps.getCount(); i++) {
                    String _name = maps.get(i);
                    result = maps.remove(i) && result;
                    sMap.smMapWC.getWorkspace().getResources().getMarkerLibrary().getRootGroup().getChildGroups().remove(_name, false);
                    sMap.smMapWC.getWorkspace().getResources().getLineLibrary().getRootGroup().getChildGroups().remove(_name, false);
                    sMap.smMapWC.getWorkspace().getResources().getFillLibrary().getRootGroup().getChildGroups().remove(_name, false);
                }
            } else if (maps.getCount() > 0 && maps.indexOf(name) >= 0) {
                result = maps.remove(name);
                sMap.smMapWC.getWorkspace().getResources().getMarkerLibrary().getRootGroup().getChildGroups().remove(name, false);
                sMap.smMapWC.getWorkspace().getResources().getLineLibrary().getRootGroup().getChildGroups().remove(name, false);
                sMap.smMapWC.getWorkspace().getResources().getFillLibrary().getRootGroup().getChildGroups().remove(name, false);
            }

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 地图另存为
     *
     * @param name
     * @param promise
     */
    @ReactMethod
    public void saveAsMap(String name, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            boolean result = false;
            if (name != null && !name.equals("")) {
                result = map.saveAs(name);
                result = result && sMap.smMapWC.getWorkspace().save();
            }

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 检查地图是否有改动
     *
     * @param promise
     */
    @ReactMethod
    public void mapIsModified(Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            boolean idModified = map.isModified();

            promise.resolve(idModified);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 检查地图是否有改动
     *
     * @param promise
     */
    @ReactMethod
    public void getMapIndex(String name, Promise promise) {
        try {
            int index = -1;
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            Maps maps = sMap.smMapWC.getWorkspace().getMaps();

            if (name == null || name.equals("")) {
                if (map != null) {
                    index = maps.indexOf(map.getName());
                }
            } else {
                index = maps.indexOf(name);
            }

            promise.resolve(index);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移动到当前位置
     *
     * @param promise
     */
    @ReactMethod
    public void moveToCurrent(Promise promise) {
        try {
            MoveToCurrentThread moveToCurrentThread = new MoveToCurrentThread(promise);
            moveToCurrentThread.run();

            sMap.smMapWC.getMapControl().getMap().setAngle(0);
            sMap.smMapWC.getMapControl().getMap().setSlantAngle(0);
//            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移动到当前位置
     *
     * @param promise
     */
    @ReactMethod
    public void moveToPoint(ReadableMap point, Promise promise) {
        try {
            if (point.hasKey("x") && point.hasKey("y")) {
                Point2D point2D = new Point2D(point.getDouble("x"), point.getDouble("y"));
                MoveToCurrentThread moveToCurrentThread = new MoveToCurrentThread(point2D, false, promise);
                moveToCurrentThread.run();
//                promise.resolve(true);
            } else {
                promise.resolve(false);
            }

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    class MoveToCurrentThread implements Runnable {

        private Promise promise;
        private Point2D point2D;
        private boolean showMarker = true;

        public MoveToCurrentThread(Promise promise) {
            this.promise = promise;
        }

        public MoveToCurrentThread(Point2D point2D, Promise promise) {
            this.promise = promise;
            this.point2D = point2D;
        }

        public MoveToCurrentThread(Point2D point2D, boolean showMarker, Promise promise) {
            this.promise = promise;
            this.point2D = point2D;
            this.showMarker = showMarker;
        }

        @Override
        public void run() {
            try {
                sMap = getInstance();
                MapControl mapControl = sMap.smMapWC.getMapControl();
                Collector collector = mapControl.getCollector();

                Point2D pt;
                if (this.point2D == null) {
                    LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
                    pt = new Point2D(gpsDat.dLongitude, gpsDat.dLatitude);
//                    pt = collector.getGPSPoint();
                } else {
                    pt = this.point2D;
                }

                Boolean isMove = true;
                if (pt != null) {
                    // Point2D point2D = new Point2D(pt);

                    if (pt.getX() <= 180 && pt.getX() >= -180 && pt.getY() >= -90 && pt.getY() <= 90) {
                        if (!safeGetType(mapControl.getMap().getPrjCoordSys(), PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)) {
                            Point2Ds point2Ds = new Point2Ds();
                            point2Ds.add(pt);
                            PrjCoordSys prjCoordSys = new PrjCoordSys();
                            prjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                            CoordSysTransParameter parameter = new CoordSysTransParameter();

                            CoordSysTranslator.convert(point2Ds, prjCoordSys, mapControl.getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                            pt = point2Ds.getItem(0);
                        }
                    } else {
                        if (!safeGetType(mapControl.getMap().getPrjCoordSys(), PrjCoordSysType.PCS_SPHERE_MERCATOR)) {
                            Point2Ds point2Ds = new Point2Ds();
                            point2Ds.add(pt);
                            PrjCoordSys prjCoordSys = new PrjCoordSys();
                            prjCoordSys.setType(PrjCoordSysType.PCS_SPHERE_MERCATOR);
                            CoordSysTransParameter parameter = new CoordSysTransParameter();

                            CoordSysTranslator.convert(point2Ds, prjCoordSys, mapControl.getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                            pt = point2Ds.getItem(0);
                        }
                    }

//                    if (mapControl.getMap().getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
//                        Point2Ds point2Ds = new Point2Ds();
//                        point2Ds.add(pt);
//                        PrjCoordSys prjCoordSys = new PrjCoordSys();
//                        prjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
//                        CoordSysTransParameter parameter = new CoordSysTransParameter();
//
//                        CoordSysTranslator.convert(point2Ds, prjCoordSys, mapControl.getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
//                        pt = point2Ds.getItem(0);
//                    }
                }
                deleteMarkerHelper(curLocationTag);
                Point2D mapCenter = pt;
                if (pt != null && !mapControl.getMap().getBounds().contains(pt)) {
                    if (defaultMapCenter != null) {
                        mapCenter = defaultMapCenter;
                        mapControl.getMap().setCenter(mapCenter);
                        isMove = true;
                        mapControl.getMap().refresh();
                    }
                } else {
                    if (this.showMarker) {
                        showMarkerHelper(mapCenter, curLocationTag);
                    }
                }
                promise.resolve(isMove);
            } catch (Exception e) {
                promise.resolve(e);
            }
        }
    }

    /**
     * 监听长按动作和滚动动作
     *
     * @param promise
     */
    @ReactMethod
    public void setGestureDetector(final Promise promise) {
        try {
            mGestureDetector = new GestureDetector(context, new GestureDetector.SimpleOnGestureListener() {

                public boolean onScroll(MotionEvent e1, MotionEvent e2,
                                        float distanceX, float distanceY) {
                    WritableMap mapE1 = Arguments.createMap();
                    mapE1.putInt("x", (int) e1.getX());
                    mapE1.putInt("y", (int) e1.getY());

                    WritableMap mapE2 = Arguments.createMap();
                    mapE2.putInt("x", (int) e2.getX());
                    mapE2.putInt("y", (int) e2.getY());

                    WritableMap map = Arguments.createMap();
                    map.putMap("start", mapE1);
                    map.putMap("end", mapE2);
                    map.putDouble("dx", distanceX);
                    map.putDouble("dy", distanceY);


                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_SCROLL, map);
                    return false;
                }

                public boolean onDown(MotionEvent event) {
                    WritableMap screenPoint = Arguments.createMap();
                    screenPoint.putInt("x", (int) event.getX());
                    screenPoint.putInt("y", (int) event.getY());

                    Point2D point2D = SMap.getInstance().getSmMapWC().getMapControl().getMap()
                            .pixelToMap(new Point((int) event.getX(), (int) event.getY()));
                    WritableMap mapPoint = Arguments.createMap();
                    mapPoint.putInt("x", (int) point2D.getX());
                    mapPoint.putInt("y", (int) point2D.getY());

                    WritableMap map = Arguments.createMap();
                    map.putMap("screenPoint", screenPoint);
                    map.putMap("mapPoint", mapPoint);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_TOUCH_BEGAN, map);
                    return false;
                }

                public boolean onSingleTapUp(MotionEvent event) {
                    WritableMap screenPoint = Arguments.createMap();
                    screenPoint.putInt("x", (int) event.getX());
                    screenPoint.putInt("y", (int) event.getY());

                    Point2D point2D = SMap.getInstance().getSmMapWC().getMapControl().getMap()
                            .pixelToMap(new Point((int) event.getX(), (int) event.getY()));
                    WritableMap mapPoint = Arguments.createMap();
                    mapPoint.putInt("x", (int) point2D.getX());
                    mapPoint.putInt("y", (int) point2D.getY());

                    WritableMap map = Arguments.createMap();
                    map.putMap("screenPoint", screenPoint);
                    map.putMap("mapPoint", mapPoint);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_SINGLE_TAP, map);
                    return false;
                }

                public void onLongPress(MotionEvent event) {
                    WritableMap screenPoint = Arguments.createMap();
                    screenPoint.putInt("x", (int) event.getX());
                    screenPoint.putInt("y", (int) event.getY());

                    Point2D point2D = SMap.getInstance().getSmMapWC().getMapControl().getMap()
                            .pixelToMap(new Point((int) event.getX(), (int) event.getY()));
                    WritableMap mapPoint = Arguments.createMap();
                    mapPoint.putDouble("x", point2D.getX());
                    mapPoint.putDouble("y", point2D.getY());

                    Point2D LLPoint2D = getPoint(point2D.getX(),point2D.getY());
                    WritableMap LLPoint = Arguments.createMap();
                    LLPoint.putDouble("x",LLPoint2D.getX());
                    LLPoint.putDouble("y",LLPoint2D.getY());

                    WritableMap map = Arguments.createMap();
                    map.putMap("screenPoint", screenPoint);
                    map.putMap("mapPoint", mapPoint);
                    map.putMap("LLPoint",LLPoint);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_LONG_PRESS, map);
                }

                public boolean onSingleTapConfirmed(MotionEvent event) {
                    WritableMap screenPoint = Arguments.createMap();
                    screenPoint.putInt("x", (int) event.getX());
                    screenPoint.putInt("y", (int) event.getY());

                    Point2D point2D = SMap.getInstance().getSmMapWC().getMapControl().getMap()
                            .pixelToMap(new Point((int) event.getX(), (int) event.getY()));
                    WritableMap mapPoint = Arguments.createMap();
                    mapPoint.putInt("x", (int) point2D.getX());
                    mapPoint.putInt("y", (int) point2D.getY());

                    WritableMap map = Arguments.createMap();
                    map.putMap("screenPoint", screenPoint);
                    map.putMap("mapPoint", mapPoint);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_SINGLE_TAP_CONFIR, map);
                    return false;
                }

                public boolean onDoubleTap(MotionEvent event) {
                    WritableMap screenPoint = Arguments.createMap();
                    screenPoint.putInt("x", (int) event.getX());
                    screenPoint.putInt("y", (int) event.getY());

                    Point2D point2D = SMap.getInstance().getSmMapWC().getMapControl().getMap()
                            .pixelToMap(new Point((int) event.getX(), (int) event.getY()));
                    WritableMap mapPoint = Arguments.createMap();
                    mapPoint.putInt("x", (int) point2D.getX());
                    mapPoint.putInt("y", (int) point2D.getY());

                    WritableMap map = Arguments.createMap();
                    map.putMap("screenPoint", screenPoint);
                    map.putMap("mapPoint", mapPoint);

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_DOUBLE_TAP, map);
                    return false;
                }
            });
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.setGestureDetector(mGestureDetector);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public void deleteGestureDetector(Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.deleteGestureDetector();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addGeometrySelectedListener(Promise promise) {
        try {
            mGeometrySelectedListener = new GeometrySelectedListener() {
                @Override
                public void geometrySelected(GeometrySelectedEvent event) {
                    int id = event.getGeometryID();
                    Layer layer = event.getLayer();

                    WritableMap map = Arguments.createMap();
                    WritableMap layerInfo = Arguments.createMap();
                    layerInfo.putString("name", layer.getName());
                    layerInfo.putString("caption", layer.getCaption());
                    layerInfo.putBoolean("editable", layer.isEditable());
                    layerInfo.putBoolean("visible", layer.isVisible());
                    layerInfo.putBoolean("selectable", layer.isSelectable());
                    layerInfo.putInt("type", layer.getDataset().getType().value());
                    layerInfo.putString("path", SMLayer.getLayerPath(layer));

                    map.putMap("layerInfo", layerInfo);
                    map.putInt("id", id);

                    Selection selection = layer.getSelection();

                    Recordset recordset = selection.toRecordset();
                    recordset.moveFirst();

                    WritableArray fields = JsonUtil.getFieldInfos(recordset, null);
                    WritableArray fieldInfo = JsonUtil.parseRecordset(recordset, fields, null);
                    map.putArray("fieldInfo", fieldInfo);

                    SMap.getInstance().setSelection(layer.getSelection());

                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MAP_GEOMETRY_SELECTED, map);
                }

                @Override
                public void geometryMultiSelected(ArrayList<GeometrySelectedEvent> events) {
                    try {
                        String layerNames = "";
                        WritableArray array = Arguments.createArray();
                        for (int i = 0; i < events.size(); i++) {
                            GeometrySelectedEvent event = events.get(i);
                            Layer layer = event.getLayer();
                            String layerName = layer.getName();
                            if(layerNames.indexOf(layerName) > 0){
                                continue;
                            }
                            layerNames = layerNames.concat(","+layerName);

                            WritableMap map = Arguments.createMap();
                            WritableMap layerInfo = Arguments.createMap();
                            WritableArray ids = Arguments.createArray();

                            layerInfo.putString("name", layerName);
                            layerInfo.putString("caption", layer.getCaption());
                            layerInfo.putBoolean("editable", layer.isEditable());
                            layerInfo.putBoolean("visible", layer.isVisible());
                            layerInfo.putBoolean("selectable", layer.isSelectable());
                            layerInfo.putInt("type", layer.getDataset().getType().value());
                            layerInfo.putString("path", SMLayer.getLayerPath(layer));

                            Selection selection = layer.getSelection();
                            Recordset rs = selection.toRecordset();
                            rs.moveFirst();

                            while(!rs.isEOF()){
                                Object curId = rs.getFieldValue("SmID");
                                if(curId != null){
                                    int rsId = (int)curId;
                                    ids.pushInt(rsId);
                                }
                                rs.moveNext();
                            }

                            rs.dispose();
                            rs.close();

                            map.putMap("layerInfo",layerInfo);
                            map.putArray("ids",ids);

                            array.pushMap(map);
                        }

                        WritableMap geometries = Arguments.createMap();
                        geometries.putArray("geometries", array);
                        context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit(EventConst.MAP_GEOMETRY_MULTI_SELECTED, geometries);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }
            };
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.addGeometrySelectedListener(mGeometrySelectedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometrySelectedListener(Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.removeGeometrySelectedListener(mGeometrySelectedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 指定编辑几何对象
     *
     * @param geoID
     * @param layerName
     * @param promise
     */
    @ReactMethod
    public void appointEditGeometry(int geoID, String layerName, Promise promise) {
        try {
            sMap = getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            Layer layer = SMLayer.findLayerByPath(layerName);//mapControl.getMap().getLayers().get(layerName);
            boolean result = mapControl.appointEditGeometry(geoID, layer);
            layer.setEditable(true);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定SymbolGroup中所有的group
     *
     * @param type
     * @param path
     * @param promise
     */
    @ReactMethod
    public void getSymbolGroups(String type, String path, Promise promise) {
        try {
            sMap = getInstance();
            Resources resources = sMap.smMapWC.getWorkspace().getResources();
            WritableArray groups = SMSymbol.getSymbolGroups(resources, type, path);

            promise.resolve(groups);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定SymbolGroup中所有的symbol
     *
     * @param type
     * @param path
     * @param promise
     */
    @ReactMethod
    public void findSymbolsByGroups(String type, String path, Promise promise) {
        try {
            sMap = getInstance();
            Resources resources = sMap.smMapWC.getWorkspace().getResources();
            WritableArray symbols = SMSymbol.findSymbolsByGroups(resources, type, path);

            promise.resolve(symbols);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 导入工作空间
     *
     * @param wInfo
     * @param strFilePath
     * @param breplaceDatasource
     * @param promise
     */
    @ReactMethod
    public void importWorkspace(ReadableMap wInfo, String strFilePath, boolean breplaceDatasource, Promise promise) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    sMap = SMap.getInstance();
                    boolean result = sMap.smMapWC.importWorkspaceInfo(wInfo.toHashMap(), strFilePath, breplaceDatasource, true);
                    promise.resolve(result);
                } catch (Exception e) {
                    promise.reject(e);
                }
            }
        }).start();
    }

    /**
     * 导出工作空间
     *
     * @param arrMapNames
     * @param strFileName
     * @param isFileReplace
     * @param promise
     */
    @ReactMethod
    public void exportWorkspace(ReadableArray arrMapNames, String strFileName, boolean isFileReplace, ReadableMap extraMap, Promise promise) {
        try {

            sMap = getInstance();
            boolean result = sMap.smMapWC.exportMapNames(arrMapNames, strFileName, isFileReplace, extraMap);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    // mapName 地图名字（不含后缀）
    // ofModule 模块名（默认传空）
    // isPrivate 是否是用户数据
    // exportWorkspacePath 导出的工作空间绝对路径（含后缀）
    @ReactMethod
    public void exportWorkspaceByMap(String mapName, String exportWorkspacePath, ReadableMap mapParam, Promise promise) {
        try {
            sMap = getInstance();
            WritableMap param = Arguments.createMap();
            param.merge(mapParam);
            param.putBoolean("IsReplaceSymbol", true);
            boolean openResult = sMap.getSmMapWC().openMapName(mapName, sMap.getSmMapWC().getWorkspace(), param);
            boolean exportResult = false;
            if (openResult) {
                WritableArray array = Arguments.createArray();
                ((WritableArray) array).pushString(mapName);
                exportResult = sMap.getSmMapWC().exportMapNames(array, exportWorkspacePath, true, null);
                Maps maps = sMap.getSmMapWC().getWorkspace().getMaps();
                maps.clear();
                SMap.getInstance().getSmMapWC().getWorkspace().getResources().getMarkerLibrary().getRootGroup().getChildGroups().remove(mapName, false);
                SMap.getInstance().getSmMapWC().getWorkspace().getResources().getLineLibrary().getRootGroup().getChildGroups().remove(mapName, false);
                SMap.getInstance().getSmMapWC().getWorkspace().getResources().getFillLibrary().getRootGroup().getChildGroups().remove(mapName, false);
                sMap.getSmMapWC().getWorkspace().getDatasources().closeAll();
            }
            promise.resolve(exportResult);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取图层标题列表及对应的数据集类型
     *
     * @param promise
     */
    @ReactMethod
    public void getLayersNames(Promise promise) {
        try {
            sMap = getInstance();
            Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
            int count = layers.getCount();
            WritableArray arr = Arguments.createArray();
            for (int i = 0; i < count; i++) {
                //获取图层标题（区别于图层的名称）
                String caption = layers.get(i).getCaption();
                WritableMap writeMap = Arguments.createMap();

                //获取数据集类型
                DatasetType type = layers.get(i).getDataset().getType();
                String datasetType = "";
                if (type == DatasetType.POINT) {
                    datasetType = "POINT";
                } else if (type == DatasetType.LINE) {
                    datasetType = "LINE";
                } else if (type == DatasetType.REGION) {
                    datasetType = "REGION";
                } else if (type == DatasetType.GRID) {
                    datasetType = "GRID";
                } else if (type == DatasetType.TEXT) {
                    datasetType = "TEXT";
                } else if (type == DatasetType.IMAGE) {
                    datasetType = "IMAGE";
                } else {
                    datasetType = type.toString();
                }

                writeMap.putString("title", caption);
                writeMap.putString("datasetType", datasetType);
                arr.pushMap(writeMap);
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isModified(Promise promise) {
        try {
            sMap = getInstance();
            boolean bWorspaceModified = sMap.smMapWC.getWorkspace().isModified();
            boolean bMapModified = sMap.smMapWC.getMapControl().getMap().isModified();
            if (!bWorspaceModified && !bMapModified)
                promise.resolve(false);
            else
                promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMapName(Promise promise) {
        try {
            sMap = getInstance();
            String mapName = sMap.smMapWC.getMapControl().getMap().getName();
            promise.resolve(mapName);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 保存地图为XML
     */
    @ReactMethod
    public void saveMapToXML(String filePath, Promise promise) {
        try {
            sMap = getInstance();
            String mapName = filePath.substring(filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

            int count = sMap.smMapWC.getWorkspace().getMaps().getCount();
            for (int i = 0; i < count; i++) {
                String name = sMap.smMapWC.getWorkspace().getMaps().get(i);
                if (mapName.equals(name)) {
                    sMap.smMapWC.getMapControl().getMap().save();
                    break;
                }
                if (i == count - 1) {
                    sMap.smMapWC.getMapControl().getMap().saveAs(mapName);
                }
            }

            if (count == 0) {
                sMap.smMapWC.getMapControl().getMap().saveAs(mapName);
            }
            String mapXML = sMap.smMapWC.getMapControl().getMap().toXML();


            if (!mapXML.equals("")) {
                File file = new File(filePath);

                FileWriter fileWritter = new FileWriter(file);
                fileWritter.write(mapXML);
                fileWritter.close();
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 加载地图XML，显示地图
     *
     * @param
     */
    @ReactMethod
    public void openMapFromXML(String filePath, Promise promise) {
        try {
            sMap = getInstance();
            String mapName = filePath.substring(filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
            File file = new File(filePath);
            Reader reader = null;

            reader = new InputStreamReader(new FileInputStream(file));
            char[] buffer = new char[1024];
            int index = 0;
            String strXML = "";
            while ((index = reader.read(buffer)) != -1) {
                strXML += String.valueOf(buffer);
            }

            int count = sMap.smMapWC.getWorkspace().getMaps().getCount();
            for (int i = 0; i < count; i++) {
                String name = sMap.smMapWC.getWorkspace().getMaps().get(i);
                if (mapName.equals(name)) {
                    break;
                }
                if (i == count - 1) {
                    sMap.smMapWC.getWorkspace().getMaps().add(mapName, strXML);
                }
            }
            if (count == 0) {
                sMap.smMapWC.getWorkspace().getMaps().add(mapName, strXML);
            }
            sMap.smMapWC.getMapControl().getMap().open(mapName);
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图对应的数据源
     *
     * @param
     */
    @ReactMethod
    public void getMapDatasourcesAlias(Promise promise) {
        try {
            sMap = getInstance();
            Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
            int count = layers.getCount();

            String datasourceName = "";
            ArrayList<String> datasourceNamelist = new ArrayList<String>();
            WritableArray arr = Arguments.createArray();
            for (int i = 0; i < count; i++) {
                Dataset dataset = layers.get(i).getDataset();
                if (dataset != null) {
                    String dataSourceAlias = dataset.getDatasource().getAlias();

                    if (!datasourceNamelist.contains(dataSourceAlias)) {
                        datasourceNamelist.add(dataSourceAlias);

                        WritableMap writeMap = Arguments.createMap();
                        writeMap.putString("title", dataSourceAlias + ".udb");
                        arr.pushMap(writeMap);
                    }
                }

            }

//            datasourceName.substring( 2,datasourceName.length()-2 );
            promise.resolve(arr);

        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /**
     * 添加数据集到当前地图
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void addDatasetToMap(ReadableMap readableMap, Promise promise) {
        try {
            sMap = SMap.getInstance();
            HashMap<String, Object> data = readableMap.toHashMap();
            String datastourceName = null;
            String datasetName = null;

            if (data.containsKey("DatasourceName")) {
                datastourceName = data.get("DatasourceName").toString();
            }
            if (data.containsKey("DatasetName")) {
                datasetName = data.get("DatasetName").toString();
            }

            Workspace workspace = sMap.smMapWC.getWorkspace();
            if (datastourceName != null && datasetName != null) {
                Datasource datasource = workspace.getDatasources().get(datastourceName);
                Dataset dataset = datasource.getDatasets().get(datasetName);

                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                Layer layer = map.getLayers().add(dataset, true);
                if (dataset.getType() == DatasetType.REGION) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setLineSymbolID(5);
                }
                if (dataset.getType() == DatasetType.REGION || dataset.getType() == DatasetType.REGION3D) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setFillForeColor(getFillColor());
                    setting.getStyle().setLineColor(getLineColor());
                } else if (dataset.getType() == DatasetType.LINE || dataset.getType() == DatasetType.NETWORK || dataset.getType() == DatasetType.NETWORK3D
                        || dataset.getType() == DatasetType.LINE3D) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setLineColor(getLineColor());
                    if (dataset.getType() == DatasetType.NETWORK || dataset.getType() == DatasetType.NETWORK3D) {
                        map.getLayers().add(((DatasetVector) dataset).getChildDataset(), true);
                    }
                } else if (dataset.getType() == DatasetType.POINT || dataset.getType() == DatasetType.POINT3D) {
                    LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                    setting.getStyle().setLineColor(getLineColor());
                }

                map.setVisibleScalesEnabled(false);
                map.refresh();

                promise.resolve(layer != null);
            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 导出地图为xml
     *
     * @param name
     * @param nModule
     * @param addition
     * @param isNew
     * @param promise
     */
    @ReactMethod
    public void saveMapName(String name, String nModule, ReadableMap addition, boolean isNew, boolean bResourcesModified, boolean bPrivate, Promise promise) {
        try {
            sMap = SMap.getInstance();
            boolean mapSaved = false;
            boolean bNew = true;

            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            if (map.getName() != null && !map.getName().equals("")) {
                bNew = false;
            }

            String oldName = map.getName();

            if (name == null || name.equals("")) {
                if (map.getName() != null && !map.getName().equals("")) {
                    bNew = false;
                    mapSaved = map.save();
                    name = map.getName();
                } else if (map.getLayers().getCount() > 0) {
                    bNew = true;
                    Layers layers = map.getLayers();
                    Layer layer = layers.get(layers.getCount() - 1);
                    name = layer.getName();
                    int i = 0;
                    while (!mapSaved) {
                        name = i == 0 ? name : (name + i);
                        mapSaved = map.save(name);
                        i++;
                    }
                }
            } else {
                if (name.equals(map.getName())) {
                    bNew = false;
                    mapSaved = map.save();
                    name = map.getName();
                } else {
                    bNew = true;
                    mapSaved = isNew ? map.saveAs(name) : map.save(name);
                }
            }

//            boolean bResourcesModified = sMap.smMapWC.getWorkspace().getMaps().getCount() > 1;
            String mapName = "";

            Map<String, String> additionInfo = new HashMap<>();
            ReadableMapKeySetIterator keys = addition.keySetIterator();
            WritableMap writableMap = Arguments.createMap();
            boolean needFilter = false;
            if (addition.hasKey("filterLayers")) {
                needFilter = true;
                while (keys.hasNextKey()) {
                    String key = keys.nextKey();
                    if (key.equals("filterLayers")) {
                        WritableArray array = Arguments.createArray();
                        for (int i = 0; i < addition.getArray(key).size(); i++) {
                            array.pushString(addition.getArray(key).getString(i));
                        }
                        writableMap.putArray(key, array);
                    } else {
                        writableMap.putString(key, addition.getString(key));
                    }
                }
            } else {
                while (keys.hasNextKey()) {
                    String key = keys.nextKey();
                    additionInfo.put(key, addition.getString(key));
                }
            }

            if (mapSaved) {
                if (needFilter) {
                    mapName = sMap.smMapWC.saveMapName(name, sMap.smMapWC.getWorkspace(), nModule, writableMap, (isNew || bNew), bResourcesModified, bPrivate);
                } else {
                    mapName = sMap.smMapWC.saveMapName(name, sMap.smMapWC.getWorkspace(), nModule, additionInfo, (isNew || bNew), bResourcesModified, bPrivate);
                }

                //保存地图后拷贝推演动画xml文件
                if (mapName != null) {
                    String strUserName = null;
                    if (!bPrivate) {
                        strUserName = "Customer";
                    } else {
                        strUserName = SMap.getInstance().smMapWC.getUserName();
                    }
                    String strRootPath = homeDirectory + "/iTablet/User/";
                    String strAnimationPath = strRootPath + strUserName + "/Data/Animation/";
                    String fromPath = strAnimationPath + oldName;
                    String toPath = strAnimationPath + mapName + "/";
                    if ((new File(fromPath)).exists()) {
                        SMap.getInstance().smMapWC.copyAnimationFile(fromPath, toPath, mapName);
                    }
                }
            }

            Maps maps = sMap.getSmMapWC().getWorkspace().getMaps();
            // isNew为true，另存为后不操作另存地图 原地图保持当前状态
            //boolean isOpen = false;
            if (oldName != null && !oldName.equals("") && !oldName.equals(mapName) && isNew) {
                if (maps.indexOf(mapName) >= 0) {
                    maps.remove(mapName);
                }
//                if (maps.indexOf(mapName) >= 0) {
//                    isOpen = map.open(mapName);
//                } else {
//                    map.saveAs(mapName);
//                }
//                if (isOpen && maps.indexOf(oldName) >= 0) {
//                    maps.remove(oldName);
//                }
            }

            map.refresh();
            promise.resolve(mapName);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 导入文件工作空间到程序目录
     *
     * @param infoMap
     * @param nModule
     * @param promise
     */
    @ReactMethod
    public void importWorkspaceInfo(ReadableMap infoMap, String nModule, boolean bPrivate, Promise promise) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    sMap = SMap.getInstance();
                    List<String> list = sMap.smMapWC.importWorkspaceInfo(infoMap.toHashMap(), nModule, bPrivate);
                    WritableArray mapsInfo = Arguments.createArray();
                    if (list == null) {
                        promise.resolve(mapsInfo);
                    } else {
                        if (list.size() > 0) {
                            for (int i = 0; i < list.size(); i++) {
                                mapsInfo.pushString(list.get(i));
                            }
                        }
                        promise.resolve(mapsInfo);
                    }
                } catch (Exception e) {
                    promise.reject(e);
                }
            }
        }).start();
    }

    /**
     * 导入数据源到程序目录
     *
     * @param strFile
     * @param strModule
     * @param promise
     */
    @ReactMethod
    public void importDatasourceFile(String strFile, String strModule, Promise promise) {
        try {
//            sMap = SMap.getInstance();
//            DatasourceConnectionInfo datasourceConnectionInfo = new DatasourceConnectionInfo();
//            datasourceConnectionInfo.setServer(strFile);
//            datasourceConnectionInfo.setEngineType(EngineType.UDB);
//            Datasource datasource = sMap.smMapWC.getWorkspace().getDatasources().open(datasourceConnectionInfo);
//            if(datasource.getDescription().equals("Label")){
//                String todatasource=rootPath+"/iTablet/User/"+sMap.smMapWC.getUserName()+"/Data/Label/Label.udb";
//                File udb=new File(todatasource);
//                if(udb.exists()){
//                    sMap.getSmMapWC().copyDataset(strFile,todatasource);
//                }
//            }else {
//                String result = sMap.smMapWC.importDatasourceFile(strFile, strModule);
//                promise.resolve(result);
//            }
//            datasourceConnectionInfo.dispose();
            String result = sMap.smMapWC.importDatasourceFile(strFile, strModule);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 大工作空间打开本地地图
     *
     * @param strMapName
     * @param promise
     */
    @ReactMethod
    public void openMapName(String strMapName, ReadableMap mapParam, Promise promise) {
        try {
            sMap = SMap.getInstance();
            boolean result = sMap.smMapWC.openMapName(strMapName, sMap.smMapWC.getWorkspace(), mapParam);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图反走样
     *
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setAntialias(boolean value, Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.getSmMapWC().getMapControl().getMap();
            map.setAntialias(value);
            map.refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取是否反走样
     *
     * @param promise
     */
    @ReactMethod
    public void isAntialias(Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.getSmMapWC().getMapControl().getMap();
            boolean result = map.isAntialias();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置固定比例尺
     *
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setVisibleScalesEnabled(boolean value, Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.getSmMapWC().getMapControl().getMap();
            map.setVisibleScalesEnabled(value);
            map.refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取是否固定比例尺
     *
     * @param promise
     */
    @ReactMethod
    public void isVisibleScalesEnabled(Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.getSmMapWC().getMapControl().getMap();
            boolean result = map.isVisibleScalesEnabled();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 检查是否有打开的地图
     *
     * @param promise
     */
    @ReactMethod
    public void isAnyMapOpened(Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            int count = map.getLayers().getCount();
            boolean isAny = true;
            if (count <= 0) {
                isAny = false;
            }

            promise.resolve(isAny);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 把指定地图中的图层添加到当前打开地图中
     *
     * @param srcMapName 要添加的地图
     * @param promise
     */
    @ReactMethod
    public void addMap(String srcMapName, ReadableMap mapParam, Promise promise) {
        try {
            sMap = getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();

            sMap.smMapWC.getMapControl().getEditHistory().addMapHistory();
            boolean result = sMap.smMapWC.addLayersFromMap(srcMapName, map, mapParam);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 批量添加图层
     *
     * @param datasetNames
     * @param promise
     */
    @ReactMethod
    public void addLayers(ReadableArray datasetNames, String datastourceName, Promise promise) {
        try {
            if (datasetNames == null || datasetNames.size() == 0 || datastourceName == null || datastourceName.isEmpty()) {
                promise.resolve(false);
                return;
            }

            Workspace workspace = sMap.smMapWC.getWorkspace();
            Datasource datasource = workspace.getDatasources().get(datastourceName);
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            Layers layers = map.getLayers();

            ArrayList<Dataset> datasets_point = new ArrayList<>();
            ArrayList<Dataset> datasets_line = new ArrayList<>();
            ArrayList<Dataset> datasets_region = new ArrayList<>();
            ArrayList<Dataset> datasets_text = new ArrayList<>();
            ArrayList<Dataset> datasets_else = new ArrayList<>();
            for (int i = 0; i < datasetNames.size(); i++) {
                String datasetName = datasetNames.getString(i);
                Dataset dataset = datasource.getDatasets().get(datasetName);


                if (dataset.getType() == DatasetType.REGION || dataset.getType() == DatasetType.REGION3D) {
                    datasets_region.add(dataset);
                } else if (dataset.getType() == DatasetType.LINE || dataset.getType() == DatasetType.NETWORK || dataset.getType() == DatasetType.NETWORK3D
                        || dataset.getType() == DatasetType.LINE3D) {
                    datasets_line.add(dataset);
                } else if (dataset.getType() == DatasetType.POINT || dataset.getType() == DatasetType.POINT3D) {
                    datasets_point.add(dataset);
                } else if (dataset.getType() == DatasetType.TEXT) {
                    datasets_text.add(dataset);
                } else {
                    datasets_else.add(dataset);
                }
            }

            ArrayList<Dataset> datasets = new ArrayList<>();
            datasets.addAll(datasets_else);
            datasets.addAll(datasets_region);
            datasets.addAll(datasets_line);
            datasets.addAll(datasets_point);
            datasets.addAll(datasets_text);

            WritableArray resultArr = Arguments.createArray();

            if (datasets.size() > 0) {
                MapControl mapControl = SMap.getSMWorkspace().getMapControl();
                mapControl.getEditHistory().addMapHistory();

                for (int i = 0; i < datasets.size(); i++) {
                    Dataset dataset = datasets.get(i);

                    Layer layer = layers.add(dataset, true);
                    if (dataset.getType() == DatasetType.REGION) {
                        LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                        setting.getStyle().setLineSymbolID(5);
                    }
                    if (dataset.getType() == DatasetType.REGION || dataset.getType() == DatasetType.REGION3D) {
                        LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                        setting.getStyle().setFillForeColor(getFillColor());
                        setting.getStyle().setLineColor(getLineColor());
                    } else if (dataset.getType() == DatasetType.LINE || dataset.getType() == DatasetType.NETWORK || dataset.getType() == DatasetType.NETWORK3D
                            || dataset.getType() == DatasetType.LINE3D) {
                        LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                        setting.getStyle().setLineColor(getLineColor());
                        if (dataset.getType() == DatasetType.NETWORK || dataset.getType() == DatasetType.NETWORK3D) {
                            map.getLayers().add(((DatasetVector) dataset).getChildDataset(), true);
                        }
                    } else if (dataset.getType() == DatasetType.POINT || dataset.getType() == DatasetType.POINT3D) {
                        LayerSettingVector setting = (LayerSettingVector) layer.getAdditionalSetting();
                        setting.getStyle().setLineColor(getLineColor());
                    }

                    if (layer != null) {
                        WritableMap layerInfo = Arguments.createMap();
                        layerInfo.putString("layerName", layer.getName());
                        layerInfo.putString("datasetName", layer.getDataset().getName());
                        layerInfo.putInt("datasetType", layer.getDataset().getType().value());
                        layerInfo.putString("description", layer.getDataset().getDescription());

                        resultArr.pushMap(layerInfo);
                    }
                }
                map.setVisibleScalesEnabled(false);
                map.refresh();
            }

            promise.resolve(resultArr);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 导入符号库
     *
     * @param path
     * @param isReplace 是否替换
     * @param promise
     */
    @ReactMethod
    public void importSymbolLibrary(String path, boolean isReplace, Promise promise) {
        try {
            sMap = SMap.getInstance();
            boolean result = sMap.smMapWC.appendFromFile(SMap.getInstance().smMapWC.getWorkspace().getResources(), path, isReplace);

            promise.resolve(result);
        } catch (Exception e) {
            Log.e(REACT_CLASS, e.getMessage());
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 设置是否压盖
     *
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setOverlapDisplayed(boolean value, Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.getSmMapWC().getMapControl().getMap();
            map.setOverlapDisplayed(value);
            map.refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 是否已经开启压盖
     *
     * @param promise
     */
    @ReactMethod
    public void isOverlapDisplayed(Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.getSmMapWC().getMapControl().getMap();
            boolean result = map.isOverlapDisplayed();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMapsByFile(String path, Promise promise) {
        try {
            WorkspaceType type = null;
            if (path.contains("sxwu")) {
                type = WorkspaceType.SXWU;
            } else if (path.contains("smwu")) {
                type = WorkspaceType.SMWU;
            } else if (path.contains("sxw")) {
                type = WorkspaceType.SXW;
            } else if (path.contains("smw")) {
                type = WorkspaceType.SMW;
            }
            Workspace workspace = new Workspace();
            WorkspaceConnectionInfo wsInfo = new WorkspaceConnectionInfo();
            wsInfo.setServer(path);
            wsInfo.setType(type);
            boolean result = workspace.open(wsInfo);
            WritableArray arr = Arguments.createArray();
            if (result) {
                for (int i = 0; i < workspace.getMaps().getCount(); i++) {
                    arr.pushString(workspace.getMaps().get(i));
                }
            }

            workspace.close();
            wsInfo.dispose();
            workspace.dispose();

            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 显示全幅
     *
     * @param promise
     */
    @ReactMethod
    public void viewEntire(Promise promise) {

        try {
            sMap = SMap.getInstance();
            Rectangle2D bounds = null;
            for(int i=0;i<sMap.getSmMapWC().getMapControl().getMap().getLayers().getCount();i++){
                Layer layer = sMap.getSmMapWC().getMapControl().getMap().getLayers().get(i);
                if( (!(layer instanceof  LayerGroup) && layer.getDataset().getDatasource().getConnectionInfo().getEngineType() != EngineType.UDB) || !layer.isVisible() ){
                    continue;
                }
                Rectangle2D boundsTmp = null;
                if (layer instanceof  LayerGroup){
                    boundsTmp = getLayerGroupBounds((LayerGroup)layer);
                }else{
                    boundsTmp = getLayerBounds(layer);
                }

                if (boundsTmp == null) continue;

                if(bounds == null){
                    bounds = new Rectangle2D(boundsTmp);
                }else{
                    bounds.union(boundsTmp);
                }
            }

            if(bounds == null){
                sMap.getSmMapWC().getMapControl().getMap().viewEntire();
            }else{
                if (!(bounds.getWidth() == 0 && bounds.getHeight() == 0 && bounds.getCenter().getY() == 0 && bounds.getCenter().getX() == 0)) {
                    if (bounds.getWidth() <= 0 || bounds.getHeight() <= 0) {
                        sMap.getSmMapWC().getMapControl().getMap().setCenter(bounds.getCenter());
                    } else {
                        sMap.getSmMapWC().getMapControl().getMap().setViewBounds(bounds);
                    }
                }
            }



            Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    sMap.getSmMapWC().getMapControl().zoomTo(sMap.getSmMapWC().getMapControl().getMap().getScale() * 0.6, 100);
                }
            }, 100);//3秒后执行Runnable中的run方法

            sMap.getSmMapWC().getMapControl().getMap().refresh();

            promise.resolve(true);
        }catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 开启动态投影
     *
     * @param promise
     */
    @ReactMethod
    public void setDynamicProjection(Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.getSmMapWC().getMapControl().getMap();
            map.setDynamicProjection(true);
            map.refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    // 添加指定字段到数据集
    private void addFieldInfo(DatasetVector dv, String name, FieldType type, boolean required, String value, int maxLength) {
        FieldInfos infos = dv.getFieldInfos();
        if (infos.indexOf(name) != -1) {//exists
            infos.remove(name);
        }
        FieldInfo newInfo = new FieldInfo();
        newInfo.setName(name);
        newInfo.setType(type);
        newInfo.setMaxLength(maxLength);
        newInfo.setDefaultValue(value);
        newInfo.setRequired(required);
        infos.add(newInfo);
    }

    /**
     * 新建标注数据集
     *
     * @param promise
     */
    @ReactMethod
    public void newTaggingDataset(String name, String userpath, boolean editable, String type, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");
//            sMap.smMapWC.getWorkspace().getConnectionInfo().getServer();
            String datasetName = "";
            Layer layer = null;
            if (opendatasource == null) {
                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias("Label_" + userpath + "#");
                info.setEngineType(EngineType.UDB);
                info.setServer(rootPath + "/iTablet/User/" + userpath + "/Data/Datasource/Label_" + userpath + "#.udb");
                Datasource datasource = workspace.getDatasources().open(info);
                if (datasource != null) {
                    Datasets datasets = datasource.getDatasets();
                    datasetName = datasets.getAvailableDatasetName(name);
                    DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
                    datasetVectorInfo.setType(DatasetType.CAD);
                    datasetVectorInfo.setEncodeType(EncodeType.NONE);
                    datasetVectorInfo.setName(datasetName);
                    DatasetVector datasetVector = datasets.create(datasetVectorInfo);
                    datasetVector.setPrjCoordSys(sMap.getSmMapWC().getMapControl().getMap().getPrjCoordSys());

                    //创建数据集时创建好字段
                    addFieldInfo(datasetVector, "name", FieldType.TEXT, false, "", 255);
                    addFieldInfo(datasetVector, "remark", FieldType.TEXT, false, "", 255);
                    addFieldInfo(datasetVector, "address", FieldType.TEXT, false, "", 255);

                    Dataset ds = datasets.get(datasetName);
                    ds.setDescription("{\"type\":\"" + type + "\"}");
                    com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                    layer = map.getLayers().add(ds, true);
                    layer.setSnapable(editable);
                    layer.setSnapable(false);
                    datasetVectorInfo.dispose();
                    datasetVector.close();
                    info.dispose();
                }
            } else {
                Datasets datasets = opendatasource.getDatasets();
                datasetName = datasets.getAvailableDatasetName(name);
                DatasetVectorInfo datasetVectorInfo = new DatasetVectorInfo();
                datasetVectorInfo.setType(DatasetType.CAD);
                datasetVectorInfo.setEncodeType(EncodeType.NONE);
                datasetVectorInfo.setName(datasetName);
                DatasetVector datasetVector = datasets.create(datasetVectorInfo);
                datasetVector.setPrjCoordSys(sMap.getSmMapWC().getMapControl().getMap().getPrjCoordSys());
                //创建数据集时创建好字段
                addFieldInfo(datasetVector, "name", FieldType.TEXT, false, "", 255);
                addFieldInfo(datasetVector, "remark", FieldType.TEXT, false, "", 255);
                addFieldInfo(datasetVector, "address", FieldType.TEXT, false, "", 255);

                Dataset ds = datasets.get(datasetName);
                ds.setDescription("{\"type\":\"" + type + "\"}");
                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                layer = map.getLayers().add(ds, true);
                layer.setEditable(editable);
                layer.setSnapable(editable);
                datasetVectorInfo.dispose();
                datasetVector.close();
            }
            WritableMap map = Arguments.createMap();
            map.putString("datasetName", datasetName);
            map.putString("layerName", layer != null ? layer.getName() : "");
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 删除标注数据集
     *
     * @param promise
     */
    @ReactMethod
    public void removeTaggingDataset(String name, String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");
            if (opendatasource == null) {
                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias("Label_" + userpath + "#");
                info.setEngineType(EngineType.UDB);
                info.setServer(rootPath + "/iTablet/User/" + userpath + "/Data/Datasource/Label_" + userpath + "#.udb");
                Datasource datasource = workspace.getDatasources().open(info);
                if (datasource != null) {
                    Datasets datasets = datasource.getDatasets();
                    datasets.delete(name);
                }
                promise.resolve(true);
            } else {
                Datasets datasets = opendatasource.getDatasets();
                datasets.delete(name);
                promise.resolve(true);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 导入标注数据集
     *
     * @param promise
     */
    @ReactMethod
    public void openTaggingDataset(String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");
            if (opendatasource == null) {

                String lableUDB = rootPath + "/iTablet/User/" + userpath + "/Data/Datasource/Label_" + userpath + "#.udb";

                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias("Label_" + userpath + "#");
                info.setEngineType(EngineType.UDB);
                info.setServer(lableUDB);

                Datasource datasource = null;
                File file = new File(lableUDB);
                if (!file.exists()) {
                    datasource = workspace.getDatasources().create(info);
                } else {
                    datasource = workspace.getDatasources().open(info);
                }

                if (datasource != null) {
                    Datasets datasets = datasource.getDatasets();
                    com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                    for (int i = 0; i < datasets.getCount(); i++) {
                        Dataset ds = datasets.get(i);
                        String addname = ds.getName() + "@Label_" + userpath + "#";
                        boolean add = true;
                        Layers maplayers = map.getLayers();
                        for (int j = 0; j < maplayers.getCount(); j++) {
                            if (maplayers.get(j).getCaption().equals(addname)) {
                                add = false;
                            }
                        }
                        if (add) {
                            Layer layer = map.getLayers().add(ds, true);
                            layer.setEditable(false);
                            layer.setVisible(false);
                        }
                    }
                }

            } else {
                Datasets datasets = opendatasource.getDatasets();
                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                for (int i = 0; i < datasets.getCount(); i++) {
                    Dataset ds = datasets.get(i);
                    String addname = ds.getName() + "@Label_" + userpath + "#";
                    boolean add = true;
                    Layers maplayers = map.getLayers();
                    for (int j = 0; j < maplayers.getCount(); j++) {
                        if (maplayers.get(j).getCaption().equals(addname)) {
                            add = false;
                        }
                    }
                    if (add) {
                        Layer layer = map.getLayers().add(ds, true);
                        layer.setEditable(false);
                        layer.setVisible(false);
                    }
                }

            }
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取默认标注
     *
     * @param promise
     */
    @ReactMethod
    public void getDefaultTaggingDataset(String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");
            if (opendatasource != null) {
                String datasetname = "";
                Datasets datasets = opendatasource.getDatasets();
                Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
                boolean isEditable = false;
                for (int i = 0; i < layers.getCount(); i++) {
                    if (!isEditable) {
                        Layer layer = layers.get(i);
                        for (int j = 0; j < datasets.getCount(); j++) {
                            Dataset dataset = datasets.get(j);
                            if (layer.getDataset() == dataset) {
                                if (layer.isEditable()) {
                                    isEditable = true;
                                    datasetname = dataset.getName();
                                    break;
                                }
                            }
                        }
                    }
                }
                promise.resolve(datasetname);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 判断是否有标注图层
     *
     * @param promise
     */
    @ReactMethod
    public void isTaggingLayer(String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");
            if (opendatasource != null) {
                Datasets datasets = opendatasource.getDatasets();
                Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
                boolean isEditable = false;
                for (int i = 0; i < layers.getCount(); i++) {
                    if (!isEditable) {
                        Layer layer = layers.get(i);
                        for (int j = 0; j < datasets.getCount(); j++) {
                            Dataset dataset = datasets.get(j);
                            if (layer.getDataset() == dataset) {
                                if (layer.isEditable()) {
                                    isEditable = true;
                                    break;
                                }
                            }
                        }
                        if (isEditable) break;
                    }
                }
                promise.resolve(isEditable);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 判断是否有标注图层，并获取当前标注图层信息
     *
     * @param promise
     */
    @ReactMethod
    public void getCurrentTaggingLayer(String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");

            WritableMap map = Arguments.createMap();

            boolean isEditable = false;
            if (opendatasource != null) {
                Datasets datasets = opendatasource.getDatasets();
                Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();

                Layer layer = null;
                for (int i = 0; i < layers.getCount(); i++) {
                    layer = layers.get(i);
                    for (int j = 0; j < datasets.getCount(); j++) {
                        Dataset dataset = datasets.get(j);
                        if (layer.getDataset() == dataset) {
                            if (layer.isEditable()) {
                                isEditable = true;
                                break;
                            }
                        }
                    }
                    if (isEditable) break;
                }
                map.putBoolean("isTaggingLayer", isEditable);
                if (isEditable) {
                    WritableMap layerInfo = Arguments.createMap();
                    layerInfo.putBoolean("isEditable", isEditable);
                    layerInfo.putBoolean("isVisible", layer.isVisible());
                    layerInfo.putString("name", layer.getName());
                    layerInfo.putString("datasetName", layer.getDataset().getName());
                    layerInfo.putString("description", layer.getDescription());
                    layerInfo.putString("datasetDescription", layer.getDataset().getDescription());

                    map.putMap("layerInfo", layerInfo);
                }
            } else {
                map.putBoolean("isTaggingLayer", isEditable);
            }
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注图层个数
     *
     * @param promise
     */
    @ReactMethod
    public void getTaggingLayerCount(String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");
            if (opendatasource != null) {
                Datasets datasets = opendatasource.getDatasets();
                int count = datasets.getCount();
                promise.resolve(count);
            } else {
                promise.resolve(0);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取当前标注
     *
     * @param promise
     */
    @ReactMethod
    public void getCurrentTaggingDataset(String name, Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            String datasetname = "";
            Layer layer = map.getLayers().get(name);
            layer.setVisible(true);
            layer.setEditable(true);
            map.refresh();
            datasetname = layer.getDataset().getName();
            promise.resolve(datasetname);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取标注图层
     *
     * @param promise
     */
    @ReactMethod
    public void getTaggingLayers(String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get("Label_" + userpath + "#");
            WritableArray arr = Arguments.createArray();
            if (opendatasource == null) {
                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias("Label_" + userpath + "#");
                info.setEngineType(EngineType.UDB);
                info.setServer(rootPath + "/iTablet/User/" + userpath + "/Data/Datasource/Label_" + userpath + "#.udb");
                Datasource datasource = workspace.getDatasources().open(info);

                if (datasource != null) {
                    Datasets datasets = datasource.getDatasets();
                    com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                    Layers layers = map.getLayers();

                    for (int i = 0; i < datasets.getCount(); i++) {
                        Dataset ds = datasets.get(i);
                        for (int j = 0; j < layers.getCount(); j++) {
                            Layer layer = layers.get(j);
                            if (layer.getDataset() == ds) {
                                WritableMap writeMap = SMLayer.getLayerInfo(layer, "");
                                arr.pushMap(writeMap);
                            }
                        }
                    }
                }
            } else {
                Datasets datasets = opendatasource.getDatasets();
                com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
                Layers layers = map.getLayers();

                for (int i = 0; i < datasets.getCount(); i++) {
                    Dataset ds = datasets.get(i);
                    for (int j = 0; j < layers.getCount(); j++) {
                        Layer layer = layers.get(j);
                        if (layer.getDataset() == ds) {
                            WritableMap writeMap = SMLayer.getLayerInfo(layer, "");
                            arr.pushMap(writeMap);
                        }
                    }
                }
            }
            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加数据集属性字段
     *
     * @param promise
     */
    @ReactMethod
    public void addRecordset(String datasourceName, String datasetName, String filedInfoName, String value, String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get(datasourceName);
            if (opendatasource == null) {
                DatasourceConnectionInfo info = new DatasourceConnectionInfo();
                info.setAlias(datasourceName);
                info.setEngineType(EngineType.UDB);
                info.setServer(rootPath + "/iTablet/User/" + userpath + "/Data/Datasource/" + datasourceName + ".udb");
                Datasource datasource = workspace.getDatasources().open(info);
                if (datasource != null) {
                    Datasets datasets = datasource.getDatasets();
                    DatasetVector dataset = (DatasetVector) datasets.get(datasetName);
                    modifyLastAttribute(dataset, filedInfoName, value);
                }
                sMap.smMapWC.getMapControl().getMap().refresh();
                promise.resolve(true);
            } else {
                Datasets datasets = opendatasource.getDatasets();
                DatasetVector dataset = (DatasetVector) datasets.get(datasetName);
                modifyLastAttribute(dataset, filedInfoName, value);
                sMap.smMapWC.getMapControl().getMap().refresh();
                promise.resolve(true);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    // 修改最新的属性值
    private void modifyLastAttribute(Dataset dataset, String filedInfoName, String value) {
        if (dataset == null) {
            return;
        }
        if (filedInfoName == null) {
            return;
        }
        if (value == null || value.isEmpty()) {
            return;
        }

        DatasetVector dtVector = (DatasetVector) dataset;
        Recordset recordset = dtVector.getRecordset(false, CursorType.DYNAMIC);
        if (recordset == null) {
            return;
        }
        recordset.moveLast();
        recordset.edit();

        //the dataset didn't have '' fieldinfo
        FieldInfos fieldInfos = recordset.getFieldInfos();
        if (fieldInfos.indexOf(filedInfoName) == -1) {
            return;
        }
        recordset.setFieldValue(filedInfoName, value);

        recordset.update();
        recordset.close();
        recordset.dispose();
    }

    private Rectangle2D getLayerGroupBounds(LayerGroup layer){
        Rectangle2D bounds = null;
        for(int i=0;i<layer.getCount();i++){
            Layer tmpLayer = layer.get(i);
            if(!tmpLayer.isVisible()){
                continue;
            }
            if (LayerGroup.class.isInstance(tmpLayer)){
                try {
                    bounds = getLayerGroupBounds((LayerGroup)tmpLayer);
                }catch (Exception e){
                   continue;
                }

            }else{
                Rectangle2D tmpBounds = getLayerBounds(tmpLayer);

                if (tmpBounds == null || tmpBounds.getWidth() == 0 && tmpBounds.getHeight() == 0 &&
                        tmpBounds.getCenter().getY() == 0 && tmpBounds.getCenter().getX() == 0) {
                    continue;
                }
                if(bounds == null){
                    bounds = new Rectangle2D(tmpBounds);
                }else{
                    bounds.union(tmpBounds);
                }
            }
        }

        return bounds;
    }
    private Rectangle2D getLayerBounds(Layer layer){
        sMap = SMap.getInstance();
        Rectangle2D bounds = null;
        if (DatasetVector.class.isInstance(layer.getDataset())) {
            Recordset recordset = ((DatasetVector)layer.getDataset()).getRecordset(false, CursorType.STATIC);
            if (recordset.getRecordCount() <= 0) {
                recordset.dispose();
                return null;
            } else {
                recordset.dispose();
            }
            bounds = ((DatasetVector)layer.getDataset()).computeBounds();
        } else {
            bounds = layer.getDataset().getBounds();
        }

        if (bounds != null && !safeGetType(layer.getDataset().getPrjCoordSys(), sMap.smMapWC.getMapControl().getMap().getPrjCoordSys())) {
            Point2Ds point2Ds = new Point2Ds();
            point2Ds.add(new Point2D(bounds.getLeft(), bounds.getTop()));
            point2Ds.add(new Point2D(bounds.getRight(), bounds.getBottom()));
            PrjCoordSys prjCoordSys = new PrjCoordSys();
            prjCoordSys.setType(layer.getDataset().getPrjCoordSys().getType());
            CoordSysTransParameter parameter = new CoordSysTransParameter();

            CoordSysTranslator.convert(point2Ds, prjCoordSys, sMap.smMapWC.getMapControl().getMap().getPrjCoordSys(), parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
            Point2D pt1 = point2Ds.getItem(0);
            Point2D pt2 = point2Ds.getItem(1);

            bounds = new Rectangle2D(pt1.getX(), pt2.getY(), pt2.getX(), pt1.getY());
        }

        return bounds;
    }
    /**
     * 设置当前图层全副
     *
     * @param promise
     */
    @ReactMethod
    public void setLayerFullView(String name, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(name);

            Rectangle2D bounds = null;
            if (layer instanceof  LayerGroup){
                bounds = getLayerGroupBounds((LayerGroup)layer);
            }else{
                bounds = getLayerBounds(layer);
            }

            if (bounds.getWidth() == 0 && bounds.getHeight() == 0 && bounds.getCenter().getY() == 0 && bounds.getCenter().getX() == 0) {
                promise.resolve(true);
            } else {
                if (bounds.getWidth() <= 0 || bounds.getHeight() <= 0) {
                    sMap.getSmMapWC().getMapControl().getMap().setCenter(bounds.getCenter());
                } else {
                    sMap.getSmMapWC().getMapControl().getMap().setViewBounds(bounds);
                    Handler handler = new Handler();
                    handler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            sMap.getSmMapWC().getMapControl().zoomTo(sMap.getSmMapWC().getMapControl().getMap().getScale() * 0.6, 100);
                        }
                    }, 100);//3秒后执行Runnable中的run方法
                }

                sMap.getSmMapWC().getMapControl().getMap().refresh();

                promise.resolve(true);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取最小可见比例尺范围
     *
     * @param promise
     */
    @ReactMethod
    public void getMinVisibleScale(String name, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(name);
            double scale = layer.getMinVisibleScale();
            if (scale != 0) {
                scale = 1 / scale;
            }
            promise.resolve(scale);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取最大可见比例尺范围
     *
     * @param promise
     */
    @ReactMethod
    public void getMaxVisibleScale(String name, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(name);
            double scale = layer.getMaxVisibleScale();
            if (scale != 0) {
                scale = 1 / scale;
            }
            promise.resolve(scale);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置最小比例尺范围
     *
     * @param promise
     */
    @ReactMethod
    public void setMinVisibleScale(String name, double number, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(name);
            double scale = number;
            if (number != 0) {
                scale = 1 / number;
            }
            layer.setMinVisibleScale(scale);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置最小比例尺范围
     *
     * @param promise
     */
    @ReactMethod
    public void setMaxVisibleScale(String name, double number, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Layer layer = SMLayer.findLayerByPath(name);//sMap.getSmMapWC().getMapControl().getMap().getLayers().get(name);
            double scale = number;
            if (number != 0) {
                scale = 1 / number;
            }
            layer.setMaxVisibleScale(scale);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加文字标注
     *
     * @param promise
     */
    @ReactMethod
    public void addTextRecordset(String datasourceName, String datasetName, String name, int x, int y, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Point2D p = sMap.smMapWC.getMapControl().getMap().pixelToMap(new Point(x, y));
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            Datasource opendatasource = workspace.getDatasources().get(datasourceName);
            Datasets datasets = opendatasource.getDatasets();
            DatasetVector dataset = (DatasetVector) datasets.get(datasetName);
            if (dataset != null) {
                dataset.setReadOnly(false);
            }
            Recordset recordset = dataset.getRecordset(false, CursorType.DYNAMIC);
            TextPart textPart = new TextPart();
            textPart.setAnchorPoint(p);
            textPart.setText(name);
            GeoText geoText = new GeoText();
            geoText.addPart(textPart);
            recordset.addNew(geoText);
            recordset.update();
            int id[] = new int[1];
            id[0] = recordset.getID();
            recordset.close();
            geoText.dispose();
            recordset.dispose();
            Recordset recordset1 = dataset.query(id, CursorType.DYNAMIC);
            sMap.smMapWC.getMapControl().getEditHistory().batchBegin();
            sMap.smMapWC.getMapControl().getEditHistory().addHistoryType(EditHistoryType.ADDNEW, recordset1, true);
            sMap.smMapWC.getMapControl().getEditHistory().batchEnd();
            recordset1.close();
            recordset1.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取点击坐标
     *
     * @param promise
     */
    @ReactMethod
    public void getGestureDetector(final Promise promise) {
        try {
            sMap = SMap.getInstance();
            final float[] x = new float[1];
            final float[] y = new float[1];
            sMap.smMapWC.getMapControl().setGestureDetector(new GestureDetector(context, new GestureDetector.OnGestureListener() {
                @Override
                public boolean onDown(MotionEvent e) {
                    return false;
                }

                @Override
                public void onShowPress(MotionEvent e) {

                }

                @Override
                public boolean onSingleTapUp(MotionEvent e) {
                    x[0] = e.getX();
                    y[0] = e.getY();
                    WritableMap writeMap = Arguments.createMap();
                    writeMap.putDouble("x", x[0]);
                    writeMap.putDouble("y", y[0]);
                    promise.resolve(writeMap);
                    sMap.smMapWC.getMapControl().deleteGestureDetector();

                    return true;
                }

                @Override
                public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
                    return false;
                }

                @Override
                public void onLongPress(MotionEvent e) {

                }

                @Override
                public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
                    return false;
                }
            }));
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    private GeometryAddedListener delegate = null;

    /**
     * 设置标注面随机色
     *
     * @param promise
     */
    @ReactMethod
    public void setTaggingGrid(String name, String userpath, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            Workspace workspace = sMap.smMapWC.getMapControl().getMap().getWorkspace();
            if (delegate == null) {
                delegate = new GeometryAddedListener() {
                    @Override
                    public void geometryAdded(GeometryEvent event) {
                        //判断是否是标绘图层
                        if(event.getLayer().getName().startsWith("PlotEdit_")){
                            delegate = null;
                            return;
                        }
                        int id[] = new int[1];
                        id[0] = event.getID();
                        DatasetVector dataset = (DatasetVector) event.getLayer().getDataset();
                        Recordset recordset = dataset.query(id, CursorType.DYNAMIC);
                        if (recordset != null) {
                            recordset.moveFirst();
                            recordset.edit();
                            Geometry geometry = recordset.getGeometry();
                            if (geometry != null) {

                                GeoStyle geoStyle = new GeoStyle();
                                geoStyle.setFillForeColor(SMap.getFillColor());
                                geoStyle.setFillBackColor(SMap.getFillColor());
                                geoStyle.setMarkerSize(new Size2D(10, 10));
                                geoStyle.setLineColor(new Color(80, 80, 80));
                                geoStyle.setFillOpaqueRate(50);//加透明度更美观
                                geometry.setStyle(geoStyle);
                                recordset.setGeometry(geometry);
                                recordset.update();
                            }
                            geometry.dispose();
                            recordset.dispose();
                        }
                        sMap.smMapWC.getMapControl().removeGeometryAddedListener(delegate);
                        delegate = null;
                    }
                };
            }
            mapControl.addGeometryAddedListener(delegate);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注集合对象symbolID
     */
    @ReactMethod
    public void setTaggingSymbolID(int symbolID, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();
            GeometryType geometryType = geometry.getType();

            if(geometryType == GeometryType.GEOPOINT) {
                geoStyle.setMarkerSymbolID(symbolID);
            } else if(geometryType == GeometryType.GEOLINE) {
                geoStyle.setLineSymbolID(symbolID);
            } else if(geometryType == GeometryType.GEOREGION){
                geoStyle.setFillSymbolID(symbolID);
            }
            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注线，标注面边框颜色
     */
    @ReactMethod
    public void setTaggingMarkerColor(String colorString, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            com.supermap.data.Color makerColor = ColorParseUtil.getColor(colorString);
            geoStyle.setMarkerSymbolID(0);
            geoStyle.setLineColor(makerColor);

            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注线，标注面边框颜色
     */
    @ReactMethod
    public void setTaggingLineColor(String colorString, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            if(colorString.equals("NULL")){
                geoStyle.setLineSymbolID(5);
            }else{
                com.supermap.data.Color color = ColorParseUtil.getColor(colorString);
                geoStyle.setLineSymbolID(0);
                geoStyle.setLineColor(color);
            }

            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注面前景色
     */
    @ReactMethod
    public void setTaggingFillForeColor(String colorString, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            if(colorString.equals("NULL")){
                geoStyle.setFillSymbolID(1);
            }else{
                com.supermap.data.Color color = ColorParseUtil.getColor(colorString);
                geoStyle.setFillSymbolID(0);
                geoStyle.setFillForeColor(color);
            }

            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注线宽
     */
    @ReactMethod
    public void getTaggingLineWidth(Promise promise) {
        try {
            sMap = SMap.getInstance();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            double width = geoStyle.getLineWidth()*10;

            geometry.dispose();
            recordset.dispose();

            promise.resolve(width);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注符号大小
     */
    @ReactMethod
    public void getTaggingMarkerSize(Promise promise) {
        try {
            sMap = SMap.getInstance();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            Size2D size2d = geoStyle.getMarkerSize();
            double size =  size2d.getWidth();

            geometry.dispose();
            recordset.dispose();

            promise.resolve(size);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注符号角度
     */
    @ReactMethod
    public void getTaggingAngle(Promise promise) {
        try {
            sMap = SMap.getInstance();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            double angle = geoStyle.getMarkerAngle();

            geometry.dispose();
            recordset.dispose();

            promise.resolve(angle);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注面透明度
     */
    @ReactMethod
    public void getTaggingAlpha(Promise promise) {
        try {
            sMap = SMap.getInstance();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            int opaque = 100 - geoStyle.getFillOpaqueRate();

            geometry.dispose();
            recordset.dispose();

            promise.resolve(opaque);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注线宽
     */
    @ReactMethod
    public void setTaggingLineWidth(int mm, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            double width = (double) mm / 10;
            geoStyle.setLineWidth(width);

            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注符号大小
     */
    @ReactMethod
    public void setTaggingMarkerSize(int mm, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            geoStyle.setMarkerSize(new Size2D(mm, mm));

            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注符号角度
     */
    @ReactMethod
    public void setTaggingAngle(int angle, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            geoStyle.setMarkerAngle(angle);

            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注面透明度
     */
    @ReactMethod
    public void setTaggingAlpha(int fillOpaqueRate, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            Geometry geometry = recordset.getGeometry();
            GeoStyle geoStyle = geometry.getStyle();

            geoStyle.setFillOpaqueRate(100 - fillOpaqueRate);

            recordset.edit();
            geometry.setStyle(geoStyle);
            recordset.setGeometry(geometry);
            recordset.update();

            geometry.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注文字字体
     */
    @ReactMethod
    public void setTaggingTextFont(String font, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            GeoText geoText = (GeoText) recordset.getGeometry();
            TextStyle textStyle = geoText.getTextStyle();

            if(font.equals("BOLD")) {
                textStyle.setBold(!textStyle.isBold());
            } else if(font.equals("ITALIC")) {
                textStyle.setItalic(!textStyle.getItalic());
            } else if(font.equals("UNDERLINE")) {
                textStyle.setUnderline(!textStyle.getUnderline());
            } else if(font.equals("STRIKEOUT")) {
                textStyle.setStrikeout(!textStyle.getStrikeout());
            } else if(font.equals("SHADOW")) {
                textStyle.setShadow(!textStyle.getShadow());
            } else if(font.equals("OUTLINE")) {
                textStyle.setOutline(!textStyle.getOutline());
            }

            recordset.edit();
            geoText.setTextStyle(textStyle);
            recordset.setGeometry(geoText);
            recordset.update();

            geoText.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 设置标注文字颜色
     */
    @ReactMethod
    public void setTaggingTextColor(String colorString, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            GeoText geoText = (GeoText) recordset.getGeometry();
            TextStyle textStyle = geoText.getTextStyle();

            com.supermap.data.Color color = ColorParseUtil.getColor(colorString);
            textStyle.setForeColor(color);

            recordset.edit();
            geoText.setTextStyle(textStyle);
            recordset.setGeometry(geoText);
            recordset.update();

            geoText.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注文字旋转角度
     */
    @ReactMethod
    public void getTaggingTextSize(Promise promise) {
        try {
            sMap = SMap.getInstance();

            Recordset recordset = sMap.getSelection().toRecordset();
            GeoText geoText = (GeoText) recordset.getGeometry();
            TextStyle textStyle = geoText.getTextStyle();

            double size = textStyle.getFontHeight();

            geoText.dispose();
            recordset.dispose();

            promise.resolve(size);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取标注文字旋转角度
     */
    @ReactMethod
    public void getTaggingTextAngle(Promise promise) {
        try {
            sMap = SMap.getInstance();

            Recordset recordset = sMap.getSelection().toRecordset();
            GeoText geoText = (GeoText) recordset.getGeometry();

            TextPart textPart = geoText.getPart(0);
            double angle = textPart.getRotation();

            geoText.dispose();
            recordset.dispose();

            promise.resolve(angle);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注文字大小
     */
    @ReactMethod
    public void setTaggingTextSize(int size, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            GeoText geoText = (GeoText) recordset.getGeometry();
            TextStyle textStyle = geoText.getTextStyle();

            textStyle.setFontHeight(size);

            recordset.edit();
            geoText.setTextStyle(textStyle);
            recordset.setGeometry(geoText);
            recordset.update();

            geoText.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注文字旋转角度
     */
    @ReactMethod
    public void setTaggingTextAngle(int angle, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();

            Recordset recordset = sMap.getSelection().toRecordset();
            GeoText geoText = (GeoText) recordset.getGeometry();

            TextPart textPart = geoText.getPart(0);
            textPart.setRotation(angle);
            geoText.setPart(0,textPart);

            recordset.edit();
            recordset.setGeometry(geoText);
            recordset.update();

            geoText.dispose();
            recordset.dispose();
            sMap.smMapWC.getMapControl().getMap().refresh();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置MapControl 画笔样式
     *
     * @param style
     * @param promise
     */
    @ReactMethod
    public void setMapControlStyle(ReadableMap style, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();

            if (style.hasKey("nodeStyle")) {
                String nodeStyleJson = style.getString("nodeStyle");
                GeoStyle nodeStyle = new GeoStyle();
                nodeStyle.fromJson(nodeStyleJson);
                mapControl.setNodeStyle(nodeStyle);
            }

            if (style.hasKey("nodeColor")) {
                int nodeColor = style.getInt("nodeColor");
                mapControl.setNodeColor(nodeColor);
            }

            if (style.hasKey("nodeSize")) {
                double nodeSize = style.getDouble("nodeSize");
                mapControl.setNodeSize(nodeSize);
            }

            if (style.hasKey("strokeColor")) {
                int strokeColor = style.getInt("strokeColor");
                mapControl.setStrokeColor(strokeColor);
            }

            if (style.hasKey("strokeWidth")) {
                int strokeWidth = style.getInt("strokeWidth");
                mapControl.setStrokeWidth(strokeWidth);
            }

            if (style.hasKey("strokeFillColor")) {
                int strokeFillColor = style.getInt("strokeFillColor");
                mapControl.setStrokeFillColor(strokeFillColor);
            }

            if (style.hasKey("objectColor")) {
                int objectColor = style.getInt("objectColor");
                mapControl.setObjectColor(objectColor);
            }

            if (style.hasKey("objectWidth")) {
                double objectWidth = style.getDouble("objectWidth");
                mapControl.setObjectWidth(objectWidth);
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置标注默认的结点，线，面颜色
     *
     * @param promise
     */
    @ReactMethod
    public void setLabelColor(/*ReadableMap readableMap,*/ Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
//            mapControl.setStrokeColor(0x3999FF);
            mapControl.setStrokeColor(0x3999FF);
//            mapControl.setStrokeFillColor();
            mapControl.setStrokeWidth(1);

            GeoStyle geoStyle_P = new GeoStyle();
//            geoStyle_P.setMarkerAngle(14.0);
//            geoStyle_P.setFillForeColor(new Color(0,133,255));
//            geoStyle_P.setLineColor(new Color(0,133,255));
//            geoStyle_P.setMarkerSize(new Size2D(10, 10));
//            geoStyle_P.setPointColor(new Color(0,133,255));
//            geoStyle_P.setMarkerSymbolID(322);
//            mapControl.setNodeStyle(geoStyle_P);

            Workspace workspace = mapControl.getMap().getWorkspace();
            Resources m_resources = workspace.getResources();
            SymbolMarkerLibrary symbol_M = m_resources.getMarkerLibrary();
            if (symbol_M.contains(322)) {
                geoStyle_P.setMarkerSymbolID(322);
                mapControl.setNodeStyle(geoStyle_P);
            } else if (symbol_M.contains(313)) {
                geoStyle_P.setMarkerSymbolID(313);
                mapControl.setNodeStyle(geoStyle_P);
            } else if (symbol_M.contains(321)) {
                geoStyle_P.setMarkerSymbolID(321);
                mapControl.setNodeStyle(geoStyle_P);
            } else {
                mapControl.setNodeColor(0x3999FF);
                mapControl.setNodeSize(2.0);
            }

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


//    /**
//     * 更新图例
//     *
//     * @param promise
//     */
//    @ReactMethod
//    public void updateLegend(Promise promise){
//        try {
//            sMap = SMap.getInstance();
//            MapControl mapControl = sMap.smMapWC.getMapControl();
//
//            Layers layers = mapControl.getMap().getLayers();
//            ArrayList<HashMap<String, String>> arrayList = new ArrayList<>();
//
//            for (int i = 0; i < layers.getCount(); i++) {
//                Layer layer = layers.get(i);
//                if (layer.getTheme() != null) {
//                    if (layer.getTheme().getType() == ThemeType.RANGE) {
//                        ThemeRange themeRange = (ThemeRange) layer.getTheme();
//                        for (int j = 0; j < themeRange.getCount(); j++) {
//                            GeoStyle GeoStyle = themeRange.getItem(j).getStyle();
////                        map.put(themeRange.getItem(j).getCaption(), GeoStyle.getFillForeColor().toColorString());
//
//                            HashMap<String, String> map = new HashMap<String, String>();
//                            map.put("Caption", themeRange.getItem(j).getCaption());
//                            map.put("Color", GeoStyle.getFillForeColor().toColorString());
//                            arrayList.add(map);
//                        }
//                    }
//                }
//            }
//
//            Legend lengend = mapControl.getMap().getCreateLegend();
//            if(lengend!=null){
//                lengend.dispose();
//
//                for (int i = 0; i < arrayList.size(); i++) {
//                    HashMap<String, String> hashMap = arrayList.get(i);
//                    String caption = hashMap.get("Caption");
//                    String colorString = hashMap.get("Color");
//
//                    int color = android.graphics.Color.parseColor(colorString);
////                ColorLegendItem colorLegendItem = new ColorLegendItem();
////                colorLegendItem.setColor(color);
////                colorLegendItem.setCaption(caption);
////                lengend.addColorLegendItem(2, colorLegendItem);
//
//                    LegendItem legendItem = new LegendItem();
//                    legendItem.setColor(color);
//                    legendItem.setCaption(caption);
//                    lengend.addUserDefinedLegendItem(legendItem);
//                }
//                mapControl.getMap().refresh();
//            }
//            promise.resolve(true);
//
//        } catch (Exception e) {
//            promise.reject(e);
//        }
//    }


    /**
     * 标绘动画
     *
     * @param promise
     */
    @ReactMethod
    public void plotAnimation(Promise promise) {

    }


/************************************** 地图编辑历史操作 BEGIN****************************************/

    /**
     * 把对地图操作记录到历史
     *
     * @param promise
     */
    @ReactMethod
    public void addMapHistory(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            mapControl.getEditHistory().addMapHistory();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图操作记录数量
     *
     * @param promise
     */
    @ReactMethod
    public void getMapHistoryCount(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            int count = mapControl.getEditHistory().getCount();

            promise.resolve(count);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图操作记录当前index
     *
     * @param promise
     */
    @ReactMethod
    public void getMapHistoryCurrentIndex(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            int index = mapControl.getEditHistory().getCurrentIndex();

            promise.resolve(index);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 地图操作记录重做到index
     *
     * @param index
     * @param promise
     */
    @ReactMethod
    public void redoWithIndex(int index, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            boolean result = mapControl.getEditHistory().redo(index);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 地图操作记录撤销到index
     *
     * @param index
     * @param promise
     */
    @ReactMethod
    public void undoWithIndex(int index, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            boolean result = mapControl.getEditHistory().undo(index);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 地图操作记录移除两个index之间的记录
     *
     * @param start
     * @param end
     * @param promise
     */
    @ReactMethod
    public void removeRange(int start, int end, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            boolean result = mapControl.getEditHistory().removeRange(start, end);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 地图操作记录移除index位置的记录
     *
     * @param promise
     */
    @ReactMethod
    public void remove(int index, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            boolean result = mapControl.getEditHistory().remove(index);

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除地图操作记录
     *
     * @param promise
     */
    @ReactMethod
    public void clear(int index, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            boolean result = mapControl.getEditHistory().clear();

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
    /************************************** 地图编辑历史操作 END ****************************************/

    /************************************** 地图设置开始 ****************************************/

    /**
     * 获取图例的宽度和title
     *
     * @param promise
     */
    @ReactMethod
    public void getScaleData(Promise promise) {
        try {
            if (scaleViewHelper == null) {
                getScaleViewHelper();
            }

            scaleViewHelper.mScaleLevel = scaleViewHelper.getScaleLevel();
            scaleViewHelper.mScaleText = scaleViewHelper.getScaleText(scaleViewHelper.mScaleLevel);
            scaleViewHelper.mScaleWidth = scaleViewHelper.getScaleWidth(scaleViewHelper.mScaleLevel);
            WritableMap map = Arguments.createMap();
            map.putDouble("width", scaleViewHelper.mScaleWidth);
            map.putString("title", scaleViewHelper.mScaleText);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图旋转角度
     *
     * @param promise
     */
    @ReactMethod
    public void getMapAngle(Promise promise) {
        try {
            sMap = SMap.getInstance();
            double angle = sMap.smMapWC.getMapControl().getMap().getAngle();
            angle = new BigDecimal(angle).setScale(1, RoundingMode.UP).doubleValue();
            promise.resolve(angle);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图旋转角度
     *
     * @param angle
     * @param promise
     */
    @ReactMethod
    public void setMapAngle(double angle, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().setAngle(angle);
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setMapSlantAngle(double angle, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().setSlantAngle(angle);
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图颜色模式
     *
     * @param promise
     */
    @ReactMethod
    public void getMapColorMode(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapColorMode colorMode = sMap.smMapWC.getMapControl().getMap().getColorMode();
            String color = colorMode.toString();
            promise.resolve(color);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图颜色模式
     *
     * @param mode
     * @param promise
     */
    @ReactMethod
    public void setMapColorMode(int mode, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapColorMode colorMode = MapColorMode.DEFAULT;
            switch (mode) {
                case 0:
                    colorMode = MapColorMode.DEFAULT;
                    break;
                case 1:
                    colorMode = MapColorMode.BLACKWHITE;
                    break;
                case 2:
                    colorMode = MapColorMode.GRAY;
                    break;
                case 3:
                    colorMode = MapColorMode.BLACK_WHITE_REVERSE;
                    break;
                case 4:
                    colorMode = MapColorMode.ONLY_BLACK_WHITE_REVERSE;
                    break;
            }
            sMap.smMapWC.getMapControl().getMap().setColorMode(colorMode);
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.resolve(e);
        }
    }

    /**
     * 获取地图背景色
     *
     * @param promise
     */
    @ReactMethod
    public void getMapBackgroundColor(Promise promise) {
        try {
            sMap = SMap.getInstance();
            GeoStyle backgroundStyle = sMap.smMapWC.getMapControl().getMap().getBackgroundStyle();
            Color color = backgroundStyle.getFillForeColor();
            String r = Integer.toHexString(color.getR());
            String g = Integer.toHexString(color.getG());
            String b = Integer.toHexString(color.getB());
            r = r.length() == 1 ? "0" + r : r;
            g = g.length() == 1 ? "0" + g : g;
            b = b.length() == 1 ? "0" + b : b;
            String colorString = "#" + r + g + b;
            promise.resolve(colorString);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图背景色
     *
     * @param r
     * @param g
     * @param b
     * @param promise
     */
    @ReactMethod
    public void setMapBackgroundColor(int r, int g, int b, Promise promise) {
        try {
            sMap = SMap.getInstance();
            GeoStyle backgroundStyle = sMap.smMapWC.getMapControl().getMap().getBackgroundStyle();
            Color color = new Color(r, g, b);
            backgroundStyle.setFillForeColor(color);
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取是否固定符号角度
     */
    @ReactMethod
    public void getMarkerFixedAngle(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Boolean b = sMap.smMapWC.getMapControl().getMap().getIsMarkerFixedAngle();
            promise.resolve(b);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置是否固定符号角度
     *
     * @param b
     * @param promise
     */
    @ReactMethod
    public void setMarkerFixedAngle(Boolean b, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().setIsMarkerFixedAngle(b);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取是否固定文本角度
     *
     * @param promise
     */
    @ReactMethod
    public void getTextFixedAngle(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Boolean b = sMap.smMapWC.getMapControl().getMap().getIsTextFixedAngle();
            promise.resolve(b);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取是否固定文本方向
     *
     * @param promise
     */
    @ReactMethod
    public void getFixedTextOrientation(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Boolean b = sMap.smMapWC.getMapControl().getMap().getIsFixedTextOrientation();
            promise.resolve(b);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置是否固定文本角度
     *
     * @param b
     * @param promise
     */
    @ReactMethod
    public void setTextFixedAngle(Boolean b, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().setIsTextFixedAngle(b);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置是否固定文本方向
     *
     * @param b
     * @param promise
     */
    @ReactMethod
    public void setFixedTextOrientation(Boolean b, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().setIsFixedTextOrientation(b);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取放大镜是否开启
     *
     * @param promise
     */
    @ReactMethod
    public void isMagnifierEnabled(Promise promise) {
        try {
            sMap = SMap.getInstance();
            boolean b = sMap.smMapWC.getMapControl().isMagnifierEnabled();
            promise.resolve(b);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置放大镜是否开启
     *
     * @param b
     * @param promise
     */
    @ReactMethod
    public void setIsMagnifierEnabled(boolean b, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().setMagnifierEnabled(b);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图中心点
     *
     * @param promise
     */
    @ReactMethod
    public void getMapCenter(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Point2D center = sMap.smMapWC.getMapControl().getMap().getCenter();
            double x = center.getX();
            double y = center.getY();
            WritableMap writeMap = Arguments.createMap();
            writeMap.putDouble("x", x);
            writeMap.putDouble("y", y);
            promise.resolve(writeMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图中心点
     *
     * @param promise
     */
    @ReactMethod
    public void setMapCenter(double x, double y, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Point2D center = new Point2D(x, y);
            sMap.smMapWC.getMapControl().getMap().setCenter(center);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图比例尺
     *
     * @param promise
     */
    @ReactMethod
    public void getMapScale(Promise promise) {
        try {
            sMap = SMap.getInstance();
            double scale = sMap.smMapWC.getMapControl().getMap().getScale();
            String mscale = "" + 1 / scale;
            promise.resolve(mscale);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 设置地图比例尺
     *
     * @param promise
     */
    @ReactMethod
    public void setMapScale(double scale, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().setScale(scale);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取当前窗口的四至范围 viewBounds
     *
     * @param promise
     */
    @ReactMethod
    public void getMapViewBounds(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Rectangle2D rect = sMap.smMapWC.getMapControl().getMap().getViewBounds();
            double left = rect.getLeft();
            double right = rect.getRight();
            double top = rect.getTop();
            double bottom = rect.getBottom();
            WritableMap map = Arguments.createMap();
            map.putDouble("left", left);
            map.putDouble("bottom", bottom);
            map.putDouble("right", right);
            map.putDouble("top", top);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置当前窗口四至范围
     *
     * @param left
     * @param bottom
     * @param right
     * @param top
     * @param promise
     */
    @ReactMethod
    public void setMapViewBounds(double left, double bottom, double right, double top, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Rectangle2D rect = new Rectangle2D(left, bottom, right, top);
            sMap.smMapWC.getMapControl().getMap().setViewBounds(rect);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图坐标系
     *
     * @param promise
     */
    @ReactMethod
    public void getPrjCoordSys(Promise promise) {
        try {
            sMap = SMap.getInstance();
            String name = sMap.smMapWC.getMapControl().getMap().getPrjCoordSys().getName();
            promise.resolve(name);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置地图坐标系
     *
     * @param xml
     * @param promise
     */
    @ReactMethod
    public void setPrjCoordSys(String xml, Promise promise) {
        try {
            sMap = SMap.getInstance();
            PrjCoordSys prjCoordSys = new PrjCoordSys();
            prjCoordSys.fromXML(xml);
            sMap.smMapWC.getMapControl().getMap().setPrjCoordSys(prjCoordSys);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 从数据源复制坐标系
     *
     * @param dataSourcePath
     * @param promise
     */
    @ReactMethod
    public void copyPrjCoordSysFromDatasource(String dataSourcePath, int engineType, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Workspace workspace = new Workspace();
            DatasourceConnectionInfo datasourceConnectionInfo = new DatasourceConnectionInfo();
            EngineType eType = EngineType.newInstance(engineType);
            datasourceConnectionInfo.setEngineType(eType);
            datasourceConnectionInfo.setServer(dataSourcePath);
            datasourceConnectionInfo.setAlias("dataSource");
            Datasource datasource = workspace.getDatasources().open(datasourceConnectionInfo);

            PrjCoordSys prjCoordSys = datasource.getPrjCoordSys();
            sMap.smMapWC.getMapControl().getMap().setPrjCoordSys(prjCoordSys);

            String coordName = sMap.smMapWC.getMapControl().getMap().getPrjCoordSys().getName();

            WritableMap map = Arguments.createMap();
            map.putString("prjCoordSysName", coordName);

            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /**
     * 从数据集复制坐标系
     *
     * @param datasourceName
     * @param datasetName
     * @param promise
     */
    @ReactMethod
    public void copyPrjCoordSysFromDataset(String datasourceName, String datasetName, Promise promise) {
        try {
            sMap = SMap.getInstance();
            Datasources datasources = sMap.smMapWC.getWorkspace().getDatasources();

            Datasource datasource = datasources.get(datasourceName);

            if (datasource != null) {
                Dataset dataset = datasource.getDatasets().get(datasetName);
                if (dataset != null) {
                    if (dataset.getPrjCoordSys() != null) {
                        sMap.smMapWC.getMapControl().getMap().setPrjCoordSys(dataset.getPrjCoordSys());
                    } else {
                        sMap.smMapWC.getMapControl().getMap().setPrjCoordSys(datasource.getPrjCoordSys());
                    }
                    String coordName = sMap.smMapWC.getMapControl().getMap().getPrjCoordSys().getName();

                    WritableMap map = Arguments.createMap();
                    map.putString("prjCoordSysName", coordName);

                    promise.resolve(map);
                } else {
                    promise.resolve(false);
                }

            } else {
                promise.resolve(false);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 从文件复制坐标系
     *
     * @param filePath
     * @param fileType
     * @param promise
     */
    @ReactMethod
    public void copyPrjCoordSysFromFile(String filePath, String fileType, Promise promise) {
        try {
            sMap = SMap.getInstance();
            PrjFileType prjFileType = fileType.equals("xml") ? PrjFileType.SUPERMAP : PrjFileType.ESRI;
            PrjCoordSys prjCoordSys = new PrjCoordSys();
            Boolean isSuccess = prjCoordSys.fromFile(filePath, prjFileType);

            WritableMap map = Arguments.createMap();

            if (isSuccess) {
                sMap.smMapWC.getMapControl().getMap().setPrjCoordSys(prjCoordSys);
                String coordName = sMap.smMapWC.getMapControl().getMap().getPrjCoordSys().getName();
                map.putString("prjCoordSysName", coordName);
            } else {
                map.putString("error", "ILLEGAL_COORDSYS");
            }

            promise.resolve(map);

        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /**
     * 获取动态投影是否已开启
     *
     * @param promise
     */
    @ReactMethod
    public void getMapDynamicProjection(Promise promise) {
        try {
            sMap = SMap.getInstance();
            Boolean isDynamicprojection = sMap.smMapWC.getMapControl().getMap().isDynamicProjection();
            promise.resolve(isDynamicprojection);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置是否开启动态投影
     *
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setMapDynamicProjection(Boolean value, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().setDynamicProjection(value);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取当前投影转换方法
     *
     * @param promise
     */
    @ReactMethod
    public void getCoordSysTransMethod(Promise promise) {
        try {
            sMap = SMap.getInstance();
            CoordSysTransMethod method = sMap.smMapWC.getMapControl().getMap().getDynamicPrjTransMethond();
            CoordSysTransMethod[] methods = new CoordSysTransMethod[6];
            int index = 0;
            String name = "";
            methods[0] = CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION;
            methods[1] = CoordSysTransMethod.MTH_MOLODENSKY;
            methods[2] = CoordSysTransMethod.MTH_MOLODENSKY_ABRIDGED;
            methods[3] = CoordSysTransMethod.MTH_POSITION_VECTOR;
            methods[4] = CoordSysTransMethod.MTH_COORDINATE_FRAME;
            methods[5] = CoordSysTransMethod.MTH_BURSA_WOLF;
            for (int i = 0; i < methods.length; i++) {
                if (method == methods[i])
                    index = i;
            }
            switch (index) {
                case 0:
                    name = "Geocentric Transalation(3-para)";
                    break;
                case 1:
                    name = "Molodensky(7-para)";
                    break;
                case 2:
                    name = "Abridged Molodensky(7-para)";
                    break;
                case 3:
                    name = "Position Vector(7-para)";
                    break;
                case 4:
                    name = "Coordinate Frame(7-para)";
                    break;
                case 5:
                    name = "Bursa-wolf(7-para)";
                    break;
            }
            promise.resolve(name);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置当前投影转换方法和参数
     *
     * @param params
     * @param promise
     */
    @ReactMethod
    public void setCoordSysTransMethodAndParams(ReadableMap params, Promise promise) {
        try {
            sMap = SMap.getInstance();
            com.supermap.mapping.Map map = sMap.smMapWC.getMapControl().getMap();
            String[] coorMethodArray = new String[6];
            CoordSysTransMethod method = CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION;
            int index = 0;
            coorMethodArray[0] = "Geocentric Transalation(3-para)";
            coorMethodArray[1] = "Molodensky(7-para)";
            coorMethodArray[2] = "Abridged Molodensky(7-para)";
            coorMethodArray[3] = "Position Vector(7-para)";
            coorMethodArray[4] = "Coordinate Frame(7-para)";
            coorMethodArray[5] = "Bursa-wolf(7-para)";
            for (int i = 0; i < coorMethodArray.length; i++) {
                if (params.getString("coordSysTransMethod").equals(coorMethodArray[i]))
                    index = i;
            }
            switch (index) {
                case 0:
                    method = CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION;
                    break;
                case 1:
                    method = CoordSysTransMethod.MTH_MOLODENSKY;
                    break;
                case 2:
                    method = CoordSysTransMethod.MTH_MOLODENSKY_ABRIDGED;
                    break;
                case 3:
                    method = CoordSysTransMethod.MTH_POSITION_VECTOR;
                    break;
                case 4:
                    method = CoordSysTransMethod.MTH_COORDINATE_FRAME;
                    break;
                case 5:
                    method = CoordSysTransMethod.MTH_BURSA_WOLF;
                    break;
            }
            map.setDynamicPrjTransMethond(method);
            map.getDynamicPrjTransParameter().setRotateX(params.getDouble("rotateX"));
            map.getDynamicPrjTransParameter().setRotateY(params.getDouble("rotateY"));
            map.getDynamicPrjTransParameter().setRotateZ(params.getDouble("rotateZ"));
            map.getDynamicPrjTransParameter().setTranslateX(params.getDouble("translateX"));
            map.getDynamicPrjTransParameter().setTranslateY(params.getDouble("translateY"));
            map.getDynamicPrjTransParameter().setTranslateZ(params.getDouble("translateZ"));

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加图例的事件监听
     *
     * @param promise
     */
    @ReactMethod
    public void addLegendListener(Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().getLegend().setContentChangeListener(this);
            sMap.smMapWC.getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @Override
    public void legendContentChanged(Vector<LegendItem> arrItems) {
        sMap = SMap.getInstance();
        WritableArray arr = Arguments.createArray();
        for (int i = 0; i < arrItems.size(); i++) {
            WritableMap writeMap = Arguments.createMap();
            Bitmap bm = arrItems.get(i).getBitmap();
            String name = arrItems.get(i).getCaption();
            int type = arrItems.get(i).getType();
            String result = null;
            if (bm != null) {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                bm.compress(Bitmap.CompressFormat.PNG, 100, baos);
                byte[] bitmapBytes = baos.toByteArray();
                result = Base64.encodeToString(bitmapBytes, Base64.DEFAULT);
            }
            writeMap.putString("image", result);
            writeMap.putString("title", name);
            writeMap.putInt("type", type);
            arr.pushMap(writeMap);
        }
        ReadableArray array = sMap.getOtherLegendData(arr);
        context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(EventConst.LEGEND_CONTENT_CHANGE, array);
    }

    /**
     * 获取分段图例数据
     *
     * @return
     */
    public ReadableArray getOtherLegendData(WritableArray array) {
        sMap = SMap.getInstance();
        Layers layers = sMap.smMapWC.getMapControl().getMap().getLayers();
        for (int i = 0; i < layers.getCount(); i++) {
            Layer layer = layers.get(i);
            if (layer.getTheme() != null) {
                if (layer.getTheme().getType() == ThemeType.RANGE) {
                    ThemeRange themeRange = (ThemeRange) layer.getTheme();
                    for (int j = 0; j < themeRange.getCount(); j++) {
                        GeoStyle geoStyle = themeRange.getItem(j).getStyle();
                        Color color = geoStyle.getFillForeColor();
                        String caption = themeRange.getItem(j).getCaption();
                        String r = Integer.toHexString(color.getR());
                        String g = Integer.toHexString(color.getG());
                        String b = Integer.toHexString(color.getB());
                        r = r.length() == 1 ? "0" + r : r;
                        g = g.length() == 1 ? "0" + g : g;
                        b = b.length() == 1 ? "0" + b : b;
                        String colorString = "#" + r + g + b;
                        System.out.print(colorString);
                        WritableMap writableMap = Arguments.createMap();
                        writableMap.putString("color", colorString);
                        writableMap.putString("title", caption);
                        writableMap.putInt("type", 3);
                        array.pushMap(writableMap);
                    }
                }
            }
        }
        return array;
    }

    /**
     * 移除图例的事件监听
     *
     * @param promise
     */
    @ReactMethod
    public void removeLegendListener(Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.smMapWC.getMapControl().getMap().getLegend().setContentChangeListener(null);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
    /************************************** 地图设置 END ****************************************/
//
//    /**
//     * 初始化二维POI搜索
//     * @param promise
//     */
//    @ReactMethod
//    public void initPointSearch(Promise promise){
//        try {
//            sMap = SMap.getInstance();
//            sMap.poiSearchHelper2D = POISearchHelper2D.getInstence();
//            MapControl mapControl = sMap.smMapWC.getMapControl();
//            sMap.poiSearchHelper2D.initMapControl(mapControl,context);
//            promise.resolve(true);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//    }
//
//    /**
//     * 二维POI搜索
//     * @param keyword
//     * @param promise
//     */
//    @ReactMethod
//    public void pointSearch(String keyword, Promise promise){
//        try {
//            sMap.poiSearchHelper2D.poiSearch(keyword, new POISearchHelper2D.PoiSearchCallBack() {
//                @Override
//                public void poiSearchInfos(ArrayList<PoiGsonBean.PoiInfos> poiInfos) {
//                    WritableArray array = Arguments.createArray();
//                    int count = poiInfos.size();
//                    for(int i = 0; i < count; i++){
//                        WritableMap map = Arguments.createMap();
//                        PoiGsonBean.PoiInfos poiInfo = poiInfos.get(i);
//                        String name = poiInfo.getName();
//                        map.putString("pointName",name);
//                        map.putDouble("x",poiInfo.getLocation().getX());
//                        map.putDouble("y",poiInfo.getLocation().getY());
//                        array.pushMap(map);
//                    }
//                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
//                            .emit(EventConst.POINTSEARCH2D_KEYWORDS, array);
//                }
//            });
//            promise.resolve(true);
//        }catch (Exception e){
//            promise.reject(e);
//        }
//    }

    /**
     * 定位到搜索结果某个点
     *
     * @param map
     * @param promise
     */
    @ReactMethod
    public void toLocationPoint(ReadableMap map, Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            double x = map.getDouble("x");
            double y = map.getDouble("y");
            String name = map.getString("pointName");
            String tagName = "POISEARCH_2D_POINT";
            clearPoint(tagName);

            Point2D mapPoint = new Point2D(x, y);
            if (!safeGetType(mapControl.getMap().getPrjCoordSys(), PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)) {
                Point2Ds points = new Point2Ds();
                points.add(mapPoint);
                PrjCoordSys sourcePrjCoordSys = new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                CoordSysTransParameter coordSysTransParameter = new CoordSysTransParameter();

                CoordSysTranslator.convert(
                        points,
                        sourcePrjCoordSys,
                        mapControl.getMap().getPrjCoordSys(),
                        coordSysTransParameter,
                        CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

                mapPoint = points.getItem(0);
            }

            Boolean isSuccess = addCallout(mapPoint.getX(), mapPoint.getY(), name, tagName, true, false);

            if (mapControl.getMap().getScale() < 0.000011947150294723098) {
                mapControl.getMap().setScale(0.000011947150294723098);
            }
            mapControl.panTo(mapPoint, 200);
//            mapControl.getMap().setCenter(mapPoint);
            mapControl.getMap().refresh();

            promise.resolve(isSuccess);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    /**
     * 获取当前定位的经纬度
     *
     * @param promise
     */
    @ReactMethod
    public void getCurrentPosition(Promise promise) {
        try {
            LocationManagePlugin.GPSData gpsDat = SMCollector.getGPSPoint();
            WritableMap map = Arguments.createMap();
            map.putDouble("x", gpsDat.dLongitude);
            map.putDouble("y", gpsDat.dLatitude);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取地图中心点经纬度
     *
     * @param promise
     */
    @ReactMethod
    public void getMapcenterPosition(Promise promise) {
        try {
            sMap = SMap.getInstance();
            MapControl mapControl = sMap.smMapWC.getMapControl();
            Point2D point = mapControl.getMap().getCenter();
            Point2Ds point2Ds = new Point2Ds();
            point2Ds.add(point);

            PrjCoordSys sourcePrjCoordSys = new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);

            CoordSysTransParameter coordSysTransParameter = new CoordSysTransParameter();

            CoordSysTranslator.convert(
                    point2Ds,
                    mapControl.getMap().getPrjCoordSys(),
                    sourcePrjCoordSys,
                    coordSysTransParameter,
                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

            Point2D mapPoint = point2Ds.getItem(0);

            WritableMap map = Arguments.createMap();
            map.putDouble("x", mapPoint.getX());
            map.putDouble("y", mapPoint.getY());

            promise.resolve(map);
        } catch (Exception e) {
            LocationManagePlugin.GPSData gpsData = SMCollector.getGPSPoint();
            double x = gpsData.dLongitude;
            double y = gpsData.dLatitude;
            WritableMap map = Arguments.createMap();
            map.putDouble("x", x);
            map.putDouble("y", y);
            promise.resolve(map);
        }
    }

    /**
     * 移除POI搜索的callout
     *
     * @param promise
     */
    @ReactMethod
    public void removePOICallout(Promise promise) {
        try {
            sMap = SMap.getInstance();
            String tagName = "POISEARCH_2D_POINT";
            clearPoint(tagName);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeAllCallout(Promise promise) {
        try {
            sMap = SMap.getInstance();
            for (int i = 0; i < 10; i++) {
                String tagName = "POISEARCH_2D_POINTS" + i;
                clearPoint(tagName);
            }
            clearPoint("bigCallout");
            hasBigCallout = false;
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    //    /**
//     * 当前选中的callout移动到地图中心
//     *
//     * @param item
//     * @param promise
//     */
//    @ReactMethod
//    public void setCalloutToMapCenter(ReadableMap item, Promise promise) {
//        try {
//            MapControl mapControl = SMap.getInstance().smMapWC.getMapControl();
//            double x = item.getDouble("x");
//            double y = item.getDouble("y");
//            Point2D point = new Point2D(x, y);
//            Point2Ds point2Ds = new Point2Ds();
//            point2Ds.add(point);
//
//            PrjCoordSys sourcePrjCoordSys = new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
//            CoordSysTransParameter coordSysTransParameter = new CoordSysTransParameter();
//
//            CoordSysTranslator.convert(
//                    point2Ds,
//                    sourcePrjCoordSys,
//                    mapControl.getMap().getPrjCoordSys(),
//                    coordSysTransParameter,
//                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
//
//            Point2D mapPoint = point2Ds.getItem(0);
//
//            mapControl.getMap().setCenter(mapPoint);
//            mapControl.getMap().refresh();
//            promise.resolve(true);
//        } catch (Exception e) {
//            promise.reject(e);
//        }
//    }
    @ReactMethod
    public void setCenterCallout(ReadableMap item, Promise promise) {
        try {
            sMap = SMap.getInstance();
            if (hasBigCallout) {
                clearPoint("bigCallout");
            }
            double x = item.getDouble("x");
            double y = item.getDouble("y");
            String name = "";
            String tagName = "bigCallout";
            boolean b = addCallout(x, y, name, tagName, true, true);
            promise.resolve(b);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加搜索到的callouts
     *
     * @param pointList
     * @param promise
     */
    @ReactMethod
    public void addCallouts(ReadableArray pointList, Promise promise) {
        try {
            sMap = SMap.getInstance();
            sMap.clearPoint("POISEARCH_2D_POINT");
            Boolean isSuccess = true;
            //最多10个callout
            int len = pointList.size() < 10 ? pointList.size() : 10;

            MapControl mapControl = sMap.smMapWC.getMapControl();
            Point2Ds point2Ds = new Point2Ds();

            for (int i = 0; i < len; i++) {
                ReadableMap map = pointList.getMap(i);
                double x = map.getDouble("x");
                double y = map.getDouble("y");

                Point2D mapPoint = new Point2D(x, y);
                if (mapControl.getMap().getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
                    Point2Ds points = new Point2Ds();
                    points.add(mapPoint);
                    PrjCoordSys sourcePrjCoordSys = new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                    CoordSysTransParameter coordSysTransParameter = new CoordSysTransParameter();

                    CoordSysTranslator.convert(
                            points,
                            sourcePrjCoordSys,
                            mapControl.getMap().getPrjCoordSys(),
                            coordSysTransParameter,
                            CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);

                    mapPoint = points.getItem(0);
                }

                String name = "";
                String tagName = "POISEARCH_2D_POINTS" + i;
                Boolean b = addCallout(mapPoint.getX(), mapPoint.getY(), name, tagName, false, false);
                if (!b) {
                    isSuccess = b;
                } else {
                    point2Ds.add(mapPoint);
                }
            }

            GeoRegion geoRegion = new GeoRegion(point2Ds);
            Rectangle2D bounds = geoRegion.getBounds();
            //bounds.inflate(-bounds.getWidth() * 0.2,-bounds.getHeight() * 0.5);
            mapControl.getMap().setViewBounds(bounds);
            Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    sMap.getSmMapWC().getMapControl().zoomTo(sMap.getSmMapWC().getMapControl().getMap().getScale() * 0.2, 100);
                }
            }, 200);//3秒后执行Runnable中的run方法
            mapControl.getMap().refresh();
            geoRegion.dispose();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 添加callout
     *
     * @param x            经度
     * @param y            纬度
     * @param name         显示的名字
     * @param tagName      标识名
     * @param changeCenter 是否改变地图中心点
     * @param bigCallout   是否特别标注（绿色、加大）
     */
    public Boolean addCallout(final double x, final double y, final String name, final String tagName, final Boolean changeCenter, final Boolean bigCallout) {
        context.getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                sMap = SMap.getInstance();
                MapControl mapControl = sMap.smMapWC.getMapControl();
                Point2D mapPoint = new Point2D(x, y);

                DisplayMetrics dm = new DisplayMetrics();
                getCurrentActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
                double density = dm.density;

                int markerSize = 30;
                RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams((int) (600 * density), (int) (markerSize * density));

                InfoCallout callout = new InfoCallout(context);
                callout.setStyle(CalloutAlignment.BOTTOM);
//                callout.setBackgroundColor(android.graphics.Color.GRAY);
//                callout.setBackground(0, 0);
                callout.setCustomize(true);
                callout.setLayoutParams(params);

                ImageView imageView = new ImageView(context);
                imageView.setAdjustViewBounds(true);

                imageView.setImageResource(R.drawable.icon_red);

                params = new RelativeLayout.LayoutParams((int) (markerSize * density), (int) (markerSize * density));
                params.setMargins((int) (150 * density) - (int) (markerSize * density / 2), 10, 0, 0);
                imageView.setLayoutParams(params);
//                imageView.setBackgroundColor(android.graphics.Color.BLUE);


                StrokeTextView strokeTextView = new StrokeTextView(context);
                strokeTextView.setTextSize(14);
                params = new RelativeLayout.LayoutParams((int) (150 * density) - (int) (markerSize * density / 2), (int) (markerSize * density) + 10);
                params.setMargins((int) (150 * density) + markerSize * (int) density / 2, 0, 0, 0);
                strokeTextView.setLayoutParams(params);
                strokeTextView.setTextColor(android.graphics.Color.WHITE);
                String showName = name.length() > 15 ? name.substring(0, 15) + "..." : name;
                strokeTextView.setText(showName);
//                strokeTextView.setBackgroundColor(android.graphics.Color.YELLOW);
                callout.addView(imageView);
                callout.addView(strokeTextView);


//                callout.setContentView(linearLayout);
                // 20处理默认callout背景位置偏差
                double x = mapPoint.getX();
                double y = mapPoint.getY();
                callout.setLocation(x, y);

                mapControl.getMap().getMapView().addCallout(callout, tagName);
                mapControl.getMap().getMapView().showCallOut();

            }
        });
        return true;
    }

    public void clearPoint(final String tagName) {
        context.getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                MapControl mapControl = SMap.getInstance().smMapWC.getMapControl();
                mapControl.getMap().getMapView().removeCallOut(tagName);
            }
        });
    }

    /*
     *是否打开移动端POI大数据优化显示选项
     */
    @ReactMethod
    public void setPOIOptimized(Boolean bPOIOptimized, Promise promise){
        try {
            sMap = SMap.getInstance();
            // sMap.smMapWC.getMapControl().getMap().setIsPOIOptimized(bPOIOptimized);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 将地图上的点转换为经纬坐标点
     *
     * @param
     * @return
     */
    private Point2D getPoint(double x, double y) {
        Point2D point2D = null;
        if (SMap.getInstance().getSmMapWC().getMapControl().getMap().getPrjCoordSys().getType() != PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE) {
            PrjCoordSys srcPrjCoordSys = SMap.getInstance().getSmMapWC().getMapControl().getMap().getPrjCoordSys();
            Point2Ds point2Ds = new Point2Ds();
            point2Ds.add(new Point2D(x, y));
            PrjCoordSys desPrjCoordSys = new PrjCoordSys();
            desPrjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
            // 转换投影坐标
            CoordSysTranslator.convert(point2Ds, srcPrjCoordSys,
                    desPrjCoordSys, new CoordSysTransParameter(),
                    CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
            point2D = point2Ds.getItem(0);
        } else {
            point2D = new Point2D(x, y);
        }
        return point2D;
    }

    /************************************** 智能配图 BEGIN ****************************************/
    /**
     * 智能配图
     *
     * @param picPath
     * @param promise
     */
    @ReactMethod
    public void matchPictureStyle(String picPath, Promise promise) {
        try {
            SMap.getInstance().smMapWC.getMapControl().getEditHistory().addMapHistory();
            SMMapRender smMapRender = SMMapRender.getInstance();
            smMapRender.setSmMapRenderListener(new SMMapRender.SMMapRenderListener() {
                @Override
                public void onMatchPictureStyleFinished(boolean bSucssed, String strPath, String error) {
                    WritableMap res = Arguments.createMap();
                    res.putBoolean("result", bSucssed);
                    res.putString("image", strPath);
                    res.putString("error", error);
                    context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(EventConst.MATCH_IMAGE_RESULT, res);
                }
            });

            String path = picPath;
            if (picPath.indexOf("content://") == 0) {
                path = FileUtil.getRealFilePath(getReactApplicationContext(), Uri.parse(picPath));
            }
            smMapRender.setCompressMode(2);
            smMapRender.matchPictureStyle(path);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 移除智能配图监听
     *
     * @param promise
     */
    @ReactMethod
    public void deleteMatchPictureListener(Promise promise) {
        try {
            SMMapRender smMapRender = SMMapRender.getInstance();
            smMapRender.setSmMapRenderListener(null);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 调整智能配图 亮度、饱和度、色调
     *
     * @param mode
     * @param value
     * @param promise
     */
    @ReactMethod
    public void updateMapFixColorsMode(int mode, int value, Promise promise) {
        try {
            SMMapFixColors smMapFixColors = SMMapFixColors.getInstance();
            SMMapFixColors.SMMapFixColorsMode _mode = DataUtil.getEnum(SMMapFixColors.SMMapFixColorsMode.class, mode);
            smMapFixColors.updateMapFixColors(_mode, value);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取智能配图 亮度、饱和度、色调
     *
     * @param mode
     * @param promise
     */
    @ReactMethod
    public void getMapFixColorsModeValue(int mode, Promise promise) {
        try {
            SMMapFixColors smMapFixColors = SMMapFixColors.getInstance();
            SMMapFixColors.SMMapFixColorsMode _mode = DataUtil.getEnum(SMMapFixColors.SMMapFixColorsMode.class, mode);
            int value = smMapFixColors.getMapFixColorsModeValue(_mode);
            promise.resolve(value);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 重置智能配图 亮度、饱和度、色调 的值
     *
     * @param isReset 是否重置地图
     * @param promise
     */
    @ReactMethod
    public void resetMapFixColorsModeValue(boolean isReset, Promise promise) {
        try {
            SMMapFixColors smMapFixColors = SMMapFixColors.getInstance();
            smMapFixColors.reset(isReset);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
    /************************************** 智能配图 END ****************************************/

    /************************************** 许可配制 BEGIN***************************************/

    /**
     * 激活许可
     *
     * @param serialNumber 序列号
     * @param promise
     */
    @ReactMethod
    public void activateLicense(final String serialNumber, final Promise promise) {
        try {
            final RecycleLicenseManager licenseManagers = RecycleLicenseManager.getInstance(context);
            Environment.setLicenseType(LicenseType.UUID);
            licenseManagers.setActivateCallback(licenseCallback);
            queryHandler = new OneArg<ArrayList<Module>>() {
                @Override
                public void handle(ArrayList<Module> modules) {

                    if(modules == null) {
                        promise.resolve(false);
                        return;
                    }

                    String modulesStr = null;
                    if (modules.size() > 0) {
                        modulesStr = modules.get(0).value() + "";
                        for (int i = 1; i < modules.size(); i++) {
                            modulesStr += "," + modules.get(i).value();
                        }
                    }
                    final String finalModulesStr = modulesStr;
                    activateHandler = new OneArg<Boolean>() {
                        @Override
                        public void handle(Boolean result) {

                            if (result) {
                                try {
                                    File serialNumberFile = new File(lcenseSerialNumberFilePath);
                                    if (serialNumberFile.exists()) {
                                        serialNumberFile.delete();
                                    }
                                    serialNumberFile.createNewFile();
                                    OutputStream outputStream = new FileOutputStream(serialNumberFile);
                                    OutputStreamWriter outputStreamWriter = new OutputStreamWriter(outputStream);
                                    String writeContent = serialNumber + "&&" + finalModulesStr;
                                    outputStreamWriter.write(writeContent);
                                    outputStreamWriter.close();
                                } catch (Exception e) {
                                    promise.reject(e);
                                }
                            }
                            promise.resolve(result);
                        }
                    };
                    licenseManagers.activateDevice(serialNumber, modules);
                }
            };
            licenseManagers.query(serialNumber);

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取正式许可所含模块
     *
     * @param serialNumber 序列号
     * @param promise
     */
    @ReactMethod
    public void licenseContainModule(final String serialNumber, final Promise promise) {
        try {
            final RecycleLicenseManager licenseManagers = RecycleLicenseManager.getInstance(context);
            licenseManagers.setActivateCallback(licenseCallback);
            queryHandler = new OneArg<ArrayList<Module>>() {
                @Override
                public void handle(ArrayList<Module> modules) {
                    WritableArray array = Arguments.createArray();
                    for (Module module : modules) {
                        array.pushInt(module.value());
                    }
                    promise.resolve(array);
                }
            };
            licenseManagers.query(serialNumber);

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 归还许可
     *
     * @param serialNumber 序列号
     * @param promise
     */
    @ReactMethod
    public void recycleLicense(String serialNumber, final Promise promise) {
        try {
            RecycleLicenseManager licenseManagers = RecycleLicenseManager.getInstance(context);
            licenseManagers.setActivateCallback(licenseCallback);
            recycleHandler = new OneArg<Boolean>() {
                @Override
                public void handle(Boolean result) {
                    promise.resolve(result);
                }
            };
            licenseManagers.recycleLicense(null);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 清除许可，清除本地许可文件，不归还
     *
     * @param serialNumber 序列号
     * @param promise
     */
    @ReactMethod
    public void clearLocalLicense(String serialNumber, Promise promise) {
        try {
            RecycleLicenseManager licenseManagers = RecycleLicenseManager.getInstance(context);
            licenseManagers.clearLocalLicense();
            File serialNumberFile = new File(lcenseSerialNumberFilePath);
            if (serialNumberFile.exists()) {
                serialNumberFile.delete();
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取剩余许可数量
     *
     * @param serialNumber 序列号
     * @param promise
     */
    @ReactMethod
    public void getLicenseCount(String serialNumber, final Promise promise) {
        try {
            RecycleLicenseManager licenseManagers = RecycleLicenseManager.getInstance(context);
            licenseManagers.setActivateCallback(licenseCallback);
            queryCountHandler = new OneArg<JSONArray>() {
                @Override
                public void handle(JSONArray jsonArray) {
                    int length = jsonArray.length();
                    //返回所有模块中剩余数量最少的  [{"Module":"Core_Runtime","LicenseActivedCount":6,"LicenseRemainedCount":494}]
                    int minCount = 0;
                    for (int i = 0; i < length; i++) {
                        try {
                            JSONObject jsonObject = (JSONObject) jsonArray.get(i);
                            int remainedCount = jsonObject.getInt("LicenseRemainedCount");
                            if (i == 0) {
                                minCount = remainedCount;
                            } else if (minCount > remainedCount) {
                                minCount = remainedCount;
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                    promise.resolve(minCount);
                }
            };
            licenseManagers.queryLicenseCount(serialNumber);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 初始化许可序列号
     *
     * @param serialNumber 序列号
     * @param promise
     */
    @ReactMethod
    public void initSerialNumber(String serialNumber, final Promise promise) {
        try {
            RecycleLicenseManager licenseManagers = RecycleLicenseManager.getInstance(context);
            lcenseSerialNumberFilePath = context.getExternalCacheDir().getParentFile().getParent() + "/com.config.supermap.runtime/config/recycleLicense/" + "/serialNumber.txt";
            File serialNumberFile = new File(lcenseSerialNumberFilePath);
            if (!serialNumberFile.exists()) {
//                serialNumberFile.mkdirs();
//                serialNumberFile.createNewFile();
                promise.resolve("");
            } else {
                InputStream inputStream = new FileInputStream(serialNumberFile);
                InputStreamReader reader = new InputStreamReader(inputStream);
                BufferedReader bufferedReader = new BufferedReader(reader);
                serialNumber = bufferedReader.readLine().split("&&")[0];
                inputStream.close();
                promise.resolve(serialNumber);
            }
            // context.getExternalCacheDir().getParentFile().getParent() + "/com.config.supermap.runtime/config/recycleLicense/"
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 离线获取序列号和模块编号数组
     *
     * @param promise
     */
    @ReactMethod
    public void getSerialNumberAndModules(Promise promise) {
        try {
            lcenseSerialNumberFilePath = context.getExternalCacheDir().getParentFile().getParent() + "/com.config.supermap.runtime/config/recycleLicense/" + "/serialNumber.txt";
            File serialNumberFile = new File(lcenseSerialNumberFilePath);
            if (!serialNumberFile.exists()) {
                promise.resolve(null);
            } else {
                InputStream inputStream = new FileInputStream(serialNumberFile);
                InputStreamReader reader = new InputStreamReader(inputStream);
                BufferedReader bufferedReader = new BufferedReader(reader);
                String[] serialNumberAndModules = bufferedReader.readLine().split("&&");
                WritableMap writableMap = Arguments.createMap();
                if (serialNumberAndModules.length == 2) {
                    writableMap.putString("serialNumber", serialNumberAndModules[0]);
                    String[] modules = serialNumberAndModules[1].split(",");
                    WritableArray array = Arguments.fromArray(modules);
                    writableMap.putArray("modulesArray", array);
                }
                inputStream.close();
                promise.resolve(writableMap);
            }
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 初始化试用许可的路径
     *
     * @param promise
     */
    @ReactMethod
    public void initTrailLicensePath(Promise promise) {
        try {

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 登记购买
     *
     * @param moduleCode 模块编号
     * @param userName   用户昵称
     * @param promise
     */
    @ReactMethod
    public void licenseBuyRegister(int moduleCode, String userName, final Promise promise) {
        try {
            Map<String, String> map = new HashMap<>();
            map.put("ANDROID_LICENSE_BUY_REGISTER_USER_NAME", userName);
            map.put("ANDROID_LICENSE_BUY_REGISTER_MODULE_CODE", moduleCode + "");
            //上传数据
            LogInfoService.sendAPPLogInfo(map, context, new LogInfoService.SendAppInfoListener() {
                @Override
                public void result(boolean result) {
                    promise.resolve(result);
                }
            });
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /**
     * 地图转XML
     * @param promise
     */
    @ReactMethod
    public void mapToXml(Promise promise) {
        try {
            String xml = SMap.getInstance().getSmMapWC().getMapControl().getMap().toXML();
            promise.resolve(xml);
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    /**
     * XML转地图
     * @param xml
     * @param promise
     */
    @ReactMethod
    public void mapFromXml(String xml, Promise promise) {
        try {
            boolean result = SMap.getInstance().getSmMapWC().getMapControl().getMap().fromXML(xml);
            if (result) {
                SMap.getInstance().getSmMapWC().getMapControl().getMap().refresh();
            }
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    public interface OneArg<T> {
        void handle(T arg);
    }

    public OneArg<ArrayList<Module>> queryHandler;
    public OneArg<JSONArray> queryCountHandler;
    public OneArg<Boolean> recycleHandler;
    public OneArg<Boolean> activateHandler;
    RecycleLicenseManager.RecycleLicenseCallback licenseCallback = new RecycleLicenseManager.RecycleLicenseCallback() {
        @Override
        public void success(LicenseStatus licenseStatus) {
            Log.i("LicenseStatus", "LicenseStatus");
            if (recycleHandler != null) {
                recycleHandler.handle(true);
                recycleHandler = null;
            }
            if (activateHandler != null) {
                activateHandler.handle(true);
                activateHandler = null;
            }
        }

        @Override
        public void activateFailed(String s) {
            Log.i("activateFailed", "activateFailed");
            if (activateHandler != null) {
                activateHandler.handle(false);
                activateHandler = null;
            }
        }

        @Override
        public void recycleLicenseFailed(String s) {
            if (recycleHandler != null) {
                recycleHandler.handle(false);
                recycleHandler = null;
            }
        }

        @Override
        public void bindPhoneNumberFailed(String s) {

        }

        @Override
        public void upgradeFailed(String s) {

        }

        @Override
        public void queryResult(ArrayList<Module> arrayList) {
            if (queryHandler != null) {
                queryHandler.handle(arrayList);
                queryHandler = null;
            }

        }

        @Override
        public void queryLicenseCount(JSONArray jsonArray) {
            if (queryCountHandler != null) {
                queryCountHandler.handle(jsonArray);
                queryCountHandler = null;
            }
        }

        @Override
        public void otherErrors(String s) {
            Log.i("otherErrors", s);
            if (activateHandler != null) {
                activateHandler.handle(false);
                activateHandler = null;
            }
            if (recycleHandler != null) {
                recycleHandler.handle(false);
                recycleHandler = null;
            }
            if (queryHandler != null) {
                ArrayList<Module> arrayList = null;
                queryHandler.handle(arrayList);
                queryHandler = null;
            }
        }
    };


    /*******************************************许可配制 END************************************/
}
