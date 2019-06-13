//
//  LayerSettingVectorCache.h
//  LibUGC
//
//  Created by imobile-xzy on 2018/7/5.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LayerSetting.h"

@class GeoStyle,TextStyle;

@interface LayerSettingVectorCache : NSObject<LayerSetting>

/**
 * @brief  获取矢量图层的类型。
 */
@property(nonatomic,readonly)LayerSettingType layerType;
//子图层ID
@property(nonatomic,strong)NSArray* subLayerIDs;

/**
 * @brief 设置矢量图层的风格。
 *
 * <p> 默认值为 {FillBackColor=Color [A=255, R=255, G=255, B=255],FillForeColor=Color [A=255, R=189, G=235, B=255],FillGradientAngle=0,FillGradientMode=None,FillGradientOffsetRatioX=0,FillGradientOffsetRatioY=0,FillOpaqueRate=100,FillSymbolID=0,LineColor=Color [A=255, R=0, G=0, B=0],LineSymbolID=0,LineWidth=1,MarkerAngle=0,MarkerSize={Width=28,Height=-1},MarkerSymbolID=0}。
 * @return 矢量图层的风格。
	*/
-(void)setSubLayerStyle:(NSString*)subLayer style:(GeoStyle*)geoStyle;
-(void)setSubLayerTextStyle:(NSString*)subLayer style:(TextStyle*)textStyle;
//设置是否可见，以及可见层级
-(void)setSubLayerVisual:(NSString*)subLayer visual:(BOOL)bVisual max:(int)maxLevel min:(int)minLevel;
//保存修改的风格
-(void)save;
//@property(nonatomic,assign)GeoStyle *geoStyle;
@end
