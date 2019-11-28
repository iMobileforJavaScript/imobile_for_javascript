//
//  Recognition.h
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/13.
//  Copyright © 2019年 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recognition : NSObject
@property(nonatomic,strong)  NSString* label;
@property(nonatomic,assign)  float confidence;
-(id)initWith:(NSString*)name confidence:(float)value;
@end
