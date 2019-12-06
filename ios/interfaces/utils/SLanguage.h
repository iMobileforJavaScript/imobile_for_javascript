//
//  SLanguage.h
//  Supermap
//
//  Created by zhiyan xie on 2019/12/6.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface SLanguage : NSObject<RCTBridgeModule>
+(NSString*)getLanguage;
@end


