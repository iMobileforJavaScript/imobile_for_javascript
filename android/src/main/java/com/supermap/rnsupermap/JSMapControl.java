package com.supermap.rnsupermap;

import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Handler;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.RNUtils.N_R_EventSender;
import com.supermap.data.Enum;
import com.supermap.data.GeoLine;
import com.supermap.data.GeoPoint;
import com.supermap.data.GeoRegion;
import com.supermap.data.Geometry;
import com.supermap.data.Point;
import com.supermap.data.Point2D;
import com.supermap.mapping.Action;
import com.supermap.mapping.ActionChangedListener;
import com.supermap.mapping.ConfigurationChangedListener;
import com.supermap.mapping.EditStatusListener;
import com.supermap.mapping.FinishEditedEvent;
import com.supermap.mapping.GeometryAddedListener;
import com.supermap.mapping.GeometryDeletedListener;
import com.supermap.mapping.GeometryDeletingListener;
import com.supermap.mapping.GeometryEvent;
import com.supermap.mapping.GeometryModifiedListener;
import com.supermap.mapping.GeometryModifyingListener;
import com.supermap.mapping.GeometrySelectedEvent;
import com.supermap.mapping.GeometrySelectedListener;
import com.supermap.mapping.Layer;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapParameterChangedListener;
import com.supermap.mapping.MapView;
import com.supermap.mapping.MeasureListener;
import com.supermap.mapping.RefreshListener;
import com.supermap.mapping.UndoStateChangeListener;
import com.supermap.mapping.collector.Collector;
import com.supermap.navi.Navigation;
import com.supermap.navi.Navigation2;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by will on 2016/6/16.
 */
public class JSMapControl extends ReactContextBaseJavaModule {

    private static Map<String, MapControl> mapControlList = new HashMap<String, MapControl>();
    private static String mSTine;
    private MapControl mMapControl;
    private Navigation2 mNavigation2;
    ReactContext mReactContext;

    private static final String TEMP_FILE_PREFIX = "iTabletImage";

    private static final String BOUNDSCHANGED = "Supermap.MapControl.MapParamChanged.BoundsChanged";
    private static final String SCALECHANGED = "Supermap.MapControl.MapParamChanged.ScaleChanged";
    private static final String ANGLECHANGED = "Supermap.MapControl.MapParamChanged.AngleChanged";
    private static final String SIZECHANGED = "Supermap.MapControl.MapParamChanged.SizeChanged";
    private static final String TOHORIZONTALSCREEN = "com.supermap.RN.Mapcontrol.to_horizontal_screen";
    private static final String TOVERTICALSCREEN = "com.supermap.RN.Mapcontrol.to_verticalscreen";


    private static final String LONGPRESS_EVENT = "com.supermap.RN.Mapcontrol.long_press_event";
    private static final String SCROLL_EVENT = "com.supermap.RN.Mapcontrol.scroll_event";
    private static final String TOUCH_BEGAN_EVENT = "com.supermap.RN.Mapcontrol.touch_began_event";
    private static final String TOUCH_END_EVENT = "com.supermap.RN.Mapcontrol.touch_end_event";
    private static final String SINGLE_TAP_EVENT = "com.supermap.RN.Mapcontrol.single_tap_event";
    private static final String DOUBLE_TAP_EVENT = "com.supermap.RN.Mapcontrol.double_tap_event";

    private static final String ACTION_CHANGE = "com.supermap.RN.Mapcontrol.action_change";
    private static final String GEOMETRYDELETED = "com.supermap.RN.Mapcontrol.geometry_deleted";
    private static final String REFRESH_EVENT = "com.supermap.RN.Mapcontrol.refresh_event";
    private static final String GEOMETRYADDED = "com.supermap.RN.Mapcontrol.grometry_added";
    private static final String GEOMETRYDELETING = "com.supermap.RN.Mapcontrol.geometry_deleting";
    private static final String GEOMETRYMODIFIED = "com.supermap.RN.Mapcontrol.geometry_modified";
    private static final String GEOMETRYMODIFYING = "com.supermap.RN.Mapcontrol.geometry_modifying";
    private static final String GEOMETRYSELECTED = "com.supermap.RN.Mapcontrol.geometry_selected";
    private static final String GEOMETRYMULTISELECTED = "com.supermap.RN.Mapcontrol.geometry_multi_selected";
    private static final String LENGTHMEASURED = "com.supermap.RN.Mapcontrol.length_measured";
    private static final String AREAMEASURED = "com.supermap.RN.Mapcontrol.area_measured";
    private static final String ANGLEMEASURED = "com.supermap.RN.Mapcontrol.angle_measured";
    private static final String UNDOSTATECHANGE = "com.supermap.RN.Mapcontrol.undo_state_change";
    private static final String ADDNODEENABLE = "com.supermap.RN.Mapcontrol.add_node_enable";
    private static final String DELETENODEENABLE = "com.supermap.RN.Mapcontrol.delete_node_enable";

//    private static final String TOUCH_UP_EVENT = "com.supermap.RN.Mapcontrol.touch_up";

