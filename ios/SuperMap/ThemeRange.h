//
//  ThemeRange.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Theme.h"
#import "RangeMode.h"
#import "ColorGradientType.h"
@class ThemeRangeItem;
@class GeoStyle;
@class DatasetVector;
@class JoinItems;

/** 分段专题图类。
*  
* <p>按照提供的分段方法对字段的属性值进行分段，并根据每个属性值所在的分段范围赋予相应对象的显示风格。</p>
* <p>注意：</p>
* <p>制作分段专题图，如果首尾区间没有设置风格，且没有设置默认风格，那么无论是采用 addToHead  还是 ddToTail   方法，首尾区间默认采用用户所添加的第一个分段的风格，比如：总共分5段，addToTail 方法依次添加 [0，1）、[1，2）、[2，4）三段，那么首区间(负无穷，0)，尾区间[4，正无穷),采用[0,1)的风格。</p>
*/
@interface ThemeRange : Theme{
@private
    RangeMode _mRangeMode;
    NSMutableArray * _mRangeItems;
}
/**
* @brief 获取或设置当前的分段模式。
* @return 当前的分段模式。
*/
@property(nonatomic)RangeMode mRangeMode;

/**
* @brief 设置分段字段表达式。
* <p>通过对比某要素分段字段表达式的值与（按照一定的分段模式确定的）各分段范围的分段值，来确定该要素所在的范围段，从而对落在不同分段内的要素设置为不同的风格。</p>
* @param var 指定分段字段表达式。
*/
-(void)setRangeExpression:(NSString *)var;

/**
* @brief 返回分段字段表达式。
* <p>通过对比某要素分段字段表达式的值与（按照一定的分段模式确定的）各分段范围的分段值，来确定该要素所在的范围段，从而对落在不同分段内的要素设置为不同的风格。</p>
* <p>默认值为一个空字符串。</p>
* @return 分段字段表达式。
*/
-(NSString *)getRangeExpression;

/**
* @brief 返回分段专题图中分段的个数。
* <p>默认值为0。</p>
* <p>分段专题图中分段的个数。</p>
*/
-(int)getCount;

/**
* @brief 把一个分段专题图子项添加到分段列表的开头。
* @param item 需要添加的分段专题图子项。
* @return 一个布尔值，分段专题图子项添加成功返回true,否则返回false。
*/
-(BOOL)addToHead:(ThemeRangeItem*)item;

/**
* @brief 把一个分段专题图子项添加搭配分段列表的尾部。
* @param item 需要添加的分段专题图子项。
* @return 一个布尔值，分段专题图子项添加成功返回true,否则返回false。
*/
-(BOOL)addToTail:(ThemeRangeItem*)item;

/**
* @brief 把一个分段专题图子项添加到分段列表的开头。
* @param item 需要添加的分段专题图子项。
* @param bNormalize 表示是否规整化，bNormalize 为 true时， item 值不合法，则进行规整，bNormalize 为 fasle时， item 值不合法则抛异常。
* @return 一个布尔值，分段专题图子项添加成功返回true,否则返回false。
*/
-(BOOL)addToHead:(ThemeRangeItem*)item Normalize:(BOOL)bNormalize;

/**
* @brief 把一个分段专题图子项添加到分段列表的尾部。
* @param item 需要添加的分段专题图子项。
* @param bNormalize 表示是否规整化，bNormalize 为 true时， item 值不合法，则进行规整，bNormalize 为 fasle时， item 值不合法则抛异常。
* @return 一个布尔值，分段专题图子项添加成功返回true,否则返回false。
*/
-(BOOL)addToTail:(ThemeRangeItem*)item Normalize:(BOOL)bNormalize;

/**
* @brief 返回指定序号的分段专题图中分段专题图子项。有关分段专题图子项详细信息，请参见 {@link ThemeRangeItem ThemeRangeItem} 类。
* @param index 指定的分段专题图序号。
* @return 指定序号的分段专题图中分段专题图子项。
*/
-(ThemeRangeItem*)getItem:(int)index;

