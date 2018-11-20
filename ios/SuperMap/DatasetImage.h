//
//  DatasetImage.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "Dataset.h"
#import "ColorSpaceType.h"
#import "PixelFormat.h"

@class GeoRegion,Color,Point2D,MapCacheService;
/** 影像数据集类。
 <p>影像数据集类，该类用于描述影像数据，不具备属性信息，例如影像地图、多波段影像和实物地图等。
 <p>光栅数据采用网格形式组织并使用二维栅格的像素值来记录数据，每个栅格（cell）代表一个像素要素，栅格值可以描述各种数据信息。影像数据集中每一个栅格存储的是一个颜色值或颜色的索引值（RGB 值）。 </p>
 <p> 注意： 在对数据集进行操作前需要先打开数据集，即调用  [Dataset open] 方法。
 */
@interface DatasetImage : Dataset{
@private
    GeoRegion* _clipRegion;
}
 /**@brief 返回影像数据集的影像数据的宽度。单位为像素。
   @return  影像数据集的影像数据的宽度。
     */
-(NSInteger) width;

/**@brief  返回影像数据集的影像数据的高度。单位为像素。
 @return  影像数据集的影像数据的高度。
     */
-(NSInteger) height;

 /**@brief 返回影像数据存储的像素格式。每个象素采用不同的字节进行表示，单位是比特（bit）。详细信息请参考 PixelFormat 枚举类。
 <p>  注意： 影像数据集类不支持 DOUBLE 、SINGLE、BIT64}类型的像素格式。
 @return  影像数据存储的像素格式。
 <p> 请参见  <PixelFormat>
     */
-(OCPixelFormat)  pixelFormat;

/**@brief 返回影像数据集指定行和列处的像素值。该方法的参数值的行、列数从零开始计数。
 @param  column 指定的影像数据集的影像点的列数。
 @param  row 指定的影像数据集的影像点的行数。
 @return  影像数据集的像素值。
     */
-(Color*) pixel:(NSInteger) column row:(NSInteger) row;

// this point is oc type
  /**@brief 将影像数据集的每一个像素点对应到地理坐标系下的坐标点，即 x, y 坐标。
 @param  point 指定的行数和列数所对应的影像点。
 @return  地理坐标系下的对应的点坐标。
    */
-(Point2D*) imageToXY:(CGPoint) point;

/**@brief 将影像数据集的在地理坐标系下的点（X, Y 坐标）对应到像素中。
 @param  point2D 指定的地理坐标系下的点。
 @return  影像数据集对应的影像点。
    */
-(CGPoint) xyToImage:(Point2D*) point2D;

/**@brief 根据指定的像素所在的行数、列数以及索引号，返回像素的颜色。
 @param  column 指定的像素所在的列数。
 @param  row 指定的像素所在的行数。
 @param  indexes 指定的像素的序列号。
 @param  indexesLength 指定的像素的序列号的个数。
 @return  指定像素的颜色。
     */
-(Color*) pixel:(NSInteger) column row:(NSInteger) row indexes:(NSInteger*) indexes length:(NSInteger) indexesLength;

/**@brief  返回色彩显示模式。
 @return  色彩显示模式。
     */
-(ColorSpaceType) colorSpaceType;
-(int)getBandCount;
 /**@brief 判断影像数据集是否已创建影像金字塔。true 表示已经创建，false 表示未创建。
 @return  影像数据集是否已创建影像金字塔。
     */
-(BOOL) hashPyramid;

// 创建金字塔
-(BOOL)buildPyramid;
//删除已创建的金字塔
-(BOOL)removePyramid;
// 更新金字塔
-(BOOL)updatePyramid:(Rectangle2D*)value;
/**
 @return  获取地图缓存对象
 */
-(MapCacheService*)getMapCacheService;

// 删除本地缓存
-(void)removeCache:(double)scale rect:(Rectangle2D*)bounds;
@end
