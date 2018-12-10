package com.supermap.RNUtils;

import android.util.Log;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
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
}
