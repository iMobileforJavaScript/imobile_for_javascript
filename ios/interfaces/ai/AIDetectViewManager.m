//
//  AIDetectViewManager.m
//  Supermap
//
//  Created by zhouyuming on 2019/11/21.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "AIDetectViewManager.h"
#import "SAIDetectView.h"
#import <React/RCTUIManager.h>
#import "SuperMapAI/AIDetectView.h"

@interface AIDetectViewManager ()

@property (nonatomic, strong) SAIDetectView *sAIDetectView;

@end

@implementation AIDetectViewManager

RCT_EXPORT_MODULE(RCTAIDetectView)

-(UIView *)view{
    @try {
//        UIView* uiView=[[UIView alloc] initWithFrame:CGRectZero];
        
        CGRect rt = [ UIScreen mainScreen ].bounds;
        UIView* uiView=[[UIView alloc] initWithFrame:rt];
        
        AIDetectView* aIDetectView=[[AIDetectView alloc] initWithFrame:uiView.frame];
        [SAIDetectView setInstance:aIDetectView];
        
        [uiView addSubview:aIDetectView];
        
        return uiView;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
        
        UIView* uiView=[[UIView alloc] initWithFrame:CGRectZero];
        
        return uiView;
    }
    
}

@end
