//
//  FileUtils.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/27.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

+ (BOOL)deleteFile:(NSString *)path {
    BOOL result = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]){
        result = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return result;
}

+ (BOOL)createFileDirectories:(NSString*)path
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

+ (BOOL)copyFile:(NSString *)fromPath targetPath:(NSString *)toPath {
    BOOL result = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fromPath]) {
        result = [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil];
    }
    return result;
}

+ (NSArray *)copyFiles:(NSArray *)fromPaths targetDictionary:(NSString *)targetDictionary {
    BOOL result = NO;
    if (targetDictionary == nil || [targetDictionary isEqualToString:@""]) {
        return nil;
    }
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    
    NSMutableArray* paths = [[NSMutableArray alloc] initWithArray:fromPaths];
    
    for (int i = 0; i < paths.count; i++) {
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", targetDictionary, [fromPaths[i] lastPathComponent]];
        if(
           [fileManager fileExistsAtPath:fromPaths[i]] &&
           ![fileManager fileExistsAtPath:filePath]
           ) {
            if ([fileManager copyItemAtPath:fromPaths[i] toPath:filePath error:&error]) {
                result = YES;
                [fileManager removeItemAtPath:fromPaths[i] error:&error];
                paths[i] = filePath;
            } else {
                result = NO;
                break;
                
            }
        }
    }
    return result ? paths : nil;
}

+ (NSString*)getLastModifiedTime:(NSDate*) nsDate{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *string=[fmt stringFromDate:nsDate];
    return string;
}

+ (NSDictionary *)readLocalFileWithPath:(NSString *)path {
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

/*
 * 获取用户名
 */
+ (NSString *)getUserName{
    SMap *sMap = [SMap singletonInstance];
    NSString *userName = [sMap.smMapWC getUserName];
    return userName;
}
@end
