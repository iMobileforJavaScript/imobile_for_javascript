//
//  ThemeLabel.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Theme.h"
#import "RangeMode.h"
#import "ThemeLabelItem.h"
#import "AlongLineDirection.h"
#import "TextStyle.h"
#import "DatasetVector.h"
#import "ColorGradientType.h"
#import "GeoStyle.h"
#import "OverLengthLabelMode.h"
#import "LabelBackShape.h"

@class Size2D;
@class LabelMatrix;
@class MixedTextStyle;
@class JoinItems;

/**  标签专题图类。
 *
 * <p>标签专题图的标注可以是数字、字母与文字，例如：河流、湖泊、海洋、山脉、城镇、村庄等地理名称，高程、等值线数值、河流流速、公路段里程、航海线里程等。</p>
 * <P>在标签专题图中，你可以对标签的显示风格和位置进行设置或控制，你可以为所有的标签都设置统一的显示风格和位置选项来显示，也可以通过分段的方式，对单个或每个分段内的标签的风格分别进行设置，另外，单个标签的位置也是可以修改的。</p>
 * <p>注：地图上一般还会出现图例说明，图名，比例尺等等，哪些都是制图元素，不属于标签专题图标注的范畴。</p>
 */
@interface ThemeLabel : Theme{
    
    RangeMode _mRangeMode;
    NSMutableArray * _mLableItems;
    ThemeLabel *_mThemeLabel;
    TextStyle *_mUniformStyle;
    GeoStyle *_mBackStyle;
    GeoStyle *_mLeaderLineStyle;
    MixedTextStyle *_mixedTextStyle;
    LabelMatrix *_mLabelMatrix;
    Size2D *_mSize2D;
    
}

/**
 * @brief 获取或设置统一文本风格。
 * <p>注：当 ThemeLabelItem 的个数大于等于1的时候，设置统一文本风格将不起作用。</p>
 * <p>默认值为 {Alignment=MiddleCenter,BackColor=Color [A=255, R=0, G=0, B=0],BackOpaque=False,Bold=False,FontHeight=4,FontWidth=0,ForeColor=Color [A=255, R=0, G=0, B=255],IsSizeFixed=True,Italic=False,Outline=False,Rotation=0,Shadow=False,Strikeout=False,Underline=False,Weight=0}</p>
 */
@property(nonatomic)TextStyle *mUniformStyle;

/**
 * @brief 获取或设置当前的分段模式。
 */
@property(nonatomic)RangeMode mRangeMode;

/**
 * @brief 获取或设置标签沿线标注方向。
 * <p> 默认值为LEFT_TOP_TO_RIGHT_BOTTOM。</p>
 */
@property(nonatomic,assign)AlongLineDirection alongLineDirection;

/**
 * @brief 拷贝构造函数，根据给定的  <ThemeLabel> 对象构造一个与其完全相同的新对象。
 * @param themeLabel 给定的  <ThemeLabel>  对象。
 */
-(id)initThemeLabel:(ThemeLabel *)themeLabel;
/**
 * @brief 获取标签专题图子项列表。
 * @return 标签专题图子项列表。
 */
-(NSMutableArray *)getLableItemList;
/**
 * @brief 设置标签专题图背景形状。
 * @param value 指定背景形状。
 */
-(void)setBackShape:(LabelBackShape)value;
-(GeoStyle*)getBackStyle;
/**
 * @brief 设置分段字段表达式。其中分段表达式中的值必须为数值型的。
 * <p>用户根据该方法的设置值来比较其从开始到结束的每一个分段值，以确定采用什么风格来显示给定标注字段表达式相应的标注文本。</p>
 * @param var 指定分段字段表达式。
 */
-(void)setRangeExpression:(NSString *)var;

/**
 * @brief 设置标注字段表达式。
 * @param var 指定标注字段表达式。
 */
-(void)setLabelExpression:(NSString*)var;

/**
 * @brief 获取标注字段表达式。
 * @return 标签专题图中的标注字段表达式。
 */
-(NSString*)getLabelExpression;

/**
 * @brief 返回标签专题图中分段的个数。
 * <p>默认值为0。</p>
 * @return 标签专题图中分段的个数。
 */
-(int)getCount;

/**
 * @brief 把一个标签专题图子项添加到分段列表的开头。
 * @param item 需要添加的子项。
 * @return 一个布尔值，如果添加成功返回true,否则返回false。
 */
-(BOOL)addToHead:(ThemeLabelItem *)item;

/**
 * @brief 把一个标签专题图子项添加到分段列表的开头。
 * @param item 需要添加的子项。
 * @param normalise 表示是否规整化，normalise为true时，item值不合法，则进行规整，normalise为false时,item值不合法则抛异常。
 * @return 一个布尔值，如果添加成功返回true,否则返回false。
 */
