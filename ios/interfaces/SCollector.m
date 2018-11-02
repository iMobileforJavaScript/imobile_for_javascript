//
//  SCollector.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/29.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SCollector.h"
#import "SMap.h"
#import "Constants.h"
#import "SMCollector.h"
#import "SCollectorType.h"
#import "SuperMap/Collector.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/CollectorElement.h"
#import "SuperMap/Action.h"
#import "SuperMap/Map.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/Workspace.h"

@implementation SCollector
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[COLLECTION_SENSOR_CHANGE];
}

- (Collector *)getCollector {
    @try {
        return [[SMap singletonInstance].smMapWC.mapControl getCollector];
    } @catch (NSException *exception) {
        @throw exception;
    }
}

#pragma mark 设置采集对象的绘制风格
RCT_REMAP_METHOD(setStyle, setStyleByJson:(NSString*)styleJson resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        Collector* collector = [self getCollector];
        GeoStyle* style = [[GeoStyle alloc] init];
        [style fromJson:styleJson];
        
        collector.style = style;
        
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector",@"redo expection",nil);
    }
}

#pragma mark 获取采集对象的绘制风格
RCT_REMAP_METHOD(getStyle, getStyleWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        Collector* collector = [self getCollector];
        GeoStyle* style = collector.style;
        NSString* styleJson = [style toJson];
        
        resolve(styleJson);
    } @catch (NSException *exception) {
        reject(@"SCollector",@"redo expection",nil);
    }
}

#pragma mark 设置用于存储采集数据的数据集，若数据源不可用，则自动创建
RCT_REMAP_METHOD(setDataset, setDatasetByLayer:(NSString*)name type:(DatasetType)type datasourceName:(NSString *)datasourceName datasourcePath:(NSString *)datasourcePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Collector* collector = [self getCollector];
        Dataset* ds;
        Layer* layer;
        if (name != nil && ![name isEqualToString:@""]) {
            layer = [sMap.smMapWC.mapControl.map.layers getLayerWithName:name];
        }
        if (layer == nil) {
            ds = [sMap.smMapWC addDatasetByName:name type:type datasourceName:datasourceName datasourcePath:datasourcePath];
        } else {
            ds = layer.dataset;
        }
        [collector setDataset:ds];

        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector", exception.reason, nil);
    }
}

#pragma mark 指定采集方式，并采集对象
RCT_REMAP_METHOD(startCollect, startCollectWithType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Collector* collector = [self getCollector];
        BOOL result = [SMCollector setCollector:collector mapControl:sMap.smMapWC.mapControl type:type];
        //        [SMCollector openGPS:collector];
        
        resolve([NSNumber numberWithBool:result]);
        
    } @catch (NSException *exception) {
        reject(@"SCollector", exception.reason, nil);
    }
}

#pragma mark 添加点,GPS获取的点
RCT_REMAP_METHOD(addGPSPoint, addGPSPointWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [self getCollector];
        BOOL result = [sender addGPSPoint];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"SCollector", exception.reason, nil);
    }
}

#pragma mark 回退操作
RCT_REMAP_METHOD(undo, undoWithType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (type == LINE_HAND_PATH || type == REGION_HAND_PATH) {
            SMap* sMap = [SMap singletonInstance];
            [sMap.smMapWC.mapControl undo];
        } else {
            Collector* collector = [self getCollector];
            [collector undo];
        }
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector", exception.reason, nil);
    }

}

#pragma mark 重做操作
RCT_REMAP_METHOD(redo, redoWithType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (type == LINE_HAND_PATH || type == REGION_HAND_PATH) {
            SMap* sMap = [SMap singletonInstance];
            [sMap.smMapWC.mapControl redo];
        } else {
            Collector* collector = [self getCollector];
            [collector redo];
        }
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector", exception.reason, nil);
    }
}

#pragma mark 提交
RCT_REMAP_METHOD(submit, submitWithType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (type == LINE_HAND_PATH || type == REGION_HAND_PATH) {
            SMap* sMap = [SMap singletonInstance];
            [sMap.smMapWC.mapControl submit];
        } else {
            Collector* collector = [self getCollector];
            [collector submit];
        }
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector",@"submit expection",nil);
    }
}

#pragma mark 取消
RCT_REMAP_METHOD(cancel, cancelWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl cancel];
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector",@"submit expection",nil);
    }
}

