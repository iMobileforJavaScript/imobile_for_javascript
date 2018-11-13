import { NativeModules } from 'react-native';
let Action = NativeModules.JSAction;//this is action 5.29
let BufferEndType = NativeModules.JSBufferEndType;
let RadiusUnit = NativeModules.JSRadiusUnit;
let EncodeType = NativeModules.JSEncodeType;
let DatasetType = NativeModules.JSDatasetType;
let FieldType = NativeModules.JSFieldType;
let TextAlignment = NativeModules.JSTextAlignment;
let SupplyCenterType = NativeModules.JSSupplyCenterType;
let PrjCoordSysType = NativeModules.JSPrjCoordSysType;
let CoordSysTransMethod = NativeModules.JSCoordSysTransMethod;
let RangeMode = NativeModules.JSRangeMode;
let ColorGradientType = NativeModules.JSColorGradientType;
let GPSElementType = NativeModules.JSGPSElementType;
let ThemeType = NativeModules.JSThemeType;
let WorkspaceType = NativeModules.JSWorkspaceType;
let SymbolType = NativeModules.JSSymbolType;

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
import GeoLineM from './NativeModule/GeoLineM.js';
import Geometry from './NativeModule/Geometry.js';
import GeoPoint from './NativeModule/GeoPoint.js';
import GeoRegion from './NativeModule/GeoRegion.js';
import GeoStyle from './NativeModule/GeoStyle.js';
import Feature from './NativeModule/Feature.js';
import FeatureSet from './NativeModule/FeatureSet.js';
import Layer from './NativeModule/Layer.js';
import LayerGroup from './NativeModule/LayerGroup.js';
import LayerSetting from './NativeModule/LayerSetting.js';
import LayerSettingVector from './NativeModule/LayerSettingVector.js';
import LocationManager from './NativeModule/LocationManager.js';
import Map from './NativeModule/Map.js';
import MapControl from './NativeModule/MapControl.js';
import MapView from './NativeModule/MapView.js';
import Navigation2 from './NativeModule/IndustryNavi.js';
import OverlayAnalyst from './NativeModule/OverlayAnalyst.js';
import OverlayAnalystParameter from './NativeModule/OverlayAnalystParameter.js';
import Point from './NativeModule/Point.js';
import Point2D from './NativeModule/Point2D.js';
import PointM from './NativeModule/PointM'
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

import Resoures from './NativeModule/Resources';
import Symbol from './NativeModule/Symbol';
import SymbolLibrary from './NativeModule/SymbolLibrary';
import SymbolFill from './NativeModule/SymbolFill';
import SymbolFillLibrary from './NativeModule/SymbolFillLibrary';
import SymbolLine from './NativeModule/SymbolLine';
import SymbolLineLibrary from './NativeModule/SymbolLineLibrary';
import SymbolMarker from './NativeModule/SymbolMarker';
import SymbolMarkerLibrary from './NativeModule/SymbolMarkerLibrary';
import SymbolGroup from './NativeModule/SymbolGroup';
import SymbolGroups from './NativeModule/SymbolGroups';

// import HotChart from './NativeModule/HotChart.js';
import GridHotChart from './NativeModule/GridHotChart.js';
import PointDensityChart from './NativeModule/PointDensityChart.js';
import PolymerChart from './NativeModule/PolymerChart.js';
import RelationalPointChart from './NativeModule/RelationalPointChart.js';
import RelationalChartPoint from './NativeModule/RelationalChartPoint.js';

import AMQPManager from './NativeModule/AMQPManager.js';
import AMQPReceiver from './NativeModule/AMQPReceiver.js';
import AMQPSender from './NativeModule/AMQPSender.js';
import STOMPManager from './NativeModule/STOMPManager.js';
import STOMPReceiver from './NativeModule/STOMPReceiver.js';
import STOMPSender from './NativeModule/STOMPSender.js';
import MQTTClientSide from './NativeModule/MQTTClientSide.js';

import Layer3Ds from './NativeModule/Layer3Ds';
import Layer3D from './NativeModule/Layer3D';
import Feature3D from './NativeModule/Feature3D';
import Feature3Ds from './NativeModule/Feature3Ds';
import Geometry3D from './NativeModule/Geometry3D';
import Point3D from './NativeModule/Point3D';
import Camera from './NativeModule/Camera';
import Layer3DOSGBFile from './NativeModule/Layer3DOSGBFile';

import FacilityAnalyst from './NativeModule/FacilityAnalyst'
import FacilityAnalystSetting from './NativeModule/FacilityAnalystSetting'
import WeightFieldInfo from './NativeModule/WeightFieldInfo'
import WeightFieldInfos from './NativeModule/WeightFieldInfos'
import TextPart from './NativeModule/TextPart'
import TextStyle from './NativeModule/TextStyle'
import GeoText from './NativeModule/GeoText'

import TransportationAnalystParameter from './NativeModule/TransportationAnalystParameter'
import TransportationAnalyst from './NativeModule/TransportationAnalyst'
import LocationAnalystParameter from './NativeModule/LocationAnalystParameter'
import SupplyCenter from './NativeModule/SupplyCenter'
import SupplyCenters from './NativeModule/SupplyCenters'
import TransportationAnalystSetting from './NativeModule/TransportationAnalystSetting'
import CoordSysTranslator from './NativeModule/CoordSysTranslator'
import CoordSysTransParameter from './NativeModule/CoordSysTransParameter'

