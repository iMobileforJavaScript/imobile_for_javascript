package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
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
        constants.put("NONEACTION", 0);
        constants.put("PAN", 1);
        constants.put("SELECT", 8);
        constants.put("VERTEXEDIT", 54);
        constants.put("VERTEXADD", 55);
        constants.put("DELETENODE", 56);
        constants.put("CREATEPOINT", 16);
        constants.put("CREATEPOLYLINE", 17);
        constants.put("CREATEPOLYGON", 27);
        constants.put("MEASURELENGTH", 1001);
        constants.put("MEASUREAREA", 1002);
        constants.put("MEASUREANGLE", 1003);
        constants.put("FREEDRAW", 199);
        constants.put("CREATEPLOT", 3000);
        return constants;
    }
}
