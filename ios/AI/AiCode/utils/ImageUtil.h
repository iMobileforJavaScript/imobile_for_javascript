//
//  ImageUtil.h
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/13.
//  Copyright © 2019年 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject
+ (CVPixelBufferRef)CVPixelBufferRefFromUiImage:(UIImage *)img;
+ (UIImage *)imageFromPixelBuffer:(CVPixelBufferRef)pixelBufferRef;
@end
