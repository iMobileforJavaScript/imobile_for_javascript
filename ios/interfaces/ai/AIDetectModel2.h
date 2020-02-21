//
//  AIDetectModel2.h
//  Supermap
//
//  Created by zhouyuming on 2020/2/14.
//  Copyright © 2020年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PERSON, //人员
    BICYCLE,//自行车
    CAR,//车辆
    MOTORCYCLE,//摩托车
    BUS,//公交车
    
    TRUCK,//卡车
    TRAFFICLIGHT,//交通信号灯
    FIREHYDRANT,//消防栓
    CUP,//杯子
    CHAIR,//椅子
    
    BIRD,//鸟
    CAT,//猫
    DOG,//狗
    POTTEDPLANT,//盆栽植物
    TV,//显示器
    
    LAPTOP,//笔记本电脑
    MOUSE,//鼠标
    KEYBOARD,//键盘
    CELLPHONE,//手机
    BOOK,//书
    
    BIN,//垃圾箱
    
    LINEARCRACK,//线裂痕
    CONSTRUCTION,//施工连接处
    LINEARLATERAL,//横向线裂痕
    CONSTRUCTIONLATERAL,//横向施工连接处
    ALLIGATORCRACK,//龟裂裂痕
    RUTTINGBUMP,//车辙
    CROSSWALK,//人行道
    WHITELINE,//道路白线
    
    BOTTLE,//瓶子
}DetectMode;

static NSArray *mEnglishNames;

static NSArray *mChineseNames;


@interface AIDetectModel2 : NSObject

//获取英文名称
+(NSString*)getEnglishName:(DetectMode)model;

+(NSString*)getChineseName:(DetectMode)model;

+(NSString*)getEnglishWithName:(NSString*)name;

+(NSString*)getChineseWithName:(NSString*)name;

+(NSArray*)getChineseArray;

+(NSArray*)getEnglishArray;

@end
