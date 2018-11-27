//
//  ClipUtil3D.m
//  Supermap
//
//  Created by wnmng on 2018/11/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ClipUtil3D.h"
#import "SuperMap/SceneControl.h"
#import "SuperMap/Scene.h"
#import "SuperMap/Layer3Ds.h"
#import "SuperMap/Layer3D.h"
#import "SuperMap/GeoBox.h"


@implementation ClipUtil3D

+(void)clipSceneCross:(SceneControl*)sceneControl position:(Point3D)position dimension:(Point2D*)dimension rotX:(double)rotX rotY:(double)rotY rotZ:(double)rotZ extrudeDistance:(double)extrudeDistance{
    return;
}

+(void)clipSceneBox:(SceneControl*)sceneControl box:(GeoBox*)box  part:(BoxClipPart)part{
    Layer3Ds *layer3Ds = [[sceneControl scene]layers];
    for (int i=0; i<layer3Ds.count;i++) {
        Layer3D *layer3d = [layer3Ds getLayerWithIndex:i];
        [layer3d clipByBox:box part:part];
    }
}

+(void)clipScenePlane:(SceneControl*)sceneControl firstPoint:(Point3D)firstPoint secondPoint:(Point3D)secondPoint thirdPoint:(Point3D)thirdPoint{
    Layer3Ds *layer3Ds = [[sceneControl scene]layers];
    for (int i=0; i<layer3Ds.count;i++) {
        Layer3D *layer3d = [layer3Ds getLayerWithIndex:i];
        [layer3d setCustomClipPlaneWithPoint:firstPoint point:secondPoint point:thirdPoint];
    }
}

@end
