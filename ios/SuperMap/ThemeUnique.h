//
//  ThemeUnique.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Theme.h"
#import "ThemeUniqueItem.h"
#import "DatasetVector.h"
#import "ColorGradientType.h"
#import "JoinItems.h"
#import "Colors.h"
@class GeoStyle;
/** 单值专题图类。
*  
* <p>将字段或表达式的值相同的要素采用相同的风格来显示，从而用来区分不同的类别。例如，在表示土地的面数据中表示土地利用类型的字段中有草地，林地，居民地，耕地等值，使用单值专题图进行渲染时，每种类型的土地利用类型被赋予一种颜色或填充风格，从而可以看出每种类型的土地利用的分布区域和范围。可用于地质图、地貌图、植被图、土地利用图、政治行政区划图、自然区划图、经济区划图等。单值专题图着重表示现象质的差别，一般不表示数量的特征。尤其是有交叉或重叠现象时，此类不推荐使用，例如：民族分布区等。</p>
*/
@interface ThemeUnique : Theme{
    NSMutableArray *_mUniqueItems;
    GeoStyle *_mDefaultStyle;
}

/**
* @brief 获取或设置单值专题图的默认风格。对于那些未在单值专题图之列的对象使用该风格显示。如未设置，则使用图层默认风格显示。
* <p>默认值为{FillBackColor=Color [A=255, R=255, G=255, B=255],FillForeColor=Color [A=255, R=189, G=235, B=255],FillGradientAngle=0,FillGradientMode=None,FillGradientOffsetRatioX=0,FillGradientOffsetRatioY=0,FillOpaqueRate=100,FillSymbolID=0,LineColor=Color [A=255, R=0, G=0, B=0],LineSymbolID=0,LineWidth=0.1,MarkerAngle=0,MarkerSize={Width=2.4,Height=-1},MarkerSymbolID=0}。</p>
* @return 单值专题图的默认风格。
*/
@property(nonatomic)GeoStyle *mDefaultStyle;

/**
* @brief 添加一个单值专题图子项到单值专题图子项列表中。
* @param item 将被添加的单值专题图子项。
* @return 如果添加成功，返回被添加子项在序列中的序号，否则返回-1。
*/
-(int)addItem:(ThemeUniqueItem *)item;

/**
* @brief 返回单值专题图格式化字符串。
* @return 单值专题图格式化字符串。
*/
-(NSString *)toString;

/**
* @brief 返回单值专题图子项个数。
* <p>默认值为0。</p>
* @return 单值专题图子项个数。
*/
-(int)getCount;

/**
* @brief 返回指定序号的单值专题图子项。
* @param index 指定的单值专题图子项的序号。
* @return 指定序号的单值专题图子项。
*/
-(ThemeUniqueItem *)getItem:(int)index;

/**
* @brief 返回单值专题图中指定子项单值在当前序列中的序号。
* @param unique 给定的单值专题图子项单值。
* @return 专题图子项在序列中的序号值。如果该值不存在，就返回-1。
*/
-(int)indexOf:(NSString *)unique;

/**
* @brief 获取单值专题图子项列表。
* @return 单值专题图子项列表。
*/
-(NSMutableArray *)getUniqueItemsList;

/**
* @brief 根据给定的矢量数据集和单值专题图字段表达式生成默认的单值专题图。
* @param dataset 给定的矢量数据集。
* @param uniqueExpression 单值专题图字段表达式。
* @return 根据参数构造得到一个新的单值专题图类的对象实例。
*/
+(ThemeUnique *)makeDefault:(DatasetVector *)dataset uniqueExpression:(NSString *)uniqueExpression;

/**
* @brief 根据给定的矢量数据集、单值专题图字段表达式和颜色渐变模式生成默认的单值专题图。
* @param dataset 给定的矢量数据集。
* @param uniqueExpression 单值专题图字段表达式。
* @param colorGradientType 颜色渐变模式。
* @return 根据参数构造得到一个新的单值专题图类的对象实例。
*/
+(ThemeUnique *)makeDefault:(DatasetVector *)dataset uniqueExpression:(NSString *)uniqueExpression colorType:(ColorGradientType )colorGradientType;

