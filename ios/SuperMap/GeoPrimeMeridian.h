//
//  GeoPrimeMeridian.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

#import "GeoPrimeMeridianType.h"

/** 中央子午线类。
 <p>该对象主要应用于地理坐标系中，地理坐标系由三部分组成：中央子午线、参照系或者大地基准（Datum）和角度单位。</p>
 */
@interface GeoPrimeMeridian : NSObject {
@private
    double _longtitudeValue;
    NSString *_name;
    GeoPrimeMeridianType _type;
    NSString *_xml;
}

/**@brief 获取或设置中央经线值，单位为度。
 <p> 默认值为 0。
 @return  中央经线值。
	 */
@property(nonatomic,assign)double longitudeValue;

/**@brief 获取或设置中央经线对象的名称。
 <p>  默认值为 "Greenwich"。
 @return  中央经线对象的名称。
	 */
@property(nonatomic,assign)NSString *name;

/**@brief 获取或设置中央经线的类型。
 <p>   默认值为 PRIMEMERIDIAN_GREENWICH
 @return  中央经线的类型。
	 */
@property(nonatomic,assign)GeoPrimeMeridianType type;


///构造一个新的 GeoPrimeMeridian 对象。
-(id)init;

/**@brief 根据指定的参数来构造一个 GeoPrimeMeridian 的新对象。
 @param  type 指定的 GeoPrimeMeridianType 对象。
	 */
-(id)initWithPrimeMeridianType:(GeoPrimeMeridianType)type;

/**@brief 根据指定的参数来构造一个 GeoPrimeMeridian 的新对象。
 @param  longitudeValue   指定的中央经线值，单位：度。
 @param  value 指定的中央经线对象的名称。
    */
-(id)initWithLongtitude:(double)longitudeValue Name:(NSString *)value;

/**@brief  根据指定的 GeoPrimeMeridian 对象构造一个与其完全相同的新对象。
 @param  geoPrimeMerdian  指定的 GeoPrimeMeridian 对象。
	 */
-(id)initWithPrimeMeridian:(GeoPrimeMeridian *)geoPrimeMerdian;

/**@brief  根据指定的 XML 字符串构建  <GeoPrimeMeridian> 对象。
 @param  xml  指定的 XML 字符串。
 @return  如果构建成功返回 true，否则返回 false。
	 */
-(BOOL)fromXML:(NSString *)xml;

/**@brief  返回表示  <GeoPrimeMeridian> 对象的 XML 字符串。
 @return  表示  <GeoPrimeMeridian> 类对象的 XML 字符串。
	 */
-(NSString *)toXML;

/**@brief  对GeoPrimeMeridian进行clone
 @return  GeoPrimeMeridian的clone对象
	 */
-(GeoPrimeMeridian *)clone;


///释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
-(void)dispose;
@end
