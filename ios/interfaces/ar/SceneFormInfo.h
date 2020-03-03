//
//  SceneFormInfo.h
//  Supermap
//
//  Created by wnmng on 2020/2/19.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/GeoLine3D.h"
#import "SuperMap/GeoPoint3D.h"

@interface SceneFormInfo : NSObject

@property(nonatomic,strong) NSString*name;
@property(nonatomic,strong) GeoLine3D * geoLine3D;
@property(nonatomic,strong) GeoPoint3D * geoPoint3D;
@property(nonatomic,strong) NSString*person;
@property(nonatomic,strong) NSString*time;
@property(nonatomic,strong) NSString*address;
@property(nonatomic,strong) NSString*notes;
@property(nonatomic,assign) int ID;


@end

