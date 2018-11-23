//
//  WorkspaceType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/** 该枚举定义了工作空间类型常量。
 <p>SuperMap 支持的文件型工作空间的类型有四种，SXW 格式、 SMW 格式、SXWU 格式和 SMWU 格式。
 */
typedef enum{

   
	/// 默认值， 表示工作空间未被保存时的工作空间类型。
    SM_DEFAULT =1,
	
	/** SXW 工作空间（即 SuperMap XML Workspace)。
	 * <p>是一种 XML格式的工作空间，可用文本编辑器打开，如：记事本，EditPlus
	 * 等。用文本编辑器打开后可以比较方便的获取到该工作空间里面的信息，比如数据源、地图以及资源文件等信息
	 * ，便于利用这些信息设置其他工作空间尤其是地图中风格的设置。</p>
	 */
    SM_SXW = 4,
	
    ///SMW 工作空间，文件型工作空间。
    SM_SMW = 5,
	
	/** SXWU工作空间，只有 6R 版本的工作空间能存成类型为 SXWU 的工作空间文件。
	  * <p>存为 6R 版本的工作空间时，文件型工作空间只能存为SXWU 或是 SMWU。<p>
	 */
    SM_SXWU = 8,
	
	/** SMWU工作空间，只有 6R 版本的工作空间能存成类型为 SMWU 的工作空间文件。
	 *   <p>另存为 6R 版本的工作空间时，文件型工作空间只能存为SXWU 或是 SMWU。该常量仅在 Windows 平台版本中支持，在 Linux、AIX 以及 HPUnix 版本中均不提供。</p>
	 */
    SM_SMWU = 9
}WorkspaceType;