//
//  ThemeUniqueItem.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "GeoStyle.h"
@class ThemeUnique;

/** 单值专题图子项类。
 <p>单值专题图是将专题值相同的要素归为一类，为每一类设定一种渲染风格，其中每一类就是一个专题图子项。比如，利用单值专题图制作行政区划图，Name 字段代表省/直辖市名，该字段用来做专题变量，如果该字段的字段值总共有5种不同值，则该行政区划图有5个专题图子项，其中每一个子项内的要素 Name 字段值都相同。</p>
*/
@interface ThemeUniqueItem : NSObject

/**@brief 获取或设置单值专题图子项的单值。
 <p>默认值为一个空字符串。</p>
 @return  单值专题图子项的单值。
*/
@property(nonatomic,retain)NSString *mUnique;

/**@brief 获取或设置单值专题图子项是否可见。
 <p>默认值为true。</p>
 @return  一个布尔值，单值专题图子项可见返回true,否则返回false。
*/
@property(nonatomic)BOOL mIsVisible;

/**@brief 获取或设置每个单值专题图子项的名称。
 <p>默认值为 "UntitledThemeUniqueItem"。</p>
 @return  每个单值专题图子项的名称。
*/
@property(nonatomic)NSString *mCaption;

/**@brief 获取或设置每个单值专题图子项的风格。
 <p>默认值为 {FillBackColor=Color [A=255, R=255, G=255, B=255],FillForeColor=Color [A=255, R=189, G=235, B=255],FillGradientAngle=0,FillGradientMode=None,FillGradientOffsetRatioX=0,FillGradientOffsetRatioY=0,FillOpaqueRate=100,FillSymbolID=0,LineColor=Color [A=255, R=0, G=0, B=0],LineSymbolID=0,LineWidth=1,MarkerAngle=0,MarkerSize={Width=28,Height=-1},MarkerSymbolID=0}。</p>
 @return  每个单值专题图子项的显示风格。
*/
@property(nonatomic)GeoStyle *mStyle;

 ///获取该单值专题图子项所属的单值专题图。
@property(nonatomic,retain)ThemeUnique *mThemeUnique;

 /**@brief 返回一个表示此单值专题图子项对象的格式化字符串。
 <p>格式为 {Caption=”china”,Unique =20, Visible=true?false ,Style={linestyle=,markerstyle=,fillstyle=} }。</p>
 @return  一个表示此单值专题图子项对象的格式化字符串。
  */
-(NSString *)toString;
/**拷贝构造函数，根据给定的 {@link ThemeUniqueItem ThemeUniqueItem} 对象构造一个与其完全相同的新对象。
 @param  item 给定的单值专题图子项对象。
  */
-(id)initWithThemeUniqueItem:(ThemeUniqueItem*)item;

@end
