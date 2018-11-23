//
//  OnlinePOIInfo.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Point2D,Point2Ds;
@interface OnlinePOIInfo : NSObject

//POI详细地址信息
@property(nonatomic,strong) NSString *address;
//POI名称信息
@property(nonatomic,strong) NSString *name;
//POI地理坐标
@property(nonatomic,strong) Point2D *location;
//查询结果的可信度
@property(nonatomic,strong) NSString *confidence;
//POI地址的联系电话
@property(nonatomic,strong) NSString *telephone;

@end
