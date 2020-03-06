//
//  SAIClassifyView.m
//  Supermap
//
//  Created by zhouyuming on 2019/11/22.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "SAIClassifyView.h"
#import "ImageClassification.h"
#import "Recognition.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SuperMap/DatasetVector.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Datasource.h"
#import "SMap.h"
#import "SLanguage.h"
#import "SMITabletUtils.h"

typedef enum {
    ASSETS_FILE,
    ABSOLUTE_FILE_PATH,
} ModelType;

NSString *const recognizeImage  = @"recognizeImage";

NSString* mDatasourceAlias=nil;
NSString* mDatasetName=nil;

static NSString* MODEL_PATH=@"";
static NSString* LABEL_PATH=@"";
static NSString* DEFAULT_LABEL_CN_TRANSLATE=@"";
static NSString* DEFAULT_LABEL_NAME=@"";
static NSString* DEFAULT_MODEL_NAME=@"";

static ImageClassification* mImageClassification=nil;

static NSArray* mListCNClassifyNames;
static NSArray* mListENClassifyNames;
//static NSString* mLanguage=@"CN";

static ModelType mModelType = ASSETS_FILE;
static UIImage * classifyImg;

@implementation SAIClassifyView


RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
             recognizeImage
             ];
}


#pragma mark 初始化
RCT_REMAP_METHOD(initAIClassify, initAIClassify:(NSString*)datasourceAlias datasetName:(NSString*)datasetName language:(NSString*)language resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mDatasourceAlias=datasourceAlias;
        mDatasetName=datasetName;
        
        [self initTensorFlowAndLoadModel];
//        mLanguage=language;
        [self initData];
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"initAIClassify", exception.reason, nil);
    }
}

#pragma mark 加载react-native-camera拍的照片（应用私有存储）
RCT_REMAP_METHOD(loadImageUri, loadImageUri:(NSString*)imgUri resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        NSString* error =  [SMITabletUtils checkLicValid];
        if(error != nil){
             resolve(@"License Invalid");
            return;
        }
        NSData *data = [NSData dataWithContentsOfFile:imgUri];
        classifyImg = [UIImage imageWithData:data];
        
        //获取全局队列
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        self.timer = timer;
        //设置触发的间隔时间
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        __block int index=0;
        //设置定时器的触发事件
        dispatch_source_set_event_handler(timer, ^{
            if(index==1){
//                resolve(@(NO));
                resolve(@(NO));
                dispatch_source_cancel(self.timer);
                self.timer=nil;
            }
            index++;
        });
        dispatch_resume(timer);
        
        NSArray* results=[mImageClassification recognizeImage:classifyImg];
        NSMutableArray* arr=[[NSMutableArray alloc] init];
        for(int i=0;i<results.count;i++){
            Recognition* recognition=results[i];
            NSMutableDictionary* recognitionDic=[[NSMutableDictionary alloc] init];
            NSString* label=recognition.label;
            if([[SLanguage getLanguage] isEqualToString:@"CN"]){
                if([mListENClassifyNames containsObject:label]){
                    NSInteger index=[mListENClassifyNames indexOfObject:label];
                    label=mListCNClassifyNames[index];
                }
            }
            [recognitionDic setObject:label forKey:@"Title"];
            NSString* confidence=[NSString stringWithFormat:@"%.2f",recognition.confidence*100];
            confidence=[confidence stringByAppendingString:@"%"];
            [recognitionDic setObject:confidence forKey:@"Confidence"];
            [recognitionDic setObject:[self getCurrentTime] forKey:@"Time"];
            [arr addObject:recognitionDic];
        }
        NSMutableDictionary* allResults=[[NSMutableDictionary alloc] init];
        [allResults setObject:arr forKey:@"results"];
        
        
//        [self sendEventWithName:recognizeImage body:allResults];

        //识别结束取消计时器
        dispatch_source_cancel(self.timer);
        self.timer=nil;

        resolve(@(YES));
        resolve(allResults);
    } @catch (NSException *exception) {
        reject(@"loadImageUri", exception.reason, nil);
    }
}


