//
//  AICameraFrame.h
//  Supermap
//
//  Created by wnmng on 2020/1/19.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AIPlateCollectionCameraFrame : UIView

-(void)collectedPlate:(NSString*)plate carType:(NSString*)carType colorDescription:(NSString*)strColor;

@property (nonatomic,strong) UIButton *submitBnt;

@end


