//
//  CameraManager.h
//  SuperMapAI
//
//  Created by wnmng on 2019/10/28.
//  Copyright © 2019 wnmng. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AIDetectView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CameraManagerDelegate <NSObject>

-(void)didOutput:(CVPixelBufferRef)pixelBuffer;

@end

@interface CameraManager : NSObject

@property(nonatomic,assign) id<CameraManagerDelegate> delegate;
-(void)outputImage:(id) takePictureSuccess;
-(id)initWithView:(AIDetectView*)view;
//开启相机
-(void)checkCameraConfigurationAndStartSession;
//暂停相机
-(void)checkCameraConfigurationAndStopSession;
-(void)refresh;
@end

NS_ASSUME_NONNULL_END
