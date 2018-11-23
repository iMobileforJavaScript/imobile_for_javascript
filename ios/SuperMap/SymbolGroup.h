//
//  SymbolGroup.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <UIKit/UIKit.h>
@class Symbol, SymbolLibrary,SymbolGroups;

/** 符号库分组类。
 * 
 * <p>该类主要为管理符号库中的子分组和符号对象提供一种逻辑化的组织结构形式，从而实现结构化，层次化的清晰管理模式，该类不能获取系统符号也并不负责符号对象的添加与删除以及符号对象的导入与导出操作，这类操作主要由符号库基类（ <SymbolLibrary>  类）提供，详细内容参见  <SymbolLibrary> 类。
 * <p>符号库的组织结构类似于Windows资源管理器的组织结构，磁盘的根目录下可以存在零个或多个文件夹以及零个或多个文件，每个文件夹中又可以有零个或多个子文件夹以及零个或多个文件，以此类推层层嵌套；符号库的根组就相当于这个磁盘的根目录，文件夹可以看做符号库的子分组，文件就好比各种符号，一个符号库只能存在一个根组，根组中可以有零个或多个子分组以及零个或多个符号，每个子分组下还可以有零个或多个子分组以及零个或多个符号，以此类推。
 * <p>根组也是分组，对应  <SymbolGroup> 类对象，根组是符号库的最高分组层次，根组中可以包含零个或多个子分组以及零个或多个符号，子分组也是分组，同样对应  <SymbolGroup >  类对象，其中所有子分组又构成一个子分组集合，对应  <SymbolGroups> 类对象，根组中至多有一个分组集合，即 <SymbolGroups>  类对象， <SymbolGroups>  类对象是  <SymbolGroup>  类对象的集合，用来管理根组中的各子分组，通过  <SymbolGroups>  类对象来完成根组中子分组的创建与移除。当子分组（例如下图绿色框所示）中还包含有零个或多个子分组以及零个或多个符号，那么这些子分组和符号又构成了的一个分组（下图蓝色虚线框所示）， 而这个绿色框标识的子分组称为蓝色虚线框所示的这个分组的父分组，并且，蓝色虚线框中的所有子分组构成了一个子分组集合，对应一个   <SymbolGroups>  类对象，同样该蓝色虚线框所示的分组中也至多有一个子分组集合，通过这个子分组集合对象来完成该蓝色虚线框所示的分组中的子分组的创建与移除。以此类推，下图中的黄色框所示的子分组对应一个  <SymbolGrous> 类对象，粉色虚线框内的子分组又构成一个分组对象（此分组对象中包含零个符号和三个子分组），即对应一个    symbolGroups>    类对象，因此，黄色框所示的分组是粉色虚线框所示分组的父分组，同样粉色虚线框所示分组中也包含了一个子分组集合。总之，符号库呈现一种树形组织结构。
 * <p>注：所谓的分组和子分组是符号库的逻辑组织形式，都是使用户可以将类别相同的符号放在一个组中，从而方便管理和使用。
 * <p>综上所述，一个符号库 <SymbolLibrary> 包含有唯一的一个根组 <SymbolGroup> 类对象，每个 <SymbolGroup> 类对象至多包含有一个  <SymbolGroups> 类对象，但却可以包含有零个或多个 <Symbol > 类对象，其中  <SymbolGroups> 类对象是 <SymbolGroup> 类对象的集合，以此实现符号库的树形管理结构。
 */
@interface SymbolGroup : NSObject
 /**
     * @brief 返回该分组对象的名称，如果该分组对象的名称在其父分组中已经存在，则会抛出异常。
     * @return 该分组对象的名称。
     */	
@property(nonatomic,retain)NSString *name;

 /**
     * @brief 返回该分组对象中的符号对象的个数。
     * @return 该分组对象中的符号对象的个数。
     */
@property(nonatomic)NSInteger count;


 /**
     * @brief 返回与该符号库分组对象相关联的符号库。
     * @return 与该符号库分组对象相关联的符号库。
     */	
@property(nonatomic,retain,readonly)SymbolLibrary *symbolLibrary;

