//
//  Rect2D.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
@class Point2D;


/**
 @since 1.0
 */
@interface Rect2D : NSObject 
{@private
    double _left;
    double _bottom;
    double _right;
    double _top;
    Point2D *_point2D;
    double _width;
    double _height;
}
#pragma mark Property
/**
 @since 1.0
 */
@property(nonatomic,readwrite)double left;
/**
 @since 1.0
 */
@property(nonatomic,readwrite)double bottom;
/**
 @since 1.0
 */
@property(nonatomic,readwrite)double right;
/**
 @since 1.0
 */
@property(nonatomic,readwrite)double top;
/**
 @since 1.0
 */
@property(nonatomic,readonly)Point2D *point2D;
/**
 @since 1.0
 */
@property(nonatomic,readonly)double width;
/**
 @since 1.0
 */
@property(nonatomic,readonly)double height;

#pragma mark Construct
/**
 @since 1.0
 */
-(id)initWithLeftBottom:(Point2D *)pointLB Width:(double)width Height:(double)height;
/**
 @since 1.0
 */
-(id)initWithLeftBottom:(Point2D *)pointLB RightTop:(Point2D *)pointRT;
/**
 @since 1.0
 */
-(id)initWithLeft:(double)left Bottom:(double)bottom Right:(double)right Top:(double)top;
/**
 @since 1.0
 */
-(id)initWithRect:(Rect2D *)rect2D;


#pragma mark Method
/**
 @since 1.0
 */
-(BOOL)containsPoint2D:(Point2D *)point2D;
/**
 @since 1.0
 */
-(BOOL)containsRect2D:(Rect2D *)rect2D;
/**
 @since 1.0
 */
-(BOOL)containsX:(double)x Y:(double)y;
/**
 @since 1.0
 */
-(BOOL)equalsRect2D:(Rect2D *)rect2D;
/**
 @since 1.0
 */
-(void)inflateX:(double)x Y:(double)y;
/**
 @since 1.0
 */
-(void)offsetX:(double)x Y:(double)y;
/**
 @since 1.0
 */
-(Rect2D *)clone;
/**
 @since 1.0
 */
-(NSString *)toString;


@end
