//
//  GeoGraphicObject.h
//  MessageDemo
//
//  Created by imobile-xzy on 15/8/26.
//  Copyright (c) 2015年 imobile-xzy. All rights reserved.
//

#import "Geometry.h"

typedef enum{
    /**
     *
     * 未知类型
     * @return
     */
    SYMBOL_UNKNOW = 0,
    /**
     *
     *点标号
     * @return
     */
    SYMBOL_DOT=1,
    /**
     *
     *线面标号
     * @return
     */
    SYMBOL_ALGO=2,
    /**
     *折线符号
     */
    SYMBOL_POLYLINE=24,
    /**
     *圆弧符号
     */
    SYMBOL_ARC=44,
    /**
     *矩形符号
     */
    SYMBOL_RECTANGLE=26,
    /**
     *正多边形符号
     */
    SYMBOL_REGULARPOLYGON=410,
    /**
     *圆形符号
     */
    SYMBOL_CIRCLE=29,
    /**
     *扇形符号
     */
    SYMBOL_PIE=380,
    /**
     *弓形符号
     */
    SYMBOL_CHORD=370,
    /**
     *图片符号
     */
    SYMBOL_PICTURE=20,
    /**
     *猪肾符号
     */
    SYMBOL_KIDNEY=390,
    /**
     *多段贝塞尔曲线符号
     */
    SYMBOL_POLYBEZIER=590,
    /**
     *任意多边形符号
     */
    SYMBOL_ARBITRARYPOLYGON=32,
    SYMBOL_ELLIPSE=14,
    /**
     *椭圆符号
     */
    SYMBOL_PARALLELOGRAM=31,
    /**
     *平行线
     */
    SYMBOL_PARALLELLINE=48,
    /**
     *大括号
     */
    SYMBOL_BRACE=400,
    /**
     *标签
     */
    SYMBOL_LABEL=34,
    /**
     *注记指示框
     */
    SYMBOL_ANNOFRAME=320,
    /**
     *注记指示线
     */
    SYMBOL_ANNOLINE=33,
    /**
     *梯形
     */
    SYMBOL_TRAPEZOID=350,
    /**
     *闭合多段贝塞尔曲线符号
     */
    SYMBOL_POLYBEZIER_CLOSE=360,
    /**
     *圆柱
     */
    SYMBOL_CYLINDER3D=901,
    /**
     *长方体
     */
    SYMBOL_BOX3D=902,
    /**
     *角锥
     */
    SYMBOL_PYRAMID3D=903,
    /**
     *圆锥
     */
    SYMBOL_CONE3D=904,
    /**
     *球
     */
    SYMBOL_SPHERE3D = 27,
}GraphicObjectType;
//态势标绘对象
@interface GeoGraphicObject : Geometry

//标绘对象,对应符号库code
@property(nonatomic,assign,readonly)NSUInteger code;
//标绘对象,对应符号库id
@property(nonatomic,assign,readonly)NSUInteger libraryID;
//标绘对象,名称
@property(nonatomic,strong,readonly)NSString* name;
//通过一个态势标绘对象，构造一个态势标绘对象
-(id)initWithGeoMetry:(Geometry*)geometry;
//释放对象占用资源
-(void)dispose;
//复制一个态势标绘对象
-(GeoGraphicObject*)clone;

-(GraphicObjectType)getSymbolType;
@end
