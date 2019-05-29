//
//  SMediaCollector.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/MDataCollector.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/FieldInfo.h"
#import "SuperMap/Point2D.h"
#import "SMap.h"
#import "InfoCallout.h"
#import "SMMedia.h"
#import "SMMediaCollector.h"
#import "SMLayer.h"
#import "FileUtils.h"

@interface SMediaCollector : RCTEventEmitter<RCTBridgeModule, MDataCollectorMediaFileListener>
{
@public
    MDataCollector* mDataCollector;
}

+ (MDataCollector *)initMediaCollector:(NSString*)datasourceName dataset:(NSString*)datasetName;
+ (void)addCallout:(SMMedia *)media layer:(Layer *)layer;
//- (void)callOutAction:(UITapGestureRecognizer *)tapGesture;
@end