/**
     * @brief 返回该分组对象的父分组。符号库的根组不存在父分组。
	 * <p>符号库的组织结构类似于Windows资源管理器的组织结构，磁盘的根目录下可以存在零个或多个文件夹以及零个或多个文件，每个文件夹中又可以有零个或多个子文件夹以及零个或多个文件，以此类推层层嵌套；符号库的根组就相当于这个磁盘的根目录，文件夹可以看做符号库的子分组，文件就好比各种符号，一个符号库只能存在一个根组，根组中可以有零个或多个子分组以及零个或多个符号，每个子分组下还可以有零个或多个子分组以及零个或多个符号，以此类推。
	 * <p>根组也是分组，对应  <SymbolGroup> 类对象，根组是符号库的最高分组层次，根组中可以包含零个或多个子分组以及零个或多个符号，子分组也是分组，同样对应  <SymbolGroup> 类对象，其中所有子分组又构成一个子分组集合，对应  <SymbolGroups> 类对象，根组中至多有一个分组集合，即  <SymbolGroups> 类对象，  <SymbolGroups> 类对象是  <SymbolGroup> 类对象的集合，用来管理根组中的各子分组，通过  <SymbolGroups> 类对象来完成根组中子分组的创建与移除。当子分组（例如下图绿色框所示）中还包含有零个或多个子分组以及零个或多个符号，那么这些子分组和符号又构成了的一个分组（下图蓝色虚线框所示）， 而这个绿色框标识的子分组称为蓝色虚线框所示的这个分组的父分组，并且，蓝色虚线框中的所有子分组构成了一个子分组集合，对应一个 {@link SymbolGroups SymbolGroups} 类对象，同样该蓝色虚线框所示的分组中也至多有一个子分组集合，通过这个子分组集合对象来完成该蓝色虚线框所示的分组中的子分组的创建与移除。以此类推，下图中的黄色框所示的子分组对应一个 {@link SymbolGroup SymbolGroup} 类对象，粉色虚线框内的子分组又构成一个分组对象（此分组对象中包含零个符号和三个子分组），即对应一个  <  SymbolGroup>       类对象，因此，黄色框所示的分组是粉色虚线框所示分组的父分组，同样粉色虚线框所示分组中也包含了一个子分组集合。总之，符号库呈现一种树形组织结构。
	 * <p>注：所谓的分组和子分组是符号库的逻辑组织形式，都是使用户可以将类别相同的符号放在一个组中，从而方便管理和使用。
	 * <p>综上所述，一个符号库 <SymbolLibrary> 包含有唯一的一个根组  <SymbolGroup> 类对象），每个   <SymbolGroup> 类对象至多包含有一个  <SymbolGroups> 类对象，但却可以包含有零个或多个  <Symbol> 类对象，其中  <SymbolGroups> 类对象是  <SymbolGroup>  类对象的集合，以此实现符号库的树形管理结构。
     * @return 该分组对象的父分组。
     */	
@property(nonatomic,retain,readonly)SymbolGroup *parentSymbolGroup;

@property(nonatomic,retain,readonly)SymbolGroups *childSymbolGroups;

/**
 * @brief 返回该分组对象中指定索引处的符号对象。
 * @param index 指定索引。
 * @return 该分组对象中指定索引处的符号对象。
 */
-(Symbol *)getSymbolWithIndex:(NSInteger)index;
/**
 * @brief 返回该分组对象中指定Id符号对象的索引。
 * @param nId 指定符号对象的ID。
 * @return 返回该分组对象中指定Id符号对象的索引。
 */
-(int)symbolIndexOfId:(int)nId;
// 移动索引处的符号对象到别的分组
-(BOOL)moveSymbol:(int)nIndex to:(SymbolGroup*)desGroup;
// 删除ID对应的符号对象
-(BOOL)removeSymbolById:(int)nId;
/**
 * @brief 返回ID对应符号对象所在子分组。
 * @param nId 指定符号对象的ID。
 * @return 返回ID对应符号对象所在子分组。
 */
-(SymbolGroup*)findSymbolGroupById:(int)nId;

// 查找Symbol
-(Symbol*)findSymbolById:(int)nId;
-(Symbol*)findSymbolByName:(NSString*)name;

@end
