//
//  SOnlineService.h
//  Supermap
//
//  Created by supermap on 2018/11/6.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/OnlineService.h"
@interface SOnlineService :  RCTEventEmitter<RCTBridgeModule, OnlineServiceUploadDelegate, OnlineServiceDownloadDelegate>

@end
