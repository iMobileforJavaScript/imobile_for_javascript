//
//  SIPortalService.h
//  Supermap
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019 Facebook. All rights reserved.
//

#ifndef SIPortalService_h
#define SIPortalService_h

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/IPortalService.h"
#import "Constants.h"

@interface SIPortalService :  RCTEventEmitter<RCTBridgeModule, IPotalResponseDelegate, IPotalProgressListener>

@end

#endif /* SIPortalService_h */
