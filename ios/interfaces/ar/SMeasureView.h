//
//  SMeasureView.h
//  Supermap
//
//  Created by zhouyuming on 2019/12/3.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import "ARMeasureView.h"
#import <React/RCTEventEmitter.h>

@interface SMeasureView : RCTEventEmitter<RCTBridgeModule,ARRangingDelegate>

+(void)setInstance:(ARMeasureView*)aRMeasureView;

-(void)setDelegate;

@end
