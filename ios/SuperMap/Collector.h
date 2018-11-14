//
//  Collector.h
//  Transportion3D
//
//  Created by imobile-xzy on 16/10/10.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CollectorElement.h"

@class MapControl,Point2D,Datasource,Dataset;
@class Geometry,GeoStyle,GPSData,Recordset;
@interface Collector : NSObject

@property(nonatomic,strong)MapControl* mapControl;

/**
 * 设置,获取绘制风格
 */
@property(nonatomic,strong)GeoStyle* style;

/**
 * 设置当前编辑节点的宽度,单位是10mm
 */
@property(nonatomic)double editNodeWidth;

/**
 * 设置是否采用手势打点
 * @param collectorId
 * @param value
 * @param promise
 */
@property(nonatomic)BOOL isSingleTapEnable;

/**
 * 定位地图到当前位置
 */
-(void)moveToCurrentPos;

/**
 * 获取当前位置
 */
-(Point2D*)getGPSPoint;

/**
 * 设置数据集
 */
-(void)setDataset:(Dataset*)dataset;

/**
 * 获取数据源
 */
-(Datasource*)getDatasource;

/**
 * 设置当前编辑节点的宽度,单位是10mm
 */
-(double)getEditNodeWidth;
/**
 * 创建指定类型的对象
 */
-(BOOL)createElement:(GPSElementType)type;

/**
 * 创建指定类型的对象
 */
-(Geometry*)getCurGeometry;


/**
 * 添加点,GPS获取的点
 */
-(BOOL)addGPSPoint:(Point2D*)pnt2D;

/**
 * 添加点,GPS获取的点
 */
-(BOOL)addGPSPoint;

/**
 * 回退操作
 * @return
 */
-(BOOL)undo;

/**
 * 重做操作
 * @return
 */
-(BOOL)redo;

/**
 * 打开GPS
 */
-(void)openGPS;

/**
 * 关闭GPS
 */
-(void)closeGPS;

/**
 * 获取当前采集对象
 */
-(CollectorElement*)getElement;

/**
 * 提交
 */
-(BOOL)submit;

-(GPSData*)getGPSData;
@end
