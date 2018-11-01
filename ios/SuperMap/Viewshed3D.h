//
//  Viewshed3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Point3D.h"
#import "AnalysisQuality.h"
 

@class Scene,Color;
/** 可视域分析类。
*  
* <p>设置观察点、目标的位置，水平、垂直视角范围，建立可视区域分析并在指定的场景中显示分析结果。该分析针对三维场景模型分析
    设置观察者位置属性和目标点即可，其余属性可以自动生成默认值</p>
*/
@interface Viewshed3D : NSObject

/// 获取或设置可视区域的颜色
@property(nonatomic)Color *visibleAreaColor;

/// 获取或设置不可视区域的颜色
@property(nonatomic)Color *hiddenAreaColor;

/// 获取或设置观察点的位置
@property(nonatomic)Point3D viewerPosition;

/// 设置目标点    根据目标点位置，能计算观察者点位和目标点的距离和方向
@property(nonatomic)Point3D targetPoint;

/// 获取或设置当前相机的方向与正北方向的夹角，单位：度  默认不需设置
@property(nonatomic)double direction;

/// 获取或设置当前分析的相机俯仰角。注意：该俯仰角指当相机方向与地面平行的时候是0度，与相机本身参数俯仰不一样  默认不需设置
@property(nonatomic)double pitch;

/// 获取或设置可视域分析的水平视角范围。单位：度。默认不需设置
@property(nonatomic)double horizontalFov;

/// 获取或设置可视域分析垂直视角范围。单位：度。默认不需设置
@property(nonatomic)double verticalFov;

/// 获取或设置可视距离，单位：米。默认不需设置
@property(nonatomic)double distance;

/// 获取或设置分析的质量级别。默认为MEDIUM
@property(nonatomic)AnalysisQuality quality;

/** 根据指定的Scene对象，构造一个新的Viewshed3D对象
 @param  scene 指定的Scene对象
 @return  Viewshed3D对象
 */
- (id)initWith:(Scene*)scene;

/// 执行分析，得出分析结果
- (BOOL)build;

/// 清除分析结果。
- (void)clearResult;

@end
