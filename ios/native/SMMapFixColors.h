//
//  SMMapFixColors.h
//  Supermap
//
//  Created by wnmng on 2019/8/29.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    //Hue
    FCM_LH = 0,
    FCM_FH = 1,
    FCM_BH = 2,
    FCM_TH = 3,
//    //Contrast
//    FCM_LC = 4,
//    FCM_FC = 5,
//    FCM_BC = 6,
//    FCM_TC = 7,
    //Saturation
    FCM_LS = 4,
    FCM_FS = 5,
    FCM_BS = 6,
    FCM_TS = 7,
    //Brightness
    FCM_LB = 8,
    FCM_FB = 9,
    FCM_BB = 10,
    FCM_TB = 11,
}FixColorsMode;

@interface SMMapFixColors : NSObject

+(id)sharedInstance;

-(void)updateMapFixColorsMode:(FixColorsMode)mode value:(int)value;
-(int)getMapFixColorsModeValue:(FixColorsMode)mode;

@end
