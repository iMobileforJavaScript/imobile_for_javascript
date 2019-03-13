//
//  SymbolLineLibrary.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "SymbolLibrary.h"
@class SymbolMarkerLibrary;
/** 符号库基类。
 *   
 * <p>点状符号库类、线型符号库类和填充符号库类都继承自该抽象类。用来管理符号对象，包括符号对象的添加、删除。
 */
@interface SymbolLineLibrary : SymbolLibrary
// 得到内部点符号库
-(SymbolMarkerLibrary*)getInlineMarkerLib;
-(void)dispose;

@end
