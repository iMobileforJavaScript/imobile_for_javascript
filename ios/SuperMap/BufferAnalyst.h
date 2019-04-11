//
//  BufferAnalyst.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "BufferRadiusUnit.h"

@class DatasetVector;
@class Recordset;
@class BufferAnalystParameter;
/**  缓冲区分析类。
 *
 * 该类用于为点、线、面数据集（或记录集）创建缓冲区，包括单边缓冲区、多重缓冲区和线单边多重缓冲区。
 * 缓冲区分析是围绕空间对象，使用一个或多个与这些对象的距离值（称为缓冲区半径）作为半径，生成一个或多个区域的过程。缓冲区也可以理解为空间对象的一种影响或服务范围。
 * 缓冲区分析的基本作用对象是点、线、面。Super支持对二维点、线、面数据集（或记录集）和网络数据集进行缓冲区分析。
 * 缓冲区分析在 GIS 空间分析中经常用到，且往往结合叠加分析来共同解决问题。缓冲区分析在农业、城市规划、生态保护、防洪抗灾、军事、地质、环境等诸多领域都有应用。
 * 例如扩建道路时，可根据道路扩宽宽度对道路创建缓冲区，然后将缓冲区图层与建筑图层叠加，通过叠加分析查找落入缓冲区而需要被拆除的建筑；又如，为了保护环境和耕地，可对湿地、森林、草地和耕地进行缓冲区分析，在缓冲区内不允许进行工业建设。
 * <p><b>说明：</b></p>
 * <p>对于面对象，在做缓冲区分析前最好先经过拓扑检查，排除面内橡胶的情况，所谓面内相交，指的是面对象自身相交。</p>
 * <p>对“负半径”的说明：</p>
 * <p>1. 如果缓冲区半径为数值型，则仅面数据支持负半径；</p>
 * <p>2  如果缓冲区半径为字段或字段表达式，如果字段或字段表达式的值为负值，对于点、线数据取其绝对值；对于面数据，若合并缓冲区，则取其绝对值，若不合并，则按照负半径处理。</p>
 * <p>关于缓冲区的参数设置，请参见<BufferAnalystParameter>
*/
@interface BufferAnalyst : NSObject

/**@brief 创建矢量数据集缓冲区。
 *@param  sourceDataset 指定的创建缓冲区的源矢量数据集，支持点、线、面数据集。
 *@param  resultDataset 指定的存储缓冲区分析结果的数据集，必须是面数据集。
 *@param  bufferAnalystParameter 指定的缓冲区分析参数对象。
 *@param  isUnion 是否合并缓冲区，即是否将源数据各对象生成的所有缓冲区域进行合并运算后返回。对于面对象而言，要求源数据集中的面对象不相交。
 *@param  isAttributeRetained  是否保留进行缓冲区分析的对象的字段属性。当合并结果面数据集时，该参数无效。即当 isUnion 参数为 false 时有效。
 *@return  一个布尔值，如果创建矢量数据集缓冲区成功返回 true，否则返回 false。
 */
+(BOOL) createBufferSourceVector:(DatasetVector*)sourceDataset ResultVector:(DatasetVector*)resultDataset BufferParam:(BufferAnalystParameter*)bufferAnalystParameter IsUnion:(BOOL)isUnion IsAttributeRetained:(BOOL)isAttributeRetained;

/**@brief 创建矢量记录集缓冲区。
 @param  sourceRecordset  指定的创建缓冲区的源矢量记录集，支持点、线、面记录集。
 @param  resultDataset 指定的存储缓冲区分析结果的数据集，必须是面数据集。
 @param  bufferAnalystParameter 指定的缓冲区分析参数对象。
 @param  isUnion 是否合并缓冲区，即是否将源数据各对象生成的所有缓冲区域进行合并运算后返回。对于面对象而言，要求源数据集中的面对象不相交。
 @param  isAttributeRetained 是否保留进行缓冲区分析的对象的字段属性。当合并结果面数据集时，该参数无效。即当 isUnion 参数为 false 时有效。
 @return  一个布尔值，如果创建矢量记录集缓冲区成功返回 true，否则返回 false。
 */
+(BOOL) createBufferSourceRecordset:(Recordset*)sourceRecordset ResultVector:(DatasetVector*)resultDataset BufferParam:(BufferAnalystParameter*)bufferAnalystParameter IsUnion:(BOOL)isUnion IsAttributeRetained:(BOOL)isAttributeRetained;

/**@brief 创建矢量线数据集单边多重缓冲区。
 *
 * <p>线的单边多重缓冲区，是指在线对象的一侧生成多重缓冲区。左侧是指沿线对象的节点序列方向的左侧，右侧为节点序列方向的右侧。
 @param  sourceDataset 指定的创建多重缓冲区的源矢量数据集，只支持线数据集。
 @param  resultDataset 指定的用于存储缓冲区分析结果的数据集，必须是面数据集。
 @param  arrBufferRadius 指定的多重缓冲区半径列表。单位由 bufferRadiusUnit 参数指定。
 @param  bufferRadiusUnit 指定的缓冲区半径单位。
 @param  semicircleSegment 指定的弧段拟合数。
 @param  isLeft 是否生成左缓冲区。设置为true，在线的左侧生成缓冲区，否则在右侧生成缓冲区。
 @param  isUnion 是否合并缓冲区，即是否将源数据各对象生成的所有缓冲区域进行合并运算后返回。
 @param  isAttributeRetained 是否保留进行缓冲区分析的对象的字段属性。当合并结果面数据集时，该参数无效，即当 isUnion 为 false 时有效。
 @param  isRing 是否生成环状缓冲区。设置为TRUE，则生成多重缓冲区时外圈缓冲区是以环状区域与内圈数据相邻的；设置为false，则外围缓冲区是一个包含了内圈数据的区域。
 @return 一个布尔值，如果创建矢量线数据集单边多重缓冲区成功返回 true，否则返回 false。
 */
