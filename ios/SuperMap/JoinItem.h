//
//  JoinItem.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "JoinType.h"
/**  连接信息类。
*
*  <p>连接信息类。用于矢量数据集与外部表的连接。外部表可以为另一个矢量数据集（其中纯属性数据集中没有空间几何信息）所对应的DBMS表，也可以是用户自建的业务表。需要注意的是，矢量数据集与外部表必须属于同一数据源。</p>
* <p>当两个表格之间建立了连接，通过对主表进行操作，可以对外部表进行查询，制作专题图以及分析等。当两个表格之间是一对一或多对以的关系时，可以使用 join 连接。当为多对一的关系时，允许指定多个字段之间的关联。该类型的实例可被创建。
*  <p> 下面通过查询的例子来说明矢量数据集与外部表的连接，假设用来进行查询的数据集表为 DatasetTableA，被连接的表为 DatasetTableB，现通过建立 DatasetTableA 与 DatasetTableB 的连接关系来查询 DatasetTableA 中满足查询条件的记录:</p>
*  <p> 设置将 DatasetTableB 连接 DatasetTableA 的连接信息，即建立 JoinItem 类并设置其属性，当执行 DatasetTableA 的查询操作时，系统将根据连接条件及查询条件，将满足条件的 DatasetTableA 中的内容与满足条件的 DatasetTableB 中的内容构成一个查询结果表，并且这个查询表保存在内存中，需要返回结果时，再从内存中取出相应的内容。</p>
*  <p> 注意：JoinItem 目前支持左连接和内连接，不支持全连接和右连接，UDB 引擎不支持内连接。</p>
*/
@interface JoinItem : NSObject{
//    NSString *_mName;         // 名称
//    NSString *_mForeignTable; // 外部关联表
//    NSString *_mJoinFiler;    // 关联条件
//    JoinType _mJoinType;      // 连接类型
}
/** 获取或设置此链接信息对象的名称。
* 
* <p>默认值为UntitledJoinItem。</p>
* @return 连接信息对象的名称。
*/
@property(nonatomic)NSString *mName; 

/**
* 获取或设置外部表的名称。
* <p>默认值为一个空字符串。</p>
* @return 外部表的名称。
*/
@property(nonatomic)NSString *mForeignTable;

/**
* 获取或设置与外部表之间的连接表达式。
* <p>即设定两个表之间关联的字段。例如，将一个房屋的面数据集（Building)的 district 字段与一个房屋拥有者的纯属性数据集（Owner）的 region 字段相连接，两个数据集对应的表名称分别为为 Table_Building 和 Table_Owner，则连接表达式为Table_Building.district = Table_Owner.region，当有多个字段相连接时，用 AND 将多个表达式相连。</p>
* <p>默认值为一个空字符串。</p>
* @return 两个表之间关联的字段。
*/
@property(nonatomic)NSString *mJoinFiler;

/**
* 获取或设置两个表之间连接的类型。
* <p>连接类型用于对两个连接的表进行查询时，决定了返回的记录的情况。</p>
* <p>默认值为LEFTJOIN 。</p>
* @return 两个表之间连接的类型。
*/
@property(nonatomic)JoinType mJoinType;

/**
* 根据给定的 JoinItem 对象构造一个与其完全相同的新对象。
* @param item 给定的 JoinItem 对象。
*/
-(id)initWithJoinItem:(JoinItem*)item;

/**
* 将此连接信息对象输出为格式化字符串。
* <p>该格式化字符串的格式为 {Name=””,ForeignTable=””,JoinFilter=””,JoinType=}。</p>
* @return 此连接信息对象的格式化字符串。
*/
-(NSString*)toString;

-(void)dispose;
@end
