//
//  Feature.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Geometry.h"

/** 几何对象类，包含几何对象与属性信息。
* 
* <p>用于向服务器进行上传数据服务动作时操作指定记录的Featrue对象。</p>
*/
@interface Feature : NSObject
/**
 * @brief 根据指定的参数构造一个新的Feature对象。
 * @param fieldNames 指定的属性名数组。
 * @param fieldValues 指定的属性值数组。
 * @param geo 指定的几何对象。
 */
-(id)initWithFeature:(NSMutableArray *)fieldNames fieldValue:(NSMutableArray *)fieldValues geometry:(Geometry *)geo;

/**
 * @brief 获取几何对象。
 * @return 获取到的几何对象。
 */
-(Geometry *)getGeometry;

/**
 * @brief 获取属性名数组。
 * @return 获取到的属性名数组。
 */
-(NSMutableArray *)getFieldNames;

/**
* @brief 获取属性值数组。
* @return 获取到的属性值数组。
 */
-(NSMutableArray *)getFieldValues;

/**
 * @brief 将几何对象转换成Json串。
 * @return 几何对象转换的Json串。
 */
-(NSString *)toJson;

/**
* @brief 修改geometry ID
* @param geoID 修改的geometry ID。
*/
-(void)setGeometryID:(int)geoID;

@end
