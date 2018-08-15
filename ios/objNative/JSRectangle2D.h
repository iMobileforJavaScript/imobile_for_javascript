//
//  JSRectangle2D.h
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>
#import "SuperMap/Rectangle2D.h"
@interface JSRectangle2D : NSObject<RCTBridgeModule>
+(NSDictionary*)reactangle2DToDic:(Rectangle2D*)reactangle;
+(Rectangle2D*)dicToReactangle2D:(NSDictionary*)dic;
@end
