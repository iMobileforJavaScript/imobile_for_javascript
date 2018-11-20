/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: Zihao Wang
 E-mail: pridehao@gmail.com
 Description:轨迹记录类提供自动记录轨迹的功能，轨迹记录可以根据道路进行纠正，保证记录点都在行进的道路上；
 可以设置记录的时间间隔或距离间隔。自动剔除异常的位置坐标。轨迹记录支持后台运行，便于外业行进中进行记录采集。
 
 **********************************************************************************/

#import <React/RCTBridgeModule.h>

@interface JSTrack : NSObject<RCTBridgeModule>

@end
