//
//  FieldInfo.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

#import "FieldType.h"

@class FieldInfos,FieldInfo;

/**字段信息类。字段信息类用来存储字段的名称、类型、默认值以及长度等相关信息。
 * 
 * 每一个字段对应一个 <FieldInfo> 。对于矢量数据集的每一个字段，只有字段的别名（Caption）可以被修改，其他属性都不能被修改。
 * FieldInfo 对象可以通过两种途径获取：一是从记录集 Recordset 中得到，注意此 Recordset 必须是进行查询时得到的；二是可以从矢量数据集 DatasetVector 中得到，并且在矢量数据集中还可以创建字段。
 */
@interface FieldInfo : NSObject{
@private
    FieldInfos* _fieldInfos;
}

/**
     * @brief 判断字段是否允许零长度。只对文本类型（Text，Char 和 NVarChar）字段有效。
     *
     * @return 如果字段允许零长度则返回 true，否则返回 false。
     */
@property (assign,nonatomic) BOOL zeroLengthAllowed;

/**
     * @brief 获取或设置字段的别名。
     *<p> 对于从数据集中得到的字段除别名外，名称和其他信息都是不可以修改的。对于用户新建的字段，其包括名称在内的所有信息都是可以被修改的，但修改后的名称也不可以跟其他字段重名。</p>
     *<p>别名可以不唯一，即不同的字段可以有相同的别名，而名称是用来唯一标识一个字段的，所以不可重名。</p>
     * @return 此字段的别名。
     */
@property (strong,nonatomic) NSString* caption;

/**
     * @brief 获取或设置字段的默认值。当添加一条记录时，如果该字段未被赋值，则以该默认值作为该字段的值。
     *
     * @return 此字段的默认值。
     */
@property (strong,nonatomic) NSString* defaultValue;

 /**
     * @brief 获取或设置字段的名称。
    * <p> 字段的名称只能由数字、字母和下划线组成，但不能以数字或下划线开头；用户新建字段时，字段名称不能以 SM 作为前缀，以SM作为前缀的都是 SuperMap 系统字段，SMUserID 除外；另外，字段的名称不能超过30个字符，且字段的名称不区分大小写。名称用于唯一标识该字段，所以字段不可重名。
     * @return 字段的名称。
     */
@property (strong,nonatomic) NSString* name;

/**
     *  @brief 判断字段是否为必填字段。
     *
     * @return 若字段为必填字段，返回 true；否则返回 false。
     *
     */
@property (assign,nonatomic) BOOL required;

/**
     *  @brief 获取或设置字段值的最大长度，只对文本字段有效。单位：字节。
     *
     * @return 字段值的最大长度。
     */
@property (assign,nonatomic) NSInteger maxLength;

 /**
     *  @brief 获取或设置字段的类型。
     *
     * @return 字段的类型。
     * @see FieldType
     */
@property (assign,nonatomic) FieldType fieldType;

/**
     * @brief  构造一个新的 FieldInfo 对象。
     */
-(id) init;

/**
     * @brief  根据给定的 FieldInfo 对象构造一个与其完全相同的新对象。
    *
     * @param fieldInfo 指定的 FieldInfo 对象。
     */
-(id) initWithFieldInfo:(FieldInfo*) fieldInfo;

/**
     * @brief 根据指定的参数来构造一个 FieldInfo 的新对象。
     *
     * @param name 指定的字段的名称。
     * @param fieldType 指定的字段类型。有关字段类型的详细信息请参考  FieldType 类。
     */
-(id) initWithName:(NSString*) name fieldType:(FieldType) fieldType;

 /**
     * @brief 指示此字段是否为 SuperMap 系统字段，SuperMap 系统字段是以 SM 为前缀的字段，SMUserID 除外。
     *
     * @return 若此字段为 SuperMap 系统字段则返回 true，否则返回 false。
     */
-(BOOL) isSystemField;

 /**
     * @brief 指定字段是否为必填字段。
     *
     * @return 若字段为必填字段，返回 true；否则返回 false。
     */
-(BOOL) isRequired;

 /**
     * @brief  该方法用于释放占用资源。
    *  <p>用户可以自己调用该方法用于立即释放占用资源。如果不调用该方法，在该对象释放的时候，会自动调用该方法。调用该方法之后，此对象不再可用。
     */
-(void) dispose;

@end
