/**
 * 
 */
package com.supermap.data;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;
import java.io.StringReader;
import java.math.BigInteger;
import java.net.Socket;
import java.net.URI;
import java.net.UnknownHostException;
import java.security.KeyStore;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;

import javax.net.ssl.KeyManager;
import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.xml.bind.DatatypeConverter;

import org.apache.http.HttpResponse;
import org.apache.http.ProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.RedirectHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.xmlpull.v1.XmlPullParser;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.util.Xml;

import com.supermap.data.iTabletDES;



/**
 * @author Administrator
 *
 */
public class ITabletLicenseManager {
	public  static String key =  "";
	public final static String SDCARD = android.os.Environment.getExternalStorageDirectory().getAbsolutePath();
	/**
	 * 用于与服务器交户
	 */
	private HttpClient mClient = null;//new DefaultHttpClient();
	
	/**
	 * 请求
	 */
	private HttpPost mRequest = new HttpPost();
	
	// 获取归还式许可文件路径
	public static String mRecycleLicenseDirectory = "";
	private static final String mIdFileName = ".core.so"; 
	
	private static String mUUID = null;
	private static String mAppid = null;
	private  static  String mMac = null;
	private  static  String _userSerialNumber = "";

	private static final String mAppKey = "5202cac5de6a48f88dbb6dd4d7d9dbfa";
	private static final String mVersion = "10i";// sdk版本
	
	private static Context mContext;

	private static LicenseInfo mInfo;
//	private static boolean mUUIDUsable = false;
	
	private static boolean misValid= false;
	
	private static boolean mIsRecycling= false;
	
	/**
	 * 用于归还式许可激活的地址
	 */
//	private final String mUrl = "https://license.supermapol.com/api/web/v1/ilicense/mobile/";
	private final String mUrl = "https://itest.supermapol.com/api/web/v1/ilicense/mobile/";
	//activation?userSerialID=test&module=1|4";
	
	private Vector<ITabletLicenseCallback> mActivationCallbacks = new Vector<ITabletLicenseCallback>();
	private Vector<LicenseOnlineVerifyCallBack> mLicenseVerifyCallbacks = new Vector<LicenseOnlineVerifyCallBack>();
	
	// 激活、升级结果状态码
	private static final int ACTIVE_SUCCESS = 200;
	private static final int APPKEY_IS_NULL = 201;
	private static final int USER_SERIAL_IS_NULL = 202;
	private static final int MODULES_IS_NULL = 203;
	private static final int OLD_USER_SERIAL_NOT_EXIST = 204;
	private static final int OUT_OF_LIC_COUNT = 205;
	private static final int MODULES_UPDATE_FAILED = 206;
	private static final int UUID_IS_NULL = 207;
	private static final int PHONENUMBER_IS_NULL = 208;
	private static final int UUID_NOT_EXIST = 209;
	private static final int UUID_PHONENUMBER_ALL_NULL = 210;
	private static final int NEW_USER_SERIAL_NOT_EXIST = 211;
	private static final int OLD_USER_SERIAL_UUID_NOT_MATCH = 212;
	private static final int LIC_GENERATE_FAILED = 213;
	private static final int PHONENUMBER_LIMITED = 214; // 手机号限制，已经绑定了
	private static final int VERSION_IS_NULL = 215;
	private static final int VERSION_LIMITED = 216;
	private static final int USER_SERIAL_COULD_ONLY_UPGRADE = 217; // 升级的序列号，不能激活，只能升级
	private static final int PHONENUMBER_NOT_EXIST = 218; // 手机号限制，已经绑定了
	private static final int PHONENUMBER_UUID_NOT_MATCH = 219; // 手机号限制，已经绑定了
	private static final int MODULE_NOT_EXIST = 220; // 手机号限制，已经绑定了
	
	private static final int OTHER_ERRORS = 12345;
	private static final int QUERY_RESULT = 45678;
	private static final int QUERY_LICENSE_COUNT = 40002;
	
	private static final int NETWORK_ERROR = 56789;
	private static final int VERIFY_SUCCESS = 2000;
	private static final int VERIFY_APPKEY_IS_NULL = 2001;
	private static final int VERIFY_UUID_NOT_EXIST = 2009;
	private static final int VERIFY_UUID_IS_NULL = 2007;

	
	private Handler mHandler = new Handler(){
		@SuppressWarnings("unchecked")
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case ACTIVE_SUCCESS:
				//激活成功，返回激活后的许可状态
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.success();
				}
				break;
			case APPKEY_IS_NULL:
			case USER_SERIAL_IS_NULL:
			case MODULES_IS_NULL:
			case LIC_GENERATE_FAILED:
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.activateFailed((String)msg.obj);
				}
				break;
			case OUT_OF_LIC_COUNT:
				//许可数量不足
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.activateFailed((String)msg.obj);
				}
				break;
			case UUID_NOT_EXIST:
				//uuid不存在
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.recycleLicenseFailed((String)msg.obj);
				}
				break;
			case PHONENUMBER_IS_NULL:
				//手机号不存在，绑定失败
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.bindPhoneNumberFailed((String)msg.obj);
				}
				break;
			case UUID_IS_NULL:
				//uuid 为null，绑定失败
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.bindPhoneNumberFailed((String)msg.obj);
				}
				break;
			case UUID_PHONENUMBER_ALL_NULL:
				//uuid与手机号同时为空，才会归还失败
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.recycleLicenseFailed((String)msg.obj);
				}
				break;
//			case UUID_PHONENUMBER_NOT_MATCH:
//				//uuid与手机号不匹配
//				for(ITabletLicenseCallback callback:mActivationCallbacks){
//					callback.recycleLicenseFailed((String)msg.obj);
//				}
//				break;
			case NEW_USER_SERIAL_NOT_EXIST:
				//新的用户序列号不存在
//				for(ITabletLicenseCallback callback:mActivationCallbacks){
//					callback.upgradeFailed((String)msg.obj);
//				}
				break;
			case OLD_USER_SERIAL_NOT_EXIST:
			case MODULES_UPDATE_FAILED:
				//老用户序列号不存在
//				for(ITabletLicenseCallback callback:mActivationCallbacks){
//					callback.upgradeFailed((String)msg.obj);
//				}
				break;
			case OLD_USER_SERIAL_UUID_NOT_MATCH:
				//老用户序列号与uuid不匹配
