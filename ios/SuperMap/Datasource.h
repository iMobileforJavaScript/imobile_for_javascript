//
//  Datasource.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "EncodeType.h"
#import "DatasourceConnectionInfo.h"
#import "Charset.h"
@class Workspace,Datasets;
@class PrjCoordSys;
@class Dataset;

/** 数据源类。
 * 
 * <p>该类管理投影信息、数据源与数据库的连接信息和对其中的数据集的相关操作，如通过已有数据集复制生成新的数据集等。
 * <p>每个数据源对应一种数据引擎。SuperMap 产品中提供了多种数据源类型，分为文件型数据源、数据库型数据源和 Web 数据源。如 UDB 数据源属于文件型数据源；Oracle、SQL Server、PostgreSQL 和DB2 数据源属于数据库型数据源；OGC、GoogleMaps、超图云服务、Rest地图服务和天地图服务数据源属于 Web 数据源。
 * <p>数据源定义了一致的数据访问接口和规范。数据源的物理存储既可以是文件方式，也可以是数据库方式。区别不同存储方式的主要依据是其所采用的数据引擎类型：采用 UDB 引擎时，数据源以文件方式存储（*.udb，*.udd）——文件型数据源文件用.udb 文件存储空间数据，.udd 文件存储属性数据。
 * <p>数据源对象通常作为工作空间中数据源集合中的一个元素。可以对数据源进行保存操作、对数据集进行复制操作。
 * <p>一个工作空间可以打开多个数据源，不同的数据源通过不同的别名（Alias）进行标识。
 * <p>其中值得一提的是我们假设数据源中的数据都使用同样的单位和空间参考系。
 */
@interface Datasource : NSObject


// in java, the datasource construction is protected,so we just assert(0)
//-(id) init;

/**
     * @brief 获取或设置数据源的描述信息。
     *  <p> 此属性为开放给用户的属性，用户可以在描述信息里加入你想加入的任何信息，例如建立数据源的人员、数据的来源、数据的主要内容、数据的精度、质量等信息，这些信息对于维护数据具有重要的意义。
     * @return description 用户添加的关于数据源的描述信息。
     */
@property (strong,nonatomic) NSString* description;

/**
     * @brief 获取数据源所包含的数据集的集合对象。
   *  <p>  该数据集集合提供对数据集的管理功能，如创建、删除、重命名等操作。一个数据源中所有的数据集对象都由一个数据集集合对象来管理。
     * @return 此数据源所包含的数据集的集合对象。
     */
@property (strong,nonatomic,readonly) Datasets* datasets;

/**
     *  @brief 获取数据源的投影信息。
     * @return 数据源的投影信息。
     */
@property (strong,nonatomic,readonly) PrjCoordSys* prjCoordSys;

/**
     * @brief 获取此数据源的连接信息。
     *  <p>  数据源连结信息包括了进行数据源连接的所有信息，如所要连接的服务器名称，数据库名称、用户名、密码等。
     * @return 此数据源的连接信息。
     * @see DatasourceConnectionInfo
     */
@property (strong,nonatomic,readonly) DatasourceConnectionInfo* datasourceConnectionInfo;

/**
     * @brief 获取数据源所在的工作空间对象。
     * @return 数据源所在的工作空间。
     */
@property (strong,nonatomic,readonly) Workspace* workspace;

/**
     *  @brief 获取数据源的别名。
     *  <p>  别名用于在工作空间中唯一标识数据源，可以通过它访问数据源。数据源的别名在创建数据源或打开数据源时给定，打开同一个数据源可以使用不同的别名。
     * @return 数据源的别名。
     */
@property (strong,nonatomic,readonly) NSString* alias;

/**
     * @brief 获取此数据源是否有改动。
     * <p>  true 表示数据源已改动，false 表示数据源还未改动。数据源负责管理数据集，因此当其中的数据集个数等内容发生改变时，此属性会返回 true。当数据源是以事务方式打开时，关闭数据源时可通过此属性判断是否需要提示用户保存修改内容。
     * @return 此数据源是否有改动。
     */
-(BOOL) isModified;

/**
     *  @brief 获取数据源是否以只读方式打开。
     * <p> 对文件型数据源，如果只读方式打开，就是共享的，可以打开多次；如果以非只读方式打开，则只能打开一次。</p>
     * <p>对于影像数据源，只会以只读方式打开。</p>
     * @return 数据源是否以只读方式打开。
     */
-(BOOL) isReadOnly;

/**
 *  @brief 保存数据源。
 * @return 数据源是否保存成功。
 */
-(BOOL) saveDatasource;

/**
 *  @brief 拷贝数据集。
 * <p> 对文件型数据源，如果只读方式打开，就是共享的，可以打开多次；如果以非只读方式打开，则只能打开一次。</p>
 * <p>对于影像数据源，只会以只读方式打开。</p>
 * @return 数据源是否以只读方式打开。
 */
-(Dataset*)copyDataset:(Dataset*)srcDataset desDatasetName:(NSString*)datasetName encodeType:(EncodeType)encodeType;

/**
 *  @brief oldPassword: 必须输入原始密码，没有为nil，newPassword:新密码 type:修改的加密类型
 * @return 修改是否成功。
 */
-(BOOL)changePassword:(NSString*)oldPassword nwePasswd:(NSString*)newPassword type:(DatasourceEncryptionType)type;


-(Dataset*)copyDataset2:(Dataset*)srcDataset desDatasetName:(NSString*)datasetName encodeType:(EncodeType)encodeType charset:(Charset)charset;
-(BOOL) isOpended;
@end
