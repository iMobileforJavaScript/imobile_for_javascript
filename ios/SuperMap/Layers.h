//
//  Layers.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Map,Layer,Dataset,LayerGroup;
@class Theme,Datasource;
@protocol LayersStateDelegate;
@protocol LayerGroupStateDelegate;
@protocol LayerStateDelegate;

/**
 *  图层集合类。
 * 
 *<p> 该类对一个地图对象中的所有图层进行管理。
 * <p> 一个图层集合对象中可包含各种类型的普通图层和专题图层，并且提供普通图层的创建方法。
 *  <p> 该类中提供了图层的添加、删除以及查找等的方法，并且可以设置图层为可编辑或不可编辑。同时，图层集合对象允许其中的多个图层同时处于可编辑状态，
 * 这样可以同时对多个图层进行编辑，从而提高工作效率。
 */
@interface Layers : NSObject{
    
}

/** 
 * @brief 图层集合状态变化时通知委托。
 */
@property (strong,nonatomic) id<LayersStateDelegate> layersdelegate;

@property(nonatomic,assign)id<LayerGroupStateDelegate>layerGroupdelegate;
@property(nonatomic,assign)id<LayerStateDelegate>layerdelegate;
/**
	 *@brief  用于把一个数据集添加到此图层集合作为一个普通图层显示，即创建一个普通图层。其风格由系统默认设置。
	 *
	 * @param dataset 要添加到图层的数据集。
	 * @param bToHead 指定新创建图层是否放在图层集合的最上面一层。当设置为 false 时，则将此新创建图层放在最底层。
	 * @return 新添加的图层。
 */
-(Layer *)addDataset:(Dataset *)dataset ToHead:(BOOL)bToHead;

/**
	 *@brief  用于把一个数据集添加到此图层集合作为一个普通图层显示，即创建一个普通图层。其风格由系统默认设置。
	 *
	 * @param dataset 要添加到图层的数据集。
	 * @param theme  专题图。
	 * @param bToHead 指定新创建图层是否放在图层集合的最上面一层。当设置为 false 时，则将此新创建图层放在最底层。
	 * @return 新添加的图层。
 */
-(Layer *)addDataset:(Dataset *)dataset Theme:(Theme*)theme ToHead:(BOOL)bToHead;

/**
	 *@brief   从此图层集合中删除一个指定索引的图层。删除成功则返回 true。
	 * @param index 要删除的图层的索引。
	 * @return 删除成功则返回 true，否则返回 false。
 */
-(BOOL)removeAt:(int)index;

/**
	 *@brief   从此图层集合中删除一个指定名称的图层。删除成功则返回 true。
	 * @param name 要删除图层的名称。
	 * @return 删除成功则返回 true，否则返回 false。
 */
-(BOOL)removeWithName:(NSString *)name;

/**
	 * @brief 删除此图层集合对象中所有的图层。
 */
-(void)clear;

/**
	 *@brief  返回此图层集合中图层对象的总数。
	 * @return 此图层集合中图层对象的总数。
 */
-(int)getCount;

/**
	 *@brief   返回此图层集合中指定名称的图层对象。
	 * @param name 要返回的图层的名称。
	 * @return 此图层集合中指定名称的图层对象。
 */
-(Layer *)getLayerWithName:(NSString *)name;


/**
	 * @brief  返回此图层集合中指定索引的图层对象。图层集合中图层的索引从 0 开始，从顶层开始依次编号。
	 * @param index 要返回的图层的索引。
	 * @return 此图层集合中指定索引的图层对象。
 */
-(Layer *)getLayerAtIndex:(int)index;


/**
	 * @brief 返回此图层集合中指定名称的图层的索引。
	 * @param name 要查找的图层的名称。
	 * @return 找到指定图层则返回图层索引，否则返回-1。
 */
-(int)indexOf:(NSString *)name;

/**
	 * @brief 图层移动。
	 * @param srcIndex 将要移动图层索引，desIndex 移动图层位置。
	 * @return 成功返回真。
 */
-(BOOL)moveTo:(int)srcIndex desIndex:(int)desIndex;
/**
 * @brief 图层上移。
 * @param srcIndex 将要移动图层索引，desIndex 移动图层位置。
 * @return 成功返回真。
 */
-(BOOL)moveUp:(int)srcIndex;
/**
 * @brief 图层下移。
 * @param srcIndex 将要移动图层索引，desIndex 移动图层位置。
 * @return 成功返回真。
 */
-(BOOL)moveDown:(int)srcIndex;
/**
 * @brief 图层置顶。
 * @param srcIndex 将要移动图层索引，desIndex 移动图层位置。
 * @return 成功返回真。
 */
-(BOOL)moveTop:(int)srcIndex;
/**
 * @brief 图层置底。
 * @param srcIndex 将要移动图层索引，desIndex 移动图层位置。
 * @return 成功返回真。
 */
-(BOOL)moveBottom:(int)srcIndex;

/**
 * 通过SLD文件，向图层集合中添加图层
 * @param layers 目标图层集合
 * @param datasource 数据所在的数据源
 * @param strSLDFilePath SLD文件路径
 */
-(void)addLayer:(Layers*)layers datasource:(Datasource*)datasource path:(NSString*)strSLDFilePath;

//添加图层
-(BOOL)addLayer:(Layer*)layer;
//插入图层
-(BOOL)insertLayer:(int)index layer:(Layer*)layer;
//删除图层
-(BOOL)remove:(Layer*)layer;
//删除分组
-(BOOL)removeGroup:(LayerGroup*)group;
//插入分组
-(LayerGroup*)insertGroup:(int)index groupName:(NSString*)groupName;
//添加分组
-(LayerGroup*)addGroup:(NSString*)groupName;

@end


///响应回调函数， 图层集合（Layers）状态变化时回调。

@protocol LayersStateDelegate <NSObject>
@optional
/**  添加新图层时回调。
*  
* @param  layerAdded 添加的新图层。
*/
-(void) layerAdded:(Layer*) layerAdded;

/** 移除图层前回调。
* 
* @param  layerRemove 被移除的图层。
*/
-(void) layerRemoving:(Layer*) layerRemove;

/** 移除图层后回调。
 *
 * @param  removedName 移除的图层名称。
 */
-(void) layerRemoved:(NSString*) removedName;

/**   编辑状态发生变化时回调。
* 
* @param changedLayer 编辑状态发生变化的图层。
* @param editable  图层可编辑状态。
 */
-(void) layerEditableChanged:(Layer*)changedLayer layerEditable:(BOOL) editable;

/**  图层别名信息发生变化时回调。
 * 
 * @param changedLayer 图层别名信息发生变化的图层。
 * @param oldName 原有的图层别名。
 * @param newName 变化后的图层别名。
 */
-(void) layerCaptionChanged:(Layer*)changedLayer oldCaption:(NSString*)oldName newCaption:(NSString*)newName;


/**   图层可见性发生变化时回调。
* 
* @param changedLayer 图层可见性发生变化的图层。
* @param isVisiable 图层是否可见。
*/
-(void) layerVisiableChanged:(Layer*)changedLayer layerVisiable:(BOOL) isVisiable;

@end

