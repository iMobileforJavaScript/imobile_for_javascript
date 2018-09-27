//
//  Action.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/** 该类定义了地图操作状态类型常量。
*
*  完成与地图显示有关的操作设置。通常与地图显示有关的操作包括地图的漫游以及简单的编辑操作如画点、画线、画面等。
*/
typedef enum {
    /// 空操作。
    NONEACTION = 0,   
    
	/** 地图漫游。
	*
	*  在对地图进行漫游操作时，首先将显示窗口内的地图转换成位图，在操作过程中，使用位图显示，操作结束后，使用真实数据显示。这种漫游速度较快。
	*/ 
	PAN = 1,
    
	///  在编辑模式下，长按选择对象，可对选中的对象进行编辑。
	SELECT = 8,
    
    /// 在可编辑图层中编辑对象的节点。
	VERTEXEDIT = 54,
    
    /// 在可编辑图层中为对象添加节点。
    VERTEXADD = 55,
    DRAW_HOLLOW_REGION = 213,
    /// 在可编辑图层中删除对象的节点。
    DELETENODE= 56,
    
    /// 在可编辑图层中画点。
    CREATEPOINT = 16,
    
	/// 在可编辑图层中画直线。
    CREATELINE = 1002,
    
	/// 在可编辑图层中画矩形。
    CREATERECTANGLE = 1003,
    
	/// 在可编辑图层中画折线。
    CREATEPOLYLINE = 17,
	
	/// 在可编辑图层中画多边形。
    CREATEPOLYGON = 27,
	
	/// 在可编辑图层中画两点圆。
    CREATE_CIRCLE_2P = 1006,
    
	/// 在可编辑图层中画椭圆。
    CREATEELLIPSE = 1009,
    
    ///  自由线。
    CREATE_FREE_POLYLINE = 100,
    
    ///  自由绘制。
    CREATE_FREE_DRAWPOLYGON = 101,
    
    ///  自由绘制。
    CREATE_FREE_DRAW = 199,
    
    /// 量算长度。
    MEASURELENGTH = 1001,
    
	/// 量算面积。
	MEASUREAREA =  1002,
    
    /// 量算角度。
    MEASUREANGLE =  1003,
    
    //态势标绘
    CREATE_PLOT = 3000,
    
    /**
     * 擦除面对象
     */
    ERASE_REGION = 201,
    /**
     * 使用线切分
     */
    SPLIT_BY_LINE = 202,
    /**
     * 面与面合并
     */
    UNION_REGION = 203,
    /**
     * 面与面组合
     */
    COMPOSE_REGION = 204,
    
    /**
     * 切割岛洞多边形
     */
    PATCH_HOLLOW_REGION = 205,
    
    /**
     * 填充导洞对象
     */
    INTERSECT_REGION = 207,
    
    /**
     * 求交面对象
     */
    FILL_HOLLOW_REGION = 206,
    
    /**
     * 多对象补洞
     */
    PATCH_POSOTIONAL_REGION = 208,
    
    /**
     * 公共点编辑(协调编辑)
     */
    MOVE_COMMON_NODE = 209,
    
    /**
     * 公共边构面
     */
    CREATE_POSITIONAL_REGION = 210,
    
    
    /**
     * 面被线分割（手绘式）
     */
    SPLIT_BY_DRAWLINE = 215,
    
    /**
     * 手绘岛洞面（手绘式）
     */
    DRAWREGION_HOLLOW_REGION = 216,
    
    /**
     * 面被面擦除(手绘式)
     */
     DRAWREGION_ERASE_REGION = 217,
    
    /**
     * 面被面分割(手绘式)
     */
    SPLIT_BY_DRAWREGION = 218,

    /**
     * 平移对象
     */
    MOVE_GEOMETRY = 301,
    /**
     * 框选操作
     */
    SELECT_BY_RECTANGLE = 302,
    
    /**
     * 多选对象
     */
    MULTI_SELECT = 305,
    
    /**
     * 卷帘模式
     */
    SWIPE = 501,
}Action;
