//
//  ARCollectorView.m
//  Supermap
//
//  Created by wnmng on 2020/2/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "ARCollectorView.h"
#import "ARMeasureView.h"

@interface ARCollectorView()<ARPositionDelegate>{
    ARMeasureView *_measurview;
    
    float _currentX;
    float _currentY;
    float _currentZ;
    
    float _totalLength;
    
    BOOL mInitNewRoute;
    int mRouteIndex;
    NSMutableDictionary* mRouteDictionary;
    
    NSMutableArray* mPointsArray;
}

@end

@implementation ARCollectorView

-(id)init{
    if (self = [super init]) {
        [self initialise];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        [self initialise];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialise];
    }
    return self;
}

-(void)initialise{
    _measurview = [[ARMeasureView alloc]init];
    _measurview.arPositionDelegate = self;
    [self addSubview:_measurview];
    //[_measurview startARSessionWithMode:AR_MODE_INDOORPOSITIONING];
    
    _currentX =0 ;
    _currentY =0 ;
    _currentZ =0 ;
    
    _totalLength = 0;
    
    mInitNewRoute = false;
    mRouteIndex = 0;
    mRouteDictionary = [[NSMutableDictionary alloc]init];
    mPointsArray = [[NSMutableArray alloc]init];
}

-(void)layoutSubviews{
    int w = self.bounds.size.width;
    int h = self.bounds.size.height;
    _measurview.frame = CGRectMake( w*0.75, h*0.375, w*0.25, h*0.25);
    
    [super layoutSubviews];
}

-(void)currentARPositionX:(float)x y:(float)y z:(float)z{
    
    if ( (_currentX-x)*(_currentX-x) + (_currentY-y)*(_currentY-y) > 0.01) {
        _currentX = x;
        _currentY = y;
        _currentZ = z;
        if(mInitNewRoute){
            NSString *strIndex = [NSString stringWithFormat:@"%d",mRouteIndex];
            
            NSMutableArray *arrRoute = mRouteDictionary[strIndex];
            
            int count = arrRoute.count;
            float prex = [(NSNumber*)arrRoute[count-3] floatValue];
            float prey = [(NSNumber*)arrRoute[count-2] floatValue];
            
            [arrRoute addObject:@(x)];
            [arrRoute addObject:@(y)];
            [arrRoute addObject:@(z)];
            float total = _totalLength + sqrtf( (x-prex)*(x-prex) + (y-prey)*(y-prey) );
            [self setTotalLength:total];
        }
       if ([NSThread isMainThread]) {
            [self setNeedsDisplay];
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self setNeedsDisplay];
            });
        }
    }
    
    
//    if (mInitNewRoute) {
//        NSString *strIndex = [NSString stringWithFormat:@"%d",mRouteIndex];
//        NSMutableArray *arrRoute = mRouteDictionary[strIndex];
//        int index = arrRoute.count/3 - 1;
//        float prex = [(NSNumber*)arrRoute[index*3] floatValue];
//        float prey = [(NSNumber*)arrRoute[index*3+1] floatValue];
//        float prez = [(NSNumber*)arrRoute[index*3+2] floatValue];
//        if ( (x-prex)*(x-prex) + (y-prey)*(y-prey) > 0.01) {
//            [arrRoute addObject:@(x)];
//            [arrRoute addObject:@(y)];
//            [arrRoute addObject:@(z)];
//        }
//    }
//    _currentX = x;
//    _currentY = y;
//    _currentZ = z;
    
}

