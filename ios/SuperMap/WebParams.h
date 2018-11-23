//
//  WebParams.h
//  HotMap
//
//  Created by imobile-xzy on 16/12/14.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

//网络服务参数类
typedef enum {
    //Rest网络服务参数类
    REST = 2
}WebParamsType;
@interface WebParams : NSObject
-(WebParamsType)getType;
@end
