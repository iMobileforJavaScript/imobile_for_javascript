//
//  ThemeLabelItem.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>


@class TextStyle;
@class ThemeLabel;

/** 标签专题图子项类。
* 
* <p>标签专题图用专题值对点、线、面等对象做标注，值得注意的是，标签专题图允许用户设置范围段，同一范围段内的标签具有相同的显示风格，其中每一个范围段就是一个专题图子项，每一个子项都具有其名称、风格、起始值和终止值。</p>
* <P>注意：每个分段所表示的范围为[Start,End)。例如：标签专题图的分段点有两个子项，它们所代表的分段区间分别为[0,5)，[5,10)。那么需要分别设置  [themelabelItems0 setMStart:0]，[themelabelItems0 setMEnd:5]，[themelabelItems1 setMStart:5]，[themelabelItems1 setMEnd:10]。</p>
*/
@interface ThemeLabelItem : NSObject{
    
@private
    
    NSString *_mCaption;
    TextStyle *_mTextStyle;
    BOOL _mVisible;
    double _mStart;
    double _mEnd;
    ThemeLabel *_mThemeLabel;
    BOOL _mIsUserThemeLabel;
}

/**
* @brief 获取或设置标签专题图子项的分段起始值。
* <p>注：如果该子项是分段中第一项，那么该起始值就是分段的最小值；如果该子项的序号大于等于1的时候，该起始值必须与前一子项的终止值相同，否则系统会抛出异常。</p>
* <p>默认值为 -3.4028235e+038。</p>
*/
@property(nonatomic)double mStart;

/**
* @brief 获取或设置标签专题图子项的分段终止值。
* <p>注：如果该子项是分段中最后一个子项，那么该终止值就是分段的最大值；如果不是最后一项，该终止值必须与其下一子项的起始值相同，否则系统抛出异常。</p>
* <p>默认值为 3.4028235e+038。</p>
*/
@property(nonatomic)double mEnd;

/**
* @brief 获取或设置标签专题图子项的名称。
* <p>默认值为 UntitledThemeLabelItem。</p>
*/
@property(nonatomic,retain)NSString * mCaption;

/**
* @brief 获取或设置标签专题图子项所对应的显示风格
* <p>默认值为 {Alignment=TopLeft,BackColor=Color [A=255, R=0, G=0, B=0],BackOpaque=False,Bold=False,FontHeight=6,FontWidth=0,ForeColor=Color [A=255, R=0, G=0, B=0],IsSizeFixed=True,Italic=False,Outline=False,Rotation=0,Shadow=False,Strikeout=False,Underline=False,Weight=400}。</p>
*/
@property(nonatomic)TextStyle *mTextStyle;

/**
* @brief 获取该标签专题图子项所属的标签专题图。
*/
@property(nonatomic,retain)ThemeLabel *mThemeLabel;

/**
* @brief 获取或设置标签专题图子项是否可见。
* <p>默认值为true。</p>
*/
@property(nonatomic,assign)BOOL mVisible;

/**
* @brief 返回标签专题图子项格式化字符串。格式为 {Caption="china",Start=10 End=20, Visible=true,Style={name=,width=,height=,color=()} }。
* @return 标签专题图格式化字符串。
*/
-(NSString *)toString;

/**
* @brief 构造一个新的标签专题图子项类的新对象。
*/
-(id) init;

/**
* @brief 拷贝构造函数，根据给定的 <ThemeLabelItem>  对象构造一个与其完全相同的新对象。
* @param themeLabelItem 给定的标签专题图子项对象。
*/
-(id)initWithThemeLableItem:(ThemeLabelItem *)themeLabelItem;

/**
* @brief 根据指定的标签专题图子项的起始值、终止值、显示风格来构造一个标签专题图子项的新对象。
* @param start 标签专题图子项的起始值。
* @param end 标签专题图子项的终止值。
* @param style 标签专题图子项的显示风格。
*/
-(id)initWithStart:(double)start end:(double)end textStyle:(TextStyle*)style;

@end
