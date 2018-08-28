//
//  DatasetVector.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

#import "Dataset.h"
#import "CursorType.h"
#import "StatisticMode.h"
#import "SpatialIndexInfo.h"

@class Geometry;
@class GeoLine;
@class FieldInfos,DatasetVector,Recordset,QueryParameter;

@protocol QueryDelegate <NSObject>
@required
-(void) queryResultWithDataset:(Dataset *)dataset fieldName:(NSString *)fieldName smIDs:(NSMutableArray *) smIDs;
@end


/** 矢量数据集类。
 * 
 * <p> 用于对矢量数据集进行描述，并对之进行相应的管理和操作。对矢量数据集的操作主要包括数据查询、修改、删除、建立索引等。
 *  <p> 用户在对矢量数据集进行操作之前，需要先打开该数据集，即调用打开数据集的方法—— [Dataset  open]
 * 方法。
 */
@interface DatasetVector : Dataset


/**
* @brief 获取矢量数据集中字段的数目。
 * <p> 该方法是线程安全的，线程安全级别为 level2。
 * @return 矢量数据集中字段的数目。
  */
@property (assign,nonatomic,readonly) NSInteger fieldCount; 

/**
* @brief  获取字段信息集合的对象。即数据集属性表中所有字段的信息。
 * <p>该方法是线程安全的，线程安全级别为 level2。</p> 
 * @return 字段信息集合的对象。
 */
@property (strong,nonatomic,readonly) FieldInfos* fieldInfos;

/**
 * @brief 获取子数据集。
 * @return 子数据集（若没有返回nil）。
 */
@property (strong,nonatomic,readonly)DatasetVector *childDataset;


/**
* @brief 通过设置查询条件对矢量数据集进行查询，该方法默认查询空间信息与属性信息。
 * <p> 该方法是线程安全的，线程安全级别为 level2。</p>
* @param queryParamter 定义的查询条件。
* @return 查询的记录集。
 */
-(Recordset*) query:(QueryParameter*) queryParamter;

/**
     *  @brief 用于查询数据集中落在指定空间对象的缓冲区内的记录。
     * @param geometry 用于查询的空间对象。
     * @param bufferDistance 缓冲区的半径。
     * @param type 指定的游标类型，以便用户控制查询出来的记录集的属性。当游标类型为动态时，记录集可以被修改，当游标类型为静态时，记录集为只读属性。
     * @return 查询的记录集。
     */  
- (Recordset *)queryWithGeometry:(Geometry *)geometry BufferDistance:(double)bufferDistance Type:(CursorType)type;

/**
     *@brief 用于查询数据集中落在指定空间对象的缓冲区内，并且满足一定条件的记录。
     * @param geometry 用于查询的空间对象。
     * @param bufferDistance 缓冲区的半径。
     * @param filter 查询条件，通常是一个 SQL 语句。
     * @param type 指定的游标类型，以便用户控制查询出来的记录集的属性。当游标类型为动态时，记录集可以被修改，当游标类型为静态时，记录集为只读。
     * @return 查询的记录集。
     */
- (Recordset *)queryWithGeometry:(Geometry *)geometry BufferDistance:(double)bufferDistance Filter:(NSString *)filter Type:(CursorType)type;

/**
     * @brief 根据 ID 进行查询。
     * @param idArray 数组。
     * @param type 指定的游标类型，以便用户控制查询出来的记录集的属性。当游标类型为动态时，记录集可以被修改，当游标类型为静态时，记录集为只读。
     * @return 查询的记录集。
     */
- (Recordset *)queryWithID:(NSArray *)idArray Type:(CursorType)type;

/**
     * @brief 用于查询落在已知空间范围内的记录。
     * @param bounds 已知的空间范围。
     * @param type 指定的游标类型，以便用户控制查询出来的记录集的属性。当游标类型为动态时，记录集可以被修改，当游标类型为静态时，记录集为只读。
     * @return 查询的记录集。
     */
- (Recordset *)queryWithBounds:(Rectangle2D *)bounds Type:(CursorType)type;

/**
     * @brief 用于查询落在已知空间范围内，并且满足一定条件的记录。
     * @param bounds 已知的空间范围。
     * @param filter 查询过滤条件，相当于 SQL 语句中的 Where 子句部分。
     * @param type 指定的游标类型，以便用户控制查询出来的记录集的属性。当游标类型为动态时，记录集可以被修改，当游标类型为静态时，记录集为只读。
     * @return 查询的记录集。
     */
