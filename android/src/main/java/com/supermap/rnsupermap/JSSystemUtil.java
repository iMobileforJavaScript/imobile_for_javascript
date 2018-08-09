package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;

public class JSSystemUtil extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSystemUtil";

    public JSSystemUtil(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void getHomeDirectory(Promise promise) {
        try {
            String homeDirectory = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();

            WritableMap map = Arguments.createMap();
            map.putString("homeDirectory", homeDirectory);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDirectoryContent(String path, Promise promise){
        try{
            File flist = new File(path);
            String[] mFileList = flist.list();

            WritableArray arr = Arguments.createArray();
            for(String str: mFileList){
                String type = "";
                if (new File(path + "/" + str).isDirectory()) {
                    type = "directory";
                } else {
                    type = "file";
                }
                WritableMap map = Arguments.createMap();
                map.putString("name", str);
                map.putString("type", type);

                arr.pushMap(map);
            }

            promise.resolve(arr);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void fileIsExist(String path, Promise promise) {
        try {
            Boolean isExist = false;
            File file = new File(path);

            if (file.exists()) {
                isExist = true;
            }

            WritableMap map = Arguments.createMap();
            map.putBoolean("isExist", isExist);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void fileIsExistInHomeDirectory(String path, Promise promise) {
        try {
            String homeDirectory = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();

            Boolean isExist = false;
            File file = new File(homeDirectory + "/" + path);

            if (file.exists()) {
                isExist = true;
            }

            WritableMap map = Arguments.createMap();
            map.putBoolean("isExist", isExist);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 创建文件目录
     * @param path - 绝对路径
     * @param promise
     */
    @ReactMethod
    public void createDirectory(String path, Promise promise) {
        try {
            boolean result = false;
            File file = new File(path);

            if (!file.exists()) {
                result = file.mkdirs();
            } else {
                result = true;
            }

            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 创建文件目录
     * @param path - 绝对路径
     * @param promise
     */
    @ReactMethod
    public void assetsDataToSD(String fileName, Promise promise) {
        try {
            InputStream myInput;
            OutputStream myOutput = new FileOutputStream(fileName);
            myInput = getReactApplicationContext().getAssets().open("myfile.zip");
            byte[] buffer = new byte[1024];
            int length = myInput.read(buffer);
            while (length > 0) {
                myOutput.write(buffer, 0, length);
                length = myInput.read(buffer);
            }
            myOutput.flush();
            myInput.close();
            myOutput.close();
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}

