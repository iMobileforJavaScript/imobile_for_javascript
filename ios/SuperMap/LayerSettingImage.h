//
//  LayerSettingImage.h
//  LibUGC
//
//  Created by imobile-xzy on 15/10/13.
//  Copyright (c) 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LayerSetting.h"
#import "ColorSpaceType.h"

@class GeoStyle;
@class Layer;
@class Layers;
@class Color;
@class ImageStretchOption;

typedef enum {
    /**
     * 组合显示模式
     */
    IDM_COMPOSITE = 0,
    /**
     * 拉伸显示模式
     */
    IDM_STRETCHED = 1,
}ImageDisplayMode;


@interface LayerSettingImage : NSObject<LayerSetting>

/**
 * @brief  获取矢量图层的类型。
 */
@property(nonatomic,readonly)LayerSettingType layerType;

/**
 * @brief  获取设置是否透明。
 */
@property(nonatomic,assign)BOOL isTransparent;

/**
 * @brief  获取设置透明色。
 */
@property(nonatomic,strong)Color* transparentColor;

/**
 * @brief  获取设置透明色容度,范围0-255，默认0 。
 */
@property(nonatomic,assign)NSUInteger transparentColorTolerance;

/**
 * 设置,获取地图指定图层集合(针对Rest服务)
 */
@property(nonatomic,strong)NSString* mapLayersID;

/**
 * 设置影像图层的色彩显示模式。它会根据影像图层当前的色彩格式和显示的波段将该影像图层以该色彩模式进行显示。目前只支持RGB/RGBA两种
 */
@property(nonatomic,assign)ColorSpaceType colorSpaceType;
/**
 *当前影像图层显示的波段索引。假设当前影像图层有若干波段，当需要按照设置的色彩模式（如rgb）设置显示波段时，指定色彩（如rgb中的红色、绿色、蓝色）对应的波段索引(如0，2，1)即可。
 */
@property(nonatomic,strong)NSArray* displayBandIndexes;
/**
 * 影像显示模式，默认值与数据集波段数保持一致，如果数据集为多波段，则默认为组合模式，否则，默认为拉伸模式
 */
@property(nonatomic,assign)ImageDisplayMode imgDisplayMode;
/**
 * 图层多波段Image的拉伸方式
 */
@property(nonatomic,strong)ImageStretchOption *imgStretchOption;

/**
 * @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
 */
- (void)dispose;

/**
 * 获取所有图层的集合，返回字符串数组
 */
-(NSArray*)getAllSubLayers;

/**
 * 获取当前可见图层的集合，返回字符串数组
 */
-(NSArray*)getVisibleSubLayers;

/**
 * 设置当前可见图层的集合
 * @param 字符串数组
 * @return void
 */
-(void)setVisibleSubLayers:(NSArray*)subLayers;

/**
 * 设置图层的最大缓存数
 */
@property (nonatomic) int cacheMaxSize;
@end
