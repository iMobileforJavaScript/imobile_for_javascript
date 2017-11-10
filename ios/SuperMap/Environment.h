//
//  Environment.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//



#ifndef SM_iMobile_Environment_h
#define SM_iMobile_Environment_h

#import <Foundation/Foundation.h>
#import "EngineType.h"
	///该类定义了SuperMap iMobile 7C for iOS支持的模块类型常量。

/**
 * 核心开发模块，包括数据管理、地图浏览和编辑、基础GIS功能等
 */
extern const NSString* CORE_DEV ;
/**
 * 核心运行模块，包括数据管理、地图浏览和编辑、基础GIS功能等
 */
extern const NSString* CORE_RUNTIME ;
/**
 * 传统导航开发模块，包括路径规划、导航引导等
 */
extern const NSString* NAVIGATION_DEV ;
/**
 * 传统导航运行模块，包括路径规划、导航引导等
 */
extern const NSString* NAVIGATION_RUNTIME ;
/**
 * 三维场景开发模块
 */
extern const NSString* MAP3D_DEV ;
/**
 * 三维场景运行模块
 */
extern const NSString* MAP3D_RUNTIME ;

/**
 * 二维标绘开发模块
 */
extern const NSString* PLOT_DEV  ;

/**
 * 二维标绘运行模块
 */
extern const NSString* PLOT_RUNTIME ;

//810新增模块
/**
 * 行业导航开发模块
 */
extern const NSString* INDUSTRY_NAVIGATION_DEV ;
extern const NSString* INDUSTRY_NAVIGATION_RUNTIME ;

/**
 * 室内导航开发模块
 */
extern const NSString* INDOOR_NAVIGATION_DEV ;
extern const NSString* INDOOR_NAVIGATION_RUNTIME ;

/**
 * 三维标绘开发模块
 */
extern const NSString* PLOT3D_DEV ;
extern const NSString* PLOT3D_RUNTIME ;

/**
 * 三维分析开发模块
 */
extern const NSString* REALPLACE_ANALYST_DEV ;
extern const NSString* REALPLACE_ANALYST_RUNTIME ;

/**
 * 三维特效开发模块
 */
extern const NSString* REALPLACE_EFFECT_DEV ;
extern const NSString* REALPLACE_EFFECT_RUNTIME ;


 /**
     * @brief 默认零值判断最大精度。系统给定的精度范围的上界，为公有静态只读字段，用户不能修改。
 <p> 默认值为 1E-10。
          */
extern const double DEFAULT_MAX_EQUAL_ZERO_PRECISION ;

 /**
     * @brief 默认零值判断最小精度。系统给定的精度范围的下界，为公有静态只读字段，用户不能修改。
 <p>  默认值为 -1E-10。
     */
extern const double DEFAULT_MIN_EQUAL_ZERO_PRECISION ;

 /**
     * @brief 返回判断一个单精度或者双精度数是否为零的最大判断精度。如果返回或设置的数值在最小判断精度(MinEqualPrecision)和最大判断精度(MaxEqualPrecision)精度范围之间，就认为它为0。即设 a 为返回或设置的数值，那么当 a 大于等于 MinEqualPrecision 且小于等于 MaxEqualPrecision 时，则认为 a 为0。注意：事实上，MaxEqualPrecision 应该大于等于 MinEqualPrecision，但目前版本的组件代码暂时不对此进行控制。
      * <p>  默认值为 1E-10。
     * @return 判断一个单精度或者双精度数是否为零的判断最大精度。
     */
extern const double maxEqualZeroPrecision ;

/**
     * @brief 返回判断一个单精度或者双精度数是否为零的最小判断精度。如果返回或设置的数值在最小判断精度(MinEqualPrecision)和最大判断精度(MaxEqualPrecision)精度范围之间，就认为它为0。即设 a 为返回或设置的数值，那么当 a 大于等于 MinEqualPrecision 且小于等于 MaxEqualPrecision 时，则认为 a 为0。注意：事实上，MaxEqualPrecision 应该大于等于 MinEqualPrecision，但目前版本的组件代码暂时不对此进行控制。
       * <p>   默认值为 -1E-10。
     * @return 判断一个单精度或者双精度数是否为零的判断最小精度。
     */
extern const double minEqualZeroPrecision ;


@protocol LicenseActivationDelegate;
@class PermissionToolKit;
@class LicenseStatus;
/**
 * @brief  关于开发环境的一些配置信息管理类，比如设置缓存目录、设置零值判断精度等功能，通过此类还可以设置像素与逻辑坐标的比例。 </p>
 *
 */
@interface Environment : NSObject

/**
 * 设置外挂字体路径
 */
+(void)setFontsPath:(NSString*)fontsPath;
/// 设置许可激活回调。
+(void)setLicenseDelegate:(id<LicenseActivationDelegate>)delegate;

/**@brief  根据指定的参数构造一个新的Environment对象。
 @param  cachePath 指定的存放网络地图缓存的路径。
 */
+ (void)initWebCachePath:(NSString *)cachePath;

/**@brief 清除下载的网络地图缓存
@param  type 网络数据类型（其他的非网络地图类型不能删除缓存）。
 */
+ (BOOL)clearWebCacheWithType:(EngineType)type;

 /**@brief  判断是否根据制定的存放网络地图缓存的路径构造了新的Environment对象。
 @return  一个布尔值，true表示根据指定的参数构造了新对象，false,表示没有根据指定的参数构造新对象。
	 */
+ (BOOL)isInitWebCachePath;

/**
 * 设置用户序列号和许可模块
 * @param userSerialNumber 用户序列号
 * @param modules 需要申请的模块列表
 * @return
 */
+(void)setUserLicInfo:(NSString *)userSerialNumber Modules:(NSArray *)modules;

/**
 * 在线激活设备
 * @return
 */
+(BOOL)activateDevice;

/**
 * 验证许可码，用于手动输入和在线注册
 * @param licCode
 * @return
 */
+(LicenseStatus*)verifyLicenseCode:(NSString*)licCode;
/**
 * 放置许可文件存放路径
 * @param path
 */
+(void)setLicensePath:(NSString*)path;

//0:DEVICEID 1:UUID
+(void)setLicenseType:(int)type;
+(int)getLicenseType;
/**
 * 获取许可状态
 * @return 返回当前的许可状态
 */
+(LicenseStatus *)getLicenseStatus;
+(NSString *)getVersion;
+(BOOL)isOpenGLMode;
+(void)setOpenGLMode:(BOOL)bOpenGLMode;
+(double)mainScreenScale;

+(void)setPrintWMSLog:(BOOL)bPrintWMSLog;
@end


///许可激活回调。

@protocol LicenseActivationDelegate <NSObject>

/**  许可激活回调函数，激活成功时返回。
 @param  licStatus  许可状态信息。
     */
-(void)activateSucceed:(LicenseStatus *)licStatus;

/** 许可激活回调函数，激活失败时返回。
 @param  errorInfo  许可激活失败错误信息。
     */
-(void)activateFailed:(NSString *)errorInfo;   

@end

#endif
