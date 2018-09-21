//
//  JSGeoStyle.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSGeoStyle.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Color.h"
#import "JSObjManager.h"
@implementation JSGeoStyle
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoStyle* style = [[GeoStyle alloc]init];
  if(style){
    NSInteger key = (NSInteger)style;
    [JSObjManager addObj:style];
    resolve(@{@"geoStyleId":@(key).stringValue});
  }else{
    reject(@"geoStyle",@"create geoStyle failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setLineColor,setLineColorWithStyleId:(NSString*)styleId redColor:(int)red greenColor:(int)green blueColor:(int)blue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Color* color = [[Color alloc]initWithR:red G:green B:blue];
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
  if (style) {
    [style setLineColor:color];
    resolve(@"1");
  }else{
     reject(@"geoStyle",@"setLineColor failed!!!",nil);
  }
}
RCT_REMAP_METHOD(setPointColor,setPointColorId:(NSString*)styleId redColor:(int)red greenColor:(int)green blueColor:(int)blue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Color* color = [[Color alloc]initWithR:red G:green B:blue];
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        [style setLineColor:color];
       // [style setPointColor:color];
        resolve(@"1");
    }else{
        reject(@"geoStyle",@"setLineColor failed!!!",nil);
    }
}
RCT_REMAP_METHOD(setLineSymbolID,setLineSymbolIdWithStyleId:(NSString*)styleId symbolId:(int)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        [style setLineSymbolID:symbolId];
        resolve(@"1");
    }else{
        reject(@"geoStyle",@"setLineSymbolID failed!!!",nil);
    }
}


RCT_REMAP_METHOD(getPointColor,getPointColorId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoStyle* style = [JSObjManager getObjWithKey:styleId];
  if (style) {
      Color* color = [style getLineColor];
      resolve(@{@"r":@(color.red),
                @"g":@(color.green),
                @"b":@(color.blue),
                });
  }else{
    reject(@"geoStyle",@"setLineSymbolID failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setLineWidth,setLineWidthWithStyleId:(NSString*)styleId lineWidth:(double)lineWidth resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoStyle* style = [JSObjManager getObjWithKey:styleId];
  if (style) {
    [style setLineWidth:lineWidth];
    resolve(@"1");
  }else{
    reject(@"geoStyle",@"setLineWidth failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setMarkerSymbolID,setMarkerSymbolIdWithStyleId:(NSString*)styleId markerSymbolId:(int)markerSymbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GeoStyle* style = [JSObjManager getObjWithKey:styleId];
        [style setMarkerSymbolID:markerSymbolId];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException* exception) {
        reject(@"geoStyle",@"setMarkerSymbolID failed!!!",nil);
    }
}
////////////////
RCT_REMAP_METHOD(setMarkerSize,setMarkerSizeWithStyleId:(NSString*)styleId sizeId:(NSString*)sizeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoStyle* style = [JSObjManager getObjWithKey:styleId];
  Size2D* size = [JSObjManager getObjWithKey:sizeId];
  if (style) {
    [style setMarkerSize:size];
    resolve(@"1");
  }else{
    reject(@"geoStyle",@"setMarkerSize failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setFillForeColor,setFillForeColorWithStyleId:(NSString*)styleId redColor:(int)redColor greenColor:(int)greenColor blueColor:(int)blueColor resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoStyle* style = [JSObjManager getObjWithKey:styleId];
  Color* color = [[Color alloc]initWithR:redColor G:greenColor B:blueColor];
  if (style) {
    [style setFillForeColor:color];
    resolve(@"1");
  }else{
    reject(@"geoStyle",@"setFillForeColor failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setFillOpaqueRate,setFillOpaqueRateWithStyleId:(NSString*)styleId rate:(int)rate resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoStyle* style = [JSObjManager getObjWithKey:styleId];
  if (style) {
    [style setFillOpaqueRate:rate];
    resolve(@"1");
  }else{
    reject(@"geoStyle",@"setFillForeColor failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getLineColor,getLineColorId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        Color* color = [style getLineColor];
        resolve(@{@"r":@(color.red),
                  @"g":@(color.green),
                  @"b":@(color.blue),
                  @"a":@(color.alpha)
                  });
    }else{
        reject(@"geoStyle",@"jsGeoStyle getLineColor failed!!!",nil);
    }
}
RCT_REMAP_METHOD(getLineSymbolID,getLineSymbolIDId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        int color = [style getLineSymbolID];
        resolve(@(color));
    }else{
        reject(@"geoStyle",@"jsGeoStyle getLineSymbolID failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getLineWidth,getLineWidthId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        double color = [style getLineWidth];
        resolve(@(color));
    }else{
        reject(@"geoStyle",@"jsGeoStyle getLineWidth failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getMarkerSymbolID,getMarkerSymbolIDId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        int color = [style getMarkerSymbolID];
        resolve(@(color));
    }else{
        reject(@"geoStyle",@"jsGeoStyle getLineWidth failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getMarkerSize,getMarkerSizeId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        Size2D* color = [style getMarkerSize];
        resolve([JSObjManager addObj:color]);
    }else{
        reject(@"geoStyle",@"jsGeoStyle getMarkerSize failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getFillForeColor,getFillForeColorId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        Color* color = [style getFillForeColor];
        resolve(@{@"r":@(color.red),
                  @"g":@(color.green),
                  @"b":@(color.blue),
                  @"a":@(color.alpha)
                  });

    }else{
        reject(@"geoStyle",@"jsGeoStyle getFillForeColor failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getFillOpaqueRate,getFillOpaqueRateId:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoStyle* style = [JSObjManager getObjWithKey:styleId];
    if (style) {
        double color = [style getFillOpaqueRate];
        resolve(@(color));

    }else{
        reject(@"geoStyle",@"jsGeoStyle getMarkerSize failed!!!",nil);
    }
}

@end
