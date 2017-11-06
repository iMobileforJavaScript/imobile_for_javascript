//
//  OnlineChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/6/29.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rectangle2D;

@protocol DistributeAnalystDelegate <NSObject>
//执行分析回调
-(void)doneExecute:(BOOL)bResult datasources:(NSArray*)datasources;
@end

@interface DistributeAnalyst : NSObject

//设置数据路径
@property(nonatomic,strong)NSString* dataPath;
//设置缓存范围
@property(nonatomic,strong)Rectangle2D* bounds;
//结果返回回调
@property(nonatomic)id<DistributeAnalystDelegate> delegate;

//登录
-(void)login:(NSString*)url port:(NSString*)port name:(NSString*)userName password:(NSString*)userPassword;

//执行
-(void)execute;
@end
