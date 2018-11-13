//
//  DynamicView.h
//  LibUGC
//
//  Created by iMobile2D on 14-8-11.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "DynamicElement.h"



@interface DynamicView : UIView

-(id)initWithMapControl:(MapControl*)mapControl;

/**@brief 移动动态层到index
 */
-(void)moveDynamicViewTo:(int)index;

/**@brief 下移 dynamicView
 */
-(void)moveDynamicViewDown;

/**@brief 上移dynamicView
 */
-(void)moveDynamicViewUp;

/**@brief 移到顶部
 */
-(void)moveDynamicViewTop;

//获取当前动态层的索引
-(NSInteger)getIndex;
/**@brief 移到底部
 */
-(void)moveDynamicViewBottum;

-(void)addElement:(DynamicElement*)element;
-(void)removeElementWithIDs:(NSArray*)IDs;
-(void)removeElementWithTag:(NSString*)tag;
-(void)clear;

-(NSArray*)queryWithIDs:(NSArray*)IDs;
-(NSArray*)queryWithTag:(NSString*)tag;
-(NSArray*)queryWithBounds:(Rectangle2D*)bounds;

-(void)startAnimation;//开始动画
-(void)stopAnimation;//停止动画
-(void)refresh;

//是否开启聚合功能
@property(nonatomic,assign)BOOL isPolymerize;
//是否开启动态元素排序功能，开启后元素将按bounds大的在底层排序
@property(nonatomic)BOOL isAutoSort;

@end
