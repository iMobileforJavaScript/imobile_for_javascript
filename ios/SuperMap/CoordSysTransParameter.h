//
//  CoordSysTransParameter.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
/** 投影坐标系转换参数类。 
 *  
 *<p>通常包括平移、旋转和比例因子。</p> 
 * <p>该投影坐标系转换类用于进行参照系的变换的，有参照系平移、旋转和比例尺缩放因子等参数，在投影转换中，如果源和目标投影的地理坐标系不同，则需要进行参照系变换，通常有三参数、七参数等方法，指的就是这些变换参数。</p>
 * <p>SuperMap 提供常用的六种参照系转换方法，详见 CoordSysTransMethod 方法。不同的参照系转换方法需要指定不同的转换参数：</p>
 * <p>1. 三参数转换法（MTH_GEOCENTRIC_TRANSLATION）、莫洛金斯基转换法（MTH_MOLODENSKY）、简化的莫洛金斯基转换法（MTH_MOLODENSKY_ABRIDGED）属于精度较低的几种转换方法，在数据精度要求不高的情况下一般可以采用这几种方法。
 *   这三种转换法需要给定三个平移转换参数：X 轴坐标偏移量（translateX）、Y 轴坐标偏移量（translateY）和 Z 轴偏移量（translateZ）；</p> 
 * <p>2. 位置矢量法（MTH_POSITION_VECTOR）、基于地心的七参数转换法（MTH_COORDINATE_FRAME）、布尔莎方法（MTH_BURSA_WOLF）属于精度较高的几种转换方法。需要七个参数来进行调整和转换，包括除上述的三个平移转换参数外，还需要设置
 *   三个旋转转换参数（X 轴旋转角度（rotateX）、Y 轴旋转角度（rotateY）和 Z 轴旋转角度（rotateZ）和投影比例尺差参数（scaleDifference））。</p> 
 */
@interface CoordSysTransParameter : NSObject
/**
     * @brief 获取或设置 X 轴的坐标偏移量。单位为米。
     * <p>  默认值为 0。
     * @return X 轴的坐标偏移量。
     */
@property(nonatomic,assign)double translateX;

/**
      * @brief 获取或设置 Y 轴的坐标偏移量。单位为米。
     * <p> 默认值为 0。
     * @return Y 轴的坐标偏移量。
     */
@property(nonatomic)double translateY;

/**
 * @brief 获取或设置 Z 轴的坐标偏移量。单位为米。
 * <p> 默认值为 0。
 * @return Z 轴的坐标偏移量。
 */
@property(nonatomic)double translateZ;
 /**
     *@brief  获取或设置 X 轴的旋转角度。用于不同大地参照系之间的转换。单位为弧度。
     * <p>  默认值为 0。
     * @return  X 轴的旋转角度。
     */
@property(nonatomic)double rotateX;

 /**
     * @brief 获取或设置 Y 轴的旋转角度。用于不同大地参照系之间的转换。单位为弧度。
    * <p>   默认值为 0。
     *@return  Y 轴的旋转角度。
     */
@property(nonatomic)double rotateY;
/**
 * @brief 获取或设置 Z 轴的旋转角度。用于不同大地参照系之间的转换。单位为弧度。
 * <p>   默认值为 0。
 *@return  Z 轴的旋转角度。
 */
@property(nonatomic)double rotateZ;
/**
    * @brief  获取或设置投影比例尺差。单位为百万分之一。用于不同大地参照系之间的转换。
     * <p>   默认值为 0。
     *  @return 投影比例尺差。
     */
@property(nonatomic)double scaleDifference;

 /**
     * @brief 根据给定的 CoordSysTransParameter 对象构造一个与其完全相同的新对象。
     * @param coordSysTransParameter 指定的 CoordSysTransParameter 对象。
     */
-(id)initWithCoordSysTransParameter:(CoordSysTransParameter*)coordSysTransParameter;

/**
     *@brief  克隆该对象本身。
     * @return 返回该对象的克隆。
     */
-(CoordSysTransParameter *)clone;

 /**
    * @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     */
-(void)dispose;

/**
     *@brief   根据 XML 字符串构建 CoordSysTransParameter 对象，成功返回 true。
     * @param xml 表示投影转换参数对象的 XML 字符串。
     * @return 如果构建 XML 字符串成功则返回 true，否则返回 false。
     */
-(BOOL)fromXML:(NSString *)xml;

 /**
    *@brief 将该 CoordSysTransParameter 对象输出为 XML 字符串。
     * @return  CoordSysTransParameter 对象的 XML 格式字符串。
     */
-(NSString *)toXML;
@end
