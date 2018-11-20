//
//  SMFileUtil.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/20.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMFileUtil.h"

@implementation SMFileUtil
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(getHomeDirectory,getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSString* home = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    if (home) {
        resolve(@{@"homeDirectory":home});
    }else{
        reject(@"systemUtil",@"get home directory failed",nil);
    }
}
RCT_REMAP_METHOD(getPathListByFilter, path:(NSString*)path filter:(NSDictionary*)filter getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:path error:nil];
    
    NSString* filterKey = filter[@"name"];
    NSString* filterEx = filter[@"type"];
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [path stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            NSString* tt = [fullPath stringByReplacingOccurrencesOfString:[NSHomeDirectory() stringByAppendingString:@"/Documents"] withString:@""];
            NSString* extension = [tt pathExtension];
            NSString* fileName = [tt lastPathComponent];
            if(([filterEx containsString:extension] && ([fileName containsString:filterKey] || [filterKey isEqualToString:@""])) || flag) {
                [array addObject:@{@"name":fileName,@"path":tt,@"isDirectory":@(flag)}];
            }
                
        }
        
    }
    
    resolve(array);
}

RCT_REMAP_METHOD(getDirectoryContent, path:(NSString*)path getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
   // NSString* home = NSHomeDirectory();
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        NSString* fullPath = [path stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            if (!flag) {
                [array addObject:@{@"name":fileName,@"type":@"file"}];
                
            }else{
                [array addObject:@{@"name":fileName,@"type":@"directory"}];
            }
        }
    }
    resolve(array);
}
+(BOOL)createFileDirectories:(NSString*)path
{
    // 判断存放音频、视频的文件夹是否存在，不存在则创建对应文件夹
    NSString* DOCUMENTS_FOLDER_AUDIO = path;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:DOCUMENTS_FOLDER_AUDIO isDirectory:&isDir];
    
    
    if(!(isDirExist && isDir)){
        BOOL bCreateDir = [fileManager createDirectoryAtPath:DOCUMENTS_FOLDER_AUDIO withIntermediateDirectories:YES attributes:nil error:nil];
        
        if(!bCreateDir){
            
            NSLog(@"Create Directory Failed.");
            return NO;
        }else
        {
            //  NSLog(@"%@",DOCUMENTS_FOLDER_AUDIO);
            return YES;
        }
    }
    
    return YES;
}

RCT_REMAP_METHOD(createDirectory,createDirectoryPath:(NSString*)path getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    // NSString* home = NSHomeDirectory();
    BOOL b = [SMFileUtil createFileDirectories:path];
    
    resolve(@(b));
    
}

RCT_REMAP_METHOD(assetsDataToSD,assetsDataToSDPath:(NSString*)path getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    // NSString* home = NSHomeDirectory();
    BOOL b = false;//[JSSystemUtil createFileDirectories:path];
    
    resolve(@(b));
    
}

RCT_REMAP_METHOD(isDirectory,isDirectoryPath:(NSString*)path getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    // NSString* home = NSHomeDirectory();
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    resolve(@(isDirExist&&isDir));
    
}

RCT_REMAP_METHOD(getPathList,getPathListPath:(NSString*)path getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [path stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            
            NSString* tt = [fullPath stringByReplacingOccurrencesOfString:[NSHomeDirectory() stringByAppendingString:@"/Documents"] withString:@""];
            [array addObject:@{@"name":fileName,@"path":tt,@"isDirectory":@(flag)}];
          //  [array addObject:@{@"name":fileName,@"type":@"directory"}];
        }
        
    }
    
    resolve(array);
    
}

RCT_REMAP_METHOD(fileIsExist,fileIsExistPath:(NSString*)path getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
   // NSString* home = NSHomeDirectory();
    BOOL b =[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil];
    
    resolve(@{@"isExist":@(b)});
    
}

RCT_REMAP_METHOD(fileIsExistInHomeDirectory,fileIsExistInHomeDirectoryPath:(NSString*)path getHomeDirectoryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSString* home = NSHomeDirectory();
    BOOL b =[[NSFileManager defaultManager] fileExistsAtPath:[home stringByAppendingFormat:@"/Documents/%@",path] isDirectory:nil];
    //BOOL b = [[NSFileManager defaultManager] createDirectoryAtPath:[home stringByAppendingFormat:@"/Documents/%@",path] withIntermediateDirectories:NO attributes:nil error:nil];
    resolve(@{@"isExist":@(b)});
}
@end
