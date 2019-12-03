//
//  SAIDetectView.h
//  Supermap
//
//  Created by zhouyuming on 2019/11/21.
//  Copyright © 2019年 Facebook. All rights reserved.
//
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

#import <React/RCTComponent.h>

#import <Foundation/Foundation.h>
//#import "SuperMapAI/AIDetectView.h"
#import "AIDetectView.h"



@interface SAIDetectView : RCTEventEmitter<RCTBridgeModule,AIDetectTouchDelegate>


+(void)setInstance:(AIDetectView*)aIDetectView;
-(void)initDelegate;
-(void)onclickAIObject:(AIRecognition*)aIRecognition;
+(void)saveArPreviewBitmap:(NSString*)folderPath name:(NSString*)name;
@end
