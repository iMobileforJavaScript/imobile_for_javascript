//
//  OnlineChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/6/29.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class Rectangle2D;

@protocol DistributeAnalystDelegate <NSObject>
/**
 * 执行分析回调
 */
-(void)doneExecute:(BOOL)bResult datasources:(NSArray*)datasources;
//////////////////////////////// add by-lucd 2018.2.8

/**
 * 执行失败
 */
-(void)doneExecuteFailed:(NSString *) errorInfo;
@end
/**
*  分布式分析服务基类
*/
@interface DistributeAnalyst : NSObject

////设置数据路径
//@property(nonatomic,strong)NSString* dataPath;
////设置缓存范围
//@property(nonatomic,strong)Rectangle2D* bounds;

/**
 * 添加在线数据可视化监听器。
 *
 */
@property(nonatomic)id<DistributeAnalystDelegate> delegate;

/**
 * 登陆iServer
 *
 * @param ip       iserver IP
 * @param port     iserver 端口号
 * @param name     iserver 用户名
 * @param password iserver 密码
 */
-(void)login:(NSString*)ip port:(NSString*)port name:(NSString*)name password:(NSString*)userPassword;

/**
 * 执行分析
 */
-(void)execute;
@end
