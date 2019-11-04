//
//  SSpeechRecognizer.m
//  Supermap
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SSpeechRecognizer.h"

@interface SSpeechRecognizer(){

}
@end

@implementation SSpeechRecognizer

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *) supportedEvents{
    return @[
             RECOGNIZE_BEGIN,
             RECOGNIZE_END,
             RECOGNIZE_ERROR,
             RECOGNIZE_EVENT,
             RECOGNIZE_RESULT,
             RECOGNIZE_VOLUME_CHANGED
             ];
}

RCT_EXPORT_METHOD(init: (NSString *) AppId
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {
    @try {
        if (self.iFlySpeechRecognizer != nil) {
            return;
        }
        
        NSString * initIFlytekString = [[NSString alloc] initWithFormat: @"appid=%@", AppId];
        
        [IFlySpeechUtility createUtility: initIFlytekString];
        
        self.iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        self.iFlySpeechRecognizer.delegate = self;
        [self.iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        [self.iFlySpeechRecognizer setParameter:@"5000" forKey:[IFlySpeechConstant VAD_BOS]];
        [self.iFlySpeechRecognizer setParameter:@"2000" forKey:[IFlySpeechConstant VAD_EOS]];
        [self.iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
       resolve([NSNumber numberWithBool:YES]);
    } @catch(NSException * e) {
       reject(@"init", e.reason, nil);
    }
}

RCT_EXPORT_METHOD(start: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {
    @try {
        if ([self.iFlySpeechRecognizer isListening]) {
            [self.iFlySpeechRecognizer cancel];
        }
        
        [self.iFlySpeechRecognizer startListening];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException * e){
        reject(@"start", e.reason, nil);
    }
    
}

RCT_EXPORT_METHOD(cancel: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {
    @try{
        if ([self.iFlySpeechRecognizer isListening]) {
            [self.iFlySpeechRecognizer cancel];
        }
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException * e){
        reject(@"cancel", e.reason, nil);
    }
}

RCT_EXPORT_METHOD(isListening: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {
    @try {
        BOOL isListening = [self.iFlySpeechRecognizer isListening];
        resolve([NSNumber numberWithBool: isListening]);
    } @catch (NSException * e) {
        reject(@"isListening", e.reason, nil);
    }
}

RCT_EXPORT_METHOD(stop: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {
    @try {
        if ([self.iFlySpeechRecognizer isListening]) {
            [self.iFlySpeechRecognizer stopListening];
        }
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException * e) {
        reject(@"stop", e.reason, nil);
    }
}

RCT_EXPORT_METHOD(setParameter: (NSString *) parameter
                  value: (NSString *) value
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {
    @try{
        if ([parameter isEqualToString: IFlySpeechConstant.ASR_AUDIO_PATH]) {
            value = [self getAbsolutePath: value];
        }
        [self.iFlySpeechRecognizer setParameter: value forKey: parameter];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException * e) {
        reject(@"setParameter", e.reason, nil);
    }
}

RCT_EXPORT_METHOD(getParameter: (NSString *) parameter
                  resolver: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject) {
    @try {
        NSString * value = [self.iFlySpeechRecognizer parameterForKey: parameter];
        resolve(value);
    } @catch (NSException * e) {
        reject(@"getParameter", e.reason, nil);
    }
}

- (void) onBeginOfSpeech {
     [self sendEventWithName: RECOGNIZE_BEGIN body: [NSNumber numberWithBool:YES]];
}

- (void) onEndOfSpeech {
     [self sendEventWithName: RECOGNIZE_END body: [NSNumber numberWithBool:YES]];
}

- (void) onCompleted:(IFlySpeechError *) error {
    if(error != nil && error.errorCode != 0 ) {
        NSString * errorString = error.errorDesc;
        [self sendEventWithName: RECOGNIZE_ERROR body: errorString];
    }
}

- (void) onResults: (NSArray *) results isLast: (BOOL) isLast {
    NSMutableString * resultString = [NSMutableString new];
    NSDictionary * dic = results[0];
    
    for (NSString * key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson = [self stringFromJson:resultString];
    
    NSDictionary * result = @{
                              @"info": resultFromJson,
                              @"isLast": [NSNumber numberWithBool: isLast],
                              };
    
    [self sendEventWithName: RECOGNIZE_RESULT body: result];
}

- (void) onVolumeChanged: (int)volume {
    NSDictionary * result = @{
                              @"volume": [NSNumber numberWithInt: volume]
                              };
    [self sendEventWithName: RECOGNIZE_VOLUME_CHANGED body: result];
    
}

- (NSString *) stringFromJson: (NSString *) params {
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

- (NSString *) getAbsolutePath: (NSString *) path {
    NSString * homePath = NSHomeDirectory();
    
    path = [path stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"/"]];
    
    return [NSString stringWithFormat:@"%@/%@", homePath, path];
}


@end
