//
//  NaviInfo.h
//  ProNavigationDemo
//
//  Created by imobile-xzy on 15/9/7.
//  Copyright (c) 2015年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NaviInfo: NSObject

// 当前道路名称
@property(nonatomic,strong,readonly)NSString* curRoadName;
// 下一道路名称
@property(nonatomic,strong,readonly)NSString* nextRoadName;
// 剩余距离
@property(nonatomic,assign,readonly)int routeRemainDis;
// 本路段剩余距离
@property(nonatomic,assign,readonly)int segRemainDis;
// 剩余时间（分钟）
@property(nonatomic,assign,readonly)double routeRemainTime;

/**
 * 转向图标类型
 * 	图标说明：
 *	直行				0
 *	左前转弯			1
 *	右前转弯			2
 *	左转弯			3
 *	右转弯			4
 *	左后转弯			5
 *	右后转弯			6
 *	调头				7
 *	右转弯绕行至左	8
 *	直角斜边右转弯	9
 *	环岛				10
 */

@property(nonatomic,assign,readonly)int iconType;
// 小车方向
@property(nonatomic,assign,readonly)double direction;
@end
