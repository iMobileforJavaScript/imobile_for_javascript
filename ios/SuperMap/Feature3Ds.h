//
//  Feature3Ds.h
//  LibUGC
//
//  Created by LK on 15/10/27.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Camera.h"
#import "Feature3DSearchOption.h"

@class Feature3D, Geometry3D;
typedef Camera Cam;


@interface Feature3Ds : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) Cam camera; // 相机
@property (nonatomic, readonly, assign) NSUInteger count;
@property (nonatomic, copy) NSString *description; // 描述信息
@property (nonatomic, getter=isVisible) BOOL visible; // 是否可见
@property (nonatomic, strong) Feature3Ds *parentFeature3Ds;

@property (nonatomic, assign) BOOL isDisposable;

/* 初始化 */
- (instancetype)init;

/* 增加、删除、修改、查找 */
- (Feature3D *)addFeature3D:(Feature3D *)feature3D;
- (Feature3Ds *)addFeature3Ds:(Feature3Ds *)feature3Ds;
- (Feature3D *)addGeometry3D:(Geometry3D *)geometry3D;
- (Feature3Ds *)addKMLFile:(NSString *)kmlFile;

- (void)removeFeature3D:(Feature3D *)feature3D;
- (void)removeFeature3Ds:(Feature3Ds *)feature3Ds;
- (void)removeObjectAtIndex:(NSInteger)index;

- (Feature3Ds *)insertFeature3Ds:(Feature3Ds *)feature3Ds AtIndex:(NSUInteger)index;
- (Feature3D *)insertFeature3D:(Feature3D *)feature3D AtIndex:(NSUInteger)index;

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

- (NSArray *)allFeature3DObjectsWithOption:(Feature3DSearchOption)option;
- (NSArray *)allFeature3DsObjectsWithOption:(Feature3DSearchOption)option;
- (Feature3D *)feature3DWithID:(NSInteger)Id option:(Feature3DSearchOption)option;
- (NSArray *)feature3DObjectsWithName:(NSString *)name option:(Feature3DSearchOption)option;
- (NSArray *)feature3DsObjectsWithName:(NSString *)name option:(Feature3DSearchOption)option;

/* KML */
- (NSString *)toKml;
- (BOOL)fromKml:(NSString *)kml;

/* KMLFile */
- (void)toKMLFile:(NSString *)kmlFile;
- (BOOL)fromKMLFile:(NSString *)kmlFile;

@end
