//
//  Scenes.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Workspace;

/**三维场景集合类。
 <p>提供根据索引获取场景名称等功能。
 */
@interface Scenes : NSObject {
    Workspace *_workspace;
}

/// 返回当前工作空间中的三维场景个数。
@property (assign,nonatomic,readonly) NSInteger count;

/**@brief 返回三维场景集合对象中指定索引的三维场景名称。
 * @param  index 指定的三维场景索引。
 * @return 三维场景名称。
 */
-(NSString*) get:(NSInteger) index;


/**@brief 获取指定名称三维场景的索引。
 * @param  name 指定的三维场景名称。
  * @return 三维场景的索引。
 */
-(NSInteger) indexOf:(NSString*) name;
@end
