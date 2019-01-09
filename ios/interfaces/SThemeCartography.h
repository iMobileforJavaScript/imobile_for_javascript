//
//  SThemeCartography.h
//  Supermap
//
//  Created by xianglong li on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface SThemeCartography : NSObject<RCTBridgeModule>
@property (nonatomic, strong)NSString* lastColorUnique;
@property (nonatomic, strong)NSString* lastColorRange;
@property (nonatomic, strong)NSMutableArray* lastColorUniqueArray;
@property (nonatomic, strong)NSMutableArray* lastColorRangeArray;
@end
