package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import java.util.Map;
import java.util.HashMap;
/**
 * Created by Yang Shanglong on 2018/6/25.
 */

public class JSColorSpaceType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSColorSpaceType";

    public JSColorSpaceType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("CMY", "CMY");
        constants.put("CMYK", "CMYK");
        constants.put("RGB", "RGB");
        constants.put("RGBA", "RGBA");
        constants.put("UNKNOW", "UNKNOW");
        constants.put("YCC", "YCC");
        constants.put("YIQ", "YIQ");
        constants.put("YUV", "YUV");
        return constants;
    }
}