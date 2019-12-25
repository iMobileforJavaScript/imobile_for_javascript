//
//  ObjectTracker.m
//  SuperMapAI
//
//  Created by wnmng on 2019/12/4.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import "ObjectTracker.h"
#import "TensorflowTrackNative.h"

//#define MAX_DEBUG_HISTORY_SIZE  30
#define MAX_FRAME_HISTORY_SIZE  200
#define DOWNSAMPLE_FACTOR  2


@interface FrameChange : NSObject

@end

@interface TimestampedDeltas : NSObject

@end


@interface ObjectTracker(){
    int _frameWidth;
    int _frameHeight;
    //BOOL alwaysTrack;
    NSMutableDictionary<NSString*,TrackedObject*> *_dicTrackedObjects;
    //NSMutableArray<TimestampedDeltas*> *_timestampedDeltas;
    
    int _rowStride;
    //float matrixValues[9];
    //float[] matrixValues = new float[9];
    long _lastTimestamp;
    //FrameChange* lastKeypoints;
    Byte* _downsampledFrame; // 降低采样的frame
    long _downsampledTimestamp;
    
    TensorflowTrackNative *_trackerNative;
    
}

-(void)addTrackedObjects:(TrackedObject*)object forKey:(NSString*)strid;

-(void)registerInitialAppearance:(CGRect)position ID:(NSString*)strid  data:(Byte*)data;

-(float)getCurrentCorrelation:(NSString*)strid;

-(void)forget:(NSString*)strID;



@end

@implementation ObjectTracker

-(BOOL)isInitWithW:(int)width H:(int)height{
    return (_frameWidth==width && _frameHeight==height);
}

-(id)initWithW:(int)frameW H:(int)frameH {
    if (self = [super init]) {
        _downsampledTimestamp = -1;
        _frameWidth = frameW;
        _frameHeight = frameH;
        _rowStride = frameW;
        
        //alwaysTrack = bTrack;
        //timestampedDeltas = [[NSMutableArray alloc]init];
        
        
        _downsampledFrame = new Byte[(_frameWidth + DOWNSAMPLE_FACTOR - 1)/ DOWNSAMPLE_FACTOR * (_frameHeight + DOWNSAMPLE_FACTOR - 1)/ DOWNSAMPLE_FACTOR];
        
        _dicTrackedObjects = [[NSMutableDictionary alloc]init];
        
        _trackerNative =[ [TensorflowTrackNative alloc]  initNativeW:_frameWidth/DOWNSAMPLE_FACTOR H:_frameHeight/DOWNSAMPLE_FACTOR always:YES];
    }
    return self;
}

-(void)dispose{
    if (_trackerNative!=nil) {
        [_trackerNative releaseNative];
        _trackerNative = nil;
    }
    if (_downsampledFrame!=NULL) {
        delete[] _downsampledFrame;
        _downsampledFrame = NULL;
    }
    [_dicTrackedObjects removeAllObjects];
    _frameWidth = 0;
    _frameHeight = 0;
    _rowStride = 0;
    
}

-(CGRect) downscaleRect:(CGRect)rect{
    return CGRectMake(rect.origin.x/DOWNSAMPLE_FACTOR,
                      rect.origin.y/DOWNSAMPLE_FACTOR,
                      rect.size.width/DOWNSAMPLE_FACTOR,
                      rect.size.height/DOWNSAMPLE_FACTOR);
}

-(CGRect)upScale:(CGRect)rect{
    return CGRectMake(rect.origin.x*DOWNSAMPLE_FACTOR,
                      rect.origin.y*DOWNSAMPLE_FACTOR,
                      rect.size.width*DOWNSAMPLE_FACTOR,
                      rect.size.height*DOWNSAMPLE_FACTOR);
}

-(void)registerInitialAppearance:(CGRect)position ID:(NSString*)strid  data:(Byte*)data{
    CGRect externalPosition = [self downscaleRect:position];
    [_trackerNative registerNewObjectWithAppearanceNative:strid
                                                       x1:externalPosition.origin.x
                                                       y1:externalPosition.origin.y
                                                       x2:externalPosition.origin.x+externalPosition.size.width
                                                       y2:externalPosition.origin.y+externalPosition.size.height
                                                     data:data];
}

-(void)setPreviousPosition:(CGRect)position ID:(NSString*)strid time:(long)timestamp{
    CGRect externalPosition = [self downscaleRect:position];
    [_trackerNative setPreviousPositionNative:strid
                                           x1:externalPosition.origin.x
                                           y1:externalPosition.origin.y
                                           x2:externalPosition.origin.x+externalPosition.size.width
                                           y2:externalPosition.origin.y+externalPosition.size.height
                                    timestamp:timestamp];
}

