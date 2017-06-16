//
//  JSLayerManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSLayerManager.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Map.h"
#import "SuperMap/LayerManager.h"
#import "JSObjManager.h"
@implementation JSLayerManager
RCT_EXPORT_MODULE(RCTLayerListView);
RCT_CUSTOM_VIEW_PROPERTY(bindMapId, NSString, UIView){
    
}
-(UIView*)view{
    MapControl*mapCtrl = [JSObjManager getObjWithKey:@"com.supermap.mapControl"];
    Map * map = mapCtrl.map;
    LayerManager* layerManager = map.layerManager;
    UIView* view = layerManager.layerManagerView;
    
    return view;
}
@end
