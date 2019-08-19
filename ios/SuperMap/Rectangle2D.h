//
//  Rectangle2D.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Point2D;
@class Size2D;
/** 矩形类。
 * 
 * <p>用来表示坐标值为双精度的矩形对象，即其左边界坐标值、下边界坐标值、右边界坐标值、上边界坐标值均为双精度类型，其中左边界坐标值小于等于右边界坐标值，下边界坐标值小于等于上边界坐标值。
 * <p>该类的对象通常用于确定范围，可用来表示几何对象的最小外接矩形、地图窗口的可视范围，数据集的范围等，另外在进行矩形选择，矩形查询等时也会用到此类的对象。</p>
 * <p>最通常的构造矩形对象的方法为用指定的左边界坐标值、下边界坐标值、右边界坐标值、上边界坐标值来构造；使用默认构造函数构造矩形对象为一个空对象，即左边界坐标值、下边界坐标值、右边界坐标值和上边界坐标值均为 -1.7976931348623157e+308，另外还可以通过给定左下角点和右上角点的方式，以及给定左下角点和矩形宽度和高度的方式来构造新的矩形对象。
 * <p>该类提供了与矩形对象相关的关系的判断，以及返回矩形对象之间的交集和并集的方法。使用该类提供的方法，您还可以对矩形对象进行缩放和平移，以及对已有矩形对象的边界坐标值采用某种取整方法来返回边界坐标值为整数的新的矩形对象。</p>
 *
 */
@interface Rectangle2D : NSObject{
@private 
    double _left;
    double _bottom;
    double _right;
    double _top;
    double _width;
    double _height;
    Point2D *_center;
}
 /**
     * @brief 获取或设置此矩形对象左边界的坐标值。
     *
     * <p> 默认值为 -1.79769313486232E+308。
     * @return 此矩形对象左边界的坐标值。
     */
@property(nonatomic,assign)double left;
 /**
     * @brief 获取或设置此矩形对象右边界的坐标值。
     *
     *  <p>  默认值为 -1.79769313486232E+308。
     * @return 此矩形对象右边界的坐标值。
     */
@property(nonatomic,assign)double right;
 /**
     * @brief 获取或设置此矩形对象上边界的坐标值。
     *
     * <p> 默认值为 -1.79769313486232E+308。
     * @return 此矩形对象上边界的坐标值。
     */
@property(nonatomic,assign)double top;
/**
     * @brief 获取或设置此矩形对象下边界的坐标值。
     *
     *<p>  默认值为 -1.7976931348623157e+308。
     * @return 此矩形对象下边界的坐标值。
     */
@property(nonatomic,assign)double bottom;
/**
     * @brief 获取此矩形对象的宽度，其值为右边界坐标值与左边界值之差。
     *
     * <p> 默认值为 -1.79769313486232E+308。
     * @return 此矩形对象的宽度。
     */
@property(nonatomic,readonly)double width;
 /**
     * @brief 获取此矩形对象的高度，其值为上边界坐标值与下边界坐标值之差。
     *
     *  <p>  默认值为 0。
     * @return 此矩形对象的高度。
     */
@property(nonatomic,readonly)double height;
/**
     * @brief 获取矩形对象的中心点，其 x 坐标值为（左边界坐标值+右边界坐标值）/2，y 坐标值为（上边界坐标值+下边界坐标值）/2。
     *
     * <p> 默认值为 {X = -Infinity,Y = -Infinity}。
     *@return 表示矩形中心点的 {@link Point2D Point2D} 对象。
     */
@property(nonatomic,readonly)Point2D *center;
/**
     *@brief 构造一个新的 Rectangle2D 对象，其坐标值均为 -1.7976931348623157e+308。
     */
-(id)init;
 /**
     * @brief 根据给定的 Rectangle2D 对象构造一个与其完全相同的新对象。
     * @param rectangle2D 指定的 Rectangle2D 对象。
     */
-(id)initWithRectangle2D:(Rectangle2D *)rectangle2D;
/**
      * @brief 根据指定的参数来构造一个 Rectangle2D 的新对象。
      * @param leftBottom 矩形的左下角点坐标。
      * @param width 矩形的宽度。
      * @param height 矩形的高度。
      */
