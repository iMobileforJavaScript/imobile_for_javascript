//
//  GeoSpheroid.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "GeoSpheroidType.h"

/**  地球椭球体参数类。 
 <p>该类主要用来描述地球的长半径和扁率。 </p>
 <p>人们通常用球体或椭球体来描述地球的形状和大小，有时为了计算方便，可以将地球看作一个球体，但更多的时候是把它看作椭球体。一般情况下在地图比例尺小于1：1,000,000 时，假设地球形状为一球体，因为在这种比例尺下球体和椭球体的差别几乎无法分辨；而在1：1,000,000 甚至更高精度要求的大比例尺时，则需用椭球体逼近地球。椭球体是以椭圆为基础的，所以用两个轴来表述地球球体的大小，即长轴（赤道半径）和短轴（极地半径）。</p>
 <p>因为同一个投影方法，不同的椭球体参数，相同的数据投影出来的结果可能相差很大，所以需要选择合适的椭球参数。不同年代、不同国家和地区使用的地球椭球参数有可能不同，中国目前主要用的是克拉索夫斯基椭球参数；北美大陆及英法等主要用的是克拉克椭球参数。</p>
 */
@interface GeoSpheroid : NSObject {
@private
    double _axis;
    double _flatten;
    NSString *_name;
    GeoSpheroidType _type;
    NSString *_xml;
}
 /**@brief  获取或设置地球椭球体的长半径。
 <p> 地球椭球体的长半径也叫地球赤道半径，通过它和地球扁率可以求得地球椭球体的极地半径、第一偏心率、第二偏心率等等。只当地球椭球体的类型为自定义类型时，长半径才可以被设置。
 <p>  默认值为 6378137.0。
 @return  地球椭球体的长半径。
     */
@property(nonatomic,assign)double axis;
 /**@brief 获取或设置地球椭球体的扁率。
 <p> 只当地球椭球体的类型为自定义类型时，扁率才可以被设置。
 <p> 地球椭球体的扁率反映了地球椭球体的圆扁情况， 一般为地球长短半轴之差与长半轴之比。</p>
 <p>  默认值为0.0033528107。
  @return  地球椭球体的扁率。
     */
@property(nonatomic,assign)double flatten;
 /**@brief 获取或设置地球椭球体对象的名称。
 <p>  只当地球椭球体的类型为自定义类型时，才可以设置。
 <p>  默认值为 "WGS_1984"。
  @return  地球椭球体对象的名称。
     */
@property(nonatomic,assign)NSString *name;
 
 /**@brief 获取或设置地球椭球体的类型。
 <p>   该地球椭球体类型为自定义类型时，用户需另外指定椭球体的长半径和扁率；其余的值为 SuperMap objects Java 系统预定义，用户不必指定长半径和扁率。可参见地球椭球体 GeoSpheroidType 枚举类。
 <p>  默认值为SPHEROID_WGS_1984 。
 @return  地球椭球体的类型。
     */
@property(nonatomic,assign)GeoSpheroidType type;

///构造一个新的 GeoSpheroid 对象。
-(id)init;

/**@brief 根据指定的参数来构造一个 GeoSpheroidType 的新对象。
 @param  type 指定的 GeoSpheroidType 对象。
     */
-(id)initWithGeoSpheroidType:(GeoSpheroidType) type;
 
 /**@brief 根据给定的 GeoSpheroidType 对象构造一个与其完全相同的新对象。
 @param  geoSpheroid 指定的 GeoSpheroidType 对象。
     */
-(id)initWithGeoSpheroid:(GeoSpheroid *)geoSpheroid;

/**@brief 根据指定的参数来构造一个 GeoSpheroid 的新对象。
 @param  axis 指定的地球椭球体的长半径。
 @param  faltten 指定的地球椭球体的扁率。
 @param  name 指定的地球椭球体的名称。
     */
-(id)initWithAxis:(double)axis Flatten:(double)faltten Name:(NSString *)name;
/**@brief 从指定的 XML 字符串中构建地球椭球体参数类的对象。
 @param  xml 指定的 XML 字符串。
 @return  如果构建成功返回 true，否则返回 false。
     */
-(BOOL)fromXML:(NSString *)xml;
/**@brief 将地球椭球参数类的对象转换为 XML 格式的字符串。
 @return  表示地球椭球体参数类的对象的 XML 字符串。
     */
-(NSString *)toXML;
/**@brief 对GeoSpheroid进行clone
@return  GeoSpheroid的clone对象
	 */
-(GeoSpheroid *)clone;

///释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
-(void)dispose;
@end
