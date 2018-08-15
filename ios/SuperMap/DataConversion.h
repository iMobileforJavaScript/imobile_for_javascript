//
//  DataConversion.h
//  LibUGC
//
//  Created by R3 on 14-8-12.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Datasource.h"
#import "Charset.h"
/**
 * 文件转换类。
 *
 *<p> 该类为文件导入导出提供方法。
 * <p> 这些方法针对具体的数据文件类型（目前支持shape和mif型文件），用于将该类文件倒入数据源和将数据源中一数据集导出成该类型文件。
 * 文件转换类方法均为静态方法，调用时无需创建该类实例
 */



@interface DataConversion : NSObject

/**
 * @brief 设置文件字符集。
 @param  value 导出生成文件或倒入源文件的字符集。默认为GB18030。
               导出时该字段（即设置的导出生成文件的字符集）与被导出数据的字符集不匹配，在导出生成文件中将会出现文字乱码情况。
               导入时该字段（即设置的读取导人文件的字符集）与导入文件本身的字符集不匹配，在倒入后的数据集中会出现文字乱码情况
  */
+(void)setConvertCharset:(Charset)value;

/**
 * @brief shape文件倒入方法。将指定路径对应的shape文件倒入成指定数据源中的同名数据集。
    @param  filePath 指定倒入的shape文件路径。
    @param  datasource 将文件倒入到的数据源。
 */
+(BOOL)importSHPFile:(NSString *)filePath toDatasource:(Datasource *)datasource;

/**
 * @brief shape文件倒出方法。将指定数据集导出到沙盒目录下生成／覆盖名为指定名称的文件。
 @param  fileName 指定倒出文件名，若无.shp后缀，方法将自动添加。
 @param  dataset 指定导出的数据集。
 */
+(BOOL)exportSHPNamed:(NSString *)fileName fromDataset:(Dataset *)dataset;

/**
 * @brief mif文件倒入方法。将指定路径对应的mif文件倒入成指定数据源中的同名数据集。
 @param  filePath 指定倒入的mif文件路径。
 @param  datasource 将文件倒入到的数据源。
 */
+(BOOL)importMIFFile:(NSString *)filePath toDatasource:(Datasource *)datasource;

/**
 * @brief mif文件倒出方法。将指定数据集导出到沙盒目录下生成／覆盖名为指定名称的文件。
 @param  fileName 指定倒出文件名，若无.mif后缀，方法将自动添加。
 @param  dataset 指定导出的数据集。
 */
+(BOOL)exportMIFNamed:(NSString *)fileName fromDataset:(Dataset *)dataset;

// bImportingAsGrid 是否导入为栅格数据集
// wordFile 坐标参考文件
+(BOOL)importTIFFile:(NSString*)filePath toDatasource:(Datasource *)datasource ;//isImportingAsGrid:(BOOL)bImportingAsGrid /*NSString* wordFile*/;

+(BOOL)exportTIFNamed:(NSString*)fileName fromDataset:(Dataset *)dataset;

// 导入dwg文件
//! \param filepath 导入文件路径
//! \param datasource 目标数据源
//! \param  inverseBlackWhite 是否导入为黑白反色模式
//! \param  importAsCAD 是否导入为cad数据集，默认为cad数据集，false为简单数据集
+(BOOL)importDWG:(NSString*)filepath toDatasource:(Datasource*) datasource bIsBlack:(BOOL)inverseBlackWhite isCad:(BOOL)importAsCAD;
+(BOOL)exportDWG:(NSString*)filepath fromDataset:(Dataset*)dataset;

// 导入dxf文件
//! \param filepath 导入文件路径
//! \param datasource 目标数据源
//! \param  inverseBlackWhite 是否导入为黑白反色模式
//! \param  importAsCAD 是否导入为cad数据集，默认为cad数据集，false为简单数据集
+(BOOL)importDXF:(NSString*)filepath toDatasource:(Datasource*)datasource bIsBlack:(BOOL)inverseBlackWhite isCad:(BOOL)importAsCAD;
+(BOOL)exportDXF:(NSString*)filepath fromDataset:(Dataset*)dataset;

// 导入kml文件
// param filepath 导入文件路径名
// param datasource 目标数据源
// param targetDatasetName 目标数据集名称
// param importAsCAD 是否导入为复合数据集， 默认导入为复合数据集
+(BOOL)importKML:(NSString*)filepath  toDatasource:(Datasource*)datasource targetDatasetName:(NSString*)targetDatasetName isCad:(BOOL)importAsCAD;
// 导出kml文件
// KML只支持矢量数据集进行导出
// 数据集投影必须为地理坐标系WGS-1984
// param filepath 导出文件路径名
// param dataset 目标数据集
+(BOOL)exportKML:(NSString*)filepath fromDataset:(Dataset*)dataset;

// 导入kmz文件
// param filepath 导入文件路径名
// param datasource 目标数据源
// param targetDatasetName 目标数据集名称
// param importAsCAD 是否导入为复合数据集， 默认导入为复合数据集
+(BOOL)importKMZ:(NSString*)filepath  toDatasource:(Datasource*)datasource targetDatasetName:(NSString*)targetDatasetName isCad:(BOOL)importAsCAD;

// 导出kmz文件
// KMZ只支持矢量数据集进行导出
// 数据集投影必须为地理坐标系WGS-1984
// param filepath 导出文件路径名
// param dataset 目标数据集
+(BOOL)exportKMZ:(NSString*)filepath fromDataset:(Dataset*)dataset;

// 导入GPX文件
// param filepath 导入文件路径名
// param datasource 目标数据源
// param targetDatasetName 目标数据集名称
+(BOOL)importGPX:(NSString*)filepath toDatasource:(Datasource*)datasource  targetDatasetName:(NSString*)targetDatasetName;

// 导出GPX文件
// GPX只支持矢量数据集进行导出
// 数据集投影必须为地理坐标系WGS-1984
// param filepath 导出文件路径名
// param dataset 目标数据集
+(BOOL)exportGPX:(NSString*)filepath fromDataset:(Dataset*)dataset;


/**
 * @brief img文件导入方法。将指定路径对应的img文件倒入成指定数据源中的同名数据集。
 @param  filePath 指定倒入的shape文件路径。
 @param  datasource 将文件倒入到的数据源。
 */
+(BOOL)importIMG:(NSString*)filePath toDatasource:(Datasource*)datasource ;
/**
 * @brief img文件导出方法。将指定数据集导出到沙盒目录下生成／覆盖名为指定名称的文件。
 @param  fileName 指定倒出文件名，若无.mif后缀，方法将自动添加。
 @param  dataset 指定导出的数据集。
 */
+(BOOL)exportIMG:(NSString*)fileName fromDataset:(Dataset*)dataset;
@end
