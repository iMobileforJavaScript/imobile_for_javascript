//
//  SNavigation2.m
//  Supermap
//
//  Created by Asort on 2019/12/6.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SNavigation2.h"

@implementation SNavigation2

@synthesize m_mapControl;
@synthesize m_navigation;
@synthesize m_lineDataset;
@synthesize m_pointDataset;
@synthesize m_startPoint;
@synthesize m_endPoint;
@synthesize m_nearEndPoint;
@synthesize m_nearStartPoint;
@synthesize m_modelPath;
@synthesize m_routeStyle;
@synthesize m_prjCoordSys;

-(id) initWithMapControl:(MapControl *)mapControl{
    if([super init]){
        m_mapControl = mapControl;
        m_navigation = [mapControl getNavigation2];
    }
    return self;
}
- (void) setRouteStyle:(GeoStyle *)style{
    m_routeStyle = style;
    [m_navigation setRouteStyle:style];
}
-(void) setNetworkDataset:(DatasetVector *)dataset{
    m_lineDataset = dataset;
    m_pointDataset = dataset.childDataset;
    [m_navigation setNetworkDataset:dataset];
}

-(void) setStartPoint:(double)x sPointY:(double)y{
    m_startPoint = [[Point2D alloc] initWithX:x Y:y];
    [m_navigation setStartPoint:x sPointY:y];
}

-(void) setDestinationPoint:(double)x dPointY:(double)y{
    m_endPoint = [[Point2D alloc] initWithX:x Y:y];
    [m_navigation setDestinationPoint:x dPointY:y];
}

