//
//  ARCollectorView.h
//  Supermap
//
//  Created by wnmng on 2020/2/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol arLengthChangeDelegate <NSObject>

-(void)onLengthChange:(float)length;

@end


@interface ARCollectorView : UIView

//开始采集
-(void)addNewRoute;
//停止采集
-(void)saveCurrentRoute;
//采集当前点
-(NSArray*)collectCurrentPoint;
//清除当前route
-(void)clearCurrentRoute;
//
-(NSArray*)currentRoutePoints;
//新增路线
-(void)routeAdd;
//从数据读到当前点串
-(void)loadPoseData:(NSArray*)arrData;

//清除所有点
-(void)clearPoseData;

-(void)startCollect;
-(void)dispose;

@property(nonatomic,assign) id<arLengthChangeDelegate> delegate;

-(void)currentPosX:(float *)x y:(float *)y z:(float *)z angle:(float *)w;

@end


