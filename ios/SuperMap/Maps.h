//
//  Maps.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Workspace;

/** 地图集合类。
 *  
 *  <p>存储地图集合对象所在的工作空间里保存的所有地图，但通过该类只能访问到当前工作空间中包含的地图的名称。对地图的访问和操作必须通过 SuperMap.Mapping 包的 <Map> 类来进行。
 * <p>该类用于管理一个工作空间中的所有地图，包括添加、删除、修改工作空间中的地图等操作。其中地图的名称是唯一标识，不可以重复。即使地图所引用的数据或者是数据源被删除，图层仍然存在于工作空间中，只是图层不显示内容，但是当把地图连接到其他的数据源，地图仍然可以显示。</p>
 */
@interface Maps : NSObject{

    Workspace* _workspace;
}

 /**
     * @brief 获取当前地图集合中地图对象的总数。
     *
     *  默认值为 0。
     * @return 当前地图集合中地图对象的总数。
     */
@property (assign,nonatomic,readonly) NSInteger count;

  /**
     * @brief 返回地图集合对象中指定序号的地图的名字。
     *
     * @param index 指定地图的序号。
     * @return 地图集合对象中指定序号的地图的名字。
     * @exception IndexOutOfBoundsException 如果 index 小于 0 或 index 大于或等于 count 时，其中 count 是地图集合中地图的总数。
     */
-(NSString*) get:(NSInteger) index;

/**
     * @brief 返回当前地图集合对象中指定名称的地图的序号。
     * @param name 指定的地图名称。该名称不区分大小写。
     * @return 当前地图集合对象中指定名称的地图的序号。
     */
-(NSInteger) indexOf:(NSString*) name;

 /**
     * @brief  删除此地图集合对象中的所有地图，即工作空间保存的所有地图。
     */
-(void) clear;

/**
     * @brief  将指定的  XML 字符串表示的地图替换地图集合对象中指定序号的地图。
     * @param index 指定的序号。
     * @param xml 用来替换指定地图的新地图的  XML 字符串表示。
     * @return 如果操作成功，返回 true；否则返回 false。
     * @exception IndexOutOfBoundsException 如果 index 小于0或 index 大于等于 count 时，其中 count 是地图集合中地图的总数。
     */
-(BOOL) setMapXML:(NSInteger) index xml:(NSString*) xml;

	/**
     * @brief  添加地图到此地图集合对象中。
	 * <p>XML 字符串包含地图所有的配置信息(包括地图的名称、背景透明与否、属性信息、图层信息、专题图信息等)，主要从
	 * Map 对象的ToXML方法中得到，如果想保存地图，需要先用ToXML方法将地图转换成XML字符串，然后用Maps对象的该方法将表示地图的XML字符串存储到
	 * Maps 对象中，从而实现将地图添加到地图集合中。</p>
     * @param name 添加到地图集合中的地图名称。该名称不区分大小写。
     * @param xml 表示要添加的地图的 XML 字符串。
     * @return 新添加的地图在此地图集合对象中的序号。
     */

-(int) add:(NSString *)name withXML:(NSString *)xml;

-(BOOL) removeMapAtIndex:(NSInteger)index;

-(BOOL) removeMapName:(NSString *)name;

@end