+(BOOL) createLineOneSideMultiBufferSourceVector:(DatasetVector*)sourceDataset ResultVector:(DatasetVector*)resultDataset ArrBufferRadius:(NSArray*)arrBufferRadius BufferRadiusUnit:(BufferRadiusUnit)bufferRadiusUnit SemicircleSegment:(int)semicircleSegment IsLeft:(BOOL)isLeft IsUnion:(BOOL)isUnion IsAttributeRetained:(BOOL)isAttributeRetained IsRing:(BOOL)isRing;

/**@brief 创建矢量线记录集单边多重缓冲区。
 @param  sourceRecordset 指定的创建多重缓冲区的源矢量记录集。只支持线记录集。
 @param  resultDataset 指定的用于存储缓冲区分析结果的数据集，必须是面数据集。
 @param  arrBufferRadius 指定的多重缓冲区半径列表。单位由 bufferradiusUnit参数指定。
 @param  bufferRadiusUnit 指定的缓冲区半径单位。
 @param  semicircleSegment 指定的弧段拟合数。
 @param  isLeft 是否生成左缓冲区。设置为true，在线的左侧生成缓冲区，否则在右侧生成缓冲区。
 @param  isUnion 是否合并缓冲区，即是否将源数据各对象生成的所有缓冲区域进行合并运算后返回。
 @param  isAttributeRetained 是否保留进行缓冲区分析的对象的字段属性。当合并结果面数据集时，该参数无效，即当 isUnion 为 false 时有效。
 @param  isRing 是否生成环状缓冲区。设置为 true，则生成多重缓冲区时外圈缓冲区是以环状区域与内圈数据相邻的；设置为 false，则外围缓冲区是一个包含了内圈数据的区域。
 @return 一个布尔值，如果成功返回 true，否则返回 false。
 */
+(BOOL) createLineOneSideMultiBufferSourceRecordset:(Recordset*)sourceRecordset ResultVector:(DatasetVector*)resultDataset ArrBufferRadius:(NSArray*)arrBufferRadius BufferRadiusUnit:(BufferRadiusUnit)bufferRadiusUnit SemicircleSegment:(int)semicircleSegment IsLeft:(BOOL)isLeft IsUnion:(BOOL)isUnion IsAttributeRetained:(BOOL)isAttributeRetained IsRing:(BOOL)isRing;

/**@brief 创建矢量数据集多重缓冲区。
 @param  sourceDataset 指定的创建多重缓冲区的源矢量数据集。支持点、线、面数据集。
 @param  resultDataset 指定的用于存储缓冲区分析结果的数据集。
 @param  arrBufferRadius 指定的多重缓冲区半径列表。
 @param  bufferRadiusUnit 指定的缓冲区半径单位。
 @param  semicircleSegment 指定的弧段拟合数。
 @param  isUnion 是否合并缓冲区，即是否将源数据各对象生成的所有缓冲区域进行合并运算后返回。
 @param  isAttributeRetained 是否保留进行缓冲区分析的对象的字段属性。当合并结果面数据集时，该参数无效，即当 isUnion 为 false 时有效。
 @param  isRing 是否生成环状缓冲区。
 @return  一个布尔值，如果创建矢量数据集多重缓冲区成功返回 true，否则返回 false。
 */
+(BOOL) createMultiBufferSourceVector:(DatasetVector*)sourceDataset ResultVector:(DatasetVector*)resultDataset ArrBufferRadius:(NSArray*)arrBufferRadius BufferRadiusUnit:(BufferRadiusUnit)bufferRadiusUnit SemicircleSegment:(int)semicircleSegment IsUnion:(BOOL)isUnion IsAttributeRetained:(BOOL)isAttributeRetained IsRing:(BOOL)isRing;

/**@brief 创建矢量记录集多重缓冲区。
 @param  sourceRecordset 指定的创建多重缓冲区的源矢量记录集。支持点、线、面记录集。
 @param  resultDataset 指定的用于存储缓冲区分析结果的数据集。
 @param  arrBufferRadius 指定的多重缓冲区半径列表。单位由 bufferRadiusUnit 参数指定。
 @param  bufferRadiusUnit 指定的缓冲区半径单位。
 @param  semicircleSegment 指定的弧段拟合数。
 @param  isUnion 是否合并缓冲区，即是否将源数据各对象生成的所有缓冲区域进行合并运算后返回。
 @param  isAttributeRetained  是否保留进行缓冲区分析的对象的字段属性。当合并结果面数据集时，该参数无效，即当 isUnion 为 false 时有效。
 @param  isRing 是否生成环状缓冲区。设置为 true，则生成多重缓冲区时外圈缓冲区是以环状区域与内圈数据相邻的；设置为false，则外围缓冲区是一个包含了内圈数据的区域。
 @return 一个布尔值，如果创建矢量记录集多重缓冲区成功返回 true，否则返回 false。
 */
+(BOOL) createMultiBufferSourceRecordset:(Recordset*)sourceRecordset ResultVector:(DatasetVector*)resultDataset ArrBufferRadius:(NSArray*)arrBufferRadius BufferRadiusUnit:(BufferRadiusUnit)bufferRadiusUnit SemicircleSegment:(int)semicircleSegment IsUnion:(BOOL)isUnion IsAttributeRetained:(BOOL)isAttributeRetained IsRing:(BOOL)isRing;

@end
