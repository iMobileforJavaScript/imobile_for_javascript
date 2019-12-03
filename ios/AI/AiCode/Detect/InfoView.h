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
@property (nonatomic,strong) NSArray *aIRecognitionArray;
@property (nonatomic,retain) NSMutableArray *aIRectArr;
@property (nonatomic,assign) AIDetectStyle* aIDetectStyle;

@property (nonatomic, copy)CallBackBlock callBackBlock;

// 起始点
@property(nonatomic)CGPoint startPoint;
// 是否是点击时间
@property(nonatomic)BOOL isTouchEvent;
-(void)refresh;
@end
