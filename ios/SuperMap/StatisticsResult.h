//
//  StatisticsResult.h
//  HotMap
//
//  Created by supermap on 2017/11/29.
//  Copyright © 2017年 supermap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsResult : NSObject
-(double) getAverage;
-(double) getMaxValue;
-(NSMutableArray *) getMajority;
-(double)getMedianValue;
-(NSMutableArray *)getMinority;
-(double) getminValue;
-(double) getStdDeviation;
-(double) getVariance;
-(BOOL) isDirty;
@end
