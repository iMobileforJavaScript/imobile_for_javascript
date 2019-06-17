//
//  ThemeRangeItem.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
@class GeoStyle;
@class ThemeRange;

/** 分段专题图子项类。
* 
* <p>在分段专题图中，将分段字段的表达式的值按照某种分段模式被分成多个范围段。每个分段都有其分段起始值、终止值、名称和风格等。每个分段所表示的范围为 [Start, End)。</p>
*/
@interface ThemeRangeItem : NSObject
/**
* @brief 获取或设置分段专题图子项的起始值。
* <p>注意：如果该子项是分段中第一个子项，那么该起始值就是分段的最小值；如果子项的序号大于等于 1 的时候，该起始值必须与前一子项的终止值相同，否则系统会抛出异常。</p>
* <p>默认值为-3.4028235e+038。</p>
* @return 分段专题图子项的起始值。
*/
@property(nonatomic,assign)double mStart;

/**
* @brief 获取或设置分段专题图子项的终止值。
* <p>默认值为3.4028235e+038。</p>
* @return 分段专题如子项的终止值。
*/
@property(nonatomic,assign)double mEnd;

/**
* @brief 获取或设置分段专题图子项中的名称
* <p>默认值为UntitledThemeRangeItem。</p>
* @return 分段专题图子项中的名称。
*/
@property(nonatomic)NSString * mCaption;

/**
* @brief 获取或设置分段专题图中每一个分段专题图子项对应的风格。
* <p>默认值为 {FillBackColor=Color [A=255, R=255, G=255, B=255],FillForeColor=Color [A=255, R=189, G=235, B=255],FillGradientAngle=0,FillGradientMode=None,FillGradientOffsetRatioX=0,FillGradientOffsetRatioY=0,FillOpaqueRate=100,FillSymbolID=0,LineColor=Color [A=255, R=0, G=0, B=0],LineSymbolID=0,LineWidth=1,MarkerAngle=0,MarkerSize={Width=28,Height=-1},MarkerSymbolID=0}。</p>
* @return 分段专题图中每一个分段专题图子项的对应的风格。
*/
@property(nonatomic)GeoStyle * mStyle;

/**
* @brief 获取该分段专题图子项所属的分段专题图。
*/
@property(nonatomic,retain)ThemeRange * mThemeRange;

/**
* @brief 获取或设置分段专题图中的子项是否可见。
* <p>默认值为true。</p>
* @return 一个布尔值，分段专题图中的子项可见返回 true，否则返回 false。
*/
@property(nonatomic,assign)BOOL mIsVisible;



/**
* @brief 根据指定分段专题图子项的起始值、终止值、显示风格、名称来构造一个分段专题图子项的新对象。
* @param start 分段专题图子项的起始值。
* @param end 分段专题图子项的终止值。
* @param style 分段专题图子项的显示风格。
* @param caption 分段专题图子项的名称。
*/
-(id)initWithStart:(double)start End:(double)end GeoStyle:(GeoStyle *)style caption:(NSString *)caption;

/**
* @brief 根据给定的分段专题图子项对象构造一个与其完全相同的新对象。
* @param themeRangeItem 给定的分段专题图子项对象。
*/
-(id)initWithThemeRangeItem:(ThemeRangeItem *)themeRangeItem;

/**
* @brief 根据给定的分段专题图构造一个分段专题图子项的新对象。
* @param 给定的分段专题图。
*/
//-(id)initWithThemeRange:(ThemeRange *)themeRange;

/**
* @brief 返回分段专题图格式化字符串。
* <p>格式为 {Caption=”china”,Start=10 End=20, Visible=true?false ,Style={linestyle=,markerstyle=,fillstyle=} }。</p>
* @return 分段专题图格式化字符串。
*/
-(NSString *)toString;

@end
