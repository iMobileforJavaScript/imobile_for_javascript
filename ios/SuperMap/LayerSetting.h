//
//  LayerSetting.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "LayerSettingType.h"
/**
 *   图层设置基类。 
 *
 *  <p>该类是对图层的显示风格的设置的基类。对矢量数据集，栅格数据集以及影像数据集的图层风格分别使用 <LayerSettingVector>  、
 * <LayerSettingGrid> 和 <LayerSettingImage>  类中提供的方法进行设置。矢量图层中所有要素采用相同的渲染风格，栅格图层采用颜色表来显示其像元，影像的图层的风格设置是对影像的亮度，对比度以及透明度等的设置。该类为抽象类。</p>
 */
@protocol LayerSetting <NSObject>

@required 

/**  返回此图层的类型。目前支持的图层设置类型仅包括矢量图层。
     *  
     * @return 图层的类型。
     */
@property(nonatomic,readonly)LayerSettingType layerType;
@optional
@property(nonatomic)BOOL isModefied;

@end