-(BOOL)addToHead:(ThemeLabelItem *)item normalise:(BOOL)normalise;

/**
 * @brief 把一个标签专题图子项添加到分段列表的尾部。
 * @param item 需要添加的标签专题图子项。
 * @return 一个布尔值，如果添加成功返回true,否则返回false。
 */
-(BOOL)addToTail:(ThemeLabelItem *)item;

/**
 * @brief 把一个标签专题图子项添加到分段列表的尾部。
 * @param item 需要添加的标签专题图子项。
 * @param normalise 表示是否规整化，normalise为true时，item 值不合法，则进行规整，normalise为false时，item值不合法则抛异常。
 * @return  一个布尔值，如果添加成功返回true,否则返回false。
 */
-(BOOL)addToTail:(ThemeLabelItem *)item normalise:(BOOL)normalise;

/**
 * @brief 删除标签专题图的子项。执行该方法后，所有的标签专题图子项都被释放，不再可用。
 */
-(void)clear;

/**
 * @brief 释放对象所占用的资源。调用该方法之后，此对象不再可用。
 */
-(void)dispose;



/**
 * @brief 返回指定序号的标签专题图中标签专题图子项。有关标签专题图子项详细信息，请参见 <ThemeLabelItem> 类。
 * @param index 指定标签专题图子项的序号。
 * @return 指定序号的标签专题图中标签专题图子项。
 */
-(ThemeLabelItem *)getItem:(int)index;

/**
 * @brief 返回当前标签专题图所归属的专题图，即其父对象。
 * <P>默认值为空。</p>
 * @return {@link ThemeLabel ThemeLabel} 对象。
 */
-(ThemeLabel*)getParent;

/**
 * @brief 返回标签专题图中指定分段字段值在当前分段序列中的序号。
 * @param value 给定的分段字段值。
 * @return 分段字段值在分段序列中的序号。如果该值不存在，就返回-1。
 */
-(int)indexOf:(double)value;

/**
 * @brief 根据给定的矢量数据集、分段字段表达式、分段模式和相应的分段参数生成默认的标签专题图。
 * @param dataset 矢量数据集。
 * @param rangeExpression 分段字段表达式。
 * @param rangeMode 分段模式。包括等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法以及自定义距离法。
 * @param rangeParameter 分段参数。当分段模式为等距离分段法，平方根分段法其中一种模式时，该参数为分段值；当分段模式为标准差分段法的时候，该参数不起作用；当分段模式为自定义距离时，该参数表示自定义距离。
 * @return 根据参数构造得到一个新的 <ThemeLabel>  的对象实例。
 */
+(ThemeLabel *)makeDefault:(DatasetVector *)dataset rangeExpression:(NSString *)rangeExpression rangeMode:(RangeMode)rangeMode rangeParameter:(double)rangeParameter;

/**
 * @brief 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数和颜色渐变模式生成默认的标签专题图。
 * @param dataset 矢量数据集。
 * @param rangeExpression 分段字段表达式。
 * @param rangeMode 分段模式。包括等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法以及自定义距离法。
 * @param rangeParameter 分段参数。当分段模式为等距离分段法，平方根分段法其中一种模式时，该参数为分段值；当分段模式为标准差分段法是时候，该参数不起作用；当分段模式为自定义距离时，该参数表示自定义距离。
 * @param colorGradientType 颜色渐变模式。
 * @return 根据参数构造得到一个新的 <ThemeLabel>  的对象实例。
 */
+(ThemeLabel *)makeDefault:(DatasetVector *)dataset rangeExpression:(NSString *)rangeExpression rangeMode:(RangeMode)rangeMode rangeParameter:(double)rangeParameter colorGradientType:(ColorGradientType)colorGradientType;

/**
 * @brief 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数、颜色渐变填充模式和外部连接表项生成默认的标签专题图。
 * @param dataset 矢量数据集。
 * @param rangeExpression  分段字段表达式。
 * @param rangeMode 分段模式。包括等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法以及自定义距离法。
 * @param rangeParameter 分段参数。当分段模式为等距离分段法，平方根分段法其中一种模式时，该参数为分段值；当分段模式为标准差分段法的时候，该参数不起作用；当分段模式为自定义距离时，该参数表示自定义距离。
 * @param colorGradientType 颜色渐变模式。
 * @param joinItems 外部表连接项。
 * @return 根据参数构造得到一个新的 <ThemeLabel>  的对象实例。
 */
+(ThemeLabel *)makeDefault:(DatasetVector *)dataset rangeExpression:(NSString *)rangeExpression rangeMode:(RangeMode)rangeMode rangeParameter:(double)rangeParameter colorGradientType:(ColorGradientType)colorGradientType joinItems:(JoinItems *)joinItems;

