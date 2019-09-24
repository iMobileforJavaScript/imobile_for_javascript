package com.supermap.interfaces.iServer;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.supermap.containts.EventConst;
import com.supermap.iportalservices.DataItemType;
import com.supermap.iportalservices.IPortalService;
import com.supermap.iportalservices.MyContentType;
import com.supermap.iportalservices.OnResponseListener;
import com.supermap.iportalservices.ProgressRequestBody;
import com.supermap.iportalservices.ProgressResponseBody;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

import okhttp3.Response;
import okhttp3.ResponseBody;


public class SIPortalService extends ReactContextBaseJavaModule {
    private IPortalService mIPortalService = null;
    private ReactApplicationContext mContext = null;
    private static final String TAG = "SIPortalService";
    private static String iPortalCookie = null;

    public SIPortalService(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext;
        Log.i(TAG,"构造函数");
    }

    @Override
    public String getName() {
        return TAG;
    }

    @ReactMethod
    public void login(String portalUrl, String username, String password, boolean rememberme, final Promise promise){
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    try{
                        if (response.code() != 200) {
                            promise.resolve(false);
                            return;
                        }
                        JSONObject root;
                        String responseBody = response.body().string();
                        root = new JSONObject(responseBody);
                        boolean succeed = root.getBoolean("succeed");
                        if (succeed) {
                            List<String> cookies = response.headers("set-cookie");
                            for(int i=0; i < cookies.size(); i++){
                                if(cookies.get(i).contains("JSESSIONID=")){
                                    setIPortalCookie(cookies.get(i));
                                    break;
                                }
                            }
                            promise.resolve(true);
                        } else {
                            promise.resolve("登陆失败:请检查用户名和密码");
                        }
                    } catch (Exception e) {
                        promise.resolve(false);
                    }
                }
            });
            IPortalService.getInstance().login(portalUrl, username, password, rememberme);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    private void setIPortalCookie (String cookie) {
        iPortalCookie = cookie;
    }

    @ReactMethod
    public void getIPortalCookie (Promise promise) {
      promise.resolve(iPortalCookie);
    }

    @ReactMethod
    public void logout(final Promise promise){
        try{
            IPortalService.getInstance().logout("输入services地址");
            setIPortalCookie(null);
            promise.resolve(true);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMyAccount(final Promise promise){
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    try{
                        String responseBody = null;
                        responseBody = response.body().string();
                        promise.resolve(responseBody);
                    } catch (Exception e) {
                        promise.resolve(false);
                    }
                }
            });

            IPortalService.getInstance().getMyAccount();
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMyDatas(int currentPage, int pageSize, final Promise promise){
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    try{
                        String responseBody = null;
                        responseBody = response.body().string();
                        promise.resolve(responseBody);
                    } catch (Exception e) {
                        promise.resolve(false);
                    }
                }
            });

            HashMap<String, String> searchParameter = new HashMap<>();
            searchParameter.put("currentPage", Integer.toString(currentPage));
            searchParameter.put("pageSize", Integer.toString(pageSize));
            searchParameter.put("orderBy", "LASTMODIFIEDTIME");
            searchParameter.put("orderType", "DESC");

            IPortalService.getInstance().getMyDatas(searchParameter);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getMyServices(int currentPage, int pageSize, final Promise promise){
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    try{
                        String responseBody = null;
                        responseBody = response.body().string();
                        promise.resolve(responseBody);
                    } catch (Exception e) {
                        promise.resolve(false);
                    }
                }
            });

            HashMap<String, String> searchParameter = new HashMap<>();
            searchParameter.put("currentPage", Integer.toString(currentPage));
            searchParameter.put("pageSize", Integer.toString(pageSize));
            searchParameter.put("orderBy", "UPDATETIME");
            searchParameter.put("orderType", "DESC");

            IPortalService.getInstance().getMyServices(searchParameter);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteMyData(String id, final Promise promise){
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    if(response.isSuccessful()){
                        promise.resolve(true);
                    } else {
                        promise.resolve(false);
                    }

                }
            });

            IPortalService.getInstance().deleteMyContentItem(MyContentType.MY_DATA, Integer.parseInt(id));
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void deleteMyService(String id, final Promise promise){
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    if(response.isSuccessful()){
                        promise.resolve(true);
                    } else {
                        promise.resolve(false);
                    }

                }
            });

            IPortalService.getInstance().deleteMyContentItem(MyContentType.MY_SERVICE, Integer.parseInt(id));
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void uploadData(final String filePath, String fileName, final Promise promise) {
        upload(filePath,fileName,"用户数据",DataItemType.WORKSPACE,promise);
    }

    @ReactMethod
    public void uploadDataByType(final String filePath, String fileName,String dataType, final Promise promise){
        DataItemType type=DataItemType.WORKSPACE;
        if(dataType.equals("UDB")){
            type=DataItemType.UDB;
        }
        upload(filePath,fileName,"用户数据",type,promise);
    }

    public void upload(final String filePath, String fileName,String tags,DataItemType dataType, final Promise promise){
        try{
//            String tags = "用户数据";

            //获取ID
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    if (response.isSuccessful()) {
                        String responseBody = null;
                        try {
                            responseBody = response.body().string();

                            JSONObject root = new JSONObject(responseBody);
                            if (root.has("childID")) {
                                int childID = root.getInt("childID");
                                if (filePath != null && !filePath.isEmpty()) {
                                    //上传
                                    IPortalService.getInstance().addOnResponseListener(new OnResponseListener() {
                                        @Override
                                        public void onFailed(Exception e) {
                                            if (e != null) {
                                                promise.resolve(e.getMessage());
                                            } else {
                                                promise.resolve(false);
                                            }
                                        }

                                        @Override
                                        public void onResponse(Response response) {
                                            if (response.isSuccessful()) {
                                                promise.resolve(true);
                                                mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.IPORTAL_SERVICE_UPLOADED,true);
                                            } else {
                                                promise.resolve(false);
                                            }
                                        }
                                    });
                                    IPortalService.getInstance().uploadData(filePath, childID, new ProgressRequestBody.ProgressListener() {
                                        @Override
                                        public void transferred(long length, long size) {
                                            double value = (float)size / length * 100;
                                            mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.IPORTAL_SERVICE_UPLOADING,value);
                                        }
                                    });
                                }
                            } else {
                                promise.resolve(false);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            promise.resolve(false);
                        }
                    } else {
                        promise.resolve(false);
                    }
                }
            });

            IPortalService.getInstance().getMyDataID(fileName, tags, dataType);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void downloadMyData(final String path, String id, final Promise promise) {
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    if (response.isSuccessful()) {
                        try {
                            ResponseBody body = response.body();
                            InputStream is = body.byteStream();

                            File file = new File(path);
                            file.getParentFile().mkdirs();
                            FileOutputStream fileout = new FileOutputStream(file);
                            /**
                             * 根据实际运行效果 设置缓冲区大小
                             */
                            byte[] buffer = new byte[1024];
                            int ch = 0;
                            while ((ch = is.read(buffer)) != -1) {
                                fileout.write(buffer, 0, ch);
                            }
                            is.close();
                            fileout.flush();
                            fileout.close();
                            promise.resolve(true);
                        } catch (IOException e) {
                            promise.resolve(false);
                            e.printStackTrace();
                        }
                    } else {
                        promise.resolve(false);
                    }
                }
            });

            IPortalService.getInstance().downloadMyData(Integer.parseInt(id), new ProgressResponseBody.ProgressListener() {
                @Override
                public void update(long bytesRead, long contentLength, boolean done) {
                    double value = (float)bytesRead / contentLength * 100;
                    mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(EventConst.IPORTAL_SERVICE_DOWNLOADING,value);
                }
            });
        } catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void downloadMyDataByName(final String path, final String fileName, final Promise promise) {
        try {
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener() {
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    try {
                        String responseBody = response.body().string();
                        String id = getIdByName(responseBody, fileName);
                        downloadMyData(path, id, promise);
                    } catch (Exception e) {
                        promise.resolve(false);
                    }
                }
            });

            HashMap<String, String> searchParameter = new HashMap<>();
            searchParameter.put("currentPage", 1 + "");
            searchParameter.put("pageSize", Integer.MAX_VALUE + "");
            searchParameter.put("orderBy", "LASTMODIFIEDTIME");
            searchParameter.put("orderType", "DESC");

            IPortalService.getInstance().getMyDatas(searchParameter);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void publishService(int id, final Promise promise) {
        try{
            IPortalService.getInstance().addOnResponseListener(new OnResponseListener(){
                @Override
                public void onFailed(Exception e) {
                    promise.resolve(false);
                }

                @Override
                public void onResponse(Response response) {
                    try {
                        String responseBody = response.body().string();
                        JSONObject root = new JSONObject(responseBody);
                        boolean succeed = root.getBoolean("succeed");

                        if(succeed){
                            promise.resolve(true);
                        } else {
                            try {
                                String error = root.getString("error");
                                promise.resolve(error);
                            } catch (JSONException e){
                                promise.resolve(false);
                            }
                        }
                    } catch (Exception e) {
                        promise.resolve(e.getMessage());
                    }
                }
            });

            HashMap<String, String> parameter = new HashMap<>();
            parameter.put("serviceType", "RESTMAP,RESTDATA");
//            IPortalService.getInstance().publishServices(id, parameter);
        } catch (Exception e){
            promise.reject(e);
        }
    }

    private String getIdByName(String dataList, String name){
        String id = null;

        try {
            JSONObject datas = new JSONObject(dataList);
            JSONArray content = datas.getJSONArray("content");

            for(int i = 0; i < content.length(); ++i) {
                JSONObject data = content.getJSONObject(i);
                String dataName = data.optString("fileName", (String)null);
                if (dataName != null) {
                    String dataNameWithNoSuffix = dataName.substring(0, dataName.lastIndexOf("."));
                    if (dataNameWithNoSuffix.equals(name)) {
                        id = data.optString("id");
                        break;
                    }
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return id;
    }

}
