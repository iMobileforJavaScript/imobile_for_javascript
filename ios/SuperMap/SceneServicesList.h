//
//  Scene3DServicesList.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>


 ///三维场景服务集合类。
@interface SceneServicesList : NSObject{
    @private
    NSString *_iServerUrl;
}


/**@brief 根据iServer服务地址名称加载三维场景。
 @param  iServerUrl iServer服务地址名称。
 */
- (BOOL)load:(NSString *)iServerUrl;


/**@brief 返回三维场景服务集合对象对应的iServer服务的地址。
 @return  三维场景服务集合对象对应的iServer服务的地址。
*/
- (NSString *)getScenesUrl;

/**@brief 返回三维场景服务集合中三维场景的总数。
 @return  三维场景服务集合中三维场景的总数。
 */
- (NSInteger)count;

/**@brief 返回三维场景服务集合中指定索引的三维场景对象，索引从0开始编号。
 @param  index 要查找的三维场景对象的索引。
 @return  三维场景服务集合中指定索引的三维场景对象。
 */
- (NSString *)sceneItemAt:(NSInteger)index;


@end
