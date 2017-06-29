//  Created by 王子豪 on 2016/11/25.
//  Copyright © SuperMap. All rights reserved.

#import "JSObjManager.h"
#import "SuperMap/TrackingLayer.h"
#import "JSTrackingLayer.h"

@implementation JSTrackingLayer
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(add, addGeometryById:(NSString*)Id geoId:(NSString*)geoId tag:(NSString*)tag resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        TrackingLayer* layer = [JSObjManager getObjWithKey:Id];
        Geometry* geo = [JSObjManager getObjWithKey:geoId];
        int result = [layer addGeometry:geo WithTag:tag];
        
        NSNumber* nsResult = [NSNumber numberWithInt:result];
        resolve(nsResult);
    } @catch (NSException *exception) {
        reject(@"JSTrackingLayer",@"add failed",nil);
    }
}

RCT_REMAP_METHOD(clear, clearObjById:(NSString*)Id resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    @try {
        TrackingLayer* layer = [JSObjManager getObjWithKey:Id];
        [layer clear];
        
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"JSTrackingLayer",@"add failed",nil);
    }
}

@end
