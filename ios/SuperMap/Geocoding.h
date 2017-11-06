//
//  Geocoding.h
//  LibUGC
//
//  Created by wnmng on 2017/9/14.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeocodingParameter.h"
#import "GeocodingData.h"

@class Point2D;

@protocol  GeocodingCallback <NSObject>

@optional
-(void)geocodingFailed:(NSString*)strErrorInfo;
-(void)geocodingSuccess:(NSArray*)geocodingDataList;
-(void)reversegeocodingSuccess:(GeocodingData*)geocodingData;

@end

@interface Geocoding : NSObject

@property (nonatomic) id<GeocodingCallback> delegate;

-(void)setKey:(NSString *)strKey;


/**
 * 正向地理编码
 */
-(NSArray*)geocodingWithParam:(GeocodingParameter*)param;

/**
 * 反向地理编码
 */
-(GeocodingData*)reverseGeocoding:(Point2D*)point2d;

@end
