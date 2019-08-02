//
//  POISearchHelper2D.m
//  Supermap
//
//  Created by supermap on 2019/8/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "POISearchHelper2D.h"
static POISearchHelper2D *poiSearchHelper2D = nil;
@interface POISearchHelper2D()<OnlinePOIQueryCallback>{
    MapControl *m_mapControl;
    NSArray *m_searchResult;
    Callout *m_callout;
}

@end
@implementation POISearchHelper2D

+(id)singletonInstance{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        poiSearchHelper2D = [[self alloc] init];
    });
    
    return poiSearchHelper2D;
}

-(void)initMapControl:(MapControl*)mapcontrol{
    m_mapControl = mapcontrol;
}

-(void)poiSearch:(NSString*) keyWords{
    OnlinePOIQuery *poiQuery=[[OnlinePOIQuery alloc]init];
    OnlinePOIQueryParameter *poiQueryParameter=[[OnlinePOIQueryParameter alloc]init];
    poiQuery.delegate=self;
    [poiQueryParameter setKeywords:keyWords];
    [poiQuery setKey:@"tY5A7zRBvPY0fTHDmKkDjjlr"];
    [poiQuery queryPOIWithParam:poiQueryParameter];
}

-(BOOL)toLocationPoint:(int) index{
    OnlinePOIInfo * curPOI = [m_searchResult objectAtIndex:index];
    Point2D *point = curPOI.location;
    
    Point2Ds *points = [[Point2Ds alloc] init];
    [points add:point];
    PrjCoordSys *sourcePrjCoordSys = [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE];
    
    CoordSysTransParameter *coordSysTransParameter = [[CoordSysTransParameter alloc] init];
    [CoordSysTranslator convert:points PrjCoordSys:sourcePrjCoordSys PrjCoordSys:m_mapControl.map.prjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
    Point2D *mapPoint = [points getItem:0];
    
    NSString *name = curPOI.name;
    if(m_callout == nil){
        m_callout = [[Callout alloc]initWithMapControl:m_mapControl BackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0] Alignment:CALLOUT_LEFTBOTTOM];
        m_callout.width = 200;
        m_callout.height = 40;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageNamed:@"resources.bundle/icon_red.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, 40, 40)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 160, 40)];
        
        UIFont *font = [UIFont systemFontOfSize:16.0];
        label.font = font;
        label.text = name;
        
        label.textColor = [UIColor grayColor];
        label.layer.shadowColor = [UIColor blackColor].CGColor;
        label.layer.shadowOffset = CGSizeMake(0, 0);
        label.layer.shadowOpacity = 1;
        
        [m_callout addSubview:imageView];
        [m_callout addSubview:label];
        [m_callout showAt:mapPoint Tag:name];
        
        if(m_mapControl.map.scale < 0.000011947150294723098)
            m_mapControl.map.scale = 0.000011947150294723098;
        m_mapControl.map.center = mapPoint;
        [m_mapControl.map refresh];
    });
    return YES;
}

-(void)clearPoint:(MapControl*)control{
    
}

-(void)querySuccess:(OnlinePOIQueryResult*)result{
    if(result){
        [self.delegate locations:result.poiInfos];
        m_searchResult=result.poiInfos;
    }
}
-(void)queryFailed:(NSString*)errorInfo{
    [self.delegate locations:nil];
}
@end
