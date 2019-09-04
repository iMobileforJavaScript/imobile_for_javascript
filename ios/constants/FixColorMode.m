//
//  FixColorMode.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/9/3.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "FixColorMode.h"
#import "SMMapFixColors.h"

@implementation FixColorMode
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{
             //Hue
             @"FCM_LH":@(FCM_LH),
             @"FCM_FH":@(FCM_FH),
             @"FCM_BH":@(FCM_BH),
             @"FCM_TH":@(FCM_TH),
             
             //Saturation
             @"FCM_LS":@(FCM_LS),
             @"FCM_FS":@(FCM_FS),
             @"FCM_BS":@(FCM_BS),
             @"FCM_TS":@(FCM_TS),
             
             //Brightness
             @"FCM_LB":@(FCM_LB),
             @"FCM_FB":@(FCM_FB),
             @"FCM_BB":@(FCM_BB),
             @"FCM_TB":@(FCM_TB),
             };
}
@end
