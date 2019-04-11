//
//  FieldInfos.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class DatasetVector;
@class FieldInfo;

/**字段信息集合类。
 * 
 * 该类可以单独创建使用，一个矢量数据集或记录集的所有字段的信息的集合即为一个字段信息集合类的一个实例。该类可以单独创建使用，也可以从矢量数据集或记录集中得到该类的对象。
 */
@interface FieldInfos : NSObject
 /**
     * @brief 构造一个新的 FieldInfos 对象，该对象中的  <FieldInfo> 对象的个数为0。
     */
-(id)init;

/**
     * @brief  根据给定的 FieldInfos 对象构造一个与其完全相同的新对象。
     *
     * @param fieldInfos 指定的 FieldInfos 对象。
     */
-(id)initWithFieldInfos:(FieldInfos*) fieldInfos;

// the array contains several FieldInfos
/**
     * @brief 根据指定的参数来构造一个 FieldInfos 的新对象。
     * @param fieldInfo 指定的  <FieldInfo> 类数组。
     */
-(id)initWithFieldInfo:(NSMutableArray*) fieldInfo;

/**
     * @brief 获取给定的字段信息集集合中元素的个数。
     *
     * @return 给定的字段信息集集合中元素的个数。
     */
@property (assign,nonatomic,readonly) NSInteger count;

 /**
     * @brief 将指定字段信息对象添加到当前字段信息集合对象中。
     *  
     * <p>注意：添加字段时，如果字段的类型是必填字段，必须设置默认值，没有设置默认值时，添加失败。
     * @param fieldInfo 要加入的字段对象。
     * @return fieldInfo 添加到此  <FieldInfos> 对象实例中的序号。
     */
-(int) add:(FieldInfo*) fieldInfo;

/**
     *@brief 返回字段信息集合对象中的指定序号的字段信息对象。
     *
     * @param index 需要返回项的索引值，索引值从0开始。
     * @return 字段信息集集合对象中的指定序号的元素。
     */
-(FieldInfo*) get:(NSInteger) index;

/**
     * @brief 返回字段信息集合对象中的指定名称的字段信息对象。
     *
     * @param fieldName 指定项的名称，即指定的  <FieldInfo> 的名称。
     * @return 字段信息集集合对象中的指定名称的字段信息。
     */
-(FieldInfo*) getName:(NSString*) fieldName;

 /**
     *  @brief 返回指定名称的字段信息对象在当前字段信息集合中的序号。
     *
     * @param fieldName 指定的 fieldInfo 的名称。
     * @return 名称为 fieldName 的  <FieldInfo> 在该 fieldInfos 中的序号。
     */
-(NSInteger) indexOfWithFieldName:(NSString*) fieldName;

/**
     *  @brief 释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     */
-(void) dispose;

/**
 * 用于从字段信息集移除指定的索引处的项
 * @param index int
 * @return boolean
 */
-(BOOL) removeFieldAtIndex:(NSInteger) index;

//从字段信息集中移除Name属性为name的项
-(BOOL) removeFieldName:(NSString *) fieldName;


@end