-(id)initWithLeftBottom:(Point2D *)leftBottom Width:(double)width Height:(double)height;
 /**
      * @brief 根据指定的参数来构造一个 Rectangle2D 的新对象。
      * @param leftBottom 左下角点。
      * @param rightTop 右上角点。
      */
-(id)initWithLeftBottom:(Point2D *)leftBottom RightTop:(Point2D *)rightTop;
/**
      * @brief 根据指定的参数来构造一个 Rectangle2D 的新对象。
      * @param center 指定的矩形的中心点。
      * @param size2D 指定的矩形的大小。
      */
-(id)initWithPoint2D:(Point2D *)center Size2D:(Size2D *)size2D;
/**
      * @brief 根据指定的参数来构造一个 Rectangle2D 的新对象。
      * @param left 左边界的 X 坐标。
      * @param bottom 底边的 Y 坐标。
      * @param right 右边界的 X 坐标。
      * @param top 顶边的 Y 坐标。
      */
-(id) initWith:(double) left bottom:(double) bottom right:(double) right top:(double)top;
 /**
     * @brief 返回一个空的矩形对象，其左边界坐标值、下边界坐标值、右边界坐标值和上边界坐标值均为 -1.7976931348623157e+308。
     * @return 一个空的 Rectangle2D 对象。
     */
+(Rectangle2D *)getEmpty;
 /**
     * @brief 判断此矩形对象是否为空，即其左边界坐标值、下边界坐标值、右边界坐标值和上边界坐标值是否都为 -1.7976931348623157e+308。关于默认零值判断精度的详细信息请参见  Environment 类。
     *
     * <p> 默认值为 true。
     * @return 当矩形对象的左边界的 X 坐标，底边的 Y 坐标，右边界的 X 坐标和顶边的 Y 坐标均为 -1.7976931348623157e+308 时，返回 true， 否则返回 false。
     */
-(BOOL)isEmpty;
 /**
     * @brief  返回当前 Rectangle2D 对象的一个拷贝。 
     * @return  通过克隆操作得到的 Rectangle2D 对象。
     */
-(Rectangle2D *)clone;
  /**
     * @brief 分别取大于或等于指定矩形对象的左边界的 X 坐标，上边界的 Y 坐标，右边界的 X 坐标和下边界的 Y 坐标的最小整数值，并以这些整数值构造一个新的矩形对象返回。
     *
     * @param rectangle2D 要转换的 Rectanlge2D。
     * @return 此方法转换得到的 Rectangle2D。
     */
+(Rectangle2D *)ceiling:(Rectangle2D *)rectangle2D;
  /**
     * @brief  返回一个矩形对象，其左边界的 X 坐标，上边界的 Y 坐标，右边界的 X 坐标和下边界的 Y 坐标值是不大于指定矩形对象相应坐标值的最大整数值。
     *
     * @param rectangle2D 要转换的 Rectangle2D。
     * @return 此方法转换得到的 Rectangle2D。
     */
+(Rectangle2D *)floor:(Rectangle2D *)rectangle2D;
/**
     * @brief 对指定矩形对象的左边界的 X 坐标，上边界的 Y 坐标，右边界的 X 坐标和下边界的 Y 坐标值进行四舍五入处理，并以这些整数值构造一个新的矩形对象返回。
     *
     * @param rectangle2D 要转换的 Rectangle2D。
     * @return 此方法转换得到的 Rectangle2D。
     */
+(Rectangle2D *)round:(Rectangle2D *)rectangle2D;
 /**
     * @brief 判定指定的点是否包含在此矩形内。当点在矩形内部和边界上时，均认为其包含在矩形内。
     *
     * @param point2D 要测试的 Point2D。
     * @return 如果指定的点在此矩形内部和边界上时，此方法将返回 true；否则将返回 false。
     */
