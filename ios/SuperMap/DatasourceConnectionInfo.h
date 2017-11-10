//
//  DatasourceConnectionInfo.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

#import "EngineType.h"



//数据源加密方式
typedef enum{
    
    DEFAULT = 0,
    AES     = 1
}DatasourceEncryptionType;


@class Rectangle2D;
/**
 * 数据源连接信息类。
 * 
 * <p> 包括了进行数据源连接的所有信息，如所要连接的服务器名称，数据库名称、用户名、密码等。当保存工作空间时，工作空间中的数据源的连接信息都将存储到工作空间文件中
 * 。对于不同类型的数据源，其连接信息有所区别。所以在使用该类所包含的成员时，请注意该成员所适用的数据源类型。
 * <p> SuperMap iMobile 7C for IOS支持 UDB 引擎下的内存数据源，允许用户在内存中创建数据源。
 */
@interface DatasourceConnectionInfo : NSObject{
@private
    BOOL _readOnly;
}

    /**
	 * @brief 构造一个新的 DatasourceConnectionInfo 对象，默认的引擎类型为 UDB 引擎。
	 */
-(id) initDatasourceConnectionInfo;

/**
	 * @brief 根据指定的参数来构造一个 DatasourceConnectionInfo 的新对象。
	 * 
	 * @param file  UDB 文件名。         
	 * @param alias  数据源别名。         
	 * @param password  密码。          
	 */
-(id) initDatasourceConnectionInfoWith:(NSString*) file alias:(NSString*)alias password:(NSString*)password;

/**
	 * @brief  获取或设置数据源别名。
	  * <p>  别名是数据源的唯一标识。该标识不区分大小写。
	 * <p> 默认值为 "UntitledDatasource"。
	 * @return 数据源别名。
	 */
@property (strong,nonatomic) NSString* alias;

/**
	 * @brief  获取或设置数据源连接的引擎类型。
             * <p> 目前提供的引擎类型包括 UDB 引擎，OGC 引擎等 ，详情请参见 EngineType 类。
	   * <p>  默认值为  UDB 。
	 * @return 数据源连接的引擎类型。
	 * @see EngineType
	 */
@property (assign,nonatomic) EngineType engineType;

/**
	 * @brief 获取或设置数据库服务器名或文件名。
	 * <p>对于UDB 文件，为其文件的名称，其中包括路径名称和文件的后缀名。特别地，此处的路径为绝对路径；
     * <p>对于 GoogleMaps 数据源，为其服务地址，其中包括路径名称和文件的后缀名。默认设置为“http://maps.google.com”,且不可更改；
     * <p>对于 SuperMap 数据源，为其服务地址；
     * <p>对于 MAPWORLD 数据源，为其服务地址,默认设置为“http://www.tianditu.cn”,且不可更改；
     * <p>对于 OGC 和 REST 数据源，为其服务地址。
	 * <p>   默认值为一个空字符串。
	 * @return 数据库服务器名或文件名。
	 */
@property (strong,nonatomic) NSString* server;

/**
 * @brief 获取或设置数据源连接所需的驱动名称。
 * <p>对于 iServer 发布的 WMTS 服务，设置的驱动名称为 WMTS,并且该属性必须调用该属性设置器驱动名称。
 * <p>   默认值为一个空字符串。
 * @return 数据源连接所需的驱动名称。
 */
@property (strong,nonatomic) NSString* driver;

/**
	 * @brief 获取或设置登录数据库的用户名。对于数据库类型数据源适用。
	 * 
	  * <p>  默认值为一个空字符串。
	 * @return 登录数据库的用户名。
	 */
@property (strong,nonatomic) NSString* user;


/**
	 *  @brief 获取或设置是否以只读方式打开数据源。如果以只读方式打开数据源，数据源的相关信息以及其中的数据都不可修改。
	 * 
	 * <p>   默认值为 false。
	 * @return 是否以只读方式打开数据源，如果以只读方式打开数据源为 true，否则为 false。
	 */
@property (assign,nonatomic) BOOL readOnly;

/**
 * @brief  获取或设置登录数据源连接的数据库或文件的密码,只对原有密码类型DEFAULT有效。
 *
 * <p>  对于 GoogleMaps 数据源，如果打开的是基于早期版本的数据源，则返回的密码为用户在 Google 官网注册后获取的密钥。
 * <p>  默认值为一个空字符串。
 * @return 登录数据源连接的数据库或文件的密码。
 */
@property (strong,nonatomic) NSString* password;

/*
 * 设置,获取 OGC数据源的坐标参考系,默认从服务上获取,优先EPSG:4326类型
 */
@property(strong,nonatomic)NSString* webCoordinate;

/**
 * @params String
 * @marks 设置,获取WMS服务的版本号
 */
@property(strong,nonatomic)NSString* webVersion;

/**
 * @params String
 * @marks 设置, 获取WMS服务的图片格式
 */
@property(strong,nonatomic)NSString* webFormat;

/**
 * @params String
 * @marks 设置,获取WMS服务的可见图层集合
 */
@property(strong,nonatomic)NSString* webVisibleLayers;

/**
 * @params
 * @marks 设置,获取WMS服务的扩展参数
 */
@property(strong,nonatomic)NSString* webExtendParam;

/**
 * @params
 * @marks 设置WMS服务的地图范围
 */
@property(nonatomic,strong)Rectangle2D* webBBox;
   /**
	 * @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
	 */
-(void) dispose;

/**
 * @brief  获取或设置登录数据源连接的数据库或文件的密码,type 加密类型，只对udb有效
 *
 * <p>  对于 GoogleMaps 数据源，如果打开的是基于早期版本的数据源，则返回的密码为用户在 Google 官网注册后获取的密钥。
 * <p>  默认值为一个空字符串。
 * @return 登录数据源连接的数据库或文件的密码。
 */
-(void)setPassword:(NSString*)passwd type:(DatasourceEncryptionType)type;

/**
 * 设置代理服务器地址和端口
 * @param address
 * @param port
 */
-(void)setProxy:(NSString*) address port:(NSString*)port;

/**
 * 获取代理服务器地址
 * @return
 */
-(NSString*)getProxyAddress;

/**
 * 获取代理服务器端口
 * @return
 */
-(NSString*)getProxyPort;
@end
