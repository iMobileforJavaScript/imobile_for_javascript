//
//  DatasetGrid.h
//  icuTest
//
//  Created by imobile on 13-11-11.
//  Copyright (c) 2013年 iMobile. All rights reserved.
//

#import "Dataset.h"
#import "PixelFormat.h"
#import "GeoRegion.h"
#import "Colors.h"
#import "DatasetVector.h"
#import <CoreGraphics/CoreGraphics.h>
@class StatisticsResult;
/** 栅格数据集类。
 <p> 栅格数据集类，该类用于描述栅格数据，例如高程数据集和土地利用图。栅格数据采用网格形式组织并使用二维的栅格的像素值来记录数据，每个栅格（cell）代表一个像素要素，栅格值可以描述各种数据信息。
 <p> 栅格数据集中每 一个栅格（cell）存储的是表示地物的属性值，属性值可以是土壤类型、密度值、高程、温度、湿度等。
 <p> 注意： 在对数据集进行操作前需要先打开数据集，即调用  [Dataset open]方法。
 */
@interface DatasetGrid : Dataset{

    GeoRegion *_clipRegion;

}
/**@brief 获取或设置栅格数据集的空值，当此数据集为空值时，用户可采用-9999来表示。
 @return  栅格数据集的空值。
*/
@property(nonatomic,assign)double noValue;
/**@brief 获取栅格数据集中栅格值的最小值。
 @return  栅格数据集中栅格值的最小值。
*/
@property(nonatomic,assign,readonly)double minValue;
/**@brief 获取栅格数据集中栅格值的最大值。
 @return  栅格数据集中栅格值的最大值。
*/
@property(nonatomic,assign,readonly)double maxValue;
/**@brief 获取栅格数据集是否已创建金字塔。true，表示已创建金字塔，false，表示未创建金字塔。
 @return  栅格数据集是否已创建金字塔。
*/
@property(nonatomic,assign,readonly)BOOL hasPyramid;
/**@brief 计算栅格数据集的极值，即最大值和最小值。建议：栅格数据集在一些分析或者操作之后，建议调用此接口，计算一下最大最小值。
 @return  如果计算成功返回 true，否则返回 false。
*/
@property(nonatomic,assign,readonly)BOOL calculateExtremum;
/**@brief 获取或设置栅格数据集的显示区域，若用户设置了栅格数据集的显示区域，栅格数据集就按照给定的区域进行显示，区域之外的都不显示。
<p>注意：</p>
* 1. 当用户所设定的栅格数据集的地理范围与所设定的裁剪区域无重叠区域，栅格数据集不显示。
* 2. 当重新设置栅格数据集的地理范围，不自动修改栅格数据集的裁剪区域。
 @return  如果计算成功返回 true，否则返回 false。
*/
@property(nonatomic,strong)GeoRegion *clipRegion;
/**@brief 获取或设置颜色表，关闭数据集时不保存对颜色表进行的设置。
 @return  颜色表。
*/
@property(nonatomic,strong)Colors *colorTable;


/**@brief 获取栅格数据集的栅格的宽度。单位为像素。
 @return  栅格数据集的栅格的宽度。
*/
-(NSInteger)width;

/**@brief 获取栅格数据集的栅格的高度。单位为像素。
 @return  栅格数据集的栅格的高度。
*/
-(NSInteger)height;

/**@brief 将栅格数据集对应到地理坐标系中指定的地理范围。
 @param  value  指定的地理范围。
*/
-(void)setGeoReference:(Rectangle2D *)value;

/**@brief 获取栅格数据存储的像素格式。每个像素采用不同的字节进行表示，单位为比特（bit）。
 @return  栅格数据存储的像素格式。
*/
-(OCPixelFormat)pixelFormat;

/**@brief 获取栅格数据集分块存储的大小。
 @return  栅格数据集分块存储的大小。
*/
-(NSInteger)blockSize;

/**@brief 获取栅格数据经过分块后所得到的总行数。
 @return  栅格数据经过分块后所得到的总行数。
*/
-(NSInteger)rowBlockCount;

/**@brief 获取栅格数据经过分块后所得到的总列数。
 @return  栅格数据经过分块后所得到的总列数。
*/
-(NSInteger)columnBlockCount;

/**@brief 根据给定的行数和列数返回栅格数据集的栅格所对应的栅格值
 @param  column  指定的栅格数据集中的列数。
 @param  row  指定的栅格数据集中的行数。
 @return  栅格数据经过分块后所得到的总列数。
*/
-(double)value:(NSInteger)column row:(NSInteger)row;

//根据给定的行数和列数设置栅格数据集的栅格所对应的栅格值
//-(double)setValue:(NSInteger)column row:(NSInteger)row value:(double)value;

/**@brief 根据指定的行数和列数所对应的栅格点转换为地理坐标系下的点，即 X, Y 坐标。
 @param  point  指定的行数和列数多对应的栅格。
 @return  地理坐标系下的对应的点坐标。
*/
-(Point2D *)gridToXY:(CGPoint)point;

/**@brief 将地理坐标系下的点（X Y）转换为栅格数据集中对应的栅格。
 @param  point2D  指定的地理坐标系下的点。
 @return  栅格数据集对应的栅格。
*/
-(CGPoint)xyToGrid:(Point2D *)point2D;

/**@brief 按指定范围更新栅格数据集影像金字塔。
 @param  value  更新金字塔的指定影像范围。
 @return  如果更新成功，返回 true，否则返回 false。
*/
-(BOOL)updatePyramid:(Rectangle2D *)value;

// 创建影像金字塔,必须先关闭数据集
-(BOOL)buildPyramid;
//删除已创建的金字塔
-(BOOL)removePyramid;

//创建栅格值属性表，其类型为属性表数据集类型
//-(DatasetVector *)buildValueTable:(Datasource *)mDatasource tableName:(NSString *)tableName;

/**@brief 根据指定的栅格数据集更新。
<p>指定的栅格数据集和被更新的栅格数据集的编码方式（EncodeType）和像素类型（PixelFormat）必须保持一致。</p>
 @param  dataset  指定的栅格数据集。
 @return  一个布尔值，表示更新是否成功，如果更新成功，返回 true，否则返回 false。
  */
-(BOOL)update:(DatasetGrid *)dataset;
/**
 * 返回栅格数据集像素的统计结果，包括最大值、最小值、均值、中值、众数、稀数、方差、标准差。
 *
 * @return 返回统计结果。
 */
-(StatisticsResult *) buildStatistics;
/**
 * 返回栅格数据集像素的统计结果，包括最大值、最小值、均值、中值、众数、稀数、方差、标准差。
 *
 * @return 返回统计结果。
 */
-(StatisticsResult *) gridStatisticsResult;
@end
