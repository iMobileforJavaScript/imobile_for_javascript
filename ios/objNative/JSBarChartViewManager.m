//
//  JSBarChartViewManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/7/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSBarChartViewManager.h"
#import "JSObjManager.h"
#import "SuperMap/BarChart.h"
#import "SuperMap/ChartData.h"
//#import "SuperMap/MapControl.h"
//#import "SuperMap/Map.h"
//#import "SuperMap/Layers.h"
//#import "SuperMap/Layer.h"

@implementation JSBarChartViewManager
RCT_EXPORT_MODULE(RCTBarChartView);

RCT_EXPORT_VIEW_PROPERTY(title, NSString);
RCT_EXPORT_VIEW_PROPERTY(textSize, float);
RCT_EXPORT_VIEW_PROPERTY(isValueAlongXAxis, BOOL);
RCT_EXPORT_VIEW_PROPERTY(axisTitleSize, float);
RCT_EXPORT_VIEW_PROPERTY(axisLableSize, float);
RCT_EXPORT_VIEW_PROPERTY(xAxisTitle, NSString);
RCT_EXPORT_VIEW_PROPERTY(yAxisTitle, NSString);

RCT_CUSTOM_VIEW_PROPERTY(hightLightColor, NSArray, BarChart){
    @try {
        NSArray* colorArr = json ? [RCTConvert NSArray:json] :nil;
        NSNumber* red = colorArr[0];
        NSNumber* green = colorArr[1];
        NSNumber* blue = colorArr[2];
        NSNumber* alpha = [NSNumber numberWithFloat:1.0f];
        if (colorArr.count>=4) {
            alpha = colorArr[3];
        }
        UIColor* color = [UIColor colorWithRed:red.intValue/255 green:green.intValue/255 blue:blue.intValue/255 alpha:alpha.floatValue];
        view.hightLightColor = color;
    } @catch (NSException *exception) {
        NSLog(@"imoble_for_reactnative got exception,info:%@",exception);
    }
}

RCT_CUSTOM_VIEW_PROPERTY(data, NSArray, BarChart){
        NSArray* jsObjArr = json ? [RCTConvert NSArray:json] :nil;
        NSMutableArray* dataArr = [[NSMutableArray alloc]initWithCapacity:5];
        for (NSString*objId in jsObjArr) {
            ChartBarData* data = [JSObjManager getObjWithKey:objId];
            [dataArr addObject:data];
        }
        [view addChartDatas:dataArr];
    [view update];
}

//RCT_CUSTOM_VIEW_PROPERTY(layerIndexWithMapCtrl, NSArray, BarChart){
//    @try {
//        NSArray* arr = json ? [RCTConvert NSArray:json] :nil;
//        NSNumber* index = arr[0];
//        NSString* mapCtrlId = arr[1];
//        MapControl* mapCtrl = [JSObjManager getObjWithKey:mapCtrlId];
//        Map* map = mapCtrl.map;
//        [[map.layers getLayerAtIndex:index.intValue] addChart:view];
//    } @catch (NSException *exception) {
//        NSLog(@"imoble_for_reactnative got exception,info:%@",exception);
//    }
//}

-(UIView*)view{
    BarChart* chart = [[BarChart alloc]init];
    return chart;
}
@end
