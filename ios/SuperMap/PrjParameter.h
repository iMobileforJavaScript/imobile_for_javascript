//
//  PrjParameter.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/**
 * 地图投影参数类。 
 *
 * <p>地图投影的参数，比如中央经线、原点纬度、双标准纬线的第一和第二条纬线等。 </p>
 *
 */
@interface PrjParameter : NSObject{
    
}

/**
     * @brief 获取或设置坐标水平偏移量。
     * <p>此方法的返回值是为了避免系统坐标出现负值而加上的一个偏移量。通常用于高斯--克吕格、UTM 和墨卡托投影中。一般的值为500000米。</p>
     * <p> 默认值为0。
     * @return 坐标水平偏移量。
     */
@property(nonatomic) double falseEasting;

/**
     * @brief 获取或设置坐标水平偏移量。
     * <p>此方法的参数值是为了避免系统坐标出现负值而加上的一个偏移量。通常用于高斯--克吕格、UTM 和墨卡托投影中。一般的值为500000米。</p>
     */
@property(nonatomic) double falseNorthing;

/**
     * @brief 获取或设置中央经线角度值。
     * <p>取值范围为-180度至180度。</p>
     * <p> 默认值为0。
     * @return 中央经线角度值。
     */
@property(nonatomic) double centralMeridian;

/**
     * @brief  获取或设置坐标原点对应纬度值。
     * <p>取值范围为-90度至90度，在圆锥投影中通常就是投影区域最南端的纬度值。</p>
     * <p>默认值为0。
     *@return 坐标原点对应纬度值。
     */
@property(nonatomic) double centralParallel;

/**
     * @brief 获取或设置第一标准纬线的纬度值。
     * <p>主要应用于圆锥投影中。如果是单标准纬线，则第一标准纬线与第二标准纬线的纬度值相同。</p>
     * <p>默认值为0。
     * @return 第一标准纬线的纬度值。
     */
@property(nonatomic) double standardParallel1;

 /**
     * @brief 返回第二标准纬线的纬度值。
     * <p>主要应用于圆锥投影中。如果是单标准纬线，则第一标准纬线与第二标准纬线的纬度值相同；如果是双标准纬线，则其值不能与第一标准纬线的值相同。</p>
     * <p> 默认值为0。
     * @return 第二标准纬线的纬度值。
     */
@property(nonatomic) double standardParallel2;

 /**
     * @brief 获取或设置投影转换的比例因子。
     * 
     *<p>用于减少投影变换的误差。墨卡托、高斯--克吕格和 UTM 投影的值一般为0.9996。</p>
     * <p> 默认值为0。
     * @return 投影转换的比例因子。
     */
@property(nonatomic) double scaleFactor;

/**
     * @brief  获取或设置投影转换的比例因子。
     * 
     *<p> 用于减少投影变换的误差。墨卡托、高斯--克吕格和 UTM 投影的值一般为0.9996。</p>
     */
@property(nonatomic) double azimuth;

/**
     * @brief  获取或设置第一个点的经度。用于方位投影或斜投影。
     * <p> 默认值为0。
     * @return 第一个点的经度。
     */
@property(nonatomic) double firstPointLongitude;

/**
     * @brief  获取或设置第二个点的经度。用于方位投影或斜投影。
     * <p> 默认值为0。
     * @return 第二个点的经度。
     */
@property(nonatomic) double secondPointLongitude;

/**
     * @brief 根据给定的 PrjParameter 对象构造一个与其完全相同的新对象。
     * @param prjParameter 指定的 PrjParameter 对象。
     */
-(id)initWithPrjParameter:(PrjParameter*)prjParameter;

/**
     * @brief 根据传入的 XML 字符串构建  <PrjParameter> 对象。
     * @param xml 传入的 XML 字符串。
     * @return 如果构建成功返回 true，否则返回 false。
     */
-(BOOL)formXML:(NSString *)xml;

/**
     * @brief 返回 PrjParameter 对象的 XML 字符串表示。
     * @return 表示投影参数对象的 XML 字符串。
     */
-(NSString *)toXML;

/**
     *@brief  克隆该对象本身。
     * @return 返回该对象的克隆。
     */
-(PrjParameter*)clone;

/**
     *@brief 释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     */
-(void)dispose;
@end