/**
 * @brief 根据给定的拆分分段值将一个指定序号的标签专题图子项拆分成两个具有各自风格和名称的标签专题图子项。
 * <p>注：splitValue 必须在拆分的范围之内。即大于标签专题图子项的起始值（Start）并且小于标签专题图子项的终止值（End）,如果不满足上述条件，则抛出异常。</p>
 * @param index 指定的标签专题图子项的序号。
 * @param splitValue 指定的拆分分段值。
 * @param style1 被拆分的两个标签专题图子项中的一个标签专题图子项的风格。
 * @param caption1 被拆分的两个标签专题图子项中的一个标签专题图子项的名称。
 * @param style2 被拆分的两个标签专题图子项中的另一个标签专题图子项的风格。
 * @param caption2 被拆分的两个标签专题图子项中的另一个标签专题图子项的名称。
 * @return 一个布尔值，拆分成功返回true，否则返回false。
 */
-(BOOL)split:(int)index SplitValue:(double)splitValue Style1:(TextStyle *)style1 Caption1:(NSString*)caption1 Style2:(TextStyle *)style2 Caption2:(NSString*)caption2;

/**
 * @brief 合并一个从指定序号起始的给定个数的标签专题图子项，并赋给合并后标签专题图子项显示风格和名称。执行该方法后，被合并的对象将被释放，不可再用。
 * @param index 指定的标签专题图子项的序号，并以此序号为起始。
 * @param count 要合并的标签专题图子项个数，即从指定的序号开始计算。
 * @param style 合并后的标签专题图子项的风格。
 * @param caption 合并后的标签专题图子项的名称。
 */
-(BOOL)merge:(int)index Count:(int)count TextStyle:(TextStyle *)style Caption:(NSString*)caption;

/**
 * @brief 返回标签专题图格式化字符串。
 * @return 标签专题图格式化字符串。
 */
-(NSString *)toString;

/**
 * @brief 设置标签专题图中标记文本相对于要素内点的水平偏移量。标签偏移量的单位为地图单位。
 * <p>该偏移量的值为一个常量值或者字段表达式所表示的值，即如果字段表达式为 SmID，其中 SmID=2，那么偏移量的值为 2。</p>
 * @param value 指定标签专题图中标记文本相对于要素内点的水平偏移量。
 */
-(void)setOffsetX:(NSString *)value;

/**
 * @brief 设置标签专题图中标记文本相对于要素内点的垂直偏移量。标签偏移量的单位为地图单位。
 * <p>该偏移量的值为一个常量值或者字段表达式所表示的值，即如果字段表达式为 SmID，其中 SmID=2，那么偏移量的值为 2。</p>
 * @param value 标签专题图中标记文本相对于要素内点的垂直偏移量。
 */
-(void)setOffsetY:(NSString *)value;

/**
 * @brief 获取标签专题图中标记文本相对于要素内点的水平偏移量。标签偏移量的单位为地图单位。
 * <p>该偏移量的值为一个常量值或者字段表达式所表示的值，即如果字段表达式为 SmID，其中 SmID=2，那么偏移量的值为 2。</p>
 * <p> 默认值为一个空字符串。</p>
 * @return 标签专题图中标记文本相对于要素内点的水平偏移量。
 */
-(NSString *)getOffsetX;

/**
 * @brief 获取标签专题图中标记文本相对于要素内点的垂直偏移量。标签偏移量的单位为地图单位。
 * <p>该偏移量的值为一个常量值或者字段表达式所表示的值，即如果字段表达式为 SmID，其中 SmID=2，那么偏移量的值为 2。</p>
 * <p> 默认值为一个空字符串。</p>
 * @return 标签专题图中标记文本相对于要素内点的垂直偏移量。
 */
-(NSString *)getOffsetY;

/**
 * @brief 设置超长标签的处理方式。对超长标签可以不作任何处理，也可以省略超出的部分，或者以换行方式进行显示。
 * @param value 指定超长标签的处理方式。
 */
-(void)setOverLengthMode:(smOverLengthLabelMode)value;

/**
 * @brief 获取超长标签的处理方式。对超长标签可以不作任何处理，也可以省略超出的部分，或者以换行方式进行显示。
 * <p>默认值为 SM_NONE，即对超长标签不进行处理。</p>
 * @return 超长标签的处理方式。
 */
-(smOverLengthLabelMode)getOverLengthMode;

/** 设置标签在每一行显示的最大长度,如果超过这个长度,将以省略号显示。
 * @param value 指定标签专题图中标记文本的最大长度。
 */
-(void)setMaxLabelLength:(NSInteger)value;

/// 返回标签在每一行显示的最大长度。
-(int)getMaxLabelLength;

@end
