//
//  InfoView.h
//  SuperMapAITest
//
//  Created by zhouyuming on 2019/11/20.
//  Copyright © 2019年 supermap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIDetectStyle.h"
#import "AIRecognition.h"

typedef void(^CallBackBlock)(AIRecognition *aIRecognition); // 返回点击的对象

@interface InfoView : UIView
@property (nonatomic,strong) NSMutableArray *aIRecognitionArray;
@property (nonatomic,strong) NSMutableArray *aIRectArr;
@property (nonatomic,strong) AIDetectStyle* aIDetectStyle;
@property(nonatomic)CGSize sizeCamera;
@property (nonatomic, strong)CallBackBlock callBackBlock;
@property (nonatomic, strong)AIRecognition *clickAIRecognition;
@property (nonatomic,assign) BOOL misPolymerize;  //是否是聚合模式（态势采集）
@property (nonatomic,assign) BOOL misPolyWithRect;  //是否显示聚合模式检测框
@property (nonatomic,assign) int thresholdx;    //聚合阀值宽
@property (nonatomic,assign) int thresholdy;    //聚合阀值高
@property (nonatomic,strong) NSMutableArray* mPolyColorArray;

// 起始点
@property(nonatomic)CGPoint startPoint;
// 是否是点击事件
@property(nonatomic)BOOL isTouchEvent;
-(void)refresh;
//设置是否是聚合模式
-(void)setIsPolymerize:(BOOL)value;
//获取是否是聚合模式
-(BOOL)isPolymerize;
//设置聚合阀值
-(void)setmPolymerizeThreshold:(int)thresholdx withy:(int)thresholdy;
@end
