//
//  OnlinePOIQueryResult.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlinePOIInfo.h"

@interface OnlinePOIQueryResult : NSObject

@property (nonatomic,assign) int count;
@property (nonatomic,strong) NSArray *poiInfos;

@end
