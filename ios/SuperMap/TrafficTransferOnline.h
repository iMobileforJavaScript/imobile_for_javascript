//
//  TrafficTransferOnline.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrafficTransferParameter.h"
#import "TrafficTransferOnlineData.h"

@protocol TrafficTransferOnlineCallback <NSObject>

@required
-(void)transferFailed:(NSString*)errorInfo;
-(void)transferSuccess:(TrafficTransferOnlineData*)data;

@end

@interface TrafficTransferOnline : NSObject

@property (nonatomic) id<TrafficTransferOnlineCallback> delegate;

-(void)setKey:(NSString*)strKey;

-(TrafficTransferOnlineData*)trafficTransferFrom:(Point2D*)startPnt to:(Point2D*)endPnt withParam:(TrafficTransferParameter*)param;

@end
