//
//  JSTimeLine.m
//  Supermap
//
//  Created by 王子豪 on 2017/7/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSTimeLine.h"
#import "SuperMap/TimeLine.h"
#import "SuperMap/ChartView.h"
#import "JSObjManager.h"

@implementation JSTimeLine
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,createObjByReactTag:(int)tag resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RCTUIManager *uiManager = self.bridge.uiManager;
        //UIView* view = [uiManager viewForReactTag:[NSNumber numberWithInt:tag]];
        dispatch_async(uiManager.methodQueue, ^{
            [uiManager addUIBlock:^(RCTUIManager* uiManager,NSDictionary<NSNumber*,UIView*> *viewRegistry){
                UIView* view = [viewRegistry objectForKey:[NSNumber numberWithInt:tag]];
                TimeLine* timeLine = [[TimeLine alloc]initWithHostView:view];
                NSInteger nsKey = (NSInteger)timeLine;
                [JSObjManager addObj:timeLine];
                resolve(@{@"_SMTimeLine":@(nsKey).stringValue});
            }];
        });
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"createObj() expection.",nil);
    }
}

RCT_REMAP_METHOD(setSliderSize,setSliderSizeById:(NSString*)Id size:(float)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        timeLine.sliderSize =size;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setSliderSize() expection.",nil);
    }
}

RCT_REMAP_METHOD(getSliderSize,getSliderSizeById:(NSString*)Id size:(float)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        float size = timeLine.sliderSize;
        NSNumber* num = [NSNumber numberWithFloat:size];
        resolve(@{@"size":num});
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getSliderSize() expection.",nil);
    }
}

RCT_REMAP_METHOD(setSliderImage,setSliderImageById:(NSString*)Id url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        UIImage* image = [UIImage imageNamed:url];
        timeLine.sliderImage =image;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setSliderImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(getSliderImage,getSliderImageById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSException* exception = [NSException exceptionWithName:@"com.supermap.exception" reason:@"getSliderImage方法暂不支持iOS设备。" userInfo:nil];
        @throw exception;
//        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
//        UIImage* image = timeLine.sliderImage;
        
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getSliderSize() expection.",nil);
    }
}

RCT_REMAP_METHOD(setSliderSelectedImage,setSliderSelectedImageById:(NSString*)Id url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        UIImage* image = [UIImage imageNamed:url];
        timeLine.sliderSelectedImage =image;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setSliderSelectedImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(getSliderSelectedImage,getSliderSelectedImageById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSException* exception = [NSException exceptionWithName:@"com.supermap.exception" reason:@"getSliderSelectedImage方法暂不支持iOS设备。" userInfo:nil];
        @throw exception;
        //        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        //        UIImage* image = timeLine.sliderSelectedImage;
        
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getSliderSelectedImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(setSliderLabelSize,setSliderLabelSizeById:(NSString*)Id size:(float)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        timeLine.sliderTextSize =size;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setSliderLabelSize() expection.",nil);
    }
}

RCT_REMAP_METHOD(getSliderLabelSize,getSliderLabelSizeById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        float size = timeLine.sliderTextSize;
        NSNumber* num = [NSNumber numberWithFloat:size];
        resolve(@{@"size":num});
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getSliderSelectedImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(setSliderLabelColor,setSliderLabelSizeById:(NSString*)Id color:(NSArray*)colorArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        NSNumber* red = colorArr[0];
        NSNumber* green = colorArr[1];
        NSNumber* blue = colorArr[2];
        NSNumber* alpha = [NSNumber numberWithDouble:1.0f];
        if (colorArr.count>3) {
            alpha = colorArr[3];
        }
        UIColor* color = [UIColor colorWithRed:red.floatValue/255 green:green.floatValue/255 blue:blue.floatValue/255 alpha:alpha.floatValue];
        timeLine.sliderTextColor = color;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setSliderLabelColor() expection.",nil);
    }
}

RCT_REMAP_METHOD(getSliderLabelColor,getSliderLabelColorById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        UIColor* color = timeLine.sliderTextColor;
        CGFloat red = 0.0;
        CGFloat green = 0.0;
        CGFloat blue = 0.0;
        CGFloat alpha = 0.0;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        NSNumber* redObj = [NSNumber numberWithFloat:red*255];
        NSNumber* greenObj =[NSNumber numberWithFloat:green*255];
        NSNumber* blueObj = [NSNumber numberWithFloat:blue*255];
        NSNumber* alphaObj =[NSNumber numberWithFloat:alpha];
        resolve(@{@"color":@[redObj,greenObj,blueObj,alphaObj]});
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getSliderLabelColor() expection.",nil);
    }
}

