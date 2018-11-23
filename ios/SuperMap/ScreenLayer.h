//
//  ScreenLayer.h
//  LibUGC
//
//  Created by imobile-xzy on 15/11/4.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Geometry;

//只支持OPenGL 显示引擎
@interface ScreenLayer : NSObject

//! \brief 是否可见
@property(nonatomic,assign)BOOL visible;
//! \brief 获取对象个数
-(int)getCount;
//! \brief 添加几何对象到设备层
-(int)addGeometry:(Geometry*)geometry tag:(NSString*)tag;
//! \brief 移除指定索引的对象
-(BOOL)removeByIndex:(int)index;
//! \brief 移除指定tag的对象
-(BOOL)removeByTag:(NSString*)tag;
//
-(Geometry*)getByIndex:(int)index;
-(BOOL)setGeometry:(int)index geometry:(Geometry*)geometry;
-(NSString*)getTag:(int)index;
-(NSArray*)getArray:(NSString*)tag;
-(void)clear;
@end
