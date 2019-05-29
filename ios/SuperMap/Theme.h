//
//  Theme.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "ThemeType.h"

///专题图类，该类是所有专题图的基类。所有专题图类，如单值专题图，标签专题图，分段专题图等都继承自该类。
@interface Theme : NSObject {
    ThemeType _themeType;
}

/**
     * @brief 获取专题图的类型。详细信息请参见ThemeType类。
     * @return 专题图的类型。
     */
@property(nonatomic,readonly)ThemeType themeType;


  /**
     * @brief  输出专题图格式化字符串。格式化字符串提供专题图的相关设置信息，与 XML 字符串不同的是，格式化字符串不可导入显示专题图，只用于提供专题图的相关信息。
     * 
     * 1. 对于栅格分段专题图，其格式为{Caption=”china”, Start=10 End=20, Visible=true?false, Style={linestyle=,markerstyle=,fillstyle=} }；</li>
     * 2. 对于栅格单值专题图，其格式为{Caption=”china”, Unique =20, Visible=true?false, Style={linestyle=,markerstyle=,fillstyle=} }；</li>
     * 3. 对于标签专题图，其格式为{Caption=”China”, Start=10 End=20, Visible=true, Style={name=,width=,height=,color=()} }；</li>
     * <li>对于分段专题图，其格式为{Caption=”china”, Start=10 End=20, Visible=true?false, Style={linestyle=,markerstyle=,fillstyle=}；</li>
     * <li>对于单值专题图，其格式为{Caption=”china”, Unique =20, Visible=true?false, Style={linestyle=,markerstyle=,fillstyle=} }。</li>
     * </ol>
     *  @return 专题图的格式化字符串。
     */
-(NSString *)themeToString;

  /**
     * @brief 返回内存专题图数据。
	 * <p>用内存数据制作专题图的方式与表达式制作专题图的方式互斥，前者优先级较高。</p>
	 * <p>第一个参数代表专题值，即数据集中用来做专题图的字段或表达式的值；第二个参数代表外部值。在制作专题图时，会用外部值代替专题值来制作相应的专题图。</p>
     *  @return 内存专题图数据。
     */
-(NSDictionary*)getMemoryData;

  /**
     * @brief 设置内存专题图数据。
	 * <p>用内存数据制作专题图的方式与表达式制作专题图的方式互斥，前者优先级较高。</p>
	 * <p>第一个参数代表专题值，即数据集中用来做专题图的字段或表达式的值；第二个参数代表外部值。在制作专题图时，会用外部值代替专题值来制作相应的专题图。</p>
     * @param memoryData 内存专题图数据。
     */
-(void) setMemoryData:(NSDictionary*)memoryData;

/**
* @brief 导出专题图信息为 XML 字符串。
* <p>在 SuperMap 中，各种专题图的风格的设置都可以导出成 XML 格式的字符串，此 XML 格式的字符串中记录了关于这种专题图的所有设置，如对于标签专题图的 XML 格式字符串会记录专题图类型，可见比例尺，标签风格的设置，是否流动显示，是否自动避让等等对该标签专题图的所有风格的设置以及用来制作标签专题图的字段或表达式。这种 XML 格式字符串可以用来导入，对专题图进行设置。</p>
* @return 包含专题图信息的 XML 字符串。
*/
-(NSString *)toXML;

/**
* @brief 从 XML 字符串中导入专题图信息。
* <p>在 SuperMap 中，各种专题图的风格的设置都可以导出成 XML 格式的字符串，此 XML 格式的字符串中记录了关于这种专题图的所有设置，如对于标签专题图的 XML 格式字符串会记录专题图类型，可见比例尺，标签风格的设置，是否流动显示，是否自动避让等等对该标签专题图的所有风格的设置以及用来制作标签专题图的字段或表达式。这种 XML 格式字符串可以用来导入，对专题图进行设置。</p>
* @param xml 包含专题图信息的 XML 字符串。
* @return 一个布尔值，导入成功返回 true，否则返回 false。
*/
-(BOOL)fromXML:(NSString *)xml;

/**
* @brief 返回当前对象的一个拷贝。
* @param theme 指定的专题图对象。
*/
+(Theme *)clone:(Theme *)theme;

@end
