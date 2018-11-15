//
//  CoordinateConvert.h
//  LibUGC
//
//  Created by wnmng on 2017/9/14.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateConvertParameter.h"

@protocol  CoordinateConvertCallback <NSObject>

-(void)convertSuccess:(Point2Ds*)pnt2Ds;
-(void)convertFailed:(NSString*)strErrorInfo;

@end

@interface CoordinateConvert : NSObject

@property (nonatomic) id<CoordinateConvertCallback> delegate;


-(Point2Ds*)convertWithParameter:(CoordinateConvertParameter*)param andKey:(NSString*)strKey;

@end
