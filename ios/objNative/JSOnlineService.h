//
//  JSOnlineService.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/8/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/OnlineService.h"

@interface JSOnlineService : RCTEventEmitter<RCTBridgeModule, OnlineServiceUploadDelegate>

@end
