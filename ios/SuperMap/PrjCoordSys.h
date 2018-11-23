//
//  PrjCoordSys.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "PrjCoordSysType.h"
#import "PrjFileVersion.h"
#import "PrjFileType.h"
#import "Unit.h"

@class GeoCoordSys,Projection,PrjParameter;

/** 投影坐标系类。
 * 
 * <p>投影坐标系统由地图投影方式、投影参数、坐标单位和地理坐标系组成。SuperMap  iMobile 7C for IOS
 * 中提供了很多预定义的投影系统，用户可以直接使用，此外，用户还可以定制自己投影系统。
 * <p>
 * 投影坐标系是定义在二维平面上的，不同于地理坐标系用经纬度定位地面点，投影坐标系是用 X、Y 坐标来定位的。每一个投影坐标系都基于一个地理坐标系。
 * </p>
 */
@interface PrjCoordSys : NSObject{
    @private
    GeoCoordSys *_geoCoordSys;
    Projection *_projection;
    PrjParameter *_PrjParameter;
}

/**
	 * @brief  获取或设置投影坐标系对象的名称。
	 * 
	 * <p> 默认值为 "User Define"。
	 * @return 投影坐标系对象的名称。
	 */
@property(nonatomic, copy)NSString* name;

/**
	 * @brief  获取或设置投影坐标系类型。
	 * <p>
	 * 当投影坐标系类型为自定义时，用户需另外指定地理坐标系、投影方法、坐标单位以及投影参数；其余的值为 SuperMap Object Java
	 * 系统预定义，用户不必指定其他参数。
	 * <p> 默认值为 PrjCoordSysType.PCS_USER_DEFINED。
	 * @return 投影坐标系类型。
	 */
@property(nonatomic)PrjCoordSysType type;

/**
	 * @brief  获取或设置投影坐标系的地理坐标系统对象。每个投影系都要依赖于一个地理坐标系。
	 * 
	 * <p> 默认值为空的  <GeoCoordSys> 对象。
	 * @return 投影坐标系的地理坐标系统对象。
	 */
@property(nonatomic)GeoCoordSys *geoCoordSys;

/**
	 * @brief 获取或设置投影坐标系统的投影方式。投影方式如等角圆锥投影、等距方位投影等等。
	 * 
	 *<p>  默认值为空的  <Projection> 对象。
	 * @return 投影坐标系统的投影方式。
	 */
@property(nonatomic)Projection *projection; 

/**
	 * @brief 获取或设置投影坐标系统对象的投影参数。
	 * 
	 * <p> 默认值为空的  <PrjParameter> 。
	 * @return 投影坐标系统对象的投影参数。
	 */
@property(nonatomic)PrjParameter *prjParameter;

/**
	 * @brief 获取或设置投影系统坐标单位。
	 * <p>
	 * 投影系统的坐标单位与距离单位（DistanceUnits）可以不同，例如经纬度坐标下的坐标单位是度，距离单位可以是米、公里等；
	 * 即使是普通平面坐标或者投影坐标，这两个单位同样可不同。
	 * </p>
	 * 
	 * <p> 默认值为 METER 。
	 * @return 投影系统坐标单位。
	 */
@property(nonatomic)Unit coordUnit;

/**
	 * @brief  获取或设置距离（长度）单位。
	 * 
	 * <p> 默认值为 METER 。
	 * @return 距离（长度）单位。
	 */
@property(nonatomic)Unit distanceUnit;

/**
	 * @brief   根据指定的参数来构造一个 PrjCoordSys 的新对象。
	 * 
	 * @param type      投影坐标系类型。  
	 */
-(id)initWithType:(PrjCoordSysType)type;

/**
	 * @brief  根据给定的 PrjCoordSys 对象构造一个与其完全相同的新对象。 
	 * 
	 * @param prjCoordSys 指定的 PrjCoordSys 对象。      
	 */
-(id)initWithPrjCoordSys:(PrjCoordSys*)prjCoordSys;

/**
	 *@brief   根据指定的参数来构造一个 PrjCoordSys 的新对象。
	 * 
	 * @param geoCdSys  投影坐标系所基于的地理坐标系。         
	 * @param proj  投影方式。投影方式如等角圆锥投影、等距方位投影等等。    
	 * @param prjp 投影参数。          
	 * @param name   投影坐标系名称。
	 */
-(id)initWithPrjCoordSys:(GeoCoordSys*)geoCdSys Projection:(Projection*)proj PrjParameter:(PrjParameter*)prjp Name:(NSString*)name;

/**
	 *@brief   据 XML 字符串构建  <PrjCoordSys> 对象，成功返回 true。
	 * 
	 * @param xml   指定的 XML 字符串。 
	 * @return 如果构建成功返回 true，否则返回 false。
	 */
-(BOOL)formXML:(NSString *)xml;

/**
	 * @brief  将投影坐标系类的对象转换为 XML 格式的字符串。
	 * 
	 * @return 表示投影坐标系类的对象的 XML 字符串。
	 */
-(NSString *)toXML;

/**
	 *  @brief  根据指定版本将 <PrjCoordSys> 对象导出到投影文件。
	 * 
	 * @param path   XML 文件的全路径。        
	 * @param version   导出投影文件的版本。         
	 * @return 导出成功返回 true，否则返回 false。
	 */
-(BOOL)toFile:(NSString *)path Version:(PrjFileVersion)version;

/**
	 * @brief  根据 XML 文件与指定版本构建  <PrjCoordSys> 对象。
	 * 
	 * @param path   XML 文件的全路径。
	 * @param version   指定的投影文件的版本。
	 * @return 构建成功返回 true，否则返回 false。
	 */
-(BOOL)fromFile:(NSString *)path Version:(PrjFileType)version;

/**
	 * @brief 对PrjCoordSys进行clone
	 * @return PrjCoordSys的clone对象
	 */
-(PrjCoordSys*) clone;

/**
	 *@brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
	 */
-(void)dispose;
@end
