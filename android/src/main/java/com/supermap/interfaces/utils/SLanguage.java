package com.supermap.interfaces.utils;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.supermap.data.Toolkit;

public class SLanguage extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SLanguage";
    static private String m_language = "CN";
    public SLanguage(ReactApplicationContext context) {
        super(context);
    }
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void setLanguage(String language,Promise promise) {
        try {
            m_language  = language;
            Toolkit.setLanguage(m_language);
//            Toolkit.setLanguage(language);
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    static public String getLanguage(){
        return m_language;
    }
}
