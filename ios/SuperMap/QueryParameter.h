//
//  QueryParameter.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "QueryType.h"
#import "CursorType.h"
#import "SpatialQueryMode.h"
@class QueryParameter;
@class Rectangle2D;

/** 查询参数类。
 * 
 * <p>用于描述一个条件查询的限制条件，如所包含的 SQL 语句，游标方式等。</p>
 * <p>条件查询，是查询满足一定条件的所有要素的记录，其查询得到的结果是记录集。查询参数类是用来设置条件查询的查询条件从而得到记录集。SQL 查询，又称属性查询，即通过构建包含属性字段、运算符号和数值的 SQL 条件语句来选择记录，从而得到记录集。</p>
 * <p>该类中 attriButeFilter ， orderBy 以及 groupBy 是用来返回和设置属性查询的相关信息的； spatialQueryObject 和 spatialQueryMode 用来返回和设置空间查询的相关信息。</p>
 */
@interface QueryParameter : NSObject{
    @private
    SpatialQueryMode _queryMode;
    id _spatialQueryObject;
}

/**
     * @brief 获取或设置查询所采用的游标类型。SuperMap 支持两种类型的游标，分别为动态游标和静态游标。使用动态游标查询时，记录集会动态的刷新，耗费很多的资源，而当使用静态游标时，查询的为记录集的静态副本，效率较高。推荐在查询时使用静态游标，使用静态游标获得的记录集是不可编辑的。详细信息请参见 CursorType 类型。
     *
     * <p>  默认值为 DYNAMIC DYNAMIC 类型。
     * @return 查询所采用的游标类型。
     * @see CursorType
     */
@property(nonatomic,assign)CursorType cursorType;

 /**
     * @brief 获取或设置查询所构建的 SQL 条件语句，即 SQL WHERE CLAUSE 语句。SQL 查询又称为属性查询，是通过一个或多个 SQL 条件语句来查询记录。SQL 语句是包含属性字段、运算符号和数值的条件语句。例如，你希望查询一个商业区内去年的年销售额超过30万的服装店，则构建的 SQL 查询语句为：Sales > 30,0000 AND SellingType = ‘Garment’。
     *
     *  <p> 默认值为一个空字符串。
     * @return 查询所构建的 SQL 条件语句，即 SQL WHERE CLAUSE 语句。
     */
@property(nonatomic,retain)NSString *attriButeFilter;

/**
     * @brief 获取或设置查询结果是否包含几何对象字段。
     *
     *  <p>  默认值为 true。
     * @return 查询结果包含几何对象字段，返回 true，不包含几何对象字段返回 false。
     */
@property(nonatomic,assign)BOOL hasGeometry;

/**
     *  @brief 获取或设置SQL查询排序的字段。对于 SQL 查询得到的记录集中的各记录，可以根据指定的字段进行排序，并可以指定为升序排列或是降序排列。注意用于排序的字段必须为数值型。
     *  <p>   默认值为个数为0的字符串数组。
     * @return SQL 查询排序的字段。
     */
@property(nonatomic,retain)NSArray *orderBy;

/**
     * @brief 获取或设置SQL 查询分组条件的字段。对于 SQL 查询得到的记录集中的各字段，可以根据指定的字段进行分组，指定的字段值相同的记录将被放置在一起。
     *
     *   <p> 默认值为个数为0的字符串数组。
     *@return SQL 查询分组条件的字段。
     */
@property(nonatomic,retain)NSArray *groupBy;

/**
     * @brief 获取或设置id查询的id数组。
     * @return id查询的id数组。
     */
@property(nonatomic,retain)NSArray *queryIDs;

/**
     * @brief 获取或设置bounds查询的范围。
     * @return bounds查询的范围。
     */
@property(nonatomic,retain)Rectangle2D *queryBounds;

/**
     *@brief 获取或设置查询类型。
     * @return 查询类型。
     */
@property(nonatomic,assign)QueryType queryType;

/**
     * @brief 获取或设置查询结果字段集合。对于查询结果的记录集中，可以设置其中所包含的字段，如果为空，则查询所有字段。
     *
     *  <p>   默认值为个数为0的字符串数组。
     * @return 查询结果字段集合。
     */
@property(nonatomic,retain)NSArray *resultFields;

/**
     * @brief 获取或设置空间查询操作模式。
     *  <p>   默认值为NONE 模式。
     * @return 空间查询操作模式。
     */
@property(nonatomic)SpatialQueryMode spatialQueryMode;

/**
     * @brief 获取或设置空间查询中的搜索对象。可以是  <Point2D> ，  <Rectangle2D>  ， <GeoPoint GeoPoint> ， <GeoLine> ， <GeoRegion> ， <DatasetVector> ， <Recordset> 等类型的对象。
     *<p>若搜索对象是数据集或是记录集类型，则必须同被搜索图层对应的数据集的地理坐标系一致。</p>
     *<p>   默认值为 null。
     *  @return 空间查询中的搜索对象。
     */
@property(nonatomic)id spatialQueryObject;

/**
     * @brief 构造一个新的 QueryParameter 对象。
     */
-(id)init;

 /**
     *@brief   根据给定的 QueryParameter 对象构造一个与其完全相同的新对象。
     * @param queryParameter 指定的 QueryParameter 对象。
     */
-(id) init:(QueryParameter*) queryParameter;

 /**
     * @brief 释放该对象所占用的资源。调用该方法之后，此对象不再可用。
     */
-(void) dispose;

/**
 * @brief 将查询参数转换成Json串。
 * @return 查询参数转换的Json串。
 */
-(NSString *) toJson;

// 日期转double，用于查询Date字段值
+(NSString*)dateToDouble:(int)year month:(int)month day:(int)day hours:(int)hours minutes:(int)minutes seconds:(int)seconds;

@end
