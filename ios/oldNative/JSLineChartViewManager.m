//
//  JSLineChartViewManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/7/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSLineChartViewManager.h"
#import "JSObjManager.h"
#import "SuperMap/LineChart.h"
#import "SuperMap/ChartData.h"

@implementation JSLineChartViewManager
RCT_EXPORT_MODULE(RCTLineChartView);
-(UIView*)view{
    JSLineChart* chart = [[JSLineChart alloc]init];
    return chart;
}

RCT_EXPORT_VIEW_PROPERTY(title, NSString);
RCT_EXPORT_VIEW_PROPERTY(textSize, float);
RCT_EXPORT_VIEW_PROPERTY(axisTitleSize, float);
RCT_EXPORT_VIEW_PROPERTY(axisLableSize, float);
RCT_EXPORT_VIEW_PROPERTY(xAxisTitle, NSString);
RCT_EXPORT_VIEW_PROPERTY(yAxisTitle, NSString);
RCT_EXPORT_VIEW_PROPERTY(allowsUserInteraction, BOOL);

RCT_CUSTOM_VIEW_PROPERTY(hightLightColor, NSArray, JSLineChart){
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

RCT_CUSTOM_VIEW_PROPERTY(geoId, int, JSLineChart){
    int geoId = json?[RCTConvert int:json]:0;
    view.geoId = geoId;
}

RCT_CUSTOM_VIEW_PROPERTY(chartDatas, NSArray, JSLineChart){
    @try {
        NSArray* jsObjArr = json ? [RCTConvert NSArray:json] :nil;
        NSMutableArray* dataArr = [[NSMutableArray alloc]initWithCapacity:5];
        for (NSString*objId in jsObjArr) {
            ChartLineData* data = [JSObjManager getObjWithKey:objId];
            [dataArr addObject:data];
        }
        view.chartDatas = dataArr;
    } @catch (NSException *exception) {
        NSLog(@"imoble_for_reactnative got exception,info:%@",exception);
    }
}

@end
