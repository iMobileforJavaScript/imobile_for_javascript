//
//  MultiBoxTracker.h
//  SuperMapAI
//
//  Created by wnmng on 2019/12/4.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MultiBoxTracker : NSObject

-(NSArray*)track:(NSArray*)result with:(CVPixelBufferRef)pixelBuffer;


@end

NS_ASSUME_NONNULL_END
