//
//  SMMedia.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Point2D.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/FieldInfo.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Size2D.h"
#import "SMap.h"
#import "SMLayer.h"
#import "FileUtils.h"
#import "NativeUtil.h"
#import "LocationTransfer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface SMMedia : NSObject

@property (nonatomic, strong) Datasource* datasourse;
@property (nonatomic, strong) Dataset* dataset;
//@property (nonatomic, strong) NSString* mediaType;
//@property (nonatomic, strong) NSString* mediaDicPath;
@property (nonatomic, strong) NSArray* paths;
@property (nonatomic, strong) NSString* fileName;
//@property (nonatomic, strong) NSData* data;
@property (nonatomic, strong) Point2D* location;

/**
 * 初始化，获取当前位置
 **/
- (id)init;
/**
 * 初始化，并设置储存多媒体文件的对象名称，和当前位置
 **/
- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name longitude:(double)longitude latitude:(double)latitude;
- (id)initWithName:(NSString *)name point:(Point2D *)point;
/**
 * 设置数据源 和 数据集
 **/
-(BOOL)setMediaDataset:(Datasource *)datasource datasetName:(NSString *)datasetName;

/**
 * 保存多媒体文件，并保存Dataset
 **/
-(BOOL)saveMedia:(NSArray *)filePaths toDictionary:(NSString *)toDictionary addNew:(BOOL)addNew;

/**
 * 添加多媒体资源文件
 **/
-(BOOL)addMediaFiles:(NSArray *)files;

/**
 * 删除多媒体资源文件
 **/
-(BOOL)deleteMediaFiles:(NSArray *)files;

@end
