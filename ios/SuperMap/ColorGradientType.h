//
//  ColorGradientType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_ColorGradientType_h
#define SM_iMobile_ColorGradientType_h

/**  该类定义了颜色渐变类型常量。
* 
*  <p>颜色渐变是多种颜色间的逐渐混合，可以是从起始色到终止色两种颜色的渐变，或者在起始色到终止色之间具有多种中间颜色进行渐变。该颜色渐变类型可应用于专题图对象的颜色方案设置中。</p>
*/
typedef enum {
    
	CGT_NULL = 500,
	
	/// 黑白渐变色。
    CGT_BLACKWHITE = 0,         

	/// 红白渐变色。
    CGT_REDWHITE = 1,           

	/// 绿白渐变色。

    CGT_GREENWHITE = 2,         

	/// 蓝白渐变色。
    CGT_BLUEWHITE = 3,          

	/// 黄白渐变色。
    CGT_YELLOWWHITE = 4,        

	/// 粉红白渐变色。
    CGT_PINKWHITE = 5,          

	/// 青白渐变色。
    CGT_CYANWHITE = 6,          

	///红黑渐变色。
    CGT_REDBLACK = 7,           

	///绿黑渐变色。
    CGT_GREENBLACK = 8,         

	///蓝黑渐变色。
    CGT_BLUEBLACK = 9,          


	///黄黑渐变色。
    CGT_YELLOWBLACK = 10,       


    ///粉红黑渐变色。
    CGT_PINKBLACK = 11,         

	///青黑渐变色。
    CGT_CYANBLACK = 12,         

	///黄红渐变色。
    CGT_YELLOWRED = 13,         

	///黄绿渐变色。
    CGT_YELLOWGREEN = 14,       


	///黄蓝渐变色。
    CGT_YELLOWBLUE = 15,        


	///绿蓝渐变色。
    CGT_GREENBLUE = 16,         


	///绿黑渐变色。
    CGT_GREENRED = 17,          

	///蓝红渐变色。
    CGT_BLUERED = 18,          

	///粉红红渐变色。
    CGT_PINKRED = 19,           


	///粉红蓝渐变色。
    CGT_PINKBLUE = 20,          


	///青蓝渐变色。
    CGT_CYANBLUE = 21,          


	///青绿渐变色。
    CGT_CYANGREEN = 22,         


	/// 彩虹色。
    CGT_RAINBOW = 23,  

	/// 绿橙紫渐变色。
    CGT_GREENORANGEVIOLET = 24, 


	///地形渐变。
    CGT_TERRAIN = 25,           

	///光谱渐变。
    CGT_SPECTRUM = 26,          
}ColorGradientType;

#endif