/**
* @brief 根据给定的矢量数据集、单值专题图字段表达式、颜色渐变模式和外部表连接项生成默认的单值专题图。
* @param dataset 给定的矢量数据集。
* @param uniqueExpression 单值专题图字段表达式。
* @param colorGradientType 颜色渐变模式。
* @param joinItems 外部表连接项。
* @return 根据参数构造得到一个新的单值专题图类的对象实例。
*/
+(ThemeUnique *)makeDefault:(DatasetVector *)dataset uniqueExpression:(NSString *)uniqueExpression colorType:(ColorGradientType )colorGradientType JoinItem:(JoinItems *)joinItems;

/**
* @brief 根据指定的面数据集、颜色字段名称、颜色生成默认的四色单值专题图。
* <p>四色单值专题图是指在一幅地图上，只用四种颜色就能使具有公共边的面对象着上不同的颜色。</p>
* <p>注意：对于面数据集复杂度低的情形下，采用四种颜色即可生成四色单值专题图；若面数据集复杂度高，则着色结果可能为五色。</p>
* @param dataset 指定的面数据集。由于该构造函数将修改面数据集的属性信息，因此需保证dataset为非只读。
* @param colorField 着色字段的名称。着色字段必须为整型字段。它可以为面数据集中已有属性字段，也可以是自定义的其它字段。若为已存在属性字段，需保证该字段类型为整型，系统将修改该字段的属性值，并分别赋值为1、2、3、4；若为自定义的其它字段，需保证字段名合法，则系统首先在面数据集中创建该字段，并分别赋值为1、2、3、4。由此，着色字段已分别赋值为1、2、3、4，代表着四种不同的颜色，根据该字段的值即可生成四色专题图。
* @param colors 用户传入的用来制作专题图的颜色。系统对传入颜色的数目不做规定，比如，用户只传入了一种颜色，则在生成专题图时，系统会自动补齐出图所需的颜色。
* @return 生成的四色单值专题图。
*/
+(ThemeUnique *)makeDefault:(DatasetVector *)dataset colorField:(NSString *)colorField colors:(Colors *)colors;

/**
* @brief 删除所有单值专题图子项。执行该方法后，所有的单值专题图子项都被释放，不可再用。
*/
-(void)clear;

/**
* @brief 释放对象所占用的资源。调用该方法之后，此对象不再可用。
*/
-(void)dispose;

/**
* @brief 根据传入的XML字符串重新构造对象。
* @param xml 传入的XML字符串。
* @return 一个布尔值，构造成功返回true,否则返回false。
*/
-(BOOL)fromXML:(NSString *)xml;

/**
* @brief 返回单值专题图字段表达式。
* <p>用于制作单值专题图的字段或字段表达式。该字段可以为要素的某一属性（如地质图中的年代或成份），其值的数据类型可以为数值型或字符型。</p>
* <p>默认值为一个空字符串。</p>
* @return 单值专题图字段表达式。
*/
-(NSString *)getUniqueExpression;

/**
* @brief 设置单值专题图字段表达式。
* <p>用于制作单值专题图的字段或字段表达式。该字段可以为要素的某一属性（如地质图中的年代或成份），其值的数据类型可以为数值型或字符型。</p>
* @param value 指定胆汁专题图字段表达式。
*/
-(void)setUniqueExpression:(NSString *)value;

/**
* @brief 将给定的单值专题图子项插入到指定序号的位置。
* @param index 指定的单值专题图子项序列的序号。
* @param item 将被插入的单值专题图子项。
*/
-(BOOL)insert:(int)index Item:(ThemeUniqueItem *)item;

/**
* @brief 返回单值专题图默认风格是否可见。
* @return 一个布尔值，单值专题图默认风格可见返回true,否则返回false。
*/
-(BOOL)isDefaultStyleVisible;

/**
* @brief 删除一个指定序号的单值专题图子项。
* @param index 指定的将被删除单值专题图子项序列的序号。
* @return 一个布尔值，删除成功返回true,否则返回false。
*/
-(BOOL)remove:(int)index;

/**
* @brief 设置单值专题图默认风格是否可见。
* @param value 胆汁专题图风格是否可见。
*/
-(void)setDefaultStyleVisible:(Boolean)value;

/**
* @brief  对单值专题图中子项的风格进行反序显示。
*/
-(void)reverseStyle;

@property (nonatomic,strong)NSString *offsetX;
@property (nonatomic,strong)NSString *offsetY;
@property (nonatomic)BOOL isOffsetFixed;
/**默认风格,如果某个对象不在单值列表内,就使用这个风格进行显示*/
@property (nonatomic,strong)GeoStyle *defaultGeoStyle;

@end
