package com.supermap.interfaces.ai;

import java.util.ArrayList;
import java.util.List;

public enum AIDetectModel2 {
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

    NULL,
    BIN,//垃圾箱

    LINEARCRACK,//线裂痕
    CONSTRUCTION,//施工连接处
    LINEARLATERAL,//横向线裂痕
    CONSTRUCTIONLATERAL,//横向施工连接处
    ALLIGATORCRACK,//龟裂裂痕
    RUTTINGBUMP,//车辙
    CROSSWALK,//人行道
    WHITELINE,//道路白线

    BOTTLE;//瓶子



    public static String getEnglishName(AIDetectModel2 model) {
        switch (model) {
            case PERSON:
                return "person";
            case BICYCLE:
                return "bicycle";
            case CAR:
                return "car";
            case MOTORCYCLE:
                return "motorcycle";
            case BUS:
                return "bus";

            case TRUCK:
                return "truck";
            case TRAFFICLIGHT:
                return "traffic light";
            case FIREHYDRANT:
                return "fire hydrant";
            case CUP:
                return "cup";
            case CHAIR:
                return "chair";

            case BIRD:
                return "bird";
            case CAT:
                return "cat";
            case DOG:
                return "dog";
            case POTTEDPLANT:
                return "potted plant";
            case TV:
                return "tv";

            case LAPTOP:
                return "laptop";
            case MOUSE:
                return "mouse";
            case KEYBOARD:
                return "keyboard";
            case CELLPHONE:
                return "cell phone";
            case BOOK:
                return "book";

            case BOTTLE:
                return "bottle";

            default:
                return "unknown";
        }
    }

    public static String getEnglishName(String name) {
        switch (name) {
            case "人员":
                return "person";
            case "自行车":
                return "bicycle";
            case "车辆":
                return "car";
            case "摩托车":
                return "motorcycle";
            case "飞机":
                return "airplane";
            case "公交车":
                return "bus";
            case "火车":
                return "train";
            case "卡车":
                return "truck";
            case "小船":
                return "boat";
            case "交通信号灯":
                return "traffic light";
            case "消防栓":
                return "fire hydrant";
            case "停车牌":
                return "stop sign";
            case "停车收费器":
                return "parking meter";
            case "长椅":
                return "bench";
            case "鸟":
                return "bird";
            case "猫":
                return "cat";
            case "狗":
                return "dog";
            case "马":
                return "horse";
            case "羊":
                return "sheep";
            case "牛":
                return "cow";
            case "大象":
                return "elephant";
            case "熊":
                return "bear";
            case "斑马":
                return "zebra";
            case "长颈鹿":
                return "giraffe";
            case "背包":
                return "backpack";
            case "雨伞":
                return "umbrella";
            case "手提包":
                return "handbag";
            case "绳子":
                return "tie";
            case "手提箱":
                return "suitcase";
            case "运动球":
                return "sports ball";
            case "风筝":
                return "kite";
            case "瓶子":
                return "bottle";
            case "玻璃酒杯":
                return "wine glass";
            case "杯子":
                return "cup";
            case "餐叉":
                return "fork";
            case "刀具":
                return "knife";
            case "勺子":
                return "spoon";
            case "碗":
                return "bowl";
            case "香蕉":
                return "banana";
            case "苹果":
                return "apple";
            case "三明治":
                return "sandwich";
            case "橙子":
                return "orange";
            case "西兰花":
                return "broccoli";
            case "胡萝卜":
                return "carrot";
            case "热狗":
                return "hot dog";
            case "比萨饼":
                return "pizza";
            case "油炸圈饼":
                return "donut";
            case "蛋糕":
                return "cake";
            case "椅子":
                return "chair";
            case "长沙发":
                return "couch";
            case "盆栽植物":
                return "potted plant";
            case "床":
                return "bed";
            case "餐桌":
                return "dining table";
            case "洗手间":
                return "toilet";
            case "显示器":
                return "tv";
            case "笔记本电脑":
                return "laptop";
            case "鼠标":
                return "mouse";
            case "遥控器":
                return "remote";
            case "键盘":
                return "keyboard";
            case "手机":
                return "cell phone";
            case "微波炉":
                return "microwave";
            case "烤箱":
                return "oven";
            case "烤面包器":
                return "toaster";
            case "洗碗槽":
                return "sink";
            case "冰箱":
                return "refrigerator";
            case "书":
                return "book";
            case "闹钟":
                return "clock";
            case "花瓶":
                return "vase";
            case "剪刀":
                return "scissors";
            case "玩具熊":
                return "teddy bear";
            case "吹风机":
                return "hair drier";
            case "牙刷":
                return "toothbrush";
            default:
                return "unknown";
        }
    }

