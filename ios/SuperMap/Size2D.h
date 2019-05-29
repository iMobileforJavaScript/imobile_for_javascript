//
//  Size2D.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

  ///存储有序双精度数对。
@interface Size2D : NSObject{
  
  /**
     * @brief 获取或设置此 Size2D 的水平分量，即宽度。
     *
     * <p> 默认值为 -1.7976931348623157e+308。
     * @return 此 Size2D 的水平分量。
     */
   double _width;
  /**
     * @brief 获取或设置此 Size2D 的垂直分量，即高度。
     *
     * <p> 默认值为 -1.7976931348623157e+308。
     * @return 此 Size2D 的垂直分量。
     */
    double _height;
}
 /**
     * @brief 获取或设置此 Size2D 的水平分量，即宽度。
     *
     * <p> 默认值为 -1.7976931348623157e+308。
     * @return 此 Size2D 的水平分量。
     */
@property(nonatomic)double width;
 /**
     * @brief 获取或设置此 Size2D 的垂直分量，即高度。
     *
     *  <p> 默认值为 -1.7976931348623157e+308。
     * @return 此 Size2D 的垂直分量。
     */
@property(nonatomic)double height;
/**
     * 
     * @brief 构造一个新的 Size2D 对象，其宽度和高度均为 -1.7976931348623157e+308。
     */
- (id)init;

 /**
     * @brief 根据指定的参数来构造一个 Size2D 的新对象。
     * @param width 用来指定 Size2D 的宽度值。
     * @param height 用来指定 Size2D 的高度值。
     */
- (id)initWithWidth:(double)width Height:(double)height;

/**
     * @brief 根据给定的 Size2D 对象构造一个与其完全相同的新对象。
     * @param size2D 指定的 Size2D 对象。
     */
- (id)initWith:(Size2D *)size2D;

 /**
     *@brief   表示一个空的只读的 Size2D 对象， 即 Width，Height 值均为 -1.7976931348623157e+308。
     * @return 一个空的 Size2D 对象。
     */
+ (Size2D *)getEmpty;

/**
    * @brief   判断当前 Size2D 对象是否为空，即是否宽度和高度均为 -1.7976931348623157e+308。
    *
    * <p> 默认值为 true， 即为当前 Size2D 对象的宽度和高度为 -1.7976931348623157e+308。
    * @return 若此 Size2D 为空则返回 true，否则返回 false。
    */
- (BOOL)isEmpty;
 
 /**
     * @brief  指定此 Size2D 是否包含与指定 Object 有相同的 width，height。
     * @param obj 要测试的对象。
     * @return 一个布尔值，若 obj 为 Size2D 并与此 Size2D 的 width，height 相等，则为 true，否则为 false。
     */
- (BOOL)equalsObj:(id)obj;

/**
     * @brief  判定此 Size2D 是否与指定 Size2D 有相同的坐标。
     *
     * <p> 注意此处的判定精度为零值判断精度，要了解更多零值判断精度的信息，请参见  Environment  类。
     * @param size2D 要测试的对象。
     * @return 如果此 Size2D 与指定的 Size2D 的坐标相等则为 true,否则为 false。
     */
- (BOOL)equals:(Size2D *)size2D;

/**
     * @brief 返回一个新的 Size2D 对象。
     *
     * <p> 其宽度和高度值为小于等于指定 Size2D 对象对应值的最大整数值，例如，指定的对象为 Size2D(2.3,6.8)，则生成的新的对象为 Size2D(2,6)。
     * @param size2D 要转换的 Size2D。
     * @return 一个 Size2D 结构的对象。
     */
+(Size2D *)floor:(Size2D *)size2D;

/**
     * @brief 返回一个新的 Size2D 对象。
     *
     *  <p>   其宽度和高度值为大于等于指定 Size2D 对象对应值的最小整数值，例如给定 Size2D(2.3,6.8)，则生成的新的对象为 Size2D(3,7)。
     * @param size2D 要转换的 Size2D。
     * @return 一个 Size2D 结构的对象。
     */
+(Size2D *)ceiling:(Size2D *)size2D;

/**
     * @brief 返回一个新的 Size2D 对象。
     *
     *<p>    其宽度和高度值是通过对给定 Size2D 对象的对应值进行四舍五入得到，例如给定 Size2D(2.3,6.8)， 则四舍五入后的新的对象为 Size2D(2,7)。
     * @param size2D 要转换的 Size2D 对象。
     * @return 一个 Size2D 结构的对象。
     */
+(Size2D *)round:(Size2D *)size2D;

/**
     * @brief  返回当前 Size2D 对象的一个拷贝。 
     * @return  通过克隆操作得到的 Size2D 对象。
     */
-(Size2D *)clone;

@end

