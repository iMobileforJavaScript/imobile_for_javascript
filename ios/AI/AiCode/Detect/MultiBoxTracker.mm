//
//  MultiBoxTracker.m
//  SuperMapAI
//
//  Created by wnmng on 2019/12/4.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import "MultiBoxTracker.h"
#import <UIKit/UIKit.h>
#import "ObjectTracker.h"
#import "AIRecognition.h"
#import "TensorflowTrackNative.h"

#define  MIN_CORRELATION 0.2f
#define MARGINAL_CORRELATION 0.75f
#define MAX_OVERLAP 0.2f

@interface TrackedRecognition : NSObject

@property (nonatomic,strong) TrackedObject* trackedObject;

@property (nonatomic,assign) float detectionConfidence;

@property (nonatomic,assign) CGRect location;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) int count;

@end

@implementation TrackedRecognition

@synthesize trackedObject,location,detectionConfidence,color,title,count;

@end




@interface MultiBoxTracker(){
    ObjectTracker *_objectTrackerInstance;
    Byte * _frameData;
    long _timestamp;
    NSMutableArray<UIColor*> *_arrColors;
    NSMutableArray<TrackedRecognition*> *_arrTrackedObjects;
    NSMutableDictionary<NSString*,NSNumber*> *_dicTrackNum;
}

@end

@implementation MultiBoxTracker