-(BOOL)containsPoint2D:(Point2D *)point2D;
 /**
     * @brief 判定指定的矩形区域是否完全包含在此矩形内。当指定矩形在此矩形内部，或与此矩形重合时，均认为其完全包含在此矩形内。
     *
     * @param rectangle2D 要测试的 Rectangle2D。
     * @return 如果指定的矩形在此矩形内部，或与此矩形重合时，
     * 此方法将返回 true；否则将返回 false。
     */
-(BOOL)containsRectangle2D:(Rectangle2D *)rectangle2D;
 /**
     * @brief 判定指定坐标构成的点是否包含在此矩形内。当点在矩形内部和边界上时，均认为其包含在矩形内。
     *
     * @param x 要测试的 X 坐标。
     * @param y 要测试的 Y 坐标。
     * @return 如果指定坐标构成的点在此矩形内部和边界上时，此方法将返回 true；否则将返回 false。
     */
-(BOOL)containsX:(double)x Y:(double)y;
 /**
     * @brief  重写基类的equals方法
     * @param obj Object
     * @return boolean
     */
-(BOOL)equalsID:(id)obj;
/**
     * @brief  判定此矩形对象是否与指定的矩形对象相等，即有相同的边界坐标值。注意其判定精度为零值判断精度。关于更多零值判断精度的信息，请参见  Environment 类。
     *
     * @param rectangle2D 要测试的 Rectangle2D。
     * @return 如果指定的矩形与此 Rectangle2D 的对应边界坐标值都相等，此方法将返回 true；否则将返回 false。
     */
-(BOOL)equalsRectangle2D:(Rectangle2D *)rectangle2D;
 /**
     * @brief 该方法在垂直和水平方向对此矩形进行缩放。
     * <p>新的左边界坐标值=Min(原始左边界坐标值-dx，原始右边界坐标值+dx)；</p>
     * <p>新的下边界坐标值=Min(原始上边界坐标值+dy，原始下边界坐标值-dy)；</p>
     * <p>新的右边界坐标值=Max(原始左边界坐标值-dx，原始右边界坐标值+dx)；</p>
     * <p>新的上边界坐标值=Max(原始上边界坐标值+dy，原始下边界坐标值-dy)；</p>
     * @param x 此 Rectangle2D 结构的水平缩放量。
     * @param y 此 Rectangle2D 结构的垂直缩放量。
     */
-(void)inflateX:(double)x Y:(double)y;
/**
     * @brief 用此矩形与指定矩形的交集替换此矩形。若此矩形与指定矩形没有交集，此矩形将变为一个空矩形对象。
     *
     * @param recttangle2D 用其进行相交操作的矩形。
     */
-(void)intersect:(Rectangle2D *)recttangle2D;
/**
     * @brief 判断此矩形与指定矩形是否有交集。当此矩形与指定的矩形有公共点或公共边时，认为其有交集。
     *
     * @param rectangle2D 要测试的矩形。
     * @return 如果两个矩形有交集,则此方法返回 true。
     */
-(BOOL)hasIntersection:(Rectangle2D *)rectangle2D;
/**
     * @brief 此方法将此矩形在 x 方向平移 x，在y方向平移 y。
     * <p>新的左边界坐标值=原始左边界坐标值+x；</p>
     * <p>新的下边界坐标值=原始下边界坐标值+y；</p>
     * <p>新的右边界坐标值=原始右边界坐标值+x；</p>
     * <p>新的上边界坐标值=原始上边界坐标值+y。</p>
     * @param x 水平偏移该位置的量。
     * @param y 垂直偏移该位置的量。
     */
-(void)offsetX:(double)x Y:(double)y;
 /**
     * @brief  用包含此矩形与指定矩形并集的最小矩形替换此矩形。
     *
     * @param rectangle2D 要与当前矩形求并集的矩形。
     */
-(void)unions:(Rectangle2D *)rectangle2D;
 /**
     * @brief 设置一个空的矩形对象，其左边界坐标值、下边界坐标值、右边界坐标值和上边界坐标值均为 -1.7976931348623157e+308。
     */
-(void)setEmpty;

 /**
     * @brief 将矩形对象转换为JSON串。
	 * @return 矩形对象转换成的JSON串。
     */
-(NSString*) toJson;
@end
