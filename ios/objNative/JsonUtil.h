//
//  JsonUtil.h
//  Supermap
//
//  Created by wnmng on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Rectangle2D.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/TransportationAnalystResult.h"

@interface JsonUtil : NSObject
/**
 * Rectangle 转 JSON 方法
 * @param rectangle2D
 */
+(NSDictionary*)rectangleToJson:(Rectangle2D*)rect;
/**
 * json转Rectangle方法
 * @param readableMap
 * @return
 * @throws Exception
 */
+(Rectangle2D*)jsonToRectangle:(NSDictionary*)jsonDic;
/**
 * 将Point2Ds转成JSON格式
 * @param point2Ds - Point2Ds对象
 * @return {WritableArray} - Json数组，元素为{x:---,y;---}坐标对对象。
 * @throws Exception
 */
+(NSArray*)point2DsToJson:(Point2Ds*)pnt2Ds;
/**
 * 将JSON格式转成Point2Ds
 * @param array - Json数组
 * @return Point2Ds
 * @throws Exception
 */
+(Point2Ds*)jsonToPoint2Ds:(NSArray*)pntsArr;
/**
 * 将TransportationAnalystResult转成JSON格式
 * @param result - TransportationAnalystResult对象
 * @throws Exception
 */
+(NSDictionary*)transportationResultToMap:(TransportationAnalystResult*) result;

@end
