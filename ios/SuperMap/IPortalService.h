//
//  IPortalService.h
//  LibUGC
//
//  Created by wnmng on 2019/7/25.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* 我的内容根资源。
* 通过对 myContent 资源执行 GET 请求，可以获取它的子资源的信息，
* 如我的地图、我的服务和我的账户等信息列表。
*/
typedef enum{
    MY_MAP, //我的地图
    MY_SERVICE, //我的服务
    MY_SCENE, //我的场景
    MY_DATA, //我的数据
    MY_INSIGHT, //我的洞察
    MY_MAPDASHBOARD //我的大屏
}MyContentType;

/**
 * 文件类型
 */
typedef enum  {
    DIT_AUDIO, //音频文件
    DIT_COLOR, //Color 颜色
    DIT_COLORSCHEME, //ColorScheme 颜色方案
    DIT_CSV, //csv数据
    DIT_EXCEL, //excel数据
    DIT_FILLSYMBOL, //FillSymbol 填充符号库
    DIT_GEOJSON, //geojson数据
    DIT_HBASE, //HDFS
    DIT_IMAGE, //图片类型
    DIT_JSON, //json数据,可以是普通json串。
    DIT_LAYERTEMPLATE, //LayerTemplate 图层模板
    DIT_LAYOUTTEMPLATE, //LayoutTemplate 布局模板
    DIT_LINESYMBOL, //LineSymbol 线符号库
    DIT_MAPBOXSTYLE, //MapBoxStyle文件内容，本质是json。
    DIT_MAPTEMPLATE, //MapTemplate 地图模板
    DIT_MARKERSYMBOL, //MarkerSymbol 点符号库
    DIT_MBTILES, //mbtiles
    DIT_PHOTOS, //照片
    DIT_SHP, //shp空间数据
    DIT_SMTILES, //smtiles
    DIT_SVTILES, //svtiles
    DIT_THEMETEMPLATE, //ThemeTemplate 专题图模板
    DIT_TPK, //tpk
    DIT_UDB, //udb 数据源
    DIT_UGCV5, //ugc v5
    DIT_UGCV5_MVT,
    DIT_UNKNOWN, //其他类型（普通文件）
    DIT_VIDEO, //视频文件
    DIT_WORKENVIRONMENT, //WorkEnvironment 工作环境
    DIT_WORKSPACE //工作空间 sxwu, smwu, sxw, smw
}DataItemType;

/**
 * 网络请求回调
 * 注意：网络回调的接口都在子线程中，如需更新UI需要在主线程中操作。
 *
 */

@protocol IPotalResponseDelegate <NSObject>
@required
// 请求失败的处理
-(void)onFailedException:(NSException*)exception;

@optional

-(void)onLoginFinished:(BOOL)bSucc message:(NSString*)strInfo;

-(void)mapsResult:(NSDictionary*)result;
-(void)datasResult:(NSDictionary*)result;
-(void)servicesResult:(NSDictionary*)result;
-(void)scenesResult:(NSDictionary*)result;
-(void)insightsResult:(NSDictionary*)result;
-(void)mapDashboardsResult:(NSDictionary*)result;

-(void)myMapsResult:(NSDictionary*)result;
-(void)myDatasResult:(NSDictionary*)result;
-(void)myDataIDResult:(NSDictionary*)result;
-(void)myServicesResult:(NSDictionary*)result;
-(void)myScenesResult:(NSDictionary*)result;
-(void)myInsightsResult:(NSDictionary*)result;
-(void)myMapDashboardsResult:(NSDictionary*)result;

-(void)myAccountResult:(NSDictionary*)result;
-(void)deleteMyContentItemResult:(BOOL)bSucceed;
-(void)updateMyNicknameResult:(BOOL)bSucceed;
-(void)updateMyEmailResult:(BOOL)bSucceed;
-(void)updateMyPwdQuestionResult:(BOOL)bSucceed;
-(void)updateMyPasswordResult:(BOOL)bSucceed;

-(void)getWebMapResult:(NSDictionary*)result;
-(void)updateWebMapResult:(BOOL)bSucceed;

-(void)publishServiceResult:(BOOL)bSucceed;

-(void)servicesShareConfigFinished:(BOOL)bSucceed;
-(void)upLoadDataComplite:(NSDictionary*)result;
-(void)downLoadDataComplite:(NSDictionary*)result;
@end

@protocol IPotalProgressListener <NSObject>
@optional
-(void)upLoadProgress:(float)newProgress;
-(void)downLoadProgress:(float)newProgress;
@end


@interface IPortalService : NSObject

+(id)sharedInstance;

/**
 * 添加网络请求的监听
 * @param listener
 */
@property(nonatomic) id<IPotalResponseDelegate> responseDelegate;

@property(nonatomic,strong) NSString* service;

/**
* 获取当前登录服务的主机地址
* @return
*/
@property(nonatomic,readonly) NSString* serviceHost;
/**
 * 获取当前登录服务的端口
 * @return
 */
@property(nonatomic,readonly) NSString* servicePort;
@property(nonatomic,readonly) NSString* servicePathSegments;

-(void)setHost:(NSString*)host port:(NSString *)port pathSegments:(NSString *)pathSegments;
/**
 * 用户登陆(POST)
 * @param username 用户名
 * @param password 用户密码
 * @param rememberme 是否记住
 */
-(void)loginUser:(NSString *)username password:(NSString *)password remembered:(BOOL)bRemember;
/**
 * 用户登陆(POST)
 * @param host 主机地址
 * @param port 端口号
 * @param pathSegments 路径片段
 * @param username 用户名
 * @param password 用户密码
 * @param rememberme 是否记住
 */