    public static String getChineseName(String name) {
        switch (name) {
            case "person":
                return "人员";
            case "bicycle":
                return "自行车";
            case "car":
                return "车辆";
            case "motorcycle":
                return "摩托车";
            case "airplane":
                return "飞机";
            case "bus":
                return "公交车";
            case "train":
                return "火车";
            case "truck":
                return "卡车";
            case "boat":
                return "小船";
            case "traffic light":
                return "交通信号灯";
            case "fire hydrant":
                return "消防栓";
            case "stop sign":
                return "停车牌";
            case "parking meter":
                return "停车收费器";
            case "bench":
                return "长椅";
            case "bird":
                return "鸟";
            case "cat":
                return "猫";
            case "dog":
                return "狗";
            case "horse":
                return "马";
            case "sheep":
                return "羊";
            case "cow":
                return "牛";
            case "elephant":
                return "大象";
            case "bear":
                return "熊";
            case "zebra":
                return "斑马";
            case "giraffe":
                return "长颈鹿";
            case "backpack":
                return "背包";
            case "umbrella":
                return "雨伞";
            case "handbag":
                return "手提包";
            case "tie":
                return "绳子";
            case "suitcase":
                return "手提箱";
            case "sports ball":
                return "运动球";
            case "kite":
                return "风筝";
            case "bottle":
                return "瓶子";
            case "wine glass":
                return "玻璃酒杯";
            case "cup":
                return "杯子";
            case "fork":
                return "餐叉";
            case "knife":
                return "刀具";
            case "spoon":
                return "勺子";
            case "bowl":
                return "碗";
            case "banana":
                return "香蕉";
            case "apple":
                return "苹果";
            case "sandwich":
                return "三明治";
            case "orange":
                return "橙子";
            case "broccoli":
                return "西兰花";
            case "carrot":
                return "胡萝卜";
            case "hot dog":
                return "热狗";
            case "pizza":
                return "比萨饼";
            case "donut":
                return "油炸圈饼";
            case "cake":
                return "蛋糕";
            case "chair":
                return "椅子";
            case "couch":
                return "长沙发";
            case "potted plant":
                return "盆栽植物";
            case "bed":
                return "床";
            case "dining table":
                return "餐桌";
            case "toilet":
                return "洗手间";
            case "tv":
                return "显示器";
            case "laptop":
                return "笔记本电脑";
            case "mouse":
                return "鼠标";
            case "remote":
                return "遥控器";
            case "keyboard":
                return "键盘";
            case "cell phone":
                return "手机";
            case "microwave":
                return "微波炉";
            case "oven":
                return "烤箱";
            case "toaster":
                return "烤面包器";
            case "sink":
                return "洗碗槽";
            case  "refrigerator":
                return "冰箱";
            case "book":
                return "书";
            case "clock":
                return "闹钟";
            case "vase":
                return "花瓶";
            case "scissors":
                return "剪刀";
            case  "teddy bear":
                return "玩具熊";
            case "hair drier":
                return "吹风机";
            case "toothbrush":
                return "牙刷";
            default:
                return "unknown";
        }
    }

    public static List<String> getALLEnglishModels() {
        List<String> list = new ArrayList<String>();

        list.add(AIDetectModel2.getEnglishName(PERSON));
        list.add(AIDetectModel2.getEnglishName(BICYCLE));
        list.add(AIDetectModel2.getEnglishName(CAR));
        list.add(AIDetectModel2.getEnglishName(MOTORCYCLE));
        list.add(AIDetectModel2.getEnglishName(BUS));

        list.add(AIDetectModel2.getEnglishName(TRUCK));
        list.add(AIDetectModel2.getEnglishName(TRAFFICLIGHT));
        list.add(AIDetectModel2.getEnglishName(FIREHYDRANT));
        list.add(AIDetectModel2.getEnglishName(CUP));
        list.add(AIDetectModel2.getEnglishName(CHAIR));

        list.add(AIDetectModel2.getEnglishName(BIRD));
        list.add(AIDetectModel2.getEnglishName(CAT));
        list.add(AIDetectModel2.getEnglishName(DOG));
        list.add(AIDetectModel2.getEnglishName(POTTEDPLANT));
        list.add(AIDetectModel2.getEnglishName(TV));

        list.add(AIDetectModel2.getEnglishName(LAPTOP));
        list.add(AIDetectModel2.getEnglishName(MOUSE));
        list.add(AIDetectModel2.getEnglishName(KEYBOARD));
        list.add(AIDetectModel2.getEnglishName(CELLPHONE));
        list.add(AIDetectModel2.getEnglishName(BOOK));

        list.add(AIDetectModel2.getEnglishName(BOTTLE));

        return list;
    }

