//
//  SCNVector3Tool.m
//  ARRanging
//
//  Created by zhang_jian on 2018/4/19.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import "SCNVector3Tool.h"

@implementation SCNVector3Tool

+ (SCNVector3)positionTranform:(matrix_float4x4)tranform
{
    simd_float4 columns = tranform.columns[3];
    SCNVector3 planeHitTestPosition = SCNVector3Make(columns.x, columns.y, columns.z);
    return planeHitTestPosition;
}

+ (SCNVector3)positionExtent:(vector_float3)extent
{
    SCNVector3 planeHitTestPosition = SCNVector3Make(extent.x, extent.y, extent.z);
    return planeHitTestPosition;
}

+ (CGFloat)distanceWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector
{
    CGFloat distance = 0.f;
    CGFloat distanceX = vector.x - startVector.x;
    CGFloat distanceY = vector.y - startVector.y;
    CGFloat distanceZ = vector.z - startVector.z;
    distance = sqrt(pow(distanceX, 2) + pow(distanceY, 2) + pow(distanceZ, 2));
    return distance;
}

+ (SCNNode *)drawLineWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector
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

+ (BOOL)isEqualBothSCNVector3WithLeft:(SCNVector3)leftVector Right:(SCNVector3)rightVector
{
    if (leftVector.x == rightVector.x &&
        leftVector.y == rightVector.y &&
        leftVector.z == rightVector.z)
    {
        return YES;
    }
    return NO;
}

+ (SCNVector3)computTextPostionWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector
{
    return SCNVector3Make((startVector.x+vector.x)/2.f, (startVector.y+vector.y)/2.f, (startVector.z+vector.z)/2);
}

@end
