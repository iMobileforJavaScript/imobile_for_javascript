//
//  SMMapRender.m
//  Supermap
//
//  Created by wnmng on 2019/8/19.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "SMMapRender.h"
#import "SMap.h"
#import "SuperMap/ThemeUnique.h"
#import "SuperMap/ThemeRange.h"
#import "SuperMap/ThemeLabel.h"
#include "vsopenapi.h"

@interface PythonParam:NSObject

@property (nonatomic,strong) UIImage* image;
@property (nonatomic,strong) NSString* picPath;
@property (nonatomic,assign) int compressMode;
@property (nonatomic,assign) int colorCount;

-(id)initWithImage:(UIImage*)img path:(NSString*)path mode:(int)mode count:(int)count;

@end

@implementation PythonParam
@synthesize image,picPath,compressMode,colorCount;
-(id)initWithImage:(UIImage *)img path:(NSString*)path mode:(int)mode count:(int)count{
    if (self = [super init]) {
        image = img;
        picPath = path;
        compressMode = mode;
        colorCount = count;
    }
    return self;
}
@end

@interface MatchedColorItem:NSObject

@property (nonatomic,strong) Color * sourceColor;
@property (nonatomic,strong) Color * keyColor;
@property (nonatomic,strong) Color * resultColor;

-(id)initWithSrc:(Color*)src key:(Color*)key result:(Color*)result;

@end

@implementation MatchedColorItem
@synthesize sourceColor,keyColor,resultColor;
-(id)initWithSrc:(Color *)src key:(Color *)key result:(Color *)result{
    if (self = [super init]) {
        sourceColor = src;
        keyColor = key;
        resultColor = result;
    }
    return self;
}
@end

@interface SMMapRender(){
    int _compressMode;
    int _colorNumber;
    ClassOfSRPControlInterface * SRPControl ;
    NSMutableDictionary* _matchedColors;
    NSThread *pythonThread;
}

@end

@implementation SMMapRender

//由Objective-C的一些特性可以知道，在对象创建的时候，无论是alloc还是new，都会调用到 allocWithZone方法。
+(id)allocWithZone:(struct _NSZone *)zone{
    return [SMMapRender sharedInstance];
}
// 在通过拷贝的时候创建对象时，会调用到-(id)copyWithZone:(NSZone *)zone，-(id)mutableCopyWithZone:(NSZone *)zone方法
-(id)copyWithZone:(NSZone *)zone{
    return [SMMapRender sharedInstance];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [SMMapRender sharedInstance];
}

// 串行队列的创建方法
//static dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
+(id)sharedInstance{
    // 为了隔离外部修改，放在方法内部，在设置成静态变量
    static id smMapRenderInstance = nil;
//    // 同步执行任务创建方法
//    dispatch_sync(queue,^{
//        if(smMapRenderInstance ==  nil){
//            //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
//            //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
//            smMapRenderInstance =  [[super allocWithZone:nil] init] ;
//            [smMapRenderInstance onCreate];
//        }
//    });
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        if(smMapRenderInstance ==  nil){
            //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
            //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
            smMapRenderInstance =  [[super allocWithZone:nil] init] ;
            [smMapRenderInstance onCreate];

        }
    });
    return (SMMapRender*)smMapRenderInstance;
}

static VS_UWORD MsgCallBack( VS_ULONG ServiceGroupID, VS_ULONG uMsg, VS_UWORD wParam, VS_UWORD lParam, VS_BOOL *IsProcessed, VS_UWORD Para )
{
    switch( uMsg ){
        case MSG_VSDISPMSG :
        case MSG_VSDISPLUAMSG :
            //printf("[core]wnmng:%s\n",(VS_CHAR *)wParam);
            break;
        case MSG_DISPMSG :
        case MSG_DISPLUAMSG :
        {
            //printf("__wnmng___:%s\n",(VS_CHAR *)wParam);
            NSString *strResult = [NSString stringWithCString:(VS_CHAR *)wParam encoding:NSUTF8StringEncoding];
            [SMMapRender.sharedInstance recievePythonResult:strResult];
        }
            break;
    }
    return 0;
}