static NSArray *_arrColors = nil;
-(NSArray*)colors{
    
    if (_arrColors==nil) {
        NSMutableArray* array=[[NSMutableArray alloc] init];
        //    [array addObject:[UIColor grayColor]];
            [array addObject:[UIColor redColor]];
            [array addObject:[UIColor greenColor]];
            [array addObject:[UIColor blueColor]];
            [array addObject:[UIColor cyanColor]];
            [array addObject:[UIColor yellowColor]];
            [array addObject:[UIColor magentaColor]];
            [array addObject:[UIColor orangeColor]];
            [array addObject:[UIColor purpleColor]];
            [array addObject:[UIColor brownColor]];
        [array addObject:[UIColor colorWithRed:0.5 green:0.8 blue:0.3 alpha:1]];
        [array addObject:[UIColor colorWithRed:0.4 green:0.6 blue:0.8 alpha:1]];
        [array addObject:[UIColor colorWithRed:0.2 green:0.9 blue:0.7 alpha:1]];
        [array addObject:[UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:1]];
        [array addObject:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [array addObject:[UIColor colorWithRed:0.9 green:0.2 blue:0.3 alpha:1]];
        [array addObject:[UIColor colorWithRed:0.3 green:0.8 blue:0.9 alpha:1]];
        _arrColors = array;
    }

    return _arrColors;
}

-(id)init{
    if (self = [super init]) {
        _timestamp = 0;
        
        NSMutableArray* array=[[NSMutableArray alloc] init];
               //    [array addObject:[UIColor grayColor]];
                   [array addObject:[UIColor redColor]];
                   [array addObject:[UIColor blueColor]];
                   [array addObject:[UIColor cyanColor]];
                   [array addObject:[UIColor yellowColor]];
                   [array addObject:[UIColor magentaColor]];
                   [array addObject:[UIColor orangeColor]];
                   [array addObject:[UIColor purpleColor]];
                   [array addObject:[UIColor brownColor]];
                [array addObject:[UIColor greenColor]];
               [array addObject:[UIColor colorWithRed:0.5 green:0.8 blue:0.3 alpha:1]];
               [array addObject:[UIColor colorWithRed:0.4 green:0.6 blue:0.8 alpha:1]];
               [array addObject:[UIColor colorWithRed:0.2 green:0.9 blue:0.7 alpha:1]];
               [array addObject:[UIColor colorWithRed:0.9 green:0.5 blue:0.2 alpha:1]];
               [array addObject:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
               [array addObject:[UIColor colorWithRed:0.9 green:0.2 blue:0.3 alpha:1]];
               [array addObject:[UIColor colorWithRed:0.3 green:0.8 blue:0.9 alpha:1]];
        _arrColors = array;
        
        _arrTrackedObjects = [[NSMutableArray alloc]init];
        _dicTrackNum = [[NSMutableDictionary alloc]init];
    }
    return self;
}


-(NSArray*)track:(NSArray *)result with:(nonnull CVPixelBufferRef)pixelBuffer{
    //跟踪处理
    //int imageChannels = 4;
    int width = (int)CVPixelBufferGetWidth(pixelBuffer);
    int height = (int)CVPixelBufferGetHeight(pixelBuffer);
    //size_t inputImageRowBytes = CVPixelBufferGetBytesPerRow(pixelBuffer);
       
    if (_objectTrackerInstance!=nil && ![_objectTrackerInstance isInitWithW:width H:height]) {
        [_objectTrackerInstance dispose];
        _objectTrackerInstance = nil;
        if (_frameData!=NULL) {
            delete[] _frameData;
            _frameData = NULL;
        }
    }
    
    if (_objectTrackerInstance==nil) {
        _objectTrackerInstance = [[ObjectTracker alloc]initWithW:width H:height];
        _frameData = new Byte[3 * width * height]; //(Byte*)malloc(3 * width * height);
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
       
    Byte* rgba = (Byte*)CVPixelBufferGetBaseAddress(pixelBuffer);

    [TensorflowTrackNative convertARGB8888:rgba ToYUV420SP:_frameData w:width h:height];

    CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    
    //时间戳
    _timestamp++;
    
    [self onFrameW:width H:height rowStride:width frame:_frameData time:_timestamp];
    
    [self trackResults:result frame:_frameData time:_timestamp W:width H:height];
    

    NSMutableArray<AIRecognition*> *arrReslt = [[NSMutableArray alloc]init];
    
    for (int i=0; i<_arrTrackedObjects.count; i++) {
        TrackedRecognition *trackedRecognition = [_arrTrackedObjects objectAtIndex:i];
        AIRecognition *regTemp = [[AIRecognition alloc]init];
        regTemp.label = trackedRecognition.title;
        regTemp.confidence = trackedRecognition.detectionConfidence;
        regTemp.displayColor = trackedRecognition.color;
        //regTemp.rect = trackedRecognition.location;
        CGRect rectTemp = [trackedRecognition.trackedObject getTrackedPositionInPreviewFrame];
        regTemp.rect = CGRectMake(rectTemp.origin.x/width,
                                  rectTemp.origin.y/height,
                                  rectTemp.size.width/width,
                                  rectTemp.size.height/height);
        //regTemp.count = [[_dicTrackNum objectForKey:trackedRecognition.title] intValue];
        regTemp.count = trackedRecognition.count;
        [arrReslt addObject:regTemp];
    }
    
    return arrReslt;
}


-(void)onFrameW:(int)w H:(int)h rowStride:(int)rowStride frame:(Byte*)frame time:(long)timestamp{
    
    [_objectTrackerInstance nextFrame:frame time:timestamp];
    // Clean up any objects not worth tracking any more.
    for (NSInteger i=_arrTrackedObjects.count-1; i>=0; i--) {
        TrackedRecognition *recognition = [_arrTrackedObjects objectAtIndex:i];
        float correlation = [recognition.trackedObject getCurrentCorrelation];
        if (correlation <  MIN_CORRELATION) {
            [[recognition trackedObject] stopTracking];
            [_arrTrackedObjects removeObjectAtIndex:i];
            [_arrColors addObject:recognition.color];
        }
    }
    
    
}

-(void)trackResults:(NSArray*)results frame:(Byte*)frame time:(long)timestamp W:(int)width H:(int)height{
    
    for (int i=0; i<results.count; i++) {
        
        AIRecognition *recognition = [results objectAtIndex:i];
        
        [self handleDetection:recognition frame:frame time:timestamp W:width H:height];
        
    }
    
    
}

-(void)handleDetection:(AIRecognition *)recognition frame:(Byte*)frame time:(long)timestamp W:(int)width H:(int)height{
    
    CGRect position = CGRectMake(recognition.rect.origin.x*width,
                                 recognition.rect.origin.y*height,
                                 recognition.rect.size.width*width,
                                 recognition.rect.size.height*height);
//    TrackedObject *potentialObject = [[TrackedObject alloc]initWith:_objectTrackerInstance
//                                                           position:position
//                                                               time:_timestamp
//                                                               data:_frameData];
    TrackedObject *potentialObject = [_objectTrackerInstance trackedobject:position
                                                                      time:_timestamp
                                                                      data:_frameData];
    
    float potentialCorrelation = [potentialObject getCurrentCorrelation];
    
    if (potentialCorrelation < MARGINAL_CORRELATION) {
        [potentialObject stopTracking];
        return;
    }
    
    NSMutableArray*removeList =[[NSMutableArray alloc]init];

    float maxIntersect = 0.0f;

    TrackedRecognition* recogToReplace = nil;
    
    //for (NSInteger k = _arrTrackedObjects.count-1; k>=0; k--)
    for (NSInteger k = 0; k < _arrTrackedObjects.count; k++) {
        TrackedRecognition *trackedRecognition = [_arrTrackedObjects objectAtIndex:k];
        
        CGRect a = [trackedRecognition.trackedObject getTrackedPositionInPreviewFrame];
        CGRect b = [potentialObject getTrackedPositionInPreviewFrame];
        
        BOOL intersects = CGRectIntersectsRect(a, b);
        CGRect intersection = CGRectIntersection(a, b);
        
        float intersectArea = intersection.size.width * intersection.size.height;
        float totalArea = a.size.width * a.size.height + b.size.width * b.size.height - intersectArea;
        float intersectOverUnion = intersectArea / totalArea;
        
        if (intersects && intersectOverUnion > MAX_OVERLAP) {
            if (recognition.confidence < trackedRecognition.detectionConfidence &&
                [trackedRecognition.trackedObject getCurrentCorrelation] > MARGINAL_CORRELATION) {
                [potentialObject stopTracking];
                return;
            }else{
                [removeList addObject:trackedRecognition];
                
                if (intersectOverUnion > maxIntersect) {
                    maxIntersect = intersectOverUnion;
                    recogToReplace = trackedRecognition;
                }
            }
        }
    }
    
    if (_arrColors.count==0 && removeList.count==0) {
        for (int n=0; n<_arrTrackedObjects.count; n++) {
            TrackedRecognition *candidate = [_arrTrackedObjects objectAtIndex:n];
            if ( candidate.detectionConfidence < [recognition confidence] ) {
                if (recogToReplace == nil || recogToReplace.detectionConfidence > candidate.detectionConfidence) {
                    recogToReplace = candidate;
                }
            }
        }
        
        if (recogToReplace!=nil) {
               [removeList addObject:recogToReplace];
        }
        
    }
    
   
    
    for (int m=0; m<removeList.count; m++) {
        TrackedRecognition *trackedRecognition = [removeList objectAtIndex:m];
        [trackedRecognition.trackedObject stopTracking];
        [_arrTrackedObjects removeObject:trackedRecognition];
        if (trackedRecognition!=recogToReplace) {
            [_arrColors addObject:trackedRecognition.color];
        }
    }
    
    [removeList removeAllObjects];
    
    if (recogToReplace==nil && _arrColors.count==0) {
        [potentialObject stopTracking];
        return;
    }
    
    TrackedRecognition *trackedRecognition = [[TrackedRecognition alloc]init];
    
    trackedRecognition.trackedObject = potentialObject;
    
    trackedRecognition.detectionConfidence = recognition.confidence;
    trackedRecognition.title = recognition.label;
    trackedRecognition.location = recognition.rect;
    
    if (recogToReplace!=nil) {
        trackedRecognition.color = recogToReplace.color;
        if(maxIntersect > MAX_OVERLAP){
            //同一个物体
            if(![trackedRecognition.title isEqualToString:recogToReplace.title]){
                trackedRecognition.title = recogToReplace.title;
                trackedRecognition.detectionConfidence =  recogToReplace.detectionConfidence;
                 trackedRecognition.count = recogToReplace.count;
//                NSNumber *numReplace =  [_dicTrackNum objectForKey:recogToReplace.title];
//                int nRep = 0;
//                if (numReplace.intValue>0) {
//                    nRep = numReplace.intValue-1;
//                }
//                [_dicTrackNum setObject:[NSNumber numberWithInt:nRep] forKey:recogToReplace.title];
                
//                NSNumber *num = [_dicTrackNum objectForKey:trackedRecognition.title];
//                int value = 0;
//                if (num != nil) {
//                    value = num.intValue;
//                }
//                [_dicTrackNum setObject:[NSNumber numberWithInt:value+1] forKey:trackedRecognition.title];
//                trackedRecognition.count = value+1;
            }else{
                trackedRecognition.count = recogToReplace.count;
            }
        }else{
            //不同物体
            NSNumber *num = [_dicTrackNum objectForKey:trackedRecognition.title];
            int value = 0;
            if (num != nil) {
                value = num.intValue;
            }
            [_dicTrackNum setObject:[NSNumber numberWithInt:value+1] forKey:trackedRecognition.title];
            trackedRecognition.count = value+1;
        }
    }else{
        trackedRecognition.color = [_arrColors objectAtIndex:0];
        [_arrColors removeObjectAtIndex:0];
        NSNumber *num = [_dicTrackNum objectForKey:trackedRecognition.title];
        int value = 0;
        if (num != nil) {
            value = num.intValue;
        }
        [_dicTrackNum setObject:[NSNumber numberWithInt:value+1] forKey:trackedRecognition.title];
        trackedRecognition.count = value+1;
    }
    
    
    
    [_arrTrackedObjects addObject:trackedRecognition];
    
    
}



@end