import Utility from './NativeModule/utility/utility.js';

import SMMapView from './NativeModule/components/SMMapViewUI.js';
import SMCallOut from './NativeModule/components/SMCallOut.js';
import SMLayerListView from './NativeModule/components/SMLayerListViewUI.js';
import SMLegendView from './NativeModule/components/SMLegendViewUI.js';
import SMScaleView from './NativeModule/components/SMScaleViewUI.js';
import SMSceneView from './NativeModule/components/SMSceneViewUI.js';
import SMPlotView from './NativeModule/components/SMPlotViewUI.js';
// import SMSearchView from './NativeModule/components/SMSearchViewUI.js';
import SMBarChartView from './NativeModule/components/SMBarChartViewUI.js';
import SMLineChartView from './NativeModule/components/SMLineChartViewUI.js';
import SMPieChartView from './NativeModule/components/SMPieChartViewUI.js';
import SMInstrumentChartView from './NativeModule/components/SMInstrumentChartViewUI.js';
import SMWorkspaceManagerView from './NativeModule/components/SMWorkspaceManagerComponent.js';

import EngineType from './NativeModule/EngineType'
import ThemeLabelItem from './NativeModule/ThemeLabelItem'
import ThemeRangeItem from './NativeModule/ThemeRangeItem'
import ThemeUniqueItem from './NativeModule/ThemeUniqueItem'
import ThemeLabel from './NativeModule/ThemeLabel'
import ThemeRange from './NativeModule/ThemeRange'
import ThemeUnique from './NativeModule/ThemeUnique'

import Collector from './NativeModule/Collector'
import CollectorElement from './NativeModule/CollectorElement'
import ElementPoint from './NativeModule/ElementPoint'
import ElementLine from './NativeModule/ElementLine'
import ElementPolygon from './NativeModule/ElementPolygon'

import SpeechManager from './NativeModule/SpeechManager'
import OnlineService from './NativeModule/OnlineService'

import Environment from './NativeModule/Environment'
/*
 import Datasets from './NativeModule/Datasets.js';
 import Datasources from './NativeModule/Datasources.js';
 import Layers from './NativeModule/Layers.js';
 import Maps from './NativeModule/Maps.js';
 import Recordset from './NativeModule/Recordset.js';
 */

/***********************Version 1.6.3**************************/
import {
  SMap,
  SAnalyst,
  SCollector,
  SScene,
} from './NativeModule/interfaces'
let SMCollectorType = NativeModules.SCollectorType;

export {
  SMMapView,
  SMCallOut,
  SMLayerListView,
  SMLegendView,
  SMScaleView,
  SMSceneView,
  SMPlotView,
  // SMSearchView,
  SMWorkspaceManagerView,
  
  Utility,
  
  Layer3Ds,
  Layer3D,
  Feature3D,
  Feature3Ds,
  Geometry3D,
  Point3D,
  Camera,
  Layer3DOSGBFile,
  
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
  // HotChart,
  GridHotChart,
  PointDensityChart,
  PolymerChart,
  RelationalPointChart,
  RelationalChartPoint,
  
  Action,
  BufferEndType,
  RadiusUnit,
  EncodeType,
  DatasetType,
  FieldType,
  TextAlignment,
  
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
  GeoLineM,
  Geometry,
  GeoPoint,
  GeoRegion,
  GeoStyle,
  Layer,
  LayerGroup,
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
  PointM,
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
  FacilityAnalyst,
  FacilityAnalystSetting,
  WeightFieldInfo,
  WeightFieldInfos,
  TextStyle,
  TextPart,
  GeoText,
  
  SupplyCenterType,
  PrjCoordSysType,
  CoordSysTransMethod,
  TransportationAnalystParameter,
  TransportationAnalyst,
  LocationAnalystParameter,
  SupplyCenter,
  SupplyCenters,
  TransportationAnalystSetting,
  CoordSysTranslator,
  CoordSysTransParameter,
  
  EngineType,
  
  RangeMode,
  ThemeLabelItem,
  ThemeRangeItem,
  ThemeUniqueItem,
  ThemeLabel,
  ThemeRange,
  ThemeUnique,
  
  ColorGradientType,
  
  GPSElementType,
  Collector,
  CollectorElement,
  ElementPoint,
  ElementLine,
  ElementPolygon,
  
  SpeechManager,
  
  ThemeType,
  WorkspaceType,
  OnlineService,
  Environment,

  Resoures,
  Symbol,
  SymbolLibrary,
  SymbolFill,
  SymbolFillLibrary,
  SymbolLine,
  SymbolLineLibrary,
  SymbolMarker,
  SymbolMarkerLibrary,
  SymbolType,
  SymbolGroup,
  SymbolGroups,
  /*
   Datasets,
   Datasources,
   Layers,
   Maps,
   Recordset,
   */

  SMap,
  SAnalyst,
  SCollector,
  SScene,
  SMCollectorType,
};
