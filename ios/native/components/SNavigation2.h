//
//  SNavigation2.h
//  Supermap
//
//  Created by Asort on 2019/12/6.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Navigation2.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Map.h"
#import "SuperMap/TrackingLayer.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/GeoLine.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/Color.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/CoordSysTransParameter.h"
@interface SNavigation2 : NSObject

@property (strong, nonatomic) MapControl* m_mapControl;
@property (strong, nonatomic) Navigation2* m_navigation;
@property (strong, nonatomic) Point2D* m_startPoint;
@property (strong, nonatomic) Point2D* m_endPoint;
@property (strong, nonatomic) Point2D* m_nearStartPoint;
@property (strong, nonatomic) Point2D* m_nearEndPoint;
@property (strong, nonatomic) DatasetVector* m_lineDataset;
@property (strong, nonatomic) Dataset* m_pointDataset;
@property (strong, nonatomic) NSString* m_modelPath;
@property (strong, nonatomic) GeoStyle* m_routeStyle;
@property (strong, nonatomic) PrjCoordSys* m_prjCoordSys;

- (id) initWithMapControl:(MapControl *)mapControl;
- (void) setNetworkDataset:(DatasetVector *)dataset;
- (void) setStartPoint:(double)x sPointY:(double)y;
- (void) setDestinationPoint:(double)x dPointY:(double)y;
- (BOOL) loadModel:(NSString *)filePath;
- (void) setRouteStyle:(GeoStyle *)style;
//重新分析
- (BOOL) reAnalyst;

//添加引导线（起点和起点邻近点、终点和终点临界点的 之间的虚线）
-(void) addGuideLineOnTrackinglayerWithMapPrj:(PrjCoordSys *)mapPrj;

@end

