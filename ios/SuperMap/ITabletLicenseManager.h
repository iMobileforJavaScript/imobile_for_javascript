//
//  RecycleLicenseManager.h
//  MapEditDemo
//
//  Created by imobile-xzy on 17/8/21.
//  Copyright © 2017年 imobile. All rights reserved.
//

#define SUPERMAP_INTERFACE __attribute__((visibility("default")))

@class LicenseStatus;

SUPERMAP_INTERFACE
@interface LicenseFeature: NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *maxlogins;
@property(nonatomic,strong)NSString *licdata;
@end


SUPERMAP_INTERFACE
@interface LicenseInfo: NSObject
@property(nonatomic,strong)NSString *signature;//唯一表识
@property(nonatomic,strong)NSString *licmode;
@property(nonatomic,strong)NSString *version;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *user;
@property(nonatomic,strong)NSString *company;
@property(nonatomic)NSInteger licenseType;//0 离线 //1 云许可
@property(nonatomic,strong)NSMutableArray<LicenseFeature*> *features;
@end


@protocol ITabletLicenseActivateSate <NSObject>


-(void)ActivateDidEnd:(BOOL)bSuccess error:(NSString*)error;

@end

SUPERMAP_INTERFACE
@interface ITabletLicenseManager : NSObject

/**
 * 获取许可状态
 * @return 返回当前的许可状态
 */
@property(nonatomic,readonly)LicenseInfo* licenseStatus;
@property(nonatomic,readonly)BOOL isValid;
/**
 * 获取许可管理类的实例
 * @return 许可管理类实例
 */
+(ITabletLicenseManager*)getInstance;


//激活回调
@property(nonatomic)id<ITabletLicenseActivateSate> delegate;
/**
 * 查询可用模块
 * @param userSerialNumber 用户序列号
 * @return 可用模块列表
 */
-(NSArray*)query:(NSString*)userSerialNumber;

/**
 * 查询许可剩余数量
 * @param userSerialNumber 用户序列号
 * @return 许可剩余数量
 */
-(NSArray*)queryLicenseCount:(NSString*)userSerialNumber;
/**
 * 在线激活设备
 * @param userSerialNumber 用户序列号
 * @param modules 需要申请的模块列表
 * @return
 */
-(void)activateDevice:(NSString*)userSerialNumber modules:(NSArray*)modules;
-(BOOL)recycleLicense:(NSString*)phoneNumber;
-(BOOL)bindPhoneNumber:(NSString*)phoneNumber;

/**
 * 清楚本地许可文件
 * @return
 */
-(void)clearLocalLicense;

@end
