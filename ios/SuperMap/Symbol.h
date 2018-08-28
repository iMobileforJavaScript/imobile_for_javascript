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
    Symbol_MARKER = 0,
    Symbol_Line = 1,
    Symbol_Fill = 2
}SymbolType;


/** 符号基类。
 *  
 * <p>符号库中所有的符号类，包括点状符号类，线型符号类和填充符号类都继承自符号基类。
 */
@interface Symbol : NSObject

-(SymbolType)getType;

-(NSString*)getName;

-(int)getID;

-(NSString*)toString;

-(CGImageRef)drawBmpWidth:(int)nBmpWidth height:(int)nBmpHeight;

-(void)setSymbolStyle:(GeoStyle*)style;



@end
