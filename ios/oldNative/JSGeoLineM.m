//
//  JSGeoLineM.m
//  Supermap
//
//  Created by wnmng on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSGeoLineM.h"
#import "SuperMap/GeoLineM.h"
#import "SuperMap/PointM.h"
#import "JSObjManager.h"

@implementation JSGeoLineM
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoLineM *lineM = [[GeoLineM alloc]init];
        NSInteger nsKey = (NSInteger)lineM;
        [JSObjManager addObj:lineM];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSGeoLineM",@"createObj expection",nil);
    }
}

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObjByPts,createObjByPts:(NSArray*)jsonPnts resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray *arrPntM = [[NSMutableArray alloc]init];
        for (int i=0; i<jsonPnts.count; i++) {
            NSDictionary *pntDic = [jsonPnts objectAtIndex:i];
            double x = [(NSNumber*)pntDic[@"x"] doubleValue];
            double y = [(NSNumber*)pntDic[@"y"] doubleValue];
            double m = [(NSNumber*)pntDic[@"m"] doubleValue];
            PointM *pntM = [[PointM alloc]initWith:x y:y z:m];
            [arrPntM addObject:pntM];
        }
        
        
        // 接口缺失
        
        GeoLineM *lineM = [[GeoLineM alloc]init];
        NSInteger nsKey = (NSInteger)lineM;
        [JSObjManager addObj:lineM];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSGeoLineM",@"createObjByPts expection",nil);
    }
}

@end
