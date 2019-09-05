//
//  AnimationGO.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    UnknowAnimation = -1,//未知类型
    WayAnimation = 0,//路径动画
    BlinkAnimation =  1,//闪烁动画
    AttribAnimation = 2,//属性动画
    ShowAnimation =  3,//显隐动画
    RotateAnimation = 4,//旋转动画
    ScaleAnimation =  5,// 比例动画
    GrowAnimation =  6,//生长动画
    //! \brief 平移动画。
    MoveAnimation =  7,
    
    //! \brief 自定义动画。
    CustomAnimation =  8,
    
    //! \brief 地图漫游动画。
    PanAnimation =  9,
    
    //! \brief 地图缩放动画。
    ZoomAnimation = 10,
    
    //! \brief 清态势动画。
    ClearSitAnimation =  11,
}AnimationType;

@class Geometry,MapControl;
@interface AnimationGO : NSObject
@property(nonatomic,strong)NSString* name;
@property(nonatomic)double startTime;
@property(nonatomic)double duration;

-(void)setGeomtry:(Geometry*)geo mapControl:(MapControl*)mapControl layer:(NSString*)layerName;
-(double)getComplete;
-(int)getGeometry;
-(NSString*)getControlName;
-(NSString*)getLayerName;
-(AnimationType)getAnimationType;
-(BOOL)fromXML:(NSString*)xml;
-(NSString*)toXML;
@end
