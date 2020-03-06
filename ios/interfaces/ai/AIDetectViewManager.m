//
//  AIDetectViewManager.m
//  Supermap
//
//  Created by zhouyuming on 2019/11/21.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "AIDetectViewManager.h"
#import "SAIDetectView.h"
#import <React/RCTUIManager.h>
#import "AIDetectView.h"
#import "AIRecognition.h"
#import <React/RCTConvert.h>
#import "SMITabletUtils.h"



@interface AIView:UIView //(ReactCategory)

@property (nonatomic, copy) RCTBubblingEventBlock onArObjectClick;
@end

@implementation AIView //(ReactCategory)

-(void)setOnArObjectClick:(RCTBubblingEventBlock)onArObjectClick{
    id property = objc_getAssociatedObject(self, @selector(onArObjectClick));
    
    if (property == nil) {
        objc_setAssociatedObject(self, @selector(onArObjectClick), onArObjectClick, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    //    if(self.onSymbolClick)
    //    {
    //        self.onSymbolClick(@{@"mapViewId":@((NSUInteger)self).stringValue});
    //    }
}
-(RCTBubblingEventBlock)onArObjectClick{
    return (RCTBubblingEventBlock)objc_getAssociatedObject(self, @selector(onArObjectClick));
}
@end


static AIView* uiView = nil;
@interface AIDetectViewManager ()<AIDetectTouchDelegate>



@property (nonatomic, strong) SAIDetectView *sAIDetectView;
@property(nonatomic,copy)RCTBubblingEventBlock onArObjectClick;


@end

@implementation AIDetectViewManager

static AIDetectView* aIDetectView;

RCT_EXPORT_MODULE(RCTAIDetectView)

//  事件的导出，onArObjectClick对应view中扩展的属性
RCT_EXPORT_VIEW_PROPERTY(onArObjectClick, RCTBubblingEventBlock)

-(UIView *)view{
    @try {
//        UIView* uiView=[[UIView alloc] initWithFrame:CGRectZero];
        
        CGRect rt = [ UIScreen mainScreen ].bounds;
        uiView=[[AIView alloc] initWithFrame:rt];
        
        aIDetectView=[[AIDetectView alloc] initWithFrame:uiView.frame];
//        SAIDetectView* sAIDetectView=[[SAIDetectView alloc] init];
//        _sAIDetectView=[[SAIDetectView alloc] init];
        [SAIDetectView setInstance:aIDetectView];
        aIDetectView.delegate=self;
//        [sAIDetectView initDelegate];
        
        [uiView addSubview:aIDetectView];
        
        NSString* error =  [SMITabletUtils checkLicValid];
           if(error != nil){
               [SMITabletUtils addLicView:uiView text:error];
           }
        
        return uiView;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
        
        UIView* uiView=[[UIView alloc] initWithFrame:CGRectZero];
        
        return uiView;
    }
    
}

-(void)setOnArObjectClick:(RCTBubblingEventBlock)onArObjectClick{
    id property = objc_getAssociatedObject(self, @selector(onArObjectClick));
    
    if (property == nil) {
        objc_setAssociatedObject(self, @selector(onArObjectClick), onArObjectClick, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    //    if(self.onSymbolClick)
    //    {
    //        self.onSymbolClick(@{@"mapViewId":@((NSUInteger)self).stringValue});
    //    }
}
-(RCTBubblingEventBlock)onArObjectClick{
    return (RCTBubblingEventBlock)objc_getAssociatedObject(self, @selector(onArObjectClick));
}

#pragma mark 点击识别目标回调
-(void)touchAIRecognition:(AIRecognition*)aIRecognition{
    if(!aIRecognition){
        return;
    }
//    [_sAIDetectView onclickAIObject:aIRecognition];
    @try {
        
        NSMutableDictionary* info=[[NSMutableDictionary alloc] init];
        
        [info setValue:0 forKey:@"id"];
        NSString* name=[NSString stringWithFormat:@"%@_%@",[self currentdateInterval],aIRecognition.label];
        [info setValue:name forKey:@"name"];
        
        NSMutableDictionary* arInfo=[[NSMutableDictionary alloc] init];
        [arInfo setValue:aIRecognition.label forKey:@"mediaName"];
        [info setValue:aIRecognition.label forKey:@"info"];
        
        //        [self sendEventWithName:onArObjectClick body:info];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            uiView.onArObjectClick(info);
        });
    } @catch (NSException *exception) {
        NSString* reason=exception.reason;
    }
}

-(NSString *)currentdateInterval
{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];
    return timeSp;
}


@end
