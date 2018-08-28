//
//  NaviStep.h
//  ProNavigationDemo
//
//  Created by imobile-xzy on 15/9/2.
//  Copyright (c) 2015年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Point2D;
@interface NaviStep : NSObject

//!< 转弯方向贴图编号
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
 *	出环岛			11
 *	目的地			12
 *	电梯上行			13
 *	电梯下行			14
 *	扶梯上行			15
 *	扶梯下行			16
 *	楼梯	上行			17
 *	楼梯下行			18
 * 	到达途经点		19
 */
@property(nonatomic,assign)int toSwerve;
//!< 道路长度，单位m
@property(nonatomic,assign)double length;
//!< 道路名称
@property(nonatomic,strong)NSString* name;
 //!< 路口点
@property(nonatomic,strong)Point2D* point;
//!< 道路时间，单位分钟
@property(nonatomic,assign)double time;

//路段行驶速度
@property(nonatomic,assign)double speed;
@end
