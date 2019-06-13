//
//  FlyManager.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "FlyStatus.h"
@protocol FlyManagerDelegate;
@class Routes;

/**三维场景飞行管理类。
 <p>通过该类的对象可以控制飞行中的飞行状态、飞行速度等。</p>
 */
@interface FlyManager : NSObject {
    id<FlyManagerDelegate> _flyManagerDelegate;
    Routes *_routes;
}


///当飞行状态改变时触发该委托。所实现的委托类必须符合 @c FlyManagerDelegate 的协议。
@property(nonatomic,assign)id<FlyManagerDelegate> flyManagerDelegate;


///返回或设置本次飞行（即当前整个路线）需要的总时间，单位为秒。
@property(nonatomic,readonly)double duration;


///返回或设置本次飞行的当前进度，单位为秒。
@property(nonatomic,readonly)double progress;


///返回或设置当前飞行所到的站点。
@property(nonatomic,readonly)NSInteger currentStopIndex;


///返回当前的飞行状态（停止，暂停，飞行中）。
@property(nonatomic,readonly)FlyStatus status;

///飞行路线。
@property(nonatomic,readonly)Routes *routes;

/* 播放速率 */
@property (nonatomic, readonly) double playRate;

///按照飞行路线开始飞行，或继续进行中断的飞行。
- (void)play;


///暂停当前飞行。
- (void)pause;


///停止当前飞行。
- (void)stop;

/* 更新当前飞行 */
- (void)update;



@end

@class StopArrivedEvent;
/// 飞行管理委托类。
@protocol FlyManagerDelegate <NSObject>

/**手指移过屏幕时响应该方法。当飞行状态发生改变时响应该方法。
 @param  status 飞行状态，如正在飞行、暂停飞行、飞行停止。
 */
@optional
//和苹果废弃API 命名冲突。影响APP审核，修改下
- (void)statuschanged:(FlyStatus)status;

//到达站点代理方法
- (void)stopArrivedWithFlyManager:(FlyManager *)flyManager andEvent:(StopArrivedEvent *)event;


@end