/**
* @brief 根据给定的拆分分段值将一个给定序号的分段专题图子项拆分成两个具有各自风格和名称的分段专题图子项。
* <p>注：splitValue必须在拆分的范围之内，即大于分段专题图子项的起始值（Start）且小于分段专题图子项的终止项（End）,如果不满足以上条件，则抛出异常。</p>
* @param index 指定的分段专题图子项的序号。
* @param splitValue 指定的拆分分段值。
* @param style1 被拆分的两个分段专题图子项中的一个分段专题图子项的风格。
* @param caption1 被拆分的两个分段专题图子项中的一个分段专题图子项的名称。
* @param style2 被拆分的两个分段专题图子项中的另一个分段专题图子项的风格。
* @param caption2 被拆分的两个分段专题图子项中的另一个分段专题图子项的名称。 
* @return 一个布尔值，如果拆分成功返回true,否则返回false。
*/
-(BOOL)splitIndex:(int)index SplitValue:(double)splitValue Style1:(GeoStyle*)style1 Caption1:(NSString*)caption1 Style2:(GeoStyle*)style2 Caption2:(NSString*)caption2;

/**
* @brief 合并一个从指定序号起始的给定个数的分段专题图子项，并赋给合并后分段专题图子项显示风格和名称。执行该方法后，被合并的对象将被释放，不再可用。
* @param index 指定的分段专题图子项的序号，并以此序号为起始。
* @param count 要合并的分段专题图子项个数，即从指定的序号开始计算。
* @param style 合并后的分段专题图子项的风格。
* @param caption 合并后的分段专题图子项的名称。
* @return 一个布尔值，如果合并成功返回true,否则返回false。
*/
-(BOOL)merge:(int)index Count:(int)count GeoStyle:(GeoStyle*)style Caption:(NSString*)caption;

/**
* @brief 根据给定的矢量数据集、分段字段表达式、分段模式和相应的分段参数生成默认的分段专题图。
* @param dataset 矢量数据集。
* @param rangeExpression 分段字段表达式。
* @param rangeMode 分段模式。包括等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法，以及自定义距离法。
* @param value 分段参数。当分段模式为等距离分段法，平方根分段，对数分段法，等计数分段法其中一种模式时，该参数为分段个数；当分段模式为标准差分段法的时候，该参数不起作用；当分段模式为自定义距离时，该参数表示自定义距离。
* @return 根据参数构造得到一个新的  <ThemeRange>  的对象实例。
*/
+(ThemeRange*)makeDefaultDataSet:(DatasetVector*)dataset RangeExpression:(NSString*)rangeExpression RangeMode:(RangeMode)rangeMode RangeParameter:(double)value;

/**
* @brief 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数和颜色渐变模式生成默认的分段专题图。
* @param dataset 矢量数据集。
* @param rangeExpression 分段字段表达式。
* @param rangeMode 分段模式。包括等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法，以及自定义距离法。
* @param value 分段参数。当分段模式为等距离分段法，平方根分段，对数分段法，等计数分段法其中一种模式时，该参数为分段个数；当分段模式为标准差分段法的时候，该参数不起作用；当分段模式为自定义距离时，该参数表示自定义距离。
* @param colorGradientType 颜色渐变模式。
* @return 根据参数构造得到一个新的  <ThemeRange> 的对象实例。
*/
+(ThemeRange*)makeDefaultDataSet:(DatasetVector*)dataset RangeExpression:(NSString*)rangeExpression RangeMode:(RangeMode)rangeMode RangeParameter:(double)value ColorGradientType:(ColorGradientType)colorGradientType;

/**
* @brief 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数、颜色渐变填充模式和外部连接表项生成默认的分段专题图。
* @param dataset 矢量数据集。
* @param rangeExpression 分段字段表达式。
* @param rangeMode 分段模式。包括等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法，以及自定义距离法。
* @param value 分段参数。当分段模式为等距离分段法，平方根分段，对数分段法，等计数分段法其中一种模式时，该参数为分段个数；当分段模式为标准差分段法的时候，该参数不起作用；当分段模式为自定义距离时，该参数表示自定义距离。
* @param colorGradientType 颜色渐变模式。
* @param joinItems 外部表连接项。
* @return 根据参数构造得到一个新的 <ThemeRange>  的对象实例。
*/
+(ThemeRange*)makeDefaultDataSet:(DatasetVector*)dataset RangeExpression:(NSString*)rangeExpression RangeMode:(RangeMode)rangeMode RangeParameter:(double)value ColorGradientType:(ColorGradientType)colorGradientType JoinItems:(JoinItems*)joinItems;