-(NSArray*)collectCurrentPoint{
    NSArray *arr = [NSArray arrayWithObjects:@(_currentX),@(_currentY),@(_currentZ), nil];
    
    [mPointsArray addObjectsFromArray:arr];
    
    if ([NSThread isMainThread]) {
        [self setNeedsDisplay];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
    return arr;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    int unit = MIN(rect.size.width, rect.size.height)*0.1;
    //背景颜色设置
    [[UIColor blackColor] set];
    CGContextFillRect(context, rect);
    
   
    
    CGContextSetLineWidth(context, MAX(2.0, unit*0.1));
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    NSArray* allKeys = [mRouteDictionary allKeys];
    for (NSString* strKey in allKeys) {
        NSArray* arrData = [mRouteDictionary objectForKey:strKey];
        int count = arrData.count/3;
        
        if(count>1){
            CGPoint arrPoints[count];
            for (int i=0; i<count; i++) {
                arrPoints[i].x = ([(NSNumber*)arrData[i*3] floatValue] - _currentX)*unit + rect.size.width*0.5;
                arrPoints[i].y = ([(NSNumber*)arrData[i*3+1] floatValue] - _currentY)*unit + rect.size.height*0.5;
            }
            CGContextAddLines(context, arrPoints,count);
            CGContextStrokePath(context);
        }
    }
    
    {
        int pntCount = mPointsArray.count/3;
        for (int i=0; i<pntCount; i++) {
            float posx = ([(NSNumber*)mPointsArray[i*3]  floatValue] - _currentX)*unit + rect.size.width*0.5;
            float posy = ([(NSNumber*)mPointsArray[i*3+1]  floatValue] - _currentY)*unit  + rect.size.height*0.5;
            
            CGContextSetLineWidth(context, 0);
            
//            CGPoint rect[5];
//            rect[0] = CGPointMake(posx-unit*0.125, posy-unit*0.125);
//            rect[1] = CGPointMake(posx-unit*0.125, posy+unit*0.125);
//            rect[2] = CGPointMake(posx+unit*0.125, posy+unit*0.125);
//            rect[3] = CGPointMake(posx+unit*0.125, posy-unit*0.125);
//            rect[4] = CGPointMake(posx-unit*0.125, posy-unit*0.125);
//            CGContextAddLines(context, rect, 5);
            CGContextAddRect(context, CGRectMake(posx-unit*0.125, posy-unit*0.125,unit*0.25,unit*0.25));
            //填充
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            //绘制路径及填充模式
            CGContextDrawPath(context, kCGPathFillStroke);
        
        }
    }
    
    {
       CGContextSetLineWidth(context, 2.0);
       CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
       CGPoint crossx[2];
       crossx[0].x = 0.5*rect.size.width-unit;
       crossx[0].y = 0.5*rect.size.height;
       crossx[1].x = 0.5*rect.size.width+unit;
       crossx[1].y = 0.5*rect.size.height;
       CGContextAddLines(context, crossx,2);
       CGPoint crossy[2];
       crossy[0].x = 0.5*rect.size.width;
       crossy[0].y = 0.5*rect.size.height-unit;
       crossy[1].x = 0.5*rect.size.width;
       crossy[1].y = 0.5*rect.size.height+unit;
       CGContextAddLines(context, crossy,2);
       CGContextStrokePath(context);
    }
    
    
}


//开始采集
-(void)addNewRoute{
    NSString *strIndex = [NSString stringWithFormat:@"%d",mRouteIndex];
    mRouteDictionary[strIndex] = [[NSMutableArray alloc]init];
    [mRouteDictionary[strIndex] addObject:@(_currentX)];
    [mRouteDictionary[strIndex] addObject:@(_currentY)];
    [mRouteDictionary[strIndex] addObject:@(_currentZ)];
    mInitNewRoute = true;
    [self setTotalLength:0];
}
//停止采集
-(void)saveCurrentRoute{
    mInitNewRoute = false;
}
//清除当前route
-(void)clearCurrentRoute{
    mInitNewRoute = false;
    [self setTotalLength:0];
    
    NSString *strIndex = [NSString stringWithFormat:@"%d",mRouteIndex];
    if ([mRouteDictionary objectForKey:strIndex]!=nil) {
        [mRouteDictionary[strIndex] removeAllObjects];
        [mRouteDictionary removeObjectForKey:strIndex];
    }
    if ([NSThread isMainThread]) {
        [self setNeedsDisplay];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
}
//
-(NSArray*)currentRoutePoints{
    NSString *strIndex = [NSString stringWithFormat:@"%d",mRouteIndex];
    return mRouteDictionary[strIndex];
}
//新增路线
-(void)routeAdd{
    mInitNewRoute = false;
    mRouteIndex ++;
}
//从数据读到当前点串
-(void)loadPoseData:(NSArray*)arrData{
    mInitNewRoute = false;
    if(arrData.count==3){
        //点
        [mPointsArray addObjectsFromArray:arrData];
        
    }else if(arrData.count>3 && arrData.count%3==0){
        [self clearCurrentRoute];
           NSString *strIndex = [NSString stringWithFormat:@"%d",mRouteIndex];
           NSMutableArray* loadData = [[NSMutableArray alloc]init];
           
           int count = arrData.count/3;
           float total = 0;
           float x = [(NSNumber*)[arrData objectAtIndex:0] floatValue];
           float y = [(NSNumber*)[arrData objectAtIndex:1] floatValue];
           float z = [(NSNumber*)[arrData objectAtIndex:2] floatValue];
           [loadData addObject: @(x)];
           [loadData addObject: @(y)];
           [loadData addObject: @(z)];
           for (int i=1; i<count; i++) {
               float cx = [(NSNumber*)[arrData objectAtIndex:i*3] floatValue];
               float cy = [(NSNumber*)[arrData objectAtIndex:i*3+1] floatValue];
               float cz = [(NSNumber*)[arrData objectAtIndex:i*3+2] floatValue];
               [loadData addObject: @(cx)];
               [loadData addObject: @(cy)];
               [loadData addObject: @(cz)];
               total += (x-cx)*(x-cx) + (y-cy)*(y-cy);
               x = cx;
               y = cy;
               z = cz;
           }
           
           total = sqrtf(total);
           mRouteDictionary[strIndex] = loadData;
           [self setTotalLength:total];
    }
    if ([NSThread isMainThread]) {
        [self setNeedsDisplay];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
    
}

-(void)setTotalLength:(float)total{
    if (_totalLength-total!=0) {
        _totalLength = total;
        if (self.delegate!=nil) {
            [self.delegate onLengthChange:total];
        }
    }
}

//清除所有点
-(void)clearPoseData{
    [mRouteDictionary removeAllObjects];
    [mPointsArray removeAllObjects];
    mRouteIndex = 0;
    mInitNewRoute = false;
    [self setTotalLength:0];
    if ([NSThread isMainThread]) {
        [self setNeedsDisplay];
    }else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
}

-(void)startCollect{
    [_measurview startARSessionWithMode:AR_MODE_INDOORPOSITIONING];
}

-(void)reset{
    [self clearPoseData];
    [_measurview stopARSession];
}

-(void)dispose{
    [self reset];
    [self removeFromSuperview];
}

@end
