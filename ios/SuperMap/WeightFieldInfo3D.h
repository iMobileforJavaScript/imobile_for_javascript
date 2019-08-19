//
//  WeightFieldInfo3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeightFieldInfos3D;
@interface WeightFieldInfo3D : NSObject


@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* ftWeightField;
@property(nonatomic,strong)NSString* tfWeightField;

-(void)setOwner:(WeightFieldInfos3D*)value;
@end
