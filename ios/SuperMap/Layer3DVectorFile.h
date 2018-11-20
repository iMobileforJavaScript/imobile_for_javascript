//
//  Layer3DVectorFile.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Layer3D.h"
#import "Layer3DVectorFileDataType.h"

DEPRECATED_ATTRIBUTE
/// 矢量文件图层类。
@interface Layer3DVectorFile : Layer3D {
    
}

/**@brief 返回图层的数据类型。
 @return  图层的数据类型。
 */
@property(nonatomic,readonly)Layer3DVectorFileDataType dataType;

@end