#pragma mark 打开GPS定位
RCT_REMAP_METHOD(openGPS, openGPSWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* collector = [self getCollector];
        [collector openGPS];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector", exception.reason, nil);
    }
}

#pragma mark 关闭GPS
RCT_REMAP_METHOD(closeGPS, closeGPSWesolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* collector = [self getCollector];
        [collector closeGPS];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SCollector", exception.reason, nil);
    }
}


///**
// * 添加点,GPS获取的点
// * @param collectorId
// * @param pnt2DId
// * @param promise
// */
//RCT_REMAP_METHOD(addGPSPointByPoint,addGPSPointByPointId:(NSString*)senderId mapId:(NSString*)mapId pnt2DId:(NSString*)pointID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        [sender addGPSPoint];
//        //        Point2D* point = [JSObjManager getObjWithKey:pointID];
//        //        Map* map =  [JSObjManager getObjWithKey:mapId];
//        //        BOOL b =[sender addGPSPoint:point];
//        //        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
//        resolve(@(1));
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"addGPSPointByPoint expection",nil);
//    }
//}

//RCT_REMAP_METHOD(addGPSPointByXY,addGPSPointByXYId:(NSString*)senderId  mapId:(NSString*) mapId x:(double) x y:(double)y  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        [sender addGPSPoint];
//        //        Point2D* point = [JSObjManager getObjWithKey:pointID];
//        //        BOOL b =[sender addGPSPoint:point];
//        //        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
//        resolve(@(1));
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"addGPSPointByPoint expection",nil);
//    }
//}

///**
// * 创建指定类型的采集对象
// * @param collectorId
// * @param type
// * @param promise
// */
//
//RCT_REMAP_METHOD(createElement,createElementById:(NSString*)senderId type:(NSString*)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        NSDictionary* typeD = @{@"POINT":@(COL_POINT),
//                                @"LINE":@(COL_LINE),
//                                @"POLYGON":@(COL_POLYGON)
//                                };
//        BOOL b = [sender createElement:[typeD[type] intValue]];
//        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
//        resolve(nsRemoved);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"createElement expection",nil);
//    }
//}
//
///**
// * 获取当前的几何对象
// * @param collectorId
// * @param promise
// */
//
//RCT_REMAP_METHOD(getCurGeometry,getCurGeometryById:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        Geometry* geo =  [sender getCurGeometry];
//        NSInteger nsKey = (NSInteger)geo;
//        [JSObjManager addObj:geo];
//        resolve(@(nsKey).stringValue);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"getCurGeometry expection",nil);
//    }
//}
//
//
///**
// * 获取当前编辑节点的宽度,单位是10mm
// * @param collectorId
// * @param promise
// */
//
//RCT_REMAP_METHOD(getEditNodeWidth,getEditNodeWidthId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        double w =  sender.editNodeWidth;
//
//        resolve(@(w));
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"getEditNodeWidth expection",nil);
//    }
//}
//
///**
// * 获取当前采集对象
// * @param collectorId
// * @param promise
// */
//RCT_REMAP_METHOD(getElement,getElementId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        CollectorElement* w =  [sender getElement];
//        NSInteger nsKey = (NSInteger)w;
//
//        [JSObjManager addObj:w];
//        NSString* typeStr = @"POINT";
//        GPSElementType type = [w getType];
//        if(type==COL_LINE){
//            typeStr = @"LINE";
//        }else if (type==COL_POLYGON){
//            typeStr = @"POLYGON";
//        }
//        resolve(@{@"id":@(nsKey).stringValue,@"type":typeStr});
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"getElement expection",nil);
//    }
//}
///**
// * 获取当前位置
// * @param collectorId
// * @param promise
// */
//RCT_REMAP_METHOD(getGPSPoint,getGPSPointId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        Point2D* w =  [sender getGPSPoint];
//        NSInteger nsKey = (NSInteger)w;
//
//        [JSObjManager addObj:w];
//
//        resolve(@(nsKey).stringValue);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"getGPSPoint expection",nil);
//    }
//}
//
///**
// * 获取绘制风格采集对象的绘制风格
// * @param collectorId
// * @param promise
// */
//RCT_REMAP_METHOD(getStyle,getStyleId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        GeoStyle* style =  sender.style ;
//        NSString* styleJson = [style toJson];
//
//        resolve(styleJson);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector", exception.reason, nil);
//    }
//}
//
///**
// * 获取是否采用手势打点
// * @param collectorId
// * @param promise
// */
//RCT_REMAP_METHOD(IsSingleTapEnable,IsSingleTapEnableId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        BOOL w =  [sender isSingleTapEnable] ;
//
//        resolve([[NSNumber alloc] initWithBool:w]);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"IsSingleTapEnable expection",nil);
//    }
//}
//
///**
// * 定位地图到当前位置
// * @param collectorId
// * @param promise
// */
//RCT_REMAP_METHOD(moveToCurrent,moveToCurrentId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        [sender moveToCurrentPos] ;
//
//        resolve([[NSNumber alloc] initWithBool:YES]);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"moveToCurrent expection",nil);
//    }
//}