//				for(ITabletLicenseCallback callback:mActivationCallbacks){
//					callback.upgradeFailed((String)msg.obj);
//				}
				break;
			case PHONENUMBER_LIMITED:
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.bindPhoneNumberFailed((String)msg.obj);
				}
				break;
			}
			case VERSION_IS_NULL:
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.otherErrors((String)msg.obj);
				}
				break;
			}
			case VERSION_LIMITED:
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.otherErrors((String)msg.obj);
				}
				break;
			}
			case USER_SERIAL_COULD_ONLY_UPGRADE:
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.activateFailed((String)msg.obj);
				}
				break;
			}
			case PHONENUMBER_NOT_EXIST: // 手机号不存在
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.recycleLicenseFailed((String)msg.obj);
				}
				break;
			}
			case PHONENUMBER_UUID_NOT_MATCH: // 手机号与uuid不匹配
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.recycleLicenseFailed((String)msg.obj);
				}
				break;
			}
			case MODULE_NOT_EXIST: // 模块不存在
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.activateFailed((String)msg.obj);
				}
				break;
			}
			case QUERY_RESULT:
			{
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.queryResult((ArrayList<Module>)msg.obj);
				}
				break;
			}
			case QUERY_LICENSE_COUNT:
			{
                for(ITabletLicenseCallback callback:mActivationCallbacks){
                    callback.queryLicenseCount((JSONArray) msg.obj);                      
                }
                break;
			}
			case VERIFY_SUCCESS:
			{
				//激活成功，返回激活后的许可状态
				for(LicenseOnlineVerifyCallBack callback:mLicenseVerifyCallbacks){
					callback.uuidExist((String)msg.obj);
				}
				break;
			}
			case VERIFY_APPKEY_IS_NULL:
			case VERIFY_UUID_NOT_EXIST:
			case VERIFY_UUID_IS_NULL:
				//uuid不存在
				for(LicenseOnlineVerifyCallBack callback:mLicenseVerifyCallbacks){
					callback.uuidNotExist((Context)msg.obj);
				}
				break;
			case NETWORK_ERROR:
				//uuid不存在
				for(LicenseOnlineVerifyCallBack callback:mLicenseVerifyCallbacks){
					callback.offline((String)msg.obj);
				}
				break;
			case OTHER_ERRORS:
				//uuid不存在
				for(ITabletLicenseCallback callback:mActivationCallbacks){
					callback.otherErrors((String)msg.obj);
				}
			default:
				break;
			}
		};
	};
	
	/**
	 * 获取许可状态
	 * @return 返回当前的许可状态
	 */
	public LicenseInfo getLicenseStatus(){
		LicenseInfo info = iTabletVerifyLicense();
		if(info != null){
			misValid = true;
		}else{
			misValid = false;
		}
		return info;
	}
	
	/**
	 * 设置在线验证回调
	 * @param callback 归还式许可激活回调
	 * @return
	 */
	public boolean setActivateCallback(ITabletLicenseCallback callback){
		if(mActivationCallbacks.contains(callback)){
			return false;
		}
		mActivationCallbacks.add(callback);
		return true;
	}
	
	/**
	 * 设置归还式许可激活回调
	 * @param callback 归还式许可激活回调
	 * @return
	 */
	boolean setLicenseVerifyCallback(LicenseOnlineVerifyCallBack callback){
		if(mLicenseVerifyCallbacks.contains(callback)){
			return false;
		}
		mLicenseVerifyCallbacks.add(callback);
		return true;
	}
	
	/**
	 * 实例
	 */
	private static ITabletLicenseManager mInstance = null;
	
	private ITabletLicenseManager(Context context){
		mContext = context;
		mAppid = mContext.getPackageName();
		mMac = Environment.getLocalMacAddress();
		key = mAppid+mMac;
		mClient = CloseableHttpClientFactory.getInstance().getDefaultHttpClient();//new DefaultHttpClient();
		mClient.getParams().setIntParameter(HttpConnectionParams.SO_TIMEOUT, 120000); //超时设置
		mClient.getParams().setIntParameter(HttpConnectionParams.CONNECTION_TIMEOUT,120000); //连接超时
		mRequest.setURI(URI.create(mUrl));

		try {
			mRecycleLicenseDirectory = SDCARD + "/.config/"+iTabletDES.getDES(mAppid,key)+"/";
		}catch (Exception e) {

			String ex =  e.toString();
			Log.e("license", ex);
			return ;
		}

	}
	
	/**
	 * 获取许可管理类的实例
	 * @return 许可管理类实例
	 */
	public static ITabletLicenseManager getInstance(Context context){
		if(mInstance == null){
			mInstance = new ITabletLicenseManager(context);
//			mAppid = get
		}
		return mInstance;
	}

	public static boolean IsLicValied(){
		LicenseInfo info = iTabletVerifyLicense();
		if(info != null){
			misValid = true;
		}else{
			misValid = false;
		}
		return misValid;
	}

	public static void setLicInfo(String userSerialNumber){
		if(userSerialNumber!=null)
			_userSerialNumber = userSerialNumber;
	}

	/**
	 * 查询可用模块
	 * @param userSerialNumber 用户序列号
	 * @return 可用模块列表
	 */
	public void query(final String userSerialNumber){
		new Thread(){
			public void run() {
				try {
					ArrayList<Module> arrModules = new ArrayList<Module>();
					
					//构建请求体
					JSONObject json = new JSONObject();
					json.put("userSerialID", userSerialNumber);//用户序列号
					json.put("version", mVersion);
					StringEntity strEntity = new StringEntity(json.toString(),"UTF-8");
					
					HttpPost postRequest = new HttpPost();
					postRequest.addHeader("Content-Type", "application/json;charset=utf-8");
					postRequest.setURI(URI.create(mUrl + "query?appKey=" + mAppKey));
					postRequest.setEntity(strEntity);
		
					HttpResponse response = mClient.execute(postRequest);
					String strRespose = EntityUtils.toString(response.getEntity());
					
					/**
					 * 正常情况返回许可信息；
					 * 200：查询成功
					 * 901：激活失败(是否需要分类，比如序列号不存在、许可数量不足、模块不正确？或者直接把这些写到描述中？)
					 */
					JSONObject jsonObj = new JSONObject(strRespose);
					int code = jsonObj.getInt("code");
					String info = "";
					if (jsonObj.has("des")) {
						info = jsonObj.getString("des");
					}
					
					if (response.getStatusLine().getStatusCode() == 200) {
						parseModules(jsonObj, arrModules);
						//
						Message msg = mHandler.obtainMessage(QUERY_RESULT);;
						
						msg.obj = arrModules;
						mHandler.sendMessage(msg);
					} else {
						analystCode(code, info);
					}
				} catch (Exception e) {
					Message msg = mHandler.obtainMessage(OTHER_ERRORS);
					msg.obj = e.toString();
					mHandler.sendMessage(msg);
					return ;
				}
			};
		}.start();
	}
	/**
     * 查询模块数量
     * @param userSerialNumber 用户序列号
     * @return 可用模块列表
     */
    public void queryLicenseCount(final String userSerialNumber){
        new Thread(){
            public void run() {
                try {
                    ArrayList<Module> arrModules = new ArrayList<Module>();
                    JSONArray resultarry=new JSONArray();
                    //构建请求体
                    JSONObject json = new JSONObject();
                    json.put("userSerialID", userSerialNumber);//用户序列号
                    json.put("version", mVersion);
                    StringEntity strEntity = new StringEntity(json.toString(),"UTF-8");

                    HttpPost postRequest = new HttpPost();
                    postRequest.addHeader("Content-Type", "application/json;charset=utf-8");
                    postRequest.setURI(URI.create(mUrl + "query?appKey=" + mAppKey));
                    postRequest.setEntity(strEntity);

                    HttpResponse response = mClient.execute(postRequest);
                    String strRespose = EntityUtils.toString(response.getEntity());
                    /**
                     * 正常情况返回许可信息；
                     * 200：查询成功
                     * 901：激活失败(是否需要分类，比如序列号不存在、许可数量不足、模块不正确？或者直接把这些写到描述中？)
                     */
                    JSONObject jsonObj = new JSONObject(strRespose);
                    int code = jsonObj.getInt("code");
                    String info = "";
                    if (jsonObj.has("des")) {
                        info = jsonObj.getString("des");
                    }
                    if (response.getStatusLine().getStatusCode() == 200) {
                        parseModulesCount(jsonObj, resultarry);
                        //
                        Message msg = mHandler.obtainMessage(QUERY_LICENSE_COUNT);;
                        msg.obj = resultarry;
                        mHandler.sendMessage(msg);
                    } else {
                        analystCode(code, info);
                    }
                } catch (Exception e) {
                    Message msg = mHandler.obtainMessage(OTHER_ERRORS);
                    msg.obj = e.toString();
                    mHandler.sendMessage(msg);
                    return ;
                }
            };
        }.start();
    }
    static  public  final ArrayList<Module>  isITabletPermission(final ArrayList<Module> modules){

		ArrayList<Module> bRes = new ArrayList<>();

		for(int i=0;i<modules.size();i++){
			Module module = modules.get(i);
			if(module.getEnumValue() >= 19001 && module.getEnumValue()<20000){
				bRes.add(module);
			}
		}

		return bRes;
	}
	/**
	 * 在线激活设备
	 * @param userSerialNumber 用户序列号
	 * @param modules 需要申请的模块列表
	 * @return
	 */
	public void activateDevice(final String userSerialNumber ,final ArrayList<Module> modules){


		if(userSerialNumber == null || userSerialNumber.equals("")){
			Message msg = mHandler.obtainMessage(USER_SERIAL_IS_NULL);
			mHandler.sendMessage(msg);
			return;
		}

		final ArrayList<Module>  modulesTmp = ITabletLicenseManager.isITabletPermission(modules);

		if(modules.size() == 0){
			misValid = false;
			Message msg = mHandler.obtainMessage(MODULES_IS_NULL);
			mHandler.sendMessage(msg);
			return;
		}
		// 激活前，优先验证本地许可是否可用，若可用，则不再重新激活新的许可
		//修改许可激活前判断方式
		LicenseInfo licenseStatus=getLicenseStatus();
		if (licenseStatus!=null && misValid){
			Message msg = mHandler.obtainMessage(ACTIVE_SUCCESS);
			msg.obj = licenseStatus;
			mHandler.sendMessage(msg);
			return;
		}


		new Thread(){
			public void run() {
				try {
//
//					readXML("<supermap_license>\n" +
//							"  <signature>2ebc9ee207f6416192db397e526e9217</signature>\n" +
//							"  <licmode>3</licmode>\n" +
//							"  <version>700</version>\n" +
//							"  <start>20200226</start>\n" +
//							"  <end>21001231</end>\n" +
//							"  <user>SuperMap</user>\n" +
//							"  <company>SuperMap</company>\n" +
//							"  <access>cloud</access>\n" +
//							"  <feature>\n" +
//							"    <id>19006</id>\n" +
//							"    <name>19006</name>\n" +
//							"    <maxlogins>1</maxlogins>\n" +
//							"    <licdata>GwMkTwToKVpYmv+AIyMs68Vtgs/3Pr8dQAvvsxasnd52PRQh01TtEwnzARv2QwFdMUO8bS6qHwuUIUGSI/H9coDPChSAcm9TeWyO7BBw4Jv57RukpDWfMTTajnfbDMnsX56FyjIYpJTr9aZ7jJMwxcCMMY5a/6vcKMsVzYsqP64=</licdata>\n" +
//							"  </feature>\n" +
//							"  <feature>\n" +
//							"    <id>19003</id>\n" +
//							"    <name>19003</name>\n" +
//							"    <maxlogins>1</maxlogins>\n" +
//							"    <licdata>QweMk4KVD/VRdLcqKtGPEar/Pmm+KHjQSyIiZZOLR1KQ4YfgVQIr4gK7BCo+7r7/80wKDJIzCxkvxGjev5VKXx5ejI05KyVuXBJIg1SOXB8j7iC5lTg253kA9CFuYgNpQ/ZQiRbxm4Uxj/P3aDPqWGJc3JZLtXEJJuTbWgrgu7w=</licdata>\n" +
//							"  </feature>\n" +
//							"  <feature>\n" +
//							"    <id>19004</id>\n" +
//							"    <name>19004</name>\n" +
//							"    <maxlogins>1</maxlogins>\n" +
//							"    <licdata>RHwACyuixw3H9og7FgpPmX1PQ7RxuC3AJ6/WygCNf/8S4GTwPC0/qtBv1mFeKrtq8suRHP7MbsY2vef6dhtQCUViyOrZS4zvUgSPkpXwnq6obPW8VaDZXnIeYssNouspBjiUsXLkKlWBF2WXo+C/GBDL0vXAF8cx3BXvA2VhrQ8=</licdata>\n" +
//							"  </feature>\n" +
//							"  <feature>\n" +
//							"    <id>19005</id>\n" +
//							"    <name>19005</name>\n" +
//							"    <maxlogins>1</maxlogins>\n" +
//							"    <licdata>FUbEP2B7g2lm14PqUpErVfSoMcH3tnwFl+cYEdq+dVsgxYzPv0NLFSMPsHY+AKtaUrFX+M5Xc6FviPE5W89mH8G0YuIcRVRayj0IJnrEFP4X6w0iM+oLjnjPe1XWI7AkkcrSJX2z6ilYn8r1Fz3+1VDYi6A5T9vJsEKaNxF5kvk=</licdata>\n" +
//							"  </feature>\n" +
//							"  <feature>\n" +
//							"    <id>19007</id>\n" +
//							"    <name>19007</name>\n" +
//							"    <maxlogins>1</maxlogins>\n" +
//							"    <licdata>AIPJhg0IKYoM7VQ1Hc95ivonEQqX/OITP/CcFnUW/8G3jl1Hg8qxEfZbg4xH546ilHz5Zk8DERIq7QeH0qW7AcxyVhiS3gcvwQkwHtyynMMlTVHdYHiIGCjSL7+ZOoEKq3Yai+HDltenx0IWZ+4A3gWGbCoitLgOROz/sQGsjWlQ</licdata>\n" +
//							"  </feature>\n" +
//							"</supermap_license>");
//
//					return;
//					mIsActivating = true;
//					构建请求体
					JSONObject json = makeRecycleLicenseRequest(userSerialNumber, modules);
					StringEntity strEntity = new StringEntity(json.toString(),"UTF-8");

					HttpPost postRequest = new HttpPost();
					postRequest.addHeader("Content-Type", "application/json;charset=utf-8");
					postRequest.setURI(URI.create(mUrl + "activation?appKey=" + mAppKey));
					postRequest.setEntity(strEntity);

					HttpResponse response = mClient.execute(postRequest);
					String strRespose = EntityUtils.toString(response.getEntity());


					/**
					 * 正常情况返回许可信息；
					 * 200：激活成功
					 */
					JSONObject jsonObj = new JSONObject(strRespose);
					int code = jsonObj.getInt("code");
					String info = "";
					if (jsonObj.has("des")) {
						info = jsonObj.getString("des");
					}

					if (code == 200) {
						saveData(jsonObj);
					} else {
						misValid = false;
						Message msg = mHandler.obtainMessage(OTHER_ERRORS);
						msg.obj = "net return error"+code;
						mHandler.sendMessage(msg);
						return;
					}
//					mIsActivating = false;
					
				} catch (Exception e) {
					misValid = false;
//					mIsActivating = false;
					Message msg = mHandler.obtainMessage(OTHER_ERRORS);
					msg.obj = e.toString();
					mHandler.sendMessage(msg);
					return;
				}
			};
		}.start();
		return;
	}
	
	/**
	 * 绑定手机号,uuid所有用户唯一，手机号也要求唯一，若已有uuid绑定该手机号，则绑定失败，若uuid不存在，则绑定失败
	 * @param uuid 需要绑定的uuid
	 * @param phoneNumber 用户手机号
	 * @return
	 */
	public void bindPhoneNumber(/*final String uuid ,*/final String phoneNumber) {
		new Thread() {
			public void run() {
				try {
					String uuid = getUUID();
					
					//构建请求体
					JSONObject json = new JSONObject();
					json.put("version", mVersion);
					json.put("UUID", uuid);//用户序列号
					json.put("phoneNumber", phoneNumber);//模块
					StringEntity strEntity = new StringEntity(json.toString(),"UTF-8");
					
					HttpPost postRequest = new HttpPost();
					postRequest.addHeader("Content-Type", "application/json;charset=utf-8");
					postRequest.setURI(URI.create(mUrl + "bindPhoneNumber?appKey=" + mAppKey));
					postRequest.setEntity(strEntity);
					HttpResponse response = mClient.execute(postRequest);
					
					String strRespose = EntityUtils.toString(response.getEntity());
					
					/**
					 * 正常情况返回许可信息；
					 * 200： 绑定成功
					 */
					JSONObject jsonObj = new JSONObject(strRespose);
					int code = jsonObj.getInt("code");
					String info = "";
					if (jsonObj.has("des")) {
						info = jsonObj.getString("des");
					}
					
					analystCode(code, info);
				} catch (Exception e) {
					Message msg = mHandler.obtainMessage(OTHER_ERRORS);
					msg.obj = e.toString();
					mHandler.sendMessage(msg);
					return ;
				}
			}
		}.start();
	}
	
	/**
	 * 判断uuid是否存在
	 * @param uuid 需判断的uuid
	 * @return 服务器连接失败，返回-1，uuid不存在，返回-2，uuid存在，返回0
	 */
	/*public*/ void isUUIDExist(final String uuid) {
		new Thread() {
			public void run() {
				try {
					JSONObject json = new JSONObject();
					json.put("version", mVersion);
					json.put("UUID", uuid);//用户序列号
					StringEntity strEntity = new StringEntity(json.toString(),"UTF-8");
					
					HttpPost postRequest = new HttpPost();
					postRequest.addHeader("Content-Type", "application/json;charset=utf-8");
				
					postRequest.setURI(URI.create(mUrl + "isUUIDExist?appKey=" + mAppKey));
					postRequest.setEntity(strEntity);
			
					HttpResponse response = mClient.execute(postRequest);
					String strRespose = EntityUtils.toString(response.getEntity());
				
					// 解析返回结果
					/**
					 * 正常情况返回许可信息；
					 * 902：UUID不存在
					 * 905：UUID存在
					 */
					JSONObject jsonObj = new JSONObject(strRespose);
					int code = jsonObj.getInt("code");
					String info = "";
					if (jsonObj.has("des")) {
						info = jsonObj.getString("des");
					}
					
					if (code == 201) {
						Message msg = mHandler.obtainMessage(VERIFY_APPKEY_IS_NULL);
						msg.obj = "uuid not exist!";
						mHandler.sendMessage(msg);
					} else if (code == 200) {
						Message msg = mHandler.obtainMessage(VERIFY_SUCCESS);
						msg.obj = uuid;
						mHandler.sendMessage(msg);
					} else if (code == 207) {
						Message msg = mHandler.obtainMessage(VERIFY_UUID_IS_NULL);
						msg.obj = mContext;
						mHandler.sendMessage(msg);
					} else if (code == 209) {
						Message msg = mHandler.obtainMessage(VERIFY_UUID_NOT_EXIST);
						msg.obj = mContext;
						mHandler.sendMessage(msg);
				    } else {
				    	Message msg = mHandler.obtainMessage(NETWORK_ERROR);
						msg.obj = uuid;
						mHandler.sendMessage(msg);
				    }
				}catch (Exception e) {
					Message msg = mHandler.obtainMessage(OTHER_ERRORS);
					msg.obj = e.toString();
					mHandler.sendMessage(msg);
				}
			}
		}.start();
	}

	/**
	 * 归还许可，通过uuid或手机号归还许可，哪个不为空用哪个，若均不为空，考虑二者的匹配性
	 * @param uuid 通过uuid归还
	 * @param phoneNumber 通过手机号归还
	 * @return
	 */
	public void recycleLicense(/*final String uuid,*/ final String phoneNumber) {
		new Thread() {
			public void run() {
				try {
					String uuid = getUUID();
					//构建请求体
					boolean paramNotNull = false;
					JSONObject json = new JSONObject();
					json.put("version", mVersion);
					
					if (phoneNumber != null && !phoneNumber.isEmpty()) {
						json.put("phoneNumber", phoneNumber);//手机号
						paramNotNull = true;
					} else if (uuid != null && !uuid.isEmpty()) {
						json.put("UUID", uuid);//UUID
						paramNotNull = true;
					}
					if (!paramNotNull) {
						String info = "Argument is null";
						Message msg = mHandler.obtainMessage(OTHER_ERRORS);
						msg.obj = info;
						mHandler.sendMessage(msg);
						Log.e("SuperMap", info);
						return;
					}
					if(mIsRecycling){
						Log.e("SuperMap", "IsRecycling");
						return;
					}
					mIsRecycling = true;
					StringEntity strEntity = new StringEntity(json.toString(),"UTF-8");
					
					HttpPost postRequest = new HttpPost();
					postRequest.addHeader("Content-Type", "application/json;charset=utf-8");
					postRequest.setURI(URI.create(mUrl + "recycleLicense?appKey=" + mAppKey));
					postRequest.setEntity(strEntity);

					HttpResponse response = mClient.execute(postRequest);
					String strRespose = EntityUtils.toString(response.getEntity());
					
					/**
					 * 正常情况返回许可信息；
					 * 900：回收成功
					 * 902：uuid不存在
					 * 903：手机号不存在
					 * 906：手机号与uuid不匹配
					 */
					JSONObject jsonObj = new JSONObject(strRespose);
					int code = jsonObj.getInt("code");
					String info = "";
					if (jsonObj.has("des")) {
						info = jsonObj.getString("des");
					}

					// 如果归还成功，清空本地uuid及license
					if (code == 200) {
						clearLocalLicense();						
					}
					analystCode(code, info);
					mIsRecycling = false;
				} catch (Exception e) {
					mIsRecycling = false;
					Message msg = mHandler.obtainMessage(OTHER_ERRORS);
					msg.obj = e.toString();
					mHandler.sendMessage(msg);
					return;
				}
			}
		}.start();
	}

	
	private JSONObject makeRecycleLicenseRequest(String userSerial, ArrayList<Module> modules) 
			throws JSONException{
		String strModules = "|"; 
		if(!modules.contains(Module.ITABLET_STANDARD) && !modules.contains(Module.ITABLET_PROFESSIONAL)&& !modules.contains(Module.ITABLET_ADVANCED)){
			throw new IllegalArgumentException("modules must contain ITABLET_STANDARD or ITABLET_PROFESSIONAL or ITABLET_ADVANCED");
		}
		for(Module m:modules){
			//模块名重复的话不加入
			if(strModules.contains("|" + String.valueOf(m.getEnumValue()) + "|")){ 
				continue;
			}
			strModules += m.getEnumValue()+"|";
		}
		strModules = strModules.substring(1,strModules.length()-1);

		//生成请求信息前先清理下
		JSONObject json = new JSONObject();
		json.put("version", mVersion);
		json.put("userSerialID", userSerial);//用户序列号
		json.put("module", strModules);//模块
		return json;
	}

	// !\brief in为服务端返回的许可内容，格式如下：UserSerialID=\nModules=567978\nVersion=900\nStartDate=20170804\nExpiredDate=21001231\nDeviceIDType=UUID\n#31584fe5f1e4432d9e3810296081777a#\n569B887CAF5C4741C96EF60A10D04D9F
