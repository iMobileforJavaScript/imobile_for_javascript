//
//  PointM.h
//  LibUGC
//
//  Created by esupermap on 14-3-3.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointM : NSObject{

    double _x;
    double _y;
    double _z;
}

@property(nonatomic)double x;
@property(nonatomic)double y;
@property(nonatomic)double z;

+(PointM*)getEMPTY;
-(id)init;
-(id)initWith:(double)x y:(double)y z:(double)z;
-(PointM*)clone;
-(BOOL)isEmpty;
-(BOOL)equals:(PointM*)pntM;
-(int)hashCode;
-(NSString*)toString;

@end