- (BOOL) loadModel:(NSString *)filePath{
    m_modelPath = filePath;
    BOOL isLoaded = [m_navigation loadModel:filePath];
    return isLoaded;
}
- (BOOL) reAnalyst{
    @try{
    GeoPoint *sPoint = [[GeoPoint alloc] initWithPoint2D:m_startPoint];
    DatasetVector *datasetVector = (DatasetVector *)m_pointDataset;
    Recordset *rd = [datasetVector queryWithGeometry:sPoint BufferDistance:0.001 Type:STATIC];
    if([rd recordCount] == 0){
        rd = [datasetVector queryWithGeometry:sPoint BufferDistance:0.005 Type:STATIC];
    }
    Geometry *geo  = [[Geometry alloc] init];
    double dLen = 1000000.0;
    while (![rd isEOF]) {
        geo = rd.geometry;
        Point2D *tmpPoint = [geo getInnerPoint];
        double len = sqrt( (m_startPoint.x - tmpPoint.x)*(m_startPoint.x - tmpPoint.x) + (m_startPoint.y - tmpPoint.y)*(m_startPoint.y - tmpPoint.y) );
        if(dLen > len){
            Recordset *lineRd = [m_lineDataset queryWithGeometry:geo BufferDistance:0 Type:STATIC];
            if([lineRd recordCount] != 0){
                dLen = len;
                m_nearStartPoint = tmpPoint;
            }
            [lineRd close];
            [lineRd dispose];
        }
        [rd moveNext];
    }
    [rd close];
    [rd dispose];
    
    GeoPoint *ePoint = [[GeoPoint alloc] initWithPoint2D:m_endPoint];
    Recordset *rd2 = [datasetVector queryWithGeometry:ePoint BufferDistance:0.001 Type:STATIC];
    if([rd2 recordCount] == 0){
        rd2 = [datasetVector queryWithGeometry:ePoint BufferDistance:0.005 Type:STATIC];
    }
    double dLen2 = 1000000.0;
    while (![rd2 isEOF]) {
        geo = rd2.geometry;
        Point2D *tmpPoint = [geo getInnerPoint];
        double len = sqrt( (m_endPoint.x - tmpPoint.x)*(m_endPoint.x - tmpPoint.x) + (m_endPoint.y - tmpPoint.y)*(m_endPoint.y - tmpPoint.y) );
        if(dLen2 > len){
            Recordset *lineRd = [m_lineDataset queryWithGeometry:geo BufferDistance:0 Type:STATIC];
            if([lineRd recordCount] != 0){
                dLen2 = len;
                m_nearEndPoint = tmpPoint;
            }
            [lineRd close];
            [lineRd dispose];
        }
        [rd2 moveNext];
    }
    [rd2 close];
    [rd2 dispose];
    [geo dispose];
    
    BOOL isFind = NO;
    if(m_nearStartPoint != nil && m_nearEndPoint != nil){
        [m_navigation setStartPoint:m_nearStartPoint.x sPointY:m_nearStartPoint.y];
        [m_navigation setDestinationPoint:m_nearEndPoint.x dPointY:m_nearEndPoint.y];
        isFind = [m_navigation routeAnalyst];
        if(!isFind){
            m_startPoint = nil;
            m_endPoint = nil;
            m_nearStartPoint = nil;
            m_nearEndPoint = nil;
        }
    }
    
    return isFind;
    }@catch(NSException *e){
        NSLog(@"%@",e.reason);
    }
}
-(void) addGuideLineOnTrackinglayerWithMapPrj:(PrjCoordSys *)mapPrjCoordSys{
    m_prjCoordSys = mapPrjCoordSys;
    
    Point2D *start = [SNavigation2 getMapPointWithPoint:m_startPoint PrjCoordSys:mapPrjCoordSys];
    Point2D *nearStart = [SNavigation2 getMapPointWithPoint:m_nearStartPoint PrjCoordSys:mapPrjCoordSys];
    Point2D *end = [SNavigation2 getMapPointWithPoint:m_endPoint PrjCoordSys:mapPrjCoordSys];
    Point2D *nearEnd = [SNavigation2 getMapPointWithPoint:m_nearEndPoint PrjCoordSys:mapPrjCoordSys];
    
    TrackingLayer *layer = m_mapControl.map.trackingLayer;
        
    GeoStyle *guideLine = [[GeoStyle alloc] init];
    [guideLine setLineWidth:2];
    [guideLine setLineColor:[[Color alloc]initWithR:82 G:198 B:233]];
    [guideLine setLineSymbolID:2];
        
    Point2Ds *startPoints = [[Point2Ds alloc] init];
    [startPoints add:start];
    [startPoints add:nearStart];
        
    GeoLine *startLine = [[GeoLine alloc] initWithPoint2Ds:startPoints];
    [startLine setStyle:guideLine];
    [layer addGeometry:startLine WithTag:@"startLine"];
        
    Point2Ds *endPoints = [[Point2Ds alloc] init];
    [endPoints add:end];
    [endPoints add:nearEnd];
        
    GeoLine *endLine = [[GeoLine alloc] initWithPoint2Ds:endPoints];
    [endLine setStyle:guideLine];
    [layer addGeometry:endLine WithTag:@"endLine"];
        
    [m_mapControl.map refresh];
    
    m_startPoint = nil;
    m_endPoint = nil;
    m_nearStartPoint = nil;
    m_nearEndPoint = nil;
}

+(Point2D *)getMapPointWithPoint:(Point2D *)pt PrjCoordSys:(PrjCoordSys *) prjCoordSys{
    Point2D *point2D = nil;
    if(pt.x >= -180 && pt.x <= 180 && pt.y >= -90 && pt.y <= 90){
        Point2Ds *points = [[Point2Ds alloc]init];
        [points add:pt];
        PrjCoordSys *desPrjCoordSys = [[PrjCoordSys alloc]init];
        desPrjCoordSys.type = PCST_EARTH_LONGITUDE_LATITUDE;
        [CoordSysTranslator convert:points PrjCoordSys:desPrjCoordSys PrjCoordSys:prjCoordSys CoordSysTransParameter:[[CoordSysTransParameter alloc]init] CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        point2D = [points getItem:0];
    }else{
        point2D = pt;
    }
    return point2D;
}

@end
