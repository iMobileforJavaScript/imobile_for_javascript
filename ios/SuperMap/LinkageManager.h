//
//  LinkageManager.h
//  LibUGC
//
//  Created by imobile-xzy on 15/12/29.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MapControl;
@interface LinkageManager : NSObject
//设置 "开启"，"关闭" 联动功能。
@property(nonatomic,assign)BOOL isLinkage;

//根据 传入mapcontrol列表初始化 
-(id)initWithMapControls:(NSArray*)mapControls;
//添加mapcontrol到联动列表
-(void)addMapControl:(MapControl*)mapControl;
//从联动列表删除mapcontrol
-(void)removeMapControl:(MapControl*)mapControl;
//销毁对象
-(void)dispose;
@end
