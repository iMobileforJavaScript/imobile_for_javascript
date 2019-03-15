//
//  PathGuide.h
//  prjTest
//
//  Created by imobile on 14-2-24.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 行驶导引类。
 */
@class PathGuideItem;
@interface PathGuide : NSObject{

    NSMutableArray *_items;
    int m_count;
}

/**
 * @brief 根据序号返回行驶导引中的导引子项对象。
 * @param index 指定的序号。
 * @return 行驶导引中的导引子项对象。
 */
-(PathGuideItem *)get:(NSInteger)index;

/**
 * @brief 返回行使导引对象中子项的个数。
 * @return 行使导引对象中子项的个数。
 */
-(NSInteger)getCount;

-(void)dispose;

@end
