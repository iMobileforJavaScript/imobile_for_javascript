//
//  Resources.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
@class SymbolMarkerLibrary;
@class SymbolLineLibrary;
@class SymbolFillLibrary;
@class Workspace;

/** 资源库类。
 <p> 该类用于管理工作空间中的资源，包括线型库、点状符号库和填充符号库。
 */
@interface Resources : NSObject {
    SymbolMarkerLibrary *_markerLibrary;
    SymbolLineLibrary *_lineLibrary;
    SymbolFillLibrary *_fillLibrary;
    Workspace *_workspace;
}

 /**@brief  获取资源库中的点状符号库对象。
 <p> 默认值为空的  <SymbolMarkerLibrary> 对象。
 @return  资源库中的点状符号库对象。
     */	
@property(nonatomic,readonly)SymbolMarkerLibrary *markerLibrary;

/**@brief 获取资源库中的线型库对象。
 <p> 默认值为空的 <SymbolLineLibrary> 对象。
 @return  资源库中的线型库对象。
     */	
@property(nonatomic,readonly)SymbolLineLibrary *lineLibrary;

/**@brief 获取资源库中的填充库对象。
 <p> 默认值为空的  <SymbolFillLibrary> 对象。
 @return  资源库中的填充库对象。
     */	
@property(nonatomic,readonly)SymbolFillLibrary *fillLibrary;

 /**@brief  获取该资源库所关联的工作空间对象。
 <p>  默认值为空。
 @return  该资源库所关联的工作空间对象。
     */	
@property(nonatomic,readonly)Workspace *workspace;

/// 构造一个新的 Resources 对象。
- (id)init;

-(void)dispose;

@end
