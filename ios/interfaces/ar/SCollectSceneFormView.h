//
//  SCollectSceneFormView.h
//  Supermap
//
//  Created by wnmng on 2020/2/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTComponent.h>
#import <Foundation/Foundation.h>
#import "ARCollectorView.h"


@interface SCollectSceneFormView :RCTEventEmitter<RCTBridgeModule,arLengthChangeDelegate>

+(ARCollectorView*)shareInstance;
+(void)setInstance:(ARCollectorView*)aICollectView;

@end
