//
//  SMediaCollector.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import "SuperMap/MDataCollector.h"
#import "SuperMap/MDataCollectorMediaFileListener.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/DatasetVector.h"
#import "SMap.h"

@interface SMediaCollector : NSObject<RCTBridgeModule, MDataCollectorMediaFileListener, DownLoadDelegate, UploadDelegate>
{
@public
    MDataCollector* mDataCollector;
}

@end
