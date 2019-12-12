//
//  ObjectTracker.h
//  SuperMapAI
//
//  Created by wnmng on 2019/12/4.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class TrackedObject;

@interface ObjectTracker : NSObject

-(id)initWithW:(int)frameW H:(int)frameH ;

-(void)dispose;

-(BOOL)isInitWithW:(int)width H:(int)height;

-(void)nextFrame:(Byte*)frameData time:(long)timestamp;


-(NSArray*)drawRectArray;

-(TrackedObject*)trackedobject:(CGRect)position time:(long)timestamp data:(Byte*)data;

@end

@interface TrackedObject : NSObject
-(id)initWith:(ObjectTracker*)tracker position:(CGRect)position time:(long)timestamp data:(Byte*)data;
-(void)updateTrackedPosition;
-(float)getCurrentCorrelation;
-(void)stopTracking;
-(CGRect)getTrackedPositionInPreviewFrame;
@end


NS_ASSUME_NONNULL_END
