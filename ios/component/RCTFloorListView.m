//
//  RCTFloorListView.m
//  Supermap
//
//  Created by supermap on 2019/9/25.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "RCTFloorListView.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>


@interface RCTFloorListView(ReactCategory)

//@property (nonatomic, copy) RCTBubblingEventBlock onSymbolClick;

@end

@implementation RCTFloorListView

RCT_EXPORT_MODULE(RCTFloorListView)

-(UIView *)view{
    @try {
        SMap *sMap = [SMap singletonInstance];
        MapControl *mapControl = sMap.smMapWC.mapControl;
        FloorListView *view= [[FloorListView alloc]initWithFrame:CGRectMake(950, 300, 55, 200)];
        [view linkMapControl:mapControl];
        sMap.smMapWC.floorListView = view;
        return view;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return view;
    }
   
}

@end
