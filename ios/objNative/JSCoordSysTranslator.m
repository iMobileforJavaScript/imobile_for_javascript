//
//  JSCoordSysTranslator.m
//  Supermap
//
//  Created by wnmng on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSCoordSysTranslator.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/CoordSysTransParameter.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/Point3Ds.h"
#import "JSObjManager.h"

@implementation JSCoordSysTranslator
RCT_EXPORT_MODULE();

/**
 * 根据源投影坐标系与目标投影坐标系对几何对象进行投影转换，结果将直接改变源几何对象
 * @param geometryId
 * @param sourcePrjCoordSysId
 * @param targetPrjCoordSysId
 * @param coordSysTransParameterId
 * @param coordSysTransMethod
 * @param promise
 */
RCT_REMAP_METHOD(convertByGeometry,convertByGeometry:(NSString*)geometryId from:(NSString*)sourcePrjCoordSysId to:(NSString*)targetPrjCoordSysId param:(NSString*)coordSysTransParameterId method:(int)coordSysTransMethod resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Geometry* geometry = [JSObjManager getObjWithKey:geometryId];
        PrjCoordSys *sourcePrjCoordSys = [JSObjManager getObjWithKey:sourcePrjCoordSysId];
        PrjCoordSys *targetPrjCoordSys = [JSObjManager getObjWithKey:targetPrjCoordSysId];
        CoordSysTransParameter *coordSysTransParameter = [JSObjManager getObjWithKey:coordSysTransParameterId];
        CoordSysTransMethod method = coordSysTransMethod;
        
        // 方法缺失
        //[CoordSysTranslator convert:<#(Point2Ds *)#> PrjCoordSys:<#(PrjCoordSys *)#> PrjCoordSys:<#(PrjCoordSys *)#> CoordSysTransParameter:<#(CoordSysTransParameter *)#> CoordSysTransMethod:<#(CoordSysTransMethod)#>]
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTranslator",@"convertByGeometry expection",nil);
    }
}

/**
 * 根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
 * @param point2DIds
 * @param sourcePrjCoordSysId
 * @param targetPrjCoordSysId
 * @param coordSysTransParameterId
 * @param coordSysTransMethod
 * @param promise
 */
RCT_REMAP_METHOD(convertByPoint2Ds,convertByPoint2Ds:(NSArray*)point2DIds from:(NSString*)sourcePrjCoordSysId to:(NSString*)targetPrjCoordSysId param:(NSString*)coordSysTransParameterId method:(int)coordSysTransMethod resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2Ds *pnt2Ds = [[Point2Ds alloc]init];
        for (int i=0; i<point2DIds.count; i++) {
            NSString* pntid = [point2DIds objectAtIndex:i];
            Point2D* pnt2d = [JSObjManager getObjWithKey:pntid];
            [pnt2Ds add:pnt2d];
        }
        PrjCoordSys *sourcePrjCoordSys = [JSObjManager getObjWithKey:sourcePrjCoordSysId];
        PrjCoordSys *targetPrjCoordSys = [JSObjManager getObjWithKey:targetPrjCoordSysId];
        CoordSysTransParameter *coordSysTransParameter = [JSObjManager getObjWithKey:coordSysTransParameterId];
        CoordSysTransMethod method = coordSysTransMethod;
        
        BOOL result = [CoordSysTranslator convert:pnt2Ds PrjCoordSys:sourcePrjCoordSys PrjCoordSys:targetPrjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:method];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTranslator",@"convertByPoint2Ds expection",nil);
    }
}

/**
 * 根据源投影坐标系与目标投影坐标系对三维点集合对象进行投影转换，结果将直接改变源坐标点串
 * @param point3DIds
 * @param sourcePrjCoordSysId
 * @param targetPrjCoordSysId
 * @param coordSysTransParameterId
 * @param coordSysTransMethod
 * @param promise
 */
RCT_REMAP_METHOD(convertByPoint3Ds,convertByPoint3Ds:(NSArray*)point3DIds from:(NSString*)sourcePrjCoordSysId to:(NSString*)targetPrjCoordSysId param:(NSString*)coordSysTransParameterId method:(int)coordSysTransMethod resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        Point3Ds *pnt3Ds = [[Point3Ds alloc]init];
//        for (int i=0; i<point3DIds.count; i++) {
//            NSString* pntid = [point3DIds objectAtIndex:i];
//            Point3D* pnt3d = [JSObjManager getObjWithKey:pntid];
//            [pnt3Ds addPoint3D:pnt3d];
//        }
//        PrjCoordSys *sourcePrjCoordSys = [JSObjManager getObjWithKey:sourcePrjCoordSysId];
//        PrjCoordSys *targetPrjCoordSys = [JSObjManager getObjWithKey:targetPrjCoordSysId];
//        CoordSysTransParameter *coordSysTransParameter = [JSObjManager getObjWithKey:coordSysTransParameterId];
//        CoordSysTransMethod method = coordSysTransMethod;
        
        // 方法缺失
//        BOOL result = [CoordSysTranslator convert:pnt2Ds PrjCoordSys:sourcePrjCoordSys PrjCoordSys:targetPrjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:method];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTranslator",@"convertByPoint3Ds expection",nil);
    }
}
/**
* 在同一地理坐标系下，该方法用于将指定的Point2Ds 类的点对象的地理坐标转换到投影坐标
* @param point2DIds
* @param prjCoordSysId
* @param promise
*/
RCT_REMAP_METHOD(forward,forward:(NSArray*)point2DIds prjCoordSys:(NSString*)prjCoordSysId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2Ds *pnt2Ds = [[Point2Ds alloc]init];
        for (int i=0; i<point2DIds.count; i++) {
            NSString* pntid = [point2DIds objectAtIndex:i];
            Point2D* pnt2d = [JSObjManager getObjWithKey:pntid];
            [pnt2Ds add:pnt2d];
        }
        PrjCoordSys *prjCoordSys = [JSObjManager getObjWithKey:prjCoordSysId];
        
        BOOL result = [CoordSysTranslator forward:pnt2Ds PrjCoordSys:prjCoordSys];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTranslator",@"forward expection",nil);
    }
}
/**
 * 在同一投影坐标系下，该方法用于将指定的Point2Ds 类的点对象的投影坐标转换到地理坐标
 * @param point2DIds
 * @param prjCoordSysId
 * @param promise
 */
RCT_REMAP_METHOD(inverse,inverse:(NSArray*)point2DIds prjCoordSys:(NSString*)prjCoordSysId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2Ds *pnt2Ds = [[Point2Ds alloc]init];
        for (int i=0; i<point2DIds.count; i++) {
            NSString* pntid = [point2DIds objectAtIndex:i];
            Point2D* pnt2d = [JSObjManager getObjWithKey:pntid];
            [pnt2Ds add:pnt2d];
        }
        PrjCoordSys *prjCoordSys = [JSObjManager getObjWithKey:prjCoordSysId];
        
        BOOL result = [CoordSysTranslator inverse:pnt2Ds PrjCoordSys:prjCoordSys];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTranslator",@"inverse expection",nil);
    }
}

@end
