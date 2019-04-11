//
//  LayerSettingVector.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <UIKit/UIKit.h>
#import "LayerSettingType.h"
#import "LayerSetting.h"

@class GeoStyle;
@class Layer;
@class Layers;

/**  矢量图层设置类。
 *
 * <p>该类主要用来设置矢量图层的显示风格。矢量图层用单一的符号或风格绘制所有的要素。当你只想可视化地显示你的空间数据，只关心空间数据中各要素在什么位置，而不关心各要素在数量或性质上的不同时，可以用普通图层来显示要素数据。 </p>
 */
@interface LayerSettingVector : NSObject<LayerSetting> 

/**
     * @brief  获取矢量图层的类型。
     */
@property(nonatomic,readonly)LayerSettingType layerType;

/**
     * @brief 获取或设置矢量图层的风格。
     * 
     * <p> 默认值为 {FillBackColor=Color [A=255, R=255, G=255, B=255],FillForeColor=Color [A=255, R=189, G=235, B=255],FillGradientAngle=0,FillGradientMode=None,FillGradientOffsetRatioX=0,FillGradientOffsetRatioY=0,FillOpaqueRate=100,FillSymbolID=0,LineColor=Color [A=255, R=0, G=0, B=0],LineSymbolID=0,LineWidth=1,MarkerAngle=0,MarkerSize={Width=28,Height=-1},MarkerSymbolID=0}。
    * @return 矢量图层的风格。
	*/
@property(nonatomic,assign)GeoStyle *geoStyle;

/**
     *  @brief 默认构造函数，构造一个新的 {@link LayerSettingVector LayerSettingVector} 对象。
     */
- (id)init;

/**
     * @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     */
- (void)dispose;
@end
