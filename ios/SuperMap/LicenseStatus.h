//
//  LicenseStatus.h
//  prjTest
//
//  Created by imobile on 14-3-26.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 许可状态类
 */
@interface LicenseStatus : NSObject{

    BOOL _isLicenseValid;            //  是否注册成功
    BOOL _isTrailLicense;            //  是否试用许可
    NSString *_startDate;              //  开始日期
    NSString *_expireDate;             //  终止日期
    long _version;                   //  版本
    BOOL _isLicenseExsit;            //  是否包含许可
    NSString *_terminalSerialNumber; //  获取设备终端序列号
}

/**
 * 许可是否有效
 * @return
 */
@property(nonatomic,assign,readonly)BOOL isLicenseValid;
/**
 * 是否是试用许可
 * @return
 */
@property(nonatomic,assign,readonly)BOOL isTrailLicense;
/**
 * 获取许可开始日期
 * @return
 */
@property(nonatomic,retain,readonly)NSString *startDate;
/**
 * 获取许可终止日期
 * @return
 */
@property(nonatomic,retain,readonly)NSString *expireDate;
/**
 * 获取许可版本
 * @return
 */
@property(nonatomic,assign,readonly)long version;
/**
 * 是否存在许可
 * @return
 */
@property(nonatomic,assign,readonly)BOOL isLicenseExsit;

/**
 * 许可是否激活
 * @return
 */
@property(nonatomic,readonly)BOOL isActivated;
/**
 * 获取设备终端序列号
 * @return
 */
@property(nonatomic,copy,readonly)NSString *terminalSerialNumber;

-(id)initWithLicense:(BOOL)isRegister IsTrailLicense:(BOOL)isTrailLicense Version:(long)version StartDate:(NSString *)startDate ExpireDate:(NSString *)expireDate IsLicenseExsit:(BOOL)isLicenseExsit terminalSerialNumber:(NSString *)terminalNum;

-(NSString *)toString;

@end
