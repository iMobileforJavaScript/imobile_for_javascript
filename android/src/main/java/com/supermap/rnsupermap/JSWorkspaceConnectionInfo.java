package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Enum;
import com.supermap.data.WorkspaceConnectionInfo;
import com.supermap.data.WorkspaceType;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by hp on 2016/4/23.
 */
public class JSWorkspaceConnectionInfo extends ReactContextBaseJavaModule {

    private static Map<String , WorkspaceConnectionInfo> mObjLise = new HashMap<String , WorkspaceConnectionInfo>();;
    private static String mSTine;
    private WorkspaceConnectionInfo mWorkspaceConnectionInfo;

    public JSWorkspaceConnectionInfo(ReactApplicationContext reactApplicationContext) {
        super(reactApplicationContext);
    }

    public static WorkspaceConnectionInfo getObjWithId(String id){
        return mObjLise.get(id);
    }

    @Override
    public String getName()
    {
        return "JSWorkspaceConnectionInfo";
    }


    public static String registerId(WorkspaceConnectionInfo workspaceConnectionInfo){
        for(Map.Entry entry:mObjLise.entrySet()){
            if(workspaceConnectionInfo.equals(entry.getValue())){
                return (String)entry.getKey();
            }
        }
        Calendar calendar=Calendar.getInstance();
        String id=Long.toString(calendar.getTimeInMillis());
        mObjLise.put(id,workspaceConnectionInfo);
        return id;
    }

    @ReactMethod
    public static void createJSObj(Promise promise) {
        try {
            WorkspaceConnectionInfo jsWorkspaceConnectionInfo = new WorkspaceConnectionInfo();

            // 将创建对象时的时间作为键，对象作为值存起来
            Calendar cale = Calendar.getInstance();
            mSTine = Long.toString(cale.getTimeInMillis());
            mObjLise.put(mSTine,jsWorkspaceConnectionInfo);

            WritableMap map = Arguments.createMap();
            map.putString("ID", mSTine);
            promise.resolve(map);

        } catch (Exception e) {
            //e.printStackTrace();
            promise.reject("",e.getMessage());
        }
    }

    @ReactMethod
    public void getName(String id,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                String strName = mWorkspaceConnectionInfo.getName();
                WritableMap map = Arguments.createMap();
                map.putString("Name", strName);
                promise.resolve(map);
            }
        } catch (Exception e) {
            //e.printStackTrace();
            promise.reject("",e.getMessage());
        }
    }

    @ReactMethod
    public void getPassword(String id,Promise promise){
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                String strName = mWorkspaceConnectionInfo.getPassword();
                WritableMap map = Arguments.createMap();
                map.putString("Password", strName);
                promise.resolve(map);
            }
        } catch (Exception e) {
            //e.printStackTrace();
            promise.reject("",e.getMessage());
        }
    }

    @ReactMethod
    public void getServer(String id,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                String strName = mWorkspaceConnectionInfo.getServer();
                WritableMap map = Arguments.createMap();
                map.putString("Server", strName);
                promise.resolve(map);
            }
        } catch (Exception e) {
            //e.printStackTrace();
            promise.reject("",e.getMessage());
        }
    }

    @ReactMethod
    public void getUser(String id,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                String strName = mWorkspaceConnectionInfo.getUser();
                WritableMap map = Arguments.createMap();
                map.putString("User", strName);
                promise.resolve(map);
            }
        } catch (Exception e) {
            //e.printStackTrace();
            promise.reject("",e.getMessage());
        }
    }

    @ReactMethod
    public void getType(String id,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                String strType = mWorkspaceConnectionInfo.getType().toString();
                WritableMap map = Arguments.createMap();
                map.putString("Type", strType);
                promise.resolve(map);
            }
        } catch (Exception e) {
            //e.printStackTrace();
            promise.reject("",e.getMessage());
        }
    }

    @ReactMethod
    public void setName(String id,String value,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                mWorkspaceConnectionInfo.setName(value);
                promise.resolve(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void setType(String infoid,int type,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(infoid);
            mWorkspaceConnectionInfo.setType((WorkspaceType) Enum.parse(WorkspaceType.class,type));
//            if (mWorkspaceConnectionInfo != null){
//                if (value.equals("SMWU")){
//                    mWorkspaceConnectionInfo.setType(WorkspaceType.SMWU);
//                }else{
//                    mWorkspaceConnectionInfo.setType(WorkspaceType.SXWU);
//                }
//            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setPassWord(String id,String value) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                mWorkspaceConnectionInfo.setPassword(value);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void setServer(String id,String value,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                mWorkspaceConnectionInfo.setServer(android.os.Environment.getExternalStorageDirectory().getAbsolutePath()+value);
            }else{
                promise.reject("","WorkspaceConnectionInfo can`t be found.");
            }
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void setUser(String id,String value) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                mWorkspaceConnectionInfo.setUser(value);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void dispose(String id) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                mWorkspaceConnectionInfo.dispose();
                mObjLise.remove(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @ReactMethod
    public void toString(String id,Promise promise) {
        try {
            mWorkspaceConnectionInfo = mObjLise.get(id);
            if (mWorkspaceConnectionInfo != null){
                String strToString = mWorkspaceConnectionInfo.toString();
                WritableMap map = Arguments.createMap();
                map.putString("User", strToString);
                promise.resolve(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
