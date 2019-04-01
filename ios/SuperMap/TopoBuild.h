//
//  TopoBuild.h
//  MapEditDemo
//
//  Created by imobile-xzy on 16/8/8.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dataset;
@interface TopoBuild : NSObject

/**
 * @author huangkj
 * @mark 线数据集拓扑生成面数据集
 * @param Dataset  原始线数据集
 * @param Dataset  拓扑生成的面数据集
 * @return boolean 生成是否成功
 */
+(BOOL)topoBuildRegion:(Dataset*)datasetLine dataset:(Dataset*)datasetRegion;


@end
