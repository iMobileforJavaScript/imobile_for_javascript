//
//  JSMap.h
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/Map.h"
@interface JSMap : RCTEventEmitter<RCTBridgeModule,MapLoadDelegate,MapParameterChangedDelegate>

@end
