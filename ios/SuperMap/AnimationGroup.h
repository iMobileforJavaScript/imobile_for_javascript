//
//  AnimationGroup.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGO.h"


@interface AnimationGroup : NSObject

@property(nonatomic,strong)NSString* name;
@property(nonatomic)double startTime;
@property(nonatomic,readonly)double duration;

-(void)addAnimation:(AnimationGO*)animationGO;
-(int)getAnimationCount;
-(AnimationGO*)getAnimationByIndex:(int)index;
-(NSArray*)getAllAnimationByGeometry:(int)geomtryID  controlName:(NSString*)controlName layerName:(NSString*)layerName;
-(NSArray*)GetAllAnimationByType:(AnimationType)type;
-(NSArray*)getAllAnimation;
// 0);//待定状态
// 1);//正在播放
// 2);//暂停播放
// 3);//停止播放
//4);//复位
-(int)getAnimationGroupPlayState;
-(BOOL)deleteAnimationByName:(NSString*)name;
@end
