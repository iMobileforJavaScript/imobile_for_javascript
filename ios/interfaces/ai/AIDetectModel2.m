//
//  AIDetectModel2.m
//  Supermap
//
//  Created by zhouyuming on 2020/2/14.
//  Copyright © 2020年 Facebook. All rights reserved.
//

#import "AIDetectModel2.h"


@implementation AIDetectModel2

+(NSString*)getEnglishName:(DetectMode)model{
    switch (model) {
        case PERSON:
            return @"person";
        case BICYCLE:
            return @"bicycle";
        case CAR:
            return @"car";
        case MOTORCYCLE:
            return @"motorcycle";
        case BUS:
            return @"bus";
            
        case TRUCK:
            return @"truck";
        case TRAFFICLIGHT:
            return @"traffic light";
        case FIREHYDRANT:
            return @"fire hydrant";
        case CUP:
            return @"cup";
        case CHAIR:
            return @"chair";
            
        case BIRD:
            return @"bird";
        case CAT:
            return @"cat";
        case DOG:
            return @"dog";
        case POTTEDPLANT:
            return @"potted plant";
        case TV:
            return @"tv";
            
        case LAPTOP:
            return @"laptop";
        case MOUSE:
            return @"mouse";
        case KEYBOARD:
            return @"keyboard";
        case CELLPHONE:
            return @"cell phone";
        case BOOK:
            return @"book";
            
        case BOTTLE:
            return @"bottle";
            
        default:
            return @"unknown";
    }
}
+(NSString*)getChineseName:(DetectMode)model{
    switch (model) {
        case PERSON:
            return @"人员";
        case BICYCLE:
            return @"自行车";
        case CAR:
            return @"车辆";
        case MOTORCYCLE:
            return @"摩托车";
        case BUS:
            return @"公交车";
            
        case TRUCK:
            return @"卡车";
        case TRAFFICLIGHT:
            return @"交通信号灯";
        case FIREHYDRANT:
            return @"消防栓";
        case CUP:
            return @"杯子";
        case CHAIR:
            return @"椅子";
            
        case BIRD:
            return @"鸟";
        case CAT:
            return @"猫";
        case DOG:
            return @"狗";
        case POTTEDPLANT:
            return @"盆栽植物";
        case TV:
            return @"显示器";
            
        case LAPTOP:
            return @"笔记本电脑";
        case MOUSE:
            return @"鼠标";
        case KEYBOARD:
            return @"键盘";
        case CELLPHONE:
            return @"手机";
        case BOOK:
            return @"书";
            
        case BOTTLE:
            return @"瓶子";
            
        case BIN:
            return @"垃圾箱";
            
        case LINEARCRACK:
            return @"线裂痕";
        case CONSTRUCTION:
            return @"施工连接处";
        case LINEARLATERAL:
            return @"横向线裂痕";
        case CONSTRUCTIONLATERAL:
            return @"横向施工连接处";
        case ALLIGATORCRACK:
            return @"龟裂裂痕";
        case RUTTINGBUMP:
            return @"车辙";
        case CROSSWALK:
            return @"人行道";
        case WHITELINE:
            return @"道路白线";
        default:
            return @"unknown";
    }
}

+(NSString*)getEnglishWithName:(NSString*)name{
    if(!mEnglishNames){
        mEnglishNames=[self getEnglishArray];
    }
    if(!mChineseNames){
        mChineseNames=[self getChineseArray];
    }
    NSInteger index = [mChineseNames  indexOfObject:name];
    if(index ==NSNotFound){
        return @"unknown";
    }
    NSString* englishName=[mEnglishNames objectAtIndex:index];
    return englishName;
}

+(NSString*)getChineseWithName:(NSString*)name{
    if(!mEnglishNames){
        mEnglishNames=[self getEnglishArray];
    }
    if(!mChineseNames){
        mChineseNames=[self getChineseArray];
    }
    
    NSInteger index = [mEnglishNames  indexOfObject:name];
    if(index ==NSNotFound){
        return @"unknown";
    }
    NSString* chineseName=[mChineseNames objectAtIndex:index];
    return chineseName;
}

+(NSArray*)getChineseArray{
    NSArray* array= @[//[[NSArray alloc]initWithObjects:
              @"人员",
              @"自行车",
              @"车辆",
              @"摩托车",
              @"飞机",
              @"公交车",
              @"火车",
              @"卡车",
              @"小船",
              @"交通信号灯",
              @"消防栓",
              @"停车牌",
              @"停车收费器",
              @"长椅",
              @"鸟",
              @"猫",
              @"狗",
              @"马",
              @"羊",
              @"牛",
              @"大象",
              @"熊",
              @"斑马",
              @"长颈鹿",
              @"背包",
              @"雨伞",
              @"手提包",
              @"绳子",
              @"手提箱",
              @"运动球",
              @"风筝",
              @"瓶子",
              @"玻璃酒杯",
              @"杯子",
              @"餐叉",
              @"刀具",
              @"勺子",
              @"碗",
              @"香蕉",
              @"苹果",
              @"三明治",
              @"橙子",
              @"西兰花",
              @"胡萝卜",
              @"热狗",
              @"比萨饼",
              @"油炸圈饼",
              @"蛋糕",
              @"椅子",
              @"长沙发",
              @"盆栽植物",
              @"床",
              @"餐桌",
              @"洗手间",
              @"显示器",
              @"笔记本电脑",
              @"鼠标",
              @"遥控器",
              @"键盘",
              @"手机",
              @"微波炉",
              @"烤箱",
              @"烤面包器",
              @"洗碗槽",
              @"冰箱",
              @"书",
              @"闹钟",
              @"花瓶",
              @"剪刀",
              @"玩具熊",
              @"吹风机",
              @"牙刷"
              @"unknown",
//                nil
              ];
    return array;
}

+(NSArray*)getEnglishArray{
    NSArray* array=@[//[[NSArray alloc]initWithObjects:
       @"person",
       @"bicycle",
       @"car",
       @"motorcycle",
       @"airplane",
       @"bus",
       @"train",
       @"truck",
       @"boat",
       @"traffic light",
       @"fire hydrant",
       @"stop sign",
       @"parking meter",
       @"bench",
       @"bird",
       @"cat",
       @"dog",
       @"horse",
       @"sheep",
       @"cow",
       @"elephant",
       @"bear",
       @"zebra",
       @"giraffe",
       @"backpack",
       @"umbrella",
       @"handbag",
       @"tie",
       @"suitcase",
       @"sports ball",
       @"kite",
       @"bottle",
       @"wine glass",
       @"cup",
       @"fork",
       @"knife",
       @"spoon",
       @"bowl",
       @"banana",
       @"apple",
       @"sandwich",
       @"orange",
       @"broccoli",
       @"carrot",
       @"hot dog",
       @"pizza",
       @"donut",
       @"cake",
       @"chair",
       @"couch",
       @"potted plant",
       @"bed",
       @"dining table",
       @"toilet",
       @"tv",
       @"laptop",
       @"mouse",
       @"remote",
       @"keyboard",
       @"cell phone",
       @"microwave",
       @"oven",
       @"toaster",
       @"sink",
       @"refrigerator",
       @"book",
       @"clock",
       @"vase",
       @"scissors",
       @"teddy bear",
       @"hair drier",
       @"toothbrush",
       @"unknown"
//        nil
       ];
    return array;
}


@end
