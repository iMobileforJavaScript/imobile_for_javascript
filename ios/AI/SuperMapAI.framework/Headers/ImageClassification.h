//
//  ImageClassification.h
//  SuperMapAI
//
//  Created by wnmng on 2019/10/28.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageClassification : NSObject

-(id)initWithModle:(NSString*)modelFilePath labels:(NSString*)labelsFilePath andThreadCount:(int)nThreadCount;
-(NSArray*)recognizeImage:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
