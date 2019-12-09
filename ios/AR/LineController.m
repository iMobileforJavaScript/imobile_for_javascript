//
//  LineController.m
//  ARRanging
//
//  Created by zhang_jian on 2018/4/19.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "LineController.h"

@implementation LineController
{
    SCNNode *m_StartNode;
    SCNNode *m_EndNode;
//    SCNNode *m_TextNode;
//    SCNText *m_TextG;
    SCNNode *m_LineNode;
    ARSCNView *m_SceneView;
    SCNVector3 m_VectorStart;
    Enum_LengthUnit m_Unit;
}

- (instancetype)initWithSceneView:(ARSCNView *)sceneView StartVector:(SCNVector3)startVector LengthUnit:(Enum_LengthUnit)unit
{
    self = [super init];
    if (self)
    {
        m_SceneView = sceneView;
        m_VectorStart = startVector;
        m_Unit = unit;
        SCNSphere *dot = [SCNSphere sphereWithRadius:.5];
        dot.firstMaterial.diffuse.contents = [UIColor redColor];
        dot.firstMaterial.lightingModelName = SCNLightingModelConstant; //光照,表面看起来都是一样的光亮,不会产生阴影
        [dot.firstMaterial setDoubleSided:YES];//两面都很亮
        
        m_StartNode = [SCNNode nodeWithGeometry:dot];
        m_StartNode.scale = SCNVector3Make(1.f/500.f, 1.f/500.f, 1.f/500.f);//看看效果这里有坑,设置位置一定要注意
        m_StartNode.position = startVector;
        [sceneView.scene.rootNode addChildNode:m_StartNode];
        
        m_EndNode = [SCNNode nodeWithGeometry:dot];//这里只需要先创建出来,稍后添加
        m_EndNode.scale = SCNVector3Make(1.f/500.f, 1.f/500.f, 1.f/500.f);//这里也有坑
        
//        m_TextG = [SCNText textWithString:@"" extrusionDepth:.1f];
//        [m_TextG setFont:[UIFont systemFontOfSize:18]];
//        m_TextG.firstMaterial.diffuse.contents = [UIColor redColor];
//        m_TextG.firstMaterial.lightingModelName = SCNLightingModelConstant;
//        [m_TextG.firstMaterial setDoubleSided:YES];
//        [m_TextG setAlignmentMode:kCAAlignmentCenter];
//        [m_TextG setTruncationMode:kCATruncationMiddle];
//        SCNNode *textWrapper = [SCNNode nodeWithGeometry:m_TextG];
//        textWrapper.eulerAngles = SCNVector3Make(0, M_PI, 0);// 数字对着自己
//        textWrapper.scale = SCNVector3Make(1.f/500.0f,1.f/500.0f,1.f/500.0f); // 坑来了
//
//        m_TextNode = [SCNNode node];
//        [m_TextNode addChildNode:textWrapper];
//        SCNLookAtConstraint *constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:sceneView.pointOfView];
//        [constraint setGimbalLockEnabled:YES];
//        m_TextNode.constraints = @[constraint];
//        [sceneView.scene.rootNode addChildNode:m_TextNode];
    }
    return self;
}

- (double)updateLineContentWithVector:(SCNVector3)vector
{
    if (m_LineNode)
    {
        [m_LineNode removeFromParentNode];
    }
    
    m_LineNode = [self drawLineWithVector:vector StartVector:m_VectorStart];
    [m_SceneView.scene.rootNode addChildNode:m_LineNode];
    
//    [m_TextG setString:[self getDistanceWithVector:vector]];
//    [m_TextNode setPosition:[SCNVector3Tool computTextPostionWithVector:vector StartVector:m_VectorStart]];
    
    [m_EndNode setPosition:vector];
    if (m_EndNode.parentNode == nil)
    {
        [m_SceneView.scene.rootNode addChildNode:m_EndNode];
    }
    return [self getDistanceWithVector:vector];
}

//- (NSString *)getDistanceWithVector:(SCNVector3)vector
//{
//    return [NSString stringWithFormat:@"%.2f %@",
//            [SCNVector3Tool distanceWithVector:vector StartVector:m_VectorStart]*[self getLengthFactor],
//            [self getLengthName]];
//}
- (double)getDistanceWithVector:(SCNVector3)vector
{
   return  [SCNVector3Tool distanceWithVector:vector StartVector:m_VectorStart]*[self getLengthFactor];
}

- (void)removeLine
{
//    SCNNode *startNode = m_StartNode;
//    SCNNode *endNode = m_EndNode;
//    //SCNNode *textNode = m_TextNode;
//    SCNNode *lineNode = m_LineNode;
//    [m_SceneView.scene.rootNode addChildNode:startNode];
//    [m_SceneView.scene.rootNode addChildNode:endNode];
//    //[m_SceneView.scene.rootNode addChildNode:textNode];
//    [m_SceneView.scene.rootNode addChildNode:lineNode];
    [m_StartNode removeFromParentNode];
    [m_EndNode removeFromParentNode];
   // [m_TextNode removeFromParentNode];
    [m_LineNode removeFromParentNode];
}

- (CGFloat)getLengthFactor
{
    switch (m_Unit) {
        case Enum_LengthUnit_meter:
            return 1.f;
        case Enum_LengthUnit_cenitMeter:
            return 100.f;
        default:
            return 0.001f;
    }
}

- (NSString *)getLengthName
{
    switch (m_Unit) {
        case Enum_LengthUnit_meter:
            return @"m";
        case Enum_LengthUnit_cenitMeter:
            return @"cm";
        default:
            return @"km";
    }
}



- (SCNNode *)drawLineWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector
{
    SCNVector3 vectorse[] = {startVector, vector};
    int indices[] = {0, 1};
    NSData *data = [NSData dataWithBytes:indices length:sizeof(indices)];
    
    SCNGeometrySource *vertexSource = [SCNGeometrySource geometrySourceWithVertices:vectorse count:2];
    
    SCNGeometryElement *verteElement = [SCNGeometryElement geometryElementWithData:data
                                                                     primitiveType:SCNGeometryPrimitiveTypeLine
                                                                    primitiveCount:1
                                                                     bytesPerIndex:sizeof(int)];
    
    SCNGeometry *geomtry = [SCNGeometry geometryWithSources:@[vertexSource] elements:@[verteElement]];
    SCNMaterial* MaterialYellow = [SCNMaterial new];
    [MaterialYellow setDoubleSided:true];
    MaterialYellow.lightingModelName = SCNLightingModelConstant;        //坑一个，这里必须加, 不然没有光源显示不出来颜色。
    MaterialYellow.diffuse.contents = [UIColor redColor];
    geomtry.firstMaterial = MaterialYellow;
    SCNNode *node = [SCNNode nodeWithGeometry:geomtry];
    return node;
}

@end
