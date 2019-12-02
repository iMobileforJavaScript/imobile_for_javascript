//
//  SAIDetectView.h
//  Supermap
//
//  Created by zhouyuming on 2019/11/21.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>

#import <Foundation/Foundation.h>
//#import "SuperMapAI/AIDetectView.h"
#import <SuperMapAI/AIDetectView.h>


@interface SAIDetectView : NSObject<RCTBridgeModule>

+(void)setInstance:(AIDetectView*)aIDetectView;

@end