-(CGRect)getTrackedPositionNative:(NSString*)strid{
    return  [self upScale: [_trackerNative getTrackedPositionNative:strid]];
}

-(BOOL)isVisable:(NSString*)strid{
    return [_trackerNative isObjectVisible:strid];
}

-(void)addTrackedObjects:(TrackedObject *)object forKey:(NSString *)strid{
    [_dicTrackedObjects setValue:object forKey:strid];
}

-(void)nextFrame:(Byte *)frameData time:(long)timestamp{
    if (_downsampledTimestamp != timestamp) {
        //  重采样
        [_trackerNative downsampleImageNativeW:_frameWidth H:_frameHeight rowStrid:_rowStride input:frameData factor:DOWNSAMPLE_FACTOR output:_downsampledFrame];
        _downsampledTimestamp = timestamp;
    }
    
    Byte*uvData = NULL;
    [_trackerNative nextFrameNative:_downsampledFrame uv:uvData time:_downsampledTimestamp];
    
//    timestampedDeltas.add(new TimestampedDeltas(timestamp, getKeypointsPacked(DOWNSAMPLE_FACTOR)));
//      while (timestampedDeltas.size() > MAX_FRAME_HISTORY_SIZE) {
//        timestampedDeltas.removeFirst();
//      }
   //NSArray *arrTrackedObjects = _dicTrackedObjects
    for (NSString* key in _dicTrackedObjects) {
        TrackedObject *trackedObject = [_dicTrackedObjects objectForKey:key];
        [trackedObject updateTrackedPosition];
    }
    
    _lastTimestamp = timestamp;
}

-(float)getCurrentCorrelation:(NSString*)strid{
    return [_trackerNative getCurrentCorrelation:strid];
}

-(void)forget:(NSString *)strID{
    [_trackerNative forgetNative:strID];
    [_dicTrackedObjects removeObjectForKey:strID];
}

-(TrackedObject*)trackedobject:(CGRect)position time:(long)timestamp data:(Byte*)data{
   if (_downsampledTimestamp != timestamp) {
        //  重采样
        [_trackerNative downsampleImageNativeW:_frameWidth H:_frameHeight rowStrid:_rowStride input:data factor:DOWNSAMPLE_FACTOR output:_downsampledFrame];
        _downsampledTimestamp = timestamp;
    }
    return [[TrackedObject alloc] initWith:self position:position time:_downsampledTimestamp data:_downsampledFrame];
}

@end


@interface TrackedObject(){
    ObjectTracker* _tracker;
    NSString *_strID;
    BOOL _isDead;
    long _lastExternalPositionTime;
    
    CGRect _lastTrackedPosition;
    BOOL _visibleInLastFrame;
}

@end

@implementation TrackedObject

-(id)initWith:(ObjectTracker*)tracker position:(CGRect)position time:(long)timestamp data:(Byte*)data{
    if (self = [super init]) {
        _tracker = tracker;
        _isDead = false;
        _strID = [NSString stringWithFormat:@"%ld",(long)self];
        _lastExternalPositionTime = timestamp;
        
        [_tracker registerInitialAppearance:position ID:_strID data:data];
        [self setPreviousPosition:position time:timestamp];
        [_tracker addTrackedObjects:self forKey:_strID];
    }
    return self;
}

-(void)setPreviousPosition:(CGRect)position time:(long)timestamp{
    if (_lastExternalPositionTime>timestamp) {
        return;
    }
    _lastExternalPositionTime = timestamp;
    
    [_tracker setPreviousPosition:position ID:_strID time:timestamp];
    
    [self updateTrackedPosition];
}

-(void)updateTrackedPosition{
    _lastTrackedPosition = [_tracker getTrackedPositionNative:_strID];
    _visibleInLastFrame = [_tracker isVisable:_strID];
}

-(CGRect)getTrackedPositionInPreviewFrame{
    return _lastTrackedPosition;
}

-(long)getLastExternalPositionTime{
    return _lastExternalPositionTime;
}

-(BOOL)visibleInLastPreviewFrame{
    return _visibleInLastFrame;
}

-(float)getCurrentCorrelation{
    return [_tracker getCurrentCorrelation:_strID];
}

-(void)stopTracking{
    _isDead = YES;
    [_tracker forget:_strID];
}

@end
