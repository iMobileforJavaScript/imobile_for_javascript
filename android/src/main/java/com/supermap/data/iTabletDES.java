package com.supermap.data;

import java.security.Key;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;


public class iTabletDES {
    /**
     * 获取加密密钥Key
     * @param keyString
     * @return
     */
    public static Key getKey(String keyString) {
        byte[] keyStringByte = keyString.getBytes();
        byte[] keyByte = new byte[8];
        for(int i = 0; i<keyStringByte.length && i < keyByte.length; i++) {
            keyByte[i] = keyStringByte[i];
        }
        Key key = new SecretKeySpec(keyByte,"DES");
        return key;
    }

    /**
     * 将byte数组转换成16进制String
     * @param bytes
     * @return
     * @throws Exception
     */
    public static String byteArr2HexStr(byte[] bytes) throws Exception {
        StringBuffer sb = new StringBuffer(bytes.length*2);
        for(int i = 0; i < bytes.length; i++){
            if((bytes[i] & 0xFF) < 0x10)
                sb.append("0");
            sb.append(Integer.toHexString(bytes[i]&0xFF));
        }
        return sb.toString();
    }

    /**
     * 将16进制string转换成byte数组
     * @param str
     * @return
     * @throws Exception
     */
    public static byte[] hexStr2ByteArr(String str) throws Exception {

        byte[] bytes = str.getBytes();

        int len = bytes.length;
        byte[] arr = new byte[len/2];
        for(int i = 0; i < len; i=i+2) {
            String tmp = new String(bytes,i,2);
            arr[i/2] = (byte) Integer.parseInt(tmp,16);
        }
        return arr;
    }

    /**
     * 对字符串进行DES加密
     * @param val 原始字符串
     * @param key 加密使用的key
     * @return
     * @throws Exception
     */
    public static String getDES(String val, String key) throws Exception {
        if(val == null || key == null)
            return null;

        Cipher encryptCipher = Cipher.getInstance("DES");
        encryptCipher.init(Cipher.ENCRYPT_MODE,getKey(key));
        byte[] cipherByte = encryptCipher.doFinal(val.getBytes());

        return byteArr2HexStr(cipherByte);
    }

    /**
     * 对DES加密后的16进制字符串进行解密
     * @param val
     * @param key
     * @return
     * @throws Exception
     */
    public static String getDESOri(String val, String key) throws Exception {
        if(val == null || key == null)
            return null;

        Cipher decryptCipher = Cipher.getInstance("DES");
        decryptCipher.init(Cipher.DECRYPT_MODE,getKey(key));
        byte[] originalByte = decryptCipher.doFinal(hexStr2ByteArr(val));

        return new String(originalByte);
    }

}
