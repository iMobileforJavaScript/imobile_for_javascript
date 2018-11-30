//
//  TouchUtil3D.h
//  Supermap
//
//  Created by imobile-xzy on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/SceneControl.h"
#import "SuperMap/Layer3Ds.h"
#import "SuperMap/Layer3D.h"
#import "SuperMap/Scene.h"
#import "SuperMap/Selection3D.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/FieldInfo.h"

@class SceneControl;
@interface TouchUtil3D : NSObject
+(void)getAttribute:(SceneControl*)sceneControl attribute:(NSDictionary**)osgbAttribute;

@end
