//
//  DatasetGridInfo.h
//  HotMap
//
//  Created by supermap on 2017/11/28.
//  Copyright © 2017年 supermap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EncodeType.h"
#import "DatasetGrid+inner.h"
@class Rectangle2D;


@interface DatasetGridInfo : NSObject
-(id)init;

-(id)initWithDatasetGridInfo:(DatasetGridInfo *)datasetGridInfo;

-(id)initWithDatasetGrid:(DatasetGrid *)datasetGrid name:(NSString *)name;

-(id)initWithName:(NSString *)name width:(int)width height:(int)height pixelFormat:(OCPixelFormat)pixelFormat encodeType:(EncodeType)encodeType;

-(id)initWithName2:(NSString *)name width:(int)width height:(int)height pixelFormat:(OCPixelFormat)pixelFormat encodeType:(EncodeType)encodeType blockSize:(int)blockSize;

-(void)dispose;

@property (nonatomic)int blockSize;

@property (nonatomic,strong)Rectangle2D *bounds;

@property (nonatomic)EncodeType encodeType;

@property (nonatomic)int height;

@property (nonatomic)int width;

@property (nonatomic)double maxValue;

@property (nonatomic)double minValue;

@property (nonatomic)NSString *name;

@property (nonatomic)double noValue;

@property (nonatomic)OCPixelFormat ocPixelFormat;

@end
