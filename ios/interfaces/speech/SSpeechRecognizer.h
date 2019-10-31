//
//  SSpeechRecognizer.h
//  Supermap
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 Facebook. All rights reserved.
//

#ifndef SSpeechRecognizer_h
#define SSpeechRecognizer_h

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <iflyMSC/IFlyMSC.h>
#import "Constants.h"

@interface SSpeechRecognizer :  RCTEventEmitter<RCTBridgeModule>

@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;

@end

#endif /* SSpeechRecognizer_h */
