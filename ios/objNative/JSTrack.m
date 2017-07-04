//  Created by 王子豪 on 2016/11/25.
//  Copyright © SuperMap. All rights reserved.

#import "JSObjManager.h"
#import "SuperMap/Track.h"
#import "SuperMap/Datasets.h"
#import "JSTrack.h"

@implementation JSTrack
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Track* track = [[Track alloc]init];
  if(track){
    NSInteger key = (NSInteger)track;
    [JSObjManager addObj:track];
    resolve(@{@"_trackId_":@(key).stringValue});
  }else{
    reject(@"JSTrack",@"Native: create Obj exception.",nil);
  }
}

RCT_REMAP_METHOD(createDataset,createDatasetById:(NSString*)trackId dataSourceId:(NSString*)dsId name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasource* dataSource = [JSObjManager getObjWithKey:dsId];
  DatasetVector* dsVector = [Track creatDataset:dataSource DatasetName:name];
  if(dsVector){
    NSInteger key = (NSInteger)dsVector;
    [JSObjManager addObj:dsVector];
    resolve(@{@"datasetId":@(key).stringValue});
  }else{
    reject(@"JSTrack",@"Native: create Dataset exception.",nil);
  }
}

RCT_REMAP_METHOD(getDataset,getDatasetById:(NSString*)trackId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        DatasetVector* dsVector = track.dataset;
        NSInteger key = (NSInteger)dsVector;
        [JSObjManager addObj:dsVector];
        resolve(@{@"datasetId":@(key).stringValue});
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: get Dataset exception.",nil);
    }
}

RCT_REMAP_METHOD(getDistanceInterval,getDistanceIntervalById:(NSString*)trackId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        double distanceInterval = track.distanceInterval;
        NSNumber* nsDistanceInterval = [NSNumber numberWithDouble:distanceInterval];
        resolve(@{@"distanceInterval":nsDistanceInterval});
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: get DistanceInterval exception.",nil);
    }
}

RCT_REMAP_METHOD(getMatchDatasets,getMatchDatasetsById:(NSString*)trackId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        NSArray* matchDatasets = track.matchDatasets;
        
        NSMutableArray* idArr = [[NSMutableArray alloc]initWithCapacity:10];
        for (int i =0; i<matchDatasets.count; i++) {
            Dataset* datasetObj = matchDatasets[i];
            NSInteger key = (NSInteger)datasetObj;
            [JSObjManager addObj:datasetObj];
            [idArr addObject:@(key).stringValue];
        }
        
        if (idArr.count>0) {
            resolve(@{@"idArr":idArr});
        }else{
            NSNumber* falseNum = [NSNumber numberWithBool:false];
            resolve(@{@"idArr":falseNum});
        }
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: get MatchDatasets exception.",nil);
    }
}

RCT_REMAP_METHOD(getTimeInterval,getTimeIntervalById:(NSString*)trackId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        int timeInterval = track.timeInterval;
        NSNumber* nsTimeInterval = [NSNumber numberWithInt:timeInterval];
        resolve(@{@"timeInterval":nsTimeInterval});
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: get TimeInterval exception.",nil);
    }
}

RCT_REMAP_METHOD(setDataset,setDatasetById:(NSString*)trackId datasetId:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        Dataset* dataset = [JSObjManager getObjWithKey:datasetId];
        track.dataset = (DatasetVector*)dataset;
        NSNumber* nsTure = [NSNumber numberWithBool:true];
        resolve(nsTure);
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: set Dataset exception.",nil);
    }
}

RCT_REMAP_METHOD(setDistanceInterval,setDistanceIntervalById:(NSString*)trackId distanceInterval:(double)distanceInterval resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        track.distanceInterval = distanceInterval;
        NSNumber* nsTure = [NSNumber numberWithBool:true];
        resolve(nsTure);
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: set DistanceInterval exception.",nil);
    }
}

RCT_REMAP_METHOD(setMatchDatasets,setMatchDatasetsById:(NSString*)trackId datasetArr:(NSArray*)datasetArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: set MatchDatasets exception.",nil);
    }
}

RCT_REMAP_METHOD(setTimeInterval,setTimeIntervalById:(NSString*)trackId timeInterval:(int)timeInterval resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        track.timeInterval = timeInterval;
        
        NSNumber* nsTrue = [NSNumber numberWithBool:true];
        resolve(nsTrue);
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: set TimeInterval exception.",nil);
    }
}

RCT_REMAP_METHOD(startTrack,startTrackById:(NSString*)trackId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        BOOL start = [track startTrack];
        
        NSNumber* nsStart = [NSNumber numberWithBool:start];
        resolve(nsStart);
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: start Track exception.",nil);
    }
}

RCT_REMAP_METHOD(stopTrack,stopTrackById:(NSString*)trackId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Track* track = [JSObjManager getObjWithKey:trackId];
        [track stopTrack];
        
        NSNumber* nsTrue = [NSNumber numberWithBool:true];
        resolve(nsTrue);
    } @catch (NSException *exception) {
        reject(@"JSTrack",@"Native: stop Track exception.",nil);
    }
}
@end
