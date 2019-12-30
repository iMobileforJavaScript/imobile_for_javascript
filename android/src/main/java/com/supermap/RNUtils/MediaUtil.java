package com.supermap.RNUtils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaPlayer;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * @Author: shanglongyang
 * Date:        2019/5/17
 * project:     iTablet
 * package:     iTablet
 * class:
 * description:
 */
public class MediaUtil {
    public static Bitmap getScreenShotImageFromVideoPath(Context context, String filePath) {
        String path = filePath;
        if (filePath.indexOf("content://") == 0) {
            path = DataUtil.getMediaPathFromUri(context, Uri.parse(filePath));
        }
        Bitmap bitmap = ThumbnailUtils.createVideoThumbnail(path, MediaStore.Video.Thumbnails.MICRO_KIND);

        return bitmap;
    }

    public static Bitmap getScreenShotImageFromVideoPath(String filePath, int width, int height) {
        Bitmap bitmap = ThumbnailUtils.createVideoThumbnail(filePath, MediaStore.Video.Thumbnails.MICRO_KIND);

        int newWidth = bitmap.getWidth() >= width ? width : bitmap.getWidth();
        int newheight = bitmap.getHeight() >= height ? height : bitmap.getHeight();

        return Bitmap.createBitmap(bitmap, 0, 0, newWidth, newheight);
    }

    public static Bitmap getLocalBitmap(String url) {
        try {
            FileInputStream fis = new FileInputStream(url);
            return BitmapFactory.decodeStream(fis);  ///把流转化为Bitmap图片

        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Bitmap getLocalBitmap(String url, int width, int height) {
        try {
            FileInputStream temp = new FileInputStream(url);

            BitmapFactory.Options options = new BitmapFactory.Options();
            options.inJustDecodeBounds = true;
            BitmapFactory.decodeStream(temp, null, options);
            temp.close();

            int i = 0;
            Bitmap bitmap;
            while (true) {
                // 这一步是根据要设置的大小，使宽和高都能满足
                if ((options.outWidth >> i <= width)
                        && (options.outHeight >> i <= height)) {
                    // 重新取得流，注意：这里一定要再次加载，不能二次使用之前的流！
                    temp = new FileInputStream(url);
                    // 这个参数表示 新生成的图片为原始图片的几分之一。
                    options.inSampleSize = (int) Math.pow(2.0D, i);
                    // 这里之前设置为了true，所以要改为false，否则就创建不出图片
                    options.inJustDecodeBounds = false;

                    bitmap = BitmapFactory.decodeStream(temp, null, options);
                    break;
                }
                i += 1;
            }
            return bitmap;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static WritableMap getScreenShotImage(Context context, String url) {
        WritableMap info = Arguments.createMap();

        Bitmap bitmap = getScreenShotImageFromVideoPath(context, url);

        String cachePath = context.getExternalCacheDir().getAbsolutePath();

        File fileFolder = new File(cachePath);
        if (!fileFolder.exists()) {
            fileFolder.mkdirs();
        }
        String fileName = "Screen_" + System.currentTimeMillis() + ".png";
        File file = new File(fileFolder, fileName);
        try {
            FileOutputStream fos = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
            fos.flush();
            fos.close();

//            info.putString("path", "file://" + file.getAbsolutePath());
            info.putString("path", file.getAbsolutePath());
            info.putDouble("width", bitmap.getWidth());
            info.putDouble("height", bitmap.getHeight());
            return info;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static int getVideoDuration(Context context, String url) {
        try {
            MediaPlayer mediaPlayer = new MediaPlayer();

            String path = url;
            if (url.indexOf("content://") == 0) {
                path = DataUtil.getMediaPathFromUri(context, Uri.parse(url));
            }
            mediaPlayer.setDataSource(path);
            mediaPlayer.prepare();
            int duration = mediaPlayer.getDuration();

            return duration;

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
