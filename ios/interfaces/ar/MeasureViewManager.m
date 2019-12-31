//
//  MeasureViewManager.m
//  Supermap
//
//  Created by zhouyuming on 2019/12/3.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "MeasureViewManager.h"
#import "SuperMap/LocationManagePlugin.h"
#import "SMCollector.h"
#import "LocationTransfer.h"
#import "SMeasureView.h"
#import <React/RCTUIManager.h>
#import <React/RCTConvert.h>
#import <UIKit/UIKit.h>
#import "SLanguage.h"

static ARMeasureView* mARMeasureView = nil;

@implementation MeasureViewManager

RCT_EXPORT_MODULE(RCTMeasureView)


- (UIView *)view
{

    @try {
        CGRect rt = [ UIScreen mainScreen ].bounds;
//        mARMeasureView = [[ARMeasureView alloc] initWithFrame:rt];
        NSString* language=[SLanguage getLanguage];
        mARMeasureView = [[ARMeasureView alloc] initWithFrame:rt withLanguage:language];
        [SMeasureView setInstance:mARMeasureView];
        [mARMeasureView startARSessionWithMode:AR_MODE_RANGING];
        
        return mARMeasureView;
    } @catch (NSException *exception) {
        NSLog(exception.reason.description);
    }
}
@end