RCT_REMAP_METHOD(setTimeLineColor,setTimeLineColorById:(NSString*)Id color:(NSArray*)colorArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        NSNumber* red = colorArr[0];
        NSNumber* green = colorArr[1];
        NSNumber* blue = colorArr[2];
        NSNumber* alpha = [NSNumber numberWithDouble:1.0f];
        if (colorArr.count>3) {
            alpha = colorArr[3];
        }
        UIColor* color = [UIColor colorWithRed:red.floatValue/255 green:green.floatValue/255 blue:blue.floatValue/255 alpha:alpha.floatValue];
        timeLine.timeLineColor = color;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setTimeLineColor() expection.",nil);
    }
}

RCT_REMAP_METHOD(getTimeLineColor,getTimeLineColorById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        UIColor* color = timeLine.timeLineColor;
        CGFloat red = 0.0;
        CGFloat green = 0.0;
        CGFloat blue = 0.0;
        CGFloat alpha = 0.0;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        NSNumber* redObj = [NSNumber numberWithFloat:red*255];
        NSNumber* greenObj =[NSNumber numberWithFloat:green*255];
        NSNumber* blueObj = [NSNumber numberWithFloat:blue*255];
        NSNumber* alphaObj =[NSNumber numberWithFloat:alpha];
        resolve(@{@"color":@[redObj,greenObj,blueObj,alphaObj]});
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getTimeLineColor() expection.",nil);
    }
}

RCT_REMAP_METHOD(setPlayImage,setPlayImageById:(NSString*)Id url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        UIImage* image = [UIImage imageNamed:url];
        timeLine.playImage =image;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setPlayImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(getPlayImage,getPlayImageById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSException* exception = [NSException exceptionWithName:@"com.supermap.exception" reason:@"getSliderSelectedImage方法暂不支持iOS设备。" userInfo:nil];
        @throw exception;
        //        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        //        UIImage* image = timeLine.playImage;
        
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getPlayImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(setStopPlayImage,setStopPlayImageById:(NSString*)Id url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        UIImage* image = [UIImage imageNamed:url];
        timeLine.pausePlayImage =image;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setStopPlayImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(getStopPlayImage,getStopPlayImageById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSException* exception = [NSException exceptionWithName:@"com.supermap.exception" reason:@"getSliderSelectedImage方法暂不支持iOS设备。" userInfo:nil];
        @throw exception;
        //        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        //        UIImage* image = timeLine.pausePlayImage;
        
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"getStopPlayImage() expection.",nil);
    }
}

RCT_REMAP_METHOD(setHorizontal,setHorizontalById:(NSString*)Id boolean:(BOOL)boolean resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
//        timeLine.isHorizontal =boolean;
//        NSNumber* num = [NSNumber numberWithBool:true];
//        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"setHorizontal() expection.",nil);
    }
}

RCT_REMAP_METHOD(isHorizontal,isHorizontalById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
//        BOOL boolean = timeLine.isHorizontal;
//        NSNumber* num = [NSNumber numberWithBool:boolean];
//        resolve(@{@"bool":num});
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"isHorizontal() expection.",nil);
    }
}

RCT_REMAP_METHOD(addChart,addChartById:(NSString*)Id chartId:(NSString*)chartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        ChartView* chart = [JSObjManager getObjWithKey:chartId];
        [timeLine addChart:chart];
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"addChart() expection.",nil);
    }
}

RCT_REMAP_METHOD(removeChart,removeChartById:(NSString*)Id chartId:(NSString*)chartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        ChartView* chart = [JSObjManager getObjWithKey:chartId];
        [timeLine removeChart:chart];
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"removeChart() expection.",nil);
    }
}

RCT_REMAP_METHOD(clearChart,clearChartById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        [timeLine clearChart];
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"clearChart() expection.",nil);
    }
}

RCT_REMAP_METHOD(load,loadById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TimeLine* timeLine = [JSObjManager getObjWithKey:Id];
        [timeLine load];
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"TimeLine",@"load() expection.",nil);
    }
}
@end
