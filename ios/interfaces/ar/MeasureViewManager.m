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

static ARMeasureView* mARMeasureView = nil;


NSString *const onCurrentLengthChanged  = @"onCurrentLengthChanged";
NSString *const onTotalLengthChanged  = @"onTotalLengthChanged";
NSString *const onCurrentToLastPntDstChanged  = @"onCurrentToLastPntDstChanged";
NSString *const onSearchingSurfaces  = @"onSearchingSurfaces";
NSString *const onSearchingSurfacesSucceed  = @"onSearchingSurfacesSucceed";

@implementation MeasureViewManager

RCT_EXPORT_MODULE(RCTMeasureView)

- (NSArray<NSString *> *)supportedEvents {
    return @[
             onCurrentLengthChanged,
             onTotalLengthChanged,
             onCurrentToLastPntDstChanged,
             onSearchingSurfaces,
             onSearchingSurfacesSucceed,
             ];
}

- (UIView *)view
{

    @try {
        CGRect rt = [ UIScreen mainScreen ].bounds;
        mARMeasureView = [[ARMeasureView alloc] initWithFrame:rt];
        
        [SMeasureView setInstance:mARMeasureView];
        [mARMeasureView startARSessionWithMode:AR_MODE_RANGING];
        
        return mARMeasureView;
    } @catch (NSException *exception) {
        NSLog(exception.reason.description);
    }
}
@end
