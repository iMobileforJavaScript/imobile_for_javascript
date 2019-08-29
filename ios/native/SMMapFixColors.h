//
//  SMMapFixColors.h
//  Supermap
//
//  Created by wnmng on 2019/8/29.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    //Brightness
    FCM_LB = 0,
    FCM_FB = 1,
    FCM_BB = 2,
    FCM_TB = 3,
    //Contrast
    FCM_LC = 4,
    FCM_FC = 5,
    FCM_BC = 6,
    FCM_TC = 7,
    //Saturation
    FCM_LS = 8,
    FCM_FS = 9,
    FCM_BS = 10,
    FCM_TS = 11,
}FixColorsMode;

@interface SMMapFixColors : NSObject

+(id)sharedInstance;

-(void)updatMapFixColorsMode:(FixColorsMode)mode value:(int)value;
-(int)getMapFixColorsModeValue:(FixColorsMode)mode;

@end
