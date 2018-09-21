//
//  Symbol.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@class GeoStyle;

typedef enum{
    Symbol_MARKER = 0,  // 点符号
    Symbol_Line = 1,    // 线填充符号
    Symbol_Fill = 2     // 面填充符号
}SymbolType;


/** 符号基类。
 *  
 * <p>符号库中所有的符号类，包括点状符号类，线型符号类和填充符号类都继承自符号基类。
 */
@interface Symbol : NSObject
// 返回符号类型
-(SymbolType)getType;
// 返回符号名称
-(NSString*)getName;
// 返回符号在符号库中ID（唯一）
-(int)getID;
// 返回包含符号ID和名称的字符串
-(NSString*)toString;
// 将符号输出图像（bitmap），nBmpWidth和nBmpHeight分别指示图像的宽和高
-(CGImageRef)drawBmpWidth:(int)nBmpWidth height:(int)nBmpHeight;
// 设置符号的风格
-(void)setSymbolStyle:(GeoStyle*)style;

@end
