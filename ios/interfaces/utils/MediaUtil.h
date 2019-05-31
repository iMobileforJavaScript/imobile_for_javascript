//
//  MediaUtil.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/9.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface MediaUtil : NSObject
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;
+ (NSDictionary *)getScreenShotImage:(NSString *)filePath;
+ (int)getVideoTimeByPath:(NSString*)path;
@end
