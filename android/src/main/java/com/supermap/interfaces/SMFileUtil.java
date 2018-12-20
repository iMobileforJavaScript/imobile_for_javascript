package com.supermap.interfaces;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.FileUtil;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.zip.ZipException;
import java.util.zip.ZipOutputStream;

public class SMFileUtil extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SMFileUtil";
//    private static final int BUFF_SIZE = 1024 * 1024; // 1M Byte
    private final static String TAG = "ZipHelper";
    private final static int BUFF_SIZE = 2048;

    private final String homeDirectory = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();

    public SMFileUtil(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void getHomeDirectory(Promise promise) {
        try {
            WritableMap map = Arguments.createMap();
            map.putString("homeDirectory", homeDirectory);
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getDirectoryContent(String path, Promise promise) {
        try {
            File flist = new File(path);
            String[] mFileList = flist.list();

            WritableArray arr = Arguments.createArray();
            for (String str : mFileList) {
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
        } catch (Exception e) {
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
     *
     * @param path    - 绝对路径
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

    @ReactMethod
    public void isDirectory(String path, Promise promise) {
        try {
            File file = new File(path);
            boolean isDirectory = file.isDirectory();
            promise.resolve(isDirectory);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getPathList(String path, Promise promise) {
        try {
            File file = new File(path);

            File[] files = file.listFiles();
            WritableArray array = Arguments.createArray();
            for (int i = 0; i < files.length; i++) {
                String p = files[i].getAbsolutePath().replace(homeDirectory, "");
                String n = files[i].getName();
                boolean isDirectory = files[i].isDirectory();
                WritableMap map = Arguments.createMap();
                map.putString("path", p);
                map.putString("name", n);
                map.putBoolean("isDirectory", isDirectory);
                array.pushMap(map);
            }
            promise.resolve(array);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void getPathListByFilter(String path, ReadableMap filter, Promise promise) {
        try {
            File file = new File(path);

            File[] files = file.listFiles();
            WritableArray array = Arguments.createArray();
            for (int i = 0; i < files.length; i++) {
                String p = files[i].getAbsolutePath().replace(homeDirectory, "");
                String n = files[i].getName();
                int lastDot = n.lastIndexOf(".");
                String name, extension = "";
                if (lastDot > 0) {
                    name = n.substring(0, lastDot).toLowerCase();
                    extension = n.substring(lastDot + 1).toLowerCase();
                } else {
                    name = n;
                }
                boolean isDirectory = files[i].isDirectory();

                String type = "Directory";
                if (filter.toHashMap().containsKey("type")) {
                    type = filter.getString("type");
                }

                if (!filter.toHashMap().containsKey("name")) {
                    String filterName = filter.getString("name").toLowerCase().trim();
                    // 判断文件名
                    if (isDirectory || filterName.equals("") || !name.contains(filterName)) {
                        continue;
                    }
                }

                boolean isExist = false;
                if (filter.toHashMap().containsKey("extension")) {
                    String filterType = filter.getString("extension").toLowerCase();
                    String[] extensions = filterType.split(",");
                    for (int j = 0; j < extensions.length; j++) {
                        String mExtension = extensions[j].trim();
                        // 判断文件类型
                        if (isDirectory && type.equals("Directory") || !isDirectory && !mExtension.equals("") && extension.contains(mExtension)) {
                            isExist = true;
                            break;
                        } else {
                            isExist = false;
                        }
                    }
                }
                if (!isExist) {
                    continue;
                }

                WritableMap map = Arguments.createMap();
                map.putString("path", p);
                map.putString("name", n);
                map.putBoolean("isDirectory", isDirectory);
                array.pushMap(map);
            }
            promise.resolve(array);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 拷贝文件到app目录下
     *
     * @param fileName
     * @param path
     * @param promise
     */
    @ReactMethod
    public void assetsDataToSD(String fileName, String path, Promise promise) {
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

    @ReactMethod
    public static void zipFile(String archive, String targetPath, Promise promise) throws IOException, FileNotFoundException, ZipException {
        try {
            ZipOutputStream zipout = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(
                    targetPath), BUFF_SIZE));
            Boolean result = true;
            File file = new File(archive);
            if (file.exists()) {
                zipFile(file, zipout, "");
            } else {
                result = false;
            }
            zipout.close();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public static void zipFiles(ReadableArray archives, String targetPath, Promise promise) throws IOException, FileNotFoundException, ZipException {
        try {
            ZipOutputStream zipout = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(
                    targetPath), BUFF_SIZE));
            Boolean result = true;
            for (int i = 0; i < archives.size(); i++) {
                File file = new File(archives.getString(i));
                if (file.exists()) {
                    zipFile(file, zipout, "");
                } else {
                    result = false;
                    break;
                }
            }
            zipout.close();
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public static void unZipFile(String archive, String decompressDir, Promise promise) throws IOException, FileNotFoundException, ZipException {
        try {
            boolean isUnZiped = false;
            BufferedInputStream bi;
            ZipFile zf = new ZipFile(archive, "GBK");
            Enumeration e = zf.getEntries();
            while (e.hasMoreElements()) {
                ZipEntry ze2 = (ZipEntry) e.nextElement();
                String entryName = ze2.getName();
                String path = decompressDir + "/" + entryName;
                if (ze2.isDirectory()) {
                    System.out.println("正在创建解压目录 - " + entryName);
                    File decompressDirFile = new File(path);
                    if (!decompressDirFile.exists()) {
                        decompressDirFile.mkdirs();
                    }
                } else {
                    System.out.println("正在创建解压文件 - " + entryName);
                    String fileDir = path.substring(0, path.lastIndexOf("/"));
                    File fileDirFile = new File(fileDir);
                    if (!fileDirFile.exists()) {
                        fileDirFile.mkdirs();
                    }
                    BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(decompressDir + "/" + entryName));
                    bi = new BufferedInputStream(zf.getInputStream(ze2));
                    byte[] readContent = new byte[1024];
                    int readCount = bi.read(readContent);
                    while (readCount != -1) {
                        bos.write(readContent, 0, readCount);
                        readCount = bi.read(readContent);
                    }
                    bos.close();
                }
            }
            zf.close();
            isUnZiped = true;
            promise.resolve(isUnZiped);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public static void doZipFiles(ReadableArray array,String toPath,Promise promise) {
        try {
            int num=array.size();
            File[] files=new File[num];
            for (int i = 0; i < num; i++) {
                files[i]=new File(array.getString(i));
            }
            zipFiles(files,toPath);
            promise.resolve(true);
        }catch (Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public static void deleteFile(String zippath, Promise promise) {
        try {
            File file = new File(zippath);
            boolean result = false;
            if (file.exists()) {
                result = file.delete();
            }
            promise.resolve(result);
        }catch (Exception e){
            promise.reject(e);
        }

    }

    //读文件
    @ReactMethod
    public static String readFile(String filePath, Promise promise){

        File file = new File(filePath);
        if(file.isFile() && file.exists()){
            try {
                FileInputStream fileInputStream = new FileInputStream(file);
                InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream, "UTF-8");
                BufferedReader bufferedReader = new BufferedReader(inputStreamReader);

                StringBuffer sb = new StringBuffer();
                String text = null;
                while((text = bufferedReader.readLine()) != null){
                    sb.append(text);
                }
                promise.resolve(sb.toString());

            } catch (Exception e) {
                // TODO: handle exception
            }
        }
        return null;
    }


    /**
     * 以FileWriter方式写入txt文件。
     *
     */
    @ReactMethod
    public static void writeToFile(String filePath,String strJson, Promise promise){
        try {

            File file = new File(filePath);
            if(file.exists()){
                FileWriter fw = new FileWriter(file,false);
                BufferedWriter bw = new BufferedWriter(fw);
                bw.write(strJson);
                bw.close();
                fw.close();
                promise.resolve(true);
//                System.out.println("test1 done!");
            }

        } catch (Exception e) {
            // TODO: handle exception
        }
    }

    private static void zipFile(File resFile, ZipOutputStream zipout, String rootpath)
            throws FileNotFoundException, IOException {
        rootpath = rootpath + (rootpath.trim().length() == 0 ? "" : File.separator)
                + resFile.getName();
        rootpath = new String(rootpath.getBytes("8859_1"), "GB2312");
        if (resFile.isDirectory()) {
            File[] fileList = resFile.listFiles();
            for (File file : fileList) {
                zipFile(file, zipout, rootpath);
            }
        } else {
            byte buffer[] = new byte[BUFF_SIZE];
            BufferedInputStream in = new BufferedInputStream(new FileInputStream(resFile),
                    BUFF_SIZE);
            zipout.putNextEntry(new java.util.zip.ZipEntry(rootpath));
            int realLength;
            while ((realLength = in.read(buffer)) != -1) {
                zipout.write(buffer, 0, realLength);
            }
            in.close();
            zipout.flush();
            zipout.closeEntry();
        }
    }


    public static boolean zipFiles(File fs[], String zipFilePath) {
        if (fs == null) {
            throw new NullPointerException("fs == null");
        }
        boolean result = false;
        org.apache.tools.zip.ZipOutputStream zos = null;
        try {
            zos = new org.apache.tools.zip.ZipOutputStream(new BufferedOutputStream(new FileOutputStream(zipFilePath)));
            for (File file : fs) {
                if (file == null || !file.exists()) {
                    continue;
                }
                if (file.isDirectory()) {
                    recursionZip(zos, file, file.getName() + File.separator);
                } else {
                    recursionZip(zos, file, "");
                }
            }
            result = true;
            zos.flush();
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "zip file failed err: " + e.getMessage());
        } finally {
            try {
                if (zos != null) {
                    zos.closeEntry();
                    zos.close();
                }
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
        return result;
    }


    private static void recursionZip(org.apache.tools.zip.ZipOutputStream zipOut, File file, String baseDir) throws Exception {
        if (file.isDirectory()) {
            Log.i(TAG, "the file is dir name -->>" + file.getName() + " the baseDir-->>>" + baseDir);
            File[] files = file.listFiles();
            for (File fileSec : files) {
                if (fileSec == null) {
                    continue;
                }
                if (fileSec.isDirectory()) {
                    baseDir = file.getName() + File.separator + fileSec.getName() + File.separator;
                    Log.i(TAG, "basDir111-->>" + baseDir);
                    recursionZip(zipOut, fileSec, baseDir);
                } else {
                    Log.i(TAG, "basDir222-->>" + baseDir);
                    recursionZip(zipOut, fileSec, baseDir);
                }
            }
        } else {
            Log.i(TAG, "the file name is -->>" + file.getName() + " the base dir -->>" + baseDir);
            byte[] buf = new byte[BUFF_SIZE];
            InputStream input = new BufferedInputStream(new FileInputStream(file));
            zipOut.putNextEntry(new ZipEntry(baseDir + file.getName()));
            int len;
            while ((len = input.read(buf)) != -1) {
                zipOut.write(buf, 0, len);
            }
            input.close();
        }
    }

}

