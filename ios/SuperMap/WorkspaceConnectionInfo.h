//
//  WorkspaceConnectionInfo.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

// object-c
#import "WorkspaceType.h"
#import "WorkspaceVersion.h"

/** 工作空间连接信息类。
 * 
 * <P>包括了进行工作空间连接的所有信息，如所要连接的服务器名称，数据库名称，用户名，密码等。对不同类型的工作空间，其连接信息有所区别，所以在使用该类所包含的成员时，请注意该成员所适用的工作空间类型。
 */
@interface WorkspaceConnectionInfo : NSObject{
@private
    BOOL _readOnly;
}


///构造一个新的 WorkspaceConnectionInfo 对象，默认的类型为默认工作空间。
-(id) init;

/** 根据指定的参数来构造一个 WorkspaceConnectionInfo 的新对象。
     * 
     * @param fileName 工作空间文件路径名。
     */
-(id) initWithFile:(NSString*) fileName;


 /** 获取或设置工作空间在数据库中的名称。对文件型的工作空间，此名称设为空。默认值为空字符串。
     *  
     *@return 工作空间在数据库中的名称。
     */
@property (strong,nonatomic) NSString* name;

 /** 获取或设置工作空间的类型。
     * 
      *  工作空间可以存储在文件中，也可以存储在数据库中。目前支持的文件型的工作空间的类型为 SXW,SMW,SXWU,SMWU,DEFAULT。
      *   默认值为 SM_DEFAULT 。
     * @return 工作空间的类型。
     */
@property (assign,nonatomic) WorkspaceType type;

 /** 获取或设置登录数据库的用户名。对数据库类型工作空间适用。
     * 
     *   默认值为空字符串。
     * @return 登录数据库的用户名。
     */
@property (strong,nonatomic) NSString* user;

/** 返回登录工作空间连接的数据库或文件的密码。
     * 
     * 此密码的设置只对 Oracle 和 SQL 数据源有效，对本地（SDBPlus 和 UDB）数据源无效。
     *  默认值为空字符串。
     * @return 登录工作空间连接的数据库或文件的密码。
     */
@property (strong,nonatomic) NSString* password;

 /** 获取或设置文件名。
     *  
      *  <p>对于 工作空间文件，为其文件名称，其中包括路径名称和文件的后缀名。特别地，此处的路径为绝对路径。
      *  <p>默认值为空字符串。
     * @return 文件的路径名。
     */
@property (strong,nonatomic) NSString* server;

 /** 获取或设置工作空间的版本。
     * 
      *  <p>  默认值为 UGC20。
     * @return 工作空间的版本。
     */
@property (assign,nonatomic) WorkspaceVersion version;

 /**
     * @brief 释放该对象所占用的资源。调用该方法之后，此对象不再可用。
     */
-(void) dispose;

/**
 *  @brief 将当前工作空间链接信息对象输出为格式字符串
 *  <p>其格式为{Name="",Type="",Server="",Database="",Driver="",User="",Password="",Version=""}
 *  @return 当前工作空间链接信息
 */
-(NSString *) toString;
@end
