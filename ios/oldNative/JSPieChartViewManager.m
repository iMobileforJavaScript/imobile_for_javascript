//
//  JSPieChartViewManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/7/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSPieChartViewManager.h"
#import "JSObjManager.h"
#import "SuperMap/PieChart.h"
#import "SuperMap/ChartData.h"

@implementation JSPieChartViewManager
RCT_EXPORT_MODULE(RCTPieChartView);

-(UIView*)view{
    JSPieChart* chart = [[JSPieChart alloc]init];
    return chart;
}

RCT_EXPORT_VIEW_PROPERTY(title, NSString);
RCT_EXPORT_VIEW_PROPERTY(textSize, float);
RCT_EXPORT_VIEW_PROPERTY(radious, float);
RCT_CUSTOM_VIEW_PROPERTY(center, NSArray, JSPieChart){
    NSArray* arr = json?[RCTConvert NSArray:json]:nil;
    NSNumber* num0 = arr[0];
    NSNumber* num1 = arr[1];
    CGPoint point = CGPointMake(num0.floatValue, num1.floatValue);
    view.center = point;
}

RCT_CUSTOM_VIEW_PROPERTY(geoId, int, JSPieChart){
    int GeoId = json?[RCTConvert int:json]:0;
    view.geoId = GeoId;
}

RCT_CUSTOM_VIEW_PROPERTY(textColor, NSArray, JSPieChart){
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
        view.textColor = color;
    } @catch (NSException *exception) {
        NSLog(@"imoble_for_reactnative got exception,info:%@",exception);
    }
}

RCT_CUSTOM_VIEW_PROPERTY(chartDatas, NSArray, JSPieChart){
    @try {
        NSArray* jsObjArr = json ? [RCTConvert NSArray:json] :nil;
        NSMutableArray* dataArr = [[NSMutableArray alloc]initWithCapacity:5];
        for (NSString*objId in jsObjArr) {
            ChartPieData* data = [JSObjManager getObjWithKey:objId];
            [dataArr addObject:data];
        }
        view.chartDatas = dataArr;
    } @catch (NSException *exception) {
        NSLog(@"imoble_for_reactnative got exception,info:%@",exception);
    }
}
@end
