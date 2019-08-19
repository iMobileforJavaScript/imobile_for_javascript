//
//  WeightFieldInfos3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeightFieldInfo3D,TransportationAnalystSetting3D,FacilityAnalystSetting3D;
@interface WeightFieldInfos3D : NSObject

-(id)initWithWeightFieldInfos3D:(WeightFieldInfos3D*)weightFieldInfos;
-(WeightFieldInfo3D*)getByIndex:(int)value;
-(WeightFieldInfo3D*)get:(NSString*) value;
-(BOOL)remove:(NSString*)value;
-(BOOL)removeAt:(int)index;
-(int)getCount;
-(int)indexOf:(NSString*)name;
-(int)add:(WeightFieldInfo3D*)value;
-(void)clear;
-(void)copyFrom:(WeightFieldInfos3D*)weightFieldInfos;
-(void) setOwnerNeedSetTrue;
-(void)setOwner:(TransportationAnalystSetting3D*) value;
-(void)setOwner2:(FacilityAnalystSetting3D*)value;
@end