static class ClassOfSRPInterface *SRPInterface;


extern "C" void init_ssl(void);
extern "C" void init_hashlib(void);


extern "C" void init_imaging(void);
extern "C" void init_imagingmorph(void);
extern "C" void init_imagingft(void);
extern "C" void init_imagingmath(void);

-(void)onCreate{
    
    _matchedColors = [[NSMutableDictionary alloc]init];
    _compressMode = 0;
    _colorNumber = 50;
    pythonThread = [[NSThread alloc]initWithBlock:^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        const char* destDir = [documentsDirectory UTF8String];
        VS_BOOL Result = StarCore_Init((VS_CHAR *)destDir);
        
        NSString *respaths = [[NSBundle mainBundle] resourcePath];
        const VS_CHAR *res_cpath = [respaths UTF8String];
        VS_CHAR python_path[512];
        VS_CHAR python_home[512];
        sprintf(python_home,"%s/python",res_cpath);
        sprintf(python_path,"%s:%s/python2.7.zip",res_cpath,res_cpath);
        static VSImportPythonCModuleDef CModuleDef[]={{"_imaging",(void*)init_imaging},{"_imagingmorph",(void*)init_imagingmorph},{"_imagingft",(void*)init_imagingft},{"_imagingmath",(void*)init_imagingmath},{NULL,NULL}};
        
        VSCoreLib_InitPython((VS_CHAR*)python_home,(VS_CHAR *)python_path,CModuleDef);
        
        VS_CORESIMPLECONTEXT Context;
        
        SRPInterface = VSCoreLib_InitSimple(&Context,(VS_CHAR*)"test",(VS_CHAR*)"123",0,0,MsgCallBack,0,NULL);
        SRPInterface ->CheckPassword(VS_FALSE);
        
        class ClassOfBasicSRPInterface *BasicSRPInterface;
        BasicSRPInterface = SRPInterface ->GetBasicInterface();
        BasicSRPInterface ->InitRaw((VS_CHAR*)"python",SRPInterface);
        void *python = SRPInterface ->ImportRawContext((VS_CHAR*)"python",(VS_CHAR*)"",false,NULL);
        
        SRPControl = BasicSRPInterface->GetSRPControlInterface();

        @autoreleasepool {
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            //如果注释了下面这一行，子线程中的任务并不能正常执行
            [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
            //NSLog(@"启动RunLoop前--%@",runLoop.currentMode);
            [runLoop run];
        }
    }];
    
    [pythonThread start];
    
}

