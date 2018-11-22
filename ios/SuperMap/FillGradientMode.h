//
//  SM_FillGradientMode.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/**
 *   该类定义了渐变模式类型常量。
  *  
 * <p>定义渐变填充模式的渐变模式。
 * <p>所有渐变模式都是两种颜色之间的渐变，即从渐变起始色到渐变终止色之间的渐变。</p>
 * <p>对于不同的渐变模式风格，可以在  <GeoStyle> 中对其旋转角度，渐变的起始色（前景色）和终止色（背景色），渐变填充中心点的位置（对线性渐变无效）等进行设置。默认情况下，渐变旋转角度为0，渐变填充中心点为填充区域范围的中心点。以下对各种渐变模式的说明都采用默认的渐变旋转角度和中心点，关于渐变填充旋转的详细信息，请参见 {@link GeoStyle GeoStyle}  类中的 {@link GeoStyle#getFillGradientAngle() getFillGradientAngle()} 和 setFillGradientAngle()方法; 关于渐变填充中心点的设置，请参见 {@link GeoStyle GeoStyle}类中的 {@link GeoStyle#getFillGradientOffsetRatioX() getFillGradientOffsetRatioX()} (setFillGradientOffsetRatioX() )和 {@link GeoStyle#getFillGradientOffsetRatioY() getFillGradientOffsetRatioY()}  (setFillGradientOffsetRatioY())方法。渐变风格的计算都是以填充区域的边界矩形，即最小外接矩形作为基础的，因而以下提到的填充区域范围即为填充区域的最小外接矩形。 </p>
 */
typedef enum{
   
   /**  无渐变。
    *<p>   当使用普通填充模式时，设置渐变模式为无渐变。
	*/ 
    FGM_NONE    = 0,
	
  /**
      *  线性渐变。
    *
      *<p> 从水平线段的起始点到终止点的渐变。</p>
      */
    FGM_LINEAR  = 1,
	
 /**
     * 辐射渐变。
    *
     *<p> 以填充区域范围的中心点作为渐变填充的起始点，距离中心点最远的边界点作为终止点的圆形渐变。注意在同一个圆周上颜色不发生变化，不同的圆之间颜色发生渐变。
     */
    FGM_RADIAL  = 2,
	
 /**
     * 圆锥渐变。
     *
     *<p> 从起始母线到终止母线，渐变在逆时针和顺时针两个方向发生渐变，都是从起始色渐变到终止色。注意填充区域范围中心点为圆锥的顶点，在圆锥的母线上颜色不发生变化。</p>
     */
    FGM_CONICAL = 3,
	
/**
     * 四角渐变。
    *
     *<p> 以填充区域范围的中心点作为渐变填充的起始点，以填充区域范围的最小外接矩形的较短边的中点为终止点的正方形渐变。注意在每个正方形上的颜色不发生变化, 不同的正方形之间颜色发生变化。
     */
    FGM_SQUARE  = 4
}SM_FillGradientMode;

