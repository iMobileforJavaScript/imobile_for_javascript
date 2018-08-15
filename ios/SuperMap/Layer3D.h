//
//  Layer3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Layer3DType.h"
#import "Point3D.h"
#import "BoxClipPart.h"

@class Layer3Ds,Selection3D,FieldInfos,Rect2D,Feature3Ds, GeoBox, Color;

/** 三维图层类。
 <p>该类提供了三维图层显示和控制等便于三维地图管理的一系列设置方法。</p>
 <p>三维图层种类有以下几种：数据集类型三维图层、地图类型三维图层、KML 类型三维图层、影像文件类型三维图层、模型缓存类型三维图层和矢量文件图层。各种类型三维图层可以叠加在一起显示。</p>
 <p>三维图层类提供了对三维图层的显示、选择等状态的控制，可以实现控制图层是否可选择，是否显示，还可以利用该类提供的方法返回图层中被选择的对象集合等。</p>
 */
@interface Layer3D : NSObject {
    BOOL _visible;
    BOOL _selectable;
    NSString *_dataName;
    NSString *_name;
    NSString *_captionName;
    Layer3DType _type;
    Selection3D *_selection3D;
    FieldInfos *_fieldInfos;
    Feature3Ds *_feature3Ds;
}




///返回或设置三维图层是否可见。
@property (nonatomic) BOOL visible;


///返回或设置三维图层是否可选择。
@property (nonatomic) BOOL selectable;


 ///返回三维图层所使用标题名称。
@property (nonatomic,readonly) NSString *captionName;

///返回三维图层的文件位置。
@property (nonatomic,readonly) NSString *dataName;

///返回三维图层的名称，此名称在场景中唯一标识此图层。
@property (nonatomic,readonly) NSString *name;

/**
     * @brief 获取或设置三维图层的阴影是否可见。默认值为 false，表示阴影不可见。
     * @return 一个布尔值，指示三维图层的阴影是否可见。true,表示图层的阴影可见，false,表示不可见。
     */
@property (nonatomic)BOOL shadowEnabled;


///返回三维图层所使用数据的类型。
@property (nonatomic,readonly) Layer3DType type;


///返回三维图层的选择集。
@property (nonatomic,readonly) Selection3D *selection3D;


///返回三维矢量图层的属性字段信息集合对象。
@property (nonatomic,readonly) FieldInfos *fieldInfos;


///返回三维图层的范围。
@property (nonatomic,readonly) Rect2D *bounds;

///返回持有的feature3Ds属性
@property (nonatomic, strong, readonly) Feature3Ds *feature3Ds;

/**
 图层不可见释放内存
 */
@property (nonatomic, assign) BOOL releaseWhenInvisible;

///获取或设置裁剪面边线的颜色
@property (nonatomic, strong) Color *clipLineColor;

/**
 *  获取或设置图层对视口的可见性
 */

- (BOOL)visibleInViewport:(NSInteger)index;
- (void)setVisible:(BOOL)visible inViewport:(NSInteger)index;

/** @brief 清除自定义裁剪面
 */
- (void)clearCustomClipPlane;

/** @brief 设置自定义裁剪面，保留顺时针法线方向的模型
 @param firstPoint 指定裁剪面的第一个顶点
 @param secondPoint 指定裁剪面的第二个顶点
 @param thirdPoint 指定裁剪面的第三个顶点
 */
- (void)setCustomClipPlaneWithPoint:(Point3D)firstPoint point:(Point3D)secondPoint point:(Point3D)thirdPoint;

/** @brief 设置一个盒子，将图层在盒子之外的部分隐藏掉
 @param box 指定的盒子
 */
- (void)setCustomClipPlanesByBox:(GeoBox *)box;

/** @brief 设置一个盒子，对图层可渲染部分进行裁剪
 @param box 指定的盒子
 @param part 裁剪面裁剪模式
 */
- (void)clipByBox:(GeoBox *)box part:(BoxClipPart)part;

/** @brief 获取用来裁剪的盒子
 @return 返回裁剪的盒子
 */
- (GeoBox *)getClipBox;

/** @brief 获取BOX裁剪的模式
 @return 返回BOX裁剪的模式
 */
- (BoxClipPart)getBoxClipPart;

/* 更新图层 */
- (void)updateData;
@end
