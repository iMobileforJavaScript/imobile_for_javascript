//
//  GeoModel.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry3D.h"
#import "Point3D.h"
/**三维模型几何对象类
 <p>该类用于建立三维几何对象的模型，从而实现对三维几何对象进行渲染
 */

@class NodeAnimation;

@interface GeoModel : Geometry3D

/// 获取或设置三维模型几何对象的名称
@property(nonatomic)NSString* modelName;

/// 节点动画
@property (nonatomic, readonly, strong) NodeAnimation *nodeAnimation;

/** @brief  构造一个GeoModel对象
 @return  GeoModel对象
 */
- (id)init;

/** @brief  根据指定的GeoModel对象，构造一个新的GeoModel对象
 @param  model 指定的GeoModel对象
 @return  GeoModel对象
 */
- (id)initWithGeoModel:(GeoModel*)model;

/** @brief  根据指定的GeoModel对象，构造一个新的GeoModel对象
 @param  filePath   文件的全路径，支持3DS文件和SGM文件，目前通过文件扩展名来判断文件的类型
 @param  position   三维模型几何对象的位置
 @return  成功返回YES，否则返回NO
 */
- (BOOL)fromFile:(NSString*)filePath Position:(Point3D)position;

/** @brief  根据指定的GeoModel对象，构造一个新的GeoModel对象
 @param  model 指定的GeoModel对象
 @return  返回当前对象的一个拷贝
 */
- (GeoModel*)clone;
@end
