//
//  SMMap.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/8/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Layers.h"
#import "SuperMap/LayerGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMMap : NSObject
+ (NSArray *)setLayersInvisibleByGroup:(LayerGroup *)layerGroup except:(NSString *)layerPath;
@end

NS_ASSUME_NONNULL_END
