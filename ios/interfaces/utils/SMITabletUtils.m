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

static NSArray *SuperMapAppID = nil;
@implementation SMITabletUtils

static UILabel* licView = nil;

+(void)addLicView:(UIView*)hostView text:(NSString*)error{
    licView = [[UILabel alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    licView.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
    licView.text = error;
    licView.numberOfLines = 0;
    [licView removeFromSuperview];
    [hostView addSubview:licView];
}
+(NSString*)checkLicValid{
    NSString* error = nil;
     LicenseInfo* info = [[ITabletLicenseManager getInstance] licenseStatus];
        if(info!=nil){
           BOOL bADVANCEDValied = false;
       
           for(LicenseFeature* fe in info.features){
               if([fe.id isEqualToString:ITABLET_ADVANCED]){
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
        SuperMapAppID = @[@"com.supermap.iTablet"];
    }
  return [SuperMapAppID containsObject:appId];
}
@end
