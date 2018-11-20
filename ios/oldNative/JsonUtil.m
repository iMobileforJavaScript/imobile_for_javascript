//
//  JsonUtil.m
//  Supermap
//
//  Created by wnmng on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JsonUtil.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/GeoLineM.h"
#import "JSObjManager.h"

@implementation JsonUtil

/**
 * Rectangle 转 JSON 方法
 * @param rectangle2D
 */
+(NSDictionary*)rectangleToJson:(Rectangle2D*)rect{

    return @{@"center":@{@"x":@(rect.center.x),
                         @"y":@(rect.center.y)},
             @"top":@(rect.top),
             @"bottom":@(rect.bottom),
             @"left":@(rect.left),
             @"right":@(rect.right),
             @"width":@(rect.width),
             @"height":@(rect.height)
             };
    
}
/**
 * json转Rectangle方法
 * @param readableMap
 * @return
 * @throws Exception
 */
+(Rectangle2D*)jsonToRectangle:(NSDictionary*)jsonDic{
    NSArray *allKeys = [jsonDic allKeys];
    if([allKeys containsObject:@"left"] && [allKeys containsObject:@"bottom"]){
        double left = [(NSNumber*)jsonDic[@"left"] doubleValue];
        double bottom = [(NSNumber*)jsonDic[@"bottom"] doubleValue];
        if ([allKeys containsObject:@"top"]&&[allKeys containsObject:@"right"]) {
            double top = [(NSNumber*)jsonDic[@"top"] doubleValue];
            double right = [(NSNumber*)jsonDic[@"right"] doubleValue];
            return [[Rectangle2D alloc]initWith:left bottom:bottom right:right top:top];
        }else if([allKeys containsObject:@"width"]&&[allKeys containsObject:@"height"]){
            double width = [(NSNumber*)jsonDic[@"width"] doubleValue];
            double height = [(NSNumber*)jsonDic[@"height"] doubleValue];
            return [[Rectangle2D alloc]initWithLeftBottom:[[Point2D alloc] initWithX:left Y:bottom]
                                                    Width:width Height:height];
        }
    }
    return nil;
}
/**
 * 将Point2Ds转成JSON格式
 * @param point2Ds - Point2Ds对象
 * @return {WritableArray} - Json数组，元素为{x:---,y;---}坐标对对象。
 * @throws Exception
 */
+(NSArray*)point2DsToJson:(Point2Ds*)pnt2Ds{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i<pnt2Ds.getCount; i++) {
        Point2D* pnt2d = [pnt2Ds getItem:i];
        [arr addObject:@{@"x":@(pnt2d.x),
                         @"y":@(pnt2d.y)}];
    }
    return arr;
}
/**
 * 将JSON格式转成Point2Ds
 * @param array - Json数组
 * @return Point2Ds
 * @throws Exception
 */
+(Point2Ds*)jsonToPoint2Ds:(NSArray*)pntsArr{
    if (pntsArr.count!=0) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i=0; i<pntsArr.count; i++) {
            NSDictionary * pntDic = [pntsArr objectAtIndex:i];
            double x = [(NSNumber*)pntDic[@"x"] doubleValue];
            double y = [(NSNumber*)pntDic[@"y"] doubleValue];
            Point2D *pnt2D = [[Point2D alloc]initWithX:x Y:y];
            [arr addObject:pnt2D];
        }
        return  [[Point2Ds alloc]initWithPoint2DsArray:arr];
    }else{
        return nil;
    }
}

+(NSDictionary*)transportationResultToMap:(TransportationAnalystResult*) result {
    NSMutableArray* arrRoutes = [result routes];
    NSMutableArray* routeIdArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<arrRoutes.count; i++) {
        GeoLineM *lineM = [arrRoutes objectAtIndex:i];
//        NSInteger nsKey = (NSInteger)result;
        NSString* nsKey = [JSObjManager addObj:lineM];
        [routeIdArr addObject:nsKey];
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:routeIdArr forKey:@"routeIds"];
    if (result.edges) {
        [dic setObject:result.edges forKey:@"edges"];
    } else {
        [dic setObject:[NSArray array] forKey:@"edges"];
    }
    if (result.nodes) {
        [dic setObject:result.nodes forKey:@"nodesArr"];
    } else {
        [dic setObject:[NSArray array] forKey:@"nodesArr"];
    }
    if (result.stops) {
        [dic setObject:result.stops forKey:@"stopIndexesArr"];
    } else {
        [dic setObject:[NSArray array] forKey:@"stopIndexesArr"];
    }
    if (result.stopWeights) {
        [dic setObject:result.stopWeights forKey:@"stopWeightsArr"];
    } else {
        [dic setObject:[NSArray array] forKey:@"stopWeightsArr"];
    }
    if (result.weights) {
        [dic setObject:result.weights forKey:@"weightsArr"];
    } else {
        [dic setObject:[NSArray array] forKey:@"weightsArr"];
    }
    
    return dic;
    
//    return @{@"routeIds":routeIdArr,
//             @"edges":result.edges,
//             @"nodesArr":result.nodes,
//             @"stopIndexesArr":result.stops,
//             @"stopWeightsArr":result.stopWeights,
//             @"weightsArr":result.weights,
//             };
}


@end
