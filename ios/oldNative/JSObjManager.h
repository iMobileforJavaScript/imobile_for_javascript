//
//  JSObjManager.h
//  iMobileRnIos
//
//  Created by imobile-xzy on 16/5/12.
//  Copyright © 2016年 supermap. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSObjManager : NSObject

+(id)getObjWithKey:(id)key;
+(NSString*)addObj:(id)obj;
+(NSString*)addObjWithKey:(id)obj key:(NSString*)key;
+(void)removeObj:(id)key;
@end