//	private String makeLicCode(String in){
//		String licCode ="";// "#UserSerialID#imobile#Modules#7#Version#100#StartDate#20130129#ExpiredDate#20130429#DeviceIDType#MAC#DeviceID#3BDA3399295C49AD#LicCode#A0E9523C646787FF103E811B7EFF8005";
//		int start = -1;
//		int end = -1;
//		String key = "UserSerialID";
//		start = in.indexOf(key) + key.length()+1;
//		key = "Modules";
//		end = in.indexOf(key) -1;//串中含2个字符的换行符
//		licCode += "#UserSerialID#"+in.substring(start, end);
//
//		start = end + key.length() + 2;
//		key = "Version";
//		end = in.indexOf(key) -1;//串中含2个字符的换行符
//		licCode += "#Modules#"+in.substring(start, end);
//
//		start = end + key.length() + 2;
//		key = "StartDate";
//		end = in.indexOf(key)-1;//串中含2个字符的换行符;
//		licCode += "#Version#"+in.substring(start, end);
//
//		start = end + key.length() + 2;
//		key = "ExpiredDate";
//		end = in.indexOf(key)-1;//串中含2个字符的换行符;
//		licCode += "#StartDate#"+in.substring(start, end);
//
//		start = end + key.length() + 2;
//		key = "DeviceIDType";
//		end = in.indexOf(key)-1;//串中含2个字符的换行符;
//		licCode += "#ExpiredDate#"+in.substring(start, end);
//
//		//许可类型
//		start = end + key.length() + 2;
//		key = "#";
//		end = in.indexOf(key)-1; //32位的UUID
//		licCode += "#DeviceIDType#"+in.substring(start, end);
//
//		//硬件号
//		start = end + key.length() + 1;
//		key = "#";
//		end = start+32; //32位的UUID
//		licCode += "#DeviceID#"+in.substring(start, end);
//
//		//许可码
//		start = end + 2;
//		licCode += "#LicCode#"+in.substring(start,in.length());//32位的许可码
//
//		return licCode;
//
//	}
	
