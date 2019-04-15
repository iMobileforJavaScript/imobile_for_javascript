//
//  WeightFieldInfo.h
//  prjTest
//
//  Created by imobile on 14-2-12.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 权值字段信息类
 */
@class WeightFieldInfos;
@interface WeightFieldInfo : NSObject{

    WeightFieldInfos *m_owner;
    NSString *_name;
    NSString *_ftWeightField;
    NSString *_tfWeightField;
}

@property(assign,nonatomic)NSString *name;
@property(assign,nonatomic)NSString *ftWeightField;
@property(assign,nonatomic)NSString *tfWeightField;

-(id)initWith:(WeightFieldInfo *)weightFieldInfo;

@end