-(void)pythonMatchPictureStyle:(NSString*)desImgPath from:(NSString*)mapImgPath colorCount:(int)nColorCount mode:(int)nMode{
    
    NSMutableString *script = [[NSMutableString alloc]init];
    [script appendString:@"import os, sys\n"];
    [script appendString:@"import traceback\n"];
    [script appendString:@"try:\n"];
    [script appendString:@" from PIL import Image\n"];
    [script appendString:@" \n"];
    [script appendString:@" def get_colors(pic, colors, mode):\n"];
    [script appendString:@" \tcolor_str = []\n"];
    [script appendString:@" \timg = Image.open(pic)\n"];
    [script appendString:@" \tif mode != 0:\n"];
    [script appendString:@" \t\toriginalWidth, originalHeight = img.size\n"];
    [script appendString:@" \t\tpercentWidth = 200*1.0 / originalWidth\n"];
    [script appendString:@" \t\tpercentHeight = 200*1.0 / originalHeight\n"];
    [script appendString:@" \t\tif percentHeight < percentWidth:\n"];
    [script appendString:@" \t\t\tpercent = percentHeight\n"];
    [script appendString:@" \t\telse:\n"];
    [script appendString:@" \t\t\tpercent = percentWidth\n"];
    [script appendString:@" \t\twidth2 = int(round(originalWidth * percent))\n"];
    [script appendString:@" \t\theight2 = int(round(originalHeight * percent))\n"];
    [script appendString:@" \tif mode == 1:\n"];
    [script appendString:@" \t\timg = img.resize((width2, height2), Image.ANTIALIAS)\n"];
    [script appendString:@" \telif mode == 2:\n"];
    [script appendString:@" \t\timg = img.resize((width2, height2), Image.NEAREST)\n"];
    [script appendString:@" \telif mode == 3:\n"];
    [script appendString:@" \t\timg = img.resize((width2, height2), Image.BILINEAR)\n"];
    [script appendString:@" \telif mode == 4:\n"];
    [script appendString:@" \t\timg = img.resize((width2, height2), Image.BICUBIC)\n"];
    [script appendString:@" \twidth, height = img.size\n"];
    [script appendString:@" \tquantized = img.quantize(colors, kmeans=3)\n"];
    [script appendString:@" \tconvert_rgb = quantized.convert('RGB')\n"];
    [script appendString:@" \tcolors = convert_rgb.getcolors()\n"];
    [script appendString:@" \tcolor_str = sorted(colors, reverse=True)\n"];
    [script appendString:@" \tfinal_list = []\n"];
    [script appendString:@" \tfor i in color_str:\n"];
    [script appendString:@" \t\tfinal_list.append((i[1][0]<<16)|(i[1][1]<<8)|i[1][2])\n"];
    [script appendString:@" \treturn final_list\n"];
    [script appendString:@" \n"];
    [script appendFormat:@" path1 = \"%@\"\n",desImgPath];
    [script appendFormat:@" path2 = \"%@\"\n",mapImgPath];
    [script appendFormat:@" color_count = %d\n",nColorCount];
    [script appendFormat:@" mode = %d\n",nMode];
    [script appendString:@" result1 = get_colors(path1, color_count, mode)\n"];
    [script appendString:@" result2 = get_colors(path2, color_count, mode)\n"];
    [script appendString:@" print(result1,result2)\n"];
    //[script appendString:@" print(result2)\n"];
    [script appendString:@"except Exception,e:\n"];
    [script appendString:@" traceback.print_exc()"];
    SRPControl->SRPLock();
    const VS_CHAR *str = [script UTF8String];
    SRPInterface->DoBuffer("python", str, strlen(str), NULL, NULL, NULL, VS_TRUE);
    SRPControl->SRPUnLock();
}


