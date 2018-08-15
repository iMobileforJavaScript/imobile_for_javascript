//
//  GeoBox.h
//  Objects_iOS
//
//  Created by zyd on 2018/3/9.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import "Geometry3D.h"

@class Size2D;
@interface GeoBox : Geometry3D

// 获取或设置长方体的底面的大小
@property (nonatomic, strong) Size2D *bottomSize;

// 获取或设置长方体几何对象的高度，即在Z轴方向的长度，单位是米
@property (nonatomic, assign) double height;

// 获取长方体几何对象的中心点
@property (nonatomic, assign, readonly) Point3D center;

/** @brief 构造一个长方体几何对象
 @return 长方体几何对象
 */
- (instancetype)init;

/** @brief 根据指定的长方体几何对象构造一个新的长方体几何对象
 @param geoBox 指定的长方体几何对象
 @return 新的长方体几何对象
 */
- (instancetype)initWithGeoBox:(GeoBox *)geoBox;

/** @brief 根据指定的位置、底面大小和高度构造一个长方体几何对象
 @param position 长方体几何对象的位置
 @param bottomSize 长方体几何对象的底面大小
 @param height 长方体几何对象的高度
 @return 长方体几何对象
 */
- (instancetype)initWithPosition:(Point3D)position bottomSize:(Size2D *)bottomSize height:(double)height;

@end
