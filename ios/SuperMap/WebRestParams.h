//
//  WebRestParams.h
//  HotMap
//
//  Created by imobile-xzy on 16/12/14.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebParams.h"

@interface WebRestParams : WebParams

/**
 * 设置,获取 是否直接从服务器请求缓存
 * @param enable
 */
@property(nonatomic)BOOL cacheEnable;
@end