-(void)recievePythonResult:(NSString*)strResult{
    NSRange range = [strResult rangeOfString:@"], ["];
    if ( range.location ==  NSNotFound) {
        return;
    }
    NSString* strDesRes = [strResult substringWithRange:NSMakeRange(1, range.location)];
    NSArray* arrDesNum = [NSJSONSerialization JSONObjectWithData:[strDesRes dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (arrDesNum==nil || arrDesNum.count==0) {
        return;
    }
    NSMutableArray *arrDesColor = [[NSMutableArray alloc] init];
    for (int i=0; i<arrDesNum.count; i++) {
        int rgb = [[arrDesNum objectAtIndex:i]intValue];
        int b = rgb & 0xff;
        int g = (rgb>>8) & 0xff;
        int r = (rgb>>16) & 0xff;
        Color* colorTemp = [[Color alloc]initWithR:r G:g B:b ];
        [arrDesColor addObject:colorTemp];
    }
    
    NSString* strSrcRes = [strResult substringWithRange:NSMakeRange(range.location+3, strResult.length-1-(range.location+3))];
    NSArray* arrSrcNum = [NSJSONSerialization JSONObjectWithData:[strSrcRes dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if (arrSrcNum==nil || arrSrcNum.count==0) {
        return;
    }
    NSMutableArray *arrSrcColor = [[NSMutableArray alloc] init];
    for (int i=0; i<arrSrcNum.count; i++) {
        int rgb = [[arrSrcNum objectAtIndex:i]intValue];
        int b = rgb & 0xff;
        int g = (rgb>>8) & 0xff;
        int r = (rgb>>16) & 0xff;
        Color* colorTemp = [[Color alloc]initWithR:r G:g B:b ];
        [arrSrcColor addObject:colorTemp];
    }
    Map* map = [[[[SMap singletonInstance]smMapWC]mapControl] map];
    [self setMapStyle:map withDes:arrDesColor fromSrc:arrSrcColor];
}

/**
 * 获取地图的所有子图层
 *
 * @DesktopJavaDocable enable
 */
-(NSArray*)getAllLayersFromMap:(Map*)map{
    NSMutableArray *arrRes = [[NSMutableArray alloc]init];
    for (int i=0; i<map.layers.getCount; i++) {
        Layer *layerTemp = [map.layers getLayerAtIndex:i];
        if ([layerTemp isKindOfClass:LayerGroup.class]) {
            [arrRes addObjectsFromArray:[self getAllLayersFromGroup:(LayerGroup *)layerTemp]];
        }else{
            [arrRes addObject:layerTemp];
        }
    }
    return arrRes;
}
-(NSArray*)getAllLayersFromGroup:(LayerGroup*)group{
    NSMutableArray *arrRes = [[NSMutableArray alloc]init];
    for (int i=0; i<group.getCount;i++) {
        Layer *layerTemp = [group getLayer:i];
        if ([layerTemp isKindOfClass:LayerGroup.class]) {
            [arrRes addObjectsFromArray:[self getAllLayersFromGroup:(LayerGroup *)layerTemp]];
        }else{
            [arrRes addObject:layerTemp];
        }
    }
    return arrRes;
}

-(void)setMapStyle:(Map*)map withDes:(NSArray*)arrDesColor fromSrc:(NSArray*)arrSrcColor{
    
    [_matchedColors removeAllObjects];
    NSArray* arrLayers = [self getAllLayersFromMap:map];
    for (int i=0; i<arrLayers.count; i++) {
        Layer* layer = [arrLayers objectAtIndex:i];
        if (layer.visible && layer.dataset!=nil) {
            
            DatasetType datasetType = layer.dataset.datasetType;
            if (datasetType==POINT
                || datasetType==LINE
                || datasetType==REGION
                || datasetType==PointZ
                || datasetType==LineZ
                || datasetType==RegionZ
                //|| datasetType==LINEM
                //|| datasetType==MODEL
                || datasetType==TABULAR
                || datasetType==Network
                || datasetType==NETWORK3D
                || datasetType==CAD
                || datasetType==TEXT
                ){
                if (layer.theme==nil) {
                    [self setDatasetVectorSimplyColors:layer withDes:arrDesColor src:arrSrcColor];
                }else{
                    [self setDatasetVectorThemeColors:layer withDes:arrDesColor src:arrSrcColor];
                }
            }
            //else if (DatasetTypeUtilities.isGridDataset(layer.getDataset().getType())) {
            //}
            //else if (DatasetTypeUtilities.isImageDataset(layer.getDataset().getType())) {
            //}
            
        }
    }
    [map refresh];
}

-(Color*)getMatchedColor:(Color*)color  withDes:(NSArray*)arrDesColors src:(NSArray*)arrSrcColors tolerance:(int)tolerance{
    Color* resultColor = nil;
    int minTolerance = tolerance * 3;
    Color* keyColor = nil;
    MatchedColorItem *matchedColorsItem = [_matchedColors objectForKey:color.toColorString];
    if (matchedColorsItem!=nil) {
        resultColor = [matchedColorsItem resultColor];
        keyColor = [matchedColorsItem keyColor];
        minTolerance = abs(keyColor.red - color.red) + abs(keyColor.green - color.green) + abs(keyColor.blue - color.blue);
    } else {
        int index = -1;
        for (int i=0;i<arrSrcColors.count;i++) {
            Color* key = [arrSrcColors objectAtIndex:i];
            if (abs(key.red - color.red) + abs(key.green - color.green) + abs(key.blue - color.blue) < minTolerance) {
                //if (resultColor == null) {
                //keyColor = key;
                index = i;
                minTolerance = abs(key.red - color.red) + abs(key.green - color.green) + abs(key.blue - color.blue);
                //}
                //                    else if (Math.abs(key.getR() - color.getR()) + Math.abs(key.getG() - color.getG()) + Math.abs(key.getB() - color.getB())
                //                            < Math.abs(keyColor.getR() - color.getR()) + Math.abs(keyColor.getG() - color.getG()) + Math.abs(keyColor.getB() - color.getB())) {
                //                        //keyColor = key;
                //                        index = i;
                //                        minTolerance = Math.abs(key.getR() - color.getR()) + Math.abs(key.getG() - color.getG()) + Math.abs(key.getB() - color.getB());
                //                    }
            }
        }
        
        if (index>=0) {
            keyColor = [arrSrcColors objectAtIndex:index];
            resultColor = [arrDesColors objectAtIndex:index];
            // matchedColors.remove(keyColor);
            
            matchedColorsItem = [[MatchedColorItem alloc]initWithSrc:color key:keyColor result:resultColor];
            //if (!m_matchedColors.containsKey(color)) {
            //    m_matchedColors.put(color, matchedColorsItem);
            // }
            [_matchedColors setObject:matchedColorsItem forKey:color.toColorString];
        }
    }
    return resultColor;
}

-(void)setDatasetVectorSimplyColors:(Layer*)layer withDes:(NSArray*)arrDesColors src:(NSArray*)arrSrcColors{
    DatasetType datasetType = layer.dataset.datasetType;
    if (datasetType==POINT
        || datasetType==PointZ
        || datasetType==LINE
        || datasetType==Network
        || datasetType==LineZ
        || datasetType==NETWORK3D
        ){
        Color *colorOrg = [[(LayerSettingVector*) layer.layerSetting geoStyle] getLineColor];
        if (colorOrg!=nil) {
            Color*  matchedColor = [self getMatchedColor:colorOrg withDes:arrDesColors src:arrSrcColors tolerance:100];
            if (matchedColor!=nil) {
                [[(LayerSettingVector*) layer.layerSetting geoStyle] setLineColor:matchedColor];
            }
        }
    }else if(datasetType==REGION
             || datasetType==RegionZ){
        Color *colorF = [[(LayerSettingVector*) layer.layerSetting geoStyle] getFillForeColor];
        if (colorF!=nil) {
            Color*  matchedColor = [self getMatchedColor:colorF withDes:arrDesColors src:arrSrcColors tolerance:100];
            if (matchedColor!=nil) {
                [[(LayerSettingVector*) layer.layerSetting geoStyle] setFillForeColor:matchedColor];
            }
        }
        
        Color *colorOrg = [[(LayerSettingVector*) layer.layerSetting geoStyle] getLineColor];
        if (colorOrg!=nil) {
            Color*  matchedColor = [self getMatchedColor:colorOrg withDes:arrDesColors src:arrSrcColors tolerance:100];
            if (matchedColor!=nil) {
                [[(LayerSettingVector*) layer.layerSetting geoStyle] setLineColor:matchedColor];
            }
        }
    }
}

-(void)setDatasetVectorThemeColors:(Layer*)layer withDes:(NSArray*)arrDesColors src:(NSArray*)arrSrcColors{
    Theme *theme = layer.theme;
    if (theme.themeType == TT_Unique) {
        ThemeUnique* themeUnique = (ThemeUnique*)theme;
        DatasetType datasetType = layer.dataset.datasetType;
        int nType = 0;
        if (datasetType==POINT
            || datasetType==PointZ
            || datasetType==LINE
            || datasetType==Network
            || datasetType==LineZ
            || datasetType==NETWORK3D
            ){
            nType = 1;
        }
        else if(datasetType==REGION
                || datasetType==RegionZ){
            nType = 2;
        }
        for (int i=0; i<themeUnique.getCount; i++) {
            if (nType==1) {
                Color *colorOrg = [[[themeUnique getItem:i] mStyle]getLineColor];
                if (colorOrg!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorOrg withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeUnique getItem:i] mStyle]setLineColor:matchedColor];
                    }
                }
            }else if(nType==2){
                Color *colorF = [[[themeUnique getItem:i] mStyle]getFillForeColor];;
                if (colorF!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorF withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeUnique getItem:i] mStyle]setFillForeColor:matchedColor];;
                    }
                }
                
                Color *colorOrg = [[[themeUnique getItem:i] mStyle]getLineColor];
                if (colorOrg!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorOrg withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeUnique getItem:i] mStyle]setLineColor:matchedColor];
                    }
                }
            }
        }
        
    }
    else if(theme.themeType == TT_Range){
        ThemeRange *themeRange = (ThemeRange*)theme;
        DatasetType datasetType = layer.dataset.datasetType;
        int nType = 0;
        if (datasetType==POINT
            || datasetType==PointZ
            || datasetType==LINE
            || datasetType==Network
            || datasetType==LineZ
            || datasetType==NETWORK3D
            ){
            nType = 1;
        }
        else if(datasetType==REGION
                || datasetType==RegionZ){
            nType = 2;
        }
        for (int i=0; i<themeRange.getCount; i++) {
            if (nType==1) {
                Color *colorOrg = [[[themeRange getItem:i] mStyle]getLineColor];
                if (colorOrg!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorOrg withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeRange getItem:i] mStyle]setLineColor:matchedColor];
                    }
                }
            }else if(nType==2){
                Color *colorF = [[[themeRange getItem:i] mStyle]getFillForeColor];;
                if (colorF!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorF withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeRange getItem:i] mStyle]setFillForeColor:matchedColor];;
                    }
                }
                
                Color *colorOrg = [[[themeRange getItem:i] mStyle]getLineColor];
                if (colorOrg!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorOrg withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeRange getItem:i] mStyle]setLineColor:matchedColor];
                    }
                }
            }
        }
    }
    else if(theme.themeType == TT_Graph){
        
    }
    else if(theme.themeType == TT_GraduatedSymbol){
        
    }else if(theme.themeType == TT_DotDensity){
        
    }else if(theme.themeType == TT_label){
        ThemeLabel *themeLabel = (ThemeLabel*)theme;
        if (themeLabel.getUniqueCount>0) {
            
            for (int i=0; i<themeLabel.getUniqueCount; i++) {
                Color *colorF = [[[themeLabel getUniqueItem:i] textStyle]getForeColor];
                if (colorF!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorF withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeLabel getUniqueItem:i] textStyle]setForeColor:matchedColor];
                    }
                }
                
                Color *colorB =  [[[themeLabel getUniqueItem:i] textStyle]getBackColor];
                if (colorB!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorB withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeLabel getUniqueItem:i] textStyle]setBackColor:matchedColor];
                    }
                }
            }
            
        }else if(themeLabel.getRangeCount>0){
            
            for (int i=0; i<themeLabel.getRangeCount; i++) {
                Color *colorF = [[[themeLabel getRangeItem:i] mTextStyle]getForeColor];
                if (colorF!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorF withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeLabel getRangeItem:i] mTextStyle]setForeColor:matchedColor];
                    }
                }
                
                Color *colorB =  [[[themeLabel getRangeItem:i] mTextStyle]getBackColor];
                if (colorB!=nil) {
                    Color*  matchedColor = [self getMatchedColor:colorB withDes:arrDesColors src:arrSrcColors tolerance:100];
                    if (matchedColor!=nil) {
                        [[[themeLabel getRangeItem:i] mTextStyle]setBackColor:matchedColor];
                    }
                }
            }
            
        }else if(themeLabel.mUniformStyle!=nil){
            Color *colorF = [[themeLabel mUniformStyle]getForeColor];
            if (colorF!=nil) {
                Color*  matchedColor = [self getMatchedColor:colorF withDes:arrDesColors src:arrSrcColors tolerance:100];
                if (matchedColor!=nil) {
                    [[themeLabel mUniformStyle]setForeColor:matchedColor];
                }
            }
            
            Color *colorB =  [[themeLabel mUniformStyle]getBackColor];
            if (colorB!=nil) {
                Color*  matchedColor = [self getMatchedColor:colorB withDes:arrDesColors src:arrSrcColors tolerance:100];
                if (matchedColor!=nil) {
                    [[themeLabel mUniformStyle]setBackColor:matchedColor];
                }
            }
        }
        
    }
    
}

