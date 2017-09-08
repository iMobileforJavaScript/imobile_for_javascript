import { NativeModules } from 'react-native';
let Action = NativeModules.JSAction;
let BufferEndType = NativeModules.JSBufferEndType;
let RadiusUnit = NativeModules.JSRadiusUnit;
let EncodeType = NativeModules.JSEncodeType;
let DatasetType = NativeModules.JSDatasetType;

import BufferAnalyst from './NativeModule/BufferAnalyst.js';
import BufferAnalystGeometry from './NativeModule/BufferAnalystGeometry.js';
import BufferAnalystParameter from './NativeModule/BufferAnalystParameter.js';
import Callout from './NativeModule/CallOut.js'
import CursorType from './NativeModule/CursorType.js';
import DataDownloadService from './NativeModule/DataDownloadService.js';
import Dataset from './NativeModule/Dataset.js';
import DatasetVector from './NativeModule/DatasetVector.js';
import DatasetVectorInfo from './NativeModule/DatasetVectorInfo.js';
import Datasource from './NativeModule/Datasource.js';
import DatasourceConnectionInfo from './NativeModule/DatasourceConnectionInfo.js';
import DataUploadService from './NativeModule/DataUploadService.js';
import GeoLine from './NativeModule/GeoLine.js';
import Geometry from './NativeModule/Geometry.js';
import GeoPoint from './NativeModule/GeoPoint.js';
import GeoRegion from './NativeModule/GeoRegion.js';
import GeoStyle from './NativeModule/GeoStyle.js';
import Feature from './NativeModule/Feature.js';
import FeatureSet from './NativeModule/FeatureSet.js';
import Layer from './NativeModule/Layer.js';
import LayerSetting from './NativeModule/LayerSetting.js';
import LayerSettingVector from './NativeModule/LayerSettingVector.js';
import LocationManager from './NativeModule/LayerSetting.js';
import Map from './NativeModule/Map.js';
import MapControl from './NativeModule/MapControl.js';
import MapView from './NativeModule/MapView.js';
import Navigation2 from './NativeModule/IndustryNavi.js';
import OverlayAnalyst from './NativeModule/OverlayAnalyst.js';
import OverlayAnalystParameter from './NativeModule/OverlayAnalystParameter.js';
import Point from './NativeModule/Point.js';
import Point2D from './NativeModule/Point2D.js';
import PrjCoordSys from './NativeModule/PrjCoordSys.js';
import QueryParameter from './NativeModule/QueryParameter.js';
import QueryService from './NativeModule/QueryService.js';
import Rectangle2D from './NativeModule/Rectangle2D.js';
import Scene from './NativeModule/Scene.js';
import SceneControl from './NativeModule/SceneControl.js';
import Selection from './NativeModule/Selection.js';
import ServiceBase from './NativeModule/ServiceBase.js';
import ServiceQueryParameter from './NativeModule/ServiceQueryParameter.js';
import Size2D from './NativeModule/Size2D.js';
import Track from './NativeModule/Track.js';
import TrackingLayer from './NativeModule/TrackingLayer.js';
import TraditionalNavi from './NativeModule/TraditionalNavi.js';
import Workspace from './NativeModule/Workspace.js';
import WorkspaceConnectionInfo from './NativeModule/WorkspaceConnectionInfo.js';

import ChartData from './NativeModule/ChartData.js';
import ChartView from './NativeModule/ChartView.js';
import ChartPoint from './NativeModule/ChartPoint.js';
import ChartLegend from './NativeModule/ChartLegend.js';
import ColorScheme from './NativeModule/ColorScheme.js';
import BarChartData from './NativeModule/BarChartData.js';
import BarChartDataItem from './NativeModule/BarChartDataItem.js';
import LineChartData from './NativeModule/LineChartData.js';
import PieChartData from './NativeModule/PieChartData.js';
import HotChart from './NativeModule/HotChart.js';
import GridHotChart from './NativeModule/GridHotChart.js';
import PointDensityChart from './NativeModule/PointDensityChart.js';
import PolymerChart from './NativeModule/PolymerChart.js';
import RelationalPointChart from './NativeModule/RelationalPointChart.js';

