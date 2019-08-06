//
//  Datasets.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Datasource;

@class Dataset,DatasetVector,DatasetVectorInfo;

/** 数据集集合类。
 * 
 * <p> 提供对数据集的管理功能，如创建、删除、重命名等操作。一个数据源中所有的数据集对象都由一个数据集集合对象来管理。
 *<p> 数据集集合可以包含一种或多种类型的数据集，可以是矢量数据集，栅格数据集或影像数据集。 目前版本支持的数据集类型有：纯属性数据集（tabulardataset），点数据集（point dataset），线数据集（line dataset），面数据集（region
 *dataset），文本数据集（text dataset）和影像数据集（image dataset）。 
 * <p>数据集对象所属的数据源的 [ Datasource  isReadOnly() ]返回值为 true时，则不允许创建和删除数据集。
 */
@interface Datasets : NSObject{
@private
    NSMutableArray* _datasets;
    Datasource* _datasource;
}

/**
*  @brief 根据指定的矢量数据集信息来创建矢量数据集。
* <p>该方法是线程安全的，线程安全级别为 level2。
* @param datasetInfo 矢量数据集信息。          
* @return 新创建的矢量数据集对象。
 */
-(DatasetVector*) create:(DatasetVectorInfo*) datasetInfo;

/**
*  @brief 返回指定序号的数据集。
* @param index 指定数据集的序号。     
 * @return 指定序号的数据集。
 */
-(Dataset*) get:(NSInteger) index;

/**
 *  @brief 返回指定名称的数据集。
  * @param name 指定的数据集的名称。
  * @return 指定名称的数据集。
*/
-(Dataset*) getWithName:(NSString*) name;

/**
*  @brief 返回数据集集合中数据集的个数。
* @return 数据集集合中数据集的个数。
 */
-(NSInteger) count;

/**
 *  @brief 检查当前数据源中是否包含指定名称的数据集。
* @param name 数据集名称。
 * @return 如果该数据源中包含指定名称的数据集，返回值为 true，如果不包含，返回值为 false。
*/
-(BOOL) contain:(NSString*) name;

/**
 *  @brief 返回给定数据集名称对应的数据集在数据集集合中所处的索引值。
 * @param name    数据集名称
* @return 表示与给定数据集名称相同的数据集所处的位置。
*/
-(NSInteger) indexOf:(NSString*) name;

/**
*  @brief 用于删除指定序号的数据集。
* <p> 该方法是线程安全的，线程安全级别为 level2。
  *  @param index 指定的数据集的序号。
  * @return 如果删除成功，返回值为 true，否则为 true。
*/
-(BOOL) delete:(NSInteger) index;

/**
 *  @brief 用于删除指定名称的数据集。
 * <p> 该方法是线程安全的，线程安全级别为 level2。
 * @param name  指定的数据集的名称。
* @return 如果删除成功，返回值为 true，否则为 false。
 */
-(BOOL) deleteName:(NSString*) name;

/**
*  @brief 返回一个数据源中未被使用的数据集的名称。
* <p> 创建数据集时，数据集名称在同一个数据源文件中必须唯一，否则不能创建新的数据集，可以使用该方法返回一个合法的名称，但是该方法得到的名称不能保证一定符合您的最佳要求。
* <p>*数据集的名称限制：数据集名称的长度限制为30个字符（也就是可以为30个英文字母或者15个汉字），组成数据集名称的字符可以为字母、汉字、数字和下划线，数据集名称不可以用数字和下划线开头，数据集名称不可以和数据库的保留关键字冲突。
 * @param name 数据集名称。
* @return 一个字符串，该字符串可以用作数据集名称。
*/
-(NSString*) availableDatasetName:(NSString*) name;

/**
 *  @brief 判断用户传进来的数据集的名称是否合法。创建数据集时应检查其名称的合法性。
 * <p> 数据集的名称限制：数据集名称的长度限制为30个字符（也就是可以为30个英文字母或者15个汉字），组成数据集名称的字符可以为字母、汉字、数字和下划线
* 数据集名称不可以用数字和下划线开头，数据集名称不可以和数据库的保留关键字冲突。
 * @param name 待检查的数据集名称。
* @return 如果数据集名称合法，返回 true；否则，返回 false。
*/
-(BOOL) isAvailableDatasetName:(NSString*)name;

@end
