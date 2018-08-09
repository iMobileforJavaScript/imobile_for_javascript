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

/**
 * 获取采集对象的边框范围
 * @param collectorId
 * @param promise
 */

/**
 * 获取采集对象的 Geometry
 * @param collectorId
 * @param promise
 */

/**
 * 获取采集对象的几何对象类型
 * @param collectorId
 * @param promise
 */

/**
 * 获取采集对象的点串
 * @param collectorId
 * @param promise
 */

/**
 * 获取采集对象的ID
 * @param collectorId
 * @param promise
 */

/**
 * 获取采集对象的名称
 * @param collectorId
 * @param promise
 */

/**
 * 获取采集对象的备注信息
 * 获取采集对象的名称
 * @param collectorId
 * @param promise
 */

/**
 * 获取单击事件监听器
 * @param collectorId
 * @param promise
 */

/**
 * 获取点串分组信息（仅适用于通过Geomotry构造的动态数据）
 * @param collectorId
 * @param promise
 */

/**
 * 获取采集对象的类型
 * @param collectorId
 * @param promise
 */

/**
 * 获取用户数据
 * @param collectorId
 * @param promise
 */

/**
 * 设置采集对象的名称
 * @param collectorId
 * @param value
 * @param promise
 */

/**
 * 设置采集对象的备注信息
 * @param collectorId
 * @param value
 * @param promise
 */

/**
 * 设置点击监听器
 * @param collectorId
 * @param value
 * @param promise
 */

/**
 * 设置用户数据
 * @param collectorId
 * @param value
 * @param promise
 */
@end
