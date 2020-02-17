//
//  SIllegallyParkView.m
//  Supermap
//
//  Created by wnmng on 2020/1/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "SIllegallyParkView.h"
#import "SLanguage.h"
#import "Constants.h"

@implementation SIllegallyParkView

RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             ILLEGALLYPARK,
             ];
}


//static SIllegallyParkView *sIllegallyParkView = nil;
static AIPlateCollectionView* aiPlateCollection = nil;


//+(id)allocWithZone:(NSZone *)zone {
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    sIllegallyParkView = [super allocWithZone:zone];
//  });
//  return sIllegallyParkView;
//}

//+ (instancetype)singletonInstance{
//    
//    static dispatch_once_t once;
//    
//    dispatch_once(&once, ^{
//        sIllegallyParkView = [[self alloc] init];
//    });
//
//    return sIllegallyParkView;
//}

+(AIPlateCollectionView*)shareInstance{
    return aiPlateCollection;
}

+(void)setInstance:(AIPlateCollectionView*)aICollectView{
    aiPlateCollection = aICollectView;
    
//    NSString* modelPath= [[NSBundle mainBundle] pathForResource:@"detect" ofType:@"tflite"];
//    NSString* labelsPath = [[NSBundle mainBundle] pathForResource:@"labelmap_cn" ofType:@"txt"];
//    if([[SLanguage getLanguage] isEqualToString:@"EN"]){
//        labelsPath = [[NSBundle mainBundle] pathForResource:@"labelmap" ofType:@"txt"];
//    }
//    [aiPlateCollection loadDetectModle:modelPath labels:labelsPath];
    
    //[aiPlateCollection startCollection];
}

-(void)collectedPlate:(NSString*)strPlate carType:(NSString*)carType colorDescription:(NSString*)strColor andImage:(UIImage*)carImage{
    
    [self submit:carImage];

}
-(void)submit:(UIImage *)image{

    NSDate *date = [NSDate date];
    //如果没有规定formatter的时区，那么formatter默认的就是当前时区，比如现在在北京就是东八区，在东京就是东九区
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //最结尾的Z表示的是时区，零时区表示+0000，东八区表示+0800
    //[formatter setDateFormat:@"yyyy-MM-dd&HH:mm:ss"];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    // 使用formatter转换后的date字符串变成了当前时区的时间
    NSString *dateStr = [formatter stringFromDate:date];
//    NSArray<NSString *> *arrDate =  [dateStr componentsSeparatedByString:@"&"];
    
   // NSString *strDir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/AIPhoto/%@",arrDate[0]];
     
    NSString *strDir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/iTablet/User/Customer/Data/Media"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = false;
    BOOL isExist = [manager fileExistsAtPath:strDir isDirectory:&isDir];
    if (!isExist || !isDir) {
        [manager createDirectoryAtPath:strDir withIntermediateDirectories:YES attributes:nil error:nil];
    }

    //NSString *strPath = [NSString stringWithFormat:@"%@/IMG_%@.png",strDir,arrDate[1]];
    NSString *strPath = [NSString stringWithFormat:@"%@/IMG_%@.png",strDir,dateStr];
    
    isDir = true;
    isExist = [manager fileExistsAtPath:strPath isDirectory:&isDir];
    if (isExist && !isDir) {
        [manager removeItemAtPath:strPath error:nil];
    }

    //NSString *strNewPath = [NSString stringWithFormat:@"/iTablet/User/Customer/Data/Media/%@.png",dateStr];
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:strPath atomically:YES];
    
    [self sendEventWithName:ILLEGALLYPARK
                           body:strPath
                           ];

}

#pragma mark ----------------onStop--------RN--------
RCT_REMAP_METHOD(onStop, onStop:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (aiPlateCollection!=nil) {
            [aiPlateCollection stopCollection];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"onStop", exception.reason, nil);
    }
}

#pragma mark ----------------onStart--------RN--------
RCT_REMAP_METHOD(onStart, onStart:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (aiPlateCollection!=nil) {
            [aiPlateCollection startCollection];
            [aiPlateCollection setDelegate:self];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"onStart", exception.reason, nil);
    }
}

#pragma mark ----------------onDestroy--------RN--------"
RCT_REMAP_METHOD(onDestroy, onDestroy:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (aiPlateCollection!=nil) {
            [aiPlateCollection stopCollection];
            [aiPlateCollection dispose];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"onStart", exception.reason, nil);
    }
}


@end
