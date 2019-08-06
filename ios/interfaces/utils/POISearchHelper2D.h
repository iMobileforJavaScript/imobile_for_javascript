//
//  POISearchHelper2D.h
//  Supermap
//
//  Created by supermap on 2019/8/1.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/MapControl.h"
#import "SuperMap/OnlinePOIInfo.h"
#import "SuperMap/OnlinePOIQuery.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/Map.h"
#import "SuperMap/Callout.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/CoordSysTransParameter.h"
@protocol PoiSearch2DDelegate <NSObject>
@required

-(void)locations:(NSArray *)locations;

@end

@interface POISearchHelper2D : NSObject

+(id)singletonInstance;
-(void)initMapControl:(MapControl*)mapcontrol;
-(void)poiSearch:(NSString*) keyWords;

-(BOOL)toLocationPoint:(int) index;

-(void)clearPoint:(MapControl*)control;
/**
 * 接口
 */
@property (nonatomic) id<PoiSearch2DDelegate> delegate;
@end