-(void)setCompressMode:(int)mode{
    if (mode<0 || mode>4){
        return;
    }else{
        _compressMode=mode;
    }
}
-(int)compressMode{
    return _compressMode;
}
-(void)setColorNumber:(int)num{
    if (num<50 || num>200){
        return;
    }else{
        _colorNumber = num;
    }
}
-(int)colorNumber{
    return _colorNumber;
}

-(void)matchPictureStyle:(NSString *)strImagePath{
    BOOL isDir = false;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:strImagePath isDirectory:&isDir];
    if ( (!isExist) || isDir) {
        return;
    }
    
    int nColorNumber = _colorNumber;
    int nCompressMode = _compressMode;
    // 主队列的获取方法
    dispatch_queue_t maiQueue = dispatch_get_main_queue();
    dispatch_async(maiQueue, ^{
        MapControl *mapcontrol = [[[SMap singletonInstance] smMapWC] mapControl];
        if ([[[mapcontrol map]layers]getCount]==0) {
            return ;
        }
        CGImageRef imgRef = [mapcontrol outputMap:mapcontrol.bounds];
        UIImage *image = [[UIImage alloc]initWithCGImage:imgRef];
        //pathon线程
        [self performSelector:@selector(pythonThreadRun:) onThread:pythonThread withObject:[[PythonParam alloc]initWithImage:image path:strImagePath mode:nCompressMode count:nColorNumber] waitUntilDone:NO];
    });
    
}

