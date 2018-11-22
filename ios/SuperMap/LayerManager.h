//
//  LayerManager.h
//  LibUGC
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LayerManager : NSObject

/*
 * 图层管理控件视图
 */
@property(nonatomic,strong,readonly) UIView* layerManagerView;

/*
 * 当用户通过代码改变地图属性时，需要手动调用该方法，通知图层管理控件加载数据
 */
-(void)reloadData;

@end