-(void)loginHost:(NSString*)host port:(NSString*)port pathSegments:(NSString*)pathSegments user:(NSString*)username password:(NSString*)password  remembered:(BOOL)bRemember;

/**
 * 用户登陆(POST)
 * @param portalUrl iPortal服务根地址
 * @param username 用户名
 * @param password 用户密码
 * @param rememberme 是否记住
 */
/**
 * 例：http://host:port/iportal/web
 * portal 资源是 SuperMap iPortal 提供的各个 REST 服务的根节点，是访问各个门户服务的入口
 */
-(void)loginPortalUrl:(NSString*)portalUrl user:(NSString*)username password:(NSString*)password  remembered:(BOOL)bRemember;

/**
 * 用户登出(GET)
 */
-(void)logout;

/**
 * 地图资源(GET)
 * @param searchParameter 请求参数
 */
-(void)getMaps:(NSDictionary*)searchParameter;

/**
 * 数据资源(GET)
 * @param searchParameter 请求参数
 */
-(void)getDatas:(NSDictionary*)searchParameter;

/**
 *  数据上传(POST),需要用到请求到的ID（先请求ID再上传）
 * @param path 数据完整路径
 * @param dataID 数据ID
 * @param progressListener 添加上传监听
 */
-(void)uploadData:(NSString*)path dataID:(int)dataId progressListener:(id<IPotalProgressListener>)progressListener;

/**
 * 取消当前上传任务
 */
-(void)cancelUploadData;

/**
 * 我的数据下载(GET)
 * @param dataID 数据ID
 * @param progressListener 添加下载监听
 */
-(void)downloadMyData:(int)dataID toFile:(NSString*)strFilePath progressListener:(id<IPotalProgressListener>)progressListener;

/**
 * 数据中心下载(GET)
 * @param dataID 数据ID
 * @param progressListener 添加下载监听
 */
-(void)downloadData:(int)dataID toFile:(NSString*)strFilePath progressListener:(id<IPotalProgressListener>)progressListener isMyData:(BOOL)isMy;

/**
 * 取消当前下载任务
 */
-(void)cancelDownloadData;

/**
 * 获取服务资源(GET)
 * @param searchParameter 查询参数
 */
-(void)getServices:(NSDictionary*)searchParameter;

/**
 * 获取场景资源(GET)
 * @param searchParameter 查询参数
 */
-(void)getScenes:(NSDictionary*)searchParameter;

/**
 * 获取洞察资源(GET)
 * @param searchParameter 查询参数
 */
-(void)getInsights:(NSDictionary*)searchParameter;

/**
 * 获取大屏资源(GET)
 * @param searchParameter 查询参数
 */
-(void)getMapDashboards:(NSDictionary*)searchParameter;

/**
 * 删除我的资源
 * @param type 资源类型
 * @param ID 资源ID
 */
-(void)deleteMyContentItem:(MyContentType)type id:(int)nID;

/**
 * 修改昵称(PUT)
 * @param nickname 新的昵称
 */
-(void)updateNickname:(NSString*)nickName;

/**
 * 修改密码(PUT)
 * @param newPassword 新密码
 * @param originPassword 原来的密码
 */
-(void)updatePassword:(NSString*)newPassword insteadOf:(NSString*)originPassword;

/**
 * 修改安全问题(PUT)
 * @param pwdQuestion 安全问题
 * @param pwdAnswer 问题答案
 */
-(void)updateSecurityQuestion:(NSString*)pwdQuestion answer:(NSString*)pwdAnwser;

/**
 * 修改邮箱(PUT)
 * @param email 新的邮箱地址
 */
-(void) updateEmail:(NSString*)email;

/**
 * WebMap 资源是地图的内容资源。
 * GET：获取指定地图的内容。
 * @param mapid 地图ID
 */
-(void)getWebMap:(int)mapid;

/**
 * WebMap 资源是地图的内容资源。
 * PUT：修改指定地图的内容。
 * @param mapid 地图ID
 * @param jsonRequst 字符串请求体
 */
-(void)updateWebMap:(int)mapid jsonRequst:(NSString*)jsonRequst;

/**
 * 我的地图(GET)
 * @param searchParameter 请求参数
 */
-(void)getMyMaps:(NSDictionary*)searchParameter;

/**
 * 我的数据(GET)
 * @param searchParameter 请求参数
 */
-(void)getMyDatas:(NSDictionary*)searchParameter;

/**
 * 数据上传前需要获取对应的ID(POST)
 * @param fileName 文件名称
 * @param tags 文件标签
 * @param type 文件类型
 */
-(void)getMyDataIDFor:(NSString*)fileName tag:(NSString*)tag type:(DataItemType)type;

/**
 * 获取我的服务(GET)
 * @param searchParameter 查询参数
 */
-(void)getMyServices:(NSDictionary*)searchParameter;

/**
 * 获取我的场景(GET)
 * @param searchParameter 查询参数
 */
-(void)getMyScenes:(NSDictionary*)searchParameter;

/**
 * 获取我的洞察(GET)
 * @param searchParameter 查询参数
 */
-(void)getMyInsights:(NSDictionary*)searchParameter;

/**
 * 获取我的大屏(GET)
 * @param searchParameter 查询参数
 */
-(void)getMyMapDashboards:(NSDictionary*)searchParameter;

/**
 * 获取我的账户信息(GET)
 */
-(void)getMyAccount;

/**
 * 发布服务
 */
-(void)publishServices:(int)dataid parameter:(NSDictionary *)parameter;

/**
 * 更改服务权限
 */
-(void)setServicesShareConfig:(NSArray*)arrIds parameter:(NSString*)paramJson;

@end
