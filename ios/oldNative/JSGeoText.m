//
//  JSGeoText.m
//  Supermap
//
//  Created by wnmng on 2018/8/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSGeoText.h"
#import "SuperMap/GeoText.h"
#import "JSObjManager.h"

@implementation JSGeoText
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [[GeoText alloc] init];
        NSInteger nsKey = (NSInteger)geoText;
        [JSObjManager addObj:geoText];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"createObj expection",nil);
    }
}
/**
 * 创建对象
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(createObjWithTextPart,createObjWithTextPart:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart*textPart = [JSObjManager getObjWithKey:textPartId];
        GeoText* geoText = [[GeoText alloc] initWithTextPart:textPart];
        NSInteger nsKey = (NSInteger)geoText;
        [JSObjManager addObj:geoText];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"createObjWithTextPart expection",nil);
    }
}
/**
 * 释放此对象所占用的资源
 * @param geoTextId
 * @param promise
 */
RCT_REMAP_METHOD(dispose,dispose:(NSString*)geoTextId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText =  [JSObjManager getObjWithKey:geoTextId];
        [geoText dispose];
        [JSObjManager removeObj:geoTextId];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"dispose expection",nil);
    }
}
/**
 * 在文本对象中添加文本子对象
 * @param geoTextId
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(addPart,addPart:(NSString*)geoTextId part:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [JSObjManager getObjWithKey:geoTextId];
        TextPart*textPart = [JSObjManager getObjWithKey:textPart];
        int res = [geoText addPart:textPart];
        resolve([NSNumber numberWithInt:res]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"addPart expection",nil);
    }
}
/**
 * 返回此文本对象的指定序号的子对象
 * @param geoTextId
 * @param index
 * @param promise
 */
RCT_REMAP_METHOD(getPart,getPart:(NSString*)geoTextId index:(int)nIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [JSObjManager getObjWithKey:geoTextId];
        TextPart*textPart = [geoText getPart:nIndex];
        NSInteger nsKey = (NSInteger)textPart;
        [JSObjManager addObj:textPart];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"getPart expection",nil);
    }
}
/**
 * 返回文本对象的子对象个数
 * @param geoTextId
 * @param promise
 */
RCT_REMAP_METHOD(getPartCount,getPartCount:(NSString*)geoTextId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText =  [JSObjManager getObjWithKey:geoTextId];
        int count = [geoText getPartCount];
        resolve([NSNumber numberWithInt:count]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"getPartCount expection",nil);
    }
}
/**
 * 返回文本对象的内容
 * @param geoTextId
 * @param promise
 */
RCT_REMAP_METHOD(getText,getText:(NSString*)geoTextId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText =  [JSObjManager getObjWithKey:geoTextId];
        NSString* strText = [geoText getText];
        resolve(strText);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"getPartCount expection",nil);
    }
}
/**
 * 返回文本对象的文本风格
 * @param geoTextId
 * @param promise
 */
RCT_REMAP_METHOD(getTextStyle,getTextStyle:(NSString*)geoTextId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText =  [JSObjManager getObjWithKey:geoTextId];
        TextStyle *style = [geoText getStyle];
        NSInteger nsKey = (NSInteger)style;
        [JSObjManager addObj:style];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"getTextStyle expection",nil);
    }
}
/**
 * 在此文本对象的指定位置插入一个文本子对象
 * @param geoTextId
 * @param index
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(insertPart,insertPart:(NSString*)geoTextId index:(int)nIndex part:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [JSObjManager getObjWithKey:geoTextId];
        TextPart*textPart = [JSObjManager getObjWithKey:textPart];
        [geoText insertPart:nIndex TextPart:textPart];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"insertPart expection",nil);
    }
}
/**
 * 判定该文本对象是否为空，即其子对象的个数是否为0
 * @param geoTextId
 * @param promise
 */
RCT_REMAP_METHOD(isEmpty,isEmpty:(NSString*)geoTextId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [JSObjManager getObjWithKey:geoTextId];
        BOOL bEmpty = [geoText isEmpty];
        resolve([NSNumber numberWithBool:bEmpty]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"isEmpty expection",nil);
    }
}
/**
 * 删除此文本对象的指定序号的文本子对象
 * @param geoTextId
 * @param index
 * @param promise
 */
RCT_REMAP_METHOD(removePart,removePart:(NSString*)geoTextId index:(int)nIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [JSObjManager getObjWithKey:geoTextId];
        BOOL res = [geoText removePart:nIndex];
        resolve([NSNumber numberWithBool:res]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"removePart expection",nil);
    }
}
/**
 * 修改此文本对象的指定序号的子对象，即用新的文本子对象来替换原来的文本子对象
 * @param geoTextId
 * @param index
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(setPart,setPart:(NSString*)geoTextId index:(int)nIndex part:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [JSObjManager getObjWithKey:geoTextId];
        TextPart*textPart = [JSObjManager getObjWithKey:textPart];
        BOOL res = [geoText setPart:nIndex TextPart:textPart];
        resolve([NSNumber numberWithBool:res]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"setPart expection",nil);
    }
}
/**
 * 设置文本对象的文本风格
 * @param geoTextId
 * @param textStyleId
 * @param promise
 */
RCT_REMAP_METHOD(setTextStyle,setTextStyle:(NSString*)geoTextId style:(NSString*)textStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoText* geoText = [JSObjManager getObjWithKey:geoTextId];
        TextStyle* style = [JSObjManager getObjWithKey:textStyleId];
        [geoText setStyle:style];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSGeoText",@"setTextStyle expection",nil);
    }
}

@end
