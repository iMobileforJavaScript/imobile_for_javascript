//
//  TouchUtil3D.m
//  Supermap
//
//  Created by imobile-xzy on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "TouchUtil3D.h"
#import "Utils3D.h"
#import "SuperMap/Feature3Ds.h"
#import "SuperMap/Geometry3D.h"

@implementation TouchUtil3D
+(void)getAttribute:(SceneControl*)sceneControl attribute:(NSDictionary**)osgbAttribute{
    NSMutableDictionary* attributeMap = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    Layer3Ds* layer3ds = sceneControl.scene.layers;
    
    for(int i=0;i<layer3ds.count;i++){
        Layer3D* layer = [layer3ds getLayerWithIndex:i];
        // 遍历count之后，得到三维图层对象
        // 返回三维图层的选择集。
        if (layer == nil) {
            continue;
        }
        Selection3D* selection = layer.selection3D;
        if (selection == nil) {
            continue;
        }
        if (layer.name == nil) {
            continue;
        }
        // 获取选择集中对象的总数
        if ([selection count] > 0) {
            // 返回选择集中指定几何对象的系统 ID
            int _nID = [selection getIDWithIndex:0];
            Scene* tempScene = sceneControl.scene;
            NSString* sceneUrl = tempScene.url;
            // 本地数据获取
            
            // 不管KML是在线和本地都是一样的方式。
            // 不管矢量数据是在线和本地都是一样
            // 只有倾斜数据的时候，本地从UDB中取，在线用json.
            [attributeMap removeAllObjects];
            if (layer.type == KML) {
                [Utils3D KMLData:layer ID:_nID info:attributeMap];// (layer, _nID, attributeMap);
                *osgbAttribute = [[NSMutableDictionary alloc]initWithDictionary:attributeMap];;
                return;
            }
            FieldInfos* fieldInfos = layer.fieldInfos;
            int FieldInfosCount = fieldInfos.count;
            if (FieldInfosCount > 0) {
                [Utils3D vect:selection layer:layer fieldInfos:fieldInfos attribute:attributeMap];
            } else {
                // 在线和本地是不一样 本地是UDB 在线是Json
                if (sceneUrl == nil || [sceneUrl isEqualToString:@""]) {
                    Workspace* mWorkspace = [[Workspace alloc]init];
                    [Utils3D urlNUll:tempScene ID:_nID wk:mWorkspace attribute:attributeMap];
                }
                [Utils3D urlNoNULL:sceneControl url:sceneUrl ID:_nID attribute:attributeMap];
               // Utils.urlNoNULL(mSceneControl, sceneUrl, _nID, attributeMap);
                
            }
            *osgbAttribute = [[NSMutableDictionary alloc]initWithDictionary:attributeMap];
            return;
        }
    }
}

/**
 * 获取被选中的兴趣点Feature3D
 *
 * @param mSceneControl
 * @param event
 * @return
 */
+(Feature3D*)getSelectFeature3D:(SceneControl*)sceneControl
{
    Layer3Ds* layer3ds = sceneControl.scene.layers;
    
    for(int i=0;i<layer3ds.count;i++){
        Layer3D* layer = [layer3ds getLayerWithIndex:i];
        // 遍历count之后，得到三维图层对象
        // 返回三维图层的选择集。
        if (layer == nil) {
            continue;
        }
        Selection3D* selection = layer.selection3D;
        if (selection == nil) {
            continue;
        }
        // 获取选择集中对象的总数
        if ([selection count] <= 0) {
            continue;
        }
        int _nID = [selection getIDWithIndex:0];
        if (layer.type == KML) {
            return nil;
        }
        Feature3Ds *fer = [layer feature3Ds];
        if (fer == nil || [fer count]<=0) {
            return nil;
        }
        Feature3D *result = [fer feature3DWithID:_nID option:Feature3DSearchOptionAllFeatures];
        if (result != nil && result.geometry3D.getType == GT_GEOPLACEMARK) {
            return result;
        }else{
            return nil;
        }
    }
    return nil;
}

@end
