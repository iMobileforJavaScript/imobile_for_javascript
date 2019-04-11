//
//  Projection.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "ProjectionType.h"

/**
 * 投影坐标系地图投影类。 
 *
 * <p>地图投影就是将球面坐标转化为平面坐标的过程。</p>
 * <p>一般来说，地图投影按变形性质可以分为等角投影、等距投影和等积投影，适于不同的用途，如果是航海图，等角投影是很常用。还有一种是各类变形介于这几种之间的任意投影，一般用作参考用途和教学地图。地图投影也可以按照构成方法分成两大类，分别为几何投影和非几何投影。几何投影是把椭球面上的经纬线网投影到几何面上，然后将几何面展为平面而得的，包括方位投影、圆柱投影和圆锥投影；非几何投影不借助几何面，根据某些条件有数学解析法确定球面与平面之间点与点的函数关系，包括伪方位投影、伪圆柱投影、伪圆锥投影和多圆锥投影。有关投影方式类型的详细信息请参考  <ProjectionType>。 </p>
 *
 */
@interface Projection : NSObject{

}

 /**
     * @brief 获取投影方式对象的名称。
     * <p> 默认值为 "No Projection" 。
     *@return 投影方式对象的名称。
     */
@property(nonatomic,readonly)NSString * name;

/**
     * @brief 获取或设置投影坐标系统的投影方式的类型。
     *<p> 默认值为 PRJ_NONPROJECTION 。
     * @return 投影坐标系统的投影方式的类型。
     */
@property(nonatomic)ProjectionType type;

/**
     * @brief 根据指定的参数来构造一个 Projection 的新对象。
     * @param type 投影坐标系统的投影方式的类型。
     */
-(id)initWithProjectionType:(ProjectionType)type;

/**
     * @brief 根据给定的 Projection 对象构造一个与其完全相同的新对象。
     * @param projection 指定的 Projection 对象。
     */
-(id)initWithProjection:(Projection *)projection;

 /**
     * @brief 对自身进行克隆。
     * @return 返回对自身的一个克隆。
     */
-(Projection *)clone;

 /**
     * @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     */
-(void)dispose;

/**
     * @brief 根据 XML 字符串构建投影坐标方式对象。
     * @param xml 指定的 XML 字符串。
     * @return 如果构建 XML 字符串成功返回 true，否则返回 false。
     */
-(BOOL)formXML:(NSString *)xml;

 /**
     * @brief 返回投影方式对象的 XML 字符串表示。
     * @return 投影方式对象的 XML字符串表示。
     */
-(NSString *)toXML;
@end