    public static String getChineseName(AIDetectModel2 model) {
        switch (model) {
            case PERSON:
                return "人员";
            case BICYCLE:
                return "自行车";
            case CAR:
                return "车辆";
            case MOTORCYCLE:
                return "摩托车";
            case BUS:
                return "公交车";

            case TRUCK:
                return "卡车";
            case TRAFFICLIGHT:
                return "交通信号灯";
            case FIREHYDRANT:
                return "消防栓";
            case CUP:
                return "杯子";
            case CHAIR:
                return "椅子";

            case BIRD:
                return "鸟";
            case CAT:
                return "猫";
            case DOG:
                return "狗";
            case POTTEDPLANT:
                return "盆栽植物";
            case TV:
                return "显示器";

            case LAPTOP:
                return "笔记本电脑";
            case MOUSE:
                return "鼠标";
            case KEYBOARD:
                return "键盘";
            case CELLPHONE:
                return "手机";
            case BOOK:
                return "书";

            case BOTTLE:
                return "瓶子";

            case BIN:
                return "垃圾箱";

            case LINEARCRACK:
                return "线裂痕";
            case CONSTRUCTION:
                return "施工连接处";
            case LINEARLATERAL:
                return "横向线裂痕";
            case CONSTRUCTIONLATERAL:
                return "横向施工连接处";
            case ALLIGATORCRACK:
                return "龟裂裂痕";
            case RUTTINGBUMP:
                return "车辙";
            case CROSSWALK:
                return "人行道";
            case WHITELINE:
                return "道路白线";

            case NULL:
                return "unknown";
            default:
                return "unknown";
        }
    }

    public static List<String> getALLChineseModels() {
        List<String> list = new ArrayList<String>();

        list.add(AIDetectModel2.getChineseName(PERSON));
        list.add(AIDetectModel2.getChineseName(BICYCLE));
        list.add(AIDetectModel2.getChineseName(CAR));
        list.add(AIDetectModel2.getChineseName(MOTORCYCLE));
        list.add(AIDetectModel2.getChineseName(BUS));

        list.add(AIDetectModel2.getChineseName(TRUCK));
        list.add(AIDetectModel2.getChineseName(TRAFFICLIGHT));
        list.add(AIDetectModel2.getChineseName(FIREHYDRANT));
        list.add(AIDetectModel2.getChineseName(CUP));
        list.add(AIDetectModel2.getChineseName(CHAIR));

        list.add(AIDetectModel2.getChineseName(BIRD));
        list.add(AIDetectModel2.getChineseName(CAT));
        list.add(AIDetectModel2.getChineseName(DOG));
        list.add(AIDetectModel2.getChineseName(POTTEDPLANT));
        list.add(AIDetectModel2.getChineseName(TV));

        list.add(AIDetectModel2.getChineseName(LAPTOP));
        list.add(AIDetectModel2.getChineseName(MOUSE));
        list.add(AIDetectModel2.getChineseName(KEYBOARD));
        list.add(AIDetectModel2.getChineseName(CELLPHONE));
        list.add(AIDetectModel2.getChineseName(BOOK));

        list.add(AIDetectModel2.getChineseName(BOTTLE));

        return list;
    }

    public static AIDetectModel2 getModelType(String englishName) {
        switch (englishName) {
            case "person":
                return PERSON;
            case "bicycle":
                return BICYCLE;
            case "car":
                return CAR;
            case "motorcycle":
                return MOTORCYCLE;
            case "bus":
                return BUS;
            case "truck":
                return TRUCK;
            case "traffic light":
                return TRAFFICLIGHT;
            case "fire hydrant":
                return FIREHYDRANT;
            case "cup":
                return CUP;
            case "chair":
                return CHAIR;
            case "bird":
                return BIRD;
            case "cat":
                return CAT;
            case "dog":
                return DOG;
            case "potted plant":
                return POTTEDPLANT;
            case "tv":
                return TV;
            case "laptop":
                return LAPTOP;
            case "mouse":
                return MOUSE;
            case "keyboard":
                return KEYBOARD;
            case "cell phone":
                return CELLPHONE;
            case "book":
                return BOOK;
            case "bottle":
                return BOTTLE;
            case "垃圾箱":
                return BIN;
            case "D00":
                return LINEARCRACK;
            case "D01":
                return CONSTRUCTION;
            case "D10":
                return LINEARLATERAL;
            case "D11":
                return CONSTRUCTIONLATERAL;
            case "D20":
                return ALLIGATORCRACK;
            case "D40":
                return RUTTINGBUMP;
            case "D43":
                return CROSSWALK;
            case "D44":
                return WHITELINE;
            default:
                return NULL;
        }
    }
}
