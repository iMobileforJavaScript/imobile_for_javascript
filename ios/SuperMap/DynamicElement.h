//
//  DynamicElement.h
//  LibUGC
//
//  Created by iMobile2D on 14-8-11.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicStyle.h"
#import "Animator.h"
#import "Point2D.h"
#import "Rectangle2D.h"

/*
 *  动态对象的类型
 */
typedef enum {
	ElementInvalid = 0,
    ElementPoint,
	ElementLine,
	ElementPolygon,
	ElementText,
    Polymerize,
} ElementType;



@protocol OnClickDelegate;

@interface DynamicElement : NSObject

@property (nonatomic, retain) DynamicStyle* style;
@property (nonatomic, retain) NSString* userData;
@property (nonatomic, retain) id<OnClickDelegate> onClickDelegate;
@property (nonatomic, retain, readonly) NSString* ID;
@property (nonatomic, readonly) Rectangle2D* bounds;
@property (nonatomic, retain) NSString* tag;
@property (nonatomic,strong)NSString* name;
@property(nonatomic)BOOL nameHidden;

-(void)addPoint:(Point2D*)point;
-(NSArray*)getGeoPoints;
-(void)addAnimator:(Animator*)animator;
-(void)startAnimation;
-(void)stopAnimation;

-(ElementType)getType;
// 是否有效的元素
-(BOOL)isValidElement;

@end



//响应单击事件，单击对象时回调。

@protocol OnClickDelegate <NSObject>
@optional
-(void)onClick:(DynamicElement*)element pos:(CGPoint)position;
-(void)onLongPress:(DynamicElement*)element pos:(CGPoint)position;
@end
