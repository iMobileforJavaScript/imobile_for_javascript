package com.supermap.rnsupermap;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by will on 2016/6/15.
 */
public class SupermapFullPackage implements ReactPackage {
    @Override
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
                new MapViewManager(),new LegendViewManager(),
                new LayerListViewManager(),new ScaleViewManager(),new CallOutManager()
                ,new SceneViewManager()
        );
    }

    @Override
    public List<NativeModule> createNativeModules(
            ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new JSCallOut(reactContext));
        modules.add(new JSDataset(reactContext));
        modules.add(new JSDatasets(reactContext));
        modules.add(new JSDatasource(reactContext));
        modules.add(new JSDatasources(reactContext));
        modules.add(new JSDatasetVector(reactContext));
        modules.add(new JSDatasourceConnectionInfo(reactContext));
        modules.add(new JSDataDownloadService(reactContext));
        modules.add(new JSDataUploadService(reactContext));
        modules.add(new JSFeature(reactContext));
        modules.add(new JSFeatureSet(reactContext));
        modules.add(new JSLayers(reactContext));
        modules.add(new JSLayer(reactContext));
        modules.add(new JSLayerSetting(reactContext));
        modules.add(new JSLayerSettingVector(reactContext));
        modules.add(new JSLocationManager(reactContext));
        modules.add(new JSMap(reactContext));
        modules.add(new JSMaps(reactContext));
        modules.add(new JSMapControl(reactContext));
        modules.add(new JSWorkspace(reactContext));
        modules.add(new JSMapView(reactContext));
        modules.add(new JSWorkspaceConnectionInfo(reactContext));
        modules.add(new JSNavigation(reactContext));
        modules.add(new JSNavigation2(reactContext));
        modules.add(new JSOverlayAnalyst(reactContext));
        modules.add(new JSOverlayAnalystParameter(reactContext));
        modules.add(new JSPoint(reactContext));
        modules.add(new JSPoint2D(reactContext));
        modules.add(new JSQueryParameter(reactContext));
        modules.add(new JSRectangle2D(reactContext));
        modules.add(new JSRecordset(reactContext));
        modules.add(new JSSelection(reactContext));
        modules.add(new JSSize2D(reactContext));
        modules.add(new JSServiceBase(reactContext));
        modules.add(new JSScene(reactContext));
        modules.add(new JSSceneControl(reactContext));
        modules.add(new JSSystemUtil(reactContext));
        modules.add(new JSGeoStyle(reactContext));
        modules.add(new JSGeometry(reactContext));
        modules.add(new JSGeoLine(reactContext));
        modules.add(new JSGeoPoint(reactContext));
        modules.add(new JSGeoRegion(reactContext));
        modules.add(new JSTheme(reactContext));
        modules.add(new JSTrack(reactContext));
        modules.add(new JSTrackingLayer(reactContext));
        modules.add(new JSBufferAnalyst(reactContext));
        modules.add(new JSBufferAnalystParameter(reactContext));
        modules.add(new JSBufferAnalystGeometry(reactContext));
        modules.add(new JSDatasetVectorInfo(reactContext));

        modules.add(new JSAMQPManager(reactContext));
        modules.add(new JSAMQPSender(reactContext));
        modules.add(new JSAMQPReceiver(reactContext));
        modules.add(new JSSTOMPManager(reactContext));
        modules.add(new JSSTOMPSender(reactContext));
        modules.add(new JSSTOMPReceiver(reactContext));
        modules.add(new JSMQTTClientSide(reactContext));

        return modules;
    }
}