#pragma mark 识别选中的的图片
RCT_REMAP_METHOD(getImagePath, getImagePath:(NSString*)imgUri resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        //获取全局队列
        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
        self.timer = timer;
        //设置触发的间隔时间
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        __block int index=0;
        //设置定时器的触发事件
        dispatch_source_set_event_handler(timer, ^{
            if(index==1){
                resolve(@(NO));
                dispatch_source_cancel(self.timer);
                self.timer=nil;
            }
            index++;
        });
        dispatch_resume(timer);
        
        // 这里是原本的图片url
//        NSString * path = @"assets-library://asset/asset.JPG?id=9581C151-4582-4ABD-A581-1F34E037E1A0&ext=JPG";
        // 取出要使用的 LocalIdentifiers
//        NSString * usePath = @"9581C151-4582-4ABD-A581-1F34E037E1A0";
        NSArray *array = [imgUri componentsSeparatedByString:@"?id="]; //从字符A中分隔成2个元素的数组
        //如果是文件夹的图片,否则是相册的图片
        if([array count]==1){
            NSData *data = [NSData dataWithContentsOfFile:imgUri];
            UIImage * classifyImg = [UIImage imageWithData:data];
            NSArray* results=[mImageClassification recognizeImage:classifyImg];
            [self recognizeImageResultAnalyze:results];
            resolve(@(YES));
            return;
        }
        NSString *usePath=[((NSString*)array[1]) componentsSeparatedByString:@"&"][0];
        
        PHFetchResult * re = [PHAsset fetchAssetsWithLocalIdentifiers:@[usePath] options:nil];
        [re enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@", obj.localIdentifier);
            [[PHCachingImageManager defaultManager] requestImageDataForAsset:obj options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                
                classifyImg =  [UIImage imageWithData:imageData];
                
                NSArray* results=[mImageClassification recognizeImage:classifyImg];
                
                [self recognizeImageResultAnalyze:results];

                resolve(@(YES));
            }];
        }];
    } @catch (NSException *exception) {
        reject(@"getImagePath", exception.reason, nil);
    }
}
//处理分类识别返回的结果
-(void)recognizeImageResultAnalyze:(NSArray*)results{
    NSMutableArray* arr=[[NSMutableArray alloc] init];
    for(int i=0;i<results.count;i++){
        Recognition* recognition=results[i];
        NSMutableDictionary* recognitionDic=[[NSMutableDictionary alloc] init];
        NSString* label=recognition.label;
        if([[SLanguage getLanguage] isEqualToString:@"CN"]){
            if([mListENClassifyNames containsObject:label]){
                NSInteger index=[mListENClassifyNames indexOfObject:label];
                label=mListCNClassifyNames[index];
            }
        }
        [recognitionDic setObject:label forKey:@"Title"];
        NSString* confidence=[NSString stringWithFormat:@"%.2f",recognition.confidence*100];
        confidence=[confidence stringByAppendingString:@"%"];
        [recognitionDic setObject:confidence forKey:@"Confidence"];
        [recognitionDic setObject:[self getCurrentTime] forKey:@"Time"];
        [arr addObject:recognitionDic];
    }
    NSMutableDictionary* allResults=[[NSMutableDictionary alloc] init];
    [allResults setObject:arr forKey:@"results"];
    
    
    [self sendEventWithName:recognizeImage body:allResults];
    //识别结束取消计时器
    dispatch_source_cancel(self.timer);
    self.timer=nil;
}

#pragma mark 获取当前模型
RCT_REMAP_METHOD(getCurrentModel, getCurrentModel:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
        if(mModelType==ABSOLUTE_FILE_PATH){
            [dic setObject:MODEL_PATH forKey:@"ModelPath"];
            [dic setObject:LABEL_PATH forKey:@"LabelPath"];
            [dic setObject:@"ABSOLUTE_FILE_PATH" forKey:@"ModelType"];
        }else{
            [dic setObject:@"ASSETS_FILE" forKey:@"ModelType"];
        }
        
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"getCurrentModel", exception.reason, nil);
    }
}

#pragma mark 清除bitmap
RCT_REMAP_METHOD(clearBitmap, clearBitmap:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        classifyImg=nil;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"clearBitmap", exception.reason, nil);
    }
}

#pragma mark 修改最新的对象
RCT_REMAP_METHOD(modifyLastItem, modifyLastItem:(NSDictionary*)infoDic resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* datasourceAlias;
        NSString* datasetName;
        NSString* mediaName;
        NSString* remarks;
        if([infoDic objectForKey:datasourceAlias]){
            datasourceAlias=[infoDic objectForKey:@"datasourceAlias"];
        }
        if([infoDic objectForKey:datasetName]){
            datasetName=[infoDic objectForKey:@"datasetName"];
        }
        if([infoDic objectForKey:mediaName]){
            mediaName=[infoDic objectForKey:@"mediaName"];
        }
        if([infoDic objectForKey:remarks]){
            remarks=[infoDic objectForKey:@"remarks"];
        }
        
        DatasetVector* datasetVector=nil;
        SMap* sMap = [SMap singletonInstance];
        MapControl* mapControl=sMap.smMapWC.mapControl;
        Workspace* workspace=mapControl.map.workspace;
        Datasource* datasource = [workspace.datasources getAlias:datasourceAlias];
        datasetVector=(DatasetVector*)[datasource.datasets getWithName:datasetName];
        
        Recordset *recordset = [datasetVector recordset:NO cursorType:DYNAMIC];
        if(recordset){
            [recordset moveLast];
            [recordset edit];
            
            FieldInfos* fieldInfos=recordset.fieldInfos;
            if([fieldInfos indexOfWithFieldName:@"MediaName"]!=-1){
                NSString* str=nil;
                NSObject* ob=[recordset getFieldValueWithString:@"MediaName"];
                if(ob != nil){
                    str = (NSString*)ob;
                }
                if(![mediaName isEqualToString:str]){
                    [recordset setFieldValueWithString:@"MediaName" Obj:str];
                }
            }
            if([fieldInfos indexOfWithFieldName:@"Description"]!=-1){
                NSString* str=nil;
                NSObject* ob=[recordset getFieldValueWithString:@"Description"];
                if(ob != nil){
                    str = (NSString*)ob;
                }
                if(![remarks isEqualToString:str]){
                    [recordset setFieldValueWithString:@"Description" Obj:remarks];
                }
            }
            
            [recordset update];
            [recordset close];
            [recordset dispose];
        }
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"modifyLastItem", exception.reason, nil);
    }
}



