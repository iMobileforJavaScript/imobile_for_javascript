//
//  Selection.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class GeoStyle,Datasource,DatasetVector,Layer,Recordset;

/** 选择集类。
 *   
 * <p>
 * 该类用于处理地图上被选中的对象。与该类紧密相连的类是 {@link Recordset Recordset}
 * 记录集类。通常可以通过选择集类返回地图的选择信息或设置地图上的选中情况。通过与 Recordset 的交互，就可以处理与选中对象相对应的数据。
 * </p> 
 */
@interface Selection : NSObject{
    @private
    Layer *_layer;
    GeoStyle * _geoStyle;
    Datasource *_dataSource;
    DatasetVector *_datasetVector;
    BOOL _isUserLayer;
}

/**
	 * @brief  获取或设置选择集几何对象的显示风格。
	 * 
	 * <p> 默认值为 {FillBackColor=Color [A=255, R=255, G=255,
	 *          B=255],FillForeColor=Color [A=255, R=189, G=235,
	 *          B=255],FillGradientAngle
	 *          =0,FillGradientMode=None,FillGradientOffsetRatioX
	 *          =0,FillGradientOffsetRatioY
	 *          =0,FillOpaqueRate=100,FillSymbolID=1,LineColor=Color [A=255,
	 *          R=0, G=0,
	 *          B=255],LineSymbolID=0,LineWidth=0.1,MarkerAngle=0,MarkerSize
	 *          ={Width=2.4,Height=2.4},MarkerSymbolID=0}
	 *  @return 选择集几何对象的显示风格。
	*/
@property(nonatomic)GeoStyle *style;

/**
	 * @brief 根据指定的参数构造 {@link Selection Selection} 类的新实例。
	 * @param datasetVector 指定的数据集。
	 */
-(id)initWithDatasetVector:(DatasetVector*)datasetVector;

/**
	 * @brief 拷贝构造函数，根据给定的 {@link Selection Selection} 对象构造一个与其完全相同的新对象。
	 * @param selection 指定的 {@link Selection Selection} 对象。
	 */
-(id)initWithSelection:(Selection *)selection;


/**
 * @brief 返回选择集中几何对象的个数。
* <p> 默认值为 0。即选择集中没有几何对象。
* @return 选择集中几何对象的个数。
*/
-(int)getCount;

/**
* @brief 返回选择集中几何对象所在的数据集。
 *  <p> 默认值为 null。
 * @return 选择集中几何对象所在的数据集。
 */
-(DatasetVector *)getDataset;

/**
* @brief  设置选择集中几何对象所在的数据集。
 * @param dataset 选择集中几何对象所在的数据集。
 * 
 */
-(void)setDataset:(DatasetVector *)dataset;

/**
* @brief 用于把一个记录集转化为选择集（即记录集所对应的对象全部呈选中状态）。
* @param recordset 要转化为选择集的记录集。
* @return 一个布尔值，转换成功返回 true，否则返回 false
 */
-(BOOL)fromRecordset:(Recordset *)recordset;

/**
 * @brief 用于把选择对象转化为记录集。只有将选择集转化为记录集后才能对其数据进行操作。
* @return 转化得到的记录集，该记录集包括所有的字段。
 */
-(Recordset *)toRecordset;

/**
 * @brief 根据属性数据中SmID 字段的值返回选择集中指定几何对象的系统 ID。
* @param index 属性数据中SmID 字段的值
 * @return 选择集中指定几何对象的系统 ID
 */
-(int)get:(int)index;


/**
	 * @brief 用于向选择集中加入几何对象。
	 * @param geometryID 新添加的几何对象的 ID 值（即其属性数据中 SmID 字段的值）。
	 * @return 新添几何对象在选择集中的序号。
	 */
-(int)add:(int)geometryID;


/**
	 * @brief 用于从选择集中删除一个几何对象，该几何对象由原来的呈选中状态变为非选中状态。
	 * @param geometryID 要删除几何对象的 ID 号（即其属性数据中 SmID 字段的值）
	 * @return 删除成功返回 true；否则返回 false。
	 */
-(BOOL)remove:(int)geometryID;

/**
	 * @brief 用于从选择集中删除指定的若干几何对象，这些几何对象由原来的选中状态变为非选中状态。
	 * 
	 * @param index 要删除的第一个几何对象的序列号。
	 * @param count 要删除的几何对象的个数。
	 * @return 成功删除的几何对象的个数。
	 */
-(int)removeRangeAt:(int)index WithCount:(int)count;

/**
	 *  @brief 将选择集清空，这样被选中的对象将全部恢复到未选中状态。
	 */
-(void)clear;

/**
	 *@brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
	 */
-(void)dispose;

 /**
	 * @brief  返回是否使用默认选择风格。如果设置为 true，则设置的选择风格将无效。
	 * @return 一个布尔值，使用默认选择风格返回 true，否则返回 false。
	 */
-(BOOL)isDefaultStyleEnabled;
@end
