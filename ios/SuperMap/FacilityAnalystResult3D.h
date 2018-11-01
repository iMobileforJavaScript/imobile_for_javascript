//
//  FacilityAnalystResult3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacilityAnalystResult3D : NSObject
/**
 * 返回结果路径经过的节点ID数组
 * @return NSArray< NSNumber<NSInteger> >
 */
@property (nonatomic,strong,readonly) NSArray * nodes;
/**
 * 返回结果路径经过的弧段ID数组
 * @return NSArray< NSNumber<NSInteger> >
 */
@property (nonatomic,strong,readonly) NSArray * edges;
/**
 * 返回结果路径经过的弧段ID数组
 * @return double
 */
@property (nonatomic,assign,readonly) double cost;

@end
