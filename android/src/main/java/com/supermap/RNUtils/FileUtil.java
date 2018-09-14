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
}
