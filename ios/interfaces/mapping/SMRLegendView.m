//
//  SMRLegendView.m
//  Supermap
//
//  Created by supermap on 2019/5/6.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "SMRLegendView.h"

@implementation SMRLegendView
RCT_EXPORT_MODULE();

#pragma mark 测试
RCT_REMAP_METHOD(legendLayer, legendLayerIsShow:(BOOL)isShow Orientation: (NSString *)orientation resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
     @try {
        if(isShow){
            //横屏需要重新调整x y的位置 由于ios目前横屏未实现，需要等到实现后修改
            NSUInteger *column = [orientation isEqualToString:@"LANDSCAPE"] ? 4 : 2;
            dispatch_async(dispatch_get_main_queue(), ^{
                SMap *sMap = [SMap singletonInstance];
                Map *map = sMap.smMapWC.mapControl.map;
                LegendView *legendView = map.legend.legendView;
                legendView.xOffset = -10.0;
                legendView.yOffset = -365.0;
                legendView.rowHeight = 50;
                legendView.column = column;
                legendView.fontSize = 8;
                legendView.hidden = NO;
                [legendView refresh];
            });
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"",@"",nil);
    }
}
@end

