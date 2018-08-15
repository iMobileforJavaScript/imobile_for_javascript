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
        NSInteger nsKey = (NSInteger)result;
        [JSObjManager addObj:result];
        [routeIdArr addObject:@(nsKey).stringValue];
    }
    
    return @{@"routeIds":routeIdArr,
             @"edges":[result edges],
             @"nodesArr":[result nodes],
             @"stopIndexesArr":[result stops],
             @"stopWeightsArr":[result stopWeights],
             @"weightsArr":[result weights]
             };
}


@end
