//
//  tensorflowTrackNative.h
//  tensorflow_tracking
//
//  Created by wnmng on 2019/12/4.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface TensorflowTrackNative : NSObject

-(id)initNativeW:(int)frameW H:(int)frameH always:(BOOL)bTrack;

-(void)releaseNative;

-(void)registerNewObjectWithAppearanceNative:(NSString*)object_id x1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 data:(Byte*)frameData;

-(void)setPreviousPositionNative:(NSString*)object_id x1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 timestamp:(long)timestamp;

-(void)setCurrentPositionNative:(NSString*)object_id x1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2;

-(BOOL)haveObject:(NSString*)object_id;

-(BOOL)isObjectVisible:(NSString*)object_id;

-(NSString*)getModelIdNative:(NSString*)object_id;

-(float)getCurrentCorrelation:(NSString*)object_id;

-(float)getMatchScore:(NSString*)object_id;

-(CGRect)getTrackedPositionNative:(NSString*)object_id;

-(void)nextFrameNative:(Byte*)y_data uv:(Byte*)uv_data time:(long)timestamp;

-(void)forgetNative:(NSString*)object_id;

-(NSArray*)getKeypointsNative:(NSString*)object_id;

-(void)getKeypointsPacked;

-(CGRect)getCurrentPositionNative:(long)timestamp x1:(float)position_x1 y1:(float)position_y1 x2:(float)position_x2 y2:(float)position_y2;

-(void)drawNative;

-(void)downsampleImageNativeW:(int)width H:(int)height rowStrid:(int)row_stride input:(Byte*)input factor:(int)factor output:(Byte*)output;

+(void)convertARGB8888:(Byte*)inpute ToYUV420SP:(Byte*)output w:(int)width h:(int)height;

@end

NS_ASSUME_NONNULL_END
