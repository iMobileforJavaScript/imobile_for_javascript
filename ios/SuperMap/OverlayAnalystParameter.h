//
//  OverlayAnalystParameter.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/** 叠加分析参数类。
 <p>该类主要提供进行叠加分析时，输出结果数据集的字段选择。在矢量叠加分析中，至少涉及到三个数据集，其中一个数据集的类型可以是点、线、面等，被称作输入数据集（在SuperMap GIS 中称作第一数据集）；另一个数据集是面数据集被称作叠加数据集（在SuperMap GIS 中称作第二数据集）；还有一个数据集就是叠加结果数据集 ，包含叠加后数据的几何信息和属性信息。叠加结果数据集中的属性信息来自于第一数据集和第二数据集的属性表，在进行叠加分析的时候，用户可以根据自己的需要在这两个数据集的属性表中选择需要保留的属性字段。</p>
*/
@interface OverlayAnalystParameter : NSObject{
    @private
        NSMutableArray *m_sourceRetainedFields;
        NSMutableArray *m_operationRetainedFields;
        double m_tolerance;
}

/**@brief 根据给定的叠加分析参数对象构造一个与其完全相同的参数对象。
 @param  param 指定的叠加分析参数对象。
 */
-(id)initWithAnalystParameter:(OverlayAnalystParameter *)param;

/**@brief 返回进行叠加分析的第一数据集或记录集中需要保留的字段名称集合。
 <p>默认值为空的 String[] 对象。</p>
 @return  进行叠加分析的第一数据集或记录集中需要保留的字段名称集合。
 */
-(NSMutableArray *)getSourceRetainedFields;

/**@brief 设置进行叠加分析的第一数据集或记录集中需要保留的字段名称集合。
 <p>注意：如果是裁剪或擦除操作，第一数据集或记录集的非系统字段将全部保留。</p>
 @param  value 进行叠加分析的第一数据集或记录集中需要保留的字段名称集合。
 */
-(void)setSourceRetainedFields:(NSMutableArray *)value;

/**@brief 返回进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
 <p>默认值为空的 String[] 对象。</p>
 @return  进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
 */
-(NSMutableArray *)getOperationRetainedFields;

/**@brief 设置进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
 @param  value 进行叠加分析的第二数据集或记录集中需要保留的字段名称集合。
 */
-(void)setOperationRetainedFields:(NSMutableArray *)value;

/**@brief 返回叠加分析的容限值。
 <p>默认值为0。</p>
 @return  叠加分析的容限值。
 */
-(double)getTolerance;

/**@brief 设置叠加分析的容限值。
 @param  value 叠加分析的容限值。
 */
-(void)setTolerance:(double)value;
@end
