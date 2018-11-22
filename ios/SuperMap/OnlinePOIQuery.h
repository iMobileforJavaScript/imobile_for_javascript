//
//  OnlinrPOIQuery.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlinePOIQueryParameter.h"
#import "OnlinePOIQueryResult.h"

@protocol OnlinePOIQueryCallback <NSObject>

@required
-(void)querySuccess:(OnlinePOIQueryResult*)result;
-(void)queryFailed:(NSString*)errorInfo;

@end


@interface OnlinePOIQuery : NSObject


@property(nonatomic) id<OnlinePOIQueryCallback> delegate;

-(void)setKey:(NSString*)key;

-(OnlinePOIQueryResult*)queryPOIWithParam:(OnlinePOIQueryParameter*)param;

@end
