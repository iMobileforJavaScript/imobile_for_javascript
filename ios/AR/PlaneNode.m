//
//  PlaneNode.m
//  ARKitTest
//
//  Created by zhang_jian on 2018/4/23.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "PlaneNode.h"

@implementation PlaneNode
{
    SCNPlane *m_plane;
    ARPlaneAnchor *m_Anchor;
}

- (instancetype) initWithPlaneAnchor:(ARPlaneAnchor *)anchor
{
    self = [super init];
    if (self)
    {
        m_Anchor = anchor;
        
        SCNMaterial *meterial = [SCNMaterial material];
        NSString * strResPath = [[[NSBundle mainBundle]pathForResource:@"SuperMapAR" ofType:@"bundle"] stringByAppendingFormat:@"/tron_grid.png"];
        
        meterial.diffuse.contents = [UIImage imageWithContentsOfFile:strResPath];
        [meterial setLightingModelName:SCNLightingModelPhysicallyBased];
        
        m_plane = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
        m_plane.materials = @[meterial];
        
        SCNNode *bridgeNode = [SCNNode nodeWithGeometry:m_plane];
        [bridgeNode setPosition:SCNVector3Make(anchor.center.x, 0, anchor.center.z)];
        [bridgeNode setTransform:SCNMatrix4MakeRotation(-M_PI_2, 1.f, 0.f, 0.f)];
        
//        [self setTextureScale];
        [self addChildNode:bridgeNode];
    }
    return self;
}

- (void)updateNodeWithPlaneAnchor:(ARPlaneAnchor *)anchor
{
    [m_plane setWidth:anchor.extent.x];
    [m_plane setHeight:anchor.extent.z];
    
    [self setPosition:SCNVector3Make(anchor.center.x, 0, anchor.center.z)];
//    [self setTextureScale];
}

- (void)setTextureScale
{
    CGFloat widht = m_plane.width;
    CGFloat height = m_plane.height;
    
    SCNMaterial *meterial = m_plane.materials.firstObject;
    if (meterial)
    {
        [meterial.diffuse setContentsTransform:SCNMatrix4MakeScale(widht, height, 1)];
        
        [meterial.diffuse setWrapS:SCNWrapModeRepeat];
        [meterial.diffuse setWrapT:SCNWrapModeRepeat];
    }
}

@end
