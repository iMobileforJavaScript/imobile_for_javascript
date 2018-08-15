//
//  JSNavigation.h
//  Supermap
//
//  Created by 王子豪 on 2017/3/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//


#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/Navigation.h"
@interface JSNavigation : RCTEventEmitter<RCTBridgeModule,NaviListener>

@end
