//
//  Recordset.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "StatisticMode.h"

@class FieldInfos;
@class Rectangle2D;
@class DatasetVector;
@class QueryParameter;
@class Geometry,FeatureSet;

/** 记录集类。
 * 
 * <p> 通过此类，可以实现对矢量数据集中的数据进行操作。
 * <p> 数据源有文件型,在文件型数据中空间几何信息和属性信息是分别存储的，记录集的应用可能比较让人费解，实际上，
 * 操作时是将数据都看成是一个空间信息和属性信息一体化存储的表，而记录集是从其中取出的用来操作的一个子集。记录集中的一条记录，即一行，对应着一个要素，包含该要素的空间几何信息和属性信息
 * 。记录集中的一列对应一个字段的信息。</p>
 *  <p>记录集可通过两种方式获得：在地图控件中选中若干个几何对象形成一个选择集，然后把选择集转换为记录集；或者从矢量数据集中获得一个记录集，有两种方法：
 * 用户可以通过
 * DatasetVector.getRecordset()
 * 方法直接从矢量数据集中返回记录集，也可以通过查询语句返回记录集，所不同的是前者得到的记录集包含该类集合的全部空间几何信息和属性信息
 * ，而后者得到的是经过查询语句条件过滤的记录集。<p>
 * @note  用户得到  <Recordset> 对象后，当执行完系列操作后，需要对该对象进行释放。
 */
@interface Recordset : NSObject 

/**
	 * @brief 获取记录集中字段（Field）的数目。
	 * 
	 * @return 字段（Field）的数目。
	 */
@property(nonatomic,readonly)NSInteger fieldCount;

/**
	 * @brief 获取记录集的属性数据表中所有记录对应的几何对象的外接矩形。
	 * 
	 * @return 记录集的属性数据表中所有记录对应的几何对象的外接矩形。
	 */
@property(nonatomic,readonly)Rectangle2D *bounds;


/**
	 *@brief   获取记录集对应的数据集。
	 * 
	 * @return 记录集对应的数据集。
	 */
@property(nonatomic,readonly)DatasetVector *datasetVector;

/**
	 * @brief 获取当前记录集对应的查询参数,返回一个副本。
	 * 
	 * @return 查询的记录集。
	 *  <p> 具体查询参数信息请参见 <QueryParameter>  类型。
	 */
@property(nonatomic,readonly)QueryParameter *queryParameter;

/**
	 * @brief 获取记录集里的字段信息集合对象。
	 *  <p> 字段信息集合类的详细信息参见  <FieldInfos> 类。
	 * @return 一个 Fieldinfos 的副本。
	 */
@property(nonatomic,readonly)FieldInfos *fieldInfos;

/**
	 * @brief 判断记录集是否已经关闭。 记录集已经关闭返回 true，否则返回 false。
	 * 
	 * <p> 默认值为 false，即记录集尚未关闭。
	 * @return 记录集是否已经关闭。
	 */
@property(nonatomic,readonly)BOOL isClosed;

/**
	 * @brief  判断当前记录的位置是否在记录集中第一条记录的前面（当然第一条记录的前面是没有数据的），如果是返回 true；否则返回 false。
	 * 
	 * @return 当前记录是否在第一条记录的前面。
	 * <p> 请参见 <Recordset> 
	 */
@property(nonatomic,readonly)BOOL isBOF;

/**
	 * @brief  获取记录集是否是只读的，如果是只读的，则返回 true，表示记录集中的信息将不可被修改。
	 * 
	 * @return 记录集是否只读。
	 */
@property(nonatomic,readonly)BOOL isReadOnly;

/**
	 * @brief 获取记录集中的记录数。
	 * 
	 * @return 记录集中的记录数。
	 */
@property(nonatomic,readonly)NSInteger recordCount;

/**
	 *  @brief 获取数据集的属性数据表中当前记录对应的几何对象。
	 * 
	 * @return 若成功返回几何对象，否则返回 null。
	 * <p> 请参见 <Recordset> 
	 */
@property(nonatomic,readonly)Geometry *geometry;

/**
	 * @brief  获取数据集的属性表中当前记录对应的几何对象的 ID 号（即 SmID 字段的值）。
	 * 
	 * @return 几何对象的 ID 号。
	 */
@property(nonatomic,readonly)NSInteger ID;

/**
	 * @brief 判断当前记录的位置是否在记录集中的最后一条记录的后面，如果是，返回 true；否则返回 false。
	 * 
	 * @return 当前记录是否在最后一条记录的后面。
	 */
@property(nonatomic,readonly)BOOL isEOF;