///**
// * 设置定位变化监听
// * @param collectorId
// * @param promise
// */
//RCT_REMAP_METHOD(setCollectionChangedListener,setCollectionChangedListenerId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"setCollectionChangedListener expection",nil);
//    }
//}
//
///**
// * 设置用于存储采集数据的数据集
// * @param collectorId
// * @param datasetId
// * @param promise
// */
//
//RCT_REMAP_METHOD(setDataset,setDatasetId:(NSString*)senderId Id:(NSString*)datasetId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        Dataset* dataset = [JSObjManager getObjWithKey:datasetId];
//        [sender setDataset:dataset] ;
//
//        resolve([[NSNumber alloc] initWithBool:YES]);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"setDataset expection",nil);
//    }
//}
//
////RCT_REMAP_METHOD(setDataset,setDatasetId:(NSString*)senderId datasetddId:(NSString*)dataset resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
////    @try {
////        Collector* sender = [self getCollector];
////        Dataset* dataset = [JSObjManager getObjWithKey:dataset];
////        [sender setDataset:dataset] ;
////
////        resolve([[NSNumber alloc] initWithBool:YES]);
////
////    } @catch (NSException *exception) {
////        reject(@"SCollector",@"setDataset expection",nil);
////    }
////}
//
///**
// * 设置当前编辑节点的宽度,单位是10mm
// * @param collectorId
// * @param value
// * @param promise
// */
//RCT_REMAP_METHOD(setEditNodeWidth,setEditNodeWidthId:(NSString*)senderId with:(double)w resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        sender.editNodeWidth = w;
//
//        resolve([[NSNumber alloc] initWithBool:YES]);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"setEditNodeWidth expection",nil);
//    }
//}
//
//
///**
// * 设置地图控件
// * @param collectorId
// * @param mapControlId
// * @param promise
// */
//
//RCT_REMAP_METHOD(setMapControl,setMapControlId:(NSString*)senderId mapControl:(NSString*)mapControl resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Collector* sender = [self getCollector];
//        MapControl* mapControl = [JSObjManager getObjWithKey:mapControl];
//        //  sender.editNodeWidth = w;
//        sender.mapControl = mapControl;
//        resolve([[NSNumber alloc] initWithBool:YES]);
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"setMapControl expection",nil);
//    }
//}
//
///**
// * 设置GPS式几何对象采集类关联的主控件
// * @param collectorId
// * @param mapViewId
// * @param promise
// */
//RCT_REMAP_METHOD(setMapView,setMapViewId:(NSString*)senderId mapControl:(NSString*)mapControl resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"setMapView expection",nil);
//    }
//
//}
///**
// * 设置是否采用手势打点
// * @param collectorId
// * @param value
// * @param promise
// */
//RCT_REMAP_METHOD(setSingleTapEnable,setSingleTapEnableId:(NSString*)senderId bValue:(BOOL)b resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        Collector* sender = [self getCollector];
//        sender.isSingleTapEnable = b;
//        resolve([[NSNumber alloc] initWithBool:YES]);
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"setSingleTapEnable expection",nil);
//    }
//
//}
//
///**
// * 显示提示信息
// * @param collectorId
// * @param info
// * @param promise
// */
//RCT_REMAP_METHOD(showInfo,showInfoId:(NSString*)senderId indo:(NSString*)info resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        resolve([[NSNumber alloc] initWithBool:YES]);
//    } @catch (NSException *exception) {
//        reject(@"SCollector",@"showInfo expection",nil);
//    }
//
//}
//


@end
