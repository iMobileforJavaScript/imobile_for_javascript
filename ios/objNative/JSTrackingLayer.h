/*********************************************************************************
  Copyright © SuperMap. All rights reserved.
  Author: Zihao Wang
  E-mail: pridehao@gmail.com
  Description:跟踪图层是一个空白的透明图层，总是在地图各图层的最上层，主要用于在一个处理或分析过程中，
  临时存放一些图形对象，以及一些文本等。 只要地图显示，跟踪图层就会存在，不可以删除跟踪图层，也不可以改变其位置。
 
**********************************************************************************/

#import <React/RCTBridgeModule.h>

@interface JSTrackingLayer : NSObject<RCTBridgeModule>

@end
