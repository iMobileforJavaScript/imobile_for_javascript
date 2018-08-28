//
//  LocationAnalystParameter.h
//  SourcesCode_Objects
//
//  Created by supermap on 2018/8/13.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SupplyCenters;
@interface LocationAnalystParameter : NSObject
-(id)initWithLocationAnalystParameter:(LocationAnalystParameter*) paramter;
-(void)dispose;


@property(nonatomic)int expectedSupplyCenterCount;
@property(nonatomic,strong)NSString* nodeDemandField;
@property(nonatomic,strong)SupplyCenters* supplyCenters;
@property(nonatomic,strong)NSString* turnWeightField;
@property(nonatomic,strong)NSString* weightName;
@property(nonatomic)BOOL isFromCenter;
@end
