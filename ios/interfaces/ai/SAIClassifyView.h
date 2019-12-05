//
//  SAIClassifyView.h
//  Supermap
//
//  Created by zhouyuming on 2019/11/22.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

#import <Foundation/Foundation.h>

@interface SAIClassifyView : RCTEventEmitter<RCTBridgeModule>
//@interface SAIClassifyView : NSObject<RCTBridgeModule>

+(void)saveClassifyBitmapAsFile:(NSString*)folderPath name:(NSString*)name;
@end
