package com.supermap.containts;

public class EventConst {

    public static final String COLLECTION_CHANGE = "com.supermap.RN.Mapcontrol.collection_change";
    public static final String COLLECTION_SENSER_CHANGE = "com.supermap.RN.Mapcontrol.collection_sensor_change";
    /*
     * 在线模块
     */
    public static final String ONLINE_SERVICE_REVERSEGEOCODING = "com.supermap.RN.Mapcontrol.online_service_reversegeocoding";

    public static final String ONLINE_SERVICE_DOWNLOADING = "com.supermap.RN.Mapcontrol.online_service_downloading";
    public static final String ONLINE_SERVICE_DOWNLOADED = "com.supermap.RN.Mapcontrol.online_service_downloaded";
    public static final String ONLINE_SERVICE_DOWNLOADFAILURE = "com.supermap.RN.Mapcontrol.online_service_downloadfailure";
    public static final String ONLINE_SERVICE_UPLOADING = "com.supermap.RN.Mapcontrol.online_service_uploading";
    public static final String ONLINE_SERVICE_UPLOADED = "com.supermap.RN.Mapcontrol.online_service_uploaded";
    public static final String ONLINE_SERVICE_UPLOADFAILURE = "com.supermap.RN.Mapcontrol.online_service_uploadfailure";

    public static final String ONLINE_SERVICE_DOWNLOADINGOFID = "com.supermap.RN.Mapcontrol.online_service_downloadingofid";
    public static final String ONLINE_SERVICE_DOWNLOADEDOFID = "com.supermap.RN.Mapcontrol.online_service_downloadedofid";
    public static final String ONLINE_SERVICE_DOWNLOADFAILUREOFID = "com.supermap.RN.Mapcontrol.online_service_downloadfailureofid";

    public static final String ONLINE_SERVICE_LOGIN = "com.supermap.RN.Mapcontrol.online_service_login";
    public static final String ONLINE_SERVICE_LOGOUT = "com.supermap.RN.Mapcontrol.online_service_logout";
    public static final String IPORTAL_SERVICE_UPLOADING = "com.supermap.RN.iPortalService_uploading";
    public static final String IPORTAL_SERVICE_UPLOADED = "com.supermap.RN.iPortalService_uploaded";
    public static final String IPORTAL_SERVICE_DOWNLOADING = "com.supermap.RN.iPortalService_downloading";

    /** 消息服务 **/
    public static final String MESSAGE_SERVICE_RECEIVE = "com.supermap.RN.Mapcontrol.message_service_receive";
    public static final String MESSAGE_IMPORTEXTERNALDATA = "com.supermap.RN.Mapcontrol.message_importexternaldata";
    public static final String MESSAGE_SHARERESULT = "com.supermap.RN.Mapcontrol.message_shareresult";
    public static final String MESSAGE_SERVICE_SEND_FILE = "com.supermap.RN.MessageService.send_file_progress";
    public static final String MESSAGE_SERVICE_RECEIVE_FILE = "com.supermap.RN.MessageService.receive_file_progress";

    /** 量算 **/
    public static final String MEASURE_LENGTH = "com.supermap.RN.Mapcontrol.length_measured";
    public static final String MEASURE_AREA = "com.supermap.RN.Mapcontrol.area_measured";
    public static final String MEASURE_ANGLE = "com.supermap.RN.Mapcontrol.angle_measured";

    /** 地图 **/
    public static final String MAP_LONG_PRESS = "com.supermap.RN.Mapcontrol.long_press_event";
    public static final String MAP_SINGLE_TAP = "com.supermap.RN.Mapcontrol.single_tap_event";
    public static final String MAP_SINGLE_TAP_CONFIR = "com.supermap.RN.Mapcontrol.single_tap_confir_event";
    public static final String MAP_DOUBLE_TAP = "com.supermap.RN.Mapcontrol.double_tap_event";
    public static final String MAP_TOUCH_BEGAN = "com.supermap.RN.Mapcontrol.touch_began_event";
    public static final String MAP_SCROLL = "com.supermap.RN.Mapcontrol.scroll_event";
    public static final String MAP_GEOMETRY_MULTI_SELECTED = "com.supermap.RN.Mapcontrol.geometry_multi_selected";
    public static final String MAP_GEOMETRY_SELECTED = "com.supermap.RN.Mapcontrol.geometry_selected";

    /** 二维POI搜索 **/
    public static final String POINTSEARCH2D_KEYWORDS = "com.supermap.RN.MapControl.PointSearch2D_keyWords";
    /** 图例 **/
    public static final String LEGEND_CONTENT_CHANGE = "com.supermap.RN.Map.Legend.legend_content_change";
    /** 比例尺 **/
    public static final String SCALEVIEW_CHANGE = "com.supermap.RN.Map.ScaleView.scaleView_change";

    /* 三维模块*/
    public static final String ANALYST_MEASURELINE = "com.supermap.RN.SMSceneControl.Analyst_measureLine";
    public static final String ANALYST_MEASURESQUARE = "com.supermap.RN.SMSceneControl.Analyst_measureSquare";
    public static final String POINTSEARCH_KEYWORDS = "com.supermap.RN.SMSceneControl.PointSearch_keyWords";
    public static final String SSCENE_FLY = "com.supermap.RN.SMSceneControl.Scene_fly";
    public static final String SSCENE_ATTRIBUTE = "com.supermap.RN.SMSceneControl.Scene_attribute";
    public static final String SSCENE_SYMBOL = "com.supermap.RN.SMSceneControl.Scene_symbol";
    public static final String SSCENE_FAVORITE = "com.supermap.RN.SMSceneControl.Scene_favorite";
    public static final String SSCENE_CIRCLEFLY = "com.supermap.RN.SMSceneControl.Scene_circleFly";
    
    /** 多媒体采集 **/
    public static final String MEDIA_CAPTURE = "com.supermap.RN.MediaCapture";
    /** 多媒体采集，Callout点击回调 **/
    public static final String MEDIA_CAPTURE_TAP_ACTION = "com.supermap.RN.MediaCaptureTapAction";

    /** 分析 **/
    public static final String ONLINE_ANALYST_RESULT = "com.supermap.RN.online_analyst_result";

    /** 导航路线 **/
    public static final String NAVIGATION_WAYS = "com.supermap.RN.Navigation.online_navigation_ways";
    public static final String NAVIGATION_LENGTH = "com.supermap.RN.Navigation.online_navigation_length";
    public static final String INDUSTRYNAVIAGTION = "com.supermap.RN.Navigation.industry_navigation";
    public static final String MAPSELECTPOINTNAMESTART = "com.supermap.RN.Navigation.mapselectpointnamestart";
    public static final String MAPSELECTPOINTNAMEEND = "com.supermap.RN.Navigation.mapselectpointnameend";

    public static final String ILLEGALLYPARK = "com.supermap.RN.Navigation.illegallypark";


    /** 智能配图 **/
    public static final String MATCH_IMAGE_RESULT = "com.supermap.RN.match_image_result";
}
