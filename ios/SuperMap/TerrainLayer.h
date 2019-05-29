//
//  Layer3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
/**
 * @brief 三维地形图层类。
 */
@class Rect2D;
@interface TerrainLayer : NSObject {
    BOOL _visible;
    NSString *_name;
    NSString *_captionName;
}

/**
 * @brief 返回或设置三维地形图层是否可见。
 */
@property (nonatomic) BOOL visible;

/**
 *@brief 返回三维图层所使用标题名称。
 */
@property (nonatomic,readonly) NSString *captionName;

/**
 * @brief 返回三维地形图层的名称，此名称在场景中唯一标识此图层。
 */
@property (nonatomic,readonly) NSString *name;

/**
 * @brief 返回三维地形图层的范围。
 */
@property (nonatomic,readonly) Rect2D *bounds;

/**
 * @brief 返回或设置三维地形图层的LOD切换距离缩放系数。
 */
@property (assign, nonatomic) double lodRangeScale;

@end
