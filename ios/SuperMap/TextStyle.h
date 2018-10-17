//
//  TextStyle.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//
#import <Foundation/Foundation.h>
#import "TextAlignment.h"
@class Color;
/**
 *  文本风格类。
 * 
 * 用于设置 <GeoText>  类对象的风格。当文本风格对象实例使用dispose()
 * @exception 方法释放后再调用该对象成员，将抛出 ObjectDisposedException 异常。
 */
@interface TextStyle : NSObject{
    
}

/**  返回文本的宽度。字体的宽度以英文字符为标准，由于一个中文字符相当于两个英文字符。默认值为 0。
	   
	 *
	 * @return 文本的宽度。
	 */
- (double)getFontWidth;

/** 返回文本字体的高度。使用地图坐标单位。  默认值为 6。
	 * 
	 *  
	 * @return 文本字体的高度。
	 */
- (double)getFontHeight;

/** 设置文本的宽度。字体的宽度以英文字符为标准，由于一个中文字符相当于两个英文字符。
	 *   
	 * @param value  文本的宽度。
	 * 
	 */
- (void)setFontWidth:(double)value;

/** 设置文本字体的高度。使用地图坐标单位。
	 *  
	 * @param value 文本字体的高度。
	 */
- (void)setFontHeight:(double)value;

/** 设置文本的前景色。
	 *   
	 * @param value 文本的前景色。
	 */
-(void)setForeColor:(Color *)value;

/** 返回文本的前景色。
	 *  
	 * <p>默认色为黑色。</p>
	 * @return 文本的前景色。
	 */
-(Color *)getForeColor;


/**  返回文本的背景色。
	 *  
	 * <p>默认颜色为黑色</p>
	 * @return 文本的背景色。
	 */
-(Color *)getBackColor;

/** 设置文本的背景色。
	 *  
	 * @param value 文本的背景色。
	 */
-(void)setBackColor:(Color *)value;

/**
	 * @brief  返回文本字体的名称。
	 * <p>文本字体的名称的默认值为 "Times New Roman"。</p>
	 * @return 文本字体的名称。
	 */
-(NSString *)getFontName;

/**
	 * @brief  设置文本字体的名称。
	 * @param value 文本字体的名称。
	 */
-(void)setFontName:(NSString*)value;

/**
 * @brief  获取文本字体的对齐方式。
 * <p>默认是文本左上角对齐TOPLEFT。</p>
 * @exception EnumConstantNotPresentException 如果返回的文本字体对齐方式不是  <TextAlignment> 类中的常量。</p>
 * @return 文本字体的对齐方式。
 */
-(TextAlignment)getAlignment;

/**
 * @brief  设置文本字体的对齐方式。
 * <p>当 setAlignment  的参数不是 <TextAlignment>  类中的常量时，则抛出 EnumConstantNotPresentException 异常。</p>
 * @param alignment 文本字体的对齐方式。
 * @exception EnumConstantNotPresentException 如果设置的文本对齐方式不是  <TextAlignment>  类中的常量。
 */
-(void)setAlignment:(TextAlignment)alignment;

/**
 * @brief 设置文本字体的磅数，表示粗体的具体数值。取值为0～900中的整百数，如400表示正常显示，700表示粗体，可参见微软MSDN
 * LogFont帮助中关于LFWeight的说明。
 *
 * @param value 文本字体的磅数。
 *           
 */
-(void)setWeight:(int)value NS_DEPRECATED_IOS(2_0,5_0);
/**
 * @brief 获取文本字体的磅数(文本的笔画宽度)，表示粗体的具体数值。取值为0～900中的整百数，如400表示正常显示，700表示粗体，可参见微软MSDN
 * LogFont帮助中关于LFWeight的说明。
 * <p>默认值为400，表示正常显示。</p>
 * @return 文本字体的磅数。 
 */
-(int)getWeight NS_DEPRECATED_IOS(2_0,5_0);

/**
 * @brief 获取文本字体是否为固定尺寸。false，表示文本为非固定尺寸的文本。
 * <p>默认值为false，表示不固定尺寸。</p>
 * @return 如果文本为固定尺寸，返回true;否则返回false。
 */
-(BOOL)IsSizeFixed;
/**
 * @brief 设置文本字体是否为固定尺寸。false，表示文本为非固定尺寸的文本。
 *
 * @param value 指定文本大小是否固定。
  */
-(void)setIsSizeFixed:(BOOL)value;

/**
 * @brief 获取文本字体是否为粗体字，True 表示为粗体。
 * <p>默认值为false，即文本不是粗体字。</p>
 * @return 如果文本为粗体字，返回true;否则返回false。
 */