import AMQPManager from './NativeModule/AMQPManager.js';
import AMQPReceiver from './NativeModule/AMQPReceiver.js';
import AMQPSender from './NativeModule/AMQPSender.js';
import STOMPManager from './NativeModule/STOMPManager.js';
import STOMPReceiver from './NativeModule/STOMPReceiver.js';
import STOMPSender from './NativeModule/STOMPSender.js';
import MQTTClientSide from './NativeModule/MQTTClientSide.js';

import Utility from './NativeModule/utility/utility.js';

import SMMapView from './NativeModule/components/SMMapViewUI.js';
import SMLayerListView from './NativeModule/components/SMLayerListViewUI.js';
import SMLegendView from './NativeModule/components/SMLegendViewUI.js';
import SMScaleView from './NativeModule/components/SMScaleViewUI.js';
import SMSceneView from './NativeModule/components/SMSceneViewUI.js';
import SMPlotView from './NativeModule/components/SMPlotViewUI.js';
import SMSearchView from './NativeModule/components/SMSearchViewUI.js';
import SMBarChartView from './NativeModule/components/SMBarChartViewUI.js';
import SMLineChartView from './NativeModule/components/SMLineChartViewUI.js';
import SMPieChartView from './NativeModule/components/SMPieChartViewUI.js';
import SMInstrumentChartView from './NativeModule/components/SMInstrumentChartViewUI.js';
import SMWorkspaceManagerView from './NativeModule/components/SMWorkspaceManagerComponent.js';


/*
import Datasets from './NativeModule/Datasets.js';
import Datasources from './NativeModule/Datasources.js';
import Layers from './NativeModule/Layers.js';
import Maps from './NativeModule/Maps.js';
import Recordset from './NativeModule/Recordset.js';
*/
export {
    SMMapView,
    SMLayerListView,
    SMLegendView,
    SMScaleView,
    SMSceneView,
    SMPlotView,
    SMSearchView,
    SMWorkspaceManagerView,
    
    Utility,
    
    AMQPManager,
    AMQPReceiver,
    AMQPSender,
    STOMPManager,
    STOMPReceiver,
    STOMPSender,
    MQTTClientSide,
    
    SMBarChartView,
    SMLineChartView,
    SMPieChartView,
    SMInstrumentChartView,
    ChartData,
    ChartView,
    ChartPoint,
    ChartLegend,
    ColorScheme,
    BarChartData,
    BarChartDataItem,
    LineChartData,
    PieChartData,
    HotChart,
    GridHotChart,
    PointDensityChart,
    PolymerChart,
    RelationalPointChart,
    
    Action,
    BufferEndType,
    RadiusUnit,
    EncodeType,
    DatasetType,
    
    BufferAnalyst,
    BufferAnalystGeometry,
    BufferAnalystParameter,
    Callout,
    CursorType,
    DataDownloadService,
    Dataset,
    DatasetVector,
    DatasetVectorInfo,
    Datasource,
    DatasourceConnectionInfo,
    DataUploadService,
    Feature,
    FeatureSet,
    GeoLine,
    Geometry,
    GeoPoint,
    GeoRegion,
    GeoStyle,
    Layer,
    LayerSetting,
    LayerSettingVector,
    LocationManager,
    Map,
    MapControl,
    MapView,
    Navigation2,
    OverlayAnalyst,
    OverlayAnalystParameter,
    Point,
    Point2D,
    PrjCoordSys,
    QueryParameter,
    QueryService,
    Rectangle2D,
    Selection,
    ServiceBase,
    ServiceQueryParameter,
    Size2D,
    Track,
    TrackingLayer,
    Workspace,
    WorkspaceConnectionInfo,
    
    /*
    Datasets,
    Datasources,
    Layers,
    Maps,
    Recordset,
     */
};
