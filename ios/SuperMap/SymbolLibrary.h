//
//  SymbolLibrary.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <UIKit/UIKit.h>
@class Symbol;
@class SymbolGroup;

/** 符号库基类。
 *  
 * <p>点状符号库类、线型符号库类和填充符号库类都继承自该抽象类。用来管理符号对象，包括符号对象的添加、删除。
 */
@interface SymbolLibrary : NSObject 

/**
     * 获取符号库的根组对象。
	 * <p>符号库的组织结构类似于Windows资源管理器的组织结构，磁盘的根目录下可以存在零个或多个文件夹以及零个或多个文件，每个文件夹中又可以有零个或多个子文件夹以及零个或多个文件，以此类推层层嵌套；符号库的根组就相当于这个磁盘的根目录，文件夹可以看做符号库的子分组，文件就好比各种符号，一个符号库只能存在一个根组，根组中可以有零个或多个子分组以及零个或多个符号，每个子分组下还可以有零个或多个子分组以及零个或多个符号，以此类推。
	 * <p>根组也是分组，对应  <SymbolGroup>  类对象，根组是符号库的最高分组层次，根组中可以包含零个或多个子分组以及零个或多个符号，子分组也是分组，同样对应   <SymbolGroup>  类对象，其中所有子分组又构成一个子分组集合，对应   <SymbolGroups>  类对象，根组中至多有一个分组集合，即  <SymbolGroups>  类对象，  <SymbolGroups>  类对象是  <SymbolGroup>  类对象的集合，用来管理根组中的各子分组，通过   <SymbolGroups>  类对象来完成根组中子分组的创建与移除。当子分组（例如下图绿色框所示）中还包含有零个或多个子分组以及零个或多个符号，那么这些子分组和符号又构成了的一个分组（下图蓝色虚线框所示）， 而这个绿色框标识的子分组称为蓝色虚线框所示的这个分组的父分组，并且，蓝色虚线框中的所有子分组构成了一个子分组集合，对应一个 {  <SymbolGroups>  类对象，同样该蓝色虚线框所示的分组中也至多有一个子分组集合，通过这个子分组集合对象来完成该蓝色虚线框所示的分组中的子分组的创建与移除。以此类推，下图中的黄色框所示的子分组对应一  <SymbolGroup>  类对象，粉色虚线框内的子分组又构成一个分组对象（此分组对象中包含零个符号和三个子分组），即对应一个    <SymbolGroup>    类对象，因此，黄色框所示的分组是粉色虚线框所示分组的父分组，同样粉色虚线框所示分组中也包含了一个子分组集合。总之，符号库呈现一种树形组织结构。
	 * <p>注：所谓的分组和子分组是符号库的逻辑组织形式，都是使用户可以将类别相同的符号放在一个组中，从而方便管理和使用。
	 * <p>综上所述，一个符号库 <SymbolLibrary> 包含有唯一的一个根组<SymbolGroup>  类对象，每个 <SymbolGroup>  类对象至多包含有一个  <SymbolGroups> 类对象，但却可以包含有零个或多个  <Symbol> 类对象，其中  <SymbolGroups> 类对象是  <SymbolGroup> 类对象的集合，以此实现符号库的树形管理结构。
     * @return 符号库的根组对象。
     */
@property(nonatomic,retain,readonly)SymbolGroup *rootGroup;

@property(nonatomic)BOOL isDispose;

/**
     * @brief  根据指定符号的 ID 号，查找该符号所属的分组。
     * @param ID 指定符号的 ID 号。
     * @return 符号库分组对象。
     */	
- (SymbolGroup *)findGroupWithID:(int)nId;

/**
     * @brief 测试当前符号库是否包含指定的 ID 号。
     * @param ID 需要进行测试的 ID 值。
     * @return 如果包含指定的 ID 号，返回 true；否则返回 false。
     */	
- (BOOL)containID:(int)nId;;

 /**
     * @brief 在该符号库中查找指定 ID 号的符号对象。
     * @param ID 指定的 ID 值。
     * @return 符号对象。
     */
- (Symbol *)findSymbolWithID:(int)nId;

/**
     * @brief 根据指定的名称，在该符号库中查找该名称所对应的符号对象，返回第一个与指定名称相同的符号对象。
     * @param name 指定的名称。
     * @return 符号对象。
     */	
- (Symbol *)findSymbolWithName:(NSString *)name;
/**
 * @brief 根据指定的路径，从文件加载符号库。
 * @param strFileName 指定的路径。
 * @return 加载是否成功。
 */
-(BOOL)fromFile:(NSString*)strFileName;
/**
 * @brief 删除符号库中指定的 ID 号的符号。
 * @param ID 需要删除符号的 ID 值。
 * @return 如果删除成功，返回 true；否则返回 false。
 */
-(BOOL)removeWithID:(int)nId;
/**
 * @brief 向符号库中添加符号，并放在指定分组下。
 * @param symbol 符号对象
 * @param desGroup 符号分组
 * @return 如果添加成功，返回 该符号在库中的 ID 值；否则返回 -1。
 */
-(int)add:(Symbol *)symbol toGroup:(SymbolGroup*)desGroup;
/**
 * @brief 向符号库中添加符号，放在根分组下。
 * @param symbol 符号对象
 * @return 如果添加成功，返回 该符号在库中的 ID 值；否则返回 -1。
 */
-(int)add:(Symbol *)symbol;
/**
 * @brief 将符号库中指定ID的符号，移动到指定分组下。
 * @param nId 需要移动符号的 ID 值。
 * @param desGroup 符号分组
 * @return 如果移动成功，返回 YES；否则返回 NO。
 */
-(BOOL)moveSymbolByID:(int)nId toGroup:(SymbolGroup*)desGroup;
/**
 * @brief 符号库路径。
 * @return 符号库路径。
 */
-(NSString*)getLibPath;

-(void)clear;
-(void)dispose;

@end
