//
//  GeoGraphicObject.h
//  MessageDemo
//
//  Created by imobile-xzy on 15/8/26.
//  Copyright (c) 2015年 imobile-xzy. All rights reserved.
//

#import "Geometry.h"

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
@end