/**
	 * @brief 用于在记录集中添加一条记录。 
	 * <p> 
            *  1. 对于只读打开的数据源，其数据集的记录集的此方法不可用；
	 *  2. 在新增记录的时候，不能对记录集进行锁定并编辑（edit），否则  Recordset.addNew()  方法会失败；
	 *  3. <当传入的参数为空时，只有记录集所在的数据集为属性数据集时该方法才可用，如果是其他类型的数据集，调用
	 * Recordset.addNew() 方法会失败。
	 * @param geometry 要追加的记录对应的几何对象，可以是点、线、面、注记等几何对象。该参数可以为 null。
	 * @return 添加成功，返回值为 true，否则返回 false。
	 * <p> 请参见 <Recordset> 
	 */
-(BOOL)addNew:(Geometry *)geometry;


/**
	 *@brief   用于提交对记录集的修改，包括添加、编辑记录、修改字段值的操作。
	  * <p> 对记录集做修改之后，都需要使用update
	 * 来提交修改。每对一条记录做完修改就需要调用一次 update来提交修改。
	 * 
	 * @return 更新成功返回 true，否则返回 false。
	 * <p> 请参见 <Recordset> 
	 */
-(BOOL)update;

/**
	 *@brief    用于关闭记录集。使用记录集以后应及时关闭。
	 */
-(void)close;

/**
	 * @brief 用于删除数据集中的当前记录，成功则返回 true。
	 * 
	 * <p> 当记录为只读时，该方法不可用。
	 * 
	 * @return 删除成功则返回 true，否则返回 false。
	 * <p> 请参见 <Recordset> 
	 */
-(BOOL)delete;

/**
	 *@brief  物理性删除指定记录集中的所有记录，即把记录从计算机的物理存储介质上删除，无法恢复。
	 *
	 *  <p> 当记录为只读时，该方法不可用。
	 * 
	 * @return 删除成功则返回 true，否则返回 false。
	 */
-(BOOL)deleteAll;

/**
	 * @brief  锁定并编辑记录集的当前记录，成功则返回 true。 
	 *  <p> 用该方法编辑后，一定要用 update() 方法更新记录集，而且在 update()
	 * 之前不能移动当前记录的位置，否则编辑失败，记录集也可能被损坏。
	 * 
	 * @return 编辑成功返回 true，否则返回 false。
	 */
-(BOOL)edit;

/**
	 *  @brief 将当前记录位置移动 count 行，将该位置的记录设置为当前记录。成功返回 true。
	 * <p> count小于0表示向前移，大于0表示向后移动，等于0时不移动。如果移动的行数太多，超出了 {@link Recordset Recordset}
	 * 的范围，将会返回 false，当前记录不移动。
	 * 
	 * @param count 移动的记录数。       
	 * @return 移动成功返回 true，否则返回 false。
	 */
-(BOOL)move:(NSInteger)count;

/**
	 * @brief 用于移动当前记录位置到第一条记录，使第一条记录成为当前记录。成功则返回 true。
	 * 
	 * @return 移动成功返回 true，否则返回 false。
	 * <p> 请参见 <Recordset> 
	 */
-(BOOL)moveFirst;

/**
	 * @brief  用于移动当前记录位置到最后一条记录，使最后一条记录成为当前记录。成功则返回 true。
	 * 
	 * @return 移动成功返回 true，否则返回 false。
	 */
-(BOOL)moveLast;

/**
	 * @brief 移动当前记录位置到下一条记录，使该记录成为当前记录。成功则返回 true。若当前记录已经为最后一条记录则返回 false。
	 * 
	 * @return 移动成功返回 true，否则返回 false。
	 */
-(BOOL)moveNext;

/**
	 * @brief  移动当前记录位置到上一条记录，使该记录成为当前记录。成功则返回 true。若当前记录已经为第一条记录则返回 false。
	 * 
	 * @return 移动成功返回 true，否则返回 false。
	 */
-(BOOL)movePrev;

/**
	 * @brief  用于移动当前记录位置到指定的位置，将该指定位置的记录作为当前记录。成功则返回 true。
	 * 
	 * @param position 移动到的位置，即第几条记录。位置从零开始，moveTo(0)  和 moveFirst 等效。
	 * @return 移动成功返回 true，否则返回 false。
	 */
-(BOOL)moveTo:(NSInteger)position;

/**
	 *  @brief  在记录中搜索指定 ID 号的记录，并定位该记录为当前记录。
	 * 
	 * @param indexId 要搜索的 ID 号。        
	 * @return 成功则返回 true，否则返回 false。
	 */
-(BOOL)seekID:(NSInteger)indexId;

/**
	 *   @brief   根据字段序号指定字段，返回数据集的属性数据表中当前记录相应字段的值。
	 * 
	 * @param index 要取其值的字段的序号。     
	 * @return 当前记录中某一字段的值。
	 */
- (NSObject *)getFieldValueWithIndex:(NSInteger)index;

