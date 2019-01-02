//
//  LayerSettingGrid.h
//  LibUGC
//
//  Created by imobile-xzy on 15/10/13.
//  Copyright (c) 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LayerSetting.h"

@class GeoStyle;
@class Layer;
@class Layers;
@class Color;
@interface LayerSettingGrid : NSObject<LayerSetting>
/**
 * @brief  获取矢量图层的类型。
 */
@property(nonatomic,readonly)LayerSettingType layerType;

/**
 * @brief  获取设置是否透明,设置则指定片元透明,设置颜色值无效。
 */
@property(nonatomic,assign)BOOL isTransparent;

/**
 * @brief  获取设置指定片元颜色,若设置透明则无效。
 */
@property(nonatomic,strong)Color* specialValueColor;

/**
 * @brief  获取设置片元值。
 */
@property(nonatomic,assign)NSUInteger specialValue;
-(int)getOpaqueRate;

-(void)setOpaqueRate:(int)opavalue;

-(int)getContrast;

-(void)setContrast:(int)opavalue;

-(int)getBrightness;

-(void)setBrightness:(int)opavalue;
/**
 * @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
 */
- (void)dispose;
@end