    //    Listeners
    private ActionChangedListener mActionChangedListener;
    private RefreshListener mRefreshListener;
    private MapParameterChangedListener mMapParamChangedListener;
    private GestureDetector mGestureDetector;
    private GeometryDeletedListener mGeometryDeleted;
    private GeometryAddedListener mGeometryAdded;
    private GeometryDeletingListener mGeometryDeletingListener;
    private GeometryModifiedListener mGeometryModifiedListener;
    private GeometryModifyingListener mGeometryModifyingListener;
    private GeometrySelectedListener mGeometrySelectedListener;
    private MeasureListener mMeasureListener;
    private UndoStateChangeListener mUndoStateChangeListener;
    private EditStatusListener mEditStatusListener;
    private View.OnTouchListener mTouchListener;

    @Override
    public String getName() {
        return "JSMapControl";
    }

    public JSMapControl(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
    }

//    public static String registerId(MapControl mapControl) {
//        for (Map.Entry entry : mapControlList.entrySet()) {
//            if (mapControl.equals(entry.getValue())) {
//                return (String) entry.getKey();
//            }
//        }
//        Calendar calendar = Calendar.getInstance();
//        String id = Long.toString(calendar.getTimeInMillis());
//        mapControlList.put(id, mapControl);
//        return id;
//    }

    public static MapControl getObjFromList(String id) {
        return mapControlList.get(id);
    }

    public static void removeObjFromList(String id) {
        mapControlList.remove(id);
    }

    @ReactMethod
    public void getMap(Promise promise) {
        try {
            MapControl mapControl = JSMapView.getMapControl();
            com.supermap.mapping.Map map = mapControl.getMap();

//            写入map及其ID，返回ID，如果已经map已经存在，返回已存在的Id
            String mapId = JSMap.registerId(map);

            WritableMap rtnMap = Arguments.createMap();
            rtnMap.putString("mapId", mapId);
            promise.resolve(rtnMap);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 监听编辑行为的变更事件
     *
     * @param promise      JS层的promise对象
     */
    @ReactMethod
    public void addActionChangedListener(Promise promise) {
        try {
            mActionChangedListener = new ActionChangedListener() {
                @Override
                public void actionChanged(Action action, Action action1) {
                    N_R_EventSender n_r_eventSender = new N_R_EventSender();
                    n_r_eventSender.putString("newAction", action.name());
                    n_r_eventSender.putString("oldAction", action1.name());
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(ACTION_CHANGE, n_r_eventSender.createSender());
                }
            };
            MapControl mapControl = JSMapView.getMapControl();
            mapControl.addActionChangedListener(mActionChangedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeActionChangedListener(Promise promise) {
        try {
            MapControl mapControl = JSMapView.getMapControl();
            mapControl.removeActionChangedListener(mActionChangedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
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
            mGestureDetector = new GestureDetector(mReactContext, new GestureDetector.SimpleOnGestureListener() {

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


                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(SCROLL_EVENT, map);
                    return false;
                }

                public boolean onDown(MotionEvent event) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) event.getX());
                    map.putInt("y", (int) event.getY());

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(TOUCH_BEGAN_EVENT, map);
                    return false;
                }

                public boolean onSingleTapUp(MotionEvent e) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) e.getX());
                    map.putInt("y", (int) e.getY());

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(TOUCH_END_EVENT, map);
                    return false;
                }

                public void onLongPress(MotionEvent event) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) event.getX());
                    map.putInt("y", (int) event.getY());

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(LONGPRESS_EVENT, map);
                }