/**
* @brief 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数、颜色渐变填充模式、外部连接表项和分段值的精度生成默认的分段专题图。
* @param dataset 矢量数据集。
* @param rangeExpression 分段字段表达式。
* @param rangeMode 分段模式。包括等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法，以及自定义距离法。
* @param value 分段参数。当分段模式为等距离分段法，平方根分段，对数分段法，等计数分段法其中一种模式时，该参数为分段个数；当分段模式为标准差分段法的时候，该参数不起作用；当分段模式为自定义距离时，该参数表示自定义距离。
* @param colorGradientType 颜色渐变模式。
* @param joinItems 外部表连接项。
* @param precision 分段值的精度。如，计算得到的分段值为13.02145，而分段精度为0.001，则分段值取13.021。
* @return 根据参数构造得到一个新的 <ThemeRange>  的对象实例。
*/
+(ThemeRange*)makeDefaultDataSet:(DatasetVector*)dataset RangeExpression:(NSString*)rangeExpression RangeMode:(RangeMode)rangeMode RangeParameter:(double)value ColorGradientType:(ColorGradientType)colorGradientType JoinItems:(JoinItems*)joinItems Precision:(double)precision;

/**
* @brief 获取范围分段专题图的舍入精度。
* @return 舍入精度。
*/
-(double)getPrecision;

/**
* @brief 设置范围分段专题图的舍入精度。
* @param value 舍入精度。
*/
-(void)setPrecision:(double)value;

/**
* @brief 返回分段专题图中指定分段字段值在当前分段序列中的序号。
* @param value 给定的分段字段值。
* @return 分段字段值在分段序列中的序号。如果该值不存在，就返回-1。
*/
-(int)indexOf:(double)value;

/**
* @brief 设置X偏移量。
* @param value X偏移量。
*/
-(void)setOffsetX:(NSString*)value;

/**
* @brief 设置Y偏移量。
* @param value Y偏移量。
*/
-(void)setOffsetY:(NSString*)value;

/**
* @brief 返回X偏移量
* @return X偏移量。
*/
-(NSString*)getOffsetX;

/**
* @brief 返回Y偏移量。
* @return Y偏移量。
*/
-(NSString*)getOffsetY;

/**
* @brief 获取自定义段长。
* @return 自定义段长。
*/
-(double)getCustomInterVal;

/**
* @brief 设置是否固定偏移量。
* @param bFixed 参数为True表示固定偏移量,否则表示不固定偏移量。
*/
-(void)setOffsetFixed:(BOOL)bFixed;

/**
* @brief 获取分段专题图子项列表。
* @return 分段专题图子项列表。
*/
-(NSMutableArray *)getRangeItemList;

/**
* @brief 返回是否固定偏移量。
* @return 一个布尔值，固定偏移量返回True，否则返回false。
*/
-(BOOL)isOffsetFixed;

/**
* @brief 返回分段专题图格式化字符串。
* @return 分段专题图格式化字符串。
*/
-(NSString *)toString;

/**
* @brief 对分段专题图中分段的风格进行反序显示。
* <p>比如，专题图有三个分段，分别为 item1，item2，item3，调用反序显示后，item3 的风格与 item1 会调换，item2 的显示风格不变。</p>
*/
-(void)reverseStyle;

/**
* @brief 删除分段专题图的所有分段子项。
* <p>执行该方法后，所有的分段专题图子项都被释放，不再可用。</p>
*/
-(void)clear;

/**
* @brief 释放对象所占用的资源。调用该方法之后，此对象不再可用。
*/
-(void)dispose;
@end
