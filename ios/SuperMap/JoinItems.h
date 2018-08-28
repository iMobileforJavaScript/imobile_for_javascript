//
//  JoinItems.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class JoinItem;
/** 连接信息集合类。
*  
* <p>当一个矢量数据集与多个外部表相连接时，用一个连接信息集合对象来管理其所有的连接信息对象。</p>
*/
@interface JoinItems : NSObject{
@protected
    NSMutableArray *_mJoinItems;
}

/**
* 返回此连接信息集合对象中指定序号的连接信息对象。
* @param index 指定的序号。
* @return 连接信息集合对象中指定序号的连接信息对象。
*/
-(JoinItem*)get:(int)index;

/**
* 返回此连接信息集合对象中所包含的连接信息对象的总数。
* <p>默认值为0。</p>
* @return 连接信息集合对象中所包含的连接信息对象的总数。
*/
-(int)getCount;

/**
* 设置此连接信息集合对象中指定序号的连接信息对象。
* @param item 连接信息集合对象中指定序号的连接信息对象。
* @param index 指定的序号。 
*/
-(void)set:(JoinItem*)item AtIndex:(int)index;

/**
* 根据给定的 JoinItems 对象拷贝一个与其完全相同的新对象。
* @param items 给定的 JoinItems 对象。
* @return 通过克隆操作得到的一个新的 JoinItems 对象。
*/
-(JoinItems*)clone:(JoinItems*)items;

/**
* 将指定的多个连接信息对象添加到此连接信息集合对象的末尾。
* @param joinItems 要添加到此连接信息集合对象中的多个连接信息对象。
* @return 添加的多个连接信息对象的个数。
*/
-(int)addRange:(NSArray*)joinItems;

-(int)add:(JoinItem*)item;

-(void)clear;

-(void)dispose;

-(BOOL)insert:(int)index joinItem:(JoinItem *)joinItem;

-(int)insertRange:(int)index joinItemArray:(NSMutableArray *)joinItemArray;

-(BOOL)remove:(int)index joinItem:(JoinItem *)joinItem;

-(BOOL)removeRange:(int)index count:(int)count;

-(NSMutableArray *)toArray;
@end
