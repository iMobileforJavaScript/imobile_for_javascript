//
//  SnapSetting.h
//  MapEditDemo
//
//  Created by imobile-xzy on 16/8/9.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

//标示地图控件的捕捉设置
typedef enum{
    //点　点在线的端点上
    POINT_ON_ENDPOINT = 1,
    //点  点同其它图素点重合
    POINT_ON_POINT = 2,
    //点 点在别的图素线上
    POINT_ON_LINE = 4,
    //点在沿线上
    POINT_DRAG_LINE = 16384,
}SnapMode;

@interface SnapSetting : NSObject
// 获取或设置一个值,标示捕捉时光标定位点的容限，单位需要与UGC确认,SFC是像素
@property(nonatomic)int tolerance;

-(id)initWithSetting:(SnapSetting*)setting;

-(void)setMode:(SnapMode)mode bValue:(BOOL)value;
/**
 * 开启全部捕捉功能,现在开出去四种功能
 */
-(void)openAll;
/**
 * 关闭全部捕捉功能,现在开出去四种功能
 */
-(void)closeAll;
/**
 * 打开默认捕捉功能,默认打开节点,端点,线上点捕捉
 */
-(void)openDefault;
/**
 获取或设置一个值, 标示指定的捕捉模式是否有效
 */
-(BOOL)getSnapMode:(SnapMode)mode;
@property(nonatomic)int maxSnappedCount;

@end
