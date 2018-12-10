//
//  SMDatasource.h
//  Supermap
//
//  Created by Shanglong Yang on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Workspace.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/DatasourceConnectionInfo.h"

@interface SMDatasource : NSObject
+ (DatasourceConnectionInfo *)convertDicToInfo:(NSDictionary *)dicInfo;
@end
