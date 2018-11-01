//
//  LegendView.h
//  LibUGC
//
//  Created by imobile-xzy on 15/11/24.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegendView : UIView



//行高，默认35
@property(nonatomic,assign)NSUInteger rowHeight;
//设置列，默认3列
@property(nonatomic,assign)NSUInteger column;
//字号，默认17号
@property(nonatomic,assign)NSUInteger fontSize;
//文字颜色，默认黑色
@property(nonatomic,strong)UIColor* fontColor;

//用于用户设置X轴，默认在左下角
@property(nonatomic,assign)double xOffset;
//用于用户设置y轴，默认在左下角
@property(nonatomic,assign)double yOffset;
//用于用户设置在图例默认大小wight,增量.
@property(nonatomic,assign)double xSizeOffset;
//用于用户设置在图例默认大小height,增量.
@property(nonatomic,assign)double ySizeOffset;

//用户自定义添加元素后需要，调用
-(void)refresh;
@end
