//
//  Utils3D.h
//  Supermap
//
//  Created by imobile-xzy on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/SceneControl.h"
#import "SuperMap/Feature3Ds.h"
#import "SuperMap/Feature3D.h"
#import "SuperMap/Layer3D.h"
#import "SuperMap/Layer3DOSGBFile.h"
#import "SuperMap/Selection3D.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/FieldInfo.h"
#import "SuperMap/Scene.h"

@class Layer3D,Selection3D,Layer3D,FieldInfos,Workspace,Scene,SceneControl;
@interface Utils3D : NSObject

+(void)KMLData:(Layer3D*)layer ID:(int)id info:(NSMutableDictionary*)attributeMap;
+(void)vect:(Selection3D*)selection layer:(Layer3D*)layer fieldInfos:(FieldInfos*)fieldInfos attribute:(NSMutableDictionary*)attributeMap;
+(void)urlNUll:(Scene*)tempScene ID:(int)_nID  wk:(Workspace*)mWorkspace  attribute:(NSMutableDictionary*)attributeMap;
+(void)urlNoNULL:(SceneControl*)mSceneControl url:(NSString*)sceneUrl ID:(int)id attribute:(NSMutableDictionary*)attributeMap;
@end
