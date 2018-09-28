//
//  SceneViewManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/4/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "SceneViewManager.h"
#import "JSSceneView.h"
#import "JSObjManager.h"

#import <React/RCTEventDispatcher.h>

#import <React/RCTConvert.h>
#import <React/UIView+React.h>
#import <objc/runtime.h>
#import <React/RCTUIManager.h>
#import <React/RCTWebView.h>

@interface JSSceneView(ReactSceneCategory)

@property (nonatomic, strong) SceneViewManager *sceneViewManger;
@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@end

@implementation JSSceneView (ReactSceneCategory)


-(void)setSceneViewManger:(SceneViewManager *)sceneViewManger{
    objc_setAssociatedObject(self, @selector(sceneViewManger), sceneViewManger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(SceneViewManager*)sceneViewManger{
    return (SceneViewManager *)objc_getAssociatedObject(self, @selector(sceneViewManger));
}

-(void)setOnChange:(RCTBubblingEventBlock)onChange{
    objc_setAssociatedObject(self, @selector(onChange), onChange, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.onChange)
    {
        self.onChange(@{@"sceneControlId":@((NSUInteger)self).stringValue});
    }
}
-(RCTBubblingEventBlock)onChange{
    return (RCTBubblingEventBlock)objc_getAssociatedObject(self, @selector(onChange));
}
@end

@implementation SceneViewManager
RCT_EXPORT_MODULE(RCTSceneView);
RCT_EXPORT_VIEW_PROPERTY(onChange, RCTBubblingEventBlock)

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
static JSSceneView* g_sceneView = nil;
- (UIView *)view
{
    if(!g_sceneView){
        g_sceneView = [[JSSceneView alloc]init];
        [JSObjManager addObj:g_sceneView];
    }
    
//    SceneControl* sceneControl = [[SceneControl alloc]init];
    g_sceneView.sceneViewManger = self;
//    sceneControl.tracked3DDelegate = self;
//    sceneControl.tracking3DDelegate = self;
//    sceneControl.sceneControlDelegate = self;
    
    return g_sceneView;
}

-(dispatch_queue_t)methodQueue{
    return dispatch_get_main_queue();
}
@end
