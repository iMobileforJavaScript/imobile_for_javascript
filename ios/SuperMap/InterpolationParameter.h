//
//  InterpolationParameter.h
//  LibUGC
//
//  Created by wnmng on 2019/7/15.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rectangle2D;

typedef  enum {

    //    None	0	不进行查找，使用所有的输入点进行内插分析
    SearchMode_NONE = 0,
    
    //QuadTree	1	使用QuadTree方式查找参与内插分析的点
    SearchMode_QUADTREE = 1,
    
    //KdTreeFixedRadius	2	使用KdTree的定长方式查找参与内插分析的点
    SearchMode_KDTREE_FIXED_RADIUS = 2,
    
    //KdTreeFixedCount	3	使用KdTree的固定点数方式查找参与内插分析的点
    SearchMode_KDTREE_FIXED_COUNT = 3

    
}SearchMode;

typedef  enum {
    
    IAT_NONE = -1,
    
    IAT_IDW = 0,
    
    //SimpleKriging 1
    IAT_SimpleKRIGING = 1,
    
    //Kriging	2	Kriging,For compatible it's meant to OrdinaryKringing
    IAT_KRIGING = 2,
    
    //UniversalKringing 3
    IAT_UniversalKRIGING = 3,
    
    //RBF	6	Radial Basis Functions
    IAT_RBF = 6,
    
    IAT_DENSITY = 9,
    
    /*注意下面的代码 RBF在UGC中为6，以后扩展功能的时候请注意
     * 		IDW = 0,
     //! Kriging
     //has the Mean parameter
     SimpleKriging = 1,
     //has the Nugget parameter
     OrdinaryKriging = 2,
     //has the Exponent parameter
     UniversalKriging = 3,
     //! Minium Curvature
     MINC  =  4,
     //! Trend Surface/Polynomial Regression
     TrendSurface = 5,
     //! Radial Basis Functions
     RBF = 6,
     //! Modified Shepard's Method
     IDW2 = 7,
     //! Triangulation with Linear Interpolation
     TIN = 8,
     */
    
}InterpolationAlgorithmType;

@interface InterpolationParameter : NSObject

@property(nonatomic,assign,readonly) InterpolationAlgorithmType type;
@property(nonatomic,assign) double resolution;
@property(nonatomic,assign) SearchMode searchMode;
@property(nonatomic,assign) double searchRadius;
@property(nonatomic,assign) int expectedCount;
@property(nonatomic,strong) Rectangle2D* bounds;
// 最多参与插值的点数，块查找的时候才支持
@property(nonatomic,assign) int maxPointCountForInterpolation;
// 参与插值的快内最多点数，块查找的时候才支持
@property(nonatomic,assign) int maxPointCountInNode;



@end
