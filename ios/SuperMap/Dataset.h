//
//  Dataset.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

#import "DatasetType.h"
#import "EncodeType.h"
#import "Datasource.h"

@class Datasource,PrjCoordSys,Rectangle2D;


/**  所有数据集类型（如矢量数据集，栅格数据集等）的基类。提供各数据集共有的方法和事件。
 *  
 *  数据集一般为存储在一起的相关数据的集合；根据数据类型的不同，分为矢量数据集和栅格数据集和影像数据集，以及为了处理特定问题而设计的如拓扑数据集，网络数据集等。数据集是 GIS 数据组织的最小单位。其中矢量数据集是由同种类型空间要素组成的集合，所以也可以称为要素集。根据要素的空间特征的不同，矢量数据集又分为点数据集，线数据集，面数据集等，各矢量数据集是空间特征和性质相同而组织在一起的数据的集合。而栅格数据集由像元阵列组成，在表现要素上比矢量数据集欠缺，但是可以很好的表现空间现象的位置关系。光栅数据集包括影像数据集和栅格数据集。
 *  在 SuperMap 中有十八种类型的数据集，但目前版本支持的数据集主要有点数据集，线数据集，面数据集，文本数据集，纯属性表数据集和影像数据集。
 * 对数据集进行操作后必须调用 [Workspace dispose] 方法，否则数据修改的内容不能被保存。
 */
@interface Dataset : NSObject{
@protected
    Datasource* _datasource;

@private
    PrjCoordSys* _prjCoordSys;
}
/**
 * @brief 获取或设置数据集的投影信息。
 * <p>  当该属性设置为null时，该数据集的投影采用其所在数据源的投影。
 * @return 数据集的投影信息。
 */
@property (strong,nonatomic) PrjCoordSys* prjCoordSys;
/// 获取或设置用户加入的对数据集的描述信息。
@property (strong,nonatomic) NSString* description;      
/// 获取此数据集的名称，是数据集的唯一标识。该标识不区分大小写 。
@property (strong,nonatomic) NSString* name;    
/// 获取此数据集对象所属数据源对象。
@property (strong,nonatomic,readonly) Datasource* datasource;  

/**  获取数据集中包含所有对象的最小外接矩形。
* 对于矢量数据集来说，为数据集中所有对象的最小外接矩形；对于栅格数据集来说，为当前栅格或影像的地理范围。
  */ 
@property (strong,nonatomic,readonly) Rectangle2D* bounds;

/**  获取此数据集的类型。
* 目前版本支持的数据集类型包括纯属性表数据集、点数据集、线数据集、面数据集、文本数据集和影像数据集（DatasetImage）。
  */ 
@property (assign,nonatomic,readonly) DatasetType datasetType;

/**  获取此数据集数据存储时的编码方式。
* 对数据集采用压缩编码方式，可以减少数据存储所占用的空间，降低数据传输时的网络负载和服务器的负载。矢量数据集支持的编码方式有Byte，Int16，Int24，Int32，SGL，LZW，DCT，也可以指定为不使用编码方式。光栅数据支持的编码方式有DCT，SGL，LZW 或不使用编码方式。具体请参见EncodeType类型。
  */ 
@property (assign,nonatomic,readonly) EncodeType encodeType;


//-(BOOL) hasVersion;  安卓没有该接口 IOS暂时注释掉

/**  判断此数据集是否已经打开。
* 在数据源连接了数据，即数据源被打开之后，数据集默认是不打开数据集的，如果要对数据集的数据进行修改或其他操作，数据集必须是打开的，否则无法进行操作。可以通过该方法来判定数据集是否已被打开。
 * @return 如果此数据集已经被打开，返回 true；否则返回 false。
 */ 
-(BOOL) isOpen;
/** 返回当前数据集是否为只读。
     * 
     *  1.  当数据源以只读方式打开时，返回 true，其中的数据集不允许被修改；
     * <p>对于矢量数据集（{@link DatasetVector DatasetVector}），不允许删除、修改和添加记录； </p>
     * <p>对于影像数据集   DatasetImage ，不允许设置其像素值；</p>
     * <p>
     *  2. 如果数据源不是以只读方式打开，但数据集被设置为只读时也不能修改数据集，这时仍然返回 true。
     * @return 一个布尔值指示当前数据集是否为只读。
     */
-(BOOL) isReadOnly;

// 设置数据集是否只读
//! \param readOnly 为true，设置数据集为只读
-(void)setReadOnly:(BOOL)readOnly;

 /** 用于打开数据集，准备对数据集进行操作。
     * 
     * <p> 在数据源连接了数据，即数据源被打开之后，数据集默认是不打开的，如果要对数据集的数据进行修改或其他操作，数据集必须是打开的，否则无法进行操作。可以先使用 isOpen 方法来判断一下数据集是否已经被打开。
     * <p>因此，在对数据集进行各种操作之前，需要先打开该数据集，即调用 Dataset.open() 方法。</p>
     * @return 如果成功打开数据集，返回 true，否则返回 false。
     */
-(BOOL) open;
/** 用于关闭当前数据集。
     * 
     *<p>对于矢量数据集，调用该方法后，所有由该数据集查询出来的记录集将会被释放。如果此数据集正在显示，必须先关闭显示窗口，再调用该方法进行关闭，否则会出现错误。
     */
-(void) close;

@end
