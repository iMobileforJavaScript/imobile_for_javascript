//
//  OnlineTileServer.h
//  LibUGC
//
//  Created by wnmng on 2017/8/21.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MapControl;
@interface OnlineTileServer : NSObject

/** @brief 构造GL瓦片下载类OnlineTileServer
 @param  mapcontrol 关联的MapControl
 @param  strURL GL瓦片线上网络地址
 @param  strPath GL瓦片本地缓存路径。
 */
-(id)initWithMapControl:(MapControl*)mapControl URL:(NSString*)strURL CachePath:(NSString*)strPath;

@end
