//
//  FeatureSet.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "FieldInfos.h"
#import "Geometry.h"
#import "Recordset.h"
#import "FieldType.h"
#import "Feature.h"

/** 要素资源集合类。
 <p>该类存储从服务上获取的数据。</p>
 */
 
@interface FeatureSet : NSObject
   

//@brief 是否含有几何对象。
//@return 若含有几何信息，返回 true；否则返回 false。
//  */
//@property(nonatomic) BOOL bHaveGeometroy;

//
// * @brief  是否只有属性信息
// *
// * @return  若只含有属性信息，返回 true；否则返回 false
// */
//@property(nonatomic) BOOL bHaveAttribute;

/**@brief 根据解析查询后的json串数据构造一个新的FeatureSet对象。
 @param  mJsonObject  id类型的json串数据。
 @return 由解析查询后的json串数据构造而成的一个新的FeatureSet对象。
   */
-(id)initWithQueryFeature:(id)mJsonObject;

/**@brief  根据要素资源和字段信息集合参数构造一个新的FeatureSet对象。
 @param  features  要素资源。
 @param  fields  字段信息集合。
 @return  根据要素资源和字段信息几何参数构造的一个新的FeatureSet对象。
 */
-(id)initWithFeatureSet:(NSMutableArray *)features FieldID:(NSMutableArray*)fields;

/**@brief 获取要素集合里的字段信息集合对象（FieldInfos）。
 @return  一个FieldInfos的副本。
  */
-(FieldInfos *)getFieldInfos;

/**@brief 获取当前要素中的几何对象。
 @return  若获取成功，返回几何对象，否则返回false。
  */
-(Geometry *)getGeometry;

/**@brief 获取要素集合里的字段信息集合的字段个数。
 @return  要素集合中要素的字段个数。
  */
-(int) fieldCount;

/**@brief 获取要素集合里的要素个数。
 @return  要素集合里的要素个数。
  */
-(int) recordCount;

/**@brief 返回当前要素的位置是否在要素集合中第一个要素的前面。
 @return  一个布尔值，如果当前要素的位置是在要素集合中第一个要素的前面返回 true；否则返回 false。
  */
-(BOOL) isBOF;

/**@brief 返回当前要素的位置是否在要素集合中最后一个要素的后面。
 @return  一个布尔值，如果当前要素的位置是在要素集合中最后一个要素的后面返回 true；否则返回 false。
  */
-(BOOL) isEOF;

//
//     * @brief
//     *
//     * @return
//     */
//-(BOOL) addNewRecord:(Recordset*)record;


//-(BOOL) deleteAll;

/**@brief  根据字段序号指定字段，返回当前要素该字段的值。
 @param  index  要取其值的字段的序号。
 @return  当前要素指定字段的字段值。
     */
- (NSObject *)getFieldValueWithIndex:(NSInteger)index;

/**@brief  根据字段名指定字段，返回当前要素该字段的值。
 @param  field  要取其值的字段的名称。
 @return  当前要素指定字段的字段值。
     */
- (NSObject *)getFieldValueWithString:(NSString *)field;

/**@brief  根据要修改的字段的名称，设定要素集合中相应字段的值。
 @param  field   要修改的字段的名称。
 @param  value  新字段值。
     */
-(void)setFieldValue:(NSString *)field value:(id)value;

/**@brief  用于设定要素中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是“布尔”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
 @param  name  要设置其值的字段的名称。
 @param  val  要设置的值。
     */
-(void)setBOOLWithName:(NSString *)name value:(BOOL)val;

/**@brief  用于设定要素集合中当前记录某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是字节类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
 @param  name  要设置其值的值得那个字段的名称。
 @param  val  要设置的 byte 值。
     */
-(void)setbyteWithName:(NSString *)name value:(Byte)val;

/**@brief  用于设定要素要素集合中某一字段的值。
 @param  name  要设置其值的那个字段的名称。
 @param  val  要设置的值。
     */
-(void)setCharWithName:(NSString *)name value:(NSString *)val;

/**@brief  用于设定要素集合中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是 DateTime，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
  @param  name  要设置其值的字段的名称。
  @param  val  要设置的值。
     */
-(void)setDateTime:(NSString *)name value:(NSString *)val;

/**@brief  用于设定要素集合中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是“双精度”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
 @param  name  要设置其值的字段的名称。
 @param  val  要设置的值。
     */
-(void)setDoubleWithName:(NSString *)name value:(double)val;

/**@brief  用于设定要素集合中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是“文本”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
 @param  name  要设置其值的字段的名称。
 @param  val  要设置的值。
     */
-(void)setStringWithName:(NSString *)name value:(NSString *)val;

/**@brief  用于设定要素集合中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是“16位整型”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
 @param  name  要设置其值的字段的名称。
 @param  val  要设置的值。
     */
-(void)setInt16WithName:(NSString *)name value:(short)val;

/**@brief  用于设定要素集合中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是“32位整型”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
 @param  name  要设置其值的字段的名称。
 @param  val  要设置的值。
     */
-(void)setInt32WithName:(NSString *)name value:(int)val;

/**@brief  用于设定要素集合中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是“64位整型”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
 @param  name  要设置其值的字段的名称。
 @param  val  要设置的值。
     */
-(void)setInt64WithName:(NSString *)name value:(long)val;

/**@brief  用于设定要素集合中某一字段的值。
 <p>设置已知字段类型的值，如果字段类型不是“单精度”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
  @param name  要设置其值的字段的名称。
  @param  val  要设置的值。
     */
-(void)setSingleWithName:(NSString *)name value:(float)val;
 
/**@brief  用于移动当前要素位置到第一个要素，使第一个要素成为当前要素。
  @return  移动成功返回 true，否则返回 false。
     */
-(BOOL) moveFirst;

/**@brief  移动当前要素位置到上一个要素，使该要素成为当前要素。
  @return  移动成功返回 true，否则返回 false。
     */
-(BOOL) movePrev;

/**@brief  移动当前要素位置到下一个要素，使该要素成为当前要素。
 @return  移动成功返回 true，否则返回 false。
     */
-(BOOL) moveNext;

/**@brief  用于移动当前要素位置到最后一个要素，使最后一条要素成为当前要素。
 @return 移动成功返回 true，否则返回 false。
     */
-(BOOL) moveLast;

/**@brief  用于移动当前要素位置到指定的位置，将该指定位置的要素作为当前要素。
 @param  position  移动到的位置，即第几个要素。
 @return  移动成功返回 true，否则返回 false。
     */
-(BOOL)moveTo:(NSInteger)position;

/**@brief  获取要素资源。
 @return  获取到的一个要素（包含字段名，字段值，几何信息）。
     */
-(Feature *)getFeature;

-(BOOL)toRecordset:(Recordset**)recordset;
-(BOOL)fromRecordset:(Recordset*)recordset;
@end
