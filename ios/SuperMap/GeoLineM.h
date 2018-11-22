//
//  GeoLineM.h
//  LibUGC
//
//  Created by esupermap on 14-3-3.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import "Geometry.h"
#import "GeoLine.h"

/**
 * <p>Title: 路由对象</p>
 *
 * <p>Description: 是一组具有X，Y坐标与线性度量值的点组成的线性地物对象。</p>
 */

@interface GeoLineM : Geometry
/**
 * <p>转线几何对象类</p>

 */
-(GeoLine *)convertToLine;
@end
