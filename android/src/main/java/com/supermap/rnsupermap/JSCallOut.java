package com.supermap.rnsupermap;

import android.content.Context;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Point2D;
import com.supermap.mapping.CallOut;
import com.supermap.mapping.CalloutAlignment;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class JSCallOut extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSCallOut";
    private static Map<String, CallOut> m_CallOutList = new HashMap<String, CallOut>();
    CallOut m_CallOut;
    ViewGroup m_rootView;
    ImageView m_imageView;

    public JSCallOut(ReactApplicationContext context) {
        super(context);
    }

    public static CallOut getObjFromList(String id) {
        return m_CallOutList.get(id);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public static String registerId(CallOut obj) {
        for (Map.Entry entry : m_CallOutList.entrySet()) {
            if (obj.equals(entry.getValue())) {
                return (String) entry.getKey();
            }
        }

        Calendar calendar = Calendar.getInstance();
        String id = Long.toString(calendar.getTimeInMillis());
        m_CallOutList.put(id, obj);
        return id;
    }

    @ReactMethod
    public void createObj(String mapViewId,Promise promise){
        try{
            Context context = JSMapView.getObjById(mapViewId).getContext();
            CallOut callOut = new CallOut(context);
            String callOutId = registerId(callOut);

            WritableMap map = Arguments.createMap();
            map.putString("callOutId",callOutId);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setStyle(String callOutId,Promise promise){
        try{
            CallOut callOut = m_CallOutList.get(callOutId);
            callOut.setStyle(CalloutAlignment.BOTTOM);

            promise.resolve(true);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setCustomize(String callOutId,boolean isSet,Promise promise){
        try{
            CallOut callOut = m_CallOutList.get(callOutId);
            callOut.setCustomize(isSet);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setLocation(String callOutId,String point2DId,Promise promise){
        try{
            CallOut callOut = m_CallOutList.get(callOutId);
            Point2D point2D = JSPoint2D.m_Point2DList.get(point2DId);
            callOut.setLocation(point2D.getX(),point2D.getY());

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setContentView(String callOutId,int imageViewId,Promise promise){
        try{
            m_CallOut = m_CallOutList.get(callOutId);
//            ImageView imageView = (ImageView)callOut.getRootView().findViewById(imageViewId);
//            ViewGroup viewGroup = (ViewGroup)imageView.getParent();
//            viewGroup.removeViewAt(imageViewId);

            m_rootView = (ViewGroup) m_CallOut.getRootView();
            m_imageView = (ImageView)m_rootView.findViewById(imageViewId);

            getCurrentActivity().runOnUiThread(updateThread);

            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    Runnable updateThread = new Runnable(){
        @Override
        public void run(){
            ViewGroup parent = (ViewGroup)m_imageView.getParent();
            parent.removeView(m_imageView);
            m_CallOut.setContentView(m_imageView);

        }
    };
}