-(BOOL)isBold;
/**
 * @brief 设置文本字体是否为粗体字，True 表示为粗体。
 *
 * @param value 指定文本是否为粗体。      
 */

-(void)setBold:(BOOL)value;
/**
 * @brief 获取文本是否采用斜体，True 表示采用斜体。
 * <p>默认值为false，即不采用斜体。</p>
 * @return 如果文本采用斜体，返回true;否则返回false。
 */
-(BOOL)getItalic;
/**
 * @brief 设置文本字体是否采用斜体，true 表示采用斜体。
 *
 * @param value 指定文本字体是否采用斜体。
 */
-(void)setItalic:(BOOL)value;

/**
 * @brief 获取是否以轮廓的方式来显示文本字体的背景。false,表示不以轮廓的方式来显示文本的背景。
 * <p> 默认值为false，即不以轮廓的方式来显示文本的背景。</p>
 * @return 如果是以轮廓的方式来显示文本，则返回true;否则返回false。
 */
-(BOOL)getOutline;
/**
 * @brief 设置是否以轮廓(外框)的方式来显示文本字体的背景。false,表示不以轮廓的方式显示文本的背景。
 *
 * @param value 指定是否以轮廓的方式来显示文本的背景。
 */
-(void)setOutline:(BOOL)value;
/**
 * @brief 获取文本旋转的角度。逆时针方向为正方向，单位为度。 
 * <p> 文本对象通过数据引擎存储后返回的旋转角度，精度为0.1度；通过构造函数直接构造的文本对象，返回的旋转角度精度不变。</p>
 * <p>默认值为0.0。</p>
 * @return 文本旋转的角度。 
 */
-(double)getRotation;

/**
 * @brief 设置文本旋转的角度。逆时针方向为正方向，单位为度。
 *
 * @param value 文本旋转的角度。
 */
 
 -(void)setRotation:(double)value;
/**
 * @brief 获取文本是否有阴影。true 文本有阴影。
 * <p>默认值为false,即文本没有阴影。</p>
 * @return 如果文本有阴影，则返回true；否则返回false。
 */
-(BOOL)getShadow;
/**
 * @brief 设置文本是否有阴影。true 表示给文本增加阴影。
 *
 * @param value 指定文本是否有阴影。
 */
-(void)setShadow:(BOOL)value;
/**
 * @brief  获取文本字体是否有删除线，true 表示文本字体有删除线。
 * <p> 默认值为false,即文本字体没有删除线。</p>
 * @return 如果文本字体有删除线，则返回true；否则返回false。
 */
-(BOOL)getStrikeout;
/**
 * @brief 设置注记字体是否加删除线，true 表示加删除线。
 *
 * @param value 文本字体是否加删除线。
 */
-(void)setStrikeout:(BOOL)value;
/**
 * @brief 获取文本背景是否不透明，true 表示文本背景不透明。
 *  <p> 默认值为false,即文本背景透明。</p>
 * @return 如果文本背景不透明，则返回true；否则返回false。
 */
-(BOOL)isBackOpaque;
/**
 * @brief 设置文本背景是否不透明，true 表示文本背景不透明。
 *
 * @param value 指定文本背景是否不透明。
 */
-(void)setBackOpaque:(BOOL)value;
/**
 * @brief 获取文本字体是否加下划线，true 表示加下划线。
 * <p> 默认值为false,即文本字体不加下划线。</p>
 * @return 如果文本字体加下划线，则返回true,否则返回false。
 */
-(BOOL)getUnderline;
/**
 * @brief 设置文本字体是否加下划线，true 表示加下划线。
 *
 * @param value 指定文本字体是否加下划线。
 */
-(void)setUnderline:(BOOL)value;
/**
	 * @brief  返回当前 TextStyle 对象的一个拷贝。 该对象是此文本风格实例的一个副本。这里的副本是一个深拷贝。
	 * @return 通过克隆操作得到的 TextStyle 对象。
	 *
	  */
- (TextStyle *)clone;

/**
	 * @brief  返回一个表示此文本风格类对象的格式化字符串。
	 * @return 表示此文本风格类对象的字符串。
	 */
-(NSString*)toString;

/** 返回文本字体的比例。  默认值为 1。
 *
 *
 * @return 文本字体的比例。
 */
- (double)getFontScale;

/** 设置文本字体的比例。
 *
 * @param value 文本字体的比例。
 */
- (void)setFontScale:(double)value;

- (void)dispose;

@end
