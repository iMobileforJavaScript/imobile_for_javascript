//
//  FacilityAnalystSetting3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DatasetVector,WeightFieldInfos3D;

@interface FacilityAnalystSetting3D : NSObject

/**
 * 障碍弧段ID列表
 */
@property (nonatomic,strong) NSArray* barrierEdges;
/**
 * 障碍节点ID列表
 */
@property (nonatomic,strong) NSArray* barrierNodes;
/**
 * 网络数据集
 */
@property (nonatomic,strong) DatasetVector* netWorkDataset;
/**
 * 流向字段列表
 */
@property (nonatomic,strong) NSString* directionField;
/**
 * 弧段ID的字段
 */
@property (nonatomic,strong) NSString* edgeIDField;
/**
 * 弧段起始结点ID的字段
 */
@property (nonatomic,strong) NSString* fNodeIDfield;
/**
 * 节点ID字段
 */
@property (nonatomic,strong) NSString* nodeIDfield;
/**
 * 弧段终止结点ID的字段
 */
@property (nonatomic,strong) NSString* tNodeIDfield;
/**
 * 点到弧段的距离容限
 */
@property (nonatomic,assign) double tolerance;
/**
 * 权值信息集合对象,类型为WeightFieldInfos，该属性的设置是为了使分析支持多线程
 */
@property (nonatomic,strong) WeightFieldInfos3D *weightFieldInfos;


-(id)initWith:(FacilityAnalystSetting3D *)facilityAnalystSetting;

//-(void)copyFrom:(FacilityAnalystSetting3D*) facilityAnalystSetting;

@end
