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
#import "SMITabletUtils.h"


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
        
        UIView* hostView = [SCollectSceneFormView shareInstance];
        NSString* error =  [SMITabletUtils checkLicValid];
        if(error != nil){
            [SMITabletUtils addLicView:hostView text:error];
        }
        
        return hostView;
    } @catch (NSException *exception) {
        NSLog(exception.reason.description);
    }
    
}

@end
