//
//  LocationManagePlugin.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_LabelBackShape_h
#define SM_iMobile_LabelBackShape_h


 /// 该类定义了标签专题图中标签背景的形状类型常量。
typedef enum {
	
	/** 空背景。
	* 
	*  不使用任何的形状做为标签的背景。此为默认值。
	*/
    LAB_NONE = 0,

	/** 矩形背景。
	* 
	* 标签背景的形状为矩形。
	*/
    LAB_RECT = 1,

	/** 圆角矩形背景。
	* 
	* 标签背景的形状为圆角矩形。
	*/
    LAB_ROUNDRECT = 2, 

	/** 椭圆形背景。
	* 
	* 标签背景的形状为椭圆形。
	*/
    LAB_ELLIPSE	= 3,

	/** 菱形背景。
	* 
	* 标签背景的形状为菱形。
	*/
    LAB_DIAMOND = 4, 

	/** 三角形背景。
	* 
	* 标签背景的形状为三角形。
	*/
    LAB_TRIANGLE = 5, 

	/** 符号背景。
	* 
	* 标签背景的形状为设定的符号，该符号可以分别通过 <ThemeLabel>  类中的 getBackStyle() 和 setBackStyle 的方法来返回和设置。
	*/
    LAB_MARKER = 100, 
}LabelBackShape;

#endif
