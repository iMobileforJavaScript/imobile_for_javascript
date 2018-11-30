//
//  AnalysisHelper3D.m
//  HypsometricSetting
//
//  Created by wnmng on 2018/11/21.
//  Copyright © 2018年 SuperMap. All rights reserved.
//

#import "AnalysisHelper3D.h"
#import "SuperMap/Sightline.h"
#import "SuperMap/Scene.h"
#import "SuperMap/TrackingLayer3D.h"
#import "SuperMap/Tracking3DEvent.h"
#import "SuperMap/GeoPoint3D.h"
#import "SuperMap/GeoStyle3D.h"

@interface AnalysisHelper3D(){
    SceneControl*m_sceneControl;
    Sightline *m_sightLine;
}
@end


@implementation AnalysisHelper3D
    SUPERMAP_SIGLETON_IMP(AnalysisHelper3D);

-(void)initializeWithSceneControl:(SceneControl *)control{
    m_sceneControl = control;
    //m_sceneControl.tracking3DDelegate = self;
}

-(void)tracking3DEvent:(Tracking3DEvent *)event{
    switch ([m_sceneControl action3D]) {
        case CREATEPOINT3D:
        {
            
        }
            break;
            
        case MEASUREDISTANCE3D:
        {
            [self measureDistance:event];
        }
            break;
            
        case MEASUREAREA3D:
        {
            [self measureSureArea:event];
        }
            break;
            
        default:
            break;
    }
}

// 开启距离测量分析
-(void)startMeasureAnalysis {
    if(m_sceneControl){
        [m_sceneControl setAction3D:MEASUREDISTANCE3D];
    }
}

// 开启测量面积分析
-(void)startSureArea{
    if(m_sceneControl){
        [m_sceneControl setAction3D:MEASUREAREA3D];
    }
}

//开始通视分析
-(void) startPerspectiveAnalysis{
    if(m_sceneControl==nil){
        return;
    }
    if(m_sightLine == nil){
        m_sightLine = [[Sightline alloc]initWith:m_sceneControl.scene];
    }
    [m_sceneControl setAction3D:CREATEPOINT3D];
}

// 结束通视分析
-(void)endPerspectiveAnalysis {
    if(m_sceneControl==nil){
        return;
    }
    [m_sceneControl.scene.trackingLayer3D clear];
    [m_sightLine clearResult];
    m_sightLine = nil;
    [m_sceneControl setAction3D:PANSELECT3D];
}

// 关闭所有情况下的分析
-(void)closeAnalysis {
    if(m_sceneControl) {
        [m_sceneControl setAction3D:PANSELECT3D];
    }
}
//
// 测量距离
-(void) measureDistance:(Tracking3DEvent*)event {
    // 加点
    // 更新总距离长度
    double totalLength = [event totalLength];
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(distanceResult:)]) {
        [self.delegate distanceResult:totalLength];
    }
}

// 测量面积
-(void) measureSureArea:(Tracking3DEvent*) event {
    // 加点
    // 更新测量面积
    double totalArea = [event totalArea];
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(areaResult:)]) {
        [self.delegate areaResult:totalArea];
    }
}

//通视
-(void) perspective:(Tracking3DEvent *)event{
    if (m_sightLine != nil) {
        
        Point3D p3D ;
        p3D.x = event.position.x;
        p3D.y = event.position.y;
        p3D.z = event.position.z;
       
        if (m_sightLine.viewerPosition.x == 0) {
            [m_sightLine setViewerPosition:p3D];
            [m_sightLine build];
            // 加点
            Point3D point3d = {event.position.x,event.position.y,event.position.z};
            GeoPoint3D * geoPoint3D = [[GeoPoint3D alloc] initWithPoint3D:point3d];
            GeoStyle3D * geoStyle3D = [[GeoStyle3D alloc]init];
            [geoPoint3D setStyle3D:geoStyle3D];
            [m_sceneControl.scene.trackingLayer3D AddGeometry:geoPoint3D Tag:@"point"];
        }else{
            [m_sightLine addTargetPoint:p3D];
            // 加点
            Point3D point3d = {event.position.x,event.position.y,event.position.z};
            GeoPoint3D * geoPoint3D = [[GeoPoint3D alloc] initWithPoint3D:point3d];
            GeoStyle3D * geoStyle3D = [[GeoStyle3D alloc]init];
            [geoPoint3D setStyle3D:geoStyle3D];
            [m_sceneControl.scene.trackingLayer3D AddGeometry:geoPoint3D Tag:@"point"];
        }
        
        double x = m_sightLine.viewerPosition.x;
        double y = m_sightLine.viewerPosition.y;
        double z = m_sightLine.viewerPosition.z;
        int count = [m_sightLine pointCount];
        
        NSString *LocationX = [NSString stringWithFormat:@"%.2f",x];
        NSString *LocationY = [NSString stringWithFormat:@"%.2f",y];
        NSString *LocationZ = [NSString stringWithFormat:@"%.2f",z];
        
        if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(perspectiveResultX:Y:Z:count:)]) {
            [self.delegate perspectiveResultX:LocationX Y:LocationY Z:LocationZ count:count];
        }
        
    }
}



@end
