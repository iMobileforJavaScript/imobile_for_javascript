//
//  Layer3DServicesList.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/// 三维场景服务列表类。
@interface Layer3DServicesList : NSObject {
    NSArray *_layerDataList;
    NSString *_iServerLayerUrl;
    NSString *_sceneName;
}

/// 返回或设置三维场景服务地址。
@property(nonatomic,readonly)NSString *iServerLayerUrl;

/// 返回或设置三维场景服务数量。
@property(nonatomic,readonly)NSInteger count;

/**@brief 加载三维场景服务。
 @param  iServerLayerUrl iServer服务地址。
 @param  sceneName 三维场景名称。
 @return  成功则返回true，否则返回false。
 */

- (BOOL)loadWithUrl:(NSString *)iServerLayerUrl SceneName:(NSString *)sceneName;
/**@brief 返回三维场景服务中指定索引的三维图层对象，索引从0开始编号。
 @param  index 要查找的三维图层对象的索引。
 @return  三维场景服务中指定索引的三维图层对象。
 */
- (NSString *)layerItemAt:(NSInteger)index;


@end
