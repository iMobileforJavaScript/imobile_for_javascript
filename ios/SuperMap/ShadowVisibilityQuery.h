//
//  ShadowVisibilityQuery.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**三维分析类。
 <p>阴影分析类，指定分析范围、设置阴影类型、设定分析时间段得出阴影分析结果
 */
@class Scene,Colors,Geometry;
@interface ShadowVisibilityQuery : NSObject

// 获取或设置点间距，分析展示点的间距
@property(nonatomic)double spacing;

// 获取或设置时区偏移
@property(nonatomic)NSTimeZone* baseUTCOffset;

// 获取或设置分析的开始时间
@property(nonatomic)NSDateComponents *startTime;

// 获取或设置分析的结束时间
@property(nonatomic)NSDateComponents *endTime;

// 获取或设置时间间隔
@property(nonatomic)NSTimeZone *timeInterval;

// 获取或设置颜色表
@property(nonatomic)Colors *colorTable;

// 获取或设置分析区域
@property(nonatomic)Geometry* queryRegion;

/** 根据指定的Scene对象，构造一个新的ShadowVisibilityQuery对象
 @param  scene 指定的Scene对象
 @return  ShadowVisibilityQuery对象
 */
- (id)initWith:(Scene*)scene;


/** 获取指定屏幕位置的阴影率
 @param  point 指定的屏幕位置
 @return  阴影率，若返回-1表示获取失败
 */
- (double)shadowRatioWithPosition:(CGPoint)point;

// 执行阴影分析
- (BOOL)build;

// 清除分析结果
- (void)clear;
@end
