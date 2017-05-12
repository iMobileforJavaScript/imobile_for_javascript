//
//  STOMPManager.h
//  MessageQueue
//
//  Created by imobile on 15/6/11.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STOMPReceiver;
@class STOMPSender;
@interface STOMPManager : NSObject
//连接
-(BOOL)connection:(NSString*)uri username:(NSString*)usrName password:(NSString*)passWord ;
//断开并释放资源，需要显示调用
-(void)disConnection;

-(STOMPSender*)newSender:(BOOL)useTopic name:(NSString*)name;
-(STOMPReceiver*)newReceiver:(BOOL)useTopic name:(NSString*)name clientid:(NSString*)clientID;

+(void)initializeLibrary;
+(void)shutdownLibrary;
@end
