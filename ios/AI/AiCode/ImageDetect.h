//
//  ImageDetect.h
//  SuperMapAI
//
//  Created by wnmng on 2019/10/28.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDetect : NSObject

-(id)initWithModle:(NSString*)modelFilePath labels:(NSString*)labelsFilePath andThreadCount:(int)nThreadCount;

-(NSArray*)runModel:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
