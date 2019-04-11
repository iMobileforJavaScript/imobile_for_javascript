//
//  TextPart.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class GeoText;
@class Point2D;

/** 文本子对象类。
 * 
 * <p> 用于表示文本对象的子对象，其存储子对象的文本，旋转角度，锚点等信息并提供对子对象进行处理的相关方法。</p>
 * <p>  当该类的实例已被dispose()  方法释放后，再调用该类成员的时候，则会抛出 ObjectDisposedException 异常。
 */
@interface TextPart : NSObject{

 @private
    //用于记录此TextPart的User，以得到此TextPart在User中的索引
    GeoText *m_geotext;
    Point2D *m_anchorPoint;
}
  /**
     * @brief  根据指定的TextPart对象构造一个与其完全相同的新对象。
     * @param part 指定的此TextPart对象。
     */
-(id)initWithTextPart:(TextPart *)part;

/**
* @brief 根据指定的参数来构造一个 TextPart 的新对象。
* @param text 指定此 TextPart 实例的文本内容。
* @param anchorPoint 指定此 TextPart 实例的锚点。
*/
-(id)initWithTextString:(NSString *)text anchorPoint:(Point2D *)anchorPoint;

/**
* @brief 根据指定的参数来构造一个 TextPart 的新对象。
* @param text 指定文本子对象实例的文本内容。
* @param anchorPoint 指定文本子对象实例的锚点。
* @param rotation 指定文本子对象的旋转角度，以度为单位，逆时针为正方向。
*/
-(id)initWithTextPartString:(NSString *)text anchorPoint:(Point2D *)anchorPoint rotation:(double)rotation;

/**
* @brief 根据指定的参数来构造一个 TextPart 的新对象。
* @param text 指定文本子对象的文本内容。
* @param x 指定文本子对象锚点的 X 的值。
* @param y 指定文本子对象锚点的 Y 的值。
* @param rotation 指定文本子对象的旋转角度，以度为单位，逆时针为正方向。
*/
-(id)initWith:(NSString *)text x:(double)x y:(double)y rotation:(double)rotation;

/**
* @brief 返回此文本子对象的文本内容。
* <p>默认值为一个空字符串。</p>
* @return 默认值为一个空字符串。
*/
-(NSString *)getText;

/**
* @brief 设置此文本子对象的文本内容。
* @param text 此文本子对象的文本内容。
*/
-(void)setText:(NSString *)text;

/**
     * @brief 设置此文本子对象锚点的横坐标。
     *
     * <p>    默认值为 0。
     *@return 此文本子对象锚点的横坐标。
     */
- (double)getX;
 /**
     * @brief 返回此文本子对象锚点的纵坐标。
     *
      * <p>    默认值为 0。
     * @return 此文本子对象锚点的纵坐标。
     */
- (double)getY;

//- (void)reset;

/**
* @brief 返回此文本子对象实例的锚点，其类型为 <Point2D> 。
* <p>该锚点与文本的对齐方式共同决定该文本子对象的显示位置。关于锚点与文本的对齐方式如何确定文本子对象的显示位置，请参见 <TextAlignment> 类。</p>
* <p>默认值为 Point2D(0.0,0.0)。</p>
* @return 此文本子对象实例的锚点。
*/
-(Point2D *)getAnchorPoint;

/**
* @brief 设置此文本子对象实例的锚点，其类型为 <Point2D> 。
* <p>该锚点与文本的对齐方式共同决定该文本子对象的显示位置。关于锚点与文本的对齐方式如何确定文本子对象的显示位置，请参见 <TextAlignment> 类。</p>
* @param anchorPoint 此文本子对象实例的锚点。
* @return 此文本子对象实例的锚点。
*/
-(void)setAnchorPoint:(Point2D *)anchorPoint;

/**
* @brief 返回此文本子对象的旋转角度。逆时针为正方向，单位为度。
* <p>文本子对象通过数据引擎存储后返回的旋转角度，精度为 0.1 度；通过构造函数直接构造的文本子对象，返回的旋转角度精度不变。</p>
* <p>默认值为 0.0。</p>
* @return 此文本子对象的旋转角度。
*/
-(double)getRotation;

/**
* @brief 设置此文本子对象的旋转角度。逆时针为正方向，单位为度。
* @param rotation 此文本子对象的旋转角度。
*/
-(void)setRotation:(double)rotation;

/**
* @brief 释放此对象所占用的资源。当调用该方法之后，此对象不再可用。
*/
-(void)dispose;
@end
