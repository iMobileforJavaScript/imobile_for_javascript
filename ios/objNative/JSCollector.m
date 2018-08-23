//
//  JSCollector.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSCollector.h"
#import "SuperMap/Collector.h"
#import "JSObjManager.h"

@implementation JSCollector
RCT_EXPORT_MODULE();

/**
 * 添加点,GPS获取的点
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(addGPSPoint,addGPSPointById:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        BOOL b =[sender addGPSPoint];
        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
        resolve(nsRemoved);

    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPoint expection",nil);
    }
}

/**
 * 添加点,GPS获取的点
 * @param collectorId
 * @param pnt2DId
 * @param promise
 */
RCT_REMAP_METHOD(addGPSPointByPoint,addGPSPointByPointId:(NSString*)senderId  pnt2DId:(NSString*)pointID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        Point2D* point = [JSObjManager getObjWithKey:pointID];
        BOOL b =[sender addGPSPoint:point];
        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPointByPoint expection",nil);
    }
}

RCT_REMAP_METHOD(addGPSPointByXY,addGPSPointByXYId:(NSString*)senderId  mapId:(NSString*) mapId x:(double) x y:(double)y  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
//        Point2D* point = [JSObjManager getObjWithKey:pointID];
//        BOOL b =[sender addGPSPoint:point];
//        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
        resolve(@(1));
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"addGPSPointByPoint expection",nil);
    }
}

/**
 * 关闭GPS
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(closeGPS,closeGPSById:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        [sender closeGPS];
        //NSNumber* nsRemoved = [NSNumber numberWithBool:b];
        resolve(@(1));
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"closeGPS expection",nil);
    }
}


/**
 * 创建指定类型的采集对象
 * @param collectorId
 * @param type
 * @param promise
 */

RCT_REMAP_METHOD(createElement,createElementById:(NSString*)senderId type:(NSString*)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        NSDictionary* typeD = @{@"POINT":@(COL_POINT),
                                @"LINE":@(COL_LINE),
                                @"POLYGON":@(COL_POLYGON)
                                };
        BOOL b = [sender createElement:typeD[type]];
        NSNumber* nsRemoved = [NSNumber numberWithBool:b];
        resolve(nsRemoved);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"createElement expection",nil);
    }
}

/**
 * 获取当前的几何对象
 * @param collectorId
 * @param promise
 */

RCT_REMAP_METHOD(getCurGeometry,getCurGeometryById:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        Geometry* geo =  [sender getCurGeometry];
        NSInteger nsKey = (NSInteger)geo;
        [JSObjManager addObj:geo];
        resolve(@(nsKey).stringValue);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"getCurGeometry expection",nil);
    }
}


/**
 * 获取当前编辑节点的宽度,单位是10mm
 * @param collectorId
 * @param promise
 */

RCT_REMAP_METHOD(getEditNodeWidth,getEditNodeWidthId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        double w =  sender.editNodeWidth;
       
        resolve(@(w));
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"getEditNodeWidth expection",nil);
    }
}

/**
 * 获取当前采集对象
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getElement,getElementId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        CollectorElement* w =  [sender getElement];
        NSInteger nsKey = (NSInteger)w;

        [JSObjManager addObj:w];
        NSString* typeStr = @"POINT";
        GPSElementType type = [w getType];
        if(type==COL_LINE){
           typeStr = @"LINE";
        }else if (type==COL_POLYGON){
             typeStr = @"POLYGON";
        }
        resolve(@{@"id":@(nsKey).stringValue,@"type":typeStr});
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"getElement expection",nil);
    }
}
/**
 * 获取当前位置
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getGPSPoint,getGPSPointId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        Point2D* w =  [sender getGPSPoint];
        NSInteger nsKey = (NSInteger)w;
        
        [JSObjManager addObj:w];

        resolve(@(nsKey).stringValue);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"getGPSPoint expection",nil);
    }
}

/**
 * 获取绘制风格采集对象的绘制风格
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getStyle,getStyleId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        GeoStyle* w =  sender.style ;
        NSInteger nsKey = (NSInteger)w;
        
        [JSObjManager addObj:w];
        
        resolve(@(nsKey).stringValue);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"getStyle expection",nil);
    }
}

/**
 * 获取是否采用手势打点
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(IsSingleTapEnable,IsSingleTapEnableId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        BOOL w =  [sender isSingleTapEnable] ;
        
        resolve([[NSNumber alloc] initWithBool:w]);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"IsSingleTapEnable expection",nil);
    }
}

/**
 * 定位地图到当前位置
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(moveToCurrent,moveToCurrentId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        [sender moveToCurrentPos] ;
        
        resolve([[NSNumber alloc] initWithBool:YES]);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"moveToCurrent expection",nil);
    }
}

/**
 * 定位地图到当前位置
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(openGPS,openGPSId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
         [sender openGPS] ;
       
        
        resolve([[NSNumber alloc] initWithBool:YES]);
        
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"openGPS expection",nil);
    }
}

/**
 * 重做操作
 * @param collectorId
 * @param promise
 */

