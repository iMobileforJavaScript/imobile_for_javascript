export default {
  /** 采集 **/
  COLLECTION_CHANGE: 'com.supermap.RN.Mapcontrol.collection_change',
  COLLECTION_SENSER_CHANGE: 'com.supermap.RN.Mapcontrol.collection_sensor_change',
  
  /** 多媒体采集 **/
  MEDIA_CAPTURE: "com.supermap.RN.MediaCapture",
  MEDIA_CAPTURE_TAP_ACTION: "com.supermap.RN.MediaCaptureTapAction",

  /** 在线服务 **/
  ONLINE_SERVICE_LOGIN: 'com.supermap.RN.Mapcontrol.online_service_login',
  ONLINE_SERVICE_LOGOUT: 'com.supermap.RN.Mapcontrol.online_service_logout',
  ONLINE_SERVICE_DOWNLOADING: 'com.supermap.RN.Mapcontrol.online_service_downloading',
  ONLINE_SERVICE_DOWNLOADED: 'com.supermap.RN.Mapcontrol.online_service_downloaded',
  ONLINE_SERVICE_DOWNLOADFAILURE: 'com.supermap.RN.Mapcontrol.online_service_downloadfailure',
  ONLINE_SERVICE_UPLOADING: 'com.supermap.RN.Mapcontrol.online_service_uploading',
  ONLINE_SERVICE_UPLOADED: 'com.supermap.RN.Mapcontrol.online_service_uploaded',
  ONLINE_SERVICE_UPLOADFAILURE: 'com.supermap.RN.Mapcontrol.online_service_uploadfailure',
  ONLINE_SERVICE_REVERSEGEOCODING: 'com.supermap.RN.Mapcontrol.online_service_reversegeocoding',
  IPORTAL_SERVICE_UPLOADING: 'com.supermap.RN.iPortalService_uploading',
  IPORTAL_SERVICE_UPLOADED: 'com.supermap.RN.iPortalService_uploaded',
  IPORTAL_SERVICE_DOWNLOADING: 'com.supermap.RN.iPortalService_downloading',
  /** 消息服务 **/
  MESSAGE_SERVICE_RECEIVE:'com.supermap.RN.Mapcontrol.message_service_receive',
  /** 量算 **/
  MEASURE_LENGTH: 'com.supermap.RN.Mapcontrol.length_measured',
  MEASURE_AREA: 'com.supermap.RN.Mapcontrol.area_measured',
  MEASURE_ANGLE: 'com.supermap.RN.Mapcontrol.angle_measured',

  /** 地图 **/
  MAP_LONG_PRESS: 'com.supermap.RN.Mapcontrol.long_press_event',
  MAP_SINGLE_TAP: 'com.supermap.RN.Mapcontrol.single_tap_event',
  MAP_DOUBLE_TAP: 'com.supermap.RN.Mapcontrol.double_tap_event',
  MAP_TOUCH_BEGAN: 'com.supermap.RN.Mapcontrol.touch_began_event',
  MAP_TOUCH_END: 'com.supermap.RN.Mapcontrol.touch_end_event',
  MAP_SCROLL: 'com.supermap.RN.Mapcontrol.scroll_event',

  POINTSEARCH2D_KEYWORDS: "com.supermap.RN.MapControl.PointSearch2D_keyWords",
  MAP_LEGEND_CONTENT_CHANGE:'com.supermap.RN.Map.Legend.legend_content_change',
  MAP_SCALEVIEW_CHANGE:'com.supermap.RN.Map.ScaleView.scaleView_change',
  MAP_GEOMETRY_MULTI_SELECTED: 'com.supermap.RN.Mapcontrol.geometry_multi_selected',
  MAP_GEOMETRY_SELECTED: "com.supermap.RN.Mapcontrol.geometry_selected",
  MAP_SCALE_CHANGED: "Supermap.MapControl.MapParamChanged.ScaleChanged",
  MAP_BOUNDS_CHANGED: "Supermap.MapControl.MapParamChanged.BoundsChanged",

 /** 三维模块 */
  ANALYST_MEASURELINE: "com.supermap.RN.SMSceneControl.Analyst_measureLine",
  ANALYST_MEASURESQUARE: "com.supermap.RN.SMSceneControl.Analyst_measureSquare",
  POINTSEARCH_KEYWORDS: "com.supermap.RN.SMSceneControl.PointSearch_keyWords",
  SSCENE_FLY: "com.supermap.RN.SMSceneControl.Scene_fly",
  SSCENE_ATTRIBUTE: "com.supermap.RN.SMSceneControl.Scene_attribute",
  SSCENE_SYMBOL: "com.supermap.RN.SMSceneControl.Scene_symbol",
  SSCENE_FAVORITE: "com.supermap.RN.SMSceneControl.Scene_favorite",
  SSCENE_CIRCLEFLY: "com.supermap.RN.SMSceneControl.Scene_circleFly",
  // SSCENE_REMOVE_ATTRIBUTE: "com.supermap.RN.SMSceneControl.Scene_removeAttribu
  
  /** 在线分析 **/
  ONLINE_ANALYST_RESULT: 'com.supermap.RN.online_analyst_result',

  /** 导航路线 **/
  NAVIGATION_WAYS :"com.supermap.RN.Navigation.online_navigation_ways",
  NAVIGATION_LENGTH :"com.supermap.RN.Navigation.online_navigation_length",
  INDUSTRYNAVIAGTION:"com.supermap.RN.Navigation.industry_navigation",
  MAPSELECTPOINTNAMESTART:"com.supermap.RN.Navigation.mapselectpointnamestart",
  MAPSELECTPOINTNAMEEND:"com.supermap.RN.Navigation.mapselectpointnameend",
  ILLEGALLYPARK:"com.supermap.RN.Navigation.illegallypark",
  /*室内地图 bounds改变，且floorlist的id*/
  IS_INDOOR_MAP : "com.supermap.RN.FloorListView.isIndoorChanged",
  
  /** 智能监听 **/
  MATCH_IMAGE_RESULT: "com.supermap.RN.match_image_result",

  /** 语音 **/
  RECOGNIZE_BEGIN: "com.supermap.RN.speech.recognize.begin",
  RECOGNIZE_END: "com.supermap.RN.speech.recognize.end",
  RECOGNIZE_ERROR: "com.supermap.RN.speech.recognize.error",
  RECOGNIZE_RESULT: "com.supermap.RN.speech.recognize.result",
  RECOGNIZE_VOLUME_CHANGED: "com.supermap.RN.speech.recognize.volume_changed",
  RECOGNIZE_EVENT: "com.supermap.RN.speech.recognize.event",
}