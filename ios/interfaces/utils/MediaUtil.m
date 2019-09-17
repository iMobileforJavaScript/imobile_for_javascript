//
//  MediaUtil.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "MediaUtil.h"

@implementation MediaUtil
#pragma mark - 获取视屏缩略图
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    
//    filePath = [filePath stringByReplacingOccurrencesOfString:@"file://"
//                                                   withString:@""];
    
    //视频路径URL
    NSURL *fileURL;
    if ([filePath hasPrefix:@"assets-library"]) {
        fileURL = [NSURL URLWithString:filePath];
    } else {
        fileURL = [NSURL fileURLWithPath:filePath];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}

#pragma mark - 获取视屏缩略图
+ (NSDictionary *)getScreenShotImage:(NSString *)filePath {
    
    UIImage *shotImage = [MediaUtil getScreenShotImageFromVideoPath:filePath];
    
    // save to temp directory
    NSString* tempDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                   NSUserDomainMask,
                                                                   YES) lastObject];
    
    NSData *data = UIImagePNGRepresentation(shotImage);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath = [tempDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Screen_%@.png", [[NSProcessInfo processInfo] globallyUniqueString]]];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    return @{ @"path" : fullPath,
              @"width" : [NSNumber numberWithFloat: shotImage.size.width],
              @"height" : [NSNumber numberWithFloat: shotImage.size.height] };
    
}

+ (int)getVideoTimeByPath:(NSString*)path {
    NSURL* videoUrl = [NSURL URLWithString:path];
    if ([path hasPrefix:@"assets-library"]) {
        videoUrl = [NSURL URLWithString:path];
    } else {
        videoUrl = [NSURL fileURLWithPath:path];
    }
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoUrl];
    CMTime time = [avUrl duration];
    int seconds = ceil(time.value/time.timescale);
    
    return seconds;
}

@end
