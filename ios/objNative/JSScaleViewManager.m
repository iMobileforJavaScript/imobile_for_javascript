//
//  JSScaleViewManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSScaleViewManager.h"
#import "SuperMap/ScaleView.h"
#import "JSObjManager.h"
@implementation JSScaleViewManager
RCT_EXPORT_MODULE(RCTScaleView);
RCT_CUSTOM_VIEW_PROPERTY(mapId, NSString, ScaleView){
    MapControl* mapcontrol = [JSObjManager getObjWithKey:json ? [RCTConvert NSString:json] : nil];
    if (mapcontrol) {
        id newView = [view initWithMapControl:mapcontrol];
    }
}
-(UIView*)view{
    ScaleView* view = [[ScaleView alloc]init];
    
    return view;
}
@end