//	private String makeLicCodeWithFormat(String jsonData) {
//		String info = jsonData.replace("\n", "\r\n");
//		return info;
//	}

	
	// 创建许可文件
//	private void writeLicense(String filePath, String fileName, String info) {
//
//		//要校验一下该路径是否合法
//		File file = new File(filePath);
//
//		if(!file.exists()){
//			//不存在的话，先创建出路径,若创建不成功则是非法路径
//			if(!file.mkdirs()){
//				throw new IllegalArgumentException(filePath + " is not a correct directory");
//			}
//		}
//
//		File targetFile = new File(filePath, fileName);
//
//		if (targetFile.exists()) {
//			targetFile.delete();
//		}
//
//		try {
//			targetFile.createNewFile();
//			RandomAccessFile raf = new RandomAccessFile(targetFile, "rw");
//
//			// 将文件指针移到最后
//			raf.seek(targetFile.length());
//			// 输出文件内容
//			raf.write(info.getBytes());
//			raf.close();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}

//	// 创建许可文件
//	private void writeLicenseWithJson(String filePath, String fileName, String jsonData) {
//
//		//要校验一下该路径是否合法
//		File file = new File(filePath);
//
//		if(!file.exists()){
//			//不存在的话，先创建出路径,若创建不成功则是非法路径
//			if(!file.mkdirs()){
//				throw new IllegalArgumentException(filePath + " is not a correct directory");
//			}
//		}
//
//		File targetFile = new File(filePath, fileName);
//
//		if (targetFile.exists()) {
//			targetFile.delete();
//		}
//
//		String info = makeLicCodeWithFormat(jsonData);
//
//		try {
//			targetFile.createNewFile();
//			RandomAccessFile raf = new RandomAccessFile(targetFile, "rw");
//
//			// 将文件指针移到最后
//			raf.seek(targetFile.length());
//			// 输出文件内容
//			raf.write(info.getBytes());
//			raf.close();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}

