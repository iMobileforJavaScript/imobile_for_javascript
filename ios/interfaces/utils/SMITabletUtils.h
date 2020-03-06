//
//  SMItTabletUtils.h
//  Supermap
//
//  Created by imobile-xzy on 2020/3/4.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMITabletUtils : NSObject
+(BOOL)isSuperMapAppID:(NSString*)appId;
+(NSString*)checkLicValid;
+(void)addLicView:(UIView*)hostView text:(NSString*)error;
@end

NS_ASSUME_NONNULL_END
