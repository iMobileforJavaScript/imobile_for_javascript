//
//  DataFlowOnline.h
//  HotMap
//
//  Created by imobile-xzy on 2017/9/26.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Geometry;

//接收数据回调
@protocol DataFlowDelegate <NSObject>
@optional
- (void)onDataFlowReceive:(Geometry*)geo;
- (void)onDataFlowReceiveGeoJson:(NSString*)geoJson;
- (void)onDataFlowDidFailed:(NSError*)error;
@end


@interface DataFlowOnline : NSObject

/**
 * 设置websocket地址
 * @param wsAddress
 */
@property(nonatomic,strong)NSString* address;

//接收数据回调
@property(nonatomic)id<DataFlowDelegate> delegate;


-(void)execute;

/**
 * 登陆iServer
 *
 * @param ip       iserver地址
 * @param port     iserver端口号
 * @param userName iserver用户名
 * @param passWord iserver密码
 */
-(BOOL)login:(NSString*)ip port:(NSString*)port user:(NSString*)userName passwd:(NSString*)passWord;
@end
