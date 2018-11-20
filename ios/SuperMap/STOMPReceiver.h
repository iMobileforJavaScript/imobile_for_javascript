//
//  STOMPReceiver.h
//  MessageQueue
//
//  Created by imobile on 15/6/9.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STOMPReceiver : NSObject

//只能获取，不能设置
@property(nonatomic,strong,readonly)NSString* clientId;
-(void)receiveMessage:(NSString**)message;
//释放资源,显示调用,如释放失败，则不能创建相同clientID 对象
-(BOOL)dispose;
@end
