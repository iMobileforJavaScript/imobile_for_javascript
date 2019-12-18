//
//  SNavigationManager.h
//  Supermap
//
//  Created by jiushuaizhao on 2019/12/16.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMap.h"

@interface SNavigationManager : RCTEventEmitter<RCTBridgeModule,navigation2ChangedDelegate,NaviListener,Navigation3ChangedDelegate>

@end
