//
//  TransportationAnalystCheckResult3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportationAnalystCheckResult3D : NSObject

-(id)initWithInfos:(NSDictionary*)nodeErrorInfos ArcErrorInfos:(NSDictionary*)arcErrorInfos;
-(NSDictionary*)getNodeErrorInfos;
-(NSDictionary*)getArcErrorInfos;
@end
