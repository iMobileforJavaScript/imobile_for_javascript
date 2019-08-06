//
//  AnimationManager.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationGO.h"


@protocol AnimationPlayDelegate <NSObject>
@optional
- (void)playBegin:(NSString*)name;
- (void)playFinish:(NSString*)name;
@end


@class AnimationGroup,Geometry;
@interface AnimationManager : NSObject


@property(nonatomic)id<AnimationPlayDelegate> delegate;

+(AnimationManager*)getInstance;

-(AnimationGO*)createAnimation:(AnimationType)type;

-(void)play;

-(void)stop;

-(void) pause;

-(void)reset;
-(void)excute;

-(void)deleteAnimationManager;
-(AnimationGroup*)addAnimationGroup:(NSString*)strgroupname;
-(void)deleteAll;
-(int)getGroupCount;
-(AnimationGroup*)getGroupByName:(NSString*)groupName;
-(AnimationGroup*)getGroupByIndex:(int)ipos;
-(BOOL)getAnimationFromXML:(NSString*)filePath;
-(BOOL)saveAnimationToXML:(NSString*)filePath;
-(Geometry*)CreateGraphicObject:(Geometry*)geo mapName:(NSString*)mapName layerName:(NSString*)layerName;

@end
