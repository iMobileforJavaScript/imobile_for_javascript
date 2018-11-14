/**
 * Created by Yangshanglong on 2018/7/12.
 */
package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

public class JSRangeMode extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSRangeMode";

    public JSRangeMode(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();

        constants.put("NONE", 6);                    // 空分段
        constants.put("EQUALINTERVAL", 0);           // 等距离分段
        constants.put("SQUAREROOT", 1);              // 平方根分段
        constants.put("STDDEVIATION", 2);            // 标准差分段
        constants.put("LOGARITHM", 3);               // 对数分段
        constants.put("QUANTILE", 4);                // 等计数分段
        constants.put("CUSTOMINTERVAL", 5);          // 自定义分段
        return constants;
    }
}