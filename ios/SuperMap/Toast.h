//
//  Toast.h
//  SpatialAnalystDemo
//
//  Created by imobile on 14-6-26.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toast : UIView
{
  
}
+(void)show:(NSString*)message hostView:(UIView*)hostView;
+(void)show:(NSString*)message pos:(NSString*)pos hostView:(UIView*)hostView;
+(void)show:(NSString*)title message:(NSString*)message pos:(NSString*)pos duration:(float)duration hostView:(UIView*)hostView;
+(void)showIndicatorView;
+(void)showIndicatorViewWith:(UIColor*)color;
+(void)hideIndicatorView;
@end
