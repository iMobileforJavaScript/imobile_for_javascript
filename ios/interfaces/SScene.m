//
//  SScene.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/9.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SScene.h"
#import "Constants.h"

@implementation SScene
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[
             ANALYST_MEASURELINE,
             ANALYST_MEASURESQUARE,
             POINTSEARCH_KEYWORDS,
             SSCENE_FLY,
             SSCENE_ATTRIBUTE,
             ];
}
@end
