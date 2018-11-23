//
//  CollectorElement.h
//  Transportion3D
//
//  Created by imobile-xzy on 16/10/10.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeometryType.h"
/**
 * GPS元素的类型
 */
typedef enum  {
    COL_POINT =0, COL_LINE, COL_POLYGON
}GPSElementType;

@class Collector,Geometry,Point2D,Rectangle2D,Point2Ds;
@protocol GPSElementDelegate;

@interface CollectorElement : NSObject

/**
 * 获取,设置对象的名称
 * @param name
 */
@property(nonatomic,strong)NSString* name;

/**
 * 获取,设置对象的备注信息
 */
@property(nonatomic,strong)NSString* notes;

/**
 * 获取,设置元素的几何对象
 */
@property(nonatomic,strong)Geometry* geometry;

/**
 * 设置点击监听器
 * @param listener
 */
//@property(nonatomic)id<GPSElementDelegate> OnClickDelegate;

/**
 * 获取,获取用户数据
 * @param data
 */
@property(nonatomic)NSString* userData;

/**
 * 获得点串
 * @return 点串
 */
-(Point2Ds*)getGeoPoints;


/**
 * 获取点串分组信息（仅适用于通过Geomotry构造的动态数据）
 * @return
 */
-(NSArray*)getPart;

/**
 * 获取对象的ID
 * @return
 */
-(int)getID;

/**
 * 获取边框范围
 * @return
 */
-(Rectangle2D*)getBounds;

/**
 *  添加点
 * @param pt
 */
-(void)addPoint:(Point2D*)pt;

/**
 * 设置采集管理器
 */
-(void)setCollector:(Collector*)collector;

/**
 * 通过Geomotry构造动态数据
 * @param geometry 地理元素
 * @return 是否构造成功
 */
-(BOOL)fromGeometry:(Geometry*)geometry;
/**
 * 获取类型
 * @return
 */
-(GPSElementType)getType;

/**
 * 获取元素的几何类型
 */
-(GeometryType)getGeometryType;
@end

//@protocol GPSElementDelegate <NSObject>
///**
//* 在轻击动态元素时被触发
//*/
//-(void)onClick:(CollectorElement*)element;
//
//@end
