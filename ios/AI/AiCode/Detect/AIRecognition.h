//
//  AIRecognition.h
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/14.
//  Copyright © 2019年 wnmng. All rights reserved.
//
#import <UIKit/UIColor.h>
#import <Foundation/Foundation.h>

@interface AIRecognition : NSObject
@property(nonatomic,strong)  NSString* label;
@property(nonatomic,assign)  float confidence;
@property(nonatomic,strong)  UIColor* displayColor;
@property(nonatomic,assign)  CGRect rect;

-(id)initWith:(NSString*)name confidence:(float)value rect:(CGRect)bounds displayColor:(UIColor*)color;
@end
