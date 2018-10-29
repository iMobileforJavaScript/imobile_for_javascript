//
//  RCTConvert+Action.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTConvert+Action.h"

@implementation RCTConvert (Action)
    RCT_ENUM_CONVERTER(Action, (@{@"NONEACTION":@(NONEACTION),
                                  @"PAN":@(PAN),
                                  @"SELECT":@(SELECT),
                                  @"VERTEXEDIT":@(VERTEXEDIT),
                                  @"VERTEXADD":@(VERTEXADD),
                                  @"DELETENODE":@(DELETENODE),
                                  @"CREATEPOINT":@(CREATEPOINT),
                                  @"CREATEPOLYLINE":@(CREATEPOLYLINE),
                                  @"CREATEPOLYGON":@(CREATEPOLYGON),
                                  @"MEASURELENGTH":@(MEASURELENGTH),
                                  @"MEASUREAREA":@(MEASUREAREA),
                                  @"MEASUREANGLE":@(MEASUREANGLE),
                                  @"FREEDRAW":@(CREATE_FREE_DRAW),
                                  @"CREATEPLOT":@(CREATE_PLOT)}), PAN, intValue);
@end
