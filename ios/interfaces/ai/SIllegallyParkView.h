//
//  SIllegallyParkView.h
//  Supermap
//
//  Created by wnmng on 2020/1/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTComponent.h>
#import <Foundation/Foundation.h>
#import "AIPlateCollectionView.h"

@interface SIllegallyParkView : RCTEventEmitter<RCTBridgeModule,AIPlateCollectionDelegate>

+(AIPlateCollectionView*)shareInstance;
+(void)setInstance:(AIPlateCollectionView*)aICollectView;
-(void)submit:(UIImage*)image;

@end