//	private String getSerialNumber(){
//		try {
//			String lcenseSerialNumberFilePath = SDCARD+"/.config/"+ mAppid + "/" + "serialNumber.core";
//			File serialNumberFile = new File(lcenseSerialNumberFilePath);
//			if (!serialNumberFile.exists()) {
//				return "";
//			}
//			InputStream inputStream = new FileInputStream(serialNumberFile);
//			InputStreamReader reader = new InputStreamReader(inputStream);
//			BufferedReader bufferedReader = new BufferedReader(reader);
//			String serialNumber = bufferedReader.readLine();
//			inputStream.close();
//			serialNumber = iTabletDES.getDESOri(serialNumber,key);
//
//			return serialNumber;
//		} catch (Exception e) {
//			return "";
//		}
//	}
	private static LicenseInfo iTabletVerifyLicense(){
		if(_userSerialNumber==null || _userSerialNumber.equals("")){
			return null;
		}
		try {
			//read
			String licStr = mRecycleLicenseDirectory+iTabletDES.getDES(mMac+_userSerialNumber,key)+".lic";
			File licFile = new File(licStr);
			if (!licFile.exists()) {
				return null;
			}
			InputStream inputStream = new FileInputStream(licFile);
			InputStreamReader reader = new InputStreamReader(inputStream);
			BufferedReader bufferedReader = new BufferedReader(reader);
			String lic = bufferedReader.readLine();
			inputStream.close();
			lic = iTabletDES.getDESOri(lic,key);

			//cheack
			String[] resArr =  lic.split("#");

			if(resArr.length > 7){
				LicenseInfo info = new LicenseInfo();
				info.features = new ArrayList<>();
				info.signature = resArr[0];
				info.startTime = resArr[2];
				info.version = resArr[3];
				info.endTime = resArr[4];
				info.company = resArr[5];
				info.user = resArr[6];
                String mac = resArr[7];



				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");// HH:mm:ss
				//获取当前时间
				Date date = new Date(System.currentTimeMillis());
				String curTime = simpleDateFormat.format(date);

				if(Integer.parseInt(curTime) >= Integer.parseInt(info.startTime) && Integer.parseInt(curTime) <= Integer.parseInt(info.endTime)){
					if(mMac.equals(mac)) {
						String[] modules = resArr[1].split("\\|");

						for (int i = 0; i < modules.length; i++) {
							LicenseFeature fe = new LicenseFeature();
							fe.id = modules[i];
							info.features.add(fe);
						}

						return info;
					}
				}
			}
		}catch (Exception e) {

			String ex =  e.toString();
			Log.e("license", ex);
			return null;
		}

		return null;
	}
	private void iTabletSaveToFile(LicenseInfo info){
		if(_userSerialNumber==null || _userSerialNumber.equals("")){
			Log.e("license", "_userSerialNumber is null");
			return ;
		}

		String strModules = "";
		for(int i=0;i<info.features.size();i++){
			LicenseFeature feature = info.features.get(i);
			strModules += "|"+feature.id;
		}

		String strLicense = info.signature+"#"+strModules+"#"+info.startTime+"#"+info.version+"#"+info.endTime+"#"+info.company+"#"+info.user+"#"+mMac;
		try {
			String pathFile = mRecycleLicenseDirectory+iTabletDES.getDES(mMac+_userSerialNumber,key)+".lic";
			File file=new File(pathFile);
			String pathDir = file.getParent();
			File fileDir = new File(pathDir);
			if(!fileDir.exists()){

				fileDir.mkdirs();
			}
			if(file.exists()){
				file.delete();
			}

			file.createNewFile();

			FileOutputStream fos = new FileOutputStream(pathFile);
			String value = iTabletDES.getDES(strLicense,key);
			fos.write(value.getBytes());
			fos.flush();
			fos.close();
		}catch (Exception e) {

			String ex =  e.toString();
			Log.e("license", ex);
			return ;
		}




	}
	private static byte[] decrypt(byte[] encrypted) {
		BigInteger modulus = new BigInteger("97940149900808251375534752128742394515589720894419487281414832262018030644275525014643445585879780364114176383835238013142689819073723152973127922693584355350878117626063464407872142659013727087204174268107953820379456111862924759697130141776327730513730393977765958470441797160670328283419007898268490444631");
		BigInteger exponent = new BigInteger("65537");
		BigInteger encryptedInt = new BigInteger(encrypted);
		BigInteger resultInt = encryptedInt.modPow(exponent, modulus);
		return resultInt.toByteArray();
	}
	private void readXML(String xml){

		try {
			XmlPullParser parser = Xml.newPullParser();
			parser.setInput(new StringReader(xml));
			int event = parser.getEventType();
			LicenseFeature feature = null;
			while (event != XmlPullParser.END_DOCUMENT){
				String nodeName = "";
				switch (event){
					case XmlPullParser.START_TAG:
						nodeName = parser.getName();
						if(nodeName.equals("supermap_license")){
							mInfo = new LicenseInfo();
							mInfo.features = new ArrayList<>();
						}else if(nodeName.equals("feature")){
							feature = new LicenseFeature();
						}
						else if (nodeName.equals("signature")) {
							String value = parser.nextText();
							mInfo.signature = value;
						}else if(nodeName.equals("licmode")){
							String value = parser.nextText();
							mInfo.licmode = value;
						}else if(nodeName.equals("version")){
							String value = parser.nextText();
							mInfo.version = value;
						}else if(nodeName.equals("start") ){
							String value = parser.nextText();
							mInfo.startTime = value;
						}else if( nodeName.equals("end")){
							String value = parser.nextText();
							mInfo.endTime = value;
						}else if(nodeName.equals("user")){
							String value = parser.nextText();
							mInfo.user = value;
						}else if(nodeName.equals("company")){
							String value = parser.nextText();
							mInfo.company = value;
						}else if(nodeName.equals("id")){
							String value = parser.nextText();
							feature.id = value;
						}else if(nodeName.equals("name")){
							String value = parser.nextText();
							feature.name = value;
						}else if(nodeName.equals("maxlogins")){
							String value = parser.nextText();
							feature.maxlogins = value;
						}else if(nodeName.equals("licdata")){
							String value = parser.nextText();
							feature.licdata = value;
						}
						break;
					case XmlPullParser.END_TAG:
						nodeName = parser.getName();
						if (nodeName.equals("supermap_license") ) {
						//   NSLog(@"c.name=%@,c.cid=%d",self.customer.name,self.customer.cid)
						//save to local
							iTabletSaveToFile(mInfo);
							LicenseInfo info = iTabletVerifyLicense();
							if(info != null){
								misValid = true;
								Message msg = mHandler.obtainMessage(ACTIVE_SUCCESS);
								msg.obj = info;
								mHandler.sendMessage(msg);
							}else{
								misValid = false;
								Message msg = mHandler.obtainMessage(OTHER_ERRORS);
								msg.obj = "VERIFY_failed";
								mHandler.sendMessage(msg);
							}
							Toolkit.ReCheackLic();
						}else if (nodeName.equals("feature")){
						//cheack
							byte[] decryptString = DatatypeConverter.parseBase64Binary(feature.licdata);
							String decryptStr = new String(decrypt(decryptString));
							String[] res = decryptStr.split("\\|");

							Boolean bValid = false;
						if(res.length == 7){
							String idStr = res[0];
							String versionStr = res[1];
							String licmodeStr = res[2];
							String signatureStr = res[3];
							String startStr = res[4];
							String endStr = res[5];
							String maxloginsStr = res[6];

							if(idStr.equals(feature.id) &&
									versionStr.equals(mInfo.version) &&
									licmodeStr.equals(mInfo.licmode) &&
									signatureStr.equals(mInfo.signature) &&
									startStr.equals(mInfo.startTime) &&
									endStr.equals(mInfo.endTime) &&
									maxloginsStr.equals(feature.maxlogins)){
								bValid = true;
							}
						}
						if(bValid){
							mInfo.features.add(feature);
						}
						}
						break;
				}
				event = parser.next();
			}
		}catch (Exception e) {
			// TODO Auto-generated catch block
//			e.printStackTrace();
			Message msg = mHandler.obtainMessage(OTHER_ERRORS);
			msg.obj = e.toString();
			mHandler.sendMessage(msg);
			return;
		}
	}
	private void saveData(JSONObject json) throws JSONException {
		// 需解析data，对uuid及许可信息进行保存、备份操作
		if (json.has("data")) {
			String jsonData  = json.getString("data");
			readXML(jsonData);
		}
	}

	private void analystCode(int code, String info) {
		Message msg = null;
		switch (code) {
			case ACTIVE_SUCCESS:
			{
				msg = mHandler.obtainMessage(ACTIVE_SUCCESS);
				mHandler.sendMessage(msg);
				break;
			}
			case APPKEY_IS_NULL:
			{
				msg = mHandler.obtainMessage(APPKEY_IS_NULL);
				msg.obj = "app key is null";
				mHandler.sendMessage(msg);
				break;
			}
			case USER_SERIAL_IS_NULL:
			{
				msg = mHandler.obtainMessage(USER_SERIAL_IS_NULL);
				msg.obj = "user serial is null";
				mHandler.sendMessage(msg);
				break;
			}
			case MODULES_IS_NULL:
			{
				msg = mHandler.obtainMessage(MODULES_IS_NULL);
				msg.obj = "modules is null";
				mHandler.sendMessage(msg);
				break;
			}
			case  OLD_USER_SERIAL_NOT_EXIST:
			{
				msg = mHandler.obtainMessage(OLD_USER_SERIAL_NOT_EXIST);
				msg.obj = "old user serial not exist!";
				mHandler.sendMessage(msg);
				break;
			}
			case OUT_OF_LIC_COUNT:
			{
				msg = mHandler.obtainMessage(OUT_OF_LIC_COUNT);
				msg.obj = "out of license count.";
				mHandler.sendMessage(msg);
				break;
			}
			case MODULES_UPDATE_FAILED:
			{
				msg = mHandler.obtainMessage(MODULES_UPDATE_FAILED);
				msg.obj = "modules update failed.";
				mHandler.sendMessage(msg);
				break;
			}
			case UUID_IS_NULL:
			{
				msg = mHandler.obtainMessage(UUID_IS_NULL);
				msg.obj = "uuid is null.";
				mHandler.sendMessage(msg);
				break;
			}
			case PHONENUMBER_IS_NULL:
			{
				msg = mHandler.obtainMessage(PHONENUMBER_IS_NULL);
				msg.obj = "phone number is null.";
				mHandler.sendMessage(msg);
				break;
			}
			case UUID_NOT_EXIST:
			{
				msg = mHandler.obtainMessage(UUID_NOT_EXIST);
				msg.obj = "uuid not exist.";
				mHandler.sendMessage(msg);
				break;
			}
			case UUID_PHONENUMBER_ALL_NULL:
			{
				msg = mHandler.obtainMessage(UUID_PHONENUMBER_ALL_NULL);
				msg.obj = "both uuid and phonenuber are null.";
				mHandler.sendMessage(msg);
				break;
			}
			case  NEW_USER_SERIAL_NOT_EXIST:
			{
				msg = mHandler.obtainMessage(NEW_USER_SERIAL_NOT_EXIST);
				msg.obj = "new user serial is not exist.";
				mHandler.sendMessage(msg);
				break;
			}
			case OLD_USER_SERIAL_UUID_NOT_MATCH:
			{
				msg = mHandler.obtainMessage(OLD_USER_SERIAL_UUID_NOT_MATCH);
				msg.obj = "old user serial and uuid are not match.";
				mHandler.sendMessage(msg);
				Log.e("SuperMap", info);
				break;
			}
			case LIC_GENERATE_FAILED:
			{
				msg = mHandler.obtainMessage(LIC_GENERATE_FAILED);
				msg.obj = "license generate failed.";
				mHandler.sendMessage(msg);
				break;
			}
			case PHONENUMBER_LIMITED:
			{
				msg = mHandler.obtainMessage(PHONENUMBER_LIMITED);
				msg.obj = "phone number is limited.";
				mHandler.sendMessage(msg);
				break;
			}
			case OTHER_ERRORS:
			{
//				msg = mHandler.obtainMessage(OTHER_ERRORS);
//				msg.obj = "network errors.";
//				mHandler.sendMessage(msg);
//				break;
			}
			case VERSION_IS_NULL:
			{
				msg = mHandler.obtainMessage(VERSION_IS_NULL);
				msg.obj = "version is null.";
				mHandler.sendMessage(msg);
				break;
			}
			case VERSION_LIMITED:
			{
				msg = mHandler.obtainMessage(VERSION_LIMITED);
				msg.obj = "version is limited, 8C is not support.";
				mHandler.sendMessage(msg);
				break;
			}
			case USER_SERIAL_COULD_ONLY_UPGRADE:
			{
				msg = mHandler.obtainMessage(USER_SERIAL_COULD_ONLY_UPGRADE);
				msg.obj = "user serial could only be used to upgrade.";
				mHandler.sendMessage(msg);
				break;
			}
			case PHONENUMBER_NOT_EXIST: // 手机号不存在
			{
				msg = mHandler.obtainMessage(PHONENUMBER_NOT_EXIST);
				msg.obj = "phone number is not exist.";
				mHandler.sendMessage(msg);
				break;
			}
			case PHONENUMBER_UUID_NOT_MATCH: // 手机号与uuid不匹配
			{
				msg = mHandler.obtainMessage(PHONENUMBER_UUID_NOT_MATCH);
				msg.obj = "phone number and uuid are not match.";
				mHandler.sendMessage(msg);
				break;
			}
			case MODULE_NOT_EXIST: // 模块不存在
			{
				msg = mHandler.obtainMessage(MODULE_NOT_EXIST);
				msg.obj = "module is not exist.";
				mHandler.sendMessage(msg);
				break;
			}
			default:
			{
				String errorInfo = "License Error Code " + code;
				msg = mHandler.obtainMessage(OTHER_ERRORS);
				msg.obj = errorInfo;
				mHandler.sendMessage(msg);
				Log.e("SuperMap", errorInfo);
				break;
			}

		} // switch
	}
	
	/*public*/ String getUUID() {
		LicenseInfo info = iTabletVerifyLicense();
		if(info != null){
			return info.signature;
		}
		return "";
	}

	// 清空本地许可文件
	public void clearLocalLicense() {
		File insideFile  = new File(mRecycleLicenseDirectory); 
		if (insideFile.exists()) {
			File[] files = insideFile.listFiles();
			//Android23以上获取的为空，增加判断
			if(files!=null){
			for (int i = 0; i < files.length; i++) {
				files[i].delete();
			}
			}
		}

		Toolkit.ReCheackLic();
	}
	

	
	private void parseModules(JSONObject json, ArrayList<Module> arrModules) {
		try {
			// 需解析data，对获取可用模块列表
			if (json.has("data")) {
				JSONArray arrData = json.getJSONArray("data");
				for (int i = 0; i < arrData.length(); i++) {
					JSONObject obj = arrData.getJSONObject(i);
					if (obj.has("code")) {
						int module = obj.getInt("code");
						if(module>19000 && module<20000){
							arrModules.add(convertToModule(module));
						}

					}
				}
			}
		} catch(JSONException ex) {
			ex.printStackTrace();
		}
	}
	 private void parseModulesCount(JSONObject json,JSONArray resultarry) {
        try {
            // 需解析data，对获取可用模块列表
            if (json.has("data")) {
                JSONArray arrData = json.getJSONArray("data");
                for (int i = 0; i < arrData.length(); i++) {
                    JSONObject obj = arrData.getJSONObject(i);
                    if (obj.has("code")) {
						int moduleN = obj.getInt("code");
						if(moduleN>19000 && moduleN<20000){
							Module module=convertToModule(obj.getInt("code"));
							JSONObject jsonObject=new JSONObject();
							jsonObject.put("Module",getModuleName(module));
							jsonObject.put("LicenseActivedCount",obj.getInt("outNumber"));
							jsonObject.put("LicenseRemainedCount",obj.getInt("xukeNum")-obj.getInt("outNumber"));
							resultarry.put(jsonObject);
						}
                    }
                }

            }
        } catch(JSONException ex) {
            ex.printStackTrace();
        }
    }

	private String getModuleName(Module module) {
		String name = null;
		if (module != null) {
			if (module == Module.ITABLET_STANDARD) {
				name = "ITABLET_STANDARD";
			} else if (module == Module.ITABLET_PROFESSIONAL) {
				name = "ITABLET_PROFESSIONAL";
			} else if (module == Module.ITABLET_ADVANCED) {
				name = "ITABLET_ADVANCED";
			} else if (module == Module.ITABLET_ARMAP) {
				name = "ITABLET_ARMAP";
			} else if (module == Module.ITABLET_NAVIGATIONMAP) {
				name = "ITABLET_NAVIGATIONMAP";
			} else if (module == Module.ITABLET_DATAANALYSIS) {
				name = "ITABLET_DATAANALYSIS";
			} else if (module == Module.ITABLET_PLOTTING) {
				name = "ITABLET_PLOTTING";
			}
		}
		return name;
	}
	private Module convertToModule(int moduleValue) {
		Module module = null;
		switch (moduleValue) {
		case 19001:
		{
			module = Module.ITABLET_STANDARD;
			break;	
		}
		case 19002:
		{
			module = Module.ITABLET_PROFESSIONAL;
			break;	
		}
		case 19003:
		{
			module = Module.ITABLET_ADVANCED;
			break;	
		}
		case 19004:
		{
			module = Module.ITABLET_ARMAP;
			break;	
		}
		case 19005:
		{
			module = Module.ITABLET_NAVIGATIONMAP;
			break;	
		}
		case 19006:
		{
			module = Module.ITABLET_DATAANALYSIS;
			break;	
		}
		case 19007:
		{
			module = Module.ITABLET_PLOTTING;
			break;	
		}
		default:
			break;
		}		
		return module;
	}
	
	//判断是否有网络否连接
	public static boolean isNetworkConnected() {  
	    if (mContext != null) { 
	        ConnectivityManager connectivityManager = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE); 
	        if (connectivityManager == null) {
				return false;
			}
	        
	        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();  
	        if (networkInfo != null) {
	        	if (networkInfo.isAvailable() && networkInfo.isConnected()) {
					return true;
				} else {
					return false;  
				}
	        }
	    }  
	    return false;  
	}
	
	public interface ITabletLicenseCallback{
		public void success();
		
		public void activateFailed(String errorInfo);
		
		public void recycleLicenseFailed(String errorInfo);

		public void bindPhoneNumberFailed(String errorInfo);
		public void queryResult(ArrayList<Module> arrModules);
		
		public void queryLicenseCount(JSONArray LicenseCount);
		
		public void otherErrors(String errorInfo);
		
	}
	
	/*public*/ interface LicenseOnlineVerifyCallBack{
		public void uuidExist(String uuid);
		
		public void uuidNotExist(Context context);
		
		public void offline(String uuid);
	}

	/**
	 * http请求的执行类，这个类会绕过证书验证，就不需要把证书导入到jdk中
	 */
	private static class CloseableHttpClientFactory {

		private static CloseableHttpClientFactory instance = null;

		private CloseableHttpClientFactory() {
		}

		public static synchronized CloseableHttpClientFactory getInstance() {
			if (null == instance) {
				instance = new CloseableHttpClientFactory();
			}
			return instance;
		}

		public synchronized DefaultHttpClient getDefaultHttpClient() {		
			BasicHttpParams params = new BasicHttpParams();
			SchemeRegistry schReg = new SchemeRegistry();
			schReg.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
			schReg.register(new Scheme("https", SSLTrustAllSocketFactory.getSocketFactory(), 443));
			ClientConnectionManager conman = new ThreadSafeClientConnManager(params, schReg);
			DefaultHttpClient httpClient = new DefaultHttpClient(conman, params);
			
			// 防止重定向
			httpClient.setRedirectHandler(new RedirectHandler() {
				
				@Override
				public boolean isRedirectRequested(HttpResponse response,
						HttpContext context) {
					// TODO Auto-generated method stub
					return false;
				}
				
				@Override
				public URI getLocationURI(HttpResponse response, HttpContext context)
						throws ProtocolException {
					// TODO Auto-generated method stub
					return null;
				}
			});
			
			return httpClient;
		}

		static class SSLTrustAllSocketFactory extends SSLSocketFactory {
		
		    private static final String TAG = "SSLTrustAllSocketFactory";
		    private SSLContext mCtx;
		
		    public SSLTrustAllSocketFactory(KeyStore truststore)
		            throws Throwable {
		        super(truststore);
		        try {
		            mCtx = SSLContext.getInstance("TLS");
		            KeyManagerFactory kf = KeyManagerFactory.getInstance("X509");
		            String psd = "pw_online";
		            kf.init(truststore, psd.toCharArray());
		            KeyManager[] keyManager= kf.getKeyManagers();
		            
		            mCtx.init(keyManager, null, null);

		        } catch (Exception ex) {
		        }
		    }
		
		    @Override
		    public Socket createSocket(Socket socket, String host,
		                               int port, boolean autoClose)
		            throws IOException, UnknownHostException {
		        return mCtx.getSocketFactory().createSocket(socket, host, port, autoClose);
		    }
		
		    @Override
		    public Socket createSocket() throws IOException {
		        return mCtx.getSocketFactory().createSocket();
		    }
		
		    public static SSLSocketFactory getSocketFactory() {
		        try {
		            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
		            trustStore.load(null, null);
		            
		            AssetManager mgr = mContext.getAssets();
		            InputStream fis = mgr.open("ver/online.bks");
		            String psd = "pw_online";
		            trustStore.load(fis, psd.toCharArray());
		            SSLSocketFactory factory = new SSLTrustAllSocketFactory(trustStore);
		            return factory;
		        } catch (Throwable e) {
		            Log.d(TAG, e.getMessage());
		            e.printStackTrace();
		        }
		        return null;
		    }
		}
	}
}
