//
//  CollectSceneFormViewManager.m
//  Supermap
//
//  Created by wnmng on 2020/2/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "CollectSceneFormViewManager.h"
#import "ARCollectorView.h"
#import "SCollectSceneFormView.h"

@implementation CollectSceneFormViewManager


RCT_EXPORT_MODULE(RCTCollectSceneFormView)



- (UIView *)view
{

    @try {
//        if ([SCollectSceneFormView shareInstance]==nil) {
//            
//           // [uiView setDelegate:self];
//        }
        
        CGRect rt = [ UIScreen mainScreen ].bounds;
        ARCollectorView *uiView = [[ARCollectorView alloc]initWithFrame:rt];
        [SCollectSceneFormView setInstance:uiView];

        return [SCollectSceneFormView shareInstance];
    } @catch (NSException *exception) {
        NSLog(exception.reason.description);
    }
    
}

@end