-(void)pythonThreadRun:(PythonParam*)parame{

    UIImage*image = parame.image;
    NSString*strPicPath = parame.picPath;
    UIImage *desImg = [UIImage imageWithContentsOfFile:strPicPath];
    int nColorNumber =  parame.colorCount;
    int nCompressMode =  parame.compressMode;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *strDir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/MapRenderCache"];
    BOOL isDir = false;
    BOOL isExist = [manager fileExistsAtPath:strDir isDirectory:&isDir];
    if (!isExist || !isDir) {
        [manager createDirectoryAtPath:strDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *strMapPath = [NSString stringWithFormat:@"%@/src_temporary.png",strDir];
    //NSString *strMapPath = [NSString stringWithFormat:@"%@/temporary.jpg",strDir];
    //NSString *strMapPath = [NSString stringWithFormat:@"%@/BeachStones.jpg",strDir];
    isDir = true;
    isExist = [manager fileExistsAtPath:strMapPath isDirectory:&isDir];
    if (isExist && !isDir) {
        [manager removeItemAtPath:strMapPath error:nil];
    }
    //NSData *imgData = UIImageJPEGRepresentation(image,1.0);
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:strMapPath atomically:YES];
    
    NSString *strImagePath = [NSString stringWithFormat:@"%@/des_temporary.png",strDir];
    isDir = true;
    isExist = [manager fileExistsAtPath:strImagePath isDirectory:&isDir];
    if (isExist && !isDir) {
        [manager removeItemAtPath:strImagePath error:nil];
    }
    NSData *desData = UIImagePNGRepresentation(desImg);
    [desData writeToFile:strImagePath atomically:YES];
    
    [self pythonMatchPictureStyle:strImagePath from:strMapPath colorCount:nColorNumber mode:nCompressMode];
}

@end
