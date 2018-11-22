//
//  SMFileUtil.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/20.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface SMFileUtil : NSObject<RCTBridgeModule>
+(BOOL)createFileDirectories:(NSString*)path;
@end
