package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.Enum;
import com.supermap.mapping.Action;

import java.util.Map;
import java.util.HashMap;
/**
 * Created by Myself on 2017/8/15.
 */

public class JSAction extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSAction";

    public JSAction(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        String[] names = Enum.getNames(Action.class);
        for (int i = 0; i < names.length; i++) {
            int value = Enum.getValueByName(Action.class, names[i]);
            constants.put(names[i], value);
        }
//        constants.put("NONEACTION", 0);                     // 空操作
//        constants.put("PAN", 1);                            // 地图漫游
//        constants.put("SELECT", 8);                         // 在编辑模式下，长按选择对象，可对选中的对象进行编辑
//        constants.put("VERTEXEDIT", 54);                    // 在可编辑图层中编辑对象的节点
//        constants.put("VERTEXADD", 55);                     // 在可编辑图层中为对象添加节点
//        constants.put("DELETENODE", 56);                    // 在可编辑图层中删除对象的节点
//        constants.put("CREATEPOINT", 16);                   // 在可编辑图层中画点
//        constants.put("CREATEPOLYLINE", 17);                // 在可编辑图层中画折线
//        constants.put("CREATEPOLYGON", 27);                 // 在可编辑图层中画多边形
//        constants.put("MEASURELENGTH", 1001);               // 量算长度
//        constants.put("MEASUREAREA", 1002);                 // 量算面积
//        constants.put("MEASUREANGLE", 1003);                // 量算角度
//        constants.put("DRAWPLOYGON", 101);                  // 自由面
//        constants.put("FREEDRAW", 199);                     // 涂鸦
//        constants.put("CREATEPLOT", 3000);                  // 态势标绘
//        constants.put("ERASE_REGION", 201);                 // 擦除面对象
//        constants.put("SPLIT_BY_LINE", 202);                // 使用线切分
//        constants.put("UNION_REGION", 203);                 // 面与面合并
//        constants.put("COMPOSE_REGION", 204);               // 面与面组合
//        constants.put("PATCH_HOLLOW_REGION", 205);          // 切割岛洞多边形
//        constants.put("INTERSECT_REGION", 207);             // 填充导洞对象
//        constants.put("FILL_HOLLOW_REGION", 206);           // 求交面对象
//        constants.put("PATCH_POSOTIONAL_REGION", 208);      // 多对象补洞
//        constants.put("MOVE_COMMON_NODE", 209);             // 公共点编辑(协调编辑)
//        constants.put("CREATE_POSITIONAL_REGION", 210);     // 公共边构面
//        constants.put("SPLIT_BY_DRAWLINE", 215);            // 面被线分割（手绘式）
//        constants.put("DRAWREGION_HOLLOW_REGION", 216);     // 手绘岛洞面（手绘式）
//        constants.put("DRAWREGION_ERASE_REGION", 217);      // 面被面擦除(手绘式)
//        constants.put("SPLIT_BY_DRAWREGION", 218);          // 面被面分割(手绘式)
//        constants.put("MOVE_GEOMETRY", 301);                // 平移对象
//        constants.put("MULTI_SELECT", 305);                 // 多选对象
//        constants.put("SWIPE", 501);                        // 卷帘模式
        return constants;
    }
}