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

+ (BOOL)copyFiles:(NSString *)from targetDictionary:(NSString *)to filterFileSuffix:(NSString *)filterFileSuffix
        filterFileDicName:(NSString*)filterFileDicName otherFileDicName:(NSString*)otherFileDicName{
    
    if (to == nil || [to isEqualToString:@""]) {
        return NO;
    }
    BOOL idDicfromFile=FALSE;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:from isDirectory:&idDicfromFile] ) {
        return NO;
    }
    NSString* fromName=[fileManager displayNameAtPath:from];
    NSString* toPath=[self formateNoneExistFileName:[NSString stringWithFormat:@"%@/%@",to ,fromName] isDir:idDicfromFile];
    NSString* filterFileDicPath=[NSString stringWithFormat:@"%@/%@",toPath ,filterFileDicName];
    NSString* otherFileDicPath=[NSString stringWithFormat:@"%@/%@",toPath ,otherFileDicName];
    if(![fileManager fileExistsAtPath:toPath]){
        [fileManager createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if(!idDicfromFile){
        return [self copyFile:from targetPath:toPath];
    }
    
    [fileManager createDirectoryAtPath:filterFileDicPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createDirectoryAtPath:otherFileDicPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:from error:nil];
    for (int i=0; i<array.count; i++) {
        NSString *filePath = [from stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDic=NO;
        [fileManager fileExistsAtPath:filePath isDirectory:&isDic];
        if(!isDic){
            NSString* strSuffix=[filePath pathExtension];
            NSString* copyDic=[strSuffix isEqualToString:filterFileSuffix]?filterFileDicPath:otherFileDicPath;
            [self copyFile:filePath targetPath:[NSString stringWithFormat:@"%@/%@",copyDic,[filePath lastPathComponent]]];
            continue;
        }
        NSArray *subArr = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
        int count=0;
        for (int index=0; index<subArr.count; index++) {
            NSString *subFilePath = [from stringByAppendingPathComponent:[subArr objectAtIndex:index]];
            if([[subFilePath pathExtension] isEqualToString:filterFileSuffix]){
                count++;
            }
        }
        if(count==0){
            [self copyFile:filePath targetPath:otherFileDicPath];
        }else{
            NSArray *childArr = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
            for (int childIndex=0; childIndex<subArr.count; childIndex++) {
                NSString *childFilePath = [filePath stringByAppendingPathComponent:[childArr objectAtIndex:childIndex]];
                [fileManager fileExistsAtPath:childFilePath isDirectory:&isDic];
                if(!isDic){
                    NSString* strSuffix=[childFilePath pathExtension];
                    NSString* copyDic=[strSuffix isEqualToString:filterFileSuffix]?filterFileDicPath:otherFileDicPath;
                    [self copyFile:childFilePath targetPath:[NSString stringWithFormat:@"%@/%@",copyDic,[childFilePath lastPathComponent]]];
                    continue;
                }else{
                    [self copyFile:childFilePath targetPath:[otherFileDicPath stringByAppendingPathComponent:[childArr objectAtIndex:childIndex]]];
                }
            }
        }
    }
    return YES;
}

+(NSString*)formateNoneExistFileName:(NSString*)strPath isDir:(BOOL)bDirFile{
    NSString*strName = strPath;
    NSString*strSuffix = @"";
    if (!bDirFile) {
        NSArray *arrPath = [strPath componentsSeparatedByString:@"/"];
        NSString *strFileName = [arrPath lastObject];
        NSArray *arrFileName = [strFileName componentsSeparatedByString:@"."];
        strSuffix = [arrFileName lastObject];
        strName = [strPath substringToIndex:strPath.length-strSuffix.length-1];
    }
    NSString *strResult = strPath;
    int nAddNumber = 1;
    while (1) {
        BOOL isDir  = false;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:strResult isDirectory:&isDir];
        if (!isExist) {
            return strResult;
        }else if(isDir!=bDirFile){
            return strResult;
        }else{
            if (!bDirFile) {
                strResult = [NSString stringWithFormat:@"%@_%d.%@",strName,nAddNumber,strSuffix];
            }else{
                strResult = [NSString stringWithFormat:@"%@_%d",strName,nAddNumber];
            }
            nAddNumber++;
        }
    }
}

+ (NSArray *)copyFiles:(NSArray *)fromPaths targetDictionary:(NSString *)targetDictionary {
//    BOOL result = NO;
    if (targetDictionary == nil || [targetDictionary isEqualToString:@""]) {
        return nil;
    }
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    
    NSMutableArray* paths = [[NSMutableArray alloc] initWithArray:fromPaths];
    
    for (int i = 0; i < paths.count; i++) {
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", targetDictionary, [fromPaths[i] lastPathComponent]];
        if(
           [fileManager fileExistsAtPath:fromPaths[i]]
//           && ![fileManager fileExistsAtPath:filePath]
           ) {
            // 如果目标地址文件已存在，则直接存入paths
            if ([fileManager copyItemAtPath:fromPaths[i] toPath:filePath error:&error]) {
//                result = YES;
                [fileManager removeItemAtPath:fromPaths[i] error:&error];
//                paths[i] = filePath;
            } else {
//                result = NO;
//                break;
            }
            paths[i] = filePath;
        }
    }
//    return result ? paths : nil;
    return paths;
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
