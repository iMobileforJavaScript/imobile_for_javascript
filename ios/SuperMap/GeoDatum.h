//
//  GeoDatum.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "GeoDatumType.h"
@class GeoSpheroid;



 /** 大地参照系类。
 <p>该类包含有地球椭球参数。
 <p> 地球椭球体仅仅是描述了地球的大小及形状，为了更准确地描述地球上的地物的具体位置，需要引入大地参照系。大地参照系确定了地球椭球体相对于地球球心的位置，为地表地物的测量提供了一个参照框架，确定了地表经纬网线的原点和方向。大地参照系把地球椭球体的球心当作原点。一个地区的大地参照系的地球椭球体或多或少地偏移了真正的地心，地表上的地物坐标都是相对于该椭球体的球心的。目前被广泛利用的是 WGS84，它被当做大地测量的基本框架。不同的大地参照系适用于不同的国家和地区，一个大地参照系并不适合于所有的地区。
 */
@interface GeoDatum : NSObject{
@private
    NSString *_name;
    GeoSpheroid *_geoSpheroid;
    GeoDatumType _datumType;
}
/**@brief  获取或设置大地参照系对象的名称。
 <p>  默认值为 "User Define"。
 @return  大地参照系对象的名称。
    */
@property(nonatomic,retain)NSString *name;
 
 /**@brief  获取或设置地球椭球体对象。只当大地参照系类型为自定义类型时才可以设置。
 <p>人们通常用球体或椭球体来描述地球的形状和大小，有时为了计算方便，可以将地球看作一个球体，但更多的时候是把它看作椭球体。一般情况下在地图比例尺小于1：1,000,000 时，假设地球形状为一球体，因为在这种比例尺下球体和椭球体的差别几乎无法分辨；而在1：1,000,000 甚至更高精度要求的大比例尺时，则需用椭球体逼近地球。椭球体是以椭圆为基础的，所以用两个轴来表述地球球体的大小，即长轴（赤道半径）和短轴（极地半径）。</p>
 <p>  默认值为空的  GeoSpheroid 对象
 @return  地球椭球体对象。
     */
@property(nonatomic,retain)GeoSpheroid *geoSpheroid;

/**@brief 获取或设置大地参照系的类型。
 <P>当大地参照系为自定义时，用户需另外指定椭球体参数；其它的值为 SuperMap Objects Java 系统预定义，用户不必指定椭球体参数。参见  GeoDatumType 。</p>
 <P> 默认值为  DATUM_WGS_1984。
 @return  大地参照系的类型。
     */
@property(nonatomic,assign)GeoDatumType datumType;

///构造一个新的 GeoDatum 对象。
-(id)init;

/**@brief 根据指定的参数来构造一个 GeoDatum 的新对象。
 @param  type 指定的大地参照系类型。
     */
-(id)initWithType: (GeoDatumType)type;
 /**@brief 根据指定的参数来构造一个 GeoDatum 的新对象。
 @param  geoSpheroid 地球椭球体。
 @param  name 大地参照系名称。
     */
-(id)initWithGeoSpheroid : (GeoSpheroid *)geoSpheroid Name:(NSString *)name;

/**@brief 根据给定的 GeoDatum 对象构造一个与其完全相同的新对象。
 @param  geodatum 指定的 GeoDatum 对象。
     */
-(id)initWithGeoDatum:(GeoDatum *)geodatum;
 /**@brief  根据 XML 字符串构建 GeoDatum 对象。
 @param  xml 指定的 XML 字符串。
 @return  如果构建成功返回 true，否则返回 false。
     */
-(BOOL)fromXML:(NSString *)xml;
 /**@brief 将大地参照系类的对象转换为 XML 格式的字符串。
 @return  表示大地参照系类的对象转换为 XML 格式的字符串。
     */
-(NSString *)toXML;
/**@brief 返回当前GeoDatum对象的一个拷贝。
 @return  通过克隆操作得到的GeoDatum对象。
	 */
-(GeoDatum *)clone;
 

///释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
-(void)dispose;

@end
