//
//  OnLineAdress.h
//  LibUGC
//
//  Created by wnmng on 2017/9/14.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineStreetNumber.h"

@interface OnlineAddress : NSObject

/**
* 县级地址描述
*/
@property(nonatomic,strong) NSString *county;
/**
 * 县级地址编码
 */
@property(nonatomic,strong) NSString *countyCode;

/**
 * 市级地址描述
 */
@property (nonatomic,strong) NSString* city;
/**
 * 市级地址编码
 */
@property(nonatomic,strong) NSString *cityCode;

/**
 * 省级地址描述
 */
@property(nonatomic,strong) NSString *province;

/**
 * 街道、门号信息
 */
@property(nonatomic,strong) OnlineStreetNumber *streetNumber;


@end
