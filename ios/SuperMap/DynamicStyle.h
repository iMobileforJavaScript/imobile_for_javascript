//
//  DynamicStyle.h
//  LibUGC
//
//  Created by iMobile2D on 14-8-11.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DynamicStyle : NSObject{
    @private
    UIImage* mBitmap;
}
@property (nonatomic,strong) UIImage* bitmap;
@property(nonatomic,strong)UIColor* brushColor;//画刷颜色
@property(nonatomic,assign)float lineWidth;//线宽
@property(nonatomic,assign)float radius;//点绘制大小
@property(nonatomic,assign)float rotaAngle;//旋转角度
@property(nonatomic,assign)int width;//宽度，设置bitmap后有效
@property(nonatomic,assign)int height;//高度，设置bitmap后有效
@property(nonatomic,assign)float alpha;//透明度
@property(nonatomic,strong)NSDictionary* textLableAttribute;//对象标签属性
@end
