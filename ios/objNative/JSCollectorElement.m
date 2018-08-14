//
//  JSCollectorElement.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSCollectorElement.h"
#import "JSObjManager.h"
#import "SuperMap/CollectorElement.h"


@implementation JSCollectorElement
RCT_EXPORT_MODULE();

/**
 * 添加点
 * @param collectorId
 * @param point2DId
 * @param promise
 */
RCT_REMAP_METHOD(addPoint,addGPSPointById:(NSString*)senderId  point:(NSString*)point resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        Point2D* point = [JSObjManager getObjWithKey:point];
        [sender addPoint:point];
        resolve([NSNumber numberWithBool:YES]);
        
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"addPoint expection",nil);
    }
}
/**
 * 通过 Geomotry 构造采集对象
 * @param collectorId
 * @param geometryId
 * @param promise
 */
RCT_REMAP_METHOD(fromGeometry,fromGeometry:(NSString*)senderId  geometry:(NSString*)geometryId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        Geometry* geo = [JSObjManager getObjWithKey:geometryId];
        BOOL result = [sender fromGeometry:geo];
        resolve([NSNumber numberWithBool:result]);
        
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"fromGeometry expection",nil);
    }
}


/**
 * 获取采集对象的边框范围
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getBounds,getBounds:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        Rectangle2D* bounds = [sender getBounds];
        NSInteger nsKey = (NSInteger)bounds;
        [JSObjManager addObj:bounds];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getBounds expection",nil);
    }
}

/**
 * 获取采集对象的 Geometry
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getGeometry,getGeometry:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        Geometry *geo = [sender geometry];
        NSInteger nsKey = (NSInteger)geo;
        [JSObjManager addObj:geo];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getGeometry expection",nil);
    }
}

/**
 * 获取采集对象的几何对象类型
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getGeometryType,getGeometryType:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        GeometryType type = [sender getGeometryType];
        resolve([NSNumber numberWithInt:type]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getGeometryType expection",nil);
    }
}

/**
 * 获取采集对象的点串
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getGeoPoints,getGeoPoints:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        Point2Ds *pnts = [sender getGeoPoints];
        NSInteger nsKey = (NSInteger)pnts;
        [JSObjManager addObj:pnts];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getGeoPoints expection",nil);
    }
}

/**
 * 获取采集对象的ID
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getID,getID:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        int idValue = [sender getID];
        resolve([NSNumber numberWithInt:idValue]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getID expection",nil);
    }
}

/**
 * 获取采集对象的名称
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getName,getName:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        NSString* name = [sender name];
        resolve(name);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getName expection",nil);
    }
}

/**
 * 获取采集对象的备注信息
 * 获取采集对象的名称
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getNotes,getNotes:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        NSString* notes = [sender notes];
        resolve(notes);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getNotes expection",nil);
    }
}

/**
 * 获取单击事件监听器
 * @param collectorId
 * @param promise
 */

RCT_REMAP_METHOD(getOnClickListenner,getOnClickListenner:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
         // TODO 获取单击事件监听器
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getOnClickListenner expection",nil);
    }
}

/**
 * 获取点串分组信息（仅适用于通过Geomotry构造的动态数据）
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getPart,getPart:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        NSArray* part = [sender getPart];
        NSInteger nsKey = (NSInteger)part;
        [JSObjManager addObj:part];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getPart expection",nil);
    }
}


/**
 * 获取采集对象的类型
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getType,getType:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        GPSElementType type = [sender getType];
        resolve([NSNumber numberWithInt:type]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getType expection",nil);
    }
}

/**
 * 获取用户数据
 * @param collectorId
 * @param promise
 */
RCT_REMAP_METHOD(getUserData,getUserData:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        NSString* data = [sender userData];
        resolve(data);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"getUserData expection",nil);
    }
}

/**
 * 设置采集对象的名称
 * @param collectorId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setName,setName:(NSString*)senderId name:(NSString*)nameStr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        [sender setName:nameStr];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"setName expection",nil);
    }
}

/**
 * 设置采集对象的备注信息
 * @param collectorId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setNotes,setNotes:(NSString*)senderId notes:(NSString*)notesStr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        [sender setNotes:notesStr];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"setNotes expection",nil);
    }
}

/**
 * 设置点击监听器
 * @param collectorId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setOnClickListenner,setOnClickListenner:(NSString*)senderId onClickListenner:(NSString*)listennerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        // TODO 设置点击监听器
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"setOnClickListenner expection",nil);
    }
}

/**
 * 设置用户数据
 * @param collectorId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setUserData,setUserData:(NSString*)senderId data:(NSString*)dataStr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CollectorElement* sender = [JSObjManager getObjWithKey:senderId];
        [sender setUserData:dataStr];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCollectorElement",@"setUserData expection",nil);
    }
}

@end
