//
//  PathGuideItem.h
//  prjTest
//
//  Created by imobile on 14-2-24.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectionType.h"
#import "SideType.h"
#import "TurnType.h"

/**
 * 行驶导引子项类。
 */
@class Rectangle2D,GeoLine;
@interface PathGuideItem : NSObject{
    
}
/**
 * 返回该行驶导引子项的范围。
 */
@property(nonatomic,retain,readonly) Rectangle2D *bounds;
/**
 * 返回该行驶导引子项的行驶方向。
 */
@property(nonatomic,readonly) DirectionType directionType;
/**
 * 返回站点到网络的距离。
 */
@property(nonatomic,readonly) double distance;
/**
 * 返回该行驶导引子项为线类型（即 isEdge 返回 true）时，对应的行驶导引线段。
 */
@property(nonatomic,retain,readonly) GeoLine *guideLine;
/**
 * 返回该行驶导引子项的 ID。
 */
@property(nonatomic,readonly) NSInteger ID;
/**
 * 返回该行驶导引子项的序号。
 */
@property(nonatomic,readonly) NSInteger index;
/**
 * 返回该行驶导引子项为线类型（即 isEdge 返回 true}）时，对应线段的长度。
 */
@property(nonatomic,readonly)double length;
/**
 * 返回该行驶导引子项的名称。
 */
@property(nonatomic,retain,readonly)NSString *name;
/**
 * 返回该行驶导引子项为站点时，站点在道路的左侧、右侧还是在路上。
 */
@property(nonatomic,readonly) SideType sideType;
/**
 * 返回该行驶导引子项为点类型（即 isEdge 返回 false）时，该点处下一步行进的转弯角度。
 */
@property(nonatomic,readonly) double turnAngle;
/**
 * 返回该行驶导引子项为点类型（即 isEdge 返回 false）时，该点处下一步行进的转弯方向。
 */
@property(nonatomic,readonly)TurnType turnType;
/**
 * 返回该行驶导引子项的权值，即行使导引对象子项的花费。
 */
@property(nonatomic,readonly)double weight;
/**
 * 返回该行驶导引子项是线还是点类型。
 */
@property(nonatomic,readonly) BOOL isEdge;
/**
 * 返回该行驶导引子项是否为站点，或站点被归结到网络上的对应点。
 */
@property(nonatomic,readonly) BOOL isStop;

-(void)dispose;
@end
