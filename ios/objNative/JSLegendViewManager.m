//
//  JSLegendViewManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSLegendViewManager.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Map.h"
#import "SuperMap/Legend.h"
#import "SuperMap/LegendView.h"
#import "JSObjManager.h"
@implementation JSLegendViewManager
RCT_EXPORT_MODULE(RCTLegendView);
RCT_CUSTOM_VIEW_PROPERTY(mapId, NSString, LegendView){

}
-(UIView*)view{
    MapControl*mapCtrl = [JSObjManager getObjWithKey:@"com.supermap.mapControl"];
    Map * map = mapCtrl.map;
    Legend* legend = map.legend;
    LegendView* view = legend.legendView;
    
    return view;
}
@end