- (Recordset *)queryWithBounds:(Rectangle2D *)bounds Filter:(NSString *)filter Type:(CursorType)type;

/**
     * @brief  利用查询条件查询数据。该方法默认查询空间数据与属性数据。
     * <p>对于 UDB 引擎，当用户传入字符串型时间字段并用此时间值构造查询条件时，需遵循以下规则：将时间值格式化到 ”to_data()” 字符串的括号中，例如，时间值 "2008-5-12 14:28:00"，写为 "to_date(2008-5-12 14:28:00)"，注意括号中时间值无需引号。</p>
     * @param filter 查询条件，相当于 SQL 语句中的 Where 子句。
     * @param type 指定的游标类型，以便用户控制查询出来的记录集的属性。当游标类型为动态时，记录集可以被修改，当游标类型为静态时，记录集为只读属性。
     * @return 查询得到的记录集。
     */
- (Recordset *)queryWithFilter:(NSString *)filter Type:(CursorType)type;

/**
 * @brief  根据给定的参数来返回空的记录集或者返回包括所有记录的记录集对象。
 * @param isEmptyRecordset 给定的判断是否返回空的记录集参数。为 true 时返回空记录集。为 false 时返回包含所有记录的记录集合对象。
 * @param cursorType 指定的游标类型，以便用户控制查询出来的记录集的属性。当游标类型为动态时，记录集可以被修改，当游标类型为静态时，记录集为只读。
 * @return isEmptyRecordset 参数为 true 时返回空的记录集；false 时返回包含所有记录的记录集。
 */
-(Recordset*) recordset:(BOOL) isEmptyRecordset cursorType:(CursorType) cursorType;

/**
 *@brief   通过字段名称指定字段，对指定的字段按照给定的方式进行统计。
 * <P> 当前版本提供了6种统计方式。统计字段的最大值，最小值，平均值，总和，标准差，以及方差。
* <p>  当前版本支持的统计字段类型为布尔，字节，双精度，单精度，16位整型，32位整型。
* @param fieldName   统计使用的字段或字段运算表达式，如 SmID/100 等。
* @param mode  统计方式。
* @return 统计结果。
*/
-(double) statisticWithName:(NSString*) fieldName mode:(StatisticMode) mode;

/**
* 对指定的字段按照给定的方式进行统计。
 * <P> 当前版本提供了6种统计方式。统计字段的最大值，最小值，平均值，总和，标准差，以及方差。
 * <p> 当前版本支持的统计字段类型为布尔，字节，双精度，单精度，16位整型，32位整型。
 * @param fieldIndex  要统计的字段索引值。
* @param mode 统计方式。
 * @return 统计结果。
*/
-(double) statisticWithIndex:(NSInteger) fieldIndex mode:(StatisticMode) mode;

/**
 * @brief 用于将记录集 <Recordset> 追加到矢量数据集 <DatasetVector> 中。
 * <P>追加时，记录集与矢量数据集中字段名相同的字段直接追加，矢量数据集中没有而记录集中有的字段将跳过不处理。</p>
 * <p>执行完追加后 recordset 会指向最后一条记录的后面，即 isEOF 方法为 true。
 * @param recordset 要追加的记录集对象。
 * @return 一个布尔值，指示记录集是否追加成功，追加成功返回true,否则返回false。
 */
-(BOOL) append:(Recordset*)recordset;

/**
* @brief 用于将记录集 <Recordset> 按图幅名字追加到矢量数据集 <DatasetVector>  中，要求该矢量数据集的空间索引为图库索引，追加后记录集中的所有记录将作为图库索引的一幅。
* <p>追加时，记录集与矢量数据集中字段名相同的字段直接追加，矢量数据集中没有而记录集中有的字段将跳过不处理。该方法一般用于标准图幅数据入库过程。</p>
* <p>执行完追加后 recordset 会指向最后一条记录的后面，即 isEOF 方法为 true。</p>
* @param recordset 要追加的记录集对象。
* @param strTitle 新增的图幅名称标记。
* @return 一个布尔值，指示记录集是否追加成功，追加成功返回true,否则返回false。
*/
-(BOOL) append:(Recordset*)recordset titleName:(NSString*) strTitle;

