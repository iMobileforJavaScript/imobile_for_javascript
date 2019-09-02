//
//  SMMapRender.h
//  Supermap
//
//  Created by wnmng on 2019/8/19.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol SMMapRenderDelegate <NSObject>
@required

-(void)matchImageFinished:(NSDictionary*)result;

@end

@interface SMMapRender : NSObject

+(id)sharedInstance;

//    0:NONE
//    1:ANTIALIAS
//    2:NEAREST
//    3:BILINEAR
//    4:BICUBIC
@property (nonatomic,assign) int compressMode;

@property (nonatomic,assign) int colorNumber;

@property (nonatomic,assign) id<SMMapRenderDelegate>delegate;

-(void)matchPictureStyle:(NSString*)strImagePath;

@end
