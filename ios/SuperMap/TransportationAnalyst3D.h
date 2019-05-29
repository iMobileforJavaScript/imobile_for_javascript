//
//  TransportationAnalyst3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TransportationAnalystSetting3D,TransportationAnalystResult3D;
@class TransportationAnalystParameter3D,TransportationAnalystCheckResult3D;
@interface TransportationAnalyst3D : NSObject

/**
 * 返回分析环境设置对象
 *
 * @return TransportationAnalystSetting
 */
@property(nonatomic,strong)TransportationAnalystSetting3D* analystSetting;

-(TransportationAnalystResult3D*)findPath:(TransportationAnalystParameter3D*)parameter;
-(TransportationAnalystCheckResult3D*)check;
-(void)dispose;
-(BOOL)load;
@end
