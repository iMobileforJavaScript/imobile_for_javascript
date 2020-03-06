//
//  SMItTabletUtils.m
//  Supermap
//
//  Created by imobile-xzy on 2020/3/4.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMITabletUtils.h"
#import "SuperMap/ITabletLicenseManager.h"
#import "SuperMap/Environment.h"
#import "SuperMap/LicenseStatus.h"
#import "SuperMap/SceneControl.h"

static BOOL bAddL = false;
static NSArray *SuperMapAppID = nil;

static UILabel* licView = nil;

@interface SMObj : NSObject

@end
@implementation SMObj

-(void)orientChange:(NSNotification *)notification{
    licView.frame  = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);//[[UILabel alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
}

@end

static SMObj* handle = nil;
@implementation SMITabletUtils


+(void)addLicView:(UIView*)hostView text:(NSString*)error{
    
    if(error == nil){
        [licView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:handle];
        bAddL = NO;
        return;
    }
    if(!bAddL){
        handle = [[SMObj alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:handle  selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        bAddL = YES;
    }
    
    [licView removeFromSuperview];
    
    licView = [[UILabel alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.alignment = NSTextAlignmentLeft;
//    paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
           
     NSDictionary*      attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:15], NSParagraphStyleAttributeName: paragraph,NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeWidthAttributeName:@(-4),NSStrokeColorAttributeName:[UIColor blackColor]};
    
    licView.attributedText = [[NSAttributedString alloc]initWithString:error attributes:attribute];

    
    licView.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
//    licView.text = error;
    licView.textAlignment = NSTextAlignmentCenter;
    licView.numberOfLines = 0;
    
    
//    if(![hostView isKindOfClass:[SceneControl class]])
//    {
//        [licView setTranslatesAutoresizingMaskIntoConstraints:NO];//将使用AutoLayout的方式布局
//        //btnTest顶部相对于self.view的顶部距离为100
//        NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:licView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:hostView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//        //btnTest左侧相对于self.view的左侧距离为100
//        NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:licView  attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:hostView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//        //btnTest右侧相对于self.view的右侧距离为100
//        NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem:hostView  attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:licView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//        //btnTest底部相对于self.view的底部距离为100
//        NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:hostView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:licView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    //    将约束添加到父视图中
//        [hostView addConstraint:constraintTop];
//        [hostView addConstraint:constraintLeft];
//        [hostView addConstraint:constraintRight];
//        [hostView addConstraint:constraintBottom];
//
//    }

    [hostView addSubview:licView];
}
+(NSString*)checkLicValid{
    NSString* error = nil;
     LicenseInfo* info = [[ITabletLicenseManager getInstance] licenseStatus];
        if(info!=nil){
           BOOL bADVANCEDValied = false;
       
           for(LicenseFeature* fe in info.features){
               if([fe.id isEqualToString:/*ITABLET_ADVANCED*/@"18003"]){
                   bADVANCEDValied = YES;
                   break;
               }
           }
           if(!bADVANCEDValied){
               NSString* appId = [[NSBundle mainBundle] bundleIdentifier];
               if(![SMITabletUtils isSuperMapAppID:appId]){
    //                    NSLog(@"\n****\nLicense error:  License not contain ITABLET_ADVANCED\n****\n");
                   error = @"License Invalid\nNot Contain ITABLET_ADVANCED\nPlease Check Your License";
//                    @throw [[NSException alloc] initWithName:@"License" reason:@"License not contain ITABLET_ADVANCED" userInfo:nil];
                   
               }
           }
           
          
        }else{//isTrailLicense
           LicenseStatus* status = [Environment getLicenseStatus];
            if( !status.isTrailLicense || !status.isLicenseValid){
    //                NSLog(@"\n****\nLicense error:  TrailLicense  invalid\n****\n");
                error = @"TrailLicense Invalid\nPlease Check Your License";
//                @throw [[NSException alloc] initWithName:@"License" reason:@"TrailLicense not Valid" userInfo:nil];
            }
        }
    
    return error;
}
+(BOOL)isSuperMapAppID:(NSString*)appId{
    if(SuperMapAppID == nil){
        SuperMapAppID = @[@"com.supermap.itablet"];
    }
  return [SuperMapAppID containsObject:appId];
}
@end
