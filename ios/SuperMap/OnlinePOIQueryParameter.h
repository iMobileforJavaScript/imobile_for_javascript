//
//  OnlinePOIQueryParameter.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateType.h"
@interface OnlinePOIQueryParameter : NSObject

/**
 * 必设参数
 * 描述：搜索关键字，需要检索的POI关键字，如输入多个关键字，请使用空格隔开
 */
@property (nonatomic,strong) NSString *keywords;

/**
 * POI服务查询范围，默认北京市范围查找
 */
@property (nonatomic,strong) NSString *city;

/**
 * 每页显示多少条数据
 * 返回记录结果数，默认10
 */
@property(nonatomic,assign) int pageSize;

/**
 * 描述：分页页码，默认0代表第一页
 */
@property(nonatomic,assign) int pageNumber;

/**
 * 描述：输出结果坐标类型，支持的坐标类型编码参考：坐标转换
 * 默认值为 190101
 */
@property(nonatomic,assign) CoordinateType coordinateType;

@end
