//
//  PoiSearchHelper.m
//  Supermap
//
//  Created by zhouyuming on 2019/3/7.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "PoiSearchHelper.h"
#import "SuperMap/Feature3D.h"
#import "SuperMap/Feature3Ds.h"
#import "SuperMap/GeoPoint3D.h"
#import "SuperMap/Layer3Ds.h"
#import "SuperMap/GeoPlacemark.h"
#import "SuperMap/GeoLine.h"
#import "SuperMap/NavigationOnline.h"
#import "SuperMap/OnlinePathInfo.h"
#import "SuperMap/TrackingLayer3D.h"
#import "SuperMap/OnlinePOIQuery.h"



@interface PoiSearchHelper()<OnlinePOIQueryCallback,NavigationOnlineCallback>{
    SceneControl* m_sceneControl;
    Feature3D* m_feature3D;
    NSArray* m_poiInfos;
}
@end

@implementation PoiSearchHelper
SUPERMAP_SIGLETON_IMP(PoiSearchHelper);

-(void)initSceneControl:(SceneControl*)control{
    m_sceneControl=control;
}

-(void)poiSearch:(NSString*) keyWords{
    OnlinePOIQuery *poiQuery=[[OnlinePOIQuery alloc]init];
    OnlinePOIQueryParameter *poiQueryParameter=[[OnlinePOIQueryParameter alloc]init];
    poiQuery.delegate=self;
    [poiQueryParameter setKeywords:keyWords];
    [poiQuery setKey:@"tY5A7zRBvPY0fTHDmKkDjjlr"];
    [poiQuery queryPOIWithParam:poiQueryParameter];
//    [poiQuery setDelegate:self];

}

//-(void)toLocationPoint:(OnlinePOIInfo*)onlinePOIInfo{
-(void)toLocationPoint:(int) index{
    if(!m_poiInfos){
        return;
    }
    OnlinePOIInfo* onlinePOIInfo=[m_poiInfos objectAtIndex:index];
    Point2D *point2D=onlinePOIInfo.location;
    Point3D pnt3d;
    pnt3d.x=point2D.x;
    pnt3d.y=point2D.y;
    pnt3d.z=500;
    Point3D  pnt3d2;
    pnt3d2.x=point2D.x;
    pnt3d2.y=point2D.y;
    pnt3d2.z=100;
    NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:@"resources" ofType:@"bundle"];
    NSString *strImageStartPath = [strBundlePath stringByAppendingString:@"/icon_green.png"];
    Feature3D* param=[self addMarkFile:m_sceneControl name:onlinePOIInfo.name point3D:pnt3d2 imagePath:strImageStartPath currentFeature3D:m_feature3D];
    m_feature3D=param;
    [m_sceneControl.scene flyToPoint:pnt3d];
}

-(Feature3D *)addMarkFile:(SceneControl*)control name:(NSString*)name point3D:(Point3D)point3D imagePath:(NSString*)imagePath currentFeature3D:(Feature3D*)currentFeature3D{
    
    GeoStyle3D* pointStyle3D=[[GeoStyle3D alloc]init];
    GeoPoint3D* geoPoint = [[GeoPoint3D alloc]initWithPoint3D:point3D];
    [pointStyle3D setMarkerFile:imagePath];
    pointStyle3D.altitudeMode = Absolute3D;
    [geoPoint setStyle3D:pointStyle3D];
    GeoPlacemark* geoPlacemark=[[GeoPlacemark alloc]initWithName:name andGeomentry:geoPoint];
    [m_sceneControl.scene.trackingLayer3D clear];
    [m_sceneControl.scene.trackingLayer3D AddGeometry:geoPlacemark Tag:@"mark"];
    [m_sceneControl.scene refresh];
    return m_feature3D;
}

-(void)navigationLine:(OnlinePOIInfo*)poiInfoStart poiInfoEnd:(OnlinePOIInfo*)poiInfoEnd{
    NavigationOnline* navigationOnline=[[NavigationOnline alloc]init];
    NavigationOnlineParamater* navigationOnlineParamater=[[NavigationOnlineParamater alloc]init];
    navigationOnlineParamater.startPoint=poiInfoStart.location;
    navigationOnlineParamater.endPoint=poiInfoEnd.location;
    [navigationOnline setKey:@"tY5A7zRBvPY0fTHDmKkDjjlr"];
    navigationOnline.delegate=self;
    [navigationOnline routeAnalyst:navigationOnlineParamater];
}

-(void)addTrackLayer:(SceneControl*)control imagePath:(NSString*)imagePath name:(NSString*)name x:(double)x y:(double)y{
    
    Point3D  point3d;
    point3d.x=x;
    point3d.y=y;
    point3d.z=0;
    GeoPoint3D *geopnt = [[GeoPoint3D alloc]initWithPoint3D:point3d];
    GeoStyle3D *geostyle = [[GeoStyle3D alloc]init];
    [geostyle setMarkerFile:imagePath];
    [geostyle setAltitudeMode:Absolute3D];
    [geopnt setStyle3D:geostyle];
    GeoPlacemark *geoPlacemark = [[GeoPlacemark alloc]initWithName:@"" andGeomentry:geopnt];
    [m_sceneControl.scene.trackingLayer3D AddGeometry:geoPlacemark Tag:name];
}

-(void)clearPoint:(SceneControl*)control{
    [m_sceneControl.scene.trackingLayer3D clear];
}

-(void)caculateSuccess:(NavigationOnlineData*)data{
    [m_sceneControl.scene.trackingLayer3D clear];
    
    GeoLine* geoLine=data.route;
    Rectangle2D* rectangle2D=[geoLine getBounds];
    [m_sceneControl.scene.trackingLayer3D AddGeometry:geoLine Tag:@"navigation"];
    //[m_sceneControl.scene ensureVisible:rectangle2D];             //ios没有三维显示平面的方法
    [m_sceneControl.scene ensureVisibleWithBounds:rectangle2D];
    OnlinePathInfo* onlinePathInfoStart=data.pathInfos.firstObject;
    OnlinePathInfo* onlinePathInfoEnd=data.pathInfos.lastObject;
    NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:@"resources" ofType:@"bundle"];
    NSString *strImageStartPath = [strBundlePath stringByAppendingString:@"/icon_green.png"];
    NSString *strImageEndPath = [strBundlePath stringByAppendingString:@"/icon_red.png"];
    [self addTrackLayer:m_sceneControl imagePath:strImageStartPath
                   name:@"start" x:onlinePathInfoStart.crossLocation.x y:onlinePathInfoStart.crossLocation.y];
    [self addTrackLayer:m_sceneControl imagePath:strImageEndPath
                   name:@"start" x:onlinePathInfoEnd.crossLocation.x y:onlinePathInfoEnd.crossLocation.y];
}
-(void)caculateFailed:(NSString *)errorInfo{
    
}


-(void)querySuccess:(OnlinePOIQueryResult*)result{
    if(result){
        [self.delegate locations:result.poiInfos];
        m_poiInfos=result.poiInfos;
    }
}
-(void)queryFailed:(NSString*)errorInfo{
    [self.delegate locations:nil];
}

@end
