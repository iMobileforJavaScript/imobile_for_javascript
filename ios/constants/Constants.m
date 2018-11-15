//
//  Constants.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "Constants.h"

/** 采集 **/
NSString * const COLLECTION_SENSOR_CHANGE = @"com.supermap.RN.Mapcontrol.collection_sensor_change";

/** 在线服务 **/
NSString * const ONLINE_SERVICE_DOWNLOADING = @"com.supermap.RN.Mapcontrol.online_service_downloading";
NSString * const ONLINE_SERVICE_DOWNLOADED = @"com.supermap.RN.Mapcontrol.online_service_downloaded";
NSString * const ONLINE_SERVICE_LOGIN = @"com.supermap.RN.Mapcontrol.online_service_login";
NSString * const ONLINE_SERVICE_LOGOUT = @"com.supermap.RN.Mapcontrol.online_service_logout";
NSString * const ONLINE_SERVICE_DOWNLOADFAILURE = @"com.supermap.RN.Mapcontrol.online_service_downloadfailure";
NSString * const ONLINE_SERVICE_UPLOADING = @"com.supermap.RN.Mapcontrol.online_service_uploading";
NSString * const ONLINE_SERVICE_UPLOADED = @"com.supermap.RN.Mapcontrol.online_service_uploaded";
NSString * const ONLINE_SERVICE_UPLOADFAILURE = @"com.supermap.RN.Mapcontrol.online_service_uploadfailure";

/** 量算 **/
NSString * const MEASURE_LENGTH = @"com.supermap.RN.Mapcontrol.length_measured";
NSString * const MEASURE_AREA = @"com.supermap.RN.Mapcontrol.area_measured";
NSString * const MEASURE_ANGLE = @"com.supermap.RN.Mapcontrol.angle_measured";

/** 3D **/
NSString * const ANALYST_MEASURELINE = @"com.supermap.RN.SMSceneControl.Analyst_measureLine";
NSString * const ANALYST_MEASURESQUARE = @"com.supermap.RN.SMSceneControl.Analyst_measureSquare";
NSString * const POINTSEARCH_KEYWORDS = @"com.supermap.RN.SMSceneControl.PointSearch_keyWords";
NSString * const SSCENE_FLY = @"com.supermap.RN.SMSceneControl.Scene_fly";
NSString * const SSCENE_ATTRIBUTE = @"com.supermap.RN.SMSceneControl.Scene_attribute";

/** 地图 **/
NSString * const MAP_LONG_PRESS = @"com.supermap.RN.Mapcontrol.long_press_event";
NSString * const MAP_SINGLE_TAP = @"com.supermap.RN.Mapcontrol.single_tap_event";
NSString * const MAP_DOUBLE_TAP = @"com.supermap.RN.Mapcontrol.double_tap_event";
NSString * const MAP_TOUCH_BEGAN = @"com.supermap.RN.Mapcontrol.touch_began_event";
NSString * const MAP_TOUCH_END = @"com.supermap.RN.Mapcontrol.touch_end_event";
NSString * const MAP_SCROLL = @"com.supermap.RN.Mapcontrol.scroll_event";

NSString * const MAP_GEOMETRY_MULTI_SELECTED = @"com.supermap.RN.Mapcontrol.geometry_multi_selected";
NSString * const MAP_GEOMETRY_SELECTED = @"com.supermap.RN.Mapcontrol.geometry_selected";
NSString * const MAP_SCALE_CHANGED = @"Supermap.MapControl.MapParamChanged.ScaleChanged";
NSString * const MAP_BOUNDS_CHANGED = @"Supermap.MapControl.MapParamChanged.BoundsChanged";

/** 符号库 **/
NSString * const SYMBOL_CLICK = @"Supermap.MapControl.SymbolLibLegend.symbol_click";

@implementation Constants

@end
