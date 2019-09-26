//
//  PoiSearchHelper.h
//  Supermap
//
//  Created by zhouyuming on 2019/3/7.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Feature3D.h"
#import "SuperMap/SceneControl.h"
#import "SuperMap/OnlinePOIInfo.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/Scene.h"
#import "SuperMap/NavigationOnline.h"
#import "SuperMap/GeoStyle3D.h"
#import "SuperMap/Point3D.h"
#import "SingletonObject_SuperMap.h"
#import "SuperMap/Layer3D.h"
#import "SuperMap/NavigationOnline.h"
#import "SuperMap/NavigationOnlineParamater.h"
//#import "OnlinePOIQueryParameter.h"
//#import "OnlinePOIQueryResult.h"

@protocol PoiSearchDelegate <NSObject>
@optional

-(void)locations:(NSArray *)locations;

@end

@interface PoiSearchHelper : NSObject
SUPERMAP_SIGLETON_DEF(PoiSearchHelper);
/**
 *初始化
 */
-(void)initSceneControl:(SceneControl*)control;

-(void)poiSearch:(NSString*) keyWords;

//-(void)toLocationPoint:(OnlinePOIInfo*)onlinePOIInfo;
-(void)toLocationPoint:(OnlinePOIInfo *) poiInfo;


-(Feature3D *)addMarkFile:(SceneControl*)control name:(NSString*)name point3D:(Point3D)point3D imagePath:(NSString*)imagePath currentFeature3D:(Feature3D*)currentFeature3D;

-(void)navigationLine:(OnlinePOIInfo*)poiInfoStart poiInfoEnd:(OnlinePOIInfo*)poiInfoEnd;

-(void)addTrackLayer:(SceneControl*)control imagePath:(NSString*)imagePath name:(NSString*)name x:(double)x y:(double)y;

-(void)clearPoint:(SceneControl*)control;

/**
 * 接口
 */
@property (nonatomic) id<PoiSearchDelegate> delegate;
@end
