//
//  SelectionMode.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/**
 *   该枚举定义了选择对象时可采用的选择模式类型常量。
 * 
 *<p>对象是否被选中是由对象与选择区域的空间位置关系以及所采用的选择模式共同决定的。当对象与选择区域的空间位置关系一样时，选择模式不同，对象是否被选中也会不同。
 * SuperMap支持多种选择方式，如点选，圆选，框选等等，SelectionMode 支持除点选外的所有选择方式。</p>
 * 
 */
typedef enum {
    /**
     * 质心在选择范围内的就选中。
     */
    CONTAIN_INNER_POINT = 0,
    
    /**
     * 与选择范围面积相交就选中。
     */
    INTERSECT = 1,
    
    /**
     * 完全在选择范围内就选中。
     */
    CONTAIN_OBJECT = 2
}SelectionMode;
