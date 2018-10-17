//
//  JSChartView.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/3.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSChartView.h"
#import "SuperMap/ChartView.h"
#import "SuperMap/ChartLegend.h"
#import "SuperMap/ChartPoint.h"
#import "JSObjManager.h"

#import "SuperMap/GridHotChart.h"
@implementation JSChartView
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(setTitle, setTitleById:(NSString*)chartviewId title:(NSString*)title resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        chartview.title = title;
        resolve(@"title setted");
    }else{
        reject(@"chartview",@"set title failed",nil);
    }
}

RCT_REMAP_METHOD(getTitle, getTitleById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        NSString* title = chartview.title;
        resolve(@{@"title":title});
    }else{
        reject(@"chartview",@"get title failed",nil);
    }
}

RCT_REMAP_METHOD(getLegend, getLegendById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        ChartLegend* legend = chartview.legend;
        [JSObjManager addObj:legend];
        NSInteger legendKey = (NSInteger)legend;
        resolve(@{@"chartLegendId":@(legendKey).stringValue});
    }else{
        reject(@"chartview",@"get title failed",nil);
    }
}

RCT_REMAP_METHOD(addChartDataWithTime, addChartDataById:(NSString*)chartviewId datas:(NSArray*)datas timeTag:(NSString*)timeTag resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        [chartview addChartDataset:datas timeTag:timeTag];
        resolve(@"data added");
    }else{
        reject(@"chartview",@"add ChartData With Time failed",nil);
    }
}

RCT_REMAP_METHOD(addChartData, addChartDataById:(NSString*)chartviewId datas:(NSArray*)datas resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GridHotChart* chartview = [JSObjManager getObjWithKey:chartviewId];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:10];
    if (chartview) {
        for(int i =0;i<=datas.count-1;i++){
            ChartPoint* point = [JSObjManager getObjWithKey:[datas[i] objectForKey:@"chartPointId"]];
            [arr addObject:point];
        }
        [chartview addChartDatas:arr];
        resolve(@"data added");
    }else{
        reject(@"chartview",@"add ChartData failed",nil);
    }
}

RCT_REMAP_METHOD(removeChartDataWithTimeTag, removeChartDataById:(NSString*)chartviewId timeTag:(NSString*)timeTag resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        [chartview removeChartDataWith:timeTag];
        resolve(@"data removed");
    }else{
        reject(@"chartview",@"remove ChartData With TimeTag failed",nil);
    }
}

RCT_REMAP_METHOD(removeAllData, removeChartDataById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        [chartview removeAllData];
        resolve(@"data removed");
    }else{
        reject(@"chartview",@"remove All Data failed",nil);
    }
}

RCT_REMAP_METHOD(dispose, disposeById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        [chartview dispose];
        [JSObjManager removeObj:chartviewId];
        resolve(@"disposed");
    }else{
        reject(@"chartview",@"dispose failed",nil);
    }
}

RCT_REMAP_METHOD(update, updateById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartView* chartview = [JSObjManager getObjWithKey:chartviewId];
    if (chartview) {
        [chartview update];
        resolve(@"updated");
    }else{
        reject(@"chartview",@"update failed",nil);
    }
}
@end
