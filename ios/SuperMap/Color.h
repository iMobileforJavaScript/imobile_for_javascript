//
//  Color.h
//  Visualization
//
//  版权所有 （c）2015 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>


/// SuperMap IOS RGB颜色类。
@interface Color: NSObject {
@private
    int reverseValue;
}
/// 红色分量。
@property (nonatomic,readonly)int red; 
/// 绿色分量。
@property (nonatomic,readonly)int green;
/// 蓝色分量。
@property (nonatomic,readonly)int blue;
/// 透明度分量.
@property (nonatomic,readonly)int alpha;
/// rgb颜色值。
@property (nonatomic,readonly)int rgb;

/** 由一个rgb颜色值构造一个颜色类。
 *
 * @param rgb  rgb值。
 */
- (id)initWithValue:(int)rgb;

/** 由rgb三个颜色分量构造一个颜色类。
*
 * @param r 红色。
 * @param g 绿色。
 * @param b 蓝色。
 */
- (id)initWithR:(int)r G:(int)g B:(int)b;

/** 由rgba四个分量构造一个颜色类。
 *
 * @param r 红色。
 * @param g 绿色。
 * @param b 蓝色。
 * @param a 透明度
 */
- (id)initWithR:(int)r G:(int)g B:(int)b A:(int)a;

/** 返回RGB颜色值16进制格式的字符串。
*
 * 这种格式的字符串可以被 iOS 接受，并转换为 iOS 的color。
 * @return RGB颜色值。
 */
- (NSString *) toColorString;
@end
