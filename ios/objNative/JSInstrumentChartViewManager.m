//
//  JSInstrumentChartViewManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/7/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSInstrumentChartViewManager.h"
#import "JSObjManager.h"
#import "SuperMap/InstrumentChart.h"
#import "SuperMap/ChartView.h"
@implementation JSInstrumentChartViewManager
RCT_EXPORT_MODULE(RCTInstrumentChartView);

-(UIView*)view{
    InstrumentChart* chart = [[InstrumentChart alloc]init];
    return chart;
}

RCT_EXPORT_VIEW_PROPERTY(isShowCurValue, BOOL);
RCT_EXPORT_VIEW_PROPERTY(minValue, float);
RCT_EXPORT_VIEW_PROPERTY(maxValue, float);
RCT_EXPORT_VIEW_PROPERTY(splitCount, int);
RCT_EXPORT_VIEW_PROPERTY(startAngle, float);
RCT_EXPORT_VIEW_PROPERTY(endAngle, float);

RCT_CUSTOM_VIEW_PROPERTY(backgroundColor, NSArray, InstrumentChart){
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
        view.backgroundColor = color;
    } @catch (NSException *exception) {
        NSLog(@"imoble_for_reactnative got exception,info:%@",exception);
    }
}

RCT_CUSTOM_VIEW_PROPERTY(gradient, NSString, InstrumentChart){
    NSString* schemeId = json?[RCTConvert NSString:json]:nil;
    ColorScheme* scheme = [JSObjManager getObjWithKey:schemeId];
    view.gradient = scheme;
}
@end
