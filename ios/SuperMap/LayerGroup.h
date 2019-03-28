//
//  LayerGroup.h
//  LibUGC
//
//  Created by imobile-xzy on 15/10/29.
//  Copyright (c) 2015年 beijingchaotu. All rights reserved.
//

#import "Layer.h"


@protocol LayerGroupStateDelegate;
@interface LayerGroup : Layer

@property(nonatomic,assign)id<LayerGroupStateDelegate>delegate;
// 返回给定的图层集合中图层对象的总数。
-(NSUInteger)getCount;
// 返回 图层集合中指定索引的图层对象。
-(Layer*)getLayer:(int)index;
// 返回 图层集合中指定名称的图层对象
-(Layer*)getLayerWithName:(NSString*)name;

-(Layer*)findLayerWithName:(NSString*)name;//嵌套着在子group中找
//索引指定图层
-(NSUInteger)indexOfLayer:(Layer*)layer;
//添加图层
-(void)add:(Layer*)layer;
//插入图层
-(BOOL)insert:(int)index Layer:(Layer*)layer;
//删除图层
-(BOOL)removeLayer:(Layer*)layer;
////移除图层,deletelayer 是否删除
//-(BOOL)removeLayer:(Layer *)layer bDelete:(BOOL)deletelayer;
//添加分组
-(LayerGroup*)addGroup:(NSString*)groupName;
//插入分组
-(LayerGroup*)insertGroup:(int)index  name:(NSString*)groupName;
//移除分组
-(BOOL)removeGroup:(LayerGroup*)group;
//解除分组
-(BOOL)unGroup;
@end

@protocol LayerGroupStateDelegate <NSObject>

/**  添加新图层时回调。
 *
 * @param  layerAdded 添加的新图层。
 */
-(void) layerGroupAdded:(LayerGroup*)addedGroup parentGroup:(LayerGroup*)parentGroup index:(int)index;

/** 移除图层前回调。
 *
 * @param  layerRemove 被移除的图层。
 */
-(void) layerGroupRemoving:(NSString*)removedGroup parentGroup:(LayerGroup*)parentGroup index:(int)index;

@end