/**
	 *@brief   根据字段名指定字段，返回数据集的属性数据表中当前记录该字段的值。
	 * 
	 * @param value 要取其值的字段的名称。    
	 * @return 当前记录中某一字段的值。
	 */
- (NSObject *)getFieldValueWithString:(NSString *)value;

/**
	 * @brief 根据要修改的字段的序号，设定记录集中相应字段的值。
	 * <p> 成功则返回 true。在对某一字段赋值的时候，需先调用 {@link #edit()
	 * edit()} 锁定要修改的记录，修改之后需调用 {@link #update() update()} 进行提交。
	 * 
	 * @param index  要修改的字段的序号。     
	 * @param value   新字段值。       
	 * @return 设定成功返回 true，否则返回 false。
	 */
-(BOOL)setFieldValue:(NSInteger)index Obj:(NSObject *)value;

/**
	 *@brief  根据字段序号，设定记录集中相应字段的值为 null，成功则返回 true。
	 * 
	 * @param index 要设定的字段的序号。       
	 * @return 设定成功返回 true，否则返回 false。
	 */
-(BOOL)setFieldValueNULL:(NSInteger)index;

/**
	 * @brief  根据字段名称，设定记录集中相应字段的值为 null，成功则返回 true。
	 * 
	 * @param value 要设定的字段的名称。
	 * @return 设定成功返回 true，否则返回 false。
	 */
-(BOOL)setFieldValueNULLWithString:(NSString *)value;
/**
	 * @brief  根据要修改的字段的名称，设定记录集中相应字段的值。
	 * <p> 成功则返回 true。在对某一字段赋值的时候，需先调用 edit
	 * 锁定要修改的记录，修改之后需调用 update 进行提交。
	 * 
	 * @param name 要修改的字段的名称。
	 * @param value 新字段值。
	 * @return 设定成功返回 true，否则返回 false。
	 */
-(BOOL)setFieldValueWithString:(NSString *)name Obj:(id) value;


/**
	 *用于设定记录集中某一字段的值，成功则返回 true。
	 * <p>
	 * 设置已知字段类型的值，如果字段类型不是“布尔”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。
	 * </p>
	 * @param name 要设置其值的字段的名称。      
	 * @param value 要设置的值。           
	 * @return 设定成功返回 true，否则返回 false。
	 */
-(BOOL)setBOOLWithName:(NSString *)name BOOLValue:(BOOL)value;

/**
	 *  @brief  用于设置记录集中当前记录某一字段的值，设置成功则返回 true。
	 * 
	 * <p> 设置已知字段类型的值，如果字段类型不是字节类型，可能会产生数据变化、精度丢失甚至返回失败等问题。
	 * 
	 * @param name  要设置其值的指定字段的名称。       
	 * @param value   要设置的 byte 值。 
	 * @return 一个布尔值，设定成功返回 true，否则返回 false。
	 */
-(BOOL)setByteWithName:(NSString *)name ByteValue:(Byte)value;

/**
	 *@brief  用于设置记录集中某一字段的值，成功则返回 true。
	 *
	 *  <p>设置已知字段类型的值，如果字段类型不是“双精度”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。
	 *  @param name   要设置其值的字段的名称。
	 *  @param value  要设置的值。
	 *@return 设定成功返回 true，否则返回 false。
	 */
-(BOOL)setDoubleWithName:(NSString *)name DoubleValue:(double)value;

// 用于设置日期类型字段的值
-(BOOL)setDateWithName:(NSString *)name DateValue:(NSDate*)value;

/**
	 * @brief 用于设定记录集中某一字段的值，成功则返回 true。
	 *
	 *  <p> 设置已知字段类型的值，如果字段类型不是“文本”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。
	 * @param name  要设置其值的字段的名称。
	 * @param value  要设置的值。
	 * @return 设定成功返回 true，否则返回 false。
	 */
-(BOOL)setStringWithName:(NSString *)name StringValue:(NSString *)value;

/**
	 * @brief  用于设置记录集中某一字段的值。
	 * 
	 * <p> 设置已知字段类型的值，如果字段类型不是“布尔”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
	 * @param index 要设置其值的字段的索引。
	 * @param value   要设置的值。
	 * @return 设定成功返回 true，否则返回 false。           
	 */
-(BOOL)setBOOLWithIndex:(NSInteger)index BOOLValue:(BOOL)value;

/**
* @brief 用于设置记录集中某一字段的值。
* <p>设置已知字段类型的值，如果字段类型不是“单精度”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
* @param name 要设置其值的字段的名称。
* @param value 要设置的值。
* @return 设定成功返回true,否则返回false。
*/
-(BOOL)setSingleWithName:(NSString *)name value:(float)value;