/**
	 * 从GeoJSON字符串中获取几何对象，并将其存入数据集中
	 * <p>仅支持点、线、面数据集，获取点、线、面对象
	 * @param geoJSON     GeoJSON格式的字符串
	 * @return            获取成功，返回true;否则，返回false
	 */
-(BOOL)fromGeoJSON:(NSString*)geoJSON;

-(BOOL)isAvailableFieldName:(NSString*)fieldName;
/**
	 * 将数据集中指定起止SmID的对象，转换成GeoJSON格式的字符串
	 * <p>仅支持点、线、面数据集，转换点、线、面对象.hasAtrributte为true时，结果中包含属性值;hasAtrribute为false时，只有几何对象。
	 * @param hasAttributte     是否包含属性值
	 * @param startID           起始SmID
	 * @param endID             结束SmID
	 * @return                  返回GeoJSON格式的字符串，没有转换成功，返回null;
	 */
-(NSString*)toGeoJSON:(BOOL)hasAttributte startID:(int)startID endID:(int)endID;

//从文件读取数据集，file 需要打开后传入
-(int)fromGeoJSONFile:(FILE*)file;

//将数据集写入文件，file 需要打开后传入
-(int)toGeoJSONFile:(FILE*)file;

//! \brief 建立空间索引
//! \remarks 此方法只能用来建立四叉树索引和R树索引,图幅索引见其他的函数,如果是IDXNone
//!          那么默认重建四叉树索引和R树索引
-(BOOL)buildSpatialIndex:(SpatialIndexInfo*)spatial;

-(BOOL)buildSpatialIndexWithType:(SpatialIndexType)spatialIndexType;

//! \brief 清除空间索引,为没有索引的状态
-(BOOL)dropSpatialIndex;

//! \brief 根据当前索引状态重建索引
-(BOOL)reBuildSpatialIndex;

//! \brief 脏数据的空间索引更新
-(BOOL)updateSpatialIndex;

//! \brief 是否需要重建空间索引
//! \remarks 规定:如果没有索引返回FALSE,有索引看索引的情况
-(BOOL)isSpatialIndexDirty;

-(BOOL)isSpatialIndexTypeSupported:(SpatialIndexType) spatialIndexType;
-(SpatialIndexType)getSpatialIndexType;
-(Rectangle2D*)computeBounds;


/**
	*  将点数据集中的所有点转换成线对象,仅支持点数据集
	*  <p>若不是点数据集，会抛出异常。若点数据集中少于两个点，则返回null</p>
	*  @return GeoLine 转换成功，返回转换后的线对象；否则返回null
	*/
-(GeoLine *)convertToLine;
/**
	*  将点数据集中的有相同字段值的点转换成线对象,仅支持点数据集
	*  <p>若不是点数据集，会抛出异常。若点数据集中不存在指定的字段或没有包含该字段值的点，以及匹配结果少于两个点，则返回null</p>
	*  @param fieldName   字段名
	*  @param fieldValue  字段值
	*  @return GeoLine    转换成功，返回转换后的线对象；否则返回null
	*/
-(GeoLine *)convertToLineWithFieldName:(NSString *) fieldName fieldValue:(NSString *) fieldValue;
/**
     *
     *  @brief 通过ID数组删除数据集中的记录
     *  @param idArray int型数组idArray
     *  @return YES代表删除成功，NO则失败
     */
-(BOOL) deleteRecords:(NSArray *) idArray;
/**
	* 空间查询，查询指定空间范围内符合字段条件的记录
	* @param attributeFilter  查询的条件，比如说 Kind=2008
	* @param geoRegion        查询的区域
	* @param count            返回的查询结果个数，默认10个，超过100按100算
 */
-(void) queryByFilter:(NSString *) attributeFilter geoRegion:(Geometry *) geoRegion count:(NSInteger)count;
/**
	* 属性查询，查询指定字段之中包含关键字的记录
	* @param fieldName    查询的字段名，如Name, Name_PY, Name_PYSZM,即名称字段，名称拼音字段，名称拼音首字母字段
	* @param keywords     对查询字段做查询的关键字
	* @param geoRegion    可以指定范围，如果为NULL，则表示全范围查询
	* @param count       返回的查询结果个数，默认10个，超过100按100算
	*/
-(void) queryByKeyword:(NSString *) fieldName keywords:(NSString *) keywords geoRegion:(Geometry *) geoRegion count:(NSInteger) count;

@property(nonatomic)id<QueryDelegate> delegate;
@end