RCT_REMAP_METHOD(redo,redoId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        [sender redo] ;
        
        
        resolve([[NSNumber alloc] initWithBool:YES]);
        
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"redo expection",nil);
    }
}

/**
 * 设置定位变化监听
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(setCollectionChangedListener,setCollectionChangedListenerId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"setCollectionChangedListener expection",nil);
    }
}

/**
 * 设置用于存储采集数据的数据集
 * @param collectorId
 * @param datasetId
 * @param promise
 */
RCT_REMAP_METHOD(setDataset,setDatasetId:(NSString*)senderId datasetId:(NSString*)dataset resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        Dataset* dataset = [JSObjManager getObjWithKey:dataset];
        [sender setDataset:dataset] ;
        
        resolve([[NSNumber alloc] initWithBool:YES]);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"setDataset expection",nil);
    }
}

/**
 * 设置当前编辑节点的宽度,单位是10mm
 * @param collectorId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setEditNodeWidth,setEditNodeWidthId:(NSString*)senderId with:(double)w resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        sender.editNodeWidth = w;
        
        resolve([[NSNumber alloc] initWithBool:YES]);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"setEditNodeWidth expection",nil);
    }
}


/**
 * 设置地图控件
 * @param collectorId
 * @param mapControlId
 * @param promise
 */

RCT_REMAP_METHOD(setMapControl,setMapControlId:(NSString*)senderId mapControl:(NSString*)mapControl resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        MapControl* mapControl = [JSObjManager getObjWithKey:mapControl];
      //  sender.editNodeWidth = w;
        sender.mapControl = mapControl;
        resolve([[NSNumber alloc] initWithBool:YES]);
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"setMapControl expection",nil);
    }
}

/**
 * 设置GPS式几何对象采集类关联的主控件
 * @param collectorId
 * @param mapViewId
 * @param promise
 */
RCT_REMAP_METHOD(setMapView,setMapViewId:(NSString*)senderId mapControl:(NSString*)mapControl resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
       
        
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"setMapView expection",nil);
    }

}
/**
 * 设置是否采用手势打点
 * @param collectorId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setSingleTapEnable,setSingleTapEnableId:(NSString*)senderId bValue:(BOOL)b resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
         Collector* sender = [JSObjManager getObjWithKey:senderId];
        sender.isSingleTapEnable = b;
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"setSingleTapEnable expection",nil);
    }
    
}
/**
 * 设置采集对象的绘制风格
 * @param collectorId
 * @param styleId
 * @param promise
 */
RCT_REMAP_METHOD(setStyle,setStyleId:(NSString*)senderId style:(NSString*)style resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        GeoStyle* style = [JSObjManager getObjWithKey:style];
        sender.style = style;
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"redo expection",nil);
    }
    
}

/**
 * 显示提示信息
 * @param collectorId
 * @param info
 * @param promise
 */
RCT_REMAP_METHOD(showInfo,showInfoId:(NSString*)senderId indo:(NSString*)info resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"showInfo expection",nil);
    }
    
}

/**
 * 提交
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(submit,submitId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        [sender submit];
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"submit expection",nil);
    }
    
}
/**
 * 回退操作
 * @param collectorId
 * @param promise
 */

RCT_REMAP_METHOD(undo,undoId:(NSString*)senderId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Collector* sender = [JSObjManager getObjWithKey:senderId];
        [sender undo];
        resolve([[NSNumber alloc] initWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollector",@"submit expection",nil);
    }
    
}
@end
