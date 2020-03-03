//
//  IllegallyParkViewManager.m
//  Supermap
//
//  Created by wnmng on 2020/1/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "IllegallyParkViewManager.h"
#import <React/RCTUIManager.h>
#import <React/RCTConvert.h>
#import <UIKit/UIKit.h>

#import "AIPlateCollectionView.h"
#import "SIllegallyParkView.h"

#import "SLanguage.h"
#import "Constants.h"



@implementation IllegallyParkViewManager

RCT_EXPORT_MODULE(RCTIllegallyParkView)



- (UIView *)view
{

    @try {
        if ([SIllegallyParkView shareInstance]==nil) {
            CGRect rt = [ UIScreen mainScreen ].bounds;
            AIPlateCollectionView *uiView = [[AIPlateCollectionView alloc]initWithFrame:rt];
            
            [uiView setDetectIntervalMillisecond:100];
            [SIllegallyParkView setInstance:uiView];
           // [uiView setDelegate:self];
        }else{
            [[SIllegallyParkView shareInstance] initData];
        }
        if([[SLanguage getLanguage] isEqualToString:@"EN"]){
            [[SIllegallyParkView shareInstance] setLanguage:@"EN"];
        }else{
            [[SIllegallyParkView shareInstance] setLanguage:@"CN"];
        }

        return [SIllegallyParkView shareInstance];
    } @catch (NSException *exception) {
        NSLog(exception.reason.description);
    }
}


@end
