//
//  RecycleLicenseManager.h
//  MapEditDemo
//
//  Created by imobile-xzy on 17/8/21.
//  Copyright © 2017年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LicenseStatus;
@interface RecycleLicenseManager : NSObject

/**
 * 获取许可状态
 * @return 返回当前的许可状态
 */
@property(nonatomic,readonly)LicenseStatus* licenseStatus;

/**
 * 获取许可管理类的实例
 * @return 许可管理类实例
 */
+(RecycleLicenseManager*)getInstance;


/**
 * 查询可用模块
 * @param userSerialNumber 用户序列号
 * @return 可用模块列表
 */
-(NSArray*)query:(NSString*)userSerialNumber;

/**
 * 在线激活设备
 * @param userSerialNumber 用户序列号
 * @param modules 需要申请的模块列表
 * @return
 */
-(BOOL)activateDevice:(NSString*)userSerialNumber modules:(NSArray*)modules;

/**
 * 绑定手机号，手机号也要求唯一，则绑定失败，若uuid不存在，则绑定失败
 * @param phoneNumber 用户手机号
 * @return
 */
-(BOOL)bindPhoneNumber:(NSString*)phoneNumber;


/**
 * 归还许可，哪个不为空用哪个，若均不为空，考虑二者的匹配性
 * @param phoneNumber 通过手机号归还
 * @return
 */
-(BOOL)recycleLicense:(NSString*)phoneNumber;

/**
 * 许可升级，服务端从userSerialIDFrom回收uuid，对应许可数量减一，从userSerialIDTo激活新的许可，可用许可数量减一，本地删除许可文件
 * @param uuid 通过uuid归还
 * @param userSerialIDFrom 将要升级的序列号
 * @param userSerialIDTo 要升级到的序列号
 * @return 升级成功，返回true，否则，返回false
 */
-(BOOL)upgrade:(NSString*)userSerialIDFrom userID:(NSString*)userSerialIDTo;

/**
 * 清楚本地许可文件
 * @return
 */
-(void)clearLocalLicense;
@end
