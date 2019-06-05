//
//  ScaleViewHelper.m
//  Supermap
//
//  Created by supermap on 2019/6/3.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "ScaleViewHelper.h"
@interface ScaleViewHelper(){
    /*属性数组*/
    NSArray *SCALES;
    NSArray *SCALESTEXT;
    NSArray *SCALESTEXTGlobal;
    NSArray *DISTANCES;
}

@end

@implementation ScaleViewHelper

-(id)initWithMapControl:(MapControl *)mapcontrol{
    self = [super init];
    _mMapControl = mapcontrol;
    _mScaleType = SV_Global;

    SCALESTEXT = @[@"<5米",@"5米",@"10米",@"20米",@"50米",@"100米",@"200米",@"500米",@"1千米",@"2千米",@"5千米",@"10千米",@"20千米",@"25千米",@"50千米",@"100千米",@"200千米",@"500千米",@"1000千米",@"2000千米",@">2000千米"];
    SCALESTEXTGlobal = @[@"<5m",@"5m",@"10m",@"20m",@"50m",@"100m",@"200m",@"500m",@"1km",@"2km",@"5km",@"10km",@"20km",@"25km",@"50km",@"100km",@"200km",@"500km",@"1000km",@"2000km",@">2000km"];
    SCALES = @[@0.0000000021276595744680852,@0.0000000042553191489361703,@0.0000000085106382978723407,@0.000000017021276595744681,@0.000000034042553191489363,
               @0.000000068085106382978725,@0.00000013617021276595745,@0.0000002723404255319149,@0.0000005446808510638298,@0.0000010893617021276596,
               @0.0000021787234042553192,@0.0000043574468085106384,@0.0000087148936170212768,@0.000017429787234042554,@0.000034859574468085107,
               @0.000069719148936170215,@0.00013943829787234043,@0.00027887659574468086,@0.00055775319148936172,@0.00105775319148936172,@0.00205775319148936172];
    DISTANCES = @[@5,@10,@20,@50,@100,@200,@500,@1000,@2000,@5000,@10000,@20000,@25000,@50000,@100000,@200000,@500000,@1000000,@2000000];
    return self;
}

-(id)initWithMapControl:(MapControl *)mapcontrol Type:(ScaleType)scaleType{
    self = [self initWithMapControl:mapcontrol];
    _mScaleType = scaleType;
    return self;
}

-(int)getScaleLevel{
    static int nLevel;
    double dScale = _mMapControl.map.scale;
    for(int i=0;i<[SCALES count] -1;i++){
        if(dScale>=[SCALES[i] doubleValue] && dScale< [SCALES[i+1]doubleValue]){
            nLevel = SCALES.count - 1 - i;
            break;
        }
    }
    if(dScale > [SCALES[SCALES.count-1]doubleValue])
        nLevel = 0;
    else if(dScale<[SCALES[0] doubleValue])
        nLevel = 20;
    return nLevel;
}

-(double)getPixMapScale{
    double dLength;
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGPoint pixPos = CGPointMake(size.width*0.5,size.height*0.5);
    //获取屏幕两个点。
    Point2D* mapPos = [_mMapControl.map pixelTomap:pixPos];
    
    CGPoint pixPos1 = CGPointMake(pixPos.x+10,pixPos.y);
    
    //转地图坐标
    Point2D* mapPos1 = [_mMapControl.map pixelTomap:pixPos1];
    
    Point2Ds *points = [[Point2Ds alloc]init];
    [points add:mapPos];
    [points add:mapPos1];
    //转经纬度坐标
    if ([_mMapControl.map.prjCoordSys type]!= PCST_EARTH_LONGITUDE_LATITUDE) {
        double dx = ABS(([points getItem:0].x-[points getItem:1].x));
        double dy = ABS(([points getItem:0].y-[points getItem:1].y));
        dLength = sqrt(dx*dx + dy*dy);
        
    }else//如果是经纬度 求弧度长
    {
        double dx = ABS(([points getItem:0].x-[points getItem:1].x))*111319.489;
        double dy = ABS(([points getItem:0].y-[points getItem:1].y))*111319.489;
        dLength = sqrt(dx*dx + dy*dy);
    }
    
    return 10/dLength;
}

-(NSString *)getScaleText:(int)level{
    NSString* strText;
    
    if(level>=0 && level<[SCALESTEXT count]){
        if(_mScaleType == SV_Global)
            strText = [SCALESTEXTGlobal objectAtIndex:level];
        else if(_mScaleType == SV_Chinese)
            strText = [SCALESTEXT objectAtIndex:level];
    }
    return strText;
}


-(float)getScaleWidth:(int)level{
    
    static int nlenth = 0;
    if(level == 0){
        // pixMapScale = [self getPixMapScale];
        nlenth =20;
    }else if (level > 19)
        nlenth = 30;
    else{
        double pixMapScale = [self getPixMapScale];
        nlenth = [DISTANCES[level-1] intValue];
        nlenth = pixMapScale*nlenth+0.7;
    }
    
    return nlenth;
}
@end