+(void)saveClassifyBitmapAsFile:(NSString*)folderPath name:(NSString*)name{
    if(!classifyImg){
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL dataIsDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];

    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* imagePath=[folderPath stringByAppendingFormat:@"%@.jpg",name];
    // 保存图片到指定的路径
    NSData *data = UIImagePNGRepresentation(classifyImg);
    [data writeToFile:imagePath atomically:YES];
    if(classifyImg){
        classifyImg=nil;
    }
}

-(NSString*)getCurrentTime{
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    
    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];
    
    return nowDateString;
}

-(void) initTensorFlowAndLoadModel{
    
    DEFAULT_MODEL_NAME=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/iTablet/Common/AI/ClassifyModel/mobilenet_quant_224/mobilenet_quant_224.tflite"];
    DEFAULT_LABEL_NAME=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/iTablet/Common/AI/ClassifyModel/mobilenet_quant_224/mobilenet_quant_224.txt"];
    DEFAULT_LABEL_CN_TRANSLATE=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/iTablet/Common/AI/ClassifyModel/mobilenet_quant_224/mobilenet_quant_224_cn.txt"];

    
    
    if (mModelType == ASSETS_FILE) {
        mImageClassification=[[[ImageClassification alloc] init] initWithModle:DEFAULT_MODEL_NAME labels:DEFAULT_LABEL_NAME andThreadCount:1];
    }else{
        mImageClassification=[[[ImageClassification alloc] init] initWithModle:MODEL_PATH labels:LABEL_PATH andThreadCount:1];
    }
}

-(void) initData{
    mListCNClassifyNames = [self getAllChineseClassifyName];
    mListENClassifyNames = [self getAllEngClassifyName];
}

-(NSArray*) getAllChineseClassifyName{
    @try {
        NSMutableArray* array=[[NSMutableArray alloc] init];
        NSString *dataFile;
        if (mModelType == ASSETS_FILE) {
            dataFile = [NSString stringWithContentsOfFile:DEFAULT_LABEL_CN_TRANSLATE encoding:NSUTF8StringEncoding error:nil];
        }else{
            dataFile = [NSString stringWithContentsOfFile:LABEL_PATH encoding:NSUTF8StringEncoding error:nil];
        }
//        NSArray *dataarr = [dataFile componentsSeparatedByString:@"\r\n"];
        NSArray *dataarr = [dataFile componentsSeparatedByString:@"\n"];
        for (NSString *str in dataarr) {
            [array addObject:str];
        }
        return array;
    } @catch (NSException *exception) {
        return nil;
    }
    
//    NSMutableArray* array=[[NSMutableArray alloc] init];
//    NSString *dataFile
//    if (mModelType == ASSETS_FILE) {
//
//    }else{
//        dataFile = [NSString stringWithContentsOfFile:LABEL_PATH encoding:NSUTF8StringEncoding error:nil];
//    }
//
//    NSArray *dataarr = [dataFile componentsSeparatedByString:@"\n"];
//    for (NSString *str in dataarr) {
//        [array addObject:str];
//    }
//    return array;
}

-(NSArray*) getAllEngClassifyName{
    
    @try {
        NSMutableArray* array=[[NSMutableArray alloc] init];
        NSString *dataFile;
        if (mModelType == ASSETS_FILE) {
            dataFile = [NSString stringWithContentsOfFile:DEFAULT_LABEL_NAME encoding:NSUTF8StringEncoding error:nil];
        }else{
            dataFile = [NSString stringWithContentsOfFile:LABEL_PATH encoding:NSUTF8StringEncoding error:nil];
        }
        NSArray *dataarr = [dataFile componentsSeparatedByString:@"\n"];
//        NSArray *dataarr = [dataFile componentsSeparatedByString:@"\r\n"];
        for (NSString *str in dataarr) {
            [array addObject:str];
        }
        return array;
    } @catch (NSException *exception) {
        return nil;
    }
}

@end
