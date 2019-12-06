//
//  ARRangingView.h
//  SuperMapAR
//
//  Created by wnmng on 2019/11/19.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

typedef enum{
    AR_MODE_RANGING,
    AR_MODE_INDOORPOSITIONING
}AR_SESSION_MODE;

typedef enum{
    AR_INITIAL_FAILED,
    AR_SEARCHING_SURFACES,
    AR_SEARCHING_SURFACES_SUCCEED,
    AR_RUNTIME_TRACKING_PAUSED,
    AR_RUNTIME_TRACKING_STOPPED
}ARRuntimeStatus;

typedef enum{
    //AR_RED_CON,
    AR_RED_FLAG,
    AR_PIN_BOWLING
}ARFlagType ;

@protocol ARRangingDelegate <NSObject>
@optional
//总长度
-(void)onTotalLengthOfSidesChange:(double)dLen;
//视点距离
-(void)onViewPointDistanceToSurfaceChange:(double)dLen;
//当前线段长度
-(void)onCurrentToLastPointDistanceChange:(double)dLen;
//状态变化
-(void)onARRuntimeStatusChange:(ARRuntimeStatus)status;

@end



@interface ARMeasureView : ARSCNView


//开启AR场景
-(void)startARSession;
-(void)startARSessionWithMode:(AR_SESSION_MODE)mode;
//结束AR场景
-(void)stopARSession;
//捕捉量算节点  若正在量算则追加 否则重新开始量算
-(void)captureRangingNode;
//若正在量算则结束并输出结果
-(NSArray*)endRanging;
//清空内容
-(void)clearARSession;

@property(nonatomic,assign) id<ARRangingDelegate> arRangingDelegate;
//锚点旗标的类型
@property(nonatomic,assign) ARFlagType flagType;
//总长度文字显隐
@property(nonatomic,assign) BOOL isTotalLengthLabelEnable;
//视点距离文字显隐
@property(nonatomic,assign) BOOL isViewPointDistanceLabelEnable;
//当前线段长度文字显隐
@property(nonatomic,assign) BOOL isCurrentLengthLabelEnable;
//总长度
-(double)totalLengthOfSides;
//视点距离
-(double)viewPointDistanceToSurface;
//当前线段长度
-(double)currentToLastPointDistance;
//撤销 量算中可用
-(void)undo;

@end