                public boolean onSingleTapConfirmed(MotionEvent e) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) e.getX());
                    map.putInt("y", (int) e.getY());

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(SINGLE_TAP_EVENT, map);
                    return false;
                }

                public boolean onDoubleTap(MotionEvent e) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) e.getX());
                    map.putInt("y", (int) e.getY());

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(DOUBLE_TAP_EVENT, map);
                    return false;
                }
            });
            MapControl mapControl = JSMapView.getMapControl();
            mapControl.setGestureDetector(mGestureDetector);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public void deleteCurrentGeometry(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            boolean deleted = mMapControl.deleteCurrentGeometry();

            WritableMap map = Arguments.createMap();
            map.putBoolean("deleted", deleted);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 监听原生map刷新事件
     *
     * @param promise
     */
    @ReactMethod
    public void setRefreshListener(Promise promise) {
        try {
            mRefreshListener = new RefreshListener() {
                @Override
                public void mapRefresh() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(REFRESH_EVENT, null);
                }
            };
            MapControl mapControl = JSMapView.getMapControl();
            mapControl.setRefreshListener(mRefreshListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setAction(int actionType, Promise promise) {
        try {
            MapControl mapControl = JSMapView.getMapControl();
            mapControl.setAction((Action) Enum.parse(Action.class, actionType));
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void submit(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            Boolean b = mMapControl.submit();

            promise.resolve(b);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getNavigation2(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mNavigation2 = mMapControl.getNavigation2();
//            getCurrentActivity().runOnUiThread(updateThread);
            String navigation2Id = JSNavigation2.registerId(mNavigation2);

            WritableMap map = Arguments.createMap();
            map.putString("navigation2Id", navigation2Id);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 监听地图参数变化
     *
     * @param promise
     */
    @ReactMethod
    public void setMapParamChangedListener(Promise promise) {
        try {
            mMapParamChangedListener = new MapParameterChangedListener() {

                @Override
                public void scaleChanged(double v) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("scale", v);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(BOUNDSCHANGED, map);
                }

                @Override
                public void boundsChanged(Point2D point2D) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("x", (int) point2D.getX());
                    map.putInt("y", (int) point2D.getY());
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(SCALECHANGED, map);
                }

                @Override
                public void angleChanged(double v) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("angle", v);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(ANGLECHANGED, map);
                }

                @Override
                public void sizeChanged(int i, int i1) {
                    WritableMap map = Arguments.createMap();
                    map.putInt("width", i);
                    map.putInt("height", i1);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(SIZECHANGED, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.setMapParamChangedListener(mMapParamChangedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getCurrentGeometry(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            Geometry geometry = mMapControl.getCurrentGeometry();
            String geometryId = JSGeometry.registerId(geometry);

            WritableMap map = Arguments.createMap();
            map.putString("geometryId", geometryId);

            String type = "";
            if (geometry instanceof GeoPoint) {
                type = "GeoPoint";
            } else if (geometry instanceof GeoLine) {
                type = "GeoLine";
            } else if (geometry instanceof GeoRegion) {
                type = "GeoRegion";
            }
            map.putString("geoType", type);

            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setConfigurationChangedListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.setConfigurationChangedListener(new ConfigurationChangedListener() {
                @Override
                public void toHorizontalScreen() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(TOHORIZONTALSCREEN, null);
                }

                @Override
                public void toVerticalScreen() {
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(TOVERTICALSCREEN, null);
                }
            });

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getTraditionalNavi(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            Navigation traditionalNavi = mMapControl.getNavigation();
            String traditionalNaviId = JSNavigation.registerId(traditionalNavi);

            WritableMap map = Arguments.createMap();
            map.putString("traditionalNaviId", traditionalNaviId);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getAction(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            Action action = mMapControl.getAction();
            int actionType = Enum.getValueByName(Action.class, action.toString());

            WritableMap map = Arguments.createMap();
            map.putInt("actionType", actionType);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void redo(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            boolean redone = mMapControl.redo();

            WritableMap map = Arguments.createMap();
            map.putBoolean("redone", redone);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void undo(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            boolean undone = mMapControl.undo();

            WritableMap map = Arguments.createMap();
            map.putBoolean("undone", undone);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void cancel(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            boolean canceled = mMapControl.cancel();

            WritableMap map = Arguments.createMap();
            map.putBoolean("canceled", canceled);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }


    @ReactMethod
    public void getEditLayer(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            Layer layer = mMapControl.getEditLayer();
            String layerId = JSLayer.registerId(layer);

            WritableMap map = Arguments.createMap();
            map.putString("layerId", layerId);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteGestureDetector(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.deleteGestureDetector();

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addGeometryDeletedListener(Promise promise) {
        try {
            mGeometryDeleted = new GeometryDeletedListener() {
                @Override
                public void geometryDeleted(GeometryEvent event) {
                    boolean canceled = event.getCancel();
                    int id = event.getID();
                    Layer layer = event.getLayer();
                    String layerId = JSLayer.registerId(layer);

                    WritableMap map = Arguments.createMap();
                    map.putString("layerId", layerId);
                    map.putInt("id", id);
                    map.putBoolean("canceled", canceled);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(GEOMETRYDELETED, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addGeometryDeletedListener(mGeometryDeleted);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometryDeletedListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeGeometryDeletedListener(mGeometryDeleted);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addGeometryAddedListener(Promise promise) {
        try {
            mGeometryAdded = new GeometryAddedListener() {
                @Override
                public void geometryAdded(GeometryEvent event) {

                    boolean canceled = event.getCancel();
                    int id = event.getID();
                    Layer layer = event.getLayer();
                    String layerId = JSLayer.registerId(layer);

                    WritableMap map = Arguments.createMap();
                    map.putString("layerId", layerId);
                    map.putInt("id", id);
                    map.putBoolean("canceled", canceled);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(GEOMETRYADDED, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addGeometryAddedListener(mGeometryAdded);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometryAddedListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeGeometryAddedListener(mGeometryAdded);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addGeometryDeletingListener(Promise promise) {
        try {
            mGeometryDeletingListener = new GeometryDeletingListener() {
                @Override
                public void geometryDeleting(GeometryEvent event) {
                    boolean canceled = event.getCancel();
                    int id = event.getID();
                    Layer layer = event.getLayer();
                    String layerId = JSLayer.registerId(layer);

                    WritableMap map = Arguments.createMap();
                    map.putString("layerId", layerId);
                    map.putInt("id", id);
                    map.putBoolean("canceled", canceled);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(GEOMETRYDELETING, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addGeometryDeletingListener(mGeometryDeletingListener);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometryDeletingListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeGeometryDeletingListener(mGeometryDeletingListener);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addGeometryModifiedListener(Promise promise) {
        try {
            mGeometryModifiedListener = new GeometryModifiedListener() {
                @Override
                public void geometryModified(GeometryEvent event) {
                    boolean canceled = event.getCancel();
                    int id = event.getID();
                    Layer layer = event.getLayer();
                    String layerId = JSLayer.registerId(layer);

                    WritableMap map = Arguments.createMap();
                    map.putString("layerId", layerId);
                    map.putInt("id", id);
                    map.putBoolean("canceled", canceled);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(GEOMETRYMODIFIED, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addGeometryModifiedListener(mGeometryModifiedListener);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometryModifiedListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeGeometryModifiedListener(mGeometryModifiedListener);

            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addGeometryModifyingListener(Promise promise) {
        try {
            mGeometryModifyingListener = new GeometryModifyingListener() {
                @Override
                public void geometryModifying(GeometryEvent event) {
                    boolean canceled = event.getCancel();
                    int id = event.getID();
                    Layer layer = event.getLayer();
                    String layerId = JSLayer.registerId(layer);

                    WritableMap map = Arguments.createMap();
                    map.putString("layerId", layerId);
                    map.putInt("id", id);
                    map.putBoolean("canceled", canceled);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(GEOMETRYMODIFYING, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addGeometryModifyingListener(mGeometryModifyingListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometryModifyingListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.addGeometryModifyingListener(mGeometryModifyingListener);
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
                    String layerId = JSLayer.registerId(layer);

                    WritableMap map = Arguments.createMap();
                    map.putString("layerId", layerId);
                    map.putInt("id", id);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(GEOMETRYSELECTED, map);
                }

                @Override
                public void geometryMultiSelected(ArrayList<GeometrySelectedEvent> events) {
                    WritableArray array = Arguments.createArray();
                    for (int i = 0; i < events.size(); i++) {
                        GeometrySelectedEvent event = events.get(i);
                        int id = event.getGeometryID();
                        Layer layer = event.getLayer();
                        String layerId = JSLayer.registerId(layer);

                        WritableMap map = Arguments.createMap();
                        map.putString("layerId", layerId);
                        map.putInt("id", id);
                        array.pushMap(map);
                    }

                    WritableMap geometries = Arguments.createMap();
                    geometries.putArray("geometries", array);
                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(GEOMETRYMULTISELECTED, geometries);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addGeometrySelectedListener(mGeometrySelectedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeGeometrySelectedListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeGeometrySelectedListener(mGeometrySelectedListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addMeasureListener(Promise promise) {
        try {
            mMeasureListener = new MeasureListener() {
                @Override
                public void lengthMeasured(double curResult, Point curPoint) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curResult", curResult);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(LENGTHMEASURED, map);
                }

                @Override
                public void areaMeasured(double curResult, Point curPoint) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curResult", curResult);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(AREAMEASURED, map);
                }

                @Override
                public void angleMeasured(double curAngle, Point curPoint) {
                    WritableMap map = Arguments.createMap();
                    map.putDouble("curAngle", curAngle);
                    WritableMap point = Arguments.createMap();
                    point.putDouble("x", curPoint.getX());
                    point.putDouble("y", curPoint.getY());
                    map.putMap("curPoint", point);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(ANGLEMEASURED, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addMeasureListener(mMeasureListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeMeasureListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeMeasureListener(mMeasureListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addUndoStateChangeListener(Promise promise) {
        try {
            mUndoStateChangeListener = new UndoStateChangeListener() {
                @Override
                public void undoStateChange(boolean canUndo, boolean canRedo) {
                    WritableMap map = Arguments.createMap();
                    map.putBoolean("canUndo", canUndo);
                    map.putBoolean("canRedo", canRedo);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(UNDOSTATECHANGE, map);
                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.addUndoStateChangeListener(mUndoStateChangeListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeUndoStateChangeListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeUndoStateChangeListener(mUndoStateChangeListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setEditStatusListener(Promise promise) {
        try {
            mEditStatusListener = new EditStatusListener() {
                @Override
                public void addNodeEnable(boolean isEnable) {
                    WritableMap map = Arguments.createMap();
                    map.putBoolean("isEnable", isEnable);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(ADDNODEENABLE, map);
                }

                @Override
                public void deleteNodeEnable(boolean isEnable) {
                    WritableMap map = Arguments.createMap();
                    map.putBoolean("isEnable", isEnable);

                    mReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(DELETENODEENABLE, map);
                }


                @Override
                public void beforeFinishGeometryEdited(FinishEditedEvent finishEditedEvent) {

                }

                @Override
                public void finishGeometryEdited(FinishEditedEvent finishEditedEvent) {

                }
            };
            mMapControl = JSMapView.getMapControl();
            mMapControl.setEditStatusListener(mEditStatusListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removeEditStatusListener(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removeEditStatusListener(mEditStatusListener);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void addPlotLibrary(final String url, final Promise promise) {
        try {
            Handler plotHandler = new Handler();
            plotHandler.post(new Runnable() {
                @Override
                public void run() {
                    mMapControl = JSMapView.getMapControl();
                    int libId = (int) mMapControl.addPlotLibrary(android.os.Environment.getExternalStorageDirectory().getAbsolutePath() + url);
                    promise.resolve(libId);
                }
            });
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void removePlotLibrary(long libId, Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.removePlotLibrary(libId);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);

        }
    }

    @ReactMethod
    public void setPlotSymbol(int libId, int symbolCode, Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            mMapControl.setPlotSymbol(libId, symbolCode);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);

        }
    }

    @ReactMethod
    public void getCollector(Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            Collector collector = mMapControl.getCollector();
            String id = JSCollector.registerId(collector);
            promise.resolve(id);
        } catch (Exception e) {
            promise.reject(e);

        }
    }

    /**
     * 指定编辑几何对象
     *
     * @param GeoID
     * @param layerId
     * @param promise
     */
    @ReactMethod
    public void appointEditGeometry(int GeoID, String layerId, Promise promise) {
        try {
            mMapControl = JSMapView.getMapControl();
            Layer layer = JSLayer.getLayer(layerId);
            boolean result = mMapControl.appointEditGeometry(GeoID, layer);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

//    /**
//     * 释放对象
//     *
//     * @param mapControlId
//     * @param promise
//     */
//    @ReactMethod
//    public void dispose(Promise promise) {
//        try {
////            mMapControl = JSMapView.getMapControl();
////            mMapControl.dispose();
////            removeObjFromList(mapControlId);
////
////            promise.resolve(true);
//            getCurrentActivity().runOnUiThread(new DisposeThread(mapControlId, promise));
//
//        } catch (Exception e) {
//            promise.reject(e);
//        }
//    }
//
//    class DisposeThread implements Runnable {
//
//        private String mapControlId;
//        private Promise promise;
//
//        public DisposeThread(Promise promise) {
//            this.promise = promise;
//        }
//
//        @Override
//        public void run() {
//            try {
//                JSMapView.disposeMapControl();
//                mMapControl = null;
//                promise.resolve(true);
//            } catch (Exception e) {
//                promise.resolve(e);
//            }
//        }
//    }

    /**
     * 将当前显示内容绘制到指定位图上
     *
     * @param width
     * @param height
     * @param quality
     * @param type
     * @param promise
     */
    @ReactMethod
    public void outputMap( int width, int height, int quality, String type, Promise promise) {
        try {
            getCurrentActivity().runOnUiThread(new OutputMapThread(width, height, quality, type, promise));

        } catch (Exception e) {
            promise.reject(e);
        }
    }

    class OutputMapThread implements Runnable {

        private int width;
        private int height;
        private int quality;
        private String type;
        private Promise promise;

        public OutputMapThread(int width, int height, int quality, String type, Promise promise) {
            this.width = width;
            this.height = height;
            this.quality = quality;
            this.type = type;
            this.promise = promise;
        }

        @Override
        public void run() {
            try {
                mMapControl = JSMapView.getMapControl();
                MapView mapView;
                int imgHeight = height;
                int imgWidth = width;

                mapView = JSMapView.getMapView();
                imgHeight = mapView.getHeight();
                imgWidth = mapView.getWidth();
                Bitmap bitmap = Bitmap.createBitmap(imgWidth, imgHeight, Bitmap.Config.ARGB_8888);
                boolean result = mMapControl.outputMap(bitmap);
                File externalCacheDir = getReactApplicationContext().getExternalCacheDir();
                File internalCacheDir = getReactApplicationContext().getCacheDir();
                File cacheDir;
                if (externalCacheDir == null && internalCacheDir == null) {
                    throw new IOException("No cache directory available");
                }
                if (externalCacheDir == null) {
                    cacheDir = internalCacheDir;
                } else if (internalCacheDir == null) {
                    cacheDir = externalCacheDir;
                } else {
                    cacheDir = externalCacheDir.getFreeSpace() > internalCacheDir.getFreeSpace() ?
                            externalCacheDir : internalCacheDir;
                }
                String suffix = ".png";
                File bitmapFile = File.createTempFile(TEMP_FILE_PREFIX, suffix, cacheDir);

                Bitmap.CompressFormat compressFormat;
                switch (type) {
                    case "jpeg":
                    case "jpg":
                        compressFormat = Bitmap.CompressFormat.JPEG;
                        break;
                    case "webp":
                        compressFormat = Bitmap.CompressFormat.WEBP;
                        break;
                    case "png":
                    default:
                        compressFormat = Bitmap.CompressFormat.PNG;
                        break;
                }
                FileOutputStream fos = new FileOutputStream(bitmapFile);
                bitmap.compress(compressFormat, quality, fos);
                fos.flush();
                fos.close();
                String uri = Uri.fromFile(bitmapFile).toString();

                WritableMap map = Arguments.createMap();

                map.putBoolean("result", result);
                map.putString("uri", uri);
                promise.resolve(map);
            } catch (Exception e) {
                promise.reject(e);
            }
        }
    }


    Runnable updateThread = new Runnable() {
        @Override
        public void run() {
            mNavigation2 = mMapControl.getNavigation2();
        }
    };

}