/**
* @brief 用于设置记录集中某一字段的值。
* <p>设置已知字段类型的值，如果字段类型不是“64位整型”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
* @param name 要设置其值的指定字段的名称。
* @param value 要设置的值。
* @return 设定成功返回true,否则返回false。
*/
-(BOOL)setInt64WithName:(NSString *)name value:(long)value;

/**
* @brief 用于设置记录集中某一字段的值。
* <p>设置已知字段类型的值，如果字段类型不是“32位整型”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
* @param name 要设置其值的指定字段的名称。
* @param value 要设置的值。
* @return 设定成功返回true,否则返回false。
*/
-(BOOL)setInt32WithName:(NSString *)name value:(int)value;

/**
* @brief 用于设置记录集中当前记录某一“16位整型”类型字段的值。
* <p>设置已知字段类型的值，如果字段类型不是“16位整型”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
* @param name 要设置其值的指定字段的名称。
* @param value 要设置的值。
* @return 设定成功返回true，否则返回false。
*/
-(BOOL)setInt16WithName:(NSString*)name shortValue:(short)value;

/**
* @brief 用于设置记录集中某一字段的值。
* <p>设置已知字段类型的值，如果字段类型不是“Char”类型，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
* @param name 要设置其值的指定字段的名称。
* @param value 要设置的值。
* @return 设定成功返回true,否则返回false。
*/
-(BOOL)setCharWithName:(NSString *)name charValue:(NSString *)value;

/**
* @brief 用于设置记录集中某一字段的值。
* <p>设置已知字段类型的值，如果字段类型不是“ DateTime”，可能会产生数据变化、精度丢失甚至返回失败等问题。</p>
* @param name 要取其值的字段的名称。
* @param value 要设置的值。
* @return 设定成功返回 true，否则返回 false。
*/
-(BOOL)setDataTime:(NSString *)name dataV:(NSString *)value;

/**
	 * @brief   用于修改记录集当前位置的几何对象，覆盖原来的几何对象，成功则返回true。
	 * 
	 *  修改记录的几何对象时，系统自动修改与对象有关的系统字段的值，如多边形对象的面积，线段对象的长度等。
	 * @param geometry   用来覆盖原几何对象的新几何对象。       
	 * @return 设置成功返回 true，否则返回 false。
	 * @exception NullPointerException
	 *                如果传入的参数为null，则抛出 NullPointerException。
	 * @exception IllegalArgumentException
	 *                如果属性表数据集调用此接口，且传入参数不为 null 时，则抛出 IllegalArgumentException
	 *                。
	 */
-(BOOL)setGeometry:(Geometry *)geometry;

/**
 * @brief   通过字段序号指定字段，对指定字段进行诸如最大值、最小值、平均值，总和，标准差和方差等方式的统计。
 *
*/
-(double)statisticByIndex:(int) index statisticMode:(StatisticMode)mode;

/**
 * @brief   通过字段名称指定字段，对指定字段进行诸如最大值、最小值、平均值，总和，标准差和方差等方式的统计。
 *
 */
-(double)statisticByName:(NSString *)name statisticMode:(StatisticMode)mode;

/**
	 *  @brief   释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
	 */
-(void)dispose;

/**
 * @brief 设置批量更新操作的最大记录数,批量更新的操作记录数等于这个最大记录数时即刻执行批量提交。 
 */
@property (nonatomic)NSInteger maxBatchCount;

/**
 * @brief 设置批量更新操作开始进行,更新操作不是立即生效而是要等到调用batchUpdate操作后统一更新。
 */
-(void)batchBegin;

/**
 * @brief 使批量更新操作生效
 */

-(void)batchUpdate;

/**
 * @brief 取消批量更新
 */

-(void)batchCancel;

/**
 * 从GeoJSON中的字符串中获取几何对象，及其所以属性值，并将其更新到数据集
 * <p>支持的几何对象类型包括：点、线、面、多线
 * @param geoJSON   GeoJSON格式的字符串，其中可以包含一个几何对象，也可以是包含多个对象的集合
 * @return          获取到所有几何对象，并更新成功，返回true；否则，返回false
 */
-(BOOL)fromGeoJSON:(NSString*)geoJSON;

/**
 * 从当前记录起，将数据集中的指定数目的记录转换成GeoJSON格式的字符串
 * <p>支持的几何对象类型包括：点、线、面、多线，该方法最多支持获取包含连续10条记录的GeoJSON串.hasAttributte为true时，返回Feature类型的字符串；hasAttributte为false时，返回只含几何对象的Geometry类型的字符串
 * @param hasAttributte   是否包含属性值
 * @param count           需要获取的记录条数
 * @return                返回获取到的GeoJSON格式字符串，若没有结果，返回null
 */
-(NSString*)toGeoJSON:(BOOL)hasAttributte count:(int)count;

@end
