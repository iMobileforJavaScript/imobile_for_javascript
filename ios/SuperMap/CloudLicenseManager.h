//
//  CloudLicenseManager.h
//  
//
//  Created by imobile-xzy on 16/12/9.
//
//

#import <Foundation/Foundation.h>

/**
 * 云许可管理类，用于管理当前设备的在线许可信息
 * 说明：	1、使用云许可前，需要先注册账户，注册地址
 * 			https://sso.supermap.com/login
 * 			2、使用云许可请保证网络良好。
 * 			3、需要在Environment.initialization(Context)之后，登录云许可。
 
 */
@class LicenseStatus;
@interface CloudLicenseManager : NSObject

/**
 * 获取许可状态
 * @return 返回当前的许可状态
 */
-(LicenseStatus*)getLicenseStatus;

/**
 * 获取许可管理类的实例
 * @return 许可管理类实例
 */
+(CloudLicenseManager*)getInstance;

/**
 * 登录云许可
 * @param userName 云许可用户名
 * @param password 云许可用密码
 * @return	 0：登录成功（或检测到有可用本地许可）；
 * 			-1：无网络连接；
 * 			-2：无法连接云许可服务器；
 * 		  	-3：登录云许可服务器失败；
 * 			-4：其它异常；
 */
-(int)login:(NSString*)userName password:(NSString*)password;

@end
