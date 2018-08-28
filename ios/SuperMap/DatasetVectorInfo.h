//
//  DatasetVectorInfo.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

#import "DatasetType.h"
#import "EncodeType.h"

@class DatasetVector;

/** 矢量数据集信息类。
 *  
 * <p>包括了矢量数据集的信息，如矢量数据集的名称，数据集的类型，编码方式，是否选用文件缓存等。文件缓存只针对图幅索引而言。</p>
 */
@interface DatasetVectorInfo : NSObject

/**
     * @brief  获取或设置矢量数据集类型。
     * <p> 在 SuperMap 中有十八种类型的数据集，但目前版本支持的矢量数据集主要有点数据集，线数据集，面数据集，文本数据集，纯属性数据集，影像数据集。数据集类型详细信息参见  <DatasetType>  类。
     * @return 矢量数据集类型。
     */
@property (assign,nonatomic) DatasetType datasetType;

/**
     * @brief 获取或设置数据集的压缩编码方式。
    * <p>  对矢量数据集，支持四种压缩编码方式，即单字节，双字节，三字节和四字节编码方式；对栅格数据集，可以采用三种压缩编码方式，即DCT，SGL和LZW。压缩编码方式详见 EncodeType  类型。
     * <p><b> 注意：</b>
     * 1. 对于某些编码方式，系统有可能会将其改变为更适合该数据集存储时的编码方式；
     *  2. 对于新建的点数据集和纯属性数据集只支持不使用编码的方式，即只支持 EncodeType.None。
     * @return 数据集的压缩编码方式。
     *  <p> 请参见 <EncodeType>
     */
@property (assign,nonatomic) EncodeType encodeType;

 /**
     * @brief 获取或设置矢量数据集的名称。
     *<p> 注意： 数据集的名称限制：数据集名称的长度限制为30个字符（也就是可以为30个英文字母或者15个汉字），组成数据集名称的字符可以为字母、汉字、数字和下划线，数据集名称不可以用数字和下划线开头，如果用字母开头，数据集名称不可以和数据库的保留关键字冲突，数据库保留关键字见保留关键字表。
     *<p> 默认值为“UntitleedDatasetVector”。
     * @return 矢量数据集的名称。
     */
@property (strong,nonatomic) NSString* name;

/**
     * @brief 构造一个新的 DatasetVectorInfo 对象。
     */
-(id) init;

/**
     * @brief 根据指定的参数来构造一个 DatasetVectorInfo 的新对象。
     * @param name 数据集的名称。
     * @param type 数据集的类型。
     */
-(id) initWithName:(NSString*) name datasetType:(DatasetType) type;

/**
     * @brief 根据给定的 DatasetVectorInfo 对象构造一个与其完全相同的新对象。
     * @param datasetVectorInfo 指定的 DatasetVectorInfo 对象。
     */
-(id) init:(DatasetVectorInfo*) datasetVectorInfo;

/**
     *@brief 根据指定的参数来构造一个 DatasetVectorInfo 的新对象。
     * @param name 指定的名称。
     * @param datasetVector 指定的模板数据集。
     */
-(id) initWithName:(NSString*) name datasetVector:(DatasetVector*) datasetVector;

/**
     * @brief 释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     */
-(void) dispose;

/**
 *
 * @brief输出矢量数据集的信息
 * 其格式为{Name="",Type="",EncodeType=""}
 */
-(NSString *)toString;

@end
