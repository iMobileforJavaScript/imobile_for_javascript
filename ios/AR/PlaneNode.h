//
//  PlaneNode.h
//  ARKitTest
//
//  Created by zhang_jian on 2018/4/23.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
//#import "ARSCNViewExtension.h"

@interface PlaneNode : SCNNode

- (instancetype) initWithPlaneAnchor:(ARPlaneAnchor *)anchor;

- (void)updateNodeWithPlaneAnchor:(ARPlaneAnchor *)anchor;

@end
