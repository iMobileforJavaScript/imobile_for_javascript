package com.supermap.rnsupermap;

import android.os.Handler;
import android.os.Looper;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapView;
import com.supermap.mapping.ScaleView;

/**
 * Created by will on 2016/9/30.
 */

public class ScaleViewManager extends SimpleViewManager<ScaleView> {
    public static final String REACT_NAME="RCTScaleView";
    ThemedReactContext m_ThemeReactContext;

    @Override
    public String getName(){return REACT_NAME;}

    @Override
    public ScaleView createViewInstance(ThemedReactContext reactContext){
        ScaleView scaleView = new ScaleView(reactContext);
        return scaleView;
    }

    @ReactProp(name="mapControlId")
    public void setMapControlId(final ScaleView view,final String mapCtrId){
        MapControl mapCtr = JSMapControl.getObjFromList(mapCtrId);
        Map map = mapCtr.getMap();
        MapView mapView = map.getMapView();
        view.setMapView(mapView);
    }
}
