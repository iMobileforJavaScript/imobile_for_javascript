package com.supermap.RNUtils;

import android.util.Log;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.zip.ZipException;

public class FileUtil {
    public static final String homeDirectory = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();

    public static boolean unZipFile(String archive, String decompressDir) throws IOException, FileNotFoundException, ZipException {
        Log.e("++++++++++++", "zipzipzipzipzipzipzipzipzipzipzipzip");
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
             isUnZiped=true;
             return isUnZiped;
         }
         catch (Exception e){
             return false;
         }
    }

    public static boolean fileIsExist(String path) {
        try {
            Boolean isExist = false;
            File file = new File(path);

            if (file.exists()) {
                isExist = true;
            }

            return isExist;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean fileIsExistInHomeDirectory(String path) {
        try {
            Boolean isExist = false;
            File file = new File(homeDirectory + "/" + path);

            if (file.exists()) {
                isExist = true;
            }

            return isExist;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 创建文件目录
     *
     * @param path    - 绝对路径
     */
    public static boolean createDirectory(String path) {
        try {
            boolean result = false;
            File file = new File(path);

            if (!file.exists()) {
                result = file.mkdirs();
            } else {
                result = true;
            }

            return result;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean isDirectory(String path) {
        try {
            File file = new File(path);
            boolean isDirectory = file.isDirectory();
            return isDirectory;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean deleteFile(String path) {
        try {
            File file = new File(path);
            boolean result = false;
            if (file.exists()) {
                result = file.delete();
            }
            return result;
        }catch (Exception e){
            return false;
        }

    }

    /*
     * Java文件操作 获取文件扩展名
     * */
    public static String getExtensionName(String filename) {
        if ((filename != null) && (filename.length() > 0)) {
            int dot = filename.lastIndexOf('.');
            if ((dot >-1) && (dot < (filename.length() - 1))) {
                return filename.substring(dot + 1);
            }
        }
        return filename;
    }

    /*
     * Java文件操作 获取不带扩展名的文件名
     * */
    public static String getFileNameNoEx(String filename) {
        if ((filename != null) && (filename.length() > 0)) {
            int dot = filename.lastIndexOf('.');
            if ((dot >-1) && (dot < (filename.length()))) {
                return filename.substring(0, dot);
            }
        }
        return filename;
    }

    public static  boolean copyDirFromPath(String srcPath, String desPath){
        boolean copySucc = true;

        List<String> array = contentsOfDirectoryAtPath(srcPath);
        for (int i = 0; i < array.size(); i++) {
            String fullPath = srcPath + "/" + array.get(i);
            String fullToPath = desPath + "/" + array.get(i);
            boolean isDir = false;
            File fileFullPath = new File(fullPath);
            boolean isExist = fileFullPath.exists();
            isDir = fileFullPath.isDirectory();
            if (isExist) {

                if (isDir) {
                    copyDirFromPath(fullPath, fullToPath);
                }else{
                    File fileDesPath = new File(fullToPath);
                    File dir = new File(fileDesPath.getParent());
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    if (!copyFile(fullPath, fullToPath)) {
                        copySucc = false;
                    }
                }
            }

        }
        return copySucc;
    }

    private static boolean copyFile(String oldPath, String newPath) {

        File oldfile = new File(oldPath);
        File newfile = new File(newPath);
        if (oldfile.exists()) {
            if (newfile.exists()) {
                newfile.delete();
            }
            try {
                newfile.createNewFile();
                FileInputStream input = new FileInputStream(oldPath);
                BufferedInputStream inBuff = new BufferedInputStream(input);
                FileOutputStream output = new FileOutputStream(newPath);
                BufferedOutputStream outBuff = new BufferedOutputStream(output);

                byte[] b = new byte[1024 * 5];
                int len;
                while ((len = inBuff.read(b)) != -1) {
                    outBuff.write(b, 0, len);
                }
                outBuff.flush();

                inBuff.close();
                outBuff.close();
                output.close();
                input.close();
            } catch (IOException e) {
                Log.e("error+zjs", e.toString());
            }

            return true;
        }
        return false;

    }
    private static List<String> contentsOfDirectoryAtPath(String path) {
        File file = new File(path);
        File[] files = file.listFiles();
        List<String> s = new ArrayList<>();
        if (files == null) {
            Log.e("error", "空目录");
            return s;
        }
        for (int i = 0; i < files.length; i++) {
            s.add(files[i].getName());
        }
        return s;
    }

    private boolean copyFile(File from, File des,boolean rewrite){
        //目标路径不存在的话就创建一个
        if(!des.getParentFile().exists()){
            des.getParentFile().mkdirs();
        }
        if(des.exists()){
            if(rewrite){
                des.delete();
            }else{
                return false;
            }
        }

        try{
            InputStream fis = new FileInputStream(from);
            FileOutputStream fos = new FileOutputStream(des);
            //1kb
            byte[] bytes = new byte[1024];
            int readlength = -1;
            while((readlength = fis.read(bytes))>0){
                fos.write(bytes, 0, readlength);
            }
            fos.flush();
            fos.close();
            fis.close();
        }catch(Exception e){
            return false;
        }
        return true;
    }

    private boolean copyFile(InputStream from, File des,boolean rewrite){
        //目标路径不存在的话就创建一个
        if(!des.getParentFile().exists()){
            des.getParentFile().mkdirs();
        }
        if(des.exists()){
            if(rewrite){
                des.delete();
            }else{
                return false;
            }
        }

        try{
            InputStream fis = from;
            FileOutputStream fos = new FileOutputStream(des);
            //1kb
            byte[] bytes = new byte[1024];
            int readlength = -1;
            while((readlength = fis.read(bytes))>0){
                fos.write(bytes, 0, readlength);
            }
            fos.flush();
            fos.close();
            fis.close();
        }catch(Exception e){
            return false;
        }
        return true;
    }
}
