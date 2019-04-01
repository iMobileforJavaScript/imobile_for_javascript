//
//  TextPart3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Point3D.h"

/**三维文本子对象类
 <p>一个三维文本对象是由一个或多个三维文本子对象构成的，三维文本对象的文字内容是各个子对象的文字内容之和，还可以通过设置各个子对象的放置位置，使一个三维文本对象中的各部分文字具有自己的放置风格。而关于三维文本子对象的文字内容的其他风格，如：文字的对齐方式、字体颜色、字体的大小以及其他文字的风格都由他们所属的三维文本对象的TextStyle属性设置来统一决定。具体内容，请参见 GeoText3D类。
 */
@interface TextPart3D : NSObject

/// 获取或设置此三维文本子对象的锚点，锚点与该子对象的文本对齐方式共同决定该子对象的显示位置。详细信息，请参见TextStyle类的TextAlignment属性
@property(nonatomic)Point3D anchorPoint;
/// 获取或设置此三维文本子对象的文本内容
@property(nonatomic)NSString *text;
/// 获取或设置此三维子对象锚点的 X 坐标，单位为度
@property(nonatomic)double x;
/// 获取或设置此三维文本子对象锚点的 Y 坐标，单位为度
@property(nonatomic)double y;
/// 获取或设置此三维文本子对象锚点的 Z 坐标，单位为米
@property(nonatomic)double z;

/** 构造一个 TextPart3D 的新对象
 @return  TextPart3D对象
 */
- (id)init;

/** 根据指定的参数来构造一个 TextPart3D 的新对象
 @param  x 指定的三维文本子对象锚点的X坐标值，单位为度
 @param  y 指定的三维文本子对象锚点的Y坐标值，单位为度
 @param  z 指定的三维文本子对象锚点的Z坐标值，单位为米
 @return  TextPart3D对象
 */
- (id)initWithString:(NSString *)text x:(double)x y:(double)y z:(double)z;
/** 根据指定的参数来构造一个 TextPart3D 的新对象
 @param  text 指定的三维文本子对象的文本内容
 @param  point 指定的三维文本子对象的锚点
 @return  TextPart3D对象
 */
- (id)initWithString:(NSString *)text point3d:(Point3D)point;

/** 根据指定的参数来构造一个 TextPart3D 的新对象
 @param  part 指定的子对象
 @return  TextPart3D对象
 */
- (id)initWithPart3D:(TextPart3D *)part;

/** 返回当前对象的一个拷贝
 @return  TextPart3D
 */
- (TextPart3D*)clone;
@end
