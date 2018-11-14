/**
 * Created by Yangshanglong on 2018/7/12.
 */
package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.TextAlignment;

import java.util.HashMap;
import java.util.Map;

public class JSTextAlignment extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSTextAlignment";

    public JSTextAlignment(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();

        constants.put("TOPLEFT", 0);                     // 左上角对齐
        constants.put("TOPCENTER", 1);                   // 顶部居中对齐
        constants.put("TOPRIGHT", 2);                    // 右上角对齐
        constants.put("BASELINELEFT", 3);                // 基准线左对齐
        constants.put("BASELINECENTER", 4);              // 基准线居中对齐
        constants.put("BASELINERIGHT",5);                // 基准线右对齐
        constants.put("BOTTOMLEFT", 6);                  // 左下角对齐
        constants.put("BOTTOMCENTER", 7);                // 底部居中对齐
        constants.put("BOTTOMRIGHT", 8);                 // 右下角对齐
        constants.put("MIDDLELEFT", 9);                  // 左中对齐
        constants.put("MIDDLECENTER", 10);               // 中心对齐
        constants.put("MIDDLERIGHT", 11);                // 右中对齐
        return constants;
    }
}