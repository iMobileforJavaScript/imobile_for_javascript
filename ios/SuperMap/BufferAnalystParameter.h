//
//  BufferAnalystParameter.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "BufferEndType.h"
#import "BufferRadiusUnit.h"
/** 缓冲区分析参数类，用于为缓冲区分析提供必要的参数信息。
 * 
 * 注意：
 *  1. 对线数据进行缓冲区分析时，可以设置缓冲区端点类型为平头或圆头，只有设置端点类型为平头时，才能生成左右半径不等或者只有左缓冲或者右缓冲的缓冲区。
 * 2. 对于点、面数据，则只能生成圆头缓冲区，缓冲区半径通过 setLeftDistance}法来设置。
 * 3. 对面数据对象设置负缓冲半径（即生成紧缩缓冲时），如果设置的负缓冲半径绝对值大于面数据对象的某个内接圆半径，由于生成的缓冲区没有实际意义，容易导致缓冲区生成失败或者缓冲区生成结果难于理解，因此不建议用户这样设置使用。
 */
@interface BufferAnalystParameter : NSObject{
@private
    
    BufferEndType _bufferEndType;      
    
    int _semicircleLineSegment; 
    
    BufferRadiusUnit _bufferRadiusUnit;   
    
    NSString *_leftDistance; 
    
    NSString *_rightDistance; 
}
/// 获取或设置缓冲区端点类型。用以区分线对象缓冲区分析时的端点是圆头缓冲还是平头缓冲。对于点或面对象，只支持圆头缓冲。
@property(nonatomic) BufferEndType bufferEndType; 
///  获取或设置半圆弧线段个数，即用多少个线段来模拟一个半圆，必须大于等于4。
@property(nonatomic) int semicircleLineSegment; 
///  获取或设置缓冲区分析半径单位。
@property(nonatomic) BufferRadiusUnit bufferRadiusUnit; 
/** 获取或设置左缓冲区的距离。
*  
*    <p>该参数支持数值型和字符串两种输入：</p>
*  1. 该参数为数值型时：
* 对于点、面数据，代表缓冲区的距离；对于线数据，代表左缓冲距离。
* 对于点、线数据，不支持负半径，面数据支持负半径。
* 2. 该参数为字符串时：
* 注意，这种情况，只对数据集和记录集进行缓冲分析时有效，且需指定除系统字段以外的合法字段。
* 对于点、面数据集，代表缓冲区距离的字段或字段表达式；对于线数据集，代表左缓冲距离的字段或字段表达式。
* 对于点、面记录集，代表缓冲区距离的字段；对于线记录集，代表左缓冲距离的字段。
*/ 
@property(nonatomic) NSString *leftDistance;
/** 获取或设置右缓冲区的距离。
 *
 *    <p>该参数只支持对线数据进行缓冲区分析时设置，对点或面数据集无效，支持数值型和字符串两种输入。</p>
 *  1. 该参数为数值型时，代表对线数据进行缓冲区分析时的右距离，不支持负半径。
 * 2. 该参数为字符串时，只对线数据集或线记录集有效，且需指定除系统字段之外的合法字段。
 * 对于线数据集，代表右缓冲距离的字段或字段表达式。
 * 对于线记录集，代表右缓冲距离的字段。
 */
@property(nonatomic) NSString *rightDistance;
@end
