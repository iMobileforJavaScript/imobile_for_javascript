//
//  FloorListView3D.h
//  LibUGC
//
//  Created by wnmng on 2017/9/7.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol Navi3DMapChangedDelegate;
@class SceneControl,Navigation3D,Datasource;

@interface FloorListView3D : UIView


@property (nonatomic,strong) NSString *currentFloorID;

@property(nonatomic)id<Navi3DMapChangedDelegate>delegate;

/**
 * 获取当前室内数据源
 */
-(Datasource *)getIndoorDatasource;


/**
 * 加载楼层信息
 */
-(void)reload;
/**
 * 链接SceneControl
 * @param sceneControl
 */
-(void)linkeSceneControl:(SceneControl*)scencontrol;

/**
 * 设置Navigation3D
 * @param Navigation3D
 */
-(void)setNavigation3D:(Navigation3D*)navi3D;

/**
 * 设置可见性
 * @param bVisable
 */
-(void)setVisible:(BOOL)bVisable;

/**
 * 设置楼层可见性：0.只有当前楼层可见 1.所有楼层均可见
 * @param bShowAll
 */
-(void)setFloorVisibleFlag:(BOOL)bShowAll;
@end

@protocol Navi3DMapChangedDelegate <NSObject>
-(void)floorChange:(NSString*)name floorID:(NSString*)floorId;
@end
