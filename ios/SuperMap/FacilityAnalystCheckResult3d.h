//
//  FacilityAnalystCheckResult3d.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacilityAnalystCheckResult3d : NSObject

@property (nonatomic,strong,readonly) NSDictionary* nodeErrorInfos;
@property (nonatomic,strong,readonly) NSDictionary* arcErrorInfos;

-(id)initWithNodeErrorInfos:(NSDictionary *)nodeErrorInfos arcErrorInfos:(NSDictionary *)arcErrorInfos;

@end
