//
//  AIDetectStyle.h
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/22.
//  Copyright © 2019年 wnmng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AIDetectStyle : NSObject

@property(nonatomic,assign)  BOOL isDrawTitle;
@property(nonatomic,assign)  BOOL isDrawConfidence;
@property(nonatomic,assign)  BOOL isDrawCount;
@property(nonatomic,assign)  BOOL isSameColor;
@property(nonatomic,assign)  UIColor* aiColor;
@property(nonatomic,assign)  float aiStrokeWidth;

@end
