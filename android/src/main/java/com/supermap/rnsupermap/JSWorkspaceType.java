package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/15.
 */

public class JSWorkspaceType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSWorkspaceType";

    public JSWorkspaceType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("DEFAULT", 1);                     // 空操作
        constants.put("SXW", 4);                            // 地图漫游
        constants.put("SMW", 5);                         // 在编辑模式下，长按选择对象，可对选中的对象进行编辑
        constants.put("SXWU", 8);                    // 在可编辑图层中编辑对象的节点
        constants.put("SMWU", 9);                     // 在可编辑图层中为对象添加节
        return constants;
    }
}