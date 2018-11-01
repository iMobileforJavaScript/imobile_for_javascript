//
//  ImageStretchOption.h
//  LibUGC
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//
#import "Layers.h"
#import <Foundation/Foundation.h>

typedef enum {
    //注意：底层并没有与之相对应的内容。这个只是上层封装的。所以ugcValue的值是无效的。
    /**
     * 无拉伸
     */
    IST_NONE = 0,
    
    /**
     * 标准差拉伸
     */
    IST_STANDARDDEVIATION = 1,
    
    /**
     * 最值拉伸
     */
    IST_MINIMUMMAXIMUM = 2,
    
    /**
     * 直方图均衡
     */
    IST_HISTOGRAMEQUALIZATION = 3,
    
    /**
     * 直方图规定化
     */
    IST_HISTOGRAMSPECIFICATION = 4,
    
    /**
     * 高斯对比度拉伸
     */
    IST_GAUSSIAN = 5
    
}ImageStretchType;

@interface ImageStretchOption : NSObject

//影像拉伸类型
@property (nonatomic,assign) ImageStretchType stretchType;

//标准差拉伸参数
@property (nonatomic,assign) double standardDeviationStretchFactor;

//标准直方图
@property (nonatomic,strong) NSArray * standardHistograms;

//高斯拉伸参数（拉伸比例）
@property (nonatomic,assign) double gaussianStretchRatioFactor;

// 高斯拉伸参数（是否使用中心值）
@property (nonatomic,assign) BOOL gaussianStretchMiddleFactor;

-(id)initWithLayer:(Layer *)layer inLayers:(Layers*)layers;

-(id)initWith:(ImageStretchOption*)imageStretchOp;

@end